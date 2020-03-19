{-# Language ScopedTypeVariables #-}
-- Imports -------------------------------------------------------- {{{ 
import qualified Data.Map as M
import qualified Data.Maybe as Maybe
import qualified System.IO as SysIO
import Text.Read (readMaybe)
import Data.Char (isDigit)
import qualified Data.Monoid
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad hiding ((|||))
import qualified XMonad.Util.Dmenu as Dmenu
import qualified XMonad.StackSet as W
import XMonad.Actions.CopyWindow
import XMonad.Actions.Submap
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.Gaps
import XMonad.Layout.Grid               -- for additional grid layout
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.MouseResizableTile -- for mouse control
import XMonad.Layout.NoBorders          -- for fullscreen without borders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile      -- for resizeable tall layout
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.ThreeColumns       -- for three column layout
import XMonad.Layout.ToggleLayouts
import XMonad.ManageHook
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (safeSpawn, spawnPipe, runProcessWithInput)
import XMonad.Util.SpawnOnce (spawnOnce)
import qualified XMonad.Layout.LayoutCombinators as LayoutCombinators

-- }}} 

-- Values -------------------- {{{

myModMask  = mod4Mask
myLauncher = "rofi -show run"
myTerminal = "termite"
myBrowser = "google-chrome-stable"
--yBar = "xmobar"
--myXmobarPP= xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

scratchpads :: [NamedScratchpad]
scratchpads = 
  [ NS "terminal" (myTerminal ++ " --class scratchpad_term") (className =? "scratchpad_term") 
    (customFloating $ W.RationalRect 0 0.7 1 0.3)
  , NS "ghci"   (myTerminal ++ " -e \"stack exec -- ghci\" --class scratchpad_ghci") (className =? "scratchpad_ghci") 
    (customFloating $ W.RationalRect 0 0.7 1 0.3)
  ]

-- Colors ------ {{{
fg        = "#ebdbb2"
bg        = "#282828"
gray      = "#a89984"
bg1       = "#3c3836"
bg2       = "#504945"
bg3       = "#665c54"
bg4       = "#7c6f64"

green     = "#b8bb26"
darkgreen = "#98971a"
red       = "#fb4934"
darkred   = "#cc241d"
yellow    = "#fabd2f"
blue      = "#83a598"
purple    = "#d3869b"
aqua      = "#8ec07c"
-- }}}

-- }}}

-- Layout ---------------------------------------- {{{
myLayout =  smartBorders $ withGaps $ withSpacing $ toggleLayouts Full
                      ( ResizableTall 1 (3/100) (1/2) []
                    ||| Mirror (ResizableTall 1 (3/100) (3/4) [])
                    ||| spiral (6/7) -- Grid
                    ||| ThreeColMid 1 (3/100) (1/2)
                      )
                    -- mouseResizableTile ||| Mirror mouseResizableTile
  where 
    -- add spacing between windows
    withSpacing = spacingRaw True (Border 0 0 0 0) True (Border 10 10 10 10) True

    -- add gaps that are disabled by default. 
    -- these get enabled when fullscreen-mode is toggled, 
    -- creating a small gap around the window's edges in Fullscreen.
    withGaps    = gaps' [((L, 10), False),((U, 10), False), ((D, 10), False), ((R, 10), False)]

-- }}}

-- Loghook -------------------------------------- {{{

myLogHook :: X ()
myLogHook = do
  fadeInactiveLogHook 0.95 -- opacity of unfocused windows
  --(W.StackSet _ layout _ _ ) <- gets windowset
-- }}}

-- Startuphook ----------------------------- {{{

myStartupHook = do
  setWMName "LG3D" -- Java stuff hack
  spawnOnce "picom --config ~/.config/picom.conf --no-fading-openclose"
  spawnOnce "pasystray"
  spawn "/home/leon/.config/polybar/launch.sh"

-- }}}

-- Keymap --------------------------------------- {{{

myKeys :: [(String, X ())]
myKeys = [ ("M-<Up>",     sendMessage MirrorExpand)
         , ("M-<Down>",   sendMessage MirrorShrink)
         , ("M-S-h",      sendMessage MirrorExpand)
         , ("M-S-l",      sendMessage MirrorShrink)
         , ("M-f",        toggleFullscreen)
         -- for copyWindow
         , ("M-S-c",      kill1)
         , ("M-S-C-a",    windows copyToAll) -- windows: Modify the current window list with a pure function, and refresh
         , ("M-C-c",      killAllOtherCopies)
         -- programs
         , ("M-g",        namedScratchpadAction scratchpads "terminal")
         , ("M-S-g",      namedScratchpadAction scratchpads "ghci")
         , ("M-p",        spawn myLauncher)
         , ("M-S-p",      spawn "rofi -combi-modi drun,window -show combi")
         , ("M-b",        spawn myBrowser)
         , ("M-s",        spawn "/home/leon/scripts/rofi-search.sh")

         , ("M-e",        promptExecute)
         ] ++ copyToWorkspaceMappings
  where
    copyToWorkspaceMappings :: [(String, X())]
    copyToWorkspaceMappings = [("M-C-" ++ wsp, windows $ copy wsp) | wsp <- map show [1..9]]

    toggleFullscreen :: X ()
    toggleFullscreen = do
      sendMessage ToggleLayout                  -- toggle fullscreen layout
      sendMessage ToggleStruts                  -- bar is hidden -> no need to make place for it
      sendMessage ToggleGaps                    -- show a small gap around the window
      safeSpawn "polybar-msg" ["cmd", "toggle"] -- toggle polybar visibility


    specialCommands :: [(String,  X ())]
    specialCommands =
      [ ("toggleSpacing", toggleWindowSpacingEnabled)
      , ("toggleGaps",    sendMessage ToggleGaps)
      ]

    promptExecute :: X ()
    promptExecute = do
      selection <- Dmenu.menuMapArgs "rofi" ["-dmenu", "-i"] $ M.fromList specialCommands -- -i -> case-insensitive
      Maybe.fromMaybe (return ()) selection

-- }}}

-- ManageHook -------------------------------{{{

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ resource =? "Dialog" --> doFloat ]

-- }}}

-- Main ------------------------------------ {{{

main = do
  dbus <- D.connectSession
  -- Request access to the DBus name
  D.requestName dbus (D.busName_ "org.xmonad.Log")
      [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  xmonad $ desktopConfig 
    { terminal    = myTerminal
    , modMask     = myModMask
    , borderWidth = 1
    , layoutHook  = avoidStruts $ myLayout
    , logHook     = myLogHook <+> logHook desktopConfig  <+> dynamicLogWithPP (polybarPP dbus)
    , startupHook = myStartupHook <+> startupHook desktopConfig
    , manageHook  = manageDocks <+> myManageHook <+> (namedScratchpadManageHook scratchpads) <+> manageHook defaultConfig
    , focusedBorderColor = aqua
    , normalBorderColor = "#282828"
    } `additionalKeysP` myKeys

-- xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- }}}

-- POLYBAR Kram -------------------------------------- {{{


polybarPP :: D.Client -> PP
polybarPP dbus = namedScratchpadFilterOutWorkspacePP $ def
  { ppOutput  = dbusOutput dbus
  , ppCurrent = withBG bg2
  , ppVisible = withBG bg2 
  , ppUrgent  = withFG red
  , ppLayout  = removeWord "Spacing" . withFG purple
  , ppHidden  = wrap " " " " . unwords . map wrapOpenWorkspaceCmd . words
  , ppWsSep   = ""
  , ppSep     = " | "
  , ppExtras  = []
  , ppTitle   = (shorten 40) . withFG aqua
  }
    where
      removeWord substr = unwords . filter (/= substr) . words 
      withBG col = wrap ("%{B" ++ col ++ "} ") " %{B-}"
      withFG col = wrap ("%{F" ++ col ++ "} ") " %{F-}"
      wrapOpenWorkspaceCmd wsp 
        | all isDigit wsp = wrapOnClickCmd ("xdotool key super+" ++ wsp) wsp
        | otherwise = wsp
      wrapOnClickCmd cmd = wrap ("%{A1:" ++ cmd ++ ":}") "%{A}"

-- Emit a DBus signal on log updates
dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

-- }}}


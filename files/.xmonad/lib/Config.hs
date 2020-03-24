{-# Language ScopedTypeVariables #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-unused-binds #-}
-- Imports -------------------------------------------------------- {{{
module Config (main) where

import qualified System.IO as SysIO
import qualified Data.Map as M
import Data.List (isSuffixOf, isPrefixOf)
import qualified Data.Maybe as Maybe
import Data.Char (isDigit)
import System.Exit (exitWith, ExitCode(ExitSuccess))
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
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.NoBorders          -- for fullscreen without borders
import XMonad.Layout.ResizableTile      -- for resizeable tall layout
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ThreeColumns       -- for three column layout
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ZoomRow
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce (spawnOnce)

-- }}}

-- Values -------------------- {{{

myModMask  = mod4Mask
myLauncher = "rofi -show run -theme /home/leon/scripts/rofi-scripts/launcher_grid_full_style.rasi"
myTerminal = "kitty --single-instance"
myBrowser = "google-chrome-stable"
--yBar = "xmobar"
--myXmobarPP= xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

scratchpads :: [NamedScratchpad]
scratchpads =
  [ NS "terminal" launchTerminal (className =? "scratchpad_term")      (customFloating $ W.RationalRect 0 0.7 1 0.3)
  , NS "ghci"     launchGHCI     (className =? "scratchpad_ghci")      (customFloating $ W.RationalRect 0 0.7 1 0.3)
  , NS "spotify"  "spotify"      (appName   =? "spotify")              defaultFloating
  , NS "discord"  "discord"      (appName   =? "discord")              defaultFloating
  , NS "whatsapp" launchWhatsapp (("WhatsApp" `isSuffixOf`) <$> title) defaultFloating
  , NS "slack"    "slack"        (("Slack | " `isPrefixOf`) <$> title) defaultFloating
  ]
    where 
      launchTerminal = myTerminal ++ " --class scratchpad_term"
      launchGHCI     = myTerminal ++ " -e \"stack exec -- ghci\" --class scratchpad_ghci" 
      launchWhatsapp = "gtk-launch chrome-hnpfjngllnobngcgfapefoaidbinmjnm-Default.desktop"

{-| adds the scripts-directory path to the filename of a script |-}
scriptFile :: String -> String
scriptFile script = "/home/leon/scripts/" ++ script

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
--layoutHints .
myLayout = avoidStruts . smartBorders . toggleLayouts Full  $ layouts
  where
    layouts = ((rename "tall"     $ withGaps (gap * 2) $ mouseResizableTile         {draggerType = dragger}) -- ResizableTall 1 (3/100) (1/2) []
          ||| (rename "horizon"  $ withGaps (gap * 2) $ mouseResizableTileMirrored {draggerType = dragger}) -- Mirror $ ResizableTall 1 (3/100) (3/4) []
          ||| (rename "row"      $ withGaps gap $ spacing gap zoomRow)
          ||| (rename "threeCol" $ withGaps gap $ spacing gap $ ThreeColMid 1 (3/100) (1/2))
          ||| (rename "spiral"   $ withGaps gap $ spacing gap $ spiral (9/21)))
          -- ||| (rename "spiral"  $ spiral (6/7)))
          -- Grid

    withGaps width = gaps [ (dir, width) | dir <- [L, R, D, U] ]
    rename name    = renamed [Replace name]

    gap     = 7
    dragger = FixedDragger (fromIntegral gap * 2) (fromIntegral gap * 2)

-- }}}

-- Loghook -------------------------------------- {{{

myLogHook :: X ()
myLogHook = do
  fadeInactiveLogHook 0.95 -- opacity of unfocused windows

-- }}}

-- Startuphook ----------------------------- {{{

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "picom --config ~/.config/picom.conf --no-fading-openclose"
  spawnOnce "pasystray"
  spawn "/home/leon/.config/polybar/launch.sh"
  setWMName "LG3D" -- Java stuff hack

-- }}}

-- Keymap --------------------------------------- {{{

-- Default mappings that need to be removed removedKeys :: [String]
removedKeys = ["M-S-c", "M-S-q"]

myKeys :: [(String, X ())]
myKeys = [ ("M-C-k",         sendMessage MirrorExpand >> sendMessage ShrinkSlave )
         , ("M-C-j",         sendMessage MirrorShrink >> sendMessage ExpandSlave )
         , ("M-+",           sendMessage zoomIn)
         , ("M--",           sendMessage zoomOut)
         , ("M-<Backspace>", sendMessage zoomReset)

         , ("M-f",           toggleFullscreen)
         , ("M-S-C-c",       kill1)
         , ("M-S-C-a",       windows copyToAll) -- windows: Modify the current window list with a pure function, and refresh
         , ("M-C-c",         killAllOtherCopies)
         , ("M-S-C-q",       io $ exitWith ExitSuccess)

         -- programs
         , ("M-p",           spawn myLauncher)
         , ("M-S-p",         spawn "rofi -combi-modi drun,window,ssh -show combi -theme /home/leon/scripts/rofi-scripts/launcher_grid_full_style.rasi")
         , ("M-S-e",         spawn "rofi -show emoji -modi emoji -theme /home/leon/scripts/rofi-scripts/launcher_grid_full_style.rasi")
         , ("M-b",           spawn myBrowser)
         , ("M-s",           spawn $ scriptFile "rofi-search.sh")
         , ("M-S-s",         spawn $ "cat " ++ scriptFile "bookmarks" ++ " | rofi -p open -dmenu | bash")
         , ("M-n",           scratchpadSubmap)
         , ("M-m",           mediaSubmap)
         , ("M-e",           promptExecute specialCommands)

         ] ++ copyToWorkspaceMappings
  where
    copyToWorkspaceMappings :: [(String, X())]
    copyToWorkspaceMappings = [("M-C-" ++ wsp, windows $ copy wsp) | wsp <- map show [1..9]]

    toggleFullscreen :: X ()
    toggleFullscreen = do
      sendMessage ToggleLayout                  -- toggle fullscreen layout
      sendMessage ToggleStruts                  -- bar is hidden -> no need to make place for it
      --sendMessage ToggleGaps                    -- show a small gap around the window
      safeSpawn "polybar-msg" ["cmd", "toggle"] -- toggle polybar visibility

    scratchpadSubmap :: X ()
    scratchpadSubmap = describedSubmap "Scratchpads"
      [ ((myModMask, xK_n), "<M-n> terminal", namedScratchpadAction scratchpads "terminal")
      , ((myModMask, xK_h), "<M-h> ghci",     namedScratchpadAction scratchpads "ghci")
      , ((myModMask, xK_w), "<M-w> whatsapp", namedScratchpadAction scratchpads "whatsapp")
      , ((myModMask, xK_s), "<M-s> slack",    namedScratchpadAction scratchpads "slack")
      , ((myModMask, xK_m), "<M-m> spotify",  namedScratchpadAction scratchpads "spotify")
      , ((myModMask, xK_d), "<M-m> discord",  namedScratchpadAction scratchpads "discord")
      ]

    mediaSubmap :: X ()
    mediaSubmap = describedSubmap "Media"
      [ ((myModMask, xK_m), "<M-m> play/pause", spawn "playerctl play-pause")
      , ((myModMask, xK_l), "<M-l> next",       spawn "playerctl next")
      , ((myModMask, xK_l), "<M-h> previous",   spawn "playerctl previous")
      ]


    specialCommands :: [(String,  X ())]
    specialCommands =
      [ ("toggleSpacing", toggleWindowSpacingEnabled)
      , ("toggleGaps",    sendMessage ToggleGaps)
      , ("screenshot",    spawn $ scriptFile "screenshot.sh")
      ]

    describedSubmap :: String -> [((KeyMask, KeySym), String, X ())] -> X ()
    describedSubmap title mappings = showDzen hintText mySubMap
      where
        mySubMap     = submap $ M.fromList $ map (\(k, _, f) -> (k, f)) mappings
        descriptions = map (\(_,x,_) -> x) mappings
        hintText     = unlines (title : descriptions)
        showDzen message action = do
          let lineCount = show $ length $ lines message
              font      = "-*-iosevka-medium-r-s*--16-87-*-*-*-*-iso10???-1"
          handle <- spawnPipe $ "sleep 1 && dzen2 -e onstart=uncollapse -l " ++ lineCount ++ " -fn '" ++ font ++ "'"
          io $ SysIO.hPutStrLn handle message
          _ <- action
          io $ SysIO.hClose handle

    promptExecute :: [(String, X ())] -> X ()
    promptExecute commands = do
      selection <- Dmenu.menuMapArgs "rofi" ["-dmenu", "-i"] $ M.fromList commands -- -i -> case-insensitive
      Maybe.fromMaybe (return ()) selection

-- }}}

-- ManageHook -------------------------------{{{

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ resource =? "Dialog" --> doFloat
  -- , isFullscreen --> doF W.focusDown <+> doFullFloat
  , manageDocks
  , namedScratchpadManageHook scratchpads
  ]

-- }}}

-- Main ------------------------------------ {{{
main :: IO ()
main = do
  dbus <- D.connectSession
  -- Request access to the DBus name
  _ <- D.requestName dbus (D.busName_ "org.xmonad.Log")
      [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

-- $ ewmh  (kills IntelliJ)
  xmonad $ ewmh $ desktopConfig
    { terminal           = myTerminal
    , modMask            = myModMask
    , borderWidth        = 1
    , layoutHook         = myLayout
    , logHook            = myLogHook <+> dynamicLogWithPP (polybarPP dbus) <+> logHook def
    , startupHook        = myStartupHook <+> startupHook def
    , manageHook         = myManageHook <+> manageHook def
    --, handleEventHook    = fullscreenEventHook
    , focusedBorderColor = aqua
    , normalBorderColor  = "#282828"
    } `removeKeysP` removedKeys `additionalKeysP` myKeys

-- }}}

-- POLYBAR Kram -------------------------------------- {{{


polybarPP :: D.Client -> PP
polybarPP dbus = namedScratchpadFilterOutWorkspacePP $ def
  { ppOutput  = dbusOutput dbus
  , ppCurrent = withBG bg2
  , ppVisible = withBG bg2
  , ppUrgent  = withFG red
  , ppLayout  = removeWord "Hinted" . removeWord "Spacing" . withFG purple
  , ppHidden  = wrap " " " " . unwords . map wrapOpenWorkspaceCmd . words
  , ppWsSep   = ""
  , ppSep     = " | "
  , ppExtras  = []
  , ppTitle   = withFG aqua . (shorten 40)
  }
    where
      removeWord substr = unwords . filter (/= substr) . words
      withBG col = wrap ("%{B" ++ col ++ "} ") " %{B-}"
      withFG col = wrap ("%{F" ++ col ++ "} ") " %{F-}"
      wrapOpenWorkspaceCmd wsp
        | all isDigit wsp = wrapOnClickCmd ("xdotool key super+" ++ wsp) wsp
        | otherwise = wsp
      wrapOnClickCmd command = wrap ("%{A1:" ++ command ++ ":}") "%{A}"

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


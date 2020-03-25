{-# Language ScopedTypeVariables, LambdaCase #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-unused-binds #-}
-- Imports -------------------------------------------------------- {{{
module Config (main) where
import qualified Rofi as Rofi

import Data.List (isSuffixOf, isPrefixOf)
import Data.Char (isDigit)
import System.Exit (exitSuccess)

import qualified System.IO as SysIO
import qualified Data.Map as M
import qualified Data.Monoid
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad hiding ((|||))
import qualified XMonad.StackSet as W
import XMonad.Actions.CopyWindow
import XMonad.Actions.Submap
import XMonad.Config.Desktop
import XMonad.Layout.BinarySpacePartition
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
import XMonad.Layout.Spacing (spacingRaw, Border(..), toggleWindowSpacingEnabled)
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ZoomRow
import XMonad.Layout.BorderResize
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP, checkKeymap)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce (spawnOnce)
import qualified XMonad.Actions.Navigation2D as Nav2d
-- Minimize stuff
import XMonad.Layout.Minimize
import qualified XMonad.Layout.BoringWindows as BoringWindows
import XMonad.Actions.Minimize
import XMonad.Actions.WindowBringer
import XMonad.Actions.Commands
-- }}}

-- Values -------------------- {{{

myModMask  = mod4Mask
myLauncher = Rofi.asCommand def ["-show run"] -- "rofi -show run -theme /home/leon/scripts/rofi-scripts/launcher_grid_full_style.rasi"
myTerminal = "kitty --single-instance"
myBrowser = "google-chrome-stable"
--yBar = "xmobar"
--myXmobarPP= xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

{-| adds the scripts-directory path to the filename of a script |-}
scriptFile :: String -> String
scriptFile script = "/home/leon/scripts/" ++ script

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
myLayout = BoringWindows.boringWindows . minimize . avoidStruts .  smartBorders . toggleLayouts Full  $ layouts
  where
    layouts =((rename "Tall"     $ onlyGaps       $ mouseResizableTile         {draggerType = dragger}) -- ResizableTall 1 (3/100) (1/2) []
          ||| (rename "Horizon"  $ onlyGaps       $ mouseResizableTileMirrored {draggerType = dragger}) -- Mirror                           $ ResizableTall 1 (3/100) (3/4) []
          ||| (rename "Row"      $ spacingAndGaps $ zoomRow)
          ||| (rename "Bsp"      $ spacingAndGaps $ borderResize $ emptyBSP))
          -- ||| (rename "threeCol" $ spacingAndGaps $ ThreeColMid 1 (3/100) (1/2))
          -- ||| (rename "spiral"   $ spacingAndGaps $ spiral (9/21))
          -- ||| (rename "spiral" $ spiral (6/7)))
          -- Grid

    rename n = renamed [Replace n]

    gap            = 7
    onlyGaps       = gaps [ (dir, (gap*2)) | dir <- [L, R, D, U] ]  -- gaps are included in mouseResizableTile
    dragger        = let x = fromIntegral gap * 2 
                     in FixedDragger x x
    spacingAndGaps = let intGap        = fromIntegral gap
                         spacingBorder = Border intGap intGap intGap intGap 
                     in onlyGaps . spacingRaw True spacingBorder False spacingBorder True
        

-- }}}

-- Loghook -------------------------------------- {{{

myLogHook :: X ()
myLogHook = fadeInactiveLogHook 0.95 -- opacity of unfocused windows

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
myKeys = [ ("M-C-k",    sendMessage MirrorExpand >> sendMessage ShrinkSlave )
         , ("M-C-j",    sendMessage MirrorShrink >> sendMessage ExpandSlave )
         , ("M-+",      sendMessage zoomIn)
         , ("M--",      sendMessage zoomOut)
         , ("M-#",      sendMessage zoomReset)

         , ("M-f",      toggleFullscreen)
         , ("M-S-C-c",  kill1)
         , ("M-S-C-a",  windows copyToAll) -- windows: Modify the current window list with a pure function, and refresh
         , ("M-C-c",    killAllOtherCopies)
         , ("M-S-C-q",  io $ exitSuccess)

         -- programs
         , ("M-p",      spawn myLauncher)
         , ("M-b",      spawn myBrowser)
         , ("M-S-p",    Rofi.showCombi def [ "drun", "window", "ssh" ])
         , ("M-S-e",    Rofi.showNormal def "emoji" )
         , ("M-s",      spawn $ scriptFile "rofi-search.sh")
         , ("M-S-s",    spawn $ "cat " ++ scriptFile "bookmarks" ++ " | " ++ Rofi.asCommand def ["-dmenu", "-p open"] ++ " | bash")
         , ("M-n",      scratchpadSubmap )
         , ("M-m",      mediaSubmap )
         , ("M-e",      Rofi.promptRunCommand def specialCommands)
         , ("M-C-e",    Rofi.promptRunCommand def =<< defaultCommands )

         -- BSP
         , ("M-M1-h",           sendMessage $ ExpandTowards L)
         , ("M-M1-l",           sendMessage $ ExpandTowards R)
         , ("M-M1-k",           sendMessage $ ExpandTowards U)
         , ("M-M1-j",           sendMessage $ ExpandTowards D)
         , ("M-<Backspace>",    sendMessage $ Swap)
         , ("M-M1-<Backspace>", sendMessage $ Rotate)
         , ("M-S-M1-h",         Nav2d.windowGo L False)
         , ("M-S-M1-l",         Nav2d.windowGo R False)
         , ("M-S-M1-k",         Nav2d.windowGo U False)
         , ("M-S-M1-j",         Nav2d.windowGo D False)

         -- Minimization
         , ("M-k",       BoringWindows.focusUp)
         , ("M-j",       BoringWindows.focusDown)
         , ("M-ü",       withFocused minimizeWindow)
         , ("M-S-ü",     withLastMinimized maximizeWindow)
         , ("M-C-ü",     promptRestoreWindow)
         , ("M1-<Tab>", cycleMinimizedWindow)
         ] ++ concat generatedMappings
  where
    generatedMappings :: [[(String, X ())]]
    generatedMappings = 
      [ [("M-C-" ++ wsp, windows $ copy wsp) | wsp <- map show [1..9]] -- Copy to workspace
      ]
        --where hjklDirPairs = [("h", L), ("j", D), ("k", U), ("l", R) ]

    cycleMinimizedWindow :: X ()
    cycleMinimizedWindow = withLastMinimized $ \window -> do 
        withFocused minimizeWindow
        maximizeWindowAndFocus window

    promptRestoreWindow = do
      wm <- windowMap
      shownWindows <- withMinimized (\minimizedWindows -> pure $ M.filter (`elem` minimizedWindows) wm)
      win <- Rofi.promptSimple def (M.keys shownWindows)
      whenJust (M.lookup win wm) (\w -> maximizeWindow w >> (windows $ bringWindow w))

    toggleFullscreen :: X ()
    toggleFullscreen = do
      sendMessage ToggleLayout                  -- toggle fullscreen layout
      sendMessage ToggleStruts                  -- bar is hidden -> no need to make place for it
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
      [ ((myModMask, xK_m), "<M-m> play/pause",      spawn "playerctl play-pause")
      , ((myModMask, xK_l), "<M-l> next",            spawn "playerctl next")
      , ((myModMask, xK_l), "<M-h> previous",        spawn "playerctl previous")
      , ((myModMask, xK_k), "<M-k> increase volume", spawn "amixer sset Master 5%+")
      , ((myModMask, xK_j), "<M-j> decrease volume", spawn "amixer sset Master 5%-")
      ]


    specialCommands :: [(String,  X ())]
    specialCommands =
      [ ("screenshot",    spawn $ scriptFile "screenshot.sh")
      , ("toggleSpacing", toggleWindowSpacingEnabled)
      , ("toggleGaps",    sendMessage ToggleGaps)
      ]

    describedSubmap :: String -> [((KeyMask, KeySym), String, X ())] -> X ()
    describedSubmap submapTitle mappings = promptDzenWhileRunning submapTitle descriptions mySubmap
      where
        mySubmap     = submap $ M.fromList $ map (\(k, _, f) -> (k, f)) mappings
        descriptions = map (\(_,x,_) -> x) mappings

-- }}}

-- ManageHook -------------------------------{{{

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ resource =? "Dialog" --> doFloat
  , appName =? "pavucontrol" --> doFloat
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
  xmonad 
    $ ewmh
    $ Nav2d.withNavigation2DConfig def { Nav2d.defaultTiledNavigation = Nav2d.sideNavigation }
    $ myConfig dbus

myConfig dbus = desktopConfig
      { terminal           = myTerminal
      , modMask            = myModMask
      , borderWidth        = 1
      , layoutHook         = myLayout
      , logHook            = myLogHook <+> dynamicLogWithPP (polybarPP dbus) <+> logHook def
      , startupHook        = myStartupHook <+> startupHook def <+> return () >> checkKeymap (myConfig dbus ) myKeys
      , manageHook         = myManageHook <+> manageHook def
      -- , handleEventHook    = minimizeEventHook <+> handleEventHook def -- fullscreenEventHook
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
  , ppLayout  = removeWord "Minimize" . removeWord "Hinted" . removeWord "Spacing" . withFG purple
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



-- Utilities --------------------------------------------------- {{{
promptDzenWhileRunning :: String -> [String] -> X () -> X ()
promptDzenWhileRunning promptTitle options action = do
  handle <- spawnPipe $ "sleep 1 && dzen2 -e onstart=uncollapse -l " ++ lineCount ++ " -fn '" ++ font ++ "'"
  io $ SysIO.hPutStrLn handle (promptTitle ++ unlines options)
  _ <- action
  io $ SysIO.hClose handle
  where
    lineCount = show $ length options
    font      = "-*-iosevka-medium-r-s*--16-87-*-*-*-*-iso10???-1"


-- }}}

{-# Language ScopedTypeVariables, LambdaCase #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-unused-binds #-}
-- Imports -------------------------------------------------------- {{{

module Config (main) where

import Control.Concurrent
import           Control.Exception              ( catch
                                                , SomeException
                                                )
import Data.Char (isDigit)
import           Data.List                      ( isSuffixOf , isPrefixOf)
import System.Exit (exitSuccess)

import qualified Rofi


import qualified Data.Map as M
import qualified Data.Monoid
import           Data.Foldable                  ( for_ )
import qualified System.IO as SysIO

import XMonad.Layout.HintedGrid

import XMonad hiding ((|||))
import XMonad.Actions.Commands
import XMonad.Actions.CopyWindow
import XMonad.Actions.Submap
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.BorderResize
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.LayoutHints
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing (spacingRaw, Border(..), toggleWindowSpacingEnabled)
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.ZoomRow
import XMonad.Util.EZConfig (additionalKeysP, removeKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce (spawnOnce)
import qualified XMonad.Actions.Navigation2D as Nav2d
import qualified XMonad.Hooks.EwmhDesktops as Ewmh
import qualified XMonad.Hooks.ManageHelpers as ManageHelpers
import qualified XMonad.Layout.BoringWindows as BoringWindows
import           XMonad.Layout.IndependentScreens
import qualified XMonad.StackSet as W
import qualified XMonad.Util.XSelection as XSel

{-# ANN module "HLint: ignore Redundant $" #-}
{-# ANN module "HLint: ignore Redundant bracket" #-}
{-# ANN module "HLint: ignore Move brackets to avoid $" #-}
{-# ANN module "HLint: ignore Unused LANGUAGE pragma" #-}

-- }}}

-- Values -------------------- {{{

myModMask  = mod4Mask
myLauncher = Rofi.asCommand (def { Rofi.theme = Rofi.bigTheme }) ["-show run"]
myTerminal = "termite"
myBrowser = "qutebrowser"
--myBrowser = "google-chrome-stable"

{-| adds the scripts-directory path to the filename of a script |-}
scriptFile :: String -> String
scriptFile script = "/home/leon/scripts/" ++ script

scratchpads :: [NamedScratchpad]
scratchpads =
  [ NS "terminal" launchTerminal (className =? "scratchpad_term")      (customFloating $ W.RationalRect 0.66 0.7 0.34 0.3)
  , NS "ghci"     launchGHCI     (className =? "scratchpad_ghci")      (customFloating $ W.RationalRect 0.66 0.7 0.34 0.3)
  , NS "spotify"  "spotify"      (appName   =? "spotify")              defaultFloating
  , NS "discord"  "discord"      (appName   =? "discord")              defaultFloating
  , NS "whatsapp" launchWhatsapp (("WhatsApp" `isSuffixOf`) <$> title) defaultFloating
  , NS "slack"    "slack"        (("Slack | " `isPrefixOf`) <$> title) defaultFloating
  ]
    where
      launchTerminal = myTerminal ++ " --class scratchpad_term"
      launchGHCI     = myTerminal ++ " --class scratchpad_ghci stack exec -- ghci"
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
myLayout = avoidStruts . BoringWindows.boringWindows . smartBorders . toggleLayouts Full . layoutHintsToCenter $ layouts
  where
    layouts =((rename "Tall"     $ onlySpacing    $ mouseResizableTile         {draggerType = dragger}) -- ResizableTall 1 (3/100) (1/2) []
          ||| (rename "Horizon"  $ onlySpacing    $ mouseResizableTileMirrored {draggerType = dragger}) -- Mirror                           $ ResizableTall 1 (3/100) (3/4) []
          ||| (rename "BSP"      $ spacingAndGaps $ borderResize $ emptyBSP)
          ||| (rename "Row"      $ spacingAndGaps $ zoomRow)
          ||| (rename "grid"     $ spacingAndGaps $ Grid False))
          -- ||| (rename "threeCol" $ spacingAndGaps $ ThreeColMid 1 (3/100) (1/2))
          -- ||| (rename "spiral"   $ spacingAndGaps $ spiral (9/21))
          -- Grid

    rename n = renamed [Replace n]

    gap            = 7
    onlySpacing = gaps [ (dir, (gap*2)) | dir <- [L, R, D, U] ]  -- gaps are included in mouseResizableTile
    dragger        = let x = fromIntegral gap * 2
                     in FixedDragger x x
    spacingAndGaps = let intGap        = fromIntegral gap
                         spacingBorder = Border (intGap) (intGap) (intGap) (intGap)
                         gapBorder     = Border intGap intGap intGap intGap
                     in spacingRaw True spacingBorder True gapBorder True


-- }}}

-- Startuphook ----------------------------- {{{

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "picom --config ~/.config/picom.conf --experimental-backends"  --no-fading-openclose"
  spawnOnce "pasystray"
  spawnOnce "nm-applet"
  spawnOnce "xfce4-clipman"
  spawnOnce "mailspring --background"
  spawnOnce "redshift -P -O 5000"
  spawn "xset r rate 300 50" -- make key repeat quicker
  spawn "/home/leon/.screenlayout/dualscreen-landscape.sh"
  _ <- liftIO $ Control.Concurrent.threadDelay (1000 * 10)
  spawn "/home/leon/.config/polybar/launch.sh"
  spawn "feh --bg-fill /home/leon/Bilder/wallpapers/mountains_with_clounds.jpg"
  setWMName "LG3D" -- Java stuff hack

-- }}}

-- Keymap --------------------------------------- {{{

-- Default mappings that need to be removed
removedKeys :: [String]
removedKeys = ["M-S-c", "M-S-q", "M-h", "M-l"] ++ ["M-" ++ show n | n <- [1..9 :: Int]]

multiMonitorOperation :: (WorkspaceId -> WindowSet -> WindowSet) -> ScreenId -> X ()
multiMonitorOperation operation n = do
  monitor <- screenWorkspace n
  case monitor of
    Just mon -> windows $ operation  mon
    Nothing -> return ()


myKeys :: XConfig a -> XConfig a
myKeys c = additionalKeysP c $
  [ ("M-+",      sendMessage zoomIn)
  , ("M--",      sendMessage zoomOut)
  , ("M-#",      sendMessage zoomReset)

  , ("M-f",      toggleFullscreen)

  , ("M-S-C-c",  kill1)
  , ("M-S-C-q",  io exitSuccess)

  -- Binary space partitioning
  , ("M-<Backspace>",    sendMessage Swap)
  , ("M-M1-<Backspace>", sendMessage Rotate)

  -- Media
  , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 5%+")
  , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 5%-")

  -- Multi monitor
  , ("M-s",   multiMonitorOperation W.view 1)
  , ("M-d",   multiMonitorOperation W.view 0)
  , ("M-S-s", (multiMonitorOperation W.shift 1) >> multiMonitorOperation W.view 1)
  , ("M-S-d", (multiMonitorOperation W.shift 0) >> multiMonitorOperation W.view 0)

  -- programs
  , ("M-p",      spawn myLauncher)
  , ("M-b",      spawn myBrowser)
  , ("M-C-p",    spawn (myTerminal ++ " --class termite_floating -e fff"))
  , ("M-S-p",    Rofi.showCombi  (def { Rofi.theme = Rofi.bigTheme }) [ "drun", "window", "ssh" ])
  , ("M-S-e",    Rofi.showNormal (def { Rofi.theme = Rofi.bigTheme }) "emoji" )
  --, ("M-s",      spawn $ scriptFile "rofi-search.sh")
  , ("M-S-o",    spawn $ scriptFile "rofi-open.sh")
  , ("M-n",      scratchpadSubmap )
  , ("M-m",      mediaSubmap )
  , ("M-e",      Rofi.promptRunCommand def specialCommands)
  , ("M-C-e",    Rofi.promptRunCommand def =<< defaultCommands )
  , ("M-o",      Rofi.promptRunCommand def withSelectionCommands)
  , ("M-S-C-g",  spawn "killall -INT -g giph" >> spawn "notify-send gif 'saved gif in ~/Bilder/gifs'") -- stop gif recording
  ] ++ generatedMappings
  where
    generatedMappings :: [(String, X ())]
    generatedMappings = windowGoMappings ++ windowSwapMappings ++ resizeMappings ++ workspaceMappings
        where
          workspaceMappings =
            [ (mappingPrefix ++ show wspNum, windows $ onCurrentScreen action wsp)
               | (wsp, wspNum) <- zip (workspaces' c) [1..9 :: Int]
              , (mappingPrefix, action) <- [("M-", W.greedyView), ("M-S-", W.shift), ("M-C-", copy)]
            ]

          keyDirPairs = [("h", L), ("j", D), ("k", U), ("l", R)]

          windowGoMappings   = [ ("M-M1-"   ++ key, Nav2d.windowGo   dir False) | (key, dir) <- keyDirPairs ]
          windowSwapMappings = [ ("M-S-M1-" ++ key, Nav2d.windowSwap dir False) | (key, dir) <- keyDirPairs ]
          resizeMappings =
              [ ("M-C-h", ifLayoutIs "BSP" (sendMessage $ ExpandTowards L) (ifLayoutIs "Horizon" (sendMessage ShrinkSlave) (sendMessage Shrink)))
              , ("M-C-j", ifLayoutIs "BSP" (sendMessage $ ExpandTowards D) (ifLayoutIs "Horizon" (sendMessage Expand)      (sendMessage MirrorShrink >> sendMessage ExpandSlave)))
              , ("M-C-k", ifLayoutIs "BSP" (sendMessage $ ExpandTowards U) (ifLayoutIs "Horizon" (sendMessage Shrink)      (sendMessage MirrorExpand >> sendMessage ShrinkSlave)))
              , ("M-C-l", ifLayoutIs "BSP" (sendMessage $ ExpandTowards R) (ifLayoutIs "Horizon" (sendMessage ExpandSlave) (sendMessage Expand)))
              ]




    toggleFullscreen :: X ()
    toggleFullscreen = do
      sendMessage ToggleLayout                  -- toggle fullscreen layout
      sendMessage ToggleStruts                  -- bar is hidden -> no need to make place for it
      --safeSpawn "polybar-msg" ["cmd", "toggle"] -- toggle polybar visibility


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

    withSelectionCommands :: [(String, X ())]
    withSelectionCommands =
      [ ("Google",        XSel.transformPromptSelection  ("https://google.com/search?q=" ++) "qutebrowser")
      , ("Hoogle",        XSel.transformPromptSelection  ("https://hoogle.haskell.org/?hoogle=" ++) "qutebrowser")
      , ("Translate",     XSel.transformPromptSelection  ("https://translate.google.com/#view=home&op=translate&sl=auto&tl=en&text=" ++) "qutebrowser")
      ]


    specialCommands :: [(String,  X ())]
    specialCommands =
      [ ("screenshot",              spawn $ scriptFile "screenshot.sh")
      , ("screenshot to file",      spawn $ scriptFile "screenshot.sh --tofile")
      , ("screenshot full to file", spawn $ scriptFile "screenshot.sh --tofile --fullscreen")
      , ("screengif to file",       spawn (scriptFile "screengif.sh") >> spawn "notify-send gif 'stop gif-recording with M-S-C-g'")
      , ("clipboard history",       spawn $ "clipmenu")
      , ("toggleOptimal",           sendMessage ToggleGaps >> toggleWindowSpacingEnabled)
      , ("toggleSpacing",           toggleWindowSpacingEnabled)
      , ("toggleGaps",              sendMessage ToggleGaps)
      , ("Copy to all workspaces",  windows copyToAll)           -- windows: Modify the current window list with a pure function, and refresh
      , ("Kill all other copies",   killAllOtherCopies)
      , ("toggle polybar",          safeSpawn "polybar-msg" ["cmd", "toggle"])
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
  [ resource =? "Dialog" --> ManageHelpers.doCenterFloat
  , appName =? "pavucontrol" --> ManageHelpers.doCenterFloat
  , className =? "mpv" --> ManageHelpers.doRectFloat (W.RationalRect 0.9 0.9 0.1 0.1)
  , title =? "Something" --> doFloat
  , className =? "termite_floating" --> ManageHelpers.doRectFloat(W.RationalRect 0.2 0.2 0.6 0.6)
  -- , isFullscreen --> doF W.focusDown <+> doFullFloat
  , manageDocks
  , namedScratchpadManageHook scratchpads
  ]

-- }}}

-- Main ------------------------------------ {{{
main :: IO ()
main = do
  currentScreenCount :: Int <- countScreens
  let monitorIndices = [0..currentScreenCount - 1]

  -- create a fifo named pipe for every monitor (called /tmp/xmonad-state-bar0, etc)
  for_ monitorIndices (\idx -> safeSpawn "mkfifo" ["/tmp/xmonad-state-bar" ++ show idx])

  -- create polybarLogHooks for every monitor and combine them using the <+> monoid instance
  let polybarLogHooks = foldMap (polybarLogHook . fromIntegral) monitorIndices

  let myConfig = myKeys (desktopConfig
        { terminal           = myTerminal
        , workspaces         = withScreens (fromIntegral currentScreenCount) (map show [1..9 :: Int])
        , modMask            = myModMask
        , borderWidth        = 2
        , layoutHook         = myLayout
        , logHook            = polybarLogHook 0 <+> polybarLogHook 1 <+> logHook def
        , startupHook        = myStartupHook <+> startupHook def -- <+> return () >> checkKeymap myConfig (myKeys myConfig)
        , manageHook         = myManageHook <+> manageHook def
        , focusedBorderColor = aqua
        , normalBorderColor  = "#282828"
        --, handleEventHook  = minimizeEventHook <+> handleEventHook def <+> hintsEventHook -- <+> Ewmh.fullscreenEventHook
        } `removeKeysP` removedKeys)



  xmonad
    $ Ewmh.ewmh
    $ Nav2d.withNavigation2DConfig def { Nav2d.defaultTiledNavigation = Nav2d.sideNavigation }
    $ myConfig



-- }}}

-- POLYBAR Kram -------------------------------------- {{{

-- | Loghook for polybar on a given monitor.
-- Will write the polybar formatted string to /tmp/xmonad-state-bar${monitor}
polybarLogHook :: Int -> X ()
polybarLogHook monitor = do
  barOut <- dynamicLogString $ polybarPP monitor
  io $ SysIO.appendFile ("/tmp/xmonad-state-bar" ++ show monitor) (barOut ++ "\n")


-- swapping namedScratchpadFilterOutWorkspacePP and marshallPP  will throw "Prelude.read no Parse" errors..... wtf
-- | create a polybar Pretty printer, marshalled for given monitor.
polybarPP :: Int -> PP
polybarPP monitor = namedScratchpadFilterOutWorkspacePP $ marshallPP (fromIntegral monitor)  $ def
  { ppCurrent = withBG bg2
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

-- }}}

-- Utilities --------------------------------------------------- {{{



catchAndNotifyAny :: IO () -> IO ()
catchAndNotifyAny ioAction = catch ioAction (\(e :: SomeException) -> safeSpawn "notify-send" ["Xmonad exception", show e])


promptDzenWhileRunning :: String -> [String] -> X () -> X ()
promptDzenWhileRunning promptTitle options action = do
  handle <- spawnPipe $ "sleep 1 && dzen2 -e onstart=uncollapse -l " ++ lineCount ++ " -fn '" ++ font ++ "'"
  io $ SysIO.hPutStrLn handle (promptTitle ++ unlines options)
  _ <- action
  io $ SysIO.hClose handle
  where
    lineCount = show $ length options
    font      = "-*-iosevka-medium-r-s*--16-87-*-*-*-*-iso10???-1"

ifLayoutIs :: String -> X a -> X a -> X a
ifLayoutIs layoutAName onLayoutA onLayoutB = do
  layout <- getActiveLayoutDescription
  if (layout == layoutAName) then onLayoutA else onLayoutB

-- Get the name of the active layout.
getActiveLayoutDescription :: X String
getActiveLayoutDescription = (description . W.layout . W.workspace . W.current) <$> gets windowset

-- }}}

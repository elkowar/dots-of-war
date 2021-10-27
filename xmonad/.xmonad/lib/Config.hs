{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE MultiParamTypeClasses, DeriveDataTypeable, TypeSynonymInstances, FlexibleInstances, FlexibleContexts, ScopedTypeVariables, LambdaCase #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-unused-binds -fno-warn-Wno-unused-top-binds #-}
-- Imports -------------------------------------------------------- {{{

module Config (main) where
import qualified Data.Map.Strict as M
import Control.Concurrent
import           Control.Exception              ( catch , SomeException)
import           Control.Monad                  (join,  filterM , when)
import           Control.Arrow                  ( (>>>) )
import Data.List ( isPrefixOf, isInfixOf, find )
import qualified Data.List
import System.Exit (exitSuccess)
import qualified Rofi
import qualified TiledDragging
--import qualified WindowSwallowing

import XMonad.Hooks.WindowSwallowing as WindowSwallowing



import qualified XMonad.Util.Hacks as Hacks
--import XMonad.Util.ActionCycle
import Data.Foldable                  ( for_ )


import Data.Function ((&))

import XMonad hiding ((|||))
import XMonad.Actions.CopyWindow
import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.LayoutCombinators ((|||))
import XMonad.Layout.LayoutHints
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing (spacingRaw, Border(..), incScreenWindowSpacing, decScreenWindowSpacing)
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation ( windowNavigation )
import XMonad.Layout.ZoomRow
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableThreeColumns
import XMonad.Layout.WindowSwitcherDecoration
import XMonad.Layout.DraggingVisualizer

import           XMonad.Util.EZConfig           ( additionalKeysP
                                                , removeKeysP
                                                , checkKeymap
                                                )


import XMonad.Util.Run
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.WorkspaceCompare   ( getSortByIndex)

import           Data.Monoid                    ( Endo )
import           Data.Semigroup                 ( All(..) )
import qualified System.IO                           as SysIO
import qualified XMonad.Actions.Navigation2D         as Nav2d
import qualified XMonad.Config.Desktop               as Desktop
import qualified XMonad.Hooks.EwmhDesktops           as Ewmh
import qualified XMonad.Hooks.ManageHelpers          as ManageHelpers
import           XMonad.Hooks.DebugStack        ( debugStackFullString
                                                )
import qualified XMonad.Layout.BoringWindows         as BoringWindows
import qualified XMonad.Layout.MultiToggle           as MTog
import qualified XMonad.Layout.MultiToggle.Instances as MTog
import qualified XMonad.Layout.ToggleLayouts         as ToggleLayouts
import qualified XMonad.StackSet                     as W
import qualified XMonad.Util.XSelection              as XSel
import qualified XMonad.Layout.PerScreen             as PerScreen
import Data.Maybe (catMaybes, maybeToList, fromMaybe)
import Data.Bifunctor
import GHC.IO.Unsafe (unsafePerformIO)
import XMonad.Layout.LayoutModifier
import qualified IndependentScreens as IS
import qualified XMonad.Actions.Sift as Sift

{-# ANN module "HLint: ignore Redundant $" #-}
{-# ANN module "HLint: ignore Redundant bracket" #-}
{-# ANN module "HLint: ignore Move brackets to avoid $" #-}
{-# ANN module "HLint: ignore Unused LANGUAGE pragma" #-}

-- }}}

-- Values -------------------- {{{

verticalMonitorIndex = 0 :: Int
myModMask  = mod4Mask
myLauncher = Rofi.asCommand def ["-show run"]
myTerminal = "alacritty"

{-| adds the scripts-directory path to the filename of a script |-}
scriptFile :: String -> String
scriptFile script = "/home/leon/scripts/" ++ script


-- }}}

-- Colors ------ {{{
gray      = "#888974"
red       = "#fb4934"
purple    = "#d3869b"
aqua      = "#8ec07c"
-- }}}


-- Layout ---------------------------------------- {{{
myTabTheme :: Theme
myTabTheme = def -- defaultThemeWithButtons
    { activeColor         = "#282828"
    , inactiveColor       = "#1d2021" --inactiveColor       = "#282828"
    , activeBorderColor   = "#1d2021"
    , inactiveBorderColor = "#282828"
    , activeTextColor     = "#fbf1c7"
    , inactiveTextColor   = "#fbf1c7"
    , decoHeight          = 20
    , activeBorderWidth   = 0
    , inactiveBorderWidth = 0
    , urgentBorderWidth   = 0
    , fontName            = "-misc-cozettevector-*-*-*-*-10-*-*-*-*-*-*-*"
    }

data EmptyShrinker = EmptyShrinker deriving (Show, Read)
instance Shrinker EmptyShrinker where
  shrinkIt _ _ = [] :: [String]


myLayout = noBorders
         . avoidStruts
         . smartBorders
         . MTog.mkToggle1 MTog.FULL
         . ToggleLayouts.toggleLayouts tabbedTall
         . MTog.mkToggle1 WINDOWDECORATION
         . draggingVisualizer
         . layoutHintsToCenter
         $ layouts
  where
    -- | if the screen is wider than 1900px it's horizontal, so use horizontal layouts.
    -- if it's not, it's vertical, so use layouts for vertical screens.
    layouts = PerScreen.ifWider 1900 
      (PerScreen.ifWider 3000 chonkyScreenLayouts (MTog.mkToggle1 ONLYONTOPHALF horizScreenLayouts))
      vertScreenLayouts

    chonkyScreenLayouts = (rn "UltraTall" $ withGaps $ centeredIfSingle 0.6 resizableThreeCol)
      ||| horizScreenLayouts

    horizScreenLayouts =
         (rn "Tall"      $            withGaps $ centeredIfSingle 0.7 mouseResizableTile {draggerType = BordersDragger})
     ||| (rn "Horizon"   $            withGaps $ mouseResizableTileMirrored {draggerType = BordersDragger})
     ||| (rn "ThreeCol"  $ mkTabbed $ withGaps $ resizableThreeCol)
     ||| (rn "TabbedRow" $ mkTabbed $ withGaps $ zoomRow)
     --  ||| (rn "Colm"      $ mkTabbed $ withGaps $ centeredIfSingle 0.7 (multiCol [1] 2 0.05))

    vertScreenLayouts =
        ((rn "ThreeCol" $ mkTabbed $ withGaps $ Mirror $ reflectHoriz $ ThreeColMid 1 (3/100) (1/2))
     ||| (rn "Horizon"  $            withGaps $ mouseResizableTileMirrored {draggerType = BordersDragger}))

    -- | Simple tall layout with tab support
    tabbedTall = rn "Tabbed" . mkTabbed . withGaps $ ResizableTall 1 (3/100) (1/2) []
    -- | Specific instance of ResizableThreeCol
    resizableThreeCol = ResizableThreeColMid 1 (3/100) (2/5) []

    rn n = renamed [Replace n]

    withGaps = spacingRaw False border True border True
      where gap = 15
            border = Border gap gap gap gap

    -- | transform a layout into supporting tabs
    mkTabbed layout = BoringWindows.boringWindows . windowNavigation . addTabs shrinkText myTabTheme $ subLayout [] Simplest $ layout



-- LayoutModifier and layout definitions ---------- {{{

-- | window decoration layout modifier. this needs you to add `dragginVisualizer` yourself
data WINDOWDECORATION = WINDOWDECORATION deriving (Read, Show, Eq, Typeable)
instance MTog.Transformer WINDOWDECORATION Window where
  transform WINDOWDECORATION layout k = k (windowSwitcherDecoration EmptyShrinker myTabTheme layout) (const layout)


-- | Layout Modifier that places a window in the center of the screen, 
-- leaving room on the left and right, if there is only a single window
newtype CenteredIfSingle a = CenteredIfSingle Double deriving (Show, Read)
instance LayoutModifier CenteredIfSingle Window where
  pureModifier (CenteredIfSingle ratio) r _ [(onlyWindow, _)] = ([(onlyWindow, rectangleCenterPiece ratio r)], Nothing)
  pureModifier _ _ _ winRects = (winRects, Nothing)

-- | Layout Modifier that places a window in the center of the screen, 
-- leaving room on the left and right, if there is only a single window
centeredIfSingle :: Double -> l a -> ModifiedLayout CenteredIfSingle l a
centeredIfSingle ratio = ModifiedLayout (CenteredIfSingle ratio)

-- | Give the center piece of a rectangle by taking the given percentage 
-- of the rectangle and taking that in the middle.
rectangleCenterPiece :: Double -> Rectangle -> Rectangle
rectangleCenterPiece ratio (Rectangle rx ry rw rh) = Rectangle start ry width rh
  where
    sides = floor $ ((fi rw) * (1.0 - ratio)) / 2
    start = (fi rx) + sides
    width = fi $ (fi rw) - (sides * 2)

-- Layout modifier that restricts windows to only display on the top part of the monitor
-- I use this because sometimes I have my bottom monitor obscure part of the top monitor,
-- thus having windows only be placed on the visible part of the screen is a good thing.

data ONLYONTOPHALF = ONLYONTOPHALF deriving (Read, Show, Eq, Typeable)
instance MTog.Transformer ONLYONTOPHALF Window where
    transform ONLYONTOPHALF layout k = k (onlyOnTopHalf 0.62 layout) (const layout) 

newtype OnlyOnTopHalf a = OnlyOnTopHalf Double deriving (Show, Read) 
instance LayoutModifier OnlyOnTopHalf Window where
  pureModifier (OnlyOnTopHalf ratio) _screenRect _ wins = (fmap (second (rectangleTopHalf ratio)) wins, Nothing)

onlyOnTopHalf :: Double -> l a -> ModifiedLayout OnlyOnTopHalf l a
onlyOnTopHalf ratio = ModifiedLayout (OnlyOnTopHalf ratio)

-- | Calculate the top part of a rectangle by a given ratio
rectangleTopHalf :: Double -> Rectangle -> Rectangle
rectangleTopHalf ratio (Rectangle rx ry rw rh) = Rectangle rx (floor $ (fi ry) * ratio) rw (floor $ (fi rh) * ratio)


fi :: (Integral a, Num b) => a -> b
fi = fromIntegral

-- }}}

-- }}}

-- Startuphook ----------------------------- {{{

myStartupHook :: X ()
myStartupHook = do
  setWMName "LG3D" -- Java stuff hack
  --spawnOnce "nm-applet &"
  spawnOnce "udiskie -s &" -- Mount USB sticks automatically. -s is smart systray mode: systray icon if something is mounted
  spawnOnce "xfce4-clipman &"
  --spawnOnce "redshift -P -O 5000 &"
  spawn "xset r rate 300 50 &" -- make key repeat quicker
  --spawn "setxkbmap de nodeadkeys"
  spawn "setxkbmap us -option compose:ralt"
  spawn "arbtt-capture"
  --spawn "/home/leon/.screenlayout/dualscreen-stacked.sh"
  spawn "/home/leon/.screenlayout/tripplescreen-fixed.sh"
  spawnOnce "xsetroot -cursor_name left_ptr"
  spawnOnce "xrdb -merge ~/.Xresources"
  io $ threadDelay $ 1000 * 100
  --spawnOnce "/home/leon/Downloads/picom --config /home/leon/.config/picom.conf --experimental-backends --backend xrender"  --no-fading-openclose"
  spawnOnce "/home/leon/Downloads/picom-epic-animations --config /home/leon/.config/picom.conf --experimental-backends --animations --animation-stiffness 200 --animation-dampening 20" --backend glx"  --no-fading-openclose"
  --spawn "/home/leon/.config/polybar/launch.sh"
  setupPolybarOn "DisplayPort-0"
  spawnOnce "eww -c /home/leon/.config/eww-bar open-many bar_2 bar_1 &"
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "nitrogen --restore"
  spawnOnce "mailnag"
  spawn "flashfocus"
  spawnOnce "dunst"
  for_ ["led1", "led2"] $ \led -> safeSpawn "sudo" ["liquidctl", "set", led, "color", "fixed", "00ffff"]
  setGtkFrameExtents


setGtkFrameExtents :: X ()
setGtkFrameExtents = withDisplay $ \dpy -> do
  r <- asks theRoot
  a <- getAtom "_NET_SUPPORTED"
  c <- getAtom "ATOM"
  f <- getAtom "_GTK_FRAME_EXTENTS"
  io $ do
    sup <- (join . maybeToList) <$> getWindowProperty32 dpy a r
    when (fromIntegral f `notElem` sup) $ do
      changeProperty32 dpy r a c propModeAppend [fromIntegral f]
-- }}}

-- Keymap --------------------------------------- {{{

myMouseBindings :: XConfig Layout -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modMask'}) = M.fromList
  [((modMask' .|. shiftMask, button1), TiledDragging.tiledDrag)]


-- Default mappings that need to be removed
removedKeys :: [String]
removedKeys = ["M-<Tab>", "M-S-c", "M-S-q", "M-h", "M-l", "M-j", "M-k", "M-S-<Return>", "M-S-j", "M-S-k"]
  ++ [key ++ show n | key <- ["M-", "M-S-", "M-C-"], n <- [1..9 :: Int]]


myKeys :: [(String, X ())]
myKeys = concat [ zoomRowBindings, tabbedBindings, multiMonitorBindings, programLaunchBindings, miscBindings, windowControlBindings, workspaceBindings ]
  where
  keyDirPairs = [("h", L), ("j", D), ("k", U), ("l", R)]

  zoomRowBindings :: [(String, X ())]
  zoomRowBindings =
    [ ("M-+", sendMessage zoomIn)
    , ("M--", sendMessage zoomOut)
    , ("M-#", sendMessage zoomReset)
    ]

  tabbedBindings :: [(String, X ())]
  tabbedBindings =
    [ ("M-j",                ifLayoutName ("Tabbed" `isPrefixOf`) (BoringWindows.focusDown) (windows W.focusDown))
    , ("M-k",                ifLayoutName ("Tabbed" `isPrefixOf`) (BoringWindows.focusUp)   (windows W.focusUp))
    , ("M-S-j",              windows Sift.siftDown)
    , ("M-S-k",              windows Sift.siftUp)
    , ("M-C-S-h",            sendMessage $ pullGroup L)
    , ("M-C-S-j",            sendMessage $ pullGroup D)
    , ("M-C-S-k",            sendMessage $ pullGroup U)
    , ("M-C-S-l",            sendMessage $ pullGroup R)
    , ("M-S-C-m",            withFocused (sendMessage . MergeAll))
    , ("M-S-C-<Backspace>",  withFocused (sendMessage . UnMerge))
    , ("M-<Tab>",            onGroup W.focusDown')
    , ("M-C-<Tab>",          onGroup W.focusUp')
    , ("M-S-t",              toggleTabbedLayout)

    -- In tabbed mode, while focussing master pane, cycle tabs on the first slave
    , ("M-S-<Tab>",          windows W.focusMaster >> BoringWindows.focusDown >> onGroup W.focusDown' >> windows W.focusMaster)
    ]

  multiMonitorBindings :: [(String, X ())]
  multiMonitorBindings =
    [ ("M-a",   windows $ IS.focusScreen 0)
    , ("M-s",   windows $ IS.focusScreen 2)
    , ("M-d",   windows $ IS.focusScreen 1)
    , ("M-S-a", windows $ IS.withWspOnScreen 0 (\wsp -> W.view wsp . W.shift wsp))
    , ("M-S-s", windows $ IS.withWspOnScreen 2 (\wsp -> W.view wsp . W.shift wsp))
    , ("M-S-d", windows $ IS.withWspOnScreen 1 (\wsp -> W.view wsp . W.shift wsp))
    , ("M-C-s", windows swapScreenContents)
    ]

  programLaunchBindings :: [(String, X ())]
  programLaunchBindings =
    [ ("M-p",          spawn myLauncher)
    , ("M-S-p",        Rofi.showNormal def "drun")
    , ("M-S-e",        Rofi.showNormal (def { Rofi.fuzzy = False }) "emoji")
    , ("M-S-o",        spawn $ scriptFile "rofi-open.sh")
    , ("M-e",          Rofi.promptRunCommand def specialCommands)
    , ("M-o",          Rofi.promptRunCommand def withSelectionCommands)
    , ("M-b",          safeSpawnProg "google-chrome-stable")
    , ("M-S-<Return>", spawn myTerminal)
    , ("M-C-S-s",      spawn "flameshot gui")
    , ("M-z",          spawn $ scriptFile "copy-pasta.sh")


    , ("M-S-h", fuckshit)
    ]

  miscBindings :: [(String, X ())]
  miscBindings =
    [ ("M-f",     do withFocused (windows . W.sink)
                     sendMessage (MTog.Toggle MTog.FULL)
                     sendMessage ToggleStruts)
    , ("M-C-S-w", sendMessage $ MTog.Toggle WINDOWDECORATION)

    , ("M-S-C-c", kill1)
    , ("M-S-C-q", io exitSuccess)


    -- useless binding simply to not accidentally quit firefox
    , ("C-q", pure ())

    -- Media
    , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 5%+")
    , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 5%-")
    , ("M-S-C-,", (notify "hi" (show $ map (\(a, _) -> show a) workspaceBindings)) >> (notify "ho" (show removedKeys)))
    , ("M-<Backspace>", spawn "flash_window")
    , ("M-g", incScreenWindowSpacing 5)
    , ("M-S-g", decScreenWindowSpacing 5)
    ]

  workspaceBindings :: [(String, X ())]
  workspaceBindings = concat $
    [ [ ("M-"   ++ show wspNum, runActionOnWorkspace W.view  wspNum)
      , ("M-S-" ++ show wspNum, runActionOnWorkspace W.shift wspNum)
      , ("M-C-" ++ show wspNum, runActionOnWorkspace copy    wspNum)
      ]
    | wspNum <- [1..9 :: Int]
    ]
    where
    runActionOnWorkspace :: (IS.VirtualWorkspace -> WindowSet -> WindowSet) -> Int -> X ()
    runActionOnWorkspace action wspNum = do
      desiredWsp <- IS.nthWorkspace (wspNum - 1)
      case desiredWsp of
        Just wsp -> windows $ IS.onCurrentScreen action wsp
        Nothing -> pure ()

  windowControlBindings :: [(String, X ())]
  windowControlBindings = windowGoMappings ++ windowSwapMappings ++ resizeMappings
    where
    windowGoMappings   = [ ("M-M1-"   ++ key, Nav2d.windowGo   dir False) | (key, dir) <- keyDirPairs ]
    windowSwapMappings = [ ("M-S-M1-" ++ key, Nav2d.windowSwap dir False) | (key, dir) <- keyDirPairs ]
    resizeMappings =
      [ ("M-C-h", ifLayoutIs "Horizon" (sendMessage ShrinkSlave) (sendMessage Shrink))
      , ("M-C-j", ifLayoutIs "Horizon" (sendMessage Expand)      (sendMessage MirrorShrink >> sendMessage ExpandSlave))
      , ("M-C-k", ifLayoutIs "Horizon" (sendMessage Shrink)      (sendMessage MirrorExpand >> sendMessage ShrinkSlave))
      , ("M-C-l", ifLayoutIs "Horizon" (sendMessage ExpandSlave) (sendMessage Expand))
      ]


  -- | toggle tabbed Tall layout, merging all non-master windows
  -- into a single tab group when initializing the tabbed layout.
  toggleTabbedLayout :: X ()
  toggleTabbedLayout = do
    sendMessage $ ToggleLayouts.Toggle "Tabbed"
    ifLayoutIs "Tabbed" (do BoringWindows.focusMaster
                            withFocused (sendMessage . MergeAll)
                            withFocused (sendMessage . UnMerge)
                            -- refresh the tabs, so they draw correctly
                            windows W.focusUp
                            windows W.focusDown)
                        (return ())

  -- | launch a program by starting an instance in a hidden workspace,
  -- and just raising an already running instance. This allows for super quick "startup" time.
  -- For this to work, the window needs to have the `_NET_WM_PID` set and unique!
  launchWithBackgroundInstance :: (Query Bool) -> String -> X ()
  launchWithBackgroundInstance windowQuery commandToRun = withWindowSet $ \winSet -> do
      fittingHiddenWindows <- (W.allWindows winSet) |> filter (\win -> Just "NSP" == W.findTag win winSet)
                                                    |> filterM (runQuery windowQuery)
      case fittingHiddenWindows of
        []        -> do spawnHere commandToRun
                        spawnOn "NSP" commandToRun
        [winId]   -> do windows $ W.shiftWin (W.currentTag winSet) winId
                        spawnOn "NSP" commandToRun
        (winId:_) -> windows $ W.shiftWin (W.currentTag winSet) winId


  swapScreenContents :: W.StackSet i l a sid sd -> W.StackSet i l a sid sd
  swapScreenContents ws = if null (W.visible ws) then ws else
    let
      otherScreen   = head $ W.visible ws
      otherWsp      = W.workspace otherScreen
      currentScreen = W.current ws
      currentWsp    = W.workspace currentScreen
    in
      ws
        { W.current = currentScreen { W.workspace = otherWsp   { W.tag = W.tag currentWsp } }
        , W.visible = (otherScreen  { W.workspace = currentWsp { W.tag = W.tag otherWsp } } : (tail $ W.visible ws))
        }

  swapCurrentWspContentsWith :: Eq i => i -> W.StackSet i l a sid sd -> W.StackSet i l a sid sd
  swapCurrentWspContentsWith other ws =
    case find ((other ==) . W.tag) $ W.workspaces ws of
      Just otherWsp -> W.mapWorkspace (swapWith otherWsp) ws
      Nothing -> ws
    where
      currentWsp = W.workspace $ W.current ws
      swapWith otherWsp w
        | W.tag w == other            = currentWsp { W.tag = W.tag otherWsp }
        | W.tag w == W.tag currentWsp = otherWsp   { W.tag = W.tag currentWsp }
        | otherwise                   = w



  withSelectionCommands :: [(String, X ())]
  withSelectionCommands =
    [ ("Google",    XSel.transformPromptSelection  ("https://google.com/search?q=" ++) "google-chrome-stable")
    , ("Hoogle",    XSel.transformPromptSelection  ("https://hoogle.haskell.org/?hoogle=" ++) "google-chrome-stable")
    , ("Translate", XSel.getSelection >>= translateMenu)
    ]

  translateMenu :: String -> X ()
  translateMenu input = do
    selectedLanguage <- Rofi.promptSimple def ["de", "en", "fr"]
    translated <- runProcessWithInput "trans" [":" ++ selectedLanguage, input, "--no-ansi"] ""
    notify "Translation" translated


  specialCommands :: [(String,  X ())]
  specialCommands =
    [ ("screenshot",                spawn $ scriptFile "screenshot.sh")
    , ("screenshot to file",        spawn $ scriptFile "screenshot.sh --tofile")
    , ("screenshot full to file",   spawn $ scriptFile "screenshot.sh --tofile --fullscreen")
    , ("screenvideo to file",       spawn (scriptFile "screenvideo.sh") >> notify "video" "stop video-recording with M-S-C-g")
    , ("screengif to file",         spawn (scriptFile "screengif.sh") >> notify "gif" "stop gif-recording with M-S-C-g")
    , ("Copy to all workspaces",    windows copyToAll)
    , ("Kill all other copies",     killAllOtherCopies)
    , ("get debug data",            debugStackFullString >>= (\str -> safeSpawn "xmessage" [str]))
    , ("get full stackset",         withWindowSet (\ws -> spawn $ "echo '" ++ show (W.floating ws) ++ "\n" ++ show (W.current ws) ++ "' | xclip -in -selection clipboard"))
    , ("toggle top screen halving", sendMessage $ MTog.Toggle ONLYONTOPHALF)
    ]



-- }}}

-- ManageHook -------------------------------{{{

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ resource  =? "Dialog"                      --> ManageHelpers.doCenterFloat
  , appName   =? "pavucontrol"                 --> ManageHelpers.doCenterFloat
  , className =? "Myxer"                       --> ManageHelpers.doCenterFloat
  --, className =? "mpv"                         --> ManageHelpers.doRectFloat (W.RationalRect 0.9 0.9 0.1 0.1)
  , title     =? "Something"                   --> doFloat
  , className =? "termite_floating"            --> ManageHelpers.doRectFloat(W.RationalRect 0.2 0.2 0.6 0.6)
  , className =? "bar_system_status_indicator" --> ManageHelpers.doRectFloat (W.RationalRect 0.7 0.05 0.29 0.26)
  , title     =? "discord.com hat Ihren Bildschirm freigegeben" --> doShift "NSP"
  , manageDocks
  ]

-- }}}

-- Main ------------------------------------ {{{



main :: IO ()
main = do
  currentScreenCount :: Int <- IS.countScreens

  -- set up the fifo for polybar
  safeSpawn "mkfifo" ["/tmp/xmonad-state-bar" ++ show verticalMonitorIndex]

  let myConfig = flip additionalKeysP myKeys
               $ flip removeKeysP removedKeys
               $ Desktop.desktopConfig
        { terminal           = myTerminal
        , workspaces         = (IS.withScreens (fromIntegral currentScreenCount) (map show [1..6 :: Int])) ++ ["NSP"]
        , modMask            = myModMask
        , borderWidth        = 0
        , layoutHook         = myLayout
        , logHook            = mconcat [ polybarLogHook verticalMonitorIndex
                                       , ewwLogHook
                                       --, Ewmh.ewmhDesktopsLogHook
                                       , logHook Desktop.desktopConfig
                                       --, fadeInactiveLogHook 0.95
                                       , logHook def]
        , startupHook        = mconcat [ --Ewmh.ewmhDesktopsStartup
                                       --, 
                                         myStartupHook, checkKeymap myConfig myKeys]
        , manageHook         = mconcat [ manageSpawn, myManageHook, manageHook def]
        , focusedBorderColor = "#427b58"
        , normalBorderColor  = "#282828"
        , handleEventHook    = mconcat [ mySwallowEventHook
                                       , activateWindowEventHook
                                       , handleEventHook Desktop.desktopConfig
                                       , Hacks.windowedFullscreenFixEventHook
                                       --, Ewmh.ewmhDesktopsEventHook
                                       ]
        --, handleEventHook  = minimizeEventHook <+> handleEventHook def <+> hintsEventHook -- <+> Ewmh.fullscreenEventHook
        , mouseBindings = myMouseBindings <+> mouseBindings def
       }

  xmonad
    $ Nav2d.withNavigation2DConfig def { Nav2d.defaultTiledNavigation = Nav2d.sideNavigation }
    $ Ewmh.setEwmhActivateHook myActivateManageHook
    $ Ewmh.ewmh
    $ docks
    $ myConfig


-- }}}


myActivateManageHook :: ManageHook
myActivateManageHook = pure mempty

mySwallowEventHook = WindowSwallowing.swallowEventHook
  (className =? "Alacritty" <||> className =? "Termite" <||> className =? "NOPE Thunar")
  ((not <$> (className =* "eww" <||> className =? "Dragon" <||> className =? "noswallow")) <||> className =? "re") -- remove that last part


(=*) :: Query String  -> String -> Query Bool
query =* value = (value `isInfixOf`) <$> query

activateWindowEventHook :: Event -> X All
activateWindowEventHook (ClientMessageEvent { ev_message_type = messageType, ev_window = window }) = withWindowSet $ \ws -> do
  activateWindowAtom <- getAtom "_NET_ACTIVE_WINDOW"

  when (messageType == activateWindowAtom) $
    if window `elem` (W.integrate' $ W.stack $ W.workspace $ W.current ws)
      then windows (W.focusWindow window)
      else do
        shouldRaise <- runQuery (className =? "discord" <||> className =? "web.whatsapp.com") window
        if shouldRaise
           then windows (W.shiftWin (W.currentTag ws) window)
           else windows (IS.focusWindow' window)
  return $ All True
activateWindowEventHook _ = return $ All True

-- | Focus a window, switching workspace on the correct Xinerama screen if neccessary.
-- focusWindow' :: Window -> WindowSet -> WindowSet
-- focusWindow' window ws
--   | Just window == W.peek ws = ws
--   | otherwise = case W.findTag window ws of
--       Just tag ->  IS.focusScreen (IS.unmarshallS tag) ws
--       Nothing -> ws



-- Bar Kram -------------------------------------- {{{

-- | Loghook for eww on all monitors. Runs the eww-bar 
ewwLogHook :: X ()
ewwLogHook = spawn "/home/leon/.config/eww-bar/update-workspaces.sh"

-- | Launch a polybar on the given monitor name
setupPolybarOn :: String -> X ()
setupPolybarOn name =
    spawnOnce $ "MONITOR=" ++ name ++ " TRAY_POSITION=right polybar -r --config=/home/leon/.config/polybar/config.ini main &"


-- | Loghook for polybar on a given monitor.
-- Will write the polybar formatted string to /tmp/xmonad-state-bar${monitor}
polybarLogHook :: Int -> X ()
polybarLogHook monitor = do
  barOut <- dynamicLogString $ polybarPP $ fromIntegral monitor
  io $ SysIO.appendFile ("/tmp/xmonad-state-bar" ++ show monitor) (barOut ++ "\n")


-- swapping namedScratchpadFilterOutWorkspacePP and marshallPP  will throw "Prelude.read no Parse" errors..... wtf
-- | create a polybar Pretty printer, marshalled for given monitor.
polybarPP :: ScreenId -> PP
polybarPP monitor = filterOutWsPP ["NSP"] . (IS.marshallPP $ fromIntegral monitor) $ def
  { ppCurrent          = withFG aqua . withMargin . withFont 5 . const "__active__"
  , ppVisible          = withFG aqua . withMargin . withFont 5 . const "__active__"
  , ppUrgent           = withFG red  . withMargin . withFont 5 . const "__urgent__"
  , ppHidden           = withFG gray . withMargin . withFont 5 . (`wrapClickableWorkspace` "__hidden__")
  , ppHiddenNoWindows  = withFG gray . withMargin . withFont 5 . (`wrapClickableWorkspace` "__empty__")
  , ppWsSep            = ""
  , ppSep              = ""
  , ppLayout           = removeWords ["DraggingVisualizer", "WindowSwitcherDeco", "Minimize", "Hinted", "Spacing", "Tall"]
                          >>> \l -> if l == "Tall" || l == "Horizon" || l == "" then ""
                                    else (withFG gray " | ") ++ (withFG purple $ withMargin l)
  , ppExtras           = []
  , ppTitle            = const "" -- withFG aqua . (shorten 40)
  , ppSort             = onlyRelevantWspsSorter
  }
    where
      withMargin                 = wrap " " " "
      removeWords wrds           = unwords . filter (`notElem` wrds). words
      withFont fNum              = wrap ("%{T" ++ show (fNum :: Int) ++ "}") "%{T}"
      withBG col                 = wrap ("%{B" ++ col ++ "}") "%{B-}"
      withFG col                 = wrap ("%{F" ++ col ++ "}") "%{F-}"
      wrapOnClickCmd command     = wrap ("%{A1:" ++ command ++ ":}") "%{A}"
      wrapClickableWorkspace wsp = wrapOnClickCmd ("xdotool key super+" ++ wsp)

      onlyRelevantWspsSorter = do
        sortByIndex <- getSortByIndex
        visibleWorkspaceTags <- getVisibleWorkspacesTagsOnMonitor monitor
        let isEmptyAndNotOpened wsp = (null $ W.stack wsp) && (W.tag wsp) `notElem` visibleWorkspaceTags
        return $ dropEndWhile isEmptyAndNotOpened . sortByIndex

-- }}}

-- Utilities --------------------------------------------------- {{{

(|>) :: a -> (a -> b) -> b
(|>) = (&)
infixl 1 |>


dropEndWhile :: (a -> Bool) -> [a] -> [a]
dropEndWhile _    []  = []
dropEndWhile test xs  = if test $ last xs then dropEndWhile test (init xs) else xs

catchAndNotifyAny :: IO () -> IO ()
catchAndNotifyAny ioAction = catch ioAction (\(e :: SomeException) -> notify "Xmonad exception" (show e))

getVisibleWorkspacesTagsOnMonitor :: ScreenId -> X [IS.VirtualWorkspace]
getVisibleWorkspacesTagsOnMonitor monitor = do
  ws <- gets windowset
  return $ W.current ws : W.visible ws
    |> map (W.tag . W.workspace)
    |> filter (\tag -> monitor == fromIntegral (IS.unmarshallS tag))
    |> map IS.unmarshallW


notify :: MonadIO m => String -> String -> m ()
notify notificationTitle notificationMsg = safeSpawn "notify-send" [notificationTitle, notificationMsg]


ifLayoutIs :: String -> X a -> X a -> X a
ifLayoutIs layoutAName = ifLayoutName (== layoutAName)

ifLayoutName :: (String -> Bool) -> X a -> X a -> X a
ifLayoutName check onLayoutA onLayoutB = do
  layout <- getActiveLayoutDescription
  if (check layout) then onLayoutA else onLayoutB

-- | Get the name of the active layout.
getActiveLayoutDescription :: X String
getActiveLayoutDescription = (description . W.layout . W.workspace . W.current) <$> gets windowset



-- }}}



unsafeGetXrdbValue :: String -> String
unsafeGetXrdbValue = unsafePerformIO . getXrdbValue

getXrdbValue :: String -> IO String
getXrdbValue key = fromMaybe "" . findValue key <$> runProcessWithInput "xrdb" ["-query"] ""
  where
    findValue :: String -> String -> Maybe String
    findValue xresKey xres =
      snd <$> ( Data.List.find ((== xresKey) . fst)
                $ catMaybes
                $ splitAtColon
                <$> lines xres
              )

    splitAtColon :: String -> Maybe (String, String)
    splitAtColon str = splitAtTrimming str <$> (Data.List.elemIndex ':' str)

    splitAtTrimming :: String -> Int -> (String, String)
    splitAtTrimming str idx = bimap trim (trim . tail) $ splitAt idx str



fuckshit = getActiveLayoutDescription >>= debugShit

debugShit :: MonadIO m => String -> m ()
debugShit x = spawn $ "notify-send 'Debug' '" ++ x ++ "'"



lastLayout :: X ()
lastLayout = lastLayout' 123
  where
    lastLayout' :: Int -> X ()
    lastLayout' 0 = pure ()
    lastLayout' n = sendMessage NextLayout >> lastLayout' (n - 1)







(!?) :: [a] -> Int -> Maybe a
(!?) [] _     = Nothing
(!?) (x:_) 0  = Just x
(!?) (_:xs) n
  | n > 0     = xs !? (n - 1)
  | otherwise = Nothing

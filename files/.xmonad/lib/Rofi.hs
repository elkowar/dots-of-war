{-# LANGUAGE RecordWildCards, OverloadedStrings #-}
module Rofi
  ( asCommand
  , promptSimple
  , promptMap
  , promptRunCommand
  , showNormal
  , showCombi
  , smallTheme
  , bigTheme
  , RofiConfig(..)
  )
where

import           Data.List                      ( intercalate )
import qualified Data.Map                      as M
import           XMonad
import qualified XMonad.Util.Dmenu             as Dmenu
import qualified XMonad.Actions.Commands       as XCommands

rofiCmd :: String
rofiCmd = "rofi"

data RofiConfig
  = RofiConfig { theme :: String, caseInsensitive :: Bool, fuzzy :: Bool } deriving (Show, Eq)

instance Default RofiConfig where
  def = RofiConfig { theme = smallTheme, caseInsensitive = True, fuzzy = True }

smallTheme :: String
smallTheme = "/home/leon/scripts/rofi/launcher_grid_style.rasi"

bigTheme :: String
bigTheme = "/home/leon/scripts/rofi/launcher_grid_full_style.rasi"

toArgList :: RofiConfig -> [String]
toArgList RofiConfig {..} = concat
  [ ["-theme", theme]
  , addIf caseInsensitive ["-i"]
  , addIf fuzzy           ["-matching", "fuzzy"]
  ]
  where addIf check list = if check then list else []



-- |given an array of arguments, generate a string that would call rofi with the configuration and arguments
asCommand :: RofiConfig -> [String] -> String
asCommand config args = unwords $ rofiCmd : toArgList config ++ args

-- |Let the user choose an element of a list
promptSimple :: MonadIO m => RofiConfig -> [String] -> m String
promptSimple config = Dmenu.menuArgs rofiCmd ("-dmenu" : toArgList config)

-- |Let the user choose an entry of a map by key. return's the chosen value.
promptMap :: MonadIO m => RofiConfig -> M.Map String a -> m (Maybe a)
promptMap config = Dmenu.menuMapArgs rofiCmd ("-dmenu" : toArgList config)

-- |Display a list of commands, of which the chosen one will be executed. See `Xmonad.Actions.Commands.runCommandConfig`
promptRunCommand :: RofiConfig -> [(String, X ())] -> X ()
promptRunCommand config = XCommands.runCommandConfig (Rofi.promptSimple config)

-- |prompt a single rofi mode. ex: `showNormal def "run"`
showNormal :: RofiConfig -> String -> X ()
showNormal config mode =
  spawn $ asCommand config ["-modi " ++ mode, "-show " ++ mode]

-- |Show a rofi combi prompt, combining all given modes
showCombi :: RofiConfig -> [String] -> X ()
showCombi config modi = spawn
  $ asCommand config ["-show combi", "-combi-modi " ++ intercalate "," modi]

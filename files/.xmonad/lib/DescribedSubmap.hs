{-# LANGUAGE FlexibleContexts #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures -fno-warn-unused-binds #-}

module DescribedSubmap
  ( describedSubmap
  )
where

import           XMonad.Util.Run                ( spawnPipe )
import           XMonad.Util.EZConfig           ( mkKeymap )
import           XMonad
import           XMonad.Actions.Submap          ( submap )
import qualified System.IO                     as SysIO



describedSubmap :: String -> [(String, String, X ())] -> X ()
describedSubmap submapTitle mappings = do
  conf <- asks config
  let generatedSubmap =
        submap $ mkKeymap conf $ map (\(k, _, a) -> (k, a)) mappings
  promptDzenWhileRunning submapTitle descriptions generatedSubmap
  where descriptions = map (\(k, desc, _) -> "<" ++ k ++ "> " ++ desc) mappings


-- | run a dzen prompt with the given title and lines for as long as the given `X` action is running
promptDzenWhileRunning :: String -> [String] -> X a -> X a
promptDzenWhileRunning promptTitle options action = do
  handle <-
    spawnPipe
    $  "sleep 1 && dzen2 -e onstart=uncollapse -l "
    ++ lineCount
    ++ " -fn '"
    ++ font
    ++ "'"
  io $ SysIO.hPutStrLn handle (unlines $ promptTitle : options)
  result <- action
  io $ SysIO.hClose handle
  return result
 where
  lineCount = show $ length options
  font      = "-*-iosevka-medium-r-s*--16-87-*-*-*-*-iso10???-1"




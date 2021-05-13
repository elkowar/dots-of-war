
{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module MultiColumns where

import XMonad
import qualified XMonad.StackSet as W

import Control.Monad




data FlexiColumns = FlexiColumns { colRows :: [Int] }

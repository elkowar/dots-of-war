{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  XMonad.Layout.MultiColumns
-- Copyright   :  (c) Anders Engstrom <ankaan@gmail.com>
-- License     :  BSD3-style (see LICENSE)
--
-- Maintainer  :  Anders Engstrom <ankaan@gmail.com>
-- Stability   :  unstable
-- Portability :  unportable
--
-- This layout tiles windows in a growing number of columns. The number of
-- windows in each column can be controlled by messages.
-----------------------------------------------------------------------------

module MultiColumns (
                              -- * Usage
                              -- $usage

                              multiCol,
                              MultiCol,
                             ) where

import XMonad
import qualified XMonad.StackSet as W

import Control.Monad

-- $usage
-- You can use this module with the following in your @~\/.xmonad\/xmonad.hs@:
--
-- > import XMonad.Layout.MultiColumns
--
-- Then edit your @layoutHook@ by adding the multiCol layout:
--
-- > myLayouts = multiCol [1] 4 0.01 0.5 ||| etc..
-- > main = xmonad def { layoutHook = myLayouts }
--
-- Or alternatively:
--
-- > myLayouts = Mirror (multiCol [1] 2 0.01 (-0.25)) ||| etc..
-- > main = xmonad def { layoutHook = myLayouts }
--
-- The maximum number of windows in a column can be controlled using the
-- IncMasterN messages and the column containing the focused window will be
-- modified. If the value is 0, all remaining windows will be placed in that
-- column when all columns before that has been filled.
--
-- The size can be set to between 1 and -0.5. If the value is positive, the
-- master column will be of that size. The rest of the screen is split among
-- the other columns. But if the size is negative, it instead indicates the
-- size of all non-master columns and the master column will cover the rest of
-- the screen. If the master column would become smaller than the other
-- columns, the screen is instead split equally among all columns. Therefore,
-- if equal size among all columns are desired, set the size to -0.5.
--
-- For more detailed instructions on editing the layoutHook see:
--
-- "XMonad.Doc.Extending#Editing_the_layout_hook"

-- | Layout constructor.
multiCol
  :: [Int]    -- ^ Windows in each column, starting with master. Set to 0 to catch the rest.
  -> Int      -- ^ Default value for all following columns.
  -> Rational -- ^ How much to change size each time.
  -> MultiCol a
multiCol n defn ds = MultiCol (map (max 0) n) (max 0 defn) ds [0.25, 0.25, 0.25, 0.25] 0

data MultiCol a = MultiCol
  { multiColNWin      :: ![Int]
  , multiColDefWin    :: !Int
  , multiColDeltaSize :: !Rational
  , multiColSize      :: ![Rational]
  , multiColActive    :: !Int
  } deriving (Show,Read,Eq)

instance LayoutClass MultiCol a where
    doLayout l r s = return (combine s rlist, resl)
        where rlist = doL (multiColSize l') (multiColNWin l') r wlen
              wlen = length $ W.integrate s
              -- Make sure the list of columns is big enough and update active column
              nw = multiColNWin l ++ repeat (multiColDefWin l)
              newMultiColNWin = take (max (length $ multiColNWin l) $ getCol (wlen-1) nw + 1) nw
              newColCnt = length newMultiColNWin - length (multiColNWin l)
              l' = l { multiColNWin = newMultiColNWin
                     , multiColActive = getCol (length $ W.up s) nw
                     , multiColSize = if newColCnt >= 0 then normalizeFractions $ multiColSize l ++ replicate newColCnt 0.5
                                                       else normalizeFractions $ reverse . drop (abs newColCnt) $ reverse (multiColSize l)
                     }
              -- Only return new layout if it has been modified
              resl = if l'==l
                     then Nothing
                     else Just l'
              combine (W.Stack foc left right) rs = zip (foc : reverse left ++ right) $ raiseFocused (length left) rs
    handleMessage l m =
        return $ msum [ fmap resize     (fromMessage m)
                      , fmap incmastern (fromMessage m) ]
            where 
                  resize Shrink = l { multiColSize = changeFractionAt (\x -> x - delta) activeCol (multiColSize l)}
                  resize Expand = l { multiColSize = changeFractionAt (+ delta) activeCol (multiColSize l)}

                  --resize Shrink = l { multiColSize = max (-0.5) $ s-ds }
                  --resize Expand = l { multiColSize = min 1 $ s+ds }
                  incmastern (IncMasterN x) = l { multiColNWin = take activeCol n ++ [newval] ++ tail r }
                      where newval =  max 0 $ head r + x
                            r = drop activeCol n
                  n = multiColNWin l
                  delta = multiColDeltaSize l
                  activeCol = multiColActive l
    description _ = "MultiCol"

raiseFocused :: Int -> [a] -> [a]
raiseFocused n xs = actual ++ before ++ after
    where (before,rest) = splitAt n xs
          (actual,after) = splitAt 1 rest

-- | Get which column a window is in, starting at 0.
getCol :: Int -> [Int] -> Int
getCol w (n:ns) = if n<1 || w < n
                  then 0
                  else 1 + getCol (w-n) ns
-- Should never occur...
getCol _ _ = -1



doL :: [Rational] -> [Int] -> Rectangle -> Int -> [Rectangle]
doL ratios nwin r n = rlist
    where -- Number of columns to tile
          ncol = getCol (n-1) nwin + 1
          -- Compute the actual size
          --size = floor $ abs s * fromIntegral (rect_width r)
          -- Extract all but last column to tile
          c = take (ncol-1) nwin
          -- Compute number of windows in last column and add it to the others
          col = c ++ [n-sum c]
          -- Compute width of columns
          --width = if s>0
                  --then if ncol==1
                       ---- Only one window
                       --then [fromIntegral $ rect_width r]
                       ---- Give the master it's space and split the rest equally for the other columns
                       --else size:replicate (ncol-1) ((fromIntegral (rect_width r) - size) `div` (ncol-1))
                  --else if fromIntegral ncol * abs s >= 1
                       ---- Split equally
                       --then replicate ncol $ fromIntegral (rect_width r) `div` ncol
                       ---- Let the master cover what is left...
                       --else (fromIntegral (rect_width r) - (ncol-1)*size):replicate (ncol-1) size
          -- Compute the horizontal position of columns
          xpos = accumEx (fromIntegral $ rect_x r) width
          -- Exclusive accumulation
          accumEx a (x:xs) = a:accumEx (a+x) xs
          accumEx _ _ = []
          -- Create a rectangle for each column
          cr = zipWith (\x w -> r { rect_x=floor x, rect_width=floor w }) xpos width
          -- Split the columns into the windows
          rlist = concat $ zipWith splitVertically col cr

          width = map (fromIntegral rw *) ratios
            where Rectangle _ _ rw _ = r








normalizeFractions :: Fractional a => [a] -> [a]
normalizeFractions list = map (/ total) list
  where total = sum list


changeFractionAt :: Fractional a => (a -> a) -> Int -> [a] -> [a]
changeFractionAt update idx list = normalizeFractions $ updateAt update idx (normalizeFractions list)



updateAt :: (a -> a) -> Int -> [a] -> [a]
updateAt _ _ [] = []
updateAt f 0 (x:xs) = f x : xs
updateAt f n (x:xs) = x : updateAt f (n - 1) xs

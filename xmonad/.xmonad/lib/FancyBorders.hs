{-# LANGUAGE TypeSynonymInstances, MultiParamTypeClasses, ScopedTypeVariables #-}
module FancyBorders
  ( FancyBordersTheme(..)
  , FancyBorders
  , fancyBorders
  , defaultFancyBorders
  , defaultFancyTheme
  )
where

import           XMonad
import           XMonad.Layout.LayoutModifier

defaultFancyTheme :: FancyBordersTheme
defaultFancyTheme = FancyBordersTheme "#303030" 1

data FancyBordersTheme = FancyBordersTheme {
                        outerColor :: String,
                        intBorderWidth:: Integer
                     } deriving (Show, Read)

newtype FancyBorders a = FancyBorders FancyBordersTheme
    deriving (Show, Read)

instance LayoutModifier FancyBorders Window where
  handleMess (FancyBorders cfg) m
    | Just (_ :: Event) <- fromMessage m =  withFocused (drawFocusedWindow cfg)
    >> return Nothing
    | otherwise = return Nothing

  redoLayout (FancyBorders cfg) _ _ wrs = do
    mapM_ (flip (drawFancyBorder cfg) False) wrs
    return (wrs, Nothing)

defaultFancyBorders :: l a -> ModifiedLayout FancyBorders l a
defaultFancyBorders = ModifiedLayout (FancyBorders defaultFancyTheme)

fancyBorders :: FancyBordersTheme -> l a -> ModifiedLayout FancyBorders l a
fancyBorders t = ModifiedLayout (FancyBorders t)

drawFocusedWindow :: FancyBordersTheme -> Window -> X ()
drawFocusedWindow cfg win = do
  dpy                   <- asks display
  bw                    <- asks (borderWidth . config)
  (_, x, y, w, h, _, _) <- io $ getGeometry dpy win
  drawFancyBorder cfg (win, Rectangle x y (w + 2 * bw) (h + 2 * bw)) True

drawFancyBorder :: FancyBordersTheme -> (Window, Rectangle) -> Bool -> X ()
drawFancyBorder cfg (win, rect) active = do
  bw  <- asks (borderWidth . config)
  dpy <- asks display
  nbc <- asks normalBorder
  fbc <- asks focusedBorder
  let w    = rect_width rect - 2 * bw
      h    = rect_height rect - 2 * bw
      fw   = rect_width rect
      fh   = rect_height rect
      ibw' = fromIntegral $ intBorderWidth cfg
      ibw  = if ibw' >= bw then 1 else ibw'
      rects =
        [ Rectangle (fromIntegral w) 0                ibw       (h + ibw)
        , Rectangle (fromIntegral fw - fromIntegral ibw) 0 ibw (h + ibw)
        , Rectangle 0                (fromIntegral h) (w + ibw) ibw
        , Rectangle 0 (fromIntegral fh - fromIntegral ibw) (w + ibw) ibw
        , Rectangle (fromIntegral fw - fromIntegral ibw)
                    (fromIntegral fh - fromIntegral ibw)
                    ibw
                    ibw
        ]

  io $ do
    pix               <- createPixmap dpy win fw fh 24
    gc                <- createGC dpy win
    (Just outerPixel) <- io $ initColor dpy $ outerColor cfg

    -- outer border
    setForeground dpy gc outerPixel
    fillRectangle dpy pix gc 0 0 fw fh

    -- inner border
    setForeground dpy gc $ if active then fbc else nbc
    io $ fillRectangles dpy pix gc rects

    setWindowBorderPixmap dpy win pix
    freeGC dpy gc
    freePixmap dpy pix


{-# LANGUAGE NamedFieldPuns #-}
module WindowSwallowing
  ( swallowEventHook
  )
where
import           XMonad
import qualified XMonad.StackSet               as W
import qualified XMonad.Util.ExtensibleState   as XS
import           XMonad.Util.Run                ( runProcessWithInput )
import           XMonad.Util.WindowProperties
import           Data.Semigroup                 ( All(..) )
import qualified Data.Map.Strict               as M
import           Data.List                      ( isInfixOf )
import           Control.Monad                  ( when )

swallowEventHook :: [Query Bool] -> [Query Bool] -> Event -> X All
swallowEventHook parentQueries childQueries event = do
  case event of
    ConfigureEvent{} -> withWindowSet
      ( XS.modify
      . setStackBeforeWindowClosing
      . W.stack
      . W.workspace
      . W.current
      )
    (DestroyWindowEvent _ _ _ _ eventId childWindow) ->
      when (eventId == childWindow) $ do
        swallowedParent <- XS.gets (getSwallowedParent childWindow)
        maybeOldStack   <- XS.gets stackBeforeWindowClosing
        case (swallowedParent, maybeOldStack) of
          (Just parent, Just oldStack) -> do
            windows
              ( updateStack (const $ Just $ oldStack { W.focus = parent })
              . onWorkspace "NSP" (W.delete' parent)
              )
            XS.modify
              (removeSwallowed childWindow . setStackBeforeWindowClosing Nothing
              )
          _ -> return ()
        return ()

    (MapRequestEvent _ _ _ _ _ newWindow) -> withFocused $ \focused -> do
      parentMatches <- mapM (`runQuery` focused) parentQueries
      childMatches  <- mapM (`runQuery` newWindow) childQueries
      when (or parentMatches && or childMatches) $ do
        newWindowPid <- getProp32s "_NET_WM_PID" newWindow
        oldWindowPid <- getProp32s "_NET_WM_PID" focused
        case (oldWindowPid, newWindowPid) of
          (Just (oldPid : _), Just (newPid : _)) -> do
            isChild <-
              liftIO $ fromIntegral newPid `isChildOf` fromIntegral oldPid
            when isChild $ do
              -- TODO use https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Layout-Hidden.html
              windows
                ( updateStack (fmap (\x -> x { W.focus = newWindow }))
                . onWorkspace "NSP" (W.insertUp focused)
                )
              XS.modify (addSwallowedParent focused newWindow)
          _ -> return ()
        return ()
    _ -> return ()
  return $ All True
 where
  updateStack f ws = ws
    { W.current = (W.current ws)
                    { W.workspace = (W.workspace $ W.current ws)
                                      { W.stack = f
                                                  . W.stack
                                                  . W.workspace
                                                  . W.current
                                                  $ ws
                                      }
                    }
    }

  onWorkspace
    :: (Eq i, Eq s)
    => i
    -> (W.StackSet i l a s sd -> W.StackSet i l a s sd)
    -> (W.StackSet i l a s sd -> W.StackSet i l a s sd)
  onWorkspace n f s = W.view (W.currentTag s) . f . W.view n $ s

  isChildOf :: Int -> Int -> IO Bool
  isChildOf child parent = do
    output <- runProcessWithInput "pstree" ["-T", "-p", show parent] ""
    return $ any (show child `isInfixOf`) $ lines output


data SwallowingState =
  SwallowingState
    { currentlySwallowed :: M.Map Window Window, -- ^ mapping from child window window to the currently swallowed parent window
      stackBeforeWindowClosing :: Maybe (W.Stack Window) -- ^ current stack state right before DestroyWindowEvent is sent
    } deriving (Typeable, Show)

getSwallowedParent :: Window -> SwallowingState -> Maybe Window
getSwallowedParent win SwallowingState { currentlySwallowed } =
  M.lookup win currentlySwallowed

addSwallowedParent :: Window -> Window -> SwallowingState -> SwallowingState
addSwallowedParent parent child s@SwallowingState { currentlySwallowed } =
  s { currentlySwallowed = M.insert child parent currentlySwallowed }

removeSwallowed :: Window -> SwallowingState -> SwallowingState
removeSwallowed child s@SwallowingState { currentlySwallowed } =
  s { currentlySwallowed = M.delete child currentlySwallowed }

setStackBeforeWindowClosing
  :: Maybe (W.Stack Window) -> SwallowingState -> SwallowingState
setStackBeforeWindowClosing stack s = s { stackBeforeWindowClosing = stack }


instance ExtensionClass SwallowingState where
  initialValue = SwallowingState { currentlySwallowed       = mempty
                                 , stackBeforeWindowClosing = Nothing
                                 }

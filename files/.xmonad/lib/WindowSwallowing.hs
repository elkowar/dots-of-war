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
import qualified XMonad.Layout.Hidden          as Hidden


swallowEventHook :: [Query Bool] -> [Query Bool] -> Event -> X All
swallowEventHook parentQueries childQueries event = do
  case event of
    ConfigureEvent{} -> withWindowSet $ \ws -> do
      XS.modify . setStackBeforeWindowClosing . currentStack $ ws
      XS.modify . setFloatingBeforeWindowClosing . W.floating $ ws

    DestroyWindowEvent { ev_event = eventId, ev_window = childWindow } ->
      when (eventId == childWindow) $ do
        maybeSwallowedParent <- XS.gets (getSwallowedParent childWindow)
        maybeOldStack        <- XS.gets stackBeforeWindowClosing
        oldFloating          <- XS.gets floatingBeforeClosing
        case (maybeSwallowedParent, maybeOldStack) of
          (Just parent, Just oldStack) -> do
            Hidden.popHiddenWindow parent
            windows
              (\ws ->
                updateCurrentStack
                    (const $ Just $ oldStack { W.focus = parent })
                  $ copyFloatingState childWindow parent
                  $ ws { W.floating = oldFloating }
              )
            XS.modify $ removeSwallowed childWindow
            XS.modify $ setStackBeforeWindowClosing Nothing
          _ -> return ()
        return ()

    MapRequestEvent { ev_window = childWindow } ->
      withFocused $ \parentWindow -> do
        parentMatches <- mapM (`runQuery` parentWindow) parentQueries
        childMatches  <- mapM (`runQuery` childWindow) childQueries
        when (or parentMatches && or childMatches) $ do
          childWindowPid  <- getProp32s "_NET_WM_PID" childWindow
          parentWindowPid <- getProp32s "_NET_WM_PID" parentWindow
          case (parentWindowPid, childWindowPid) of
            (Just (parentPid : _), Just (childPid : _)) -> do
              isChild <- liftIO $ fi childPid `isChildOf` fi parentPid
              when isChild $ do
                windows
                  (updateCurrentStack (fmap (\x -> x { W.focus = childWindow }))
                  . copyFloatingState parentWindow childWindow
                  )
                XS.modify (addSwallowedParent parentWindow childWindow)
                Hidden.hideWindow parentWindow
            _ -> return ()
          return ()
    _ -> return ()
  return $ All True


updateCurrentStack
  :: (Maybe (W.Stack a) -> Maybe (W.Stack a))
  -> W.StackSet i l a sid sd
  -> W.StackSet i l a sid sd
updateCurrentStack f ws = ws
  { W.current = (W.current ws)
    { W.workspace = currentWsp { W.stack = f $ currentStack ws }
    }
  }
  where currentWsp = W.workspace $ W.current ws

currentStack :: W.StackSet i l a sid sd -> Maybe (W.Stack a)
currentStack = W.stack . W.workspace . W.current

copyFloatingState
  :: Ord a => a -> a -> W.StackSet i l a s sd -> W.StackSet i l a s sd
copyFloatingState from to ws = ws
  { W.floating = maybe (M.delete to (W.floating ws))
                       (\r -> M.insert to r (W.floating ws))
                       (M.lookup from (W.floating ws))
  }


-- | check if a given process is a child of another process. This depends on "pstree" being in the PATH
-- NOTE: this does not work if the child process does any kind of process-sharing.
isChildOf
  :: Int -- ^ child PID
  -> Int -- ^ parent PID
  -> IO Bool
isChildOf child parent = do
  output <- runProcessWithInput "pstree" ["-T", "-p", show parent] ""
  return $ any (show child `isInfixOf`) $ lines output


data SwallowingState =
  SwallowingState
    { currentlySwallowed :: M.Map Window Window -- ^ mapping from child window window to the currently swallowed parent window
    , stackBeforeWindowClosing :: Maybe (W.Stack Window) -- ^ current stack state right before DestroyWindowEvent is sent
    , floatingBeforeClosing :: M.Map Window W.RationalRect -- ^ floating map of the stackset right before DestroyWindowEvent is sent
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

setFloatingBeforeWindowClosing
  :: M.Map Window W.RationalRect -> SwallowingState -> SwallowingState
setFloatingBeforeWindowClosing x s = s { floatingBeforeClosing = x }

instance ExtensionClass SwallowingState where
  initialValue = SwallowingState { currentlySwallowed       = mempty
                                 , stackBeforeWindowClosing = Nothing
                                 , floatingBeforeClosing    = mempty
                                 }


fi :: (Integral a, Num b) => a -> b
fi = fromIntegral
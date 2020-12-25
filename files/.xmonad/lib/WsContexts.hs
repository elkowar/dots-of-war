module WsContexts where

import Data.List (foldl', nub)
import qualified Data.List
import Data.List.NonEmpty ((<|), NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import XMonad
import qualified XMonad.StackSet as W
import qualified XMonad.Util.ExtensibleState as XS

createWorkspace :: Layout Window -> WorkspaceId -> W.Workspace WorkspaceId (Layout Window) a
createWorkspace layout name =
  W.Workspace
    { W.tag = name,
      W.layout = layout,
      W.stack = Nothing
    }

addWorkspaces :: [W.Workspace i l a] -> W.StackSet i l a s sid -> W.StackSet i l a s sid
addWorkspaces new ws = foldl' (flip addNewWorkspace) ws new
  where
    addNewWorkspace :: W.Workspace i l a -> W.StackSet i l a s sid -> W.StackSet i l a s sid
    addNewWorkspace newWorkspace stackset =
      stackset
        { W.current = (W.current stackset) {W.workspace = newWorkspace},
          W.hidden = W.workspace (W.current stackset) : W.hidden stackset
        }


wsContextView :: WorkspaceId -> X ()
wsContextView wspId = do
  (WsContext currentCtx) <- XS.gets (NE.head . contexts)
  windows (W.view $ annotateWspId currentCtx wspId)

pushContext :: WsContext -> X ()
pushContext ctx = updateContexts $ \ctxState -> ctxState { contexts = ctx <| contexts ctxState }


-- TODO: working dir
newtype WsContext = WsContext String
  deriving (Show, Eq)

data WsContextsState = WsContextsState
  { contexts :: NonEmpty WsContext,
    stickies :: [WorkspaceId]
  }
  deriving (Typeable, Show)

wsContexts :: XConfig l -> XConfig l
wsContexts conf = conf {workspaces = map (annotateWspId "default") (workspaces conf)}

instance ExtensionClass WsContextsState where
  initialValue =
    WsContextsState
      { contexts = WsContext "default" :| [],
        stickies = []
      }

updateContexts :: (WsContextsState -> WsContextsState) -> X ()
updateContexts update = do
  oldState <- XS.get
  let newState = update oldState
  if NE.head (contexts oldState) /= NE.head (contexts newState)
    then applyWorkspaceContext $ NE.head (contexts oldState)
    else pure ()

annotateWspId :: String -> WorkspaceId -> WorkspaceId
annotateWspId contextName wspId = wspId ++ "<" ++ contextName ++ ">"

unannotateWspId :: WorkspaceId -> (WorkspaceId, String)
unannotateWspId wspId =
  let (actualId, rest) = splitWhere (== '<') wspId
   in (actualId, takeWhile (/= '>') rest)

applyWorkspaceContext :: WsContext -> X ()
applyWorkspaceContext context = do
  contextAlreadyOpen <- withWindowSet $ pure . any (wspMatchesContext context) . W.workspaces
  if contextAlreadyOpen
    then windows (switchToWorkspacesOf context)
    else initializeWorkspacesFor context

initializeWorkspacesFor :: WsContext -> X ()
initializeWorkspacesFor context = do
  defaultLayout <- asks (layoutHook . config)
  windows $ \ws -> addWorkspaces (map (createWorkspace defaultLayout) (baseWorkspaceNames ws)) ws
  windows (switchToWorkspacesOf context)

baseWorkspaceNames :: W.StackSet WorkspaceId l a s sid -> [WorkspaceId]
baseWorkspaceNames = nub . fmap (fst . unannotateWspId . W.tag) . W.workspaces

switchToWorkspacesOf :: Eq s => WsContext -> W.StackSet WorkspaceId l a s sid -> W.StackSet WorkspaceId l a s sid
switchToWorkspacesOf (WsContext context) ws =
  let (currentWspName, _) = unannotateWspId $ W.currentTag ws
   in W.view (annotateWspId context currentWspName) ws

wspMatchesContext :: WsContext -> W.Workspace WorkspaceId l a -> Bool
wspMatchesContext (WsContext context) wsp = (snd . unannotateWspId $ W.tag wsp) == context

findWorkspaceByTag :: (i -> Bool) -> W.StackSet i l a s sid -> Maybe (W.Workspace i l a)
findWorkspaceByTag cond = Data.List.find (cond . W.tag) . W.workspaces

splitWhere :: (a -> Bool) -> [a] -> ([a], [a])
splitWhere cond list =
  ( takeWhile (not . cond) list,
    goodTail $ dropWhile (not . cond) list
  )

goodTail :: [a] -> [a]
goodTail [] = []
goodTail (_ : xs) = xs



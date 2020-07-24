module Utils where

-- import System.Posix.Unistd (nodeName, getSystemID)

import Data.Maybe (maybeToList)
import Control.Monad (join, when)

import XMonad
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (safeRunInTerm)
import XMonad.Actions.Eval (evalExpression, defaultEvalConfig)
import XMonad.Prompt.Input (inputPrompt)
-- import XMonad.Util.Cursor (setDefaultCursor)

startupHook' :: X ()
startupHook' = do
  -- setDefaultCursor xC_left_ptr
  spawnOnce "xsetroot -xcf $HOME/.icons/Atto-cursor/cursors/default 16"
  safeRunInTerm "" "calcurse"
  -- setFullscreenSupported
  addEWMHFullscreen

-- hack to let firefox fullscreen
setFullscreenSupported :: X ()
setFullscreenSupported = withDisplay \disp -> do
  root <- asks theRoot
  netSupported <- getAtom "_NET_SUPPORTED"
  atom <- getAtom "ATOM"
  supp <- mapM getAtom [ "_NET_WM_STATE_HIDDEN"
                       , "_NET_WM_STATE_FULLSCREEN" -- XXX Copy-pasted to add this line
                       , "_NET_NUMBER_OF_DESKTOPS"
                       , "_NET_CLIENT_LIST"
                       , "_NET_CLIENT_LIST_STACKING"
                       , "_NET_CURRENT_DESKTOP"
                       , "_NET_DESKTOP_NAMES"
                       , "_NET_ACTIVE_WINDOW"
                       , "_NET_WM_DESKTOP"
                       , "_NET_WM_STRUT"
                       ]
  io . changeProperty32 disp root netSupported atom propModeReplace $ fromIntegral <$> supp
  setWMName "xmonad"

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
  wms <- getAtom "_NET_WM_STATE"
  wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
  mapM_ addNETSupported [wms, wfs]
    where
      addNETSupported :: Atom -> X ()
      addNETSupported x = withDisplay $ \dpy -> do
        r               <- asks theRoot
        a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
        a               <- getAtom "ATOM"
        liftIO do
          sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
          when (fromIntegral x `notElem` sup) $
            changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]


hsPrompt :: X ()
hsPrompt = inputPrompt def "Eval"
  >>= flip whenJust (evalExpression defaultEvalConfig)

-- hostname = nodeName <$> getSystemID

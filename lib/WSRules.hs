module WSRules where

import XMonad
import XMonad.Hooks.ManageHelpers (isDialog
                                 , isFullscreen
                                 , doCenterFloat
                                 , doFullFloat)
import XMonad.StackSet (shift
                      , shiftMaster
                      , RationalRect(..))
import XMonad.Util.NamedScratchpad (namedScratchpadManageHook)
import XMonad.Layout.NoBorders (hasBorder)
import XMonad.Util.NamedScratchpad (NamedScratchpad(..), customFloating)

-- import XMonad.Actions.PhysicalScreens

manageHook' :: ManageHook
manageHook' = composeAll . concat $
      -- shift to workspace
  [ [ className =? w --> viewShift "ffox" | w <- [ "Firefox"
                                                 ] ]

  , [ className =? w --> viewShift "term" | w <- [ "Vim"
                                                 ] ]

  , [ className =? w --> doFloat | w <- [ "imv"
                                        , "feh"
                                        , "dde-polkit-dialog"
                                        , "Gimp"
                                        ] ]

  , [ appName =? w --> doFloat | w <- [ "file_progress"
                                      ] ]

  , [ (className =? c <&&> appName =? i) --> doFloat
      | (c, i) <- [ ("Firefox", "Dialog")
                  , ("Firefox", "Plugin-container")
                  ] ]

  , [ scratchpads
    , isFullscreen --> doFullFloat <> hasBorder False
    , isDialog <||> isPopup --> doMasterFloat
    ]
  ]
    where
      viewShift = doF . shift

doMasterFloat :: ManageHook
doMasterFloat = doCenterFloat <> (doF shiftMaster)
isPopup :: Query Bool
isPopup = stringProperty "WM_WINDOW_ROLE" =? "popup"

-- RationalRect left top width height
scratchpads :: ManageHook
scratchpads = namedScratchpadManageHook [
    NS "gvim" "gvim" (className =? "Gvim")
        (customFloating $ RationalRect (1/3) (4/5) (1/3) (1/3))
  , NS "term" "alacritty --class 'scratchterm' --command 'tmux new -s scratch'" (className =? "scratchterm")
        (customFloating $ RationalRect 0.25 0.015 0.5 0.4)
  ]

mediaShiftC :: [String]
mediaShiftC = [ "Transmission" ]

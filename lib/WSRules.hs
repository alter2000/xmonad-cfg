module WSRules where

import XMonad
import XMonad.Hooks.ManageHelpers (isDialog
                                 , isFullscreen
                                 , doCenterFloat
                                 , doFullFloat)
import XMonad.Hooks.ManageDocks (manageDocks)
import XMonad.StackSet (shift
                      , shiftMaster
                      , RationalRect(..))
import XMonad.Util.Scratchpad (scratchpadManageHook)
import XMonad.Actions.PhysicalScreens

manageHook' = composeAll . concat $
    [
      [ className =? w --> viewShift "ffox" | w <- ffoxShiftC ]
    , [ className =? w --> viewShift "term" | w <- termShiftC ]
    , [ className =? w --> doFloat | w <- floatsC ]
    , [ resource  =? w --> doFloat | w <- floatsI ]
    , [ (className =? (fst w) <&&> resource =? (snd w)) --> doFloat | w <- floatsCI ]
    , [ isDialog <||> isPopup --> doMasterFloat ]
    , [ (isFullscreen --> doFullFloat) ]
    , [ manageDocks ]
    , [ dropdownTerminal ]
    ]
    where
        doMasterFloat = doCenterFloat <+> (doF shiftMaster)
        isPopup = stringProperty "WM_WINDOW_ROLE" =? "popup"
        viewShift = doF . shift
        -- shift to workspace
        ffoxShiftC  = [ "Firefox" ]
        termShiftC  = [ "Vim" ]
        mediaShiftC = [ "Transmission" ]
        -- floating classes/instances/both
        floatsC  = [ "imv", "feh", "dde-polkit-dialog", "Gimp" ]
        floatsI  = [ "file_progress" ]
        floatsCI = [ ("Firefox", "Dialog")
                   , ("Firefox", "Plugin-container")
                   ]

dropdownTerminal = scratchpadManageHook $ RationalRect tLeftPC tTopPC tWidthPC tHeightPC
    where
        tHeightPC = 0.4
        tWidthPC  = 0.5
        tTopPC    = 0.015
        tLeftPC   = 0.25

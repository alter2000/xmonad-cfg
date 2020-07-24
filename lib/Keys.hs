module Keys (
    keys'
  , mouseBindings'
  , logHook'
  ) where

import Data.Map (Map, fromList)
import Data.Function ((&))

import XMonad
import XMonad.Layout.LayoutCombinators
import XMonad.Prompt.Layout (layoutPrompt)
import XMonad.Actions.MessageFeedback hiding (send)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.ManageDocks (ToggleStruts(..))
import XMonad.Actions.PhysicalScreens (viewScreen, sendToScreen)
import XMonad.Hooks.UrgencyHook (focusUrgent)
import qualified XMonad.StackSet as W
import XMonad.Util.Run (safeSpawn, unsafeSpawn)
import XMonad.Util.CustomKeys (customKeys)
import XMonad.Actions.CycleRecentWS (cycleRecentWS)
import XMonad.Actions.SwapWorkspaces (swapWithCurrent)
import XMonad.Layout.WindowNavigation

import XMonad.Actions.FloatSnap
import XMonad.Actions.UpdatePointer (updatePointer)

import Utils (hsPrompt)
import Config

import XMonad.Hooks.FadeWindows
import XMonad.Hooks.FadeInactive


keys' :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
keys' = customKeys del ins

sh :: KeyMask
sh = shiftMask

send :: [SomeMessage] -> X ()
send = sendSomeMessages

m' :: Message a => a -> SomeMessage
m' = SomeMessage

ins :: XConfig l -> [((KeyMask, KeySym), X ())]
ins _conf@(XConfig { modMask = mm }) =
    [ ((mm, xK_d)         , safeSpawn "rofi" [ "-show", "drun" ])
    , ((mm, xK_F4)        , kill)
    , ((mm, xK_j)         , send [m' $ Go D])
    , ((mm, xK_k)         , send [m' $ Go U])
    , ((mm, xK_h)         , send [m' $ Go L])
    , ((mm, xK_l)         , send [m' $ Go R])
    , ((mm, xK_semicolon) , windows W.focusMaster)
    , ((mm .|. sh, xK_j)  , windows W.swapDown)
    , ((mm .|. sh, xK_k)  , windows W.swapUp)
    , ((mm .|. sh, xK_h)  , send [m' $ Shrink])
    , ((mm .|. sh, xK_l)  , send [m' $ Expand])
    , ((mm, xK_space)     , send [m' $ NextLayout])
    , ((mm, xK_apostrophe), windows W.swapMaster)
    , ((mm, xK_BackSpace) , focusUrgent)
    , ((mm, xK_t)         , withFocused $ windows . W.sink)
    , ((mm, xK_Tab)       , cycleRecentWS [xK_Meta_L] xK_Tab xK_grave)
    , ((mm .|. sh, xK_m)  , layoutPrompt def)

    , ((mm .|. sh, xK_r)  , unsafeSpawn "xmonad --restart")
    -- , ((mm .|. sh, xK_m)  , sendMessage $ IncMasterN (1))
    -- , ((mm .|. sh, xK_n)  , sendMessage $ IncMasterN (-1))
    -- , ((mm .|. sh, xK_q)  , io $ exitWith ExitSuccess)

    , ((mm, xK_f) , send [ m' $ Toggle FULL])
    -- , ((mm, xK_v) , send [m' $ JumpToLayout "ResizableTall", m' $ ToggleStruts])
    -- , ((mm, xK_t) , sendMessage $ JumpToLayout "Tabbed Simplest")

    -- , ((mm, xK_u), hsPrompt)
    ]

    ++ [
      ((mm .|. mask, key), windows $ fn idx)
      | (key, idx) <- allWorkspaces
      , (fn, mask) <- [(W.greedyView, 0), (W.shift, sh)]
    ]
    ++ [((m .|. mm, key), f sc)
        | (key, sc) <- zip [xK_a, xK_s, xK_d] [0..]
        -- Order screen by physical order instead of arbitrary numberings.
        , (f, m) <- [(viewScreen def, 0), (sendToScreen def, sh)]]
    ++ [((mm .|. controlMask, k), windows $ swapWithCurrent i)
        | (k, i) <- allWorkspaces]
    -- ++ [
    --   ((m .|. mm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --   | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --   , (f, m) <- [(view, 0), (shift, sh)]
    -- ]

del :: XConfig l -> [(KeyMask, KeySym)]
del XConfig { modMask = mm } =
      -- single key
     [ (mm, k) | k <- [] ]
      -- key + shift
  <> [ (mm .|. sh, k) | k <- [xK_c]]
      -- both
  <> [ (mm .|. m, k) | m <- [0, sh], k <- [xK_w, xK_e, xK_r, xK_p, xK_q]
      ]

mouseBindings' :: XConfig Layout -> Map (ButtonMask, Button) (Window -> X ())
mouseBindings' _conf@(XConfig { modMask = mm }) = fromList
    -- Set the window to floating mode and move by dragging
    [ ((mm, button1), \w -> do
        focus w
        mouseMoveWindow w
        windows W.shiftMaster
        afterDrag $ snapMagicMove snap snap w
    ), ((mm, button2), \w -> w & W.focusWindow & (W.shiftMaster .) & windows
    -- Raise the window to the top of the stack
    ), ((mm, button3), \w -> do
    -- Set the window to floating mode and resize by dragging
        focus w
        mouseResizeWindow w
        windows W.shiftMaster
    ), ((mm .|. sh, button3), \w -> do
        focus w
        mouseResizeWindow w
        afterDrag $ snapMagicResize [R,D] snap snap w
      )
    -- afterDrag (snapMagicResize [L,R,U,D] snap snap w)
    ]
      where
        snap = Just 40

logHook' :: X ()
logHook' = updatePointer (0.5, 0.5) (1.1, 1.1) -- within 110% of the edge
        >> fadeInactiveLogHook fadeHook
  where
    fadeHook = 1 --0.9

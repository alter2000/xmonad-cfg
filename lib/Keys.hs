module Keys (
    keys'
  ) where

import System.Exit (exitWith, ExitCode(ExitSuccess))
import Data.Map (Map, fromList)

import XMonad
import XMonad.Actions.PhysicalScreens (viewScreen, sendToScreen)
import XMonad.Hooks.UrgencyHook (focusUrgent)
import XMonad.StackSet (focusDown, focusUp, focusMaster,
                        swapDown, swapUp, swapMaster,
                        view, greedyView,
                        sink, shift)
import XMonad.Layout.ToggleLayouts (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Util.Run (safeSpawn, unsafeSpawn)
import XMonad.Util.CustomKeys (customKeys)

-- import Utils (hsPrompt)

keys' :: XConfig Layout -> Map (KeyMask, KeySym) (X ())
keys' = customKeys del ins

ins conf@(XConfig { modMask = mm }) =
    [ ((mm, xK_d)               , safeSpawn "rofi" [ "-show", "drun" ])
    , ((mm, xK_F4)              , kill)
    , ((mm, xK_j)               , windows focusDown)
    , ((mm, xK_k)               , windows focusUp)
    , ((mm, xK_semicolon)       , windows focusMaster)
    , ((mm .|. shiftMask, xK_j) , windows swapDown)
    , ((mm .|. shiftMask, xK_k) , windows swapUp)
    , ((mm, xK_apostrophe)      , windows swapMaster)
    , ((mm, xK_space)           , sendMessage NextLayout)
    , ((mm, xK_h)               , sendMessage Shrink)
    , ((mm, xK_l)               , sendMessage Expand)
    , ((mm, xK_BackSpace)       , focusUrgent)
    , ((mm, xK_t)               , withFocused $ windows . sink)

    , ((mm .|. shiftMask, xK_m) , sendMessage $ IncMasterN (1))
    , ((mm .|. shiftMask, xK_n) , sendMessage $ IncMasterN (-1))
    , ((mm .|. shiftMask, xK_r) , unsafeSpawn "rm -rf ~/.xmonad && xmonad --recompile && xmonad --restart")
    , ((mm .|. shiftMask, xK_q) , io (exitWith ExitSuccess))

    -- , ((mm .|. shiftMask, xK_v) , sendMessage $ JumpToLayout "Tall")
    -- , ((mm .|. shiftMask, xK_f) , sendMessage $ JumpToLayout "Full")
    -- , ((mm .|. shiftMask, xK_t) , sendMessage $ JumpToLayout "Tabbed Simplest")

    -- , ((mm, xK_u), hsPrompt)
    ]

    ++ [
      ((mm .|. mask, key), windows $ fn idx)
      | (key, idx) <- zip [ xK_1..xK_9 ] $ XMonad.workspaces conf
      , (fn, mask) <- [(greedyView, 0), (shift, shiftMask)]
    ]
    ++
      [((m .|. mm, key), f sc)
      | (key, sc) <- zip [xK_a, xK_s, xK_d] [0..]
      -- Order screen by physical order instead of arbitrary numberings.
      , (f, m) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]]
    -- ++ [
    --   ((m .|. mm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --   | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --   , (f, m) <- [(view, 0), (shift, shiftMask)]
    -- ]

del XConfig { modMask = mm } =
    [ (mm .|. shiftMask, xK_c)
    , (mm .|. shiftMask, xK_p)
    , (mm, xK_p)
    ]
    ++
    [ (mm .|. m, k) | m <- [0, shiftMask], k <- [xK_w, xK_e, xK_r] ]

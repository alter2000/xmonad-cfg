module Layouts (
    layoutHook'
  ) where
-- TODO: maybe add layouts as <leader> maps?

import XMonad
import XMonad.StackSet (RationalRect(..))

-- import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.ResizableTile (ResizableTall(..))
import XMonad.Layout.WindowArranger (windowArrange)

-- import XMonad.Layout.TwoPane

import XMonad.Layout.Gaps
-- import XMonad.Layout.Circle

-- -- one or the other _villager noises_
-- import XMonad.Layout.BinarySpacePartition
-- import XMonad.Layout.Dwindle

import XMonad.Hooks.ManageDocks (avoidStruts)

import XMonad.Util.NamedScratchpad (NamedScratchpad(..), customFloating)

layoutHook' = tilingL ||| fullL

tilingL = windowArrange ( gaps [(U, 22), (R, 0), (L, 0), (D, 0)] $
                          avoidStruts $
                          ResizableTall 1 (5/100) (2/5) [])

fullL = noBorders $ fullscreenFull Full

scratchpads = [
    NS "gvim" "gvim" (className =? "Gvim")
        (customFloating $ RationalRect (1/3) (4/5) (1/3) (1/3))
  ]

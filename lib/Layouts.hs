{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# LANGUAGE FlexibleContexts #-}

module Layouts (
    layoutHook'
  ) where
-- TODO: maybe add layouts as <leader> maps?

import Data.Function ((&))

import XMonad hiding ((|||))
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances

import XMonad.Layout.Tabbed

import XMonad.Layout.NoBorders --(noBorders, smartBorders)
import XMonad.Layout.Fullscreen (fullscreenFocus)
import XMonad.Layout.MouseResizableTile --(ResizableTall(..))
import XMonad.Layout.WindowNavigation ( configurableNavigation
                                      , navigateColor
                                      , navigateBrightness
                                      , WindowNavigation
                                      )
import XMonad.Layout.Renamed

-- import XMonad.Layout.BinarySpacePartition

import XMonad.Hooks.ManageDocks (avoidStruts, AvoidStruts)

import Config

type Borderer = (ConfigurableBorder Ambiguity)
baseMovement :: (LayoutModifier Borderer Window, LayoutClass l Window)
             => l Window ->
  (ModifiedLayout WindowNavigation
  (ModifiedLayout Borderer
  (ModifiedLayout AvoidStruts l))) Window
baseMovement = (configurableNavigation $ navigateBrightness 0.5)
            . lessBorders (Combine Difference Screen OnlyLayoutFloat)
            . avoidStruts

layoutHook' =
  mkToggle (MIRROR ?? FULL ?? EOT) $
      renamed [Replace "Tall"] tiling
  -- ||| renamed [Replace "Fullscreen"] full

tiling =
  (mouseResizableTile @Window)
    { nmaster = 1
    , fracIncrement = (5/100)
    , masterFrac = (2/5)
    , draggerType = BordersDragger
    }
  & baseMovement

full = noBorders $ fullscreenFocus Full

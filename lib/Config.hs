{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module Config (
    allWorkspaces
  , tabLayoutTheme
  ) where

import XMonad
import XMonad.Layout.Tabbed

allWorkspaces :: [(KeySym, String)]
allWorkspaces =
  [ (xK_1, "ffox")
  , (xK_2, "term")
  , (xK_3, "files")
  , (xK_4, "random")
  , (xK_9, "aux")
  , (xK_0, "media")
  ]

tabLayoutTheme :: Theme
tabLayoutTheme = def
        { activeColor = "#556064"
        , inactiveColor = "#2F3D44"
        , urgentColor = "#FDF6E3"
        , activeBorderColor = "#454948"
        , inactiveBorderColor = "#454948"
        , urgentBorderColor = "#268BD2"
        , activeTextColor = "#80FFF9"
        , inactiveTextColor = "#1ABC9C"
        , urgentTextColor = "#1ABC9C"
        , fontName = "xft:Hasklig:size=10:antialias=true"
        }


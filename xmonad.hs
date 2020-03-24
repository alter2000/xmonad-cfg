module Main where

import XMonad

import XMonad.Layout.Fullscreen (fullscreenSupport)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (docks)

import Keys (keys')
import Layouts (layoutHook')
import WSRules (manageHook')
import Utils (startupHook')


main = do
     xmonad
       . fullscreenSupport
       . ewmh
       . docks
       $ def
         { terminal    = "alacritty"
         , modMask     = mod4Mask
         , borderWidth = 0
         , workspaces  = [ "ffox", "term", "files", "random", "aux", "media" ]
         , manageHook  = manageHook'
         , startupHook = startupHook'
         , layoutHook  = layoutHook'
         , keys        = keys'
         }

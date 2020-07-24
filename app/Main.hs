{-# OPTIONS_GHC -fno-warn-missing-signatures #-}

module Main where

import XMonad

import XMonad.Layout.Fullscreen (fullscreenSupport)
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageDocks (docks)
import XMonad.Layout.NoBorders (borderEventHook)

-- import qualified DBus as D
-- import qualified DBus.Client as D

import Keys (keys', mouseBindings', logHook')
import Layouts (layoutHook')
import WSRules (manageHook')
import Utils (startupHook')

import Config

main :: IO ()
main = do

  -- dbus <- D.connectSession
  -- -- Request access to the DBus name
  -- D.requestName dbus (D.busName_ "org.xmonad.Log")
  --     [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

  xmonad opts


opts = ewmh
     . docks
     . fullscreenSupport
     $ def
       { terminal         = "alacritty"
       , modMask          = mod4Mask
       , borderWidth      = 4
       , workspaces       = snd <$> allWorkspaces
       , keys             = keys'
       , manageHook       = manageHook'
       , startupHook      = startupHook'
       , layoutHook       = layoutHook'
       , logHook          = logHook'
       , mouseBindings    = mouseBindings'
       , handleEventHook  = borderEventHook <> handleEventHook def
       }

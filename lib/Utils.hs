module Utils where

import System.Posix.Unistd (nodeName, getSystemID)

import XMonad
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Run (safeRunInTerm)
import XMonad.Actions.Eval (evalExpression, defaultEvalConfig)
import XMonad.Prompt.Input (inputPrompt)

import XMonad.Layout.Tabbed

hostname = fmap nodeName getSystemID

startupHook' = do
        spawnOnce "xsetroot -xcf $HOME/.icons/Atto-cursor/cursors/default 16"
        safeRunInTerm "" "calcurse"
        -- TODO: safeSpawn "mkfifo" or spawnPipe $ "/tmp/.xmonad-workspace-log"

{-
   polybarHook = do
     winset <- gets windowset
     let currWs = W.currentTag winset
     let wss = map W.tag $ W.workspaces winset
     let wsStr = join $ map (fmt currWs) $ sort' wss
     io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")
     where fmt currWs ws
             | currWs == ws = "[" ++ ws ++ "]"
             | otherwise    = " " ++ ws ++ " "
           sort' = sortBy (compare `on` (!! 0))
-}


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

hsPrompt = inputPrompt def "Eval" >>= flip whenJust (evalExpression defaultEvalConfig)

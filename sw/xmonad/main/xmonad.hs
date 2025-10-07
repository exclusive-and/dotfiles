{-# LANGUAGE NamedFieldPuns #-}

module Main where

import Data.Default
import Data.Map (Map)
import Data.Map qualified as Map
import System.Exit

import XMonad
import XMonad.Hooks.EwmhDesktops (
    ewmh,
    ewmhFullscreen,
  )
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Operations (
    kill,
    refresh,
    sendMessage,
    setLayout,
    windows,
    withFocused,
  )
import XMonad.StackSet qualified as StackSet
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main = xmonad $ ewmhFullscreen $ ewmh $ configuration

configuration =
  let
    layout = 
      Tall 1 (3 / 100) (2 / 3)
      |||
      Grid
      |||
      Full

    modifiers =
      avoidStruts .
      gaps [(L, 5), (R, 5), (U, 10), (D, 10)] .
      smartSpacing 2
  in
    def
      {
        borderWidth = 2
      , focusedBorderColor = "#e03f3f"
      , normalBorderColor  = "#44b88d"

      , clickJustFocuses = True
      , focusFollowsMouse = True
      , modMask = mod4Mask

      , keys = keyCommandMap
      , layoutHook = modifiers layout
      , startupHook = startupMain
      , terminal = "alacritty"
      }

startupMain :: X ()
startupMain = do
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "feh --bg-scale $HOME/wallpapers/school-sunset.png"

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
appList     = "rofi -show window -show-icons"

keyCommandMap :: XConfig Layout -> Map (ButtonMask, KeySym) (X ())
keyCommandMap conf =
  let
    XConfig
      {
        modMask
      , layoutHook
      , terminal
      , workspaces
      } = conf
  in
    Map.fromList $ concat
      [
        [((modMask, xK_h), sendMessage Shrink)]
      , [((modMask, xK_j), windows StackSet.focusDown)]
      , [((modMask, xK_k), windows StackSet.focusUp)]
      , [((modMask, xK_l), sendMessage Expand)]
      , [((modMask, xK_m), windows StackSet.focusMaster)]
      , [((modMask, xK_n), refresh)]
      , [((modMask, xK_t), withFocused $ windows . StackSet.sink)]

      , [
          ((modMask, key), windows $ StackSet.greedyView view)
            | (key, view) <- zip [xK_1 .. xK_9] workspaces
        ]

      , [((modMask, xK_comma), sendMessage (IncMasterN 1))]
      , [((modMask, xK_grave), spawn terminal)]
      , [((modMask, xK_period), sendMessage (IncMasterN (-1)))]
      , [((modMask, xK_space), sendMessage NextLayout)]
      , [((modMask, xK_Return), spawn appLauncher)]
      , [((modMask, xK_Tab), spawn appList)]

      , [((modMask .|. shiftMask, xK_c), kill)]
      , [((modMask .|. shiftMask, xK_j), windows StackSet.swapDown)]
      , [((modMask .|. shiftMask, xK_k), windows StackSet.swapUp)]

      , [
          ((modMask .|. shiftMask, key), windows $ StackSet.shift view)
            | (key, view) <- zip [xK_1 .. xK_9] workspaces
        ]

      , [((modMask .|. shiftMask, xK_space), setLayout layoutHook)]
      
      , [((modMask .|. shiftMask, xK_Escape), XMonad.io exitSuccess)]
      ]

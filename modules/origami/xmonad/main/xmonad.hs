{-# Language DisambiguateRecordFields #-}
{-# Language ImportQualifiedPost #-}
{-# Language NamedFieldPuns #-}
{-# Language NoImplicitPrelude #-}
{-# Language NoStarIsType #-}
{-# Language RankNTypes #-}
{-# Language ScopedTypeVariables #-}
{-# Language TupleSections #-}
{-# Language TypeApplications #-}

module Main where

import Prelude

import Data.Default
import Data.Map (Map)
import Data.Map qualified as Map
import System.Exit

import XMonad
import XMonad.Hooks.EwmhDesktops
  ( ewmh
  , ewmhFullscreen
  )
import XMonad.Hooks.ManageDocks
import XMonad.Layout qualified
import XMonad.Layout.Accordion qualified
import XMonad.Layout.Dishes qualified
import XMonad.Layout.Drawer qualified
import XMonad.Layout.Fullscreen qualified
import XMonad.Layout.Gaps
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed qualified
import XMonad.Operations
  ( kill
  , refresh
  , sendMessage
  , setLayout
  , windows
  , withFocused
  )
import XMonad.StackSet qualified as StackSet
import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main =
  let
    layout =
          XMonad.Layout.Full
      ||| XMonad.Layout.Tall 1 (3 / 100) (5 / 8)

    modifiers =
        avoidStruts
      . lessBorders OnlyScreenFloat
      . gaps [(L, 5), (R, 5), (U, 10), (D, 10)]
      . smartSpacing 2
  in
    xmonad $ ewmhFullscreen $ ewmh $ def
      { XMonad.startupHook = Main.startupHook
        -- Keybinds.
      , XMonad.keys = Main.keys
      , XMonad.modMask = mod4Mask
      , XMonad.terminal = "alacritty"
        -- Window properties and layout.
      , XMonad.focusedBorderColor = "#e03f3f"
      , XMonad.normalBorderColor  = "#44b88d"
      , XMonad.borderWidth = 2
      , XMonad.layoutHook = modifiers layout
        -- Mouse behaviour.
      , XMonad.clickJustFocuses = True
      , XMonad.focusFollowsMouse = True
      }

startupHook :: X ()
startupHook = do
  spawn "xsetroot -cursor_name left_ptr"
  spawnOnce "feh --bg-scale $HOME/wallpapers/mirrors-edge.png"

keys :: XConfig Layout -> Map (ButtonMask, KeySym) (X ())
keys XConfig{modMask, layoutHook, terminal, workspaces} =
  Map.fromList $ concat [
      appKeys
    , layoutKeys
    , focusKeys
    , workspaceKeys
    ]
  where
    appKeys = [
        ((modMask, xK_Return), spawn appLauncher)
      , ((modMask, xK_Tab), spawn appList)
      , ((modMask, xK_grave), spawn terminal)
      , ((modMask .|. shiftMask, xK_c), kill)
      , ((modMask .|. shiftMask, xK_Escape), XMonad.io exitSuccess)
      ]
    
    appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
    appList     = "rofi -show window -show-icons"
    
    layoutKeys = [
        ((modMask, xK_space), sendMessage NextLayout)
      , ((modMask, xK_n), refresh)
      , ((modMask .|. shiftMask, xK_space), setLayout layoutHook)
      , ((modMask, xK_h), sendMessage Shrink)
      , ((modMask, xK_l), sendMessage Expand)
      , ((modMask .|. shiftMask, xK_j), windows StackSet.swapDown)
      , ((modMask .|. shiftMask, xK_k), windows StackSet.swapUp)
      , ((modMask, xK_comma), sendMessage (IncMasterN 1))
      , ((modMask, xK_period), sendMessage (IncMasterN (-1)))
      , ((modMask, xK_t), withFocused $ windows . StackSet.sink)
      ]
    
    focusKeys = [
        ((modMask, xK_j), windows StackSet.focusDown)
      , ((modMask, xK_k), windows StackSet.focusUp)
      , ((modMask, xK_m), windows StackSet.focusMaster)
      ]
    
    workspaceKeys =
      let
        f (key, view) = [
            ((modMask, key), windows $ StackSet.greedyView view)
          , ((modMask .|. shiftMask, key), windows $ StackSet.shift view)
          ]
      in
        concatMap f $ zip [xK_1 .. xK_9] workspaces

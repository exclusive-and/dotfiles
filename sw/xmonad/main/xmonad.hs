import Data.Map (Map)
import Data.Map qualified as Map
import System.Exit

import XMonad hiding (XConfig (..))
import XMonad (XConfig (XConfig))
import XMonad qualified as XMonad
import XMonad.Operations
    ( kill
    , refresh
    , sendMessage
    , setLayout
    , windows
    , withFocused
    )
import XMonad.StackSet qualified as W

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps qualified as XMonad
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing qualified as XMonad

import XMonad.Util.SpawnOnce (spawnOnce)

main :: IO ()
main = xmonad . ewmh . ewmhFullscreen $ XMonad.def
    { XMonad.modMask    = XMonad.mod4Mask       -- 
    , XMonad.keys       = keys
    , XMonad.terminal   = "alacritty"

    -- Whenever .xinitrc invokes me...
    , XMonad.startupHook = startupHook

    -- Whenever the window arrangement changes...
    , XMonad.layoutHook = layoutHook

    -- Window borders
    , XMonad.borderWidth        = 2
    , XMonad.focusedBorderColor = "#bc96da"     -- Purple-ish
    , XMonad.normalBorderColor  = "#3b4252"     -- Gray

    -- Mouse focusing behavior
    , XMonad.clickJustFocuses   = False
    , XMonad.focusFollowsMouse  = True
    }

keys conf@XConfig {XMonad.modMask = modMask} = Map.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask,               xK_Return), spawn appLauncher) -- %! Launch dmenu
    , ((modMask,               xK_Tab   ), spawn appList)
    , ((modMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    {-
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    -}
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    {-
    , ((modMask,               xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    -}
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), XMonad.io exitSuccess) -- %! Quit xmonad
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [ ((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]

appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
appList     = "rofi -show window -show-icons"

layoutHook =
    let
        layout = tiled ||| XMonad.Full
    in
        avoidStruts . smartBorders . gaps . spacing 10 $ layout
    where
        tiled   = XMonad.Tall nmaster delta ratio

        -- Default number of windows in the master pane
        nmaster = 1

        -- Default proportion of the screen taken up by the master pane
        ratio   = 1 / 2

        -- Percent of screen size to increment by when resizing
        delta   = 3 / 100

        gaps = XMonad.gaps [(L, 30), (R, 30), (U, 40), (D, 60)]

        spacing = XMonad.smartSpacing

startupHook = do
    spawn       "xsetroot -cursor_name left_ptr"
    spawnOnce   "feh --bg-scale $HOME/wallpapers/school-sunset.png"
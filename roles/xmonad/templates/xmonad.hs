import qualified Data.Map as M
import Data.Map (Map)
import Graphics.X11.ExtraTypes.XF86
import System.IO
import XMonad
import XMonad.Actions.SpawnOn (spawnOn, manageSpawn)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout
import XMonad.Layout.Circle (Circle (..))
import XMonad.Layout.Cross (simpleCross)
import XMonad.Layout.Tabbed (simpleTabbed)
import XMonad.StackSet (greedyView, shift, view)
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)


myModMask :: KeyMask
myModMask = mod4Mask

altMask = mod1Mask

myBorderWidth :: Dimension
myBorderWidth = 1

myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"] ++ map snd myExtraWorkspaces

myExtraWorkspaces = [(xK_0, "0"), (xK_minus, "-"), (xK_equal, "=")]

extraWorkspaceKeys conf@XConfig{modMask = modm} = M.fromList $
  [
    ((modm, key), windows $ greedyView workspace)
    | (key, workspace) <- myExtraWorkspaces
  ] ++ [
    ((modm .|. shiftMask, key), windows $ shift workspace)
    | (key, workspace) <- myExtraWorkspaces
  ] ++ [
    ((modm, stringToKeysym $ "KP_" ++ show n), windows $ greedyView (show n))
    | n <- [1..9]
  ]
  -- ++ [
  --   ((modm .|. modifier, key), screenWorkspace screen >>= flip whenJust (windows . f))
  --   | (key, screen) <- zip [xK_w, xK_e, xK_r] [1, 0, 2]
  --   , (f, modifier) <- [(view, 0), (shift, shiftMask)]
  -- ]

myMiscKeys conf@XConfig{modMask = modm} = M.fromList $
  [ ((modm, xK_p), spawn "dmenu_run")
  , ((modm .|. shiftMask, xK_p), spawn "passmenu")
  , ((modm, xK_b), sendMessage ToggleStruts)
  , ((altMask .|. controlMask, xK_l), spawn "xscreensaver-command --lock")
  , ((shiftMask .|. modm, xK_Print), spawn "peek")
  , ((modm, xK_Print), spawn "flameshot gui -p {{ home }}/Pictures/")
  , ((0, xK_Print), spawn "flameshot full -p {{ home }}/Pictures/")
  -- FIXME: construir script em clisp
  , ((0, xF86XK_MonBrightnessDown), spawn "{{ home }}/bin/backlight/manage_backlight.sh dec")
  , ((0, xF86XK_MonBrightnessUp), spawn "{{ home }}/bin/backlight/manage_backlight.sh inc")
  , ((modm .|. controlMask, xK_KP_Multiply), spawn "{{ home }}/bin/tmg-vlc next")
  , ((0, xF86XK_AudioNext), spawn "{{ home }}/bin/tmg-vlc next")
  , ((modm .|. controlMask, xK_KP_Divide), spawn "{{ home }}/bin/tmg-vlc previous")
  , ((0, xF86XK_AudioPrev), spawn "{{ home }}/bin/tmg-vlc previous")
  , ((modm .|. controlMask, xK_KP_Delete), spawn "{{ home }}/bin/tmg-vlc pause-resume")
  , ((0, xF86XK_AudioPlay), spawn "{{ home }}/bin/tmg-vlc pause-resume")
  , ((noModMask, stringToKeysym "XF86AudioRaiseVolume"), spawn "amixer set Master 2%+")
  , ((noModMask, stringToKeysym "XF86AudioLowerVolume"), spawn "amixer set Master 2%-")
  , ((noModMask, stringToKeysym "XF86AudioMute"), spawn "amixer set Master toggle")
  , ((noModMask, xF86XK_HomePage), spawn "{{ home }}/bin/tmg-vlc fwd")
  , ((noModMask, xF86XK_Mail), spawn "{{ home }}/bin/tmg-vlc bwd")
  ]

myKeys conf = foldMap ($ conf) [myMiscKeys, extraWorkspaceKeys, keys def]

myStartupHook :: X ()
myStartupHook = do
  -- spawnOn "1" "google-chrome"
  -- spawnOn "3" "emacs25"
  setWMName "LG3D"
  spawn "{{ home }}/bin/tmg-xinit.sh"
  return ()

myManageHook :: ManageHook
myManageHook = composeAll [ isFullscreen --> doFullFloat
                          ]
               <+> composeOne [ isDialog -?> doCenterFloat
                              ]

myLayoutHook = avoidStruts $
               (layoutHook def)
               -- ||| Circle
               -- ||| simpleCross
               ||| simpleTabbed

myConfig xmobarProc = def
                       { modMask = myModMask
                       , borderWidth = myBorderWidth
                       , workspaces = myWorkspaces
                       , manageHook = manageSpawn
                                      <+> manageDocks
                                      <+> myManageHook
                                      <+> manageHook def
                       , layoutHook = myLayoutHook
                       , startupHook = myStartupHook >> startupHook def
                       , logHook = dynamicLogWithPP xmobarPP { ppOutput = hPutStrLn xmobarProc }
                       , handleEventHook = handleEventHook def
                                           <+> docksEventHook
                       , keys = myKeys
                       , terminal = "terminator"
                       } -- `additionalKeys` extraWorkspaceKeys

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ ewmh $ docks $ myConfig xmproc

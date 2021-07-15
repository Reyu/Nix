{-# LANGUAGE AllowAmbiguousTypes, DeriveDataTypeable, TypeSynonymInstances, MultiParamTypeClasses, LambdaCase #-}
-- Modules                                                              {{{
---------------------------------------------------------------------------
import qualified Data.Map as M
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8
import Text.Printf
import System.Directory               ( getHomeDirectory )
import System.Exit
import System.IO                            -- for xmonbar

import XMonad hiding ( (|||) )              -- from X.L.LayoutCombinators
import qualified XMonad.StackSet as W       -- myManageHookShift

import qualified XMonad.Actions.ConstrainedResize as Sqr
import XMonad.Actions.CopyWindow            -- like cylons, except x windows
import XMonad.Actions.CycleWS
import XMonad.Actions.DynamicProjects
import XMonad.Actions.DynamicWorkspaceOrder
import XMonad.Actions.FloatSnap
import XMonad.Actions.Navigation2D
import XMonad.Actions.Promote               -- promote window to master
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Actions.SinkAll
import XMonad.Actions.SpawnOn
import XMonad.Actions.WithAll               -- action all the things
import XMonad.Actions.WorkspaceNames

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks             -- avoid xmobar
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.DecorationMadness      -- testing alternative accordion styles
import XMonad.Layout.Fullscreen
import XMonad.Layout.Hidden
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.PerScreen              -- Check screen width & adjust layouts
import XMonad.Layout.PerWorkspace           -- Configure layouts on a per-workspace
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile          -- Resizable Horizontal border
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.SubLayouts             -- Layouts inside windows. Excellent.
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WindowNavigation

import XMonad.Prompt                        -- to get my old key bindings working
import XMonad.Prompt.ConfirmPrompt          -- don't just hard quit

import XMonad.Util.Cursor
import XMonad.Util.EZConfig                 -- removeKeys, additionalKeys
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows
import XMonad.Util.Paste as P               -- testing
import XMonad.Util.Run                      -- for spawnPipe and hPutStrLn
import XMonad.Util.SpawnOnce
import XMonad.Util.WorkspaceCompare         -- custom WS functions filtering NSP

------------------------------------------------------------------------}}}
-- Main                                                                 {{{
---------------------------------------------------------------------------

main :: IO ()
main = do
    dbus <- D.connectSession
    _ <- D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad 
        $ dynamicProjects projects
        $ withNavigation2DConfig myNav2DConf
        $ withUrgencyHook LibNotifyUrgencyHook
        $ ewmh
        $ addDescrKeys' ((myModMask, xK_F1), showKeybindings) myKeys
        $  myConfig dbus

myConfig p = def
        { borderWidth        = 0
        , clickJustFocuses   = myClickJustFocuses
        , focusFollowsMouse  = myFocusFollowsMouse
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , manageHook         = myManageHook
        , handleEventHook    = myHandleEventHook
        , layoutHook         = myLayoutHook
        , logHook            = dynamicLogWithPP (myLogHook p)
        , modMask            = myModMask
        , mouseBindings      = myMouseBindings
        , startupHook        = myStartupHook
        , terminal           = myTerminal
        , workspaces         = myWorkspaces
        }


------------------------------------------------------------------------}}}
-- Logging                                                              {{{
---------------------------------------------------------------------------

myLogHook dbus = def
    { ppCurrent = wrap ("%{F" ++ green  ++ "}") "%{F-}"
    , ppVisible = wrap ("%{F" ++ cyan   ++ "}") "%{F-}"
    , ppHidden  = wrap ("%{F" ++ blue   ++ "}") "%{F-}"
    , ppUrgent  = wrap ("%{F" ++ yellow ++ "}") "%{F-}"
    , ppLayout  = wrap ("%{F" ++ base0  ++ "}") "%{F-}"
    , ppTitle   = shorten 150
    , ppSort    = fmap (namedScratchpadFilterOutWorkspace .) getSortByXineramaRule
    , ppOrder   = \case
                    (ws : l : _ : exs) -> [ws, l] ++ exs
                    _                  -> []
    , ppOutput  = dbusOutput dbus
    }

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal objectPath interfaceName memberName) {
            D.signalBody = [D.toVariant $ UTF8.decodeString str]
        }
    D.emit dbus signal
  where
    objectPath = D.objectPath_ "/org/xmonad/Log"
    interfaceName = D.interfaceName_ "org.xmonad.Log"
    memberName = D.memberName_ "Update"

------------------------------------------------------------------------}}}
-- Workspaces                                                           {{{
---------------------------------------------------------------------------

wsWEB   = "web"
wsNIX   = "nix-config"
wsVID   = "video"
wsVIRT  = "virt"
wsSTL   = "modeling"
wsNET   = "foxnet"
wsWRK   = "work"
wsFLOAT = "float"

myWorkspaces = [wsWEB, wsNIX, wsVID, wsVIRT, wsSTL, wsNET, wsWRK, wsFLOAT]

projects =
  [ Project { projectName      = wsWEB
            , projectDirectory = "~"
            , projectStartHook = Just $ spawnOn wsWRK "firefox -P personal"
            }
  , Project { projectName      = wsNET
            , projectDirectory = "~/Projects/FoxNet"
            , projectStartHook = Just $ spawnOn wsNET (myTerminal ++ " -c FoxNet -e 'tmux new -A FoxNet'")
            }
  , Project { projectName      = wsWRK
            , projectDirectory = "~/Projects/Capacity"
            , projectStartHook = Just $ spawnOn wsWRK "firefox -P work"
            }
  , Project { projectName = wsNIX
            , projectDirectory = "~/Projects/NIX"
            , projectStartHook = Just $ spawnOn wsNET (myTerminal ++ " -c XMonad -e 'tmux new -A NixConfig")
            }
  , Project { projectName = wsVID
            , projectDirectory = "~"
            , projectStartHook = Just $ spawnOn wsVID "firefox -P video https://youtube.com"
            }
  , Project { projectName = wsVIRT
            , projectDirectory = "~/Projects"
            , projectStartHook = Just $ spawnOn wsVIRT "virt-manager"
            }
  , Project { projectName = wsSTL
            , projectDirectory = "~/Projects/Modeling"
            , projectStartHook = Just $ spawnOn wsSTL "blender"
            }
  ]

------------------------------------------------------------------------}}}
-- Applications                                                         {{{
---------------------------------------------------------------------------

myTerminal          = "alacritty"
myBrowser           = "firefox"
myBrowserClass      = "Firefox"
myLauncher          = "rofi -matching fuzzy -modi combi -show combi -combi-modi run,drun"


scratchpads
  = [ term "htop" "htop"           mySPFloat
    , term "mail" "zsh -c neomutt" mySPLargeFloat
    , term "irc"  "zsh -c weechat" mySPLargeFloat
    , NS "volume" "pavucontrol"        (className =? "Pavucontrol")     mySPLargeFloat
    , NS "element" "element-desktop"   (className =? "Element")         mySPLargeFloat
    , NS "discord" "Discord"           (className =? "discord")         mySPLargeFloat
    , NS "telegram" "telegram-desktop" (className =? "TelegramDesktop") mySPLargeFloat
    ]
 where
    -- Run in Terminal
  term n c = NS n (printf "%s -c %s %s" myTerminal n c) (className =? n)
  -- Helpers
  mySPFloat      = customFloating $ W.RationalRect (1 / 4) (1 / 4) (1 / 2) (1 / 2)
  mySPLargeFloat = customFloating $ W.RationalRect (1 / 8) (1 / 8) (3 / 4) (3 / 4)

------------------------------------------------------------------------}}}
-- Theme                                                                {{{
---------------------------------------------------------------------------

myFocusFollowsMouse  = False
myClickJustFocuses   = False

base03 = "#002b36"
base02 = "#073642"
-- base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
-- base1   = "#93a1a1"
-- base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
-- orange  = "#cb4b16"
red     = "#dc322f"
-- magenta = "#d33682"
-- violet  = "#6c71c4"
blue = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"

-- sizes
topbar = 10
prompt = 20
-- status = 20

myNormalBorderColor     = base03
myFocusedBorderColor    = green

active       = blue
-- activeWarn   = red
-- inactive     = base02
-- focusColor   = blue
-- unfocusColor = base02

myFont = "xft:Source Code Pro:pixelsize=14:autohint=true"

topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = topbar
    }

myTabTheme = def
    { fontName              = myFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

myPromptTheme = def
    { font                  = myFont
    , bgColor               = base03
    , fgColor               = active
    , fgHLight              = base03
    , bgHLight              = active
    , borderColor           = base03
    , promptBorderWidth     = 0
    , height                = prompt
    , position              = Top
    }

warmPromptTheme = myPromptTheme
    { bgColor               = yellow
    , fgColor               = base03
    , position              = Top
    }

hotPromptTheme = myPromptTheme
    { bgColor               = red
    , fgColor               = base3
    , position              = Top
    }

myShowWNameTheme = def
    { swn_font              = myFont
    , swn_fade              = 0.5
    , swn_bgcolor           = "#000000"
    , swn_color             = "#FFFFFF"
    }

------------------------------------------------------------------------}}}
-- Layouts                                                              {{{
---------------------------------------------------------------------------

myNav2DConf = def
    { defaultTiledNavigation    = centerNavigation
    , floatNavigation           = centerNavigation
    , screenNavigation          = lineNavigation
    , layoutNavigation          = [("Full", centerNavigation)
                                  ]
    , unmappedWindowRect        = [("Full", singleWindowRect)
                                  ]
    }


data FULLBAR = FULLBAR deriving (Read, Show, Eq, Typeable)
instance Transformer FULLBAR Window where
    transform FULLBAR x k = k barFull (const x)

barFull = avoidStruts Simplest

myLayoutHook = showWorkspaceName
             $ onWorkspace wsFLOAT floatWorkSpace
             $ fullscreenFloat -- fixes floating windows going full screen, while retaining "bounded" fullscreen
             $ fullScreenToggle
             $ fullBarToggle
             $ mirrorToggle
             $ reflectToggle
             $ flex ||| tabs
  where

    floatWorkSpace      = simplestFloat
    fullBarToggle       = mkToggle (single FULLBAR)
    fullScreenToggle    = mkToggle (single FULL)
    mirrorToggle        = mkToggle (single MIRROR)
    reflectToggle       = mkToggle (single REFLECTX)
    smallMonResWidth    = 1080
    showWorkspaceName   = showWName' myShowWNameTheme

    named n             = renamed [XMonad.Layout.Renamed.Replace n]
    trimNamed w n       = renamed [XMonad.Layout.Renamed.CutWordsLeft w,
                                   XMonad.Layout.Renamed.PrependWords n]
    suffixed n          = renamed [XMonad.Layout.Renamed.AppendWords n]
    trimSuffixed w n    = renamed [XMonad.Layout.Renamed.CutWordsRight w,
                                   XMonad.Layout.Renamed.AppendWords n]

    addTopBar           = noFrillsDeco shrinkText topBarTheme

    --------------------------------------------------------------------------
    -- Tabs Layout                                                          --
    --------------------------------------------------------------------------

    tabs = named "Tabs"
         $ avoidStruts
         $ addTopBar
         $ addTabs shrinkText myTabTheme
           Simplest

    flex = trimNamed 5 "Flex"
              $ avoidStruts
              $ windowNavigation
              $ addTopBar
              $ addTabs shrinkText myTabTheme
              $ subLayout [] (Simplest ||| Accordion)
              $ ifWider smallMonResWidth wideLayouts standardLayouts
              where
                  wideLayouts = suffixed "Wide 3Col" $ ThreeColMid 1 (1/20) (1/2)
                    ||| trimSuffixed 1 "Wide BSP" (hiddenWindows emptyBSP)
                  standardLayouts = suffixed "Std 2/3" (ResizableTall 1 (1/20) (2/3) [])
                    ||| suffixed "Std 1/2" (ResizableTall 1 (1/20) (1/2) [])


------------------------------------------------------------------------}}}
-- Bindings                                                             {{{
---------------------------------------------------------------------------

myModMask = mod4Mask -- super (and on my system, hyper) keys

-- Display keyboard mappings using zenity
-- from https://github.com/thomasf/dotfiles-thomasf-xmonad/
--              blob/master/.xmonad/lib/XMonad/Config/A00001.hs
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
    h <- spawnPipe "zenity --text-info --font=terminus"
    hPutStr h (unlines $ showKm x)
    hClose h
    return ()

wsKeys = ["1","2","3","4","5","6","7","8","9","0"] 

-- any workspace but scratchpad
-- notSP = (return $ ("NSP" /=) . W.tag) :: X (WindowSpace -> Bool)
-- shiftAndView dir = findWorkspace getSortByIndex dir (WSIs notSP) 1
--         >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)

-- hidden, non-empty workspaces less scratchpad
-- shiftAndView' dir = findWorkspace getSortByIndexNoSP dir HiddenNonEmptyWS 1
--         >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)
nextNonEmptyWS = findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1
        >>= \t -> windows . W.view $ t
prevNonEmptyWS = findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1
        >>= \t -> windows . W.view $ t
getSortByIndexNoSP =
        fmap (.namedScratchpadFilterOutWorkspace) getSortByIndex

-- toggle any workspace but scratchpad
-- myToggle = windows $ W.view =<< W.tag . head . filter 
--         ((\x -> x /= "NSP" && x /= "SP") . W.tag) . W.hidden

myKeys conf = let

    subKeys str ks = subtitle str : mkNamedKeymap conf ks
    dirKeys        = ["j","k","h","l"]
    arrowKeys      = ["<D>","<U>","<L>","<R>"]
    dirs           = [ D,  U,  L,  R ]

    zipM  m nm ks as f = zipWith (\k d -> (m ++ k, addName nm $ f d)) ks as
    zipM' m nm ks as f b = zipWith (\k d -> (m ++ k, addName nm $ f d b)) ks as

    toggleFloat w = windows (\s -> if M.member w (W.floating s)
                    then W.sink w s
                    else W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s)

  in
    -----------------------------------------------------------------------
    -- System / Utilities
    -----------------------------------------------------------------------
    subKeys "System"
    [ ("M-q"                    , addName "Restart XMonad"                    restartXmonad)
    , ("M-C-q"                  , addName "Rebuild & restart XMonad"          rebuildXmonad)
    , ("M-S-q"                  , addName "Quit XMonad"                       quitXmonad)
    , ("M-x"                    , addName "Lock screen"                     $ spawn "xset s activate")
    , ("M-<F4>"                 , addName "Print Screen"                    $ return ())
    ] ^++^

    -----------------------------------------------------------------------
    -- Launchers
    -----------------------------------------------------------------------
    subKeys "Launchers"
    [ ("M-<Space>"              , addName "Launcher"                        $ spawn myLauncher)
    , ("M-<Return>"             , addName "Terminal"                        $ do
        name <- withWindowSet (pure . W.currentTag)
        spawn $ myTerminal ++ " -e tmux new -At " ++ name)
        -- wsName <- getCurrentWorkspaceName
        -- let wsName' = case wsName of
        --               Nothing -> "EXTRA"
        --               Just name -> name
        --  in spawn (myTerminal ++ " -e tmux new -At " ++ wsName'))
    , ("M-\\"                   , addName "Browser"                         $ bindOn [ (wsWRK, spawn $ myBrowser ++ " -P Work")
                                                                                     , (""   , spawn myBrowser)
                                                                                     ])
    , ("M-s s"                  , addName "Cancel submap"                   $ return ())
    , ("M-s M-s"                , addName "Cancel submap"                   $ return ())
    , ("M-e"                    , addName "NSP Element"                     $ namedScratchpadAction scratchpads "element")
    , ("M-i"                    , addName "NSP Element"                     $ namedScratchpadAction scratchpads "irc")
    , ("M-m"                    , addName "NSP NeoMutt"                     $ namedScratchpadAction scratchpads "mail")
    , ("M-v"                    , addName "NSP Volume Control"              $ namedScratchpadAction scratchpads "volume")
    , ("M-t"                    , addName "NSP HTOP"                        $ namedScratchpadAction scratchpads "htop")
    , ("M-c d"                  , addName "NSP Discord"                     $ namedScratchpadAction scratchpads "discord")
    , ("M-c t"                  , addName "NSP Telegram"                    $ namedScratchpadAction scratchpads "telegram")
    , ("M-c M-d"                , addName "NSP Discord"                     $ namedScratchpadAction scratchpads "discord")
    , ("M-c M-t"                , addName "NSP Telegram"                    $ namedScratchpadAction scratchpads "telegram")
    ] ^++^

    -----------------------------------------------------------------------
    -- Windows
    -----------------------------------------------------------------------

    subKeys "Windows"
    (
    [ ("M-<Backspace>"          , addName "Kill"                              kill1)
    , ("M-S-<Backspace>"        , addName "Kill all"                        $ confirmPrompt hotPromptTheme "kill all" killAll)
    , ("M-d"                    , addName "Duplicate w to all ws"             toggleCopyToAll)
    , ("M-p"                    , addName "Hide window to stack"            $ withFocused hideWindow)
    , ("M-S-p"                  , addName "Restore hidden window (FIFO)"      popOldestHiddenWindow)

    , ("M-b"                    , addName "Promote"                           promote) 

    , ("M-g"                    , addName "Un-merge from sublayout"         $ withFocused (sendMessage . UnMerge))
    , ("M-S-g"                  , addName "Merge all into sublayout"        $ withFocused (sendMessage . MergeAll))

    , ("M-z u"                  , addName "Focus urgent"                    focusUrgent)
    , ("M-z m"                  , addName "Focus master"                    $ windows W.focusMaster)

    , ("C-'"                    , addName "Swap tab U"                      $ windows W.swapUp)
    , ("C-;"                    , addName "Swap tab D"                      $ windows W.swapDown)
    ]

    ++ zipM' "M-"               "Navigate window"                           dirKeys dirs windowGo True
    ++ zipM' "M-S-"             "Move window"                               dirKeys dirs windowSwap True
    ++ zipM  "M-C-"             "Merge w/sublayout"                         dirKeys dirs (sendMessage . pullGroup)
    ++ zipM' "M-"               "Navigate screen"                           arrowKeys dirs screenGo True
    ++ zipM' "M-S-"             "Move window to screen"                     arrowKeys dirs windowToScreen True

    ) ^++^

    -----------------------------------------------------------------------
    -- Workspaces & Projects
    -----------------------------------------------------------------------

    subKeys "Workspaces & Projects"
    (
    [ ("M-w"                    , addName "Switch to Project"           $ switchProjectPrompt warmPromptTheme)
    , ("M-S-w"                  , addName "Shift to Project"            $ shiftToProjectPrompt warmPromptTheme)
    , ("M-<Escape>"             , addName "Next non-empty workspace"      nextNonEmptyWS)
    , ("M-S-<Escape>"           , addName "Prev non-empty workspace"      prevNonEmptyWS)
    , ("M-`"                    , addName "Next non-empty workspace"      nextNonEmptyWS)
    , ("M-S-`"                  , addName "Prev non-empty workspace"      prevNonEmptyWS)
    , ("M-a"                    , addName "Toggle last workspace"       $ toggleWS' ["NSP"])
    ]
    ++ zipM "M-"                "View      ws"                          wsKeys [0..] (withNthWorkspace W.greedyView)
    ++ zipM "M-S-"              "Move w to ws"                          wsKeys [0..] (withNthWorkspace W.shift)
    ++ zipM "M-S-C-"            "Copy w to ws"                          wsKeys [0..] (withNthWorkspace copy)
    ) ^++^

    -----------------------------------------------------------------------
    -- Layouts & Sublayouts
    -----------------------------------------------------------------------

    subKeys "Layout Management"

    [ ("M-<Tab>"                , addName "Cycle all layouts"           $ sendMessage NextLayout)
    , ("M-C-<Tab>"              , addName "Cycle sublayout"             $ toSubl NextLayout)
    , ("M-S-<Tab>"              , addName "Reset layout"                $ setLayout $ XMonad.layoutHook conf)

    , ("M-y"                    , addName "Float tiled w"               $ withFocused toggleFloat)
    , ("M-S-y"                  , addName "Tile all floating w"           sinkAll)

    , ("M-,"                    , addName "Decrease master windows"     $ sendMessage (IncMasterN (-1)))
    , ("M-."                    , addName "Increase master windows"     $ sendMessage (IncMasterN 1))

    , ("M-S-r"                  , addName "Force Reflect (even on BSP)" $ sendMessage (XMonad.Layout.MultiToggle.Toggle REFLECTX))


    -- If following is run on a floating window, the sequence first tiles it.
    -- Not perfect, but works.
    , ("M-f"                    , addName "Fullscreen"                  $ sequence_ [ withFocused $ windows . W.sink
                                                                        , sendMessage $ XMonad.Layout.MultiToggle.Toggle FULL ])

    , ("C-S-h"                  , addName "Ctrl-h passthrough"          $ P.sendKey controlMask xK_h)
    , ("C-S-j"                  , addName "Ctrl-j passthrough"          $ P.sendKey controlMask xK_j)
    , ("C-S-k"                  , addName "Ctrl-k passthrough"          $ P.sendKey controlMask xK_k)
    , ("C-S-l"                  , addName "Ctrl-l passthrough"          $ P.sendKey controlMask xK_l)
    ]
    where
    toggleCopyToAll = wsContainingCopies >>= \case
                                            [] -> windows copyToAll
                                            _ -> killAllOtherCopies

-- Mouse bindings: default actions bound to mouse events
-- Includes window snapping on move/resize using X.A.FloatSnap
-- Includes window w/h ratio constraint (square) using X.H.ConstrainedResize
myMouseBindings XConfig{} = M.fromList
    [ ((myModMask,               button1) ,\w -> focus w
      >> mouseMoveWindow w
      >> ifClick (snapMagicMove (Just 50) (Just 50) w)
      >> windows W.shiftMaster)

    , ((myModMask .|. shiftMask, button1), \w -> focus w
      >> mouseMoveWindow w
      >> ifClick (snapMagicResize [L,R,U,D] (Just 50) (Just 50) w)
      >> windows W.shiftMaster)

    , ((myModMask,               button3), \w -> focus w
      >> mouseResizeWindow w
      >> ifClick (snapMagicResize [R,D] (Just 50) (Just 50) w)
      >> windows W.shiftMaster)

    , ((myModMask .|. shiftMask, button3), \w -> focus w
      >> Sqr.mouseResizeWindow w True
      >> ifClick (snapMagicResize [R,D] (Just 50) (Just 50) w)
      >> windows W.shiftMaster)
    ]

------------------------------------------------------------------------}}}
-- Startup                                                              {{{
---------------------------------------------------------------------------

myStartupHook = do
        spawn "polybar -r primary"
        spawnOnce "~/.xmonad/AutoStart/AutoStart.zsh"
        setDefaultCursor xC_left_ptr

quitXmonad :: X ()
quitXmonad = confirmPrompt hotPromptTheme "Quit XMonad" $ io exitSuccess

rebuildXmonad :: X ()
rebuildXmonad = do
  spawn "xmonad --rebuild"
  restartXmonad

restartXmonad :: X ()
restartXmonad = do
  home <- liftIO getHomeDirectory
  restart (home ++ "/.xmonad/xmonad-x86_64-linux") True

------------------------------------------------------------------------}}}
-- Actions                                                              {{{
---------------------------------------------------------------------------


---------------------------------------------------------------------------
-- Urgency Hook                                                            
---------------------------------------------------------------------------
-- from https://pbrisbin.com/posts/using_notify_osd_for_xmonad_notifications/
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name'    <- getName w
        Just idx <- W.findTag w <$> gets windowset

        safeSpawn "notify-send" [show name', "workspace " ++ idx]
-- cf https://github.com/pjones/xmonadrc


---------------------------------------------------------------------------
-- New Window Actions
---------------------------------------------------------------------------

-- https://wiki.haskell.org/Xmonad/General_xmonad.hs_config_tips#ManageHook_examples
-- <+> manageHook defaultConfig

myManageHook :: ManageHook
myManageHook =
        manageSpecific
    <+> manageDocks
    <+> namedScratchpadManageHook scratchpads
    <+> fullscreenManageHook
    <+> manageSpawn
    where
        manageSpecific = composeOne
            [ resource =? "desktop_window"    -?> doIgnore
            , className=? "Polybar"           -?> doIgnore
            , resource =? "stalonetray"       -?> doIgnore
            , resource =? "vlc"               -?> doFloat
            , transience
            , isBrowserDialog -?> forceCenterFloat
            , isRole =? gtkFile  -?> forceCenterFloat
            , isDialog -?> doCenterFloat
            , isRole =? "pop-up" -?> doCenterFloat
            , isInProperty "_NET_WM_WINDOW_TYPE"
                           "_NET_WM_WINDOW_TYPE_SPLASH" -?> doCenterFloat
            , resource =? "console" -?> tileBelowNoFocus
            , isFullscreen -?> doFullFloat
            , pure True -?> tileBelow ]
        isBrowserDialog = isDialog <&&> className =? myBrowserClass
        gtkFile = "GtkFileChooserDialog"
        isRole = stringProperty "WM_WINDOW_ROLE"
        tileBelow = insertPosition Below Newer
        tileBelowNoFocus = insertPosition Below Older

---------------------------------------------------------------------------
-- X Event Actions
---------------------------------------------------------------------------

-- for reference, the following line is the same as dynamicTitle myDynHook
-- <+> dynamicPropertyChange "WM_NAME" myDynHook

-- I'm not really into full screens without my say so... I often like to
-- fullscreen a window but keep it constrained to a window rect (e.g.
-- for videos, etc. without the UI chrome cluttering things up). I can
-- always do that and then full screen the subsequent window if I want.
-- THUS, to cut a long comment short, no fullscreenEventHook
-- <+> XMonad.Hooks.EwmhDesktops.fullscreenEventHook

myHandleEventHook = docksEventHook
                <+> fadeWindowsEventHook
                <+> handleEventHook def
                <+> XMonad.Layout.Fullscreen.fullscreenEventHook

---------------------------------------------------------------------------
-- Custom hook helpers
---------------------------------------------------------------------------

-- from:
-- https://github.com/pjones/xmonadrc/blob/master/src/XMonad/Local/Action.hs

forceCenterFloat :: ManageHook
forceCenterFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 1/3
    h = 1/2
    x = (1-w)/2
    y = (1-h)/2

-- vim: ft=haskell:foldmethod=marker:expandtab:ts=4:shiftwidth=4

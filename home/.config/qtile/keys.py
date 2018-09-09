import subprocess
from time import time
from pathlib import Path


from libqtile.config import Key, Drag, Click
from libqtile.command import lazy

from groups import groups, group_keys

mod = 'mod4'
alt = 'mod1'

music_cmd = ('dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify '
             '/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.')


def restart():
    def __inner(qtile):
        subprocess.call(['setxkbmap', 'de'])  # workaround/fix
        qtile.cmd_restart()
    return __inner


def move_window_to_screen(screen):
    def cmd(qtile):
        w = qtile.currentWindow
        # XXX: strange behaviour - w.focus() doesn't work
        # if toScreen is called after togroup...
        qtile.toScreen(screen)
        if w is not None:
            w.togroup(qtile.screens[screen].group.name)
    return cmd

def switch_screens():
    def __inner(qtile):
        i = qtile.screens.index(qtile.currentScreen)
        group = qtile.screens[i - 1].group
        qtile.currentScreen.setGroup(group)
    return __inner


def next_prev(action):
    def f(qtile):
        qtile.cmd_spawn(music_cmd + action)
    return f


def screenshot(save=True, copy=True):
    # maim -s | xclip -selection clipboard -t image/png
    def f(qtile):
        path = Path.home() / 'Screenshots'
        path /= f'screenshot_{str(int(time() * 100))}.png'
        shot = subprocess.run(['maim', '-s'], stdout=subprocess.PIPE)

        if save:
            with open(path, 'wb') as sc:
                sc.write(shot.stdout)

        if copy:
            subprocess.run(['xclip', '-selection', 'clipboard', '-t',
                            'image/png'], input=shot.stdout)
    return f


keys = [
    Key([mod], "h", lazy.layout.shrink_main()),
    Key([mod], "l", lazy.layout.grow_main()),
    Key([mod, 'control'], "h", lazy.layout.shrink()),
    Key([mod, 'control'], "l", lazy.layout.grow()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "m", lazy.layout.maximize()),
    Key([mod, 'control'], 'm', lazy.window.toggle_fullscreen()),
    Key([mod], 'b', lazy.window.toggle_floating()),

    # Move windows up or down in current stack
    Key([mod, 'control'], 'k', lazy.layout.shuffle_down()),
    Key([mod, 'control'], 'j', lazy.layout.shuffle_up()),


    # Switch window focus to other pane(s) of stack
    Key([mod], 'space', lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, 'shift'], 'space', lazy.layout.rotate()),

    # switch screens
    Key([mod], "o", lazy.function(switch_screens())),


    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, 'shift'], 'Return', lazy.layout.toggle_split()),
    Key([mod], 'Return', lazy.spawn('urxvt')),

    # app hotkeys
    Key([mod], 'e', lazy.spawn("xdotool search --name 'Mozilla Firefox' "
                               "windowactivate --sync key --clearmodifiers "
                               "--window 0 ctrl+t")),
    Key([], 'XF86LaunchB', lazy.function(screenshot())),

    # media hotkeys
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer sset Master 5%+')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer sset Master 5%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer sset Master toggle')),
    Key([], 'XF86AudioPlay', lazy.spawn(music_cmd + 'PlayPause')),
    Key([], 'XF86AudioNext', lazy.function(next_prev('Next'))),
    Key([], 'XF86AudioPrev', lazy.function(next_prev('Previous'))),



    # uniarg:key_numarg({}, "XF86MonBrightnessUp",
    # function ()
    #   awful.util.spawn("xbacklight -inc 10")
    # end,
    # function (n)
    #   awful.util.spawn("xbacklight -inc " .. n)
    # end),
    #
    # uniarg:key_numarg({}, "XF86MonBrightnessDown",
    # function ()
    #   awful.util.spawn("xbacklight -dec 10")
    # end,
    # function (n)
    #   awful.util.spawn("xbacklight -dec " .. n)
    # end),


    # Toggle between different layouts as defined below
    Key([mod], 'Tab', lazy.next_layout()),

    Key([mod, 'control'], 'r', lazy.function(restart())),
    Key([mod, 'control'], 'q', lazy.shutdown()),
    Key([mod], 'c', lazy.spawncmd()),
    Key([mod, 'shift'], 'c', lazy.window.kill()),

    Key([mod], "i", lazy.to_screen(0)),
    Key([mod, "shift"], "i", lazy.function(move_window_to_screen(0))),
    Key([mod], "a", lazy.to_screen(1)),
    Key([mod, "shift"], "a", lazy.function(move_window_to_screen(1))),
    Key([mod], "u", lazy.group['keeppad'].dropdown_toggle('Google Keep')),
]

for group, key in zip(groups, group_keys):
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], key, lazy.group[group.name].toscreen()),
        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, 'shift'], key, lazy.window.togroup(group.name)),
    ])

# Drag floating layouts.
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front())
]

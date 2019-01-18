import os
import subprocess

from libqtile.config import Key, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

from keys import keys
from groups import groups
from screens import screens

try:
    from typing import List  # noqa: F401
except ImportError:
    pass



layouts = [
    layout.Max(),
    layout.MonadTall(name='xmonad'),
    layout.Stack(num_stacks=2),
]

widget_defaults = dict(
    font='sans',
    fontsize=27,
    padding=3,
)
extension_defaults = widget_defaults.copy()



dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = 'smart'

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = 'LG3D'


# hooks

@hook.subscribe.startup_once
def startup_once():  # autostart
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


@hook.subscribe.startup
def startup():
    subprocess.call(['setxkbmap', 'de', 'neo'])  # workaround/fix


@hook.subscribe.client_new
def dialogs(window):
    if(window.window.get_wm_type() == 'dialog' or window.window.get_wm_transient_for()):
        window.floating = True
    print(window.window.get_wm_class())


@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    subprocess.call(['setxkbmap', 'de'])  # workaround/fix
    qtile.cmd_restart()


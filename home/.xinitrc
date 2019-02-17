#!/bin/sh

xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Themes, etc
gnome-settings-daemon &

# Fallback cursor # dont know what this is for..
# xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 180 50

# Capslock ctrl key
setxkbmap de neo

eval $(ssh-agent)

exec emacs --eval "(progn (require 'exwm-systemtray) (exwm-systemtray-enable) (exwm-enable))"

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

# exec emacs --eval "(progn (require 'exwm-systemtray) (require 'exwm-randr) (setq exwm-randr-workspace-output-plist '(1 \"eDP1\" 2 \"HDMI1\")) (add-hook 'exwm-randr-screen-change-hook (lambda () (start-process-shell-command \"xrandr\" nil \"xrandr --fb 7680x2160 --output HDMI1 --transform none && xrandr --fb 7680x2160 --output eDP1 --gamma 1.0:1.0:1.0 --mode 3840x2160 --pos 0x0 --primary --rate 60.00 --reflect normal --rotate normal --output HDMI1 --gamma 1.0:1.0:1.0 --mode 1920x1080 --pos 3840x0 --rate 60.00 --reflect normal --rotate normal --transform 2.000000,0.000000,0.000000,0.000000,2.000000,0.000000,0.000000,0.000000,1.000000\"))) (exwm-systemtray-enable) (exwm-enable))"
exec emacs --eval "(progn (require 'exwm-systemtray) (require 'exwm-randr) (setq exwm-randr-workspace-output-plist '(1 \"eDP1\" 2 \"HDMI1\")) (add-hook 'exwm-randr-screen-change-hook (lambda () (start-process-shell-command \"xrandr\" nil \"xrandr --output HDMI1 --right-of eDP1 --mode 1920x1080\"))) (exwm-systemtray-enable) (exwm-enable))"

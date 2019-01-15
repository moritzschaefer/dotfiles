xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

setxkbmap de neo

exec dbus-launch --exit-with-session emacs --eval "(progn (require 'exwm-systemtray) (exwm-systemtray-enable) (exwm-enable))"

xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec dbus-launch --exit-with-session emacs --eval "(exwm-enable)"

#!/bin/sh

# Keyboard repeat rate
xset r rate 180 50

setxkbmap -layout de -variant bone -option "lv5:rwin_switch_lock"

# [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

xrdb -merge ~/.Xresources

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Themes, etc
#gnome-settings-daemon &

# Fallback cursor # dont know what this is for..
# xsetroot -cursor_name left_ptr

# This is adapted from zsh for compatibility
function _start_ssh_agent() {
    SHORT_HOST=$(cat /etc/hostname)
    _ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"
	  # start ssh-agent and setup environment
	  echo "Starting ssh-agent..."
    [[ -f $_ssh_env_cache ]] && rm $_ssh_env_cache
	  ssh-agent -s | sed 's/^echo/#echo/' > $_ssh_env_cache
	  chmod 600 $_ssh_env_cache
	  . $_ssh_env_cache > /dev/null
}
_start_ssh_agent

# start GPG agent
AGENT_SOCK=$(gpgconf --list-dirs | grep agent-socket | cut -d : -f 2)


# TODO maybe this is not even necessary ..
if [[ ! -S $AGENT_SOCK ]]; then
    gpg-agent --daemon --use-standard-socket &>/dev/null
fi
export GPG_TTY=$TTY

# Set SSH to use gpg-agent if it's enabled (its not normally)
GNUPGCONFIG="${GNUPGHOME:-"$HOME/.gnupg"}/gpg-agent.conf"
if [[ -r $GNUPGCONFIG ]] && command grep -q enable-ssh-support "$GNUPGCONFIG"; then
    export SSH_AUTH_SOCK="$AGENT_SOCK.ssh"
    unset SSH_AGENT_PID
fi
# eval $(ssh-agent)

# exec emacs --eval "(progn (require 'exwm-systemtray) (require 'exwm-randr) (setq exwm-randr-workspace-output-plist '(1 \"eDP1\" 2 \"HDMI1\")) (add-hook 'exwm-randr-screen-change-hook (lambda () (start-process-shell-command \"xrandr\" nil \"xrandr --fb 7680x2160 --output HDMI1 --transform none && xrandr --fb 7680x2160 --output eDP1 --gamma 1.0:1.0:1.0 --mode 3840x2160 --pos 0x0 --primary --rate 60.00 --reflect normal --rotate normal --output HDMI1 --gamma 1.0:1.0:1.0 --mode 1920x1080 --pos 3840x0 --rate 60.00 --reflect normal --rotate normal --transform 2.000000,0.000000,0.000000,0.000000,2.000000,0.000000,0.000000,0.000000,1.000000\"))) (exwm-systemtray-enable) (exwm-enable))"
exec emacs --eval "(progn (require 'exwm-systemtray) (require 'exwm-randr) (setq exwm-randr-workspace-monitor-plist '(0 \"eDP1\" 1 \"HDMI1\" 2 \"DP2\" 3 \"eDP1\" 4 \"HDMI1\" 5 \"DP2\")) (add-hook 'exwm-randr-screen-change-hook (lambda () (start-process-shell-command \"xrandr\" nil \"xrandr --output HDMI1 --right-of eDP1 --mode 1920x1080\"))) (exwm-systemtray-enable) (exwm-enable))" 2>&1 >> ~/.xsession-errors2

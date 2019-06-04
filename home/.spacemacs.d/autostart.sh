#!/bin/bash

if ! pgrep nm-applet; then
    clipit &
    nm-applet &
    # rambox &
    system-config-printer-applet &
    ~/bin/redshift-workaround &
    udiskie &
    syndaemon -d  -t  -i 1.0s
    lxqt-policykit-agent &
    seafile-applet &
    blueman-applet &
    sparkleshare &
    touchegg &
    pasystray & 
    urxvt -e bash -c "tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$USER@$HOSTNAME" &
    if xrandr | ag "DP2 connected"; then
        sleep 2
        xrandr --output eDP1 --auto --pos 0x0 --output HDMI1 --scale 2x2 --auto --pos 3840x0 --output DP2 --scale 2x2 --auto --pos 7680x0 --fb 11520x2160
        sleep 2
        qutebrowser & 
    fi
fi

sleep infinity


#!/bin/bash

if ! pgrep nm-applet; then
    clipit &
    nm-applet &
    rambox &
    ~/bin/redshift-workaround &
    udiskie &
    syndaemon -d  -t  -i 1.0s
    lxqt-policykit-agent &
    seafile-applet &
    blueman-applet &
    sparkleshare &
    touchegg &
    pasystray & 
    qutebrowser & 
fi

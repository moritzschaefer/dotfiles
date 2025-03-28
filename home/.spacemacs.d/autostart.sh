#!/bin/bash

# TODO we might want to run `xrdb -merge ~/.Xresources`
if ! pgrep urxvt; then
    # mamba_kernel $ 
    nm-applet &
    clipit 2>&1 &
    # system-config-printer-applet &
    # ~/bin/redshift-workaround &
    # lxqt-policykit-agent &
    # urxvt -e bash -c "tmux -q has-session && exec tmux attach-session -d || exec command tmux new-session -n$USER -s$USER@$HOSTNAME" &
    urxvt -cd ~/ -e fish -c tmux &
    # export QUTE_BIB_FILEPATH="~/wiki/papers/references.bib" # this is taken care of already
    # qutebrowser-niced &
    chromium &
    blueman-applet &
    rfkill unblock bluetooth
    pasystray &
    # teams &  # use in browser
    discord &
    renice -n -15 -p $(pidof emacs)
    xsetroot -cursor_name left_ptr  # https://discourse.nixos.org/t/cursor-invisible-in-gtk-apps/19905/5  # top_left_arrow might be more beautiful
    # onedrivegui & 

    # if xrandr | ag "DP2 connected"; then
    #     sleep 2
    #     # xrandr --output eDP1 --auto --pos 0x0 --output HDMI1 --scale 2x2 --auto --pos 3840x0 --output DP2 --scale 2x2 --auto --pos 7680x0 --fb 11520x2160
    #     ~/.screenlayout/default.sh
    #     sleep 2
    #     # qutebrowser & 
    #     firefox &
    # else
    #     # qutebrowser & 
    #     firefox &
    # fi
fi

sleep infinity


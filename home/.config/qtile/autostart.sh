#!/bin/bash

clipit &
nm-applet &
rambox &
bin/redshift-workaround &
udiskie &
syndaemon -d  -t  -i 1.0s
lxqt-policykit-agent &
seafile-applet &
blueman-applet &
gitwatch /home/moritz/.homesick/repos/dotfiles/ &

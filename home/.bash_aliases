alias g='git'
alias sl='ls'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias duf='du -sk | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias jcurl='curl -v -H "Accept: application/json" -H "Content-type: application/json" -b .cookies -c .cookies'
alias susp='dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend'
alias hib='dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate'
alias neo='setxkbmap de neo -option'
alias de='setxkbmap de'
alias us='setxkbmap us'
alias tubvpn='sudo openconnect vpn.tu-berlin.de --script  /etc/vpnc/vpnc-script'
alias banot='ssh alu7053@banot.etsii.ull.es'
alias clip='xclip -selection clipboard'
alias j='jobs'
alias h='history'
alias nonose='nosetests --nocapture --nologcapture'
alias wifioff='nmcli nm wifi off'
alias wifion='nmcli nm wifi on'
alias anaconda='source ~/Apps/anaconda/bin/activate normal'
alias deactivate='source ~/Apps/anaconda/bin/deactivate'
alias disablenmnotifications='gsettings set org.gnome.nm-applet disable-disconnected-notifications "true"; gsettings set org.gnome.nm-applet disable-connected-notifications "true"'
alias enablenmnotifications='gsettings set org.gnome.nm-applet disable-disconnected-notifications "true"; gsettings set org.gnome.nm-applet disable-connected-notifications "true"'
alias scan='nmap -sP 192.168.178.255/24'
alias wifiscan='sudo iwlist wlan1 scan'
alias invert='xcalib -invert -alter'
alias timelapse='mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 -vf scale=1920:1080 -mf type=jpeg:fps=25 mf://@gopro.txt -o gopro.mp4'
alias addaudio='mencoder gopro.mp4 -o gopro_music.mp4 -ovc copy -oac copy -audiofile '
alias rocketdbssh='ssh -fqN om_user@db1.rocket-om.com -L 5432:127.0.0.1:5432'
alias lock='gnome-screensaver-command -l'
alias coffeer='coffee -cwo'
alias fontsize='printf '"'"'\33]50;%s%d\007'"'"' "xft:Inconsolata for Powerline:antialias=true:hinting=true:pixelsize="'
alias vodafone-stick="sudo usb_modeswitch -v 0x19d2 -p 0x2000 -V 0x19d2 -P 0x0031 -m 0x01 -M 55534243123456782000000080000c85010101180101010101000000000000"
# use like 'create_ctags <tagsfile> <code_dir>'
alias ctags_create='ctags -R --sort=yes --c++-kinds=+p --fields=+ilaS --extra=+q --language-force=C++ -f '
alias tmoteserial0='java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:115200'
alias vimdownload='vim ~/Downloads/$(ls -t ~/Downloads | head -n1)'
alias password="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"
alias flashsd110='softdevice-merge _build/*.hex && sudo cp out.hex /mnt/nrf51822'
alias screenshot='import -window root /tmp/screenshot.jpg'
alias sc='systemctl'
alias vpndown='nmcli connection down TU\ VPN '
alias vpnup='nmcli connection up TU\ VPN '
alias seafup='seafile-upload https://services.moritzs.de Uploads mail@moritzs.de'
alias matlab='synclient HorizTwoFingerScroll=0 && LD_LIBRARY_PATH=/home/moritz/Downloads/usr/lib/ /home/moritz/Apps/Matlab/bin/matlab || synclient HorizTwoFingerScroll=1'
alias matlabcli='LD_LIBRARY_PATH=/home/moritz/Downloads/usr/lib/ /home/moritz/Apps/Matlab/bin/matlab -nodisplay -nosplash'
# alias vim='nvim'
# alias v='nvim'
#
function cutvideo {
  if [[ "$#" < 3 ]]; then
    echo "Usage: cutvideo <video> <starttime> <enddtime> [outfile] # Hint: times as seconds or HH:MM:SS"
  else
    if [[ "$#" = 3 ]]; then
      filename=$(basename "$1")
      extension="${filename##*.}"
      filename="${filename%.*}"
      outfile="${filename}_modified.${extension}"
    else
      outfile="$4"
    fi
    ffmpeg -i $1 -acodec copy -vcodec copy -ss $2 -t $3 "$outfile"
  fi
}

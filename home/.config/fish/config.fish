if status is-interactive
    # Commands to run in interactive sessions can go here
    alias g="git"
    alias l="ls -lhrta"
    alias clip="xclip -selection clipboard"
    alias muwvpn="pass show Wien/meduniwien.ac.at/mschae83 | sudo openconnect --passwd-on-stdin --user mschae83 --authgroup _CeMM_exkl.Journale vpn.meduniwien.ac.at"
    alias feh="feh --scale-down --action 'cp %F ~/tmp/feh_selections/'"

    set -gx PATH $HOME/bin $PATH
    set EDITOR vim

    if [ "$TERM" = rxvt-unicode-256color ]
      set -x TERM xterm-256color
    end

    function add_ssh_keys
        ssh-add -l > /dev/null
        if [ $status -ne 0 ]
            for I in "$HOME/.ssh/id_rsa;SSH/pass_keys/id_rsa"
                set SSHKEYPATH (echo $I | string split ';')[1]
                set PASS (echo $I | string split ';')[2]
                set pass_output (pass $PASS)

                expect -c "
                  spawn ssh-add $SSHKEYPATH
                  expect \"Enter passphrase for $SSHKEYPATH:\"
                  send \"$pass_output\r\"
                  expect eof
                "
            end
        end
    end

    if [ (hostname) = "mopad" -o (hostname) = "moair" ]
        add_ssh_keys
    end

    # eval (direnv hook fish)  # already covered in nixos

    function save_history --on-event fish_postexec
        history --save
    end

    function cp_from_muw --description 'Copy file with prompt if destination exists'
        set src /mnt/muwhpc/(string replace "/home/moritz/Projects/" "" -- (realpath $argv[1]))
        set dest $argv[1]
        cp -i $src $dest
    end

    set fish_color_autosuggestion brblue

    mcfly init fish | source


end

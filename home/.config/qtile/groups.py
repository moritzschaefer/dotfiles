from libqtile.config import Group, Match, DropDown, ScratchPad

group_keys = 'nrtdgfq'

groups = []
groups.append(Group('urxvt', spawn='urxvt -e bash -c "tmux -q has-session && exec tmux attach-session -d || exec tmux new-session -n$USER -s$USER@$HOSTNAME"', layout='max'))
groups.append(Group('editor', spawn='spacemax', layout='max', matches=[Match(wm_class=['emac', 'Emacs'])]))
groups.append(Group('browser', spawn='firefox', layout='max', matches=[Match(wm_class=['Navigator', 'Firefox'])]))
groups.append(Group('chat', spawn='rambox', layout='max', matches=[Match(wm_class=['rambox', 'Rambox'])]))
groups.append(Group('music', spawn='spotify', layout='max', matches=[Match(wm_class=["spotify", "Spotify"])]))

for i in range(len(group_keys)-len(groups)):
    groups.append(Group(f'misc{i+1}'))

groups.append(ScratchPad('keeppad', [DropDown('Google Keep', 'chromium --app-id=hcfcmgpnmpinpidjdgejehjchlbglpde', opacity=0.85)]))

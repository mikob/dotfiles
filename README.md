Run `scripts/setup.sh` to create the proper symbolic links. To make sure
nothing you wanted to keep is overwritten, check the script before running.

Run `^A I` in tmux to install the tmux plugins.
Run `:PlugInstall` in vim to install the vim plugins.
WORKAROUND: Manually re-symbolic link prompt theme function after prezto installs it's plugins.

To have gnome-terminal work programmatically with tabs (fucking ridiculous how
hard this was to figure out and do properly):
gnome-terminal --tab -e 'zsh -c "POST_RC=\"hra && cd webapp && ./manage.py runserver\" exec zsh"' --tab-with-profile=default -e 'zsh -c "POST_RC=\"hra && cd webapp && grunt watch\" exec zsh"' --tab-with-profile=default -e 'zsh -c "POST_RC=\"hra && cd webapp\" exec zsh"'

Trackpoint Fixes:
Check in `scripts`

Auto light/dark theme based on timer
`scripts/automatic_theme_cinnamon.py --configure`

Make a startup script with
`scripts/automatic_theme_cinnamon.py --on`

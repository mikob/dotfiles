Run `bin/setup.sh` to create the proper symbolic links. To make sure
nothing you wanted to keep is overwritten, check the script before running.

Run `^A I` in tmux to install the tmux plugins.
Run `:PlugInstall` in vim to install the vim plugins.
WORKAROUND: Manually re-symbolic link prompt theme function after prezto installs it's plugins.

To have gnome-terminal work programmatically with tabs (fucking ridiculous how
hard this was to figure out and do properly):
gnome-terminal --tab -e 'zsh -c "POST_RC=\"hra && cd webapp && ./manage.py runserver\" exec zsh"' --tab-with-profile=default -e 'zsh -c "POST_RC=\"hra && cd webapp && grunt watch\" exec zsh"' --tab-with-profile=default -e 'zsh -c "POST_RC=\"hra && cd webapp\" exec zsh"'

Trackpoint Fixes:

`$ cd /sys/devices/platform/i8042/serio1/`

`$ sudo apt install sysfsutils`

`$ sudo systemctl enable sysfsutils.service`

We just need to edit /etc/sysfs.conf to do our bidding. Here is a sample from mine

```
#tweak trackpoint
devices/platform/i8042/serio1/sensitivity = 191
devices/platform/i8042/serio1/rate = 200
devices/platform/i8042/serio1/speed = 255
devices/platform/i8042/serio1/inertia = 5
```

this should up the polling rate a bit and make it much more sensitive.

You can test your new config with

`$ sudo systemctl restart sysfsconf.service`


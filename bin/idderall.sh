#!/bin/bash

cur_dir="$(pwd)"

FFX_PROFILE=~/.mozilla/firefox/e0cvqqm9.Dev/
cd ~/workspace/shockcollar
sublime &
gnome-terminal -x sleep 5;source /home/mikob/.virtualenvs/shockcollar/bin/activate;cd ~/workspace/shockcollar-site/shockcollar;./manage.py runserver 8080

#--tab -e "bash -c \"cd ~/workspace/shockcollar;~/tools/addon-sdk-1.14/bin/cfx run -p $FFX_PROFILE;echo '~/tools/addon-sdk-1.14/bin/cfx run -p $FFX_PROFILE';exec bash;\""\
#--tab -e "bash -c \"cd ~/workspace/shockcollar; exec bash\""

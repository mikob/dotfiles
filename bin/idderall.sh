#!/bin/bash

cur_dir="$(pwd)"

cd ~/workspace/shockcollar
sublime &
gnome-terminal --tab -e "bash -c \"source /home/miko/.virtualenvs/shockcollar/bin/activate;cd ~/workspace/shockcollar-site/shockcollar;./manage.py runserver 8080;exec bash\""\
    --tab -e "bash -c \"cd ~/workspace/shockcollar;~/tools/addon-sdk-1.13.2/bin/cfx run -p ~/.mozilla/firefox/e0cvqqm9.Dev/ -b /opt/firefox-latest/firefox;echo '~/tools/addon-sdk-1.13.2/bin/cfx run -p ~/.mozilla/firefox/e0cvqqm9.Dev/ -b /opt/firefox-latest/firefox;';exec bash;\""\
    --tab -e "bash -c \"cd ~/workspace/shockcollar; exec bash\""

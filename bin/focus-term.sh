#!/bin/bash
# use `xwininfo` to see window names
TERM_WIN=`xdotool search --desktop 0 --name 'Terminal'`
ACTIVE_WIN=`xdotool getactivewindow`
if [ "$TERM_WIN" -eq "$ACTIVE_WIN" ]; then
    xdotool windowminimize $TERM_WIN
else
    xdotool windowactivate $TERM_WIN
fi


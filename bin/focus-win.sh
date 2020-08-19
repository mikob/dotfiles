#!/bin/bash
# use `xwininfo` to see window names
TARGET_WIN=`xdotool search --desktop 0 --name "$1"`
ACTIVE_WIN=`xdotool getactivewindow`
if [ "$TARGET_WIN" -eq "$ACTIVE_WIN" ]; then
    xdotool windowminimize $TARGET_WIN
else
    xdotool windowactivate $TARGET_WIN
fi


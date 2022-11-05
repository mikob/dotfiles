#!/bin/bash
# use `xwininfo` to see window names
TARGET_WORKSPACE=`xdotool get_desktop`
TARGET_WIN=`xdotool search --desktop $TARGET_WORKSPACE --name "$1"`
ACTIVE_WIN=`xdotool getactivewindow`
if [ "$TARGET_WIN" -eq "$ACTIVE_WIN" ]; then
    xdotool windowminimize $TARGET_WIN
else
    xdotool windowactivate $TARGET_WIN
fi


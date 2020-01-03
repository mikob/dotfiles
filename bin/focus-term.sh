#!/bin/sh
# use `xwininfo` to see window names

TERM_WIN_ID=`xdotool search --name 'Terminal'`
xdotool windowactivate $TERM_WIN_ID

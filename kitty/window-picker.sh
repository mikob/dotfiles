#!/bin/bash

# List kitty windows and select one
WINDOW_ID=$(kitty @ ls | jq -r '.[].tabs[].windows[].title' | rofi -dmenu -p "Select window")

# Focus the selected window
kitty @ focus-window --match title:$WINDOW_ID
#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item ram right \
           --set ram \
                 update_freq=5 \
                 icon="󰘚" \
                 icon.color=$BLUE \
                 label.color=$BLUE \
                 padding_left=4 \
                 padding_right=4 \
                 icon.padding_left=6 \
                 icon.padding_right=2 \
                 label.padding_left=2 \
                 label.padding_right=6 \
                 script="$PLUGIN_DIR/ram.sh" \
           --subscribe ram mouse.entered mouse.exited

#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item ram right \
           --set ram \
                 update_freq=5 \
                 icon="󰘚" \
                 icon.color=$BLUE \
                 label.drawing=off \
                 padding_left=6 \
                 padding_right=0 \
                 icon.padding_left=0 \
                 icon.padding_right=0 \
                 icon.width=26 \
                 icon.align=center \
                 script="$PLUGIN_DIR/ram.sh" \
           --subscribe ram mouse.entered mouse.exited

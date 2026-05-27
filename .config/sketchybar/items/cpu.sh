#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item cpu right \
           --set cpu \
                 update_freq=2 \
                 icon="󰍛" \
                 icon.color=$GREEN \
                 label.color=$GREEN \
                 padding_left=4 \
                 padding_right=4 \
                 icon.padding_left=6 \
                 icon.padding_right=2 \
                 label.padding_left=2 \
                 label.padding_right=6 \
                 script="$PLUGIN_DIR/cpu.sh" \
           --subscribe cpu mouse.entered mouse.exited

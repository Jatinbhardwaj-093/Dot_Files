#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item cpu right \
           --set cpu \
                  update_freq=2 \
                  icon="󰍛" \
                  icon.color=$GREEN \
                  label.drawing=off \
                  padding_left=6 \
                  padding_right=0 \
                  icon.padding_left=0 \
                  icon.padding_right=0 \
                  icon.width=26 \
                  icon.align=center \
                  script="$PLUGIN_DIR/cpu.sh" \
            --subscribe cpu mouse.entered mouse.exited

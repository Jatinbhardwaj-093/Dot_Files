#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

sketchybar --add item agy right \
           --set agy \
                 drawing=off \
                 update_freq=3 \
                 icon=":antigravity:" \
                 icon.font="sketchybar-app-font:Regular:14.0" \
                 icon.color=$ORANGE \
                 icon.padding_left=8 \
                 icon.padding_right=4 \
                 label="Working" \
                 label.font="JetBrainsMono Nerd Font:Bold:11.5" \
                 label.color=$ORANGE \
                 label.padding_left=2 \
                 label.padding_right=8 \
                 background.color=0xff282b2c \
                 background.border_width=1 \
                 background.border_color=0x44e78a4e \
                 background.corner_radius=6 \
                 background.height=22 \
                 padding_left=2 \
                 padding_right=2 \
                 popup.background.color=0xff282b2c \
                 popup.background.border_width=1 \
                 popup.background.border_color=0x22ebdbb2 \
                 popup.background.corner_radius=8 \
                 popup.background.padding_left=4 \
                 popup.background.padding_right=4 \
                 popup.align=right \
                 script="/bin/bash $PLUGIN_DIR/agy.sh" \
                 click_script="/bin/bash $PLUGIN_DIR/agy_click.sh" \
           --subscribe agy agy_event aerospace_workspace_change front_app_switched mouse.entered mouse.exited

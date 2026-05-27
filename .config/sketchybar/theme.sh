#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

FONT="JetBrainsMono Nerd Font"

BAR_COLOR=$BG0
ITEM_BG_COLOR=$BG1
ACCENT_COLOR=$YELLOW

sketchybar --bar \
  height=32 \
  color=0xdd1d2021 \
  blur_radius=40 \
  corner_radius=14 \
  margin=10 \
  y_offset=6 \
  padding_left=6 \
  padding_right=6 \
  position=top \
  sticky=on \
  topmost=window

default=(
  padding_left=4
  padding_right=4
  icon.padding_left=4
  icon.padding_right=4
  label.padding_left=4
  label.padding_right=4
  background.height=22
  background.corner_radius=8
  icon.color=$FG1
  label.color=$FG1
)

sketchybar --default "${default[@]}"

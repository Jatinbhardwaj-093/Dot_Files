#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$BG2 background.border_color=$PURPLE
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=0x26504945 background.border_color=0x14ebdbb2
  exit 0
fi

DATE="$(date '+%I:%M %p • %a, %b %d')"
sketchybar --set clock label="$DATE"

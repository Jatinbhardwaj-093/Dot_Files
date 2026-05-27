#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$BG2 background.border_color=$GREEN
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=0x26504945 background.border_color=0x14ebdbb2
  exit 0
fi

# Get total CPU load using top (usr + sys)
CPU_LOAD=$(top -l 1 -n 0 | awk '/CPU usage/ {usr=$3; sys=$5; sub(/%/, "", usr); sub(/%/, "", sys); print usr + sys}')

COLOR=$GREEN

if [ -n "$CPU_LOAD" ]; then
  INT_LOAD=${CPU_LOAD%.*}
  
  if [ "$INT_LOAD" -ge 80 ]; then
    COLOR=$RED
  elif [ "$INT_LOAD" -ge 50 ]; then
    COLOR=$YELLOW
  fi
fi

printf -v FMT_LOAD "%.1f%%" "$CPU_LOAD" 2>/dev/null || FMT_LOAD="${CPU_LOAD}%"

sketchybar --set $NAME \
             icon.color=$COLOR \
             label.color=$COLOR \
             label="$FMT_LOAD"

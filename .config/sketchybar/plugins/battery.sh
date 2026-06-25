#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

PERCENTAGE="$(pmset -g batt | grep -Eo '\d+%' | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ -z "$PERCENTAGE" ]; then
  exit 0
fi

# Determine Dynamic Color
COLOR=$GREEN
if [ -n "$CHARGING" ]; then
  COLOR=$AQUA
else
  if [ "$PERCENTAGE" -lt 15 ]; then
    COLOR=$RED
  elif [ "$PERCENTAGE" -lt 35 ]; then
    COLOR=$ORANGE
  elif [ "$PERCENTAGE" -lt 75 ]; then
    COLOR=$YELLOW
  fi
fi

# Handle Mouse Hover
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$BG2 background.border_color=$COLOR
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=0x26504945 background.border_color=0x14ebdbb2
  exit 0
fi

# Determine Dynamic Icon
if [ -n "$CHARGING" ]; then
  ICON="󰂄"
else
  if [ "$PERCENTAGE" -ge 95 ]; then
    ICON="󰁹"
  elif [ "$PERCENTAGE" -ge 85 ]; then
    ICON="󰂂"
  elif [ "$PERCENTAGE" -ge 75 ]; then
    ICON="󰂁"
  elif [ "$PERCENTAGE" -ge 65 ]; then
    ICON="󰂀"
  elif [ "$PERCENTAGE" -ge 55 ]; then
    ICON="󰁿"
  elif [ "$PERCENTAGE" -ge 45 ]; then
    ICON="󰁾"
  elif [ "$PERCENTAGE" -ge 35 ]; then
    ICON="󰁽"
  elif [ "$PERCENTAGE" -ge 25 ]; then
    ICON="󰁼"
  elif [ "$PERCENTAGE" -ge 15 ]; then
    ICON="󰁻"
  elif [ "$PERCENTAGE" -ge 5 ]; then
    ICON="󰁺"
  else
    ICON="󰂎"
  fi
fi

sketchybar --set battery icon="$ICON" icon.color=$COLOR label="${PERCENTAGE}%" label.color=$COLOR

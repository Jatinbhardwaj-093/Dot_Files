#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

# Get current volume and mute status
VOLUME=$(osascript -e "output volume of (get volume settings)" 2>/dev/null)
MUTED=$(osascript -e "output muted of (get volume settings)" 2>/dev/null)

if [ -z "$VOLUME" ]; then
  VOLUME=0
fi

if [ "$MUTED" = "true" ] || [ "$VOLUME" -eq 0 ]; then
  ICON="󰝟"
  COLOR=$RED
  LABEL="Muted"
else
  COLOR=$YELLOW
  if [ "$VOLUME" -lt 30 ]; then
    ICON="󰕿"
  elif [ "$VOLUME" -lt 70 ]; then
    ICON="󰖀"
  else
    ICON="󰕾"
  fi
  LABEL="${VOLUME}%"
fi

# Handle Mouse Hover
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set "$NAME" background.color="$BG2" background.border_color="$COLOR"
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set "$NAME" background.color="0x26504945" background.border_color="0x14ebdbb2"
  exit 0
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL" label.color="$COLOR"

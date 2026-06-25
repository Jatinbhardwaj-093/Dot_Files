#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

# Get SSID of connected Wifi
SSID=$(networksetup -getairportnetwork en0 2>/dev/null | cut -d ':' -f2- | sed 's/^ //')

# If SSID contains "is not associated" or is empty, we are disconnected
if [[ "$SSID" == *"not associated"* ]] || [ -z "$SSID" ]; then
  ICON="󰤮"
  COLOR=$RED
  LABEL="Offline"
else
  ICON="󰤨"
  COLOR=$BLUE
  LABEL="$SSID"
  # Truncate long SSIDs
  if [ ${#LABEL} -gt 12 ]; then
    LABEL="${LABEL:0:10}..."
  fi
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

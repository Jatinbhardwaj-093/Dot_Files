#!/usr/bin/env bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

CURRENT_MODE=$(aerospace list-modes --current 2>/dev/null)
if [ -z "$CURRENT_MODE" ]; then
  CURRENT_MODE="main"
fi

if [ "$CURRENT_MODE" = "main" ]; then
  sketchybar --set aerospace_mode drawing=off
elif [ "$CURRENT_MODE" = "resize" ]; then
  sketchybar --set aerospace_mode \
    drawing=on \
    icon="󰩨" \
    icon.color="$YELLOW" \
    label="Resize" \
    label.color="$YELLOW" \
    background.border_color="$YELLOW"
elif [ "$CURRENT_MODE" = "service" ]; then
  sketchybar --set aerospace_mode \
    drawing=on \
    icon="󰒓" \
    icon.color="$RED" \
    label="Service" \
    label.color="$RED" \
    background.border_color="$RED"
else
  sketchybar --set aerospace_mode \
    drawing=on \
    icon="󰘳" \
    icon.color="$BLUE" \
    label="$CURRENT_MODE" \
    label.color="$BLUE" \
    background.border_color="$BLUE"
fi

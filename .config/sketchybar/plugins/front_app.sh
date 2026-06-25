#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

if [ "$SENDER" = "front_app_switched" ]; then
  APP_NAME="$INFO"
else
  APP_NAME=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)
fi

__icon_map "$APP_NAME"
sketchybar --set "$NAME" icon="$icon_result"

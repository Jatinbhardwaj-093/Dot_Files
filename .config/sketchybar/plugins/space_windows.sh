#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="1"
fi

# Query unique app names in the focused workspace
APPS=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" --format "%{app-name}" 2>/dev/null | sort -u)

ICONS=""
if [ -n "$APPS" ]; then
  while IFS= read -r app; do
    if [ -n "$app" ]; then
      __icon_map "$app"
      if [ -z "$ICONS" ]; then
        ICONS="$icon_result"
      else
        ICONS="$ICONS  $icon_result"
      fi
    fi
  done <<< "$APPS"
fi

if [ -z "$ICONS" ]; then
  ICONS=":default:"
fi

sketchybar --set "$NAME" icon="$ICONS"

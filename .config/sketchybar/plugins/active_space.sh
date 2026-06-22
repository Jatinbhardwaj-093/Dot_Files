#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/icon_map.sh"

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="1"
fi

# Get unique list of open application names in the focused workspace
APPS=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" 2>/dev/null | awk -F ' \\| ' '{print $2}' | sort -u)

ICON_STR=""
if [ -n "$APPS" ]; then
  while IFS= read -r app; do
    __icon_map "$app"
    ICON_STR+="$icon_result "
  done <<< "$APPS"
fi

sketchybar --set "$NAME" icon="$ICON_STR" label="$FOCUSED_WORKSPACE"

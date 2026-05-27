#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Find current focused AeroSpace workspace
FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)

if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="1"
fi

# Get unique list of open application names in the focused workspace
APPS=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" 2>/dev/null | awk -F ' \\| ' '{print $2}' | sort -u)

APP_NAMES=""
if [ -n "$APPS" ]; then
  # Join application names with " | "
  APP_NAMES=$(echo "$APPS" | tr '\n' ',' | sed 's/,$//' | sed 's/,/ | /g')
else
  # If no apps are open, display workspace name as fallback
  APP_NAMES="$FOCUSED_WORKSPACE"
fi

sketchybar --set "$NAME" label="$APP_NAMES"

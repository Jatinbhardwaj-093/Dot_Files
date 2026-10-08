#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"

# Hover actions
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set "$NAME" background.color="$BG2" popup.drawing=on
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set "$NAME" background.color="0xff282b2c" popup.drawing=off
  exit 0
fi

# Auto-dismiss on switching to Terminal
if [ "$SENDER" = "aerospace_workspace_change" ] || [ "$SENDER" = "front_app_switched" ]; then
  FOCUSED_WS=$(aerospace list-workspaces --focused 2>/dev/null)
  if [ "$FOCUSED_WS" = "Terminal" ]; then
    python3 /Users/jatinbhardwaj/scripts/agy_sessions.py clear
    exit 0
  fi
fi

# Default render via multi-session manager
python3 /Users/jatinbhardwaj/scripts/agy_sessions.py render

#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

focused_ws=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$focused_ws" ]; then
  focused_ws="1"
fi

# Get layout of all windows in the workspace
win_layouts=$(aerospace list-windows --workspace "$focused_ws" --format "%{window-layout}" 2>/dev/null)

if [ -n "$win_layouts" ]; then
  # Check if any window is tiling (i.e. h_tiles, v_tiles, accordion)
  if echo "$win_layouts" | grep -qE "tiles|accordion"; then
    layout_mode="Tiling"
  else
    layout_mode="Floating"
  fi
else
  # No windows: check state file, default to Tiling
  state_file="$HOME/.config/aerospace/layout_state_${focused_ws}"
  if [ -f "$state_file" ]; then
    layout_mode=$(cat "$state_file")
  else
    layout_mode="Tiling"
  fi
fi

if [ "$layout_mode" = "Tiling" ]; then
  COLOR=$ORANGE
  ICON="󰕰"
  LABEL="Tiling"
else
  COLOR=$AQUA
  ICON="󰖲"
  LABEL="Floating"
fi

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$BG2 background.border_color=$COLOR
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=0x26504945 background.border_color=0x14ebdbb2
  exit 0
fi

sketchybar --set $NAME \
             icon="$ICON" \
             icon.color=$COLOR \
             label.color=$COLOR \
             label="$LABEL"

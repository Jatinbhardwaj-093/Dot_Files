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
  # Determine specific layout mode
  if echo "$win_layouts" | grep -q "h_tiles"; then
    layout_mode="h_tiles"
  elif echo "$win_layouts" | grep -q "v_tiles"; then
    layout_mode="v_tiles"
  elif echo "$win_layouts" | grep -q "h_accordion"; then
    layout_mode="h_accordion"
  elif echo "$win_layouts" | grep -q "v_accordion"; then
    layout_mode="v_accordion"
  elif echo "$win_layouts" | grep -q "floating"; then
    layout_mode="Floating"
  else
    layout_mode="Tiling"
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

if [ "$layout_mode" = "h_tiles" ] || [ "$layout_mode" = "h_accordion" ]; then
  COLOR=$ORANGE
  ICON="󰕰" 
  LABEL="H-Tiles"
elif [ "$layout_mode" = "v_tiles" ] || [ "$layout_mode" = "v_accordion" ]; then
  COLOR=$ORANGE
  ICON="󰕴" 
  LABEL="V-Tiles"
elif [ "$layout_mode" = "Floating" ]; then
  COLOR=$AQUA
  ICON="󰖲" 
  LABEL="Floating"
else
  COLOR=$ORANGE
  ICON="󰕰" 
  LABEL="Tiling"
fi

# Handle Mouse Hover
if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set "$NAME" background.color="$BG2" background.border_color="$COLOR"
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set "$NAME" background.color="0x26504945" background.border_color="0x14ebdbb2"
  exit 0
fi

sketchybar --set space_layout icon="$ICON" icon.color="$COLOR" label="$LABEL" label.color="$COLOR"

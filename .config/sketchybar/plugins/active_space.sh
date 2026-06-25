#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

# Remove all existing active space items
sketchybar --remove '/active_space\..*/'

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="1"
fi

# Get unique list of open application names in the focused workspace
APPS=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" 2>/dev/null | awk -F ' \\| ' '{print $2}' | sort -u)

if [ -n "$APPS" ]; then
  idx=0
  while IFS= read -r app; do
    if [ -z "$app" ]; then
      continue
    fi
    __icon_map "$app"
    sketchybar --add item "active_space.$idx" center \
               --set "active_space.$idx" \
                     icon="$icon_result" \
                     icon.font="sketchybar-app-font:Regular:15.0" \
                     icon.color=$FG1 \
                     icon.padding_left=4 \
                     icon.padding_right=4 \
                     icon.width=24 \
                     icon.align=center \
                     label.drawing=off \
                     background.height=20 \
                     background.corner_radius=6 \
                     background.color=0xff282b2c \
                     background.border_width=1 \
                     background.border_color=0x22ebdbb2 \
                     background.padding_left=2 \
                     background.padding_right=2 \
                     padding_left=3 \
                     padding_right=3
    idx=$((idx + 1))
  done <<< "$APPS"
fi

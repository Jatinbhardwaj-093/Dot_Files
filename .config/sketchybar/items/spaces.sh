#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

# Get current workspaces
ALL_WORKSPACES=$(aerospace list-workspaces --all)

# Preferred ordering
ORDER=("Terminal" "Browser" "Chat" "Mail" "Obsidian" "Research" "1" "2" "4" "5" "6" "7" "8" "9" "10")

# Collect ordered workspaces
SORTED_WORKSPACES=()
for w in "${ORDER[@]}"; do
  if echo "$ALL_WORKSPACES" | grep -qx "$w"; then
    SORTED_WORKSPACES+=("$w")
  fi
done

# Add any dynamic ones that aren't in the standard list
for w in $ALL_WORKSPACES; do
  if ! [[ " ${ORDER[@]} " =~ " ${w} " ]]; then
    SORTED_WORKSPACES+=("$w")
  fi
done

for sid in "${SORTED_WORKSPACES[@]}"; do
  sketchybar --add item space.$sid left \
    --set space.$sid \
    icon="$sid" \
    icon.drawing="on" \
    icon.font="JetBrainsMono Nerd Font:Bold:11.5" \
    icon.padding_left=8 \
    icon.padding_right=8 \
    label.drawing="off" \
    background.padding_left=3 \
    background.padding_right=3 \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid" \
    update_freq=0 \
    --subscribe space.$sid aerospace_workspace_change front_app_switched window_change mouse.entered mouse.exited
done

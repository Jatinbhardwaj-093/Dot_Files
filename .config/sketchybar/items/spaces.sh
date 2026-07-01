#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

# Get current workspaces with retry to handle startup race conditions
for i in {1..10}; do
  ALL_WORKSPACES=$(aerospace list-workspaces --all 2>/dev/null)
  if [ -n "$ALL_WORKSPACES" ]; then
    break
  fi
  sleep 0.5
done

# Fallback to default/persistent workspaces if AeroSpace is not running or ready
if [ -z "$ALL_WORKSPACES" ]; then
  ALL_WORKSPACES="Terminal
Browser
Chat
Mail
Obsidian
Research
Music
1"
fi

# Preferred ordering
ORDER=("Terminal" "Browser" "Chat" "Mail" "Obsidian" "Research" "Music" "1" "4" "5" "6" "7" "8" "9" "10")

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

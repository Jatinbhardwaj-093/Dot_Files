#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

PRIMARY_WORKSPACES=("Terminal" "Browser" "Chat" "Research" "Free")
SECONDARY_WORKSPACES=("Terminal-2" "Browser-2" "Chat-2" "Research-2" "Free-2")

# 1. Primary workspaces: always registered and drawn
for sid in "${PRIMARY_WORKSPACES[@]}"; do
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
    drawing="on" \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid" \
    update_freq=0 \
    --subscribe space.$sid aerospace_workspace_change front_app_switched window_change mouse.entered mouse.exited
done

# 2. Secondary workspaces: registered, but hidden (drawing=off) unless active or occupied
for sid in "${SECONDARY_WORKSPACES[@]}"; do
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
    drawing="off" \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid" \
    update_freq=0 \
    --subscribe space.$sid aerospace_workspace_change front_app_switched window_change mouse.entered mouse.exited
done

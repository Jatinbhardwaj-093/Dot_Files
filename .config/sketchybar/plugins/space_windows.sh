#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$FOCUSED_WORKSPACE" ]; then
  FOCUSED_WORKSPACE="1"
fi

# Detect currently focused app
if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  FOCUSED_APP="$INFO"
else
  FOCUSED_APP=$(aerospace list-windows --focused --format "%{app-name}" 2>/dev/null)
fi

# Query unique app names in the focused workspace
APPS=$(aerospace list-windows --workspace "$FOCUSED_WORKSPACE" --format "%{app-name}" 2>/dev/null | sort -u)

# Colors: Active app matches JankyBorders active_color ($ORANGE), inactive apps use Aqua ($AQUA)
ACTIVE_COLOR=$ORANGE
INACTIVE_COLOR="0xaa82b3a8"

MAX_SLOTS=10
INDEX=1
ARGS=()

APP_LIST=()
if [ -n "$APPS" ]; then
  while IFS= read -r app; do
    [ -n "$app" ] && APP_LIST+=("$app")
  done <<< "$APPS"
fi

TOTAL=${#APP_LIST[@]}

if [ "$TOTAL" -gt 0 ]; then
  for app in "${APP_LIST[@]}"; do
    [ "$INDEX" -gt "$MAX_SLOTS" ] && break

    __icon_map "$app"

    if [ "$app" = "$FOCUSED_APP" ]; then
      COLOR=$ACTIVE_COLOR
    else
      COLOR=$INACTIVE_COLOR
    fi

    # Dynamic padding for smooth capsule appearance
    PAD_L=4
    PAD_R=4
    [ "$INDEX" -eq 1 ] && PAD_L=8
    [ "$INDEX" -eq "$TOTAL" ] && PAD_R=8

    ARGS+=(--set "space_windows.$INDEX" \
      drawing=on \
      icon="$icon_result" \
      icon.color="$COLOR" \
      icon.padding_left="$PAD_L" \
      icon.padding_right="$PAD_R" \
      click_script="open -a '$app'")

    INDEX=$((INDEX + 1))
  done
fi

# Hide remaining unused slots
for ((i=INDEX; i<=MAX_SLOTS; i++)); do
  ARGS+=(--set "space_windows.$i" drawing=off)
done

if [ ${#ARGS[@]} -gt 0 ]; then
  sketchybar "${ARGS[@]}"
fi


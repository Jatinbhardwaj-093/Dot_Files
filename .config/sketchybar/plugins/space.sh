#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icon_map.sh"

SPACE_NAME="${NAME#space.}"

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$FOCUSED" ]; then
  FOCUSED="Free"
fi

WINDOW_COUNT=$(aerospace list-windows --workspace "$SPACE_NAME" 2>/dev/null | wc -l | tr -d ' ')

# Query unique app names in the workspace
ICONS=""
if [ "$SPACE_NAME" = "Free" ]; then
  APPS=$(aerospace list-windows --workspace "$SPACE_NAME" --format "%{app-name}" 2>/dev/null | sort -u)
  if [ -n "$APPS" ]; then
    while IFS= read -r app; do
      if [ -n "$app" ]; then
        __icon_map "$app"
        if [ -z "$ICONS" ]; then
          ICONS="$icon_result"
        else
          ICONS="$ICONS  $icon_result"
        fi
      fi
    done <<< "$APPS"
  fi
fi

if [ -n "$ICONS" ]; then
  sketchybar --set "$NAME" label="$ICONS" label.drawing=on label.font="sketchybar-app-font:Regular:15.0" label.padding_right=10
else
  sketchybar --set "$NAME" label.drawing=off
fi

if [ "$SPACE_NAME" = "$FOCUSED" ]; then
  # HERO: active workspace must pop — solid Gruvbox yellow, black text
  if [ "$SENDER" = "mouse.entered" ]; then
    sketchybar --set "$NAME" \
      background.color="$ORANGE" \
      background.border_width=0 \
      icon.color="$BLACK" \
      label.color="$BLACK"
  else
    sketchybar --set "$NAME" \
      background.color="$YELLOW" \
      background.border_width=0 \
      icon.color="$BLACK" \
      label.color="$BLACK"
  fi

elif [ "$WINDOW_COUNT" -gt 0 ]; then
  # Occupied but inactive: warm dark pill, yellow edge so it reads "alive"
  if [ "$SENDER" = "mouse.entered" ]; then
    sketchybar --set "$NAME" \
      background.color="$BG2" \
      background.border_width=1 \
      background.border_color="$YELLOW" \
      icon.color="$FG0" \
      label.color="$FG0"
  else
    sketchybar --set "$NAME" \
      background.color="0xff282b2c" \
      background.border_width=1 \
      background.border_color="0x44ebdbb2" \
      icon.color="$FG0" \
      label.color="$FG0"
  fi

else
  # Empty: ghost pill, no border noise
  if [ "$SENDER" = "mouse.entered" ]; then
    sketchybar --set "$NAME" \
      background.color="$BG1" \
      background.border_width=1 \
      background.border_color="$GRAY" \
      icon.color="$FG1" \
      label.color="$FG1"
  else
    sketchybar --set "$NAME" \
      background.color="0x441d2021" \
      background.border_width=1 \
      background.border_color="0x14ebdbb2" \
      icon.color="$GRAY" \
      label.color="$GRAY"
  fi
fi

#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

source "$HOME/.config/sketchybar/colors.sh"

SPACE_NAME="${NAME#space.}"

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -z "$FOCUSED" ]; then
  FOCUSED="1"
fi

WINDOW_COUNT=$(aerospace list-windows --workspace "$SPACE_NAME" 2>/dev/null | wc -l | tr -d ' ')

if [ "$SPACE_NAME" = "$FOCUSED" ]; then
  # Current active workspace
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
  # Workspace has windows/apps
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
  # Empty workspace
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

#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  case "$NAME" in
    "apple.sleep") GLOW_COLOR=$BLUE ;;
    "apple.lock") GLOW_COLOR=$PURPLE ;;
    "apple.restart") GLOW_COLOR=$YELLOW ;;
    "apple.shutdown") GLOW_COLOR=$RED ;;
    *) GLOW_COLOR=$FG2 ;;
  esac
  sketchybar --set "$NAME" background.color=0x26504945 background.border_width=1 background.border_color=$GLOW_COLOR
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set "$NAME" background.color=$TRANSPARENT background.border_width=0
elif [ "$SENDER" = "mouse.clicked" ]; then
  # Instantly dismiss the popup first for quick UI response
  sketchybar --set apple popup.drawing=off
  
  case "$NAME" in
    "apple.about")
      open -a "System Information"
      ;;
    "apple.settings")
      open -a "System Settings"
      ;;
    "apple.sleep")
      pmset sleepnow
      ;;
    "apple.lock")
      # Lock screen shortcut (Ctrl+Cmd+Q) or fall back to ScreenSaverEngine
      osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}' || open -a ScreenSaverEngine
      ;;
    "apple.restart")
      osascript -e 'tell app "System Events" to restart'
      ;;
    "apple.shutdown")
      osascript -e 'tell app "System Events" to shut down'
      ;;
  esac
fi

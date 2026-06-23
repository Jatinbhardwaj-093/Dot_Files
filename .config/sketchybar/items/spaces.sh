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
  # Determine label and icon based on whether it is a named space or a numbered space
  if [[ "$sid" =~ ^[0-9]+$ ]]; then
    # It's a number - use outline digits
    case "$sid" in
      1) icon_str="󰎤" ;;
      2) icon_str="󰎧" ;;
      3) icon_str="󰎪" ;;
      4) icon_str="󰎭" ;;
      5) icon_str="󰎱" ;;
      6) icon_str="󰎴" ;;
      7) icon_str="󰎷" ;;
      8) icon_str="󰎺" ;;
      9) icon_str="󰎽" ;;
      10) icon_str="󰎡" ;;
      *) icon_str="$sid" ;;
    esac
    icon_font="JetBrainsMono Nerd Font:Bold:14.0"
  else
    # It's a named space
    case "$sid" in
      "Terminal") icon_str=":ghostty:" ;;
      "Browser") icon_str=":safari:" ;;
      "Chat") icon_str=":discord:" ;;
      "Obsidian") icon_str=":obsidian:" ;;
      "Research") icon_str=":zotero:" ;;
      *) icon_str=":default:" ;; # default icon for unknown named spaces
    esac
    icon_font="sketchybar-app-font:Regular:15.0"
  fi

  sketchybar --add item space.$sid left \
    --set space.$sid \
    icon="$icon_str" \
    icon.drawing="off" \
    icon.font="$icon_font" \
    icon.padding_left=10 \
    icon.padding_right=10 \
    label="$sid" \
    label.drawing="on" \
    label.font="JetBrainsMono Nerd Font:Bold:13.0" \
    label.padding_left=10 \
    label.padding_right=10 \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid" \
    update_freq=1 \
    --subscribe space.$sid aerospace_workspace_change front_app_switched mouse.entered mouse.exited
done

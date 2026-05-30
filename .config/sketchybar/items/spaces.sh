#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
source "$HOME/.config/sketchybar/colors.sh"

# Get current workspaces
ALL_WORKSPACES=$(aerospace list-workspaces --all)

# Preferred ordering
ORDER=("Terminal" "Browser" "Chat" "Obsidian" "Research" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

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
    label_str=""
    icon_drawing="on"
    label_drawing="off"
    
    icon_padding_left=10
    icon_padding_right=10
    label_padding_left=0
    label_padding_right=0
  else
    # It's a named space
    label_str="$sid"
    icon_drawing="on"
    label_drawing="on"
    
    icon_padding_left=10
    icon_padding_right=6
    label_padding_left=0
    label_padding_right=10
    
    case "$sid" in
      "Terminal") icon_str="󰆍" ;;
      "Browser") icon_str="󰖟" ;;
      "Chat") icon_str="󰭹" ;;
      "Obsidian") icon_str="󱞎" ;;
      "Research") icon_str="󰗚" ;;
      *) icon_str="󰣆" ;; # default icon for unknown named spaces
    esac
  fi

  sketchybar --add item space.$sid left \
    --set space.$sid \
    icon="$icon_str" \
    icon.drawing="$icon_drawing" \
    icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
    icon.padding_left="$icon_padding_left" \
    icon.padding_right="$icon_padding_right" \
    label="$label_str" \
    label.drawing="$label_drawing" \
    label.font="JetBrainsMono Nerd Font:Bold:13.0" \
    label.padding_left="$label_padding_left" \
    label.padding_right="$label_padding_right" \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid" \
    update_freq=1 \
    --subscribe space.$sid aerospace_workspace_change front_app_switched mouse.entered mouse.exited
done

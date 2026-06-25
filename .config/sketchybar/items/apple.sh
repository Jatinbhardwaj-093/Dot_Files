#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

PLUGIN_DIR="$HOME/.config/sketchybar/plugins"

sketchybar --add item apple left \
           --set apple icon="" \
                 icon.font="JetBrainsMono Nerd Font:Bold:16.0" \
                 icon.color=$FG0 \
                 background.color=0xff282b2c \
                 background.border_width=1 \
                 background.border_color=0x22ebdbb2 \
                 background.corner_radius=6 \
                 background.height=22 \
                 icon.padding_left=8 \
                 icon.padding_right=8 \
                 label.drawing=off \
                 popup.drawing=off \
                 popup.background.color=0xe61d2021 \
                 popup.background.corner_radius=12 \
                 popup.background.border_width=1 \
                 popup.background.border_color=0x22ebdbb2 \
                 popup.background.shadow.drawing=on \
                 popup.blur_radius=30 \
                 popup.y_offset=10 \
                 popup.height=0 \
                 click_script="sketchybar --set apple popup.drawing=toggle"

# Spacer Top
sketchybar --add item apple.spacer_top popup.apple \
           --set apple.spacer_top drawing=on \
                 icon.drawing=off \
                 label.drawing=off \
                 background.height=6 \
                 background.color=$TRANSPARENT \
                 width=170

# Common properties for menu items
default_item=(
  icon.font="JetBrainsMono Nerd Font:Bold:14.0"
  label.font="JetBrainsMono Nerd Font:Bold:12.0"
  icon.color=$FG1
  label.color=$FG1
  icon.padding_left=12
  icon.padding_right=8
  label.padding_left=4
  label.padding_right=12
  padding_left=10
  padding_right=10
  background.corner_radius=8
  background.height=28
  width=170
  align=left
  background.color=$TRANSPARENT
  script="$PLUGIN_DIR/apple_item.sh"
)

# 1. About This Mac
sketchybar --add item apple.about popup.apple \
           --set apple.about "${default_item[@]}" \
                 icon="󰀵" \
                 label="About This Mac" \
           --subscribe apple.about mouse.entered mouse.exited mouse.clicked

# 2. System Settings
sketchybar --add item apple.settings popup.apple \
           --set apple.settings "${default_item[@]}" \
                 icon="󰒓" \
                 label="System Settings" \
           --subscribe apple.settings mouse.entered mouse.exited mouse.clicked

# Divider 1 (Width 170 + Padding 10 + 10 = 190 total width)
sketchybar --add item apple.divider1 popup.apple \
           --set apple.divider1 icon.drawing=off label.drawing=off \
                 background.color=0x14ebdbb2 background.height=1 \
                 padding_left=10 padding_right=10 width=170 y_offset=-2

# 3. Sleep
sketchybar --add item apple.sleep popup.apple \
           --set apple.sleep "${default_item[@]}" \
                 icon="󰒲" \
                 label="Sleep" \
                 icon.color=$BLUE \
           --subscribe apple.sleep mouse.entered mouse.exited mouse.clicked

# 4. Lock Screen
sketchybar --add item apple.lock popup.apple \
           --set apple.lock "${default_item[@]}" \
                 icon="󰌾" \
                 label="Lock Screen" \
                 icon.color=$PURPLE \
           --subscribe apple.lock mouse.entered mouse.exited mouse.clicked

# Divider 2 (Width 170 + Padding 10 + 10 = 190 total width)
sketchybar --add item apple.divider2 popup.apple \
           --set apple.divider2 icon.drawing=off label.drawing=off \
                 background.color=0x14ebdbb2 background.height=1 \
                 padding_left=10 padding_right=10 width=170 y_offset=-2

# 5. Restart
sketchybar --add item apple.restart popup.apple \
           --set apple.restart "${default_item[@]}" \
                 icon="󰑓" \
                 label="Restart" \
                 icon.color=$YELLOW \
           --subscribe apple.restart mouse.entered mouse.exited mouse.clicked

# 6. Shut Down
sketchybar --add item apple.shutdown popup.apple \
           --set apple.shutdown "${default_item[@]}" \
                 icon="󰐥" \
                 label="Shut Down" \
                 icon.color=$RED \
           --subscribe apple.shutdown mouse.entered mouse.exited mouse.clicked

# Spacer Bottom
sketchybar --add item apple.spacer_bottom popup.apple \
           --set apple.spacer_bottom drawing=on \
                 icon.drawing=off \
                 label.drawing=off \
                 background.height=6 \
                 background.color=$TRANSPARENT \
                 width=170

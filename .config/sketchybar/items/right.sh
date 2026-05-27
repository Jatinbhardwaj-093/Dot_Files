#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"

ITEM_BG=0xff3c3836

# =========================================================
# WIFI
# =========================================================

sketchybar --add item wifi right \
  --set wifi \
  icon=󰤨 \
  icon.color=$BLUE \
  label.drawing=off \
  background.color=$ITEM_BG \
  background.corner_radius=8 \
  background.height=22 \
  padding_left=4 \
  padding_right=4

# =========================================================
# BLUETOOTH
# =========================================================

sketchybar --add item bluetooth right \
  --set bluetooth \
  icon=󰂯 \
  icon.color=$AQUA \
  label.drawing=off \
  background.color=$ITEM_BG \
  background.corner_radius=8 \
  background.height=22 \
  padding_left=4 \
  padding_right=4

# =========================================================
# FOCUS MODE
# =========================================================

sketchybar --add item focus right \
  --set focus \
  icon=󰒲 \
  icon.color=$PURPLE \
  label.drawing=off \
  background.color=$ITEM_BG \
  background.corner_radius=8 \
  background.height=22 \
  padding_left=4 \
  padding_right=4

# =========================================================
# AUDIO OUTPUT
# =========================================================

sketchybar --add item volume right \
  --set volume \
  icon=󰕾 \
  icon.color=$YELLOW \
  label.drawing=off \
  background.color=$ITEM_BG \
  background.corner_radius=8 \
  background.height=22 \
  padding_left=4 \
  padding_right=4

# =========================================================
# BATTERY
# =========================================================

sketchybar --add item battery right \
  --set battery \
  update_freq=30 \
  icon.color=$GREEN \
  background.color=$ITEM_BG \
  background.corner_radius=8 \
  background.height=22 \
  padding_left=6 \
  padding_right=6 \
  script="$PLUGIN_DIR/battery.sh"

# =========================================================
# CLOCK
# =========================================================

sketchybar --add item clock right \
  --set clock \
  update_freq=10 \
  icon=󰃰 \
  icon.color=$ORANGE \
  label.color=$FG1 \
  background.color=$ITEM_BG \
  background.corner_radius=8 \
  background.height=22 \
  padding_left=8 \
  padding_right=8 \
  script="$PLUGIN_DIR/clock.sh"

#!/bin/bash
source "$HOME/.config/sketchybar/colors.sh"

if [ "$SENDER" = "mouse.entered" ]; then
  sketchybar --set $NAME background.color=$BG2 background.border_color=$BLUE
  exit 0
elif [ "$SENDER" = "mouse.exited" ]; then
  sketchybar --set $NAME background.color=0x26504945 background.border_color=0x14ebdbb2
  exit 0
fi

# Calculate RAM usage percentage and absolute size in GB using vm_stat and sysctl
RAM_INFO=$(vm_stat | awk -v total_bytes=$(sysctl -n hw.memsize) '
  /page size of/ {sub(/\./, "", $8); pgsize=$8}
  /Pages active:/ {active=$3; sub(/\./, "", active)}
  /Pages wired down:/ {wired=$4; sub(/\./, "", wired)}
  /Pages occupied by compressor:/ {comp=$5; sub(/\./, "", comp)}
  END {
    used_bytes = (active + wired + comp) * pgsize
    pct = (used_bytes / total_bytes) * 100
    used_gb = used_bytes / (1024 * 1024 * 1024)
    printf "%.1f %.1f\n", pct, used_gb
  }
')

PCT=$(echo "$RAM_INFO" | awk '{print $1}')
USED_GB=$(echo "$RAM_INFO" | awk '{print $2}')

COLOR=$BLUE

if [ -n "$PCT" ]; then
  INT_PCT=${PCT%.*}
  
  if [ "$INT_PCT" -ge 85 ]; then
    COLOR=$RED
  elif [ "$INT_PCT" -ge 70 ]; then
    COLOR=$ORANGE
  fi
fi

sketchybar --set ram icon.color=$COLOR label="${PCT}%" label.color=$COLOR

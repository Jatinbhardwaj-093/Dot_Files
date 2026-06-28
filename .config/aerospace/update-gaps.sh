#!/usr/bin/env bash

# Query the focused display's physical width, menu bar height, and display type using JXA
DISPLAY_INFO=$(osascript -l JavaScript <<EOF 2>/dev/null
ObjC.import("Cocoa");
var mainScreen = $.NSScreen.mainScreen;
if (mainScreen) {
    var frame = mainScreen.frame;
    var visible = mainScreen.visibleFrame;
    var m_height = frame.size.height - (visible.size.height + visible.origin.y);
    var width = frame.size.width;
    var name = ObjC.unwrap(mainScreen.localizedName) || "";
    var isBuiltin = name.toLowerCase().indexOf("built-in") !== -1 || name.toLowerCase().indexOf("retina") !== -1;
    JSON.stringify({ width: Math.round(width), m_height: Math.round(m_height), is_builtin: isBuiltin });
} else {
    JSON.stringify({ width: 0, m_height: 0, is_builtin: false });
}
EOF
)

# Parse JSON values
WIDTH=$(echo "$DISPLAY_INFO" | grep -o -E '"width":[0-9]+' | cut -d: -f2)
MENU_BAR_HEIGHT=$(echo "$DISPLAY_INFO" | grep -o -E '"m_height":[0-9]+' | cut -d: -f2)
IS_BUILTIN=$(echo "$DISPLAY_INFO" | grep -o -E '"is_builtin":(true|false)' | cut -d: -f2)

# Fallback values
if [ -z "$WIDTH" ] || [ "$WIDTH" -eq 0 ]; then
    WIDTH=1512
fi
if [ -z "$MENU_BAR_HEIGHT" ]; then
    MENU_BAR_HEIGHT=0
fi

# Define adaptive geometry boundaries
# Desktop display: external screen or width > 2000
# Mac original display: built-in screen with width <= 2000
if [ "$IS_BUILTIN" = "false" ] || [ "$WIDTH" -gt 2000 ]; then
    # External / Desktop Monitor padding
    NEW_INNER=16
    NEW_OUTER=16
    SK_MARGIN=16
    SK_Y_OFFSET=16
    SK_PADDING=16
    BAR_HEIGHT=36
    TARGET_LEFT=16
    TARGET_TOP=50
else
    # Mac original / built-in laptop display padding
    NEW_INNER=10
    NEW_OUTER=10
    SK_MARGIN=10
    SK_Y_OFFSET=10
    SK_PADDING=10
    BAR_HEIGHT=32
    TARGET_LEFT=10
    TARGET_TOP=16
fi

NEW_TOP=$TARGET_TOP
if [ "$NEW_TOP" -lt 0 ]; then
    NEW_TOP=0
fi

NEW_LEFT=$TARGET_LEFT

CONFIG_FILE="$HOME/.aerospace.toml"

# Read the current gaps from the config file using POSIX compatible character class
CURRENT_TOP=$(grep -E "^[[:space:]]*outer.top[[:space:]]*=" "$CONFIG_FILE" | grep -o -E "[0-9]+")
CURRENT_LEFT=$(grep -E "^[[:space:]]*outer.left[[:space:]]*=" "$CONFIG_FILE" | grep -o -E "[0-9]+")
CURRENT_INNER=$(grep -E "^[[:space:]]*inner.horizontal[[:space:]]*=" "$CONFIG_FILE" | grep -o -E "[0-9]+")

# Update SketchyBar dynamically at runtime (instantaneous, no flicker)
sketchybar --bar \
  margin="$SK_MARGIN" \
  y_offset="$SK_Y_OFFSET" \
  height="$BAR_HEIGHT" 2>/dev/null

# If current settings are different, perform atomic update to avoid reload loops
if [ "$CURRENT_TOP" != "$NEW_TOP" ] || [ "$CURRENT_LEFT" != "$NEW_LEFT" ] || [ "$CURRENT_INNER" != "$NEW_INNER" ]; then
    # Update all gaps atomically in a single pass to prevent redundant AeroSpace reloads
    sed -i '' \
      -e "s/\(inner.horizontal[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_INNER/" \
      -e "s/\(inner.vertical[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_INNER/" \
      -e "s/\(outer.left[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_LEFT/" \
      -e "s/\(outer.right[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_OUTER/" \
      -e "s/\(outer.bottom[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_OUTER/" \
      -e "s/\(outer.top[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_TOP/" \
      "$CONFIG_FILE"
fi

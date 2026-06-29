#!/usr/bin/env bash

# Query the focused display's physical properties using Apple CoreGraphics API via JXA
DISPLAY_INFO=$(osascript -l JavaScript <<EOF 2>/dev/null
ObjC.import("Cocoa");
ObjC.import("CoreGraphics");
var mainScreen = $.NSScreen.mainScreen;
if (mainScreen) {
    var frame = mainScreen.frame;
    var visible = mainScreen.visibleFrame;
    var m_height = frame.size.height - (visible.size.height + visible.origin.y);
    var width = frame.size.width;
    var deviceDescription = mainScreen.deviceDescription;
    var displayID = deviceDescription.objectForKey("NSScreenNumber").unsignedIntValue;
    var isBuiltin = $.CGDisplayIsBuiltin(displayID) == 1;
    JSON.stringify({ width: Math.round(width), m_height: Math.round(m_height), is_builtin: isBuiltin });
} else {
    JSON.stringify({ width: 0, m_height: 0, is_builtin: false });
}
EOF
)

# Parse JSON values
WIDTH=$(echo "$DISPLAY_INFO" | grep -o -E '"width":[0-9]+' | cut -d: -f2)
IS_BUILTIN=$(echo "$DISPLAY_INFO" | grep -o -E '"is_builtin":(true|false)' | cut -d: -f2)

# Fallback values
if [ -z "$WIDTH" ] || [ "$WIDTH" -eq 0 ]; then
    WIDTH=1512
fi

# Define adaptive geometry boundaries:
# External Desktop Monitor (top gap 50) vs Built-in Laptop Display (top gap 46)
if [ "$IS_BUILTIN" = "false" ] || [ "$WIDTH" -gt 2000 ]; then
    NEW_INNER=10
    NEW_OUTER=10
    SK_MARGIN=10
    SK_Y_OFFSET=10
    BAR_HEIGHT=34
    TARGET_TOP=50
else
    NEW_INNER=10
    NEW_OUTER=10
    SK_MARGIN=10
    SK_Y_OFFSET=8
    BAR_HEIGHT=32
    TARGET_TOP=46
fi

CONFIG_FILE="$HOME/.aerospace.toml"

# Read current gaps from config file
CURRENT_TOP=$(grep -E "^[[:space:]]*outer.top[[:space:]]*=" "$CONFIG_FILE" | grep -o -E "[0-9]+")
CURRENT_INNER=$(grep -E "^[[:space:]]*inner.horizontal[[:space:]]*=" "$CONFIG_FILE" | grep -o -E "[0-9]+")

# Update SketchyBar dynamically at runtime
sketchybar --bar \
  margin="$SK_MARGIN" \
  y_offset="$SK_Y_OFFSET" \
  height="$BAR_HEIGHT" 2>/dev/null

# Update gaps if necessary
if [ "$CURRENT_TOP" != "$TARGET_TOP" ] || [ "$CURRENT_INNER" != "$NEW_INNER" ]; then
    sed -i '' \
      -e "s/\(inner.horizontal[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_INNER/" \
      -e "s/\(inner.vertical[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_INNER/" \
      -e "s/\(outer.left[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_OUTER/" \
      -e "s/\(outer.right[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_OUTER/" \
      -e "s/\(outer.bottom[[:space:]]*=[[:space:]]*\)[0-9]*/\1$NEW_OUTER/" \
      -e "s/\(outer.top[[:space:]]*=[[:space:]]*\)[0-9]*/\1$TARGET_TOP/" \
      "$CONFIG_FILE"
fi

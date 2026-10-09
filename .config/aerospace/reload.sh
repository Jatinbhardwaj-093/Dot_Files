#!/usr/bin/env bash

# Export Homebrew binary path for environment compatibility
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

echo "==> Reloading window management stack..."

# 1. Reload AeroSpace
echo -n "  • AeroSpace: "
if aerospace reload-config; then
  echo "✓ reloaded"
else
  echo "✗ error"
fi

# 2. Reload SketchyBar
echo -n "  • SketchyBar: "
if sketchybar --reload; then
  echo "✓ reloaded"
else
  echo "✗ error"
fi

# 3. Reload JankyBorders
echo -n "  • JankyBorders: "
if "$HOME/.config/borders/bordersrc"; then
  echo "✓ reloaded"
else
  echo "✗ error"
fi

echo "==> All components reloaded!"

# Notification feedback
osascript -e 'display notification "AeroSpace, SketchyBar & Borders reloaded!" with title "Config Reload"' 2>/dev/null || true

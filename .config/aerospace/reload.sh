#!/usr/bin/env bash

# Export Homebrew binary path for environment compatibility
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

echo "Updating display gaps..."
/Users/jatinbhardwaj/.config/aerospace/update-gaps.sh 2>/dev/null || true

echo "Reloading AeroSpace configuration..."
aerospace reload-config 2>/dev/null || true

echo "Reloading SketchyBar configuration..."
sketchybar --reload 2>/dev/null || true

osascript -e 'display notification "AeroSpace and SketchyBar reloaded successfully!" with title "Config Reload"' 2>/dev/null || true
echo "Done!"

#!/usr/bin/env bash

# Automatically update AeroSpace top window gaps based on current screen's menu bar height
/Users/jatinbhardwaj/.config/aerospace/update-gaps.sh

# Trigger SketchyBar update
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"

# Automatically open Zotero only when visiting the Research workspace
if [ "$AEROSPACE_FOCUSED_WORKSPACE" = "Research" ]; then
    open -a Zotero
fi

#!/usr/bin/env bash

# Trigger SketchyBar update on workspace change smoothly without reloading config
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$AEROSPACE_FOCUSED_WORKSPACE"

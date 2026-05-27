#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Get the currently focused workspace name
focused_ws=$(aerospace list-workspaces --focused)

if [ -n "$focused_ws" ]; then
    # List all window IDs in the focused workspace
    win_ids=$(aerospace list-windows --workspace "$focused_ws" | cut -d'|' -f1 | tr -d ' ')
    
    # Loop through each window and toggle its layout status between floating and tiling
    for win_id in $win_ids; do
        if [ -n "$win_id" ]; then
            aerospace layout --window-id "$win_id" floating tiling
        fi
    done
fi

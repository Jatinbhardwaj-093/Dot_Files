#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Get the currently focused workspace name
focused_ws=$(aerospace list-workspaces --focused)

if [ -n "$focused_ws" ]; then
    # Get current window layouts in this workspace
    win_layouts=$(aerospace list-windows --workspace "$focused_ws" --format "%{window-layout}" 2>/dev/null)
    
    if [ -n "$win_layouts" ]; then
        if echo "$win_layouts" | grep -qE "tiles|accordion"; then
            current_mode="Tiling"
        else
            current_mode="Floating"
        fi
    else
        state_file="$HOME/.config/aerospace/layout_state_${focused_ws}"
        if [ -f "$state_file" ]; then
            current_mode=$(cat "$state_file")
        else
            current_mode="Tiling"
        fi
    fi
    
    if [ "$current_mode" = "Tiling" ]; then
        new_mode="Floating"
    else
        new_mode="Tiling"
    fi
    
    # Save the new mode
    echo "$new_mode" > "$HOME/.config/aerospace/layout_state_${focused_ws}"
    
    # Toggle windows
    win_ids=$(aerospace list-windows --workspace "$focused_ws" | cut -d'|' -f1 | tr -d ' ')
    for win_id in $win_ids; do
        if [ -n "$win_id" ]; then
            if [ "$new_mode" = "Floating" ]; then
                aerospace layout --window-id "$win_id" floating
            else
                aerospace layout --window-id "$win_id" tiling
            fi
        fi
    done
    
    # Trigger sketchybar update
    sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$focused_ws"
fi

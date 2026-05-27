#!/bin/bash

# Exit on error
set -e

# Robust PATH for macOS (Homebrew + System)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Repository directory
REPO_DIR="/Users/jatinbhardwaj/Github/dot_files"
LOG_FILE="$REPO_DIR/sync.log"

# Function to log messages
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "Starting dotfiles sync..."

# Ensure we are in a clean state and have the latest updates
cd "$REPO_DIR"

# 1. Zshrc
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$REPO_DIR/.zshrc"
    log "Synced .zshrc"
fi

# 2. Tmux
if [ -f "$HOME/.tmux.conf" ]; then
    cp "$HOME/.tmux.conf" "$REPO_DIR/.tmux.conf"
    log "Synced .tmux.conf"
fi

# 3. Starship
if [ -f "$HOME/.config/starship/starship.toml" ]; then
    cp "$HOME/.config/starship/starship.toml" "$REPO_DIR/starship.toml"
    log "Synced starship.toml"
fi

# 4. Neovim Init
if [ -f "$HOME/.config/nvim/init.lua" ]; then
    cp "$HOME/.config/nvim/init.lua" "$REPO_DIR/vim_init.lua"
    log "Synced vim_init.lua"
fi

# 5. Neovim Mappings
if [ -f "$HOME/.config/nvim/lua/mappings.lua" ]; then
    cp "$HOME/.config/nvim/lua/mappings.lua" "$REPO_DIR/vim_mappings.lua"
    log "Synced vim_mappings.lua"
fi

# 5b. Neovim Float Term
if [ -f "$HOME/.config/nvim/lua/float_term.lua" ]; then
    cp "$HOME/.config/nvim/lua/float_term.lua" "$REPO_DIR/vim_float_term.lua"
    log "Synced vim_float_term.lua"
fi

# 6. Ghostty Config
GHOSTTY_CONF="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
if [ -f "$GHOSTTY_CONF" ]; then
    cp "$GHOSTTY_CONF" "$REPO_DIR/.ghostty_config"
    log "Synced .ghostty_config"
fi

# 7. Aerospace config (file)
if [ -f "$HOME/.aerospace.toml" ]; then
    cp "$HOME/.aerospace.toml" "$REPO_DIR/.aerospace.toml"
    log "Synced .aerospace.toml"
fi

# 8. Aerospace folder
if [ -d "$HOME/.config/aerospace" ]; then
    mkdir -p "$REPO_DIR/.config/aerospace"
    rsync -av --exclude '.DS_Store' --delete "$HOME/.config/aerospace/" "$REPO_DIR/.config/aerospace/"
    log "Synced .config/aerospace"
fi

# 9. Jankyborders
if [ -d "$HOME/.config/borders" ]; then
    mkdir -p "$REPO_DIR/.config/borders"
    rsync -av --exclude '.DS_Store' --delete "$HOME/.config/borders/" "$REPO_DIR/.config/borders/"
    log "Synced .config/borders"
fi

# 10. Sketchybar
if [ -d "$HOME/.config/sketchybar" ]; then
    mkdir -p "$REPO_DIR/.config/sketchybar"
    rsync -av --exclude '.DS_Store' --delete "$HOME/.config/sketchybar/" "$REPO_DIR/.config/sketchybar/"
    log "Synced .config/sketchybar"
fi

# Git Commit and Push if changes exist
if [ -n "$(git status --porcelain)" ]; then
    log "Changes detected in dotfiles. Committing and pushing..."
    git add -A
    git commit -m "Auto-update dotfiles: $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Try to push, log output
    if git push origin main >> "$LOG_FILE" 2>&1; then
        log "Successfully pushed changes to GitHub."
    else
        log "ERROR: Failed to push changes to GitHub."
    fi
else
    log "No changes detected. Nothing to commit."
fi

log "Dotfiles sync completed."

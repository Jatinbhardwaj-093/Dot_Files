#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# Focus Terminal workspace & Ghostty
aerospace workspace Terminal 2>/dev/null
open -a Ghostty 2>/dev/null

# Clear done notifications
python3 /Users/jatinbhardwaj/scripts/agy_sessions.py clear

#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

EVENT="$1"
exec python3 /Users/jatinbhardwaj/scripts/agy_sessions.py record "$EVENT"

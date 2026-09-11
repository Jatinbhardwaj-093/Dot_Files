#!/usr/bin/env python3
import time
import subprocess

def run_cmd(args):
    try:
        res = subprocess.run(args, capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except Exception:
        return ""

def ensure_tmux_restored():
    # Check if tmux server is running by running 'tmux list-sessions'
    res = subprocess.run(["tmux", "list-sessions"], capture_output=True)
    if res.returncode != 0:
        # Tmux server is not running! Boot it detatched.
        # This triggers tmux-continuum to automatically restore saved sessions in the background.
        subprocess.run(["tmux", "new-session", "-d"])
        
        # Poll for @resurrect-state (up to 3.0 seconds max) to allow restoration to complete
        start_time = time.time()
        while time.time() - start_time < 3.0:
            time.sleep(0.05)
            state = run_cmd(["tmux", "show-option", "-gqv", "@resurrect-state"])
            if state == "restored":
                break

def main():
    # Automatically restore tmux sessions silently if the server is not running
    ensure_tmux_restored()

if __name__ == "__main__":
    main()

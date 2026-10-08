#!/usr/bin/env python3
import sys
import os
import json
import time
import subprocess
import re

SESSIONS_DIR = "/tmp/agy_sessions"
os.makedirs(SESSIONS_DIR, exist_ok=True)

# Gruvbox Colors
ORANGE = "0xffe78a4e"
GREEN  = "0xffa9b665"
YELLOW = "0xffd6b676"
FG1    = "0xffc0b196"
BG1    = "0xff282b2c"
BG2    = "0xff393c3d"

def get_running_agy():
    """Return dict of {pid: cmd} for all active agy processes."""
    running = {}
    try:
        res = subprocess.run(["pgrep", "-fl", "agy"], capture_output=True, text=True)
        if res.returncode == 0:
            for line in res.stdout.strip().splitlines():
                parts = line.strip().split(None, 1)
                if parts:
                    try:
                        pid = int(parts[0])
                        # Ignore self or python scripts containing 'agy'
                        cmd = parts[1] if len(parts) > 1 else ""
                        if "agy_sessions.py" in cmd or "agy_hook" in cmd or "agy-notify" in cmd:
                            continue
                        # Verify the binary is agy
                        bin_name = os.path.basename(cmd.split()[0]) if cmd else ""
                        if bin_name == "agy" or "agy " in cmd:
                            running[pid] = cmd
                    except ValueError:
                        pass
    except Exception:
        pass
    return running

def find_parent_agy_pid():
    """Walk process ancestry to find the agy process invoking this hook."""
    running = get_running_agy()
    if not running:
        return None
    if len(running) == 1:
        return list(running.keys())[0]

    curr = os.getppid()
    while curr > 1:
        if curr in running:
            return curr
        try:
            res = subprocess.check_output(["ps", "-o", "ppid=", "-p", str(curr)], text=True).strip()
            curr = int(res)
        except Exception:
            break
    return list(running.keys())[0]

def extract_project_name(cid, workspace_paths):
    """Get clean project/workspace name."""
    if workspace_paths and isinstance(workspace_paths, list):
        wp = workspace_paths[0].rstrip("/")
        if wp and wp != os.path.expanduser("~"):
            return os.path.basename(wp)
    # Check if custom name file exists in brain
    name_file = os.path.expanduser(f"~/.gemini/antigravity-cli/brain/{cid}/.name")
    if os.path.isfile(name_file):
        try:
            with open(name_file, "r") as f:
                name = f.read().strip()
                if name:
                    return name[:20]
        except Exception:
            pass
    return "agy"

def record_event(event_type):
    """Handle hook invocation from agy."""
    raw_input = sys.stdin.read()
    payload = {}
    if raw_input.strip():
        try:
            payload = json.loads(raw_input)
        except Exception:
            pass

    cid = payload.get("conversationId")
    if not cid:
        # Fallback to single/unknown session
        cid = "default"

    project = extract_project_name(cid, payload.get("workspacePaths", []))
    pid = find_parent_agy_pid()

    status_map = {
        "pre_invocation": ("busy", "Working"),
        "stop": ("done", "Done"),
        "ask_question": ("prompt", "Input Needed"),
        "clear": ("idle", "Idle")
    }

    status, msg = status_map.get(event_type, ("busy", "Working"))

    data = {
        "id": cid,
        "pid": pid,
        "project": project,
        "status": status,
        "msg": msg,
        "updated_at": time.time()
    }

    filepath = os.path.join(SESSIONS_DIR, f"{cid}.json")
    try:
        with open(filepath, "w") as f:
            json.dump(data, f)
    except Exception:
        pass

    # Notify sketchybar
    subprocess.run(["sketchybar", "--trigger", "agy_event"], capture_output=True)

    # Output required hook JSON
    if event_type == "pre_invocation":
        print('{"injectSteps": []}')
    elif event_type == "stop":
        print('{"decision": "stop"}')
    elif event_type == "ask_question":
        print('{"decision": "allow"}')
    else:
        print('{}')

def clear_all():
    """Clear all done or idle sessions."""
    try:
        for fname in os.listdir(SESSIONS_DIR):
            fpath = os.path.join(SESSIONS_DIR, fname)
            if fname.endswith(".json"):
                try:
                    with open(fpath, "r") as f:
                        data = json.load(f)
                    data["status"] = "idle"
                    with open(fpath, "w") as f:
                        json.dump(data, f)
                except Exception:
                    pass
    except Exception:
        pass
    render_bar()

def render_bar():
    """Inspect all active sessions and update SketchyBar."""
    running_agy = get_running_agy()
    running_pids = set(running_agy.keys())

    # Load session files
    sessions = []
    if os.path.isdir(SESSIONS_DIR):
        for fname in os.listdir(SESSIONS_DIR):
            if not fname.endswith(".json"):
                continue
            fpath = os.path.join(SESSIONS_DIR, fname)
            try:
                with open(fpath, "r") as f:
                    s = json.load(f)
                spid = s.get("pid")
                # Prune if dead
                if spid and spid not in running_pids:
                    os.remove(fpath)
                    continue
                sessions.append(s)
            except Exception:
                try:
                    os.remove(fpath)
                except Exception:
                    pass

    # If running_agy has PIDs not in session files, synthesize idle sessions
    known_pids = {s.get("pid") for s in sessions if s.get("pid")}
    for rpid, rcmd in running_agy.items():
        if rpid not in known_pids:
            cid_match = re.search(r'--conversation\s+([0-9a-fA-F-]+)', rcmd)
            cid = cid_match.group(1) if cid_match else f"pid_{rpid}"
            proj = "agy"
            s = {
                "id": cid,
                "pid": rpid,
                "project": proj,
                "status": "idle",
                "msg": "Idle",
                "updated_at": time.time()
            }
            sessions.append(s)

    total = len(running_agy)
    # If pgrep found nothing, hide
    if total == 0:
        subprocess.run(["sketchybar", "--set", "agy", "drawing=off", "popup.drawing=off"], capture_output=True)
        return

    # Counts
    busy_list   = [s for s in sessions if s.get("status") == "busy"]
    prompt_list = [s for s in sessions if s.get("status") == "prompt"]
    done_list   = [s for s in sessions if s.get("status") == "done"]
    idle_list   = [s for s in sessions if s.get("status") == "idle"]

    busy_n   = len(busy_list)
    prompt_n = len(prompt_list)
    done_n   = len(done_list)
    idle_n   = total - (busy_n + prompt_n + done_n)
    if idle_n < 0:
        idle_n = 0

    # Clean existing popup items first
    subprocess.run(["sketchybar", "--remove", "/agy.s.*/"], capture_output=True)

    if total == 1:
        s = sessions[0] if sessions else {"status": "idle", "project": "agy"}
        st = s.get("status", "idle")
        proj = s.get("project", "agy")
        label_prefix = f"[{proj}] " if proj != "agy" else ""

        if st == "busy":
            color = ORANGE
            label = f"{label_prefix}Working"
            border = "0x44e78a4e"
            draw = "on"
        elif st == "prompt":
            color = YELLOW
            label = f"{label_prefix}Input Needed"
            border = "0x44d6b676"
            draw = "on"
        elif st == "done":
            color = GREEN
            label = f"{label_prefix}Done"
            border = "0x44a9b665"
            draw = "on"
        else:
            # Idle
            draw = "off"
            color = FG1
            label = f"{label_prefix}Idle"
            border = "0x14ebdbb2"

        subprocess.run([
            "sketchybar", "--set", "agy",
            f"drawing={draw}",
            'icon=:antigravity:',
            'icon.font=sketchybar-app-font:Regular:14.0',
            f'icon.color={color}',
            f'label={label}',
            f'label.color={color}',
            f'background.border_color={border}',
            'popup.drawing=off'
        ], capture_output=True)

    else:
        # Multi-session mode: 2 or more sessions open
        # Urgency color
        if prompt_n > 0:
            color = YELLOW
            border = "0x44d6b676"
        elif done_n > 0:
            color = GREEN
            border = "0x44a9b665"
        elif busy_n > 0:
            color = ORANGE
            border = "0x44e78a4e"
        else:
            color = FG1
            border = "0x22ebdbb2"

        # Label text summary
        if busy_n == total:
            status_text = f"{total} Working"
        elif done_n == total:
            status_text = f"{total} Done"
        elif prompt_n == total:
            status_text = f"{total} Input Needed"
        elif idle_n == total:
            status_text = f"{total} Active"
        else:
            parts = []
            if prompt_n: parts.append(f"{prompt_n} Input")
            if done_n:   parts.append(f"{done_n} Done")
            if busy_n:   parts.append(f"{busy_n} Busy")
            if idle_n:   parts.append(f"{idle_n} Idle")
            status_text = f"{total} • {', '.join(parts)}"

        # Set main pill
        subprocess.run([
            "sketchybar", "--set", "agy",
            "drawing=on",
            'icon=:antigravity:',
            'icon.font=sketchybar-app-font:Regular:14.0',
            f'icon.color={color}',
            f'label={status_text}',
            f'label.color={color}',
            f'background.border_color={border}'
        ], capture_output=True)

        # Build popup items showing detail for all sessions
        for idx, s in enumerate(sessions[:8], 1):
            s_proj = s.get("project", f"session-{idx}")
            s_st = s.get("status", "idle")
            if s_st == "busy":
                s_color = ORANGE
                s_desc = "Working..."
            elif s_st == "prompt":
                s_color = YELLOW
                s_desc = "Input Needed"
            elif s_st == "done":
                s_color = GREEN
                s_desc = "Done"
            else:
                s_color = FG1
                s_desc = "Idle"

            item_name = f"agy.s{idx}"
            subprocess.run([
                "sketchybar",
                "--add", "item", item_name, "popup.agy",
                "--set", item_name,
                "icon=:antigravity:",
                "icon.font=sketchybar-app-font:Regular:12.0",
                f"icon.color={s_color}",
                f"label=[{s_proj}] {s_desc}",
                f"label.color={s_color}",
                "label.font=JetBrainsMono Nerd Font:Bold:11.0",
                "padding_left=8",
                "padding_right=8",
                "background.height=20",
                "background.color=0xff282b2c",
                "click_script=aerospace workspace Terminal && open -a Ghostty"
            ], capture_output=True)

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "record" and len(sys.argv) > 2:
            record_event(sys.argv[2])
        elif cmd == "render":
            render_bar()
        elif cmd == "clear":
            clear_all()
        elif cmd == "simulate":
            # Simulate multi-session test
            os.makedirs(SESSIONS_DIR, exist_ok=True)
            with open(os.path.join(SESSIONS_DIR, "test1.json"), "w") as f:
                json.dump({"id": "test1", "pid": 7773, "project": "pgmpy", "status": "done", "updated_at": time.time()}, f)
            with open(os.path.join(SESSIONS_DIR, "test2.json"), "w") as f:
                json.dump({"id": "test2", "pid": 7773, "project": "sketchybar", "status": "busy", "updated_at": time.time()}, f)
            print("Simulated sessions written.")
    else:
        render_bar()

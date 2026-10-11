# Custom User Scripts (`~/scripts`)

This folder contains custom terminal scripts and utilities.

---

## `agyc` — Antigravity Conversation Manager & Fuzzy Picker

An interactive terminal tool to search, preview, and resume past Google Antigravity (`agy`) CLI sessions without copying or remembering 36-character UUIDs.

### Features
1. **Repository / Project Detection**: Automatically identifies the workspace project (e.g. `pgmpy`, `software_project`, or `~`) from tool calls and paths.
2. **Current Project Awareness**:
   - Running `agyc` inside any project repo automatically highlights that project's sessions (`★`).
   - Running `agyc .` filters the list strictly to sessions belonging to the current directory.
3. **Session Naming**:
   - **In-Chat**: Simply include `Naming session: <Your Title>` anywhere in your prompt. `agyc` will recognize it and display it with a `🏷 ` tag.
   - **From Terminal**: Run `agyc name "Your Title"` to name the most recent session.
4. **Session Killing & Memory Cleanup**:
   - **In-Chat**: Type `Kill session` in chat to immediately purge all session memory (artifacts, SQLite database, transcripts) and eliminate wasted memory.
   - **From Terminal**: Run `agyc kill` (or alias `kill-session` / `agyk`) to kill the most recent session, or `agyc kill <id>` for a specific session.
   - **Interactive in `agyc`**: Press `Ctrl-X` on any session in the fuzzy picker to permanently wipe it and free disk space.
   - **Pruning**: Run `agyc prune` to clean all past sessions where `Kill session` was requested.
5. **Dialogue Preview (3:2 Ratio)**:
   - 60% conversation list / 40% preview pane on the right.
   - Tool calls are folded into a single line (`▸ Folded Tools (3): view_file (x2), replace_file_content`) to prevent visual clutter and keep focus on the actual dialogue.
6. **Human Message Count**: Displays actual user requests (`4 msgs`) rather than internal LLM reasoning/tool step counts.

### Usage
```zsh
# Launch interactive fuzzy finder (Ctrl-X kills selected session)
agyc

# Filter to current directory/project only
agyc .

# Pre-filter by keyword
agyc pgmpy
agyc docker

# Name the most recent session
agyc name "Refactor Auth Middleware"

# Kill most recent session and reclaim disk space
agyc kill
# or alias
kill-session

# Kill a specific session by ID or topic
agyc kill <id>

# Prune all sessions marked with 'Kill session'
agyc prune

# Continue the single most recent session
agyc -c
# or
agyc last

# Quick terminal list of 15 recent sessions
agyc ls
```

---

## Antigravity Memory Protocol (`~/.gemini/memory/`)

Persistent cross-session knowledge is stored outside Git in `~/.gemini/memory/<project-name>.md`:
- **Clean Git**: Repositories remain 100% clean with zero `.gitignore` modifications.
- **Auto-Load**: The agent reads the project's memory file on start.
- **Handoff**: Say *"Update memory"* or *"Handoff"* at the end of a session to write the project state and next steps.

#!/usr/bin/env bash
# Desktop notification for Claude Code hooks. Dunst replaces an earlier bubble
# with the same stack tag, so each session shows at most one at a time.
#
# Setup: add this to ~/.claude/settings.json. Needs jq, xdotool, notify-send and
# dunst, plus background-tasks.jq next to this script.
#
#   "hooks": {
#     "Stop": [{ "hooks": [{ "type": "command", "command": "~/.claude/hooks/notify.sh" }] }],
#     "Notification": [{ "hooks": [{ "type": "command", "command": "~/.claude/hooks/notify.sh" }] }],
#     "PreToolUse": [{ "matcher": "AskUserQuestion", "hooks": [{ "type": "command", "command": "~/.claude/hooks/notify.sh" }] }]
#   }
set -u

input=$(cat)
event=$(jq -r '.hook_event_name // empty' <<<"$input")
session=$(jq -r '.session_id // "unknown"' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")
project=$(basename "${cwd:-$PWD}")

# The session's name as the sidebar shows it: your /rename title, else the generated one.
session_title() {
  local transcript title
  transcript=$(jq -r '.transcript_path // empty' <<<"$input")
  [[ -f "$transcript" ]] || return 1
  title=$(tac "$transcript" | grep -m1 '"type":"custom-title"' | jq -r '.customTitle // empty' 2>/dev/null)
  [[ -n "$title" ]] || title=$(tac "$transcript" | grep -m1 '"type":"ai-title"' | jq -r '.aiTitle // empty' 2>/dev/null)
  [[ -n "$title" ]] && printf '%s' "$title"
}

label=$(session_title || true)
label=${label:-$project}

QUIET_LIMIT_SECONDS=3600

# True while a background agent, command or Monitor this session started has not reported back.
has_background_work_running() {
  local transcript running
  transcript=$(jq -r '.transcript_path // empty' <<<"$input")
  [[ -f "$transcript" ]] || return 1
  running=$(jq -rn --argjson now "$(date +%s)" --argjson quiet_limit "$QUIET_LIMIT_SECONDS" \
    -f ~/.claude/hooks/background-tasks.jq "$transcript" 2>/dev/null)
  [[ -n "$running" ]]
}

case "$event" in
  Stop)
    has_background_work_running && exit 0
    summary="$label: finished"; body="" ;;
  PreToolUse) summary="$label: has a question"; body="" ;;
  Notification) summary="$label: needs you"; body=$(jq -r '.message // empty' <<<"$input") ;;
  *) exit 0 ;;
esac

# Skip when this project's VS Code window is already focused.
active_window=$(xdotool getactivewindow getwindowname 2>/dev/null || true)
if [[ "$active_window" == *"Visual Studio Code"* && "$active_window" == *"$project"* ]]; then
  exit 0
fi

notify-send -a 'Claude Code' -h "string:x-dunst-stack-tag:claude-$session" "$summary" "$body" || true

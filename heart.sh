#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$ROOT/workspace"
QUEUE="$ROOT/queue"
RUN="$ROOT/run"
DONE="$ROOT/done"

mkdir -p "$WORKSPACE" "$QUEUE" "$RUN" "$DONE"
cd "$WORKSPACE"

LOCK="$RUN/heartbeat.lock"
[ -f "$LOCK" ] && exit 0
trap 'rm -f "$LOCK"' EXIT
touch "$LOCK"

TASK="$(find "$QUEUE" -type f -name '*.md' | sort | head -n 1)"
[ -n "${TASK:-}" ] || exit 0

BASENAME="$(basename "$TASK" .md)"
DONE_TASK="$DONE/$(basename "$TASK")"
OUT="$RUN/$BASENAME.json"

TASK_BODY="$(cat "$TASK")"
PROMPT="$(cat <<EOF
You are the HEARTBEAT agent.
Work only inside $WORKSPACE.
Do the task.
Do not ask follow-up questions.
If blocked, write a short BLOCKED note.
Prefer concise output.

Task:
$TASK_BODY
EOF
)"

opencode -p "$PROMPT" --format json > "$OUT"
mv "$TASK" "$DONE_TASK"
printf '\n\n---\nLOG (%s)\n%s\n' "$(date -Is)" "$(cat "$OUT")" >> "$DONE_TASK"
rm -f "$OUT"

date -Is > "$RUN/last-heartbeat.txt"

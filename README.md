# Heartbeat

`heart.sh` is a tiny queue runner for `opencode` tasks. It looks for the first Markdown task in `queue/`, runs it inside `workspace/`, then moves the task into `done/` and appends the JSON run log to the end of that file.

Run it manually from this directory:

```bash
bash heart.sh
```

Run it every hour with cron:

```cron
0 * * * * /bin/bash /path/to/heartbeat/heart.sh
```

Install that with `crontab -e`.

Prompt to add to another agent's `AGENTS.md`:

```md
To queue a task, create a new Markdown file in `queue/` describing the work to run in `workspace/`. To check status, look for the task file in `queue/` if it is pending or in `done/` if it has finished; completed tasks also include the appended JSON run log.
```

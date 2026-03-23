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

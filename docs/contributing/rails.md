# Contributing with Rails

When adding or changing durable project knowledge, use `.rails/` artifacts instead of agent-specific directories.

## Rules

1. Every owned artifact must be indexed in `.rails/index.toml`.
2. Owned artifact paths must live under `.rails/`.
3. No Rails-owned artifact path may live under `.codex/`, `.spec/`, `.claude/`, or `.jules/`.
4. Prefer focused lane trackers under `.rails/lanes/` instead of a giant global task queue.

## Workflow

1. Add or update proposal/spec/ADR artifacts under `.rails/`.
2. Link relationships in `.rails/index.toml`.
3. Track execution with a focused lane tracker under `.rails/lanes/`.
4. Record outcomes in `.rails/closeouts/`.

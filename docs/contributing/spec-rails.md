# Contributing: Spec Rails

## Durable namespace

Create and maintain durable spec artifacts under `.atlasctl-swarm-spec/`.

## External agent state

This repo may include `.codex/`, `.claude/`, `.jules/`, and `.spec/`.
These directories are not durable ownership surfaces for this spec system.

## Artifact linkage

Every durable artifact should be linked through `.atlasctl-swarm-spec/index.toml`.

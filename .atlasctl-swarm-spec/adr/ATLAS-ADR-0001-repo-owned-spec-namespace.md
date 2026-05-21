# ATLAS-ADR-0001: Repo-owned spec namespace

Status: accepted
Date: 2026-05-21
Owner: repo-architecture
Linked proposal: ATLAS-PROP-0001
Linked specs: ATLAS-SPEC-0001

## Decision

Long-term proposal/spec/ADR/lane/closeout rails live in `.atlasctl-swarm-spec/`.

## Context

Tool-specific state directories are not durable ownership surfaces for repository governance artifacts.

## Consequences

The repository gains stable, tool-neutral memory and cleaner separation of concerns.

## Alternatives considered

Owning durable artifacts in `.codex` or `.spec` was rejected.

## Follow-up specs / plans

Add validators for index and lane tracker integrity.

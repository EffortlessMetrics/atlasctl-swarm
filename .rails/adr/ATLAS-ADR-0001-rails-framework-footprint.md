# ATLAS-ADR-0001: Rails Framework Footprint

Status: accepted
Date: 2026-05-21
Owner: core
Linked proposal: ATLAS-PROP-0001
Linked specs: ATLAS-SPEC-0001

## Decision

Long-term proposal/spec/ADR/lane/closeout rails live under `.rails/`.
Agent/tool-specific state remains external and awareness-only.

## Context

The project needs one portable and brandable framework footprint shared across repositories.

## Consequences

Durable knowledge is centralized under `.rails/` and indexed through `.rails/index.toml`.
No owned artifact path may live under `.codex/`, `.spec/`, `.claude/`, or `.jules/`.

## Alternatives considered

Repo-specific naming conventions were rejected because they reduce portability and consistency.

## Follow-up specs / plans

Implement and enforce the artifact graph contract in ATLAS-SPEC-0001 and the rails-adoption lane.

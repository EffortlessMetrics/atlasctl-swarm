# ATLAS-SPEC-0001: Repo-native spec rails contract

Status: accepted
Owner: repo-architecture
Created: 2026-05-21
Linked proposal: ATLAS-PROP-0001
Linked ADRs: ATLAS-ADR-0001
Linked lane: spec-system
Linked issues: n/a
Linked PRs: pending
Support-tier impact: informational
Policy impact: references only

## Problem

The repo needs durable, tool-neutral ownership of specification artifacts.

## Behavior

- Durable rails are owned under `.atlasctl-swarm-spec/`.
- `docs/` explains contributor-facing workflow.
- `policy/*.toml` may be referenced, not duplicated.
- `.codex`, `.spec`, `.claude`, `.jules` are awareness-only and must not host owned durable artifacts.

## Non-goals

Managing agent scratch state or migrating external tool state.

## Required evidence

- File layout present under `.atlasctl-swarm-spec/`.
- Linked artifact index exists.

## Acceptance examples

- Proposal/spec/ADR/lane artifacts are addressable from `index.toml`.
- External namespaces are listed only as external.

## Test mapping

- `git diff --check`

## Implementation mapping

- `.atlasctl-swarm-spec/`
- `docs/spec-style.md`
- `docs/contributing/spec-rails.md`

## CI proof

- `git diff --check`

## Metrics / promotion rule

Adopted once contributors can create and link artifacts via templates.

## Failure modes

Artifact paths under `.codex`, `.spec`, `.claude`, or `.jules` must be treated as invalid ownership.

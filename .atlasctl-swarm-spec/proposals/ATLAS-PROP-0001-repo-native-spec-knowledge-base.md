# ATLAS-PROP-0001: Repo-native spec knowledge base

Status: accepted
Owner: repo-architecture
Created: 2026-05-21
Target milestone: M1
Linked specs: ATLAS-SPEC-0001
Linked ADRs: ATLAS-ADR-0001
Linked lanes: spec-system

## Problem

Durable product and architecture intent can drift into tool-specific state, making it hard to maintain long-term, repo-owned memory.

## Users and surfaces

Contributors, maintainers, reviewers, and automation that need stable proposal/spec/ADR/lane context.

## Success criteria

The full source-of-truth stack is retained and stored in a repo-owned namespace.

## Proposed shape

Adopt `.atlasctl-swarm-spec/` as the durable spec control plane.

## Alternatives considered

Using `.codex/` or `.spec/` as ownership namespaces was rejected because they are tool/session specific.

## Specs to create or update

- ATLAS-SPEC-0001

## Architecture decisions needed

- ATLAS-ADR-0001

## Implementation campaign shape

Install namespace doctrine, templates, seed artifacts, then validators.

## Evidence plan

- `git diff --check`

## Risks

Over-centralization in one document without artifact boundaries.

## Non-goals

Migrating or modifying `.spec` and agent state directories.

## Exit criteria

Namespace, linkage, and contributor guidance are merged.

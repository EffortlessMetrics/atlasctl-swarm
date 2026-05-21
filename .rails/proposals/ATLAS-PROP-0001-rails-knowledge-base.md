# ATLAS-PROP-0001: Rails Knowledge Base Footprint

Status: accepted
Owner: core
Created: 2026-05-21
Target milestone: foundation
Linked specs: ATLAS-SPEC-0001
Linked ADRs: ATLAS-ADR-0001
Linked lanes: rails-adoption

## Problem

The repository lacks a durable, tool-agnostic source-of-truth structure for proposals, specs, decisions, sequencing, and closeout evidence.

## Users and surfaces

Maintainers and contributors need stable artifact locations independent of agent-specific state directories.

## Success criteria

A portable `.rails/` framework footprint exists, with index-linked artifacts and lane tracking under `.rails/`.

## Proposed shape

Adopt `.rails/` as the durable knowledge base and keep `.codex/`, `.spec/`, `.claude/`, and `.jules/` awareness-only external namespaces.

## Alternatives considered

Using repo-specific hidden directories was rejected due to inconsistent product footprint and lower portability.

## Specs to create or update

- ATLAS-SPEC-0001

## Architecture decisions needed

- ATLAS-ADR-0001

## Implementation campaign shape

Establish framework files and templates, then validate lane-based adoption artifacts.

## Evidence plan

- `git diff --check`

## Risks

Artifacts could drift if not consistently linked in `.rails/index.toml`.

## Non-goals

Migrating or modifying external agent/tool state directories.

## Exit criteria

Core Rails artifacts and templates exist, are indexed, and contributor docs describe ownership boundaries.

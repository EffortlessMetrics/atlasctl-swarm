# Spec system implementation plan

Status: active
Owner: repo-architecture
Linked proposal: ATLAS-PROP-0001
Linked specs: ATLAS-SPEC-0001
Linked ADRs: ATLAS-ADR-0001

## End state

The repository has a durable, repo-owned specification rail system under `.atlasctl-swarm-spec/` and human-facing guidance in `docs/`.

## Work items

### Work item: namespace-doctrine

Status: done
Linked proposal: ATLAS-PROP-0001
Linked spec: ATLAS-SPEC-0001
Linked ADR: ATLAS-ADR-0001
Blocks: none
Blocked by: none
Issue: n/a
PR: pending

#### Goal

Create namespace doctrine and first linked artifacts.

#### Production delta

Adds namespace structure, durable index, proposal/spec/ADR seed, and contributor docs.

#### Non-goals

No changes to `.codex`, `.spec`, `.claude`, `.jules`.

#### Acceptance

Doctrine and links are present and internally consistent.

#### Proof commands

```bash
git diff --check
```

#### Rollback

Revert added files.

#### Claim boundary

Does not yet implement automated validators.

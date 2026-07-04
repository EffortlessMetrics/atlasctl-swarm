# Rails Framework

`.rails/` is the durable Rails knowledge base for this repository.

`docs/` explains Rails to humans and contributors.

For the full conceptual overview of the stack, see [docs/rails-overview.md](rails-overview.md).

## External namespaces (awareness-only)

Rails does not own or mutate external tool/session state:

- `.codex/` is Codex execution state and is not owned by Rails.
- `.spec/` is Spec Kit / speckit state and is not owned by Rails.
- `.claude/` and `.jules/` are external agent/session spaces and are not owned by Rails.

## Artifact model

Rails separates durable knowledge into focused artifacts:

- Proposals (`.rails/proposals/`): why work exists.
- Specs (`.rails/specs/`): what behavior must be true.
- ADRs (`.rails/adr/`): durable architecture decisions.
- Lanes (`.rails/lanes/`): focused implementation sequencing.
- Support (`.rails/support/`): product claim-to-proof mapping.
- Policy (`.rails/policy/`): references to live enforcement ledgers.
- Closeouts (`.rails/closeouts/`): what landed, proof, and follow-ups.

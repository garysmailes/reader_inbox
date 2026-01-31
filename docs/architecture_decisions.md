# Architecture Decisions & Guardrails

**Status:** Canonical  
**Applies to:** Backend, frontend, automation, and integrations  
**Audience:** Developers and AI assistants

This document records the **architectural intent** behind Reading Inbox.

Its purpose is not to describe the codebase exhaustively, but to:
- explain *why* certain approaches are chosen
- prevent accidental complexity
- keep the system boring, legible, and trustworthy

---

## Core architectural philosophy

Reading Inbox is a **small, personal system**.

Architecture choices must prioritise:
- clarity over abstraction
- predictability over cleverness
- durability over optimisation

The system should be easy to reason about six months from now.

---

## Rails Way (non-negotiable)

The application follows standard Rails conventions.

- Standard MVC
- Conventional file structure
- Rails defaults preferred unless clearly insufficient

Avoid:
- parallel frameworks
- custom architectural patterns
- reinventing Rails features

If Rails provides a reasonable default, use it.

---

## Controllers

Controllers should be:

- thin
- readable
- intent-focused

Responsibilities:
- orchestrate requests
- enforce access boundaries
- delegate logic elsewhere when justified

Avoid:
- business logic in controllers
- complex branching
- hidden side effects

---

## Models

Models are the primary home for:

- validations
- state rules
- single-record logic

Prefer:
- explicit validations
- database-backed integrity
- readable methods over callbacks

Avoid:
- “magic” behaviour
- implicit state mutation
- analytics-like logic

---

## Service objects

Service objects are **allowed but constrained**.

Use a service object only when:
- logic spans multiple models, or
- the workflow is multi-step and cannot live cleanly in one model

Service objects should:
- have one clear responsibility
- be explicitly named
- be easy to delete later

Avoid:
- premature extraction
- service layers for single-model logic

---

## Concerns

Concerns are allowed **only for shared behaviour**.

Use concerns when:
- behaviour is shared across multiple models or controllers

Do not use concerns for:
- single-use logic
- organisational convenience
- speculative reuse

---

## Hotwire discipline

Hotwire is preferred for interactivity.

- Turbo Frames first
- Turbo Streams where appropriate
- Stimulus only when Turbo cannot express the interaction

Avoid:
- custom JavaScript for simple UI state
- front-end frameworks
- client-side state machines

The UI should degrade gracefully without JavaScript.

---

## Background jobs

Background jobs are allowed **only for non-critical work**.

Appropriate uses:
- metadata fetching
- future optional automation

Inappropriate uses:
- core capture flow
- state transitions
- anything required for immediate user feedback

If a job fails:
- the system must remain usable
- user intent must not be blocked

---

## Authentication & authorization

Authentication uses:
- Rails 8 built-in authentication mechanisms

Authorization should remain:
- simple
- explicit
- server-enforced

Avoid:
- policy gems
- role matrices
- permission DSLs

MVP assumes a single `user` role.

---

## Data integrity

Prefer:
- database constraints
- uniqueness indexes
- explicit foreign keys

Do not rely solely on:
- application-level checks
- UI enforcement

The database is the final authority on integrity.

---

## AI & automation boundary

Automation and AI systems:

- are optional
- are externalised (e.g. via n8n)
- must never own core logic

AI may:
- read data
- suggest organisation
- generate summaries

AI may never:
- mutate state
- infer intent
- override user actions

---

## Avoided complexity (intentional)

The system intentionally avoids:

- event sourcing
- CQRS
- audit logs
- analytics pipelines
- optimisation engines

These are not “missing features”.  
They are **explicitly rejected**.

---

## Canonical rule

If a proposed change introduces:
- a new architectural pattern
- a new abstraction layer
- a new dependency with behavioural impact

this document must be updated first.

The architecture exists to serve the product.  
The product exists to serve the user.


# Reading Inbox — Documentation

This folder contains the **canonical documentation** for *Reading Inbox*.

Reading Inbox is a personal, mobile-first “read-it-later” system designed to:
- capture long-form articles quickly via URL
- return to them later in a calm, low-distraction inbox
- track simple reading progression via explicit states
- maintain a permanent personal archive

The documentation here defines:
- what the product is and is not
- the meaning of core domain concepts
- strict boundaries between MVP and roadmap
- architectural and behavioural guardrails

All product decisions and implementations must be traceable back to these documents.

---

## How to use these docs

If you are:
- **building features** → start with **[Product Outline](./docs/product_outline.md)**
- **making UX decisions** → read **[UI Principles](./docs/ui_principles.md)**
- **working with states or automation** → read **[State Model](./docs/state_model.md)**
- **handling URLs or metadata** → read **[URL Handling](./docs/url_handling.md)** and **[Metadata Fetching](./docs/metadata_fetching.md)**
- **adding future ideas** → check **[Roadmap](./docs/roadmap.md)** first

If something is unclear or missing:
- do not guess
- update the docs first
- then implement

The docs define truth.  
The code implements it.

---

## Canonical documents

### Product definition

- **[Product Outline](./docs/product_outline.md)**  
  The single source of truth for product scope, behaviour, and boundaries.  
  All features and implementations must be traceable to this document.

- **[Domain Language](./docs/domain_language.md)**  
  Defines canonical nouns and terms (e.g. “Saved Item”, “Inbox”, “Viewed”).  
  Prevents naming drift across code, UI, and documentation.

- **[State Model](./docs/state_model.md)**  
  Defines the explicit reading lifecycle and allowed state transitions.  
  Clarifies what is automatic vs manual and what is never inferred.

---

### Behavioural guardrails

- **[URL Handling](./docs/url_handling.md)**  
  Rules for URL ingestion, deduplication, and canonicalisation boundaries.

- **[Metadata Fetching](./docs/metadata_fetching.md)**  
  Defines best-effort metadata behaviour and failure handling.  
  Protects capture speed and user intent.

- **[UI Principles](./docs/ui_principles.md)**  
  Mobile-first UX principles and interaction priorities.  
  Guards against clutter, gamification, and distraction.

- **[Architecture Decisions](./docs/architecture_decisions.md)**  
  Records architectural intent and constraints (Rails-way, Hotwire discipline, background jobs).

---

### Future-facing (non-binding)

- **[Roadmap](./docs/roadmap.md)**  
  Explicitly out-of-scope ideas parked for later consideration.  
  Items here must not leak into MVP behaviour.

---

## Canonical rules

- The **[Product Outline](./docs/product_outline.md)** is authoritative.
- MVP behaviour must never be inferred from roadmap sections.
- AI and automation are always subordinate to explicit user intent.
- If behaviour changes, the docs must be updated before or alongside code.

---

## Status

This documentation set is a **living system**.

It is expected to evolve as:
- new features are added
- constraints are clarified
- roadmap items are promoted into MVP

Changes should be deliberate, explicit, and traceable.

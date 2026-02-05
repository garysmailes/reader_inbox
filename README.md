# Reading Inbox

## 1. What this app is

**Reading Inbox** is a personal, mobile-first *read-it-later* application.

Its purpose is deliberately narrow:

- Capture long-form content quickly via a single URL
- Provide a calm, low-distraction inbox for returning to that content
- Allow the reader to explicitly control reading progress via simple states
- Preserve a permanent personal archive, without optimisation or gamification

Reading Inbox is **not** a recommendation engine, a productivity tracker, or a social product. All behaviour is driven by explicit user intent rather than inferred engagement.

The documentation in [`/docs`](docs/) defines the product. The code exists to implement those decisions.

---

## 2. Product outline, features, and roadmap

The product is defined by a small set of canonical documents. These act as the **single source of truth** for scope, behaviour, and constraints.

### AI implementation prompt

- **AI Prompt (canonical)**  \
  [`AI Prompt`](docs/outline/ai_prompt.md)  \
  The authoritative prompt used to guide ChatGPT when acting as a Rails technical lead for this project. This file encodes execution constraints, product doctrine, architectural guardrails, and documentation discipline.

### Core product definition

- **Product Outline**  
  [`/docs/outline/00_product_outline.md`](docs/outline/00_product_outline.md)  
  Defines what the app does and does not do, MVP boundaries, and user-visible behaviour.

- **Feature list**  
  [`/docs/outline/01_feature_list.md`](docs/outline/01_feature_list.md)  
  The current feature set, expressed as documentation-first product scope.

- **Roadmap (non-binding)**  
  [`/docs/outline/02_roadmap.md`](docs/outline/02_roadmap.md)  
  Explicitly out-of-scope ideas parked for later consideration. Nothing in this document should affect MVP behaviour.

### Supporting canon docs

- **Domain Language**  
  [`/docs/domain_language.md`](docs/domain_language.md)  
  Canonical nouns and terminology used across code, UI, and documentation.

- **State Model**  
  [`/docs/state_model.md`](docs/state_model.md)  
  Explicit reading states and allowed transitions. Clarifies what is manual and what is never inferred.

- **UI Principles**  
  [`/docs/ui_principles.md`](docs/ui_principles.md)  
  Mobile-first interaction rules and UX guardrails.

- **URL Handling**  
  [`/docs/url_handling.md`](docs/url_handling.md)  
  Rules for capture, deduplication, and canonicalisation.

- **Metadata Fetching**  
  [`/docs/metadata_fetching.md`](docs/metadata_fetching.md)  
  Best-effort metadata behaviour and failure handling.

---

## 3. Architecture overview

Reading Inbox is intentionally simple and conservative in its architecture.

### Core principles

- Rails-conventional monolith
- Server-rendered HTML with Hotwire for interactivity
- Minimal background processing
- No behavioural inference or analytics-driven automation

### Key architectural decisions

- **Ruby on Rails** as the application framework
- **Hotwire (Turbo + Stimulus)** for progressive enhancement
- **PostgreSQL** as the primary data store
- **Background jobs** used only where they protect capture speed (e.g. metadata fetching)

Architectural intent, trade-offs, and constraints are recorded in:

- **Architecture Decisions**  
  [`/docs/architecture_decisions.md`](docs/architecture_decisions.md)

This document should be updated whenever a significant architectural choice is made.

---

## 4. How to work with this repo

- Treat the documentation as authoritative
- Do not invent behaviour that is not supported by the docs
- Update documentation *before or alongside* any behavioural change
- MVP behaviour must never be inferred from roadmap items

If something is unclear:

1. Check the relevant document in [`/docs`](docs/)
2. If still unclear, update or extend the documentation
3. Only then implement

---

## 5. Status

Reading Inbox is a living system.

The documentation is expected to evolve as constraints are clarified and features are deliberately added. All changes should be explicit, traceable, and aligned with the core goal: **a calm, intentional reading inbox**.

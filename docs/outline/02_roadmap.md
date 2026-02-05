# Roadmap — Reading Inbox

**Status:** Non-binding  
**Applies to:** Post-MVP planning only  
**Audience:** Product planning, operators, and future development

This document lists **potential future directions** for Reading Inbox.

Items in this file:
- are not commitments
- must not influence MVP behaviour
- must not be partially implemented

If a roadmap item is promoted into MVP:
- the Product Outline must be updated first
- relevant guardrail docs must be updated
- only then may implementation begin

---

## Guiding principle

The roadmap exists to:
- capture ideas without pressure
- prevent scope creep
- preserve the calm, intentional nature of the product

Nothing here is urgent.

---

## Reader mode

A future reader mode may:

- extract article text on demand
- present it in a distraction-free, read-only view

Hard constraints:

- extracted content is not persisted
- no offline storage
- no redistribution
- no indexing
- user-initiated only

Reader mode is a **temporary convenience**, not content ownership.

---

## Notes & highlights

The system may later support:

- personal notes
- highlights

Constraints:

- strictly personal
- no sharing by default
- no analytics or metrics derived from notes

This must not evolve into a research or annotation platform.

---

## Tags & categories

Future organisational tools may include:

- manual tags
- categories
- filtering and sorting by tag/category

Constraints:

- tagging is optional
- no auto-tagging in MVP
- no ranking or prioritisation

---

## Automation & AI

Optional automation may be introduced via external systems (e.g. n8n).

AI may:

- suggest tags
- generate summaries
- assist with organisation

AI may never:

- change Saved Item state
- mark items as read or archived
- decide importance or priority
- override user intent

AI is always subordinate.

---

## Chrome extension

A future Chrome extension may:

- authenticate against the same user account
- save URLs via a fire-and-forget action
- mirror core ingestion behaviour

Constraints:

- no confirmation flow
- no editing at capture time
- capture speed remains primary

---

## Sharing & social features

Potential future features may include:

- friends
- shared URLs
- shared lists

Constraints:

- all sharing is explicit
- opt-in only
- additive, never default
- privacy-first

MVP includes **no sharing of any kind**.

---

## Data portability

Future export options may include:

- CSV export
- JSON export

Constraints:

- export must be user-initiated
- no background syncing
- no external publishing

The schema should support this without major rewrites.

---

## Explicit exclusions (permanent)

The system will never:

- track reading time
- gamify reading
- issue reminders or nudges
- rank or score content
- optimise engagement
- become a public content platform
- act as a bookmark sync service

These are not roadmap items.  
They are **permanently out of scope**.

---

## Promotion rule

To move an item from this roadmap into active development:

1. Update `/docs/product_outline.md`
2. Update any affected guardrail docs
3. Confirm scope and constraints
4. Only then begin implementation

Ideas are cheap.  
Clarity is expensive.


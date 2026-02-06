This roadmap defines **what comes next**, in **priority order**, for Reading Inbox.

Features are listed from **foundational and non-negotiable** through to **optional future expansion**.
Each item captures the *intent* and *constraints* required for later detailed specification.

---

## Phase 1 — MVP Completion (Foundational)

These features complete the MVP as already promised by the Product Outline.
They are required for the product to be considered *done*, not “nice to have”.

---

### 1. Explicit Delete (Hard Delete)

Provide a clear, user-initiated way to permanently delete a Saved Item.

Deletion must:

* remove the item entirely (no trash, no recovery)
* be clearly distinct from Archiving
* require explicit user intent (no automation)

This enforces the product’s retention philosophy and keeps the archive meaningful.

---

### 2. Duplicate URL Feedback

Improve user feedback when a URL is already saved.

The system must:

* prevent duplicate saves per user
* clearly indicate that the URL already exists
* distinguish duplicate feedback from generic errors

This is a UX obligation implied by deduplication rules, not an optional enhancement.

---

### 3. Defined Metadata Failure State

Make metadata failure explicit and legible in the UI.

When metadata fetching fails:

* the item must still be saved
* the clean URL must be displayed consistently
* the UI should indicate that metadata was unavailable

This avoids silent failure and preserves trust in capture reliability.

---

### 4. Last Viewed Semantics (Clarification & Consistency)

Formally define and enforce how `last_viewed_at` behaves.

Clarify:

* whether repeated opens update `last_viewed_at`
* that it is informational only, not behavioural tracking
* that it never drives state changes or automation

This prevents accidental drift into analytics-based logic.

---

### 5. Export-Ready Data Model

Ensure the data model is stable and portable, even before exports exist.

The system must:

* represent all Saved Item data explicitly in the database
* avoid UI-only or derived-only state
* maintain predictable field naming and types

This guarantees future CSV/JSON export without schema rewrites.

---

## Phase 2 — MVP+ (Low-Risk Extensions)

These features extend usefulness without changing the product’s core character.

---

### 6. Basic Admin Role (Non-UI)

Introduce a conceptual admin role without exposing admin UI.

Admins may later:

* enable or disable AI features
* manage integrations

For now, this is structural groundwork only, preventing future permission leaks.

---

### 7. Metadata Re-fetch Capability (Manual / Internal)

Allow metadata to be re-fetched on demand or internally.

Constraints:

* user-initiated or admin-initiated only
* never blocks normal usage
* does not override user-visible fields without intent

This supports future AI and reader-mode features safely.

---

### 8. Accessibility & Interaction Clarity

Improve accessibility without adding visual noise.

Focus areas:

* keyboard navigation
* focus management after URL submission
* clear tap targets and ARIA semantics

This aligns directly with the “calm, focused, low-distraction” philosophy.

---

## Phase 3 — Organisation & Navigation

These features improve navigation once inbox size grows, without introducing productivity theatre.

---

### 9. Tags

Allow users to assign simple, free-form tags to Saved Items.

Rules:

* tags are user-defined
* no automatic tagging
* no ranking or scoring

Tags are organisational aids, not intelligence signals.

---

### 10. Categories

Introduce optional categories as a higher-level grouping mechanism.

Categories:

* are explicitly set by the user
* coexist with tags
* do not affect ordering or state

This supports lightweight mental organisation without hierarchy creep.

---

### 11. Filtering & Alternate Ordering

Add optional ways to view the inbox.

Examples:

* filter by tag or category
* alternate sort orders (e.g. oldest first)

The default view must remain unchanged and canonical.

---

## Phase 4 — Reader Experience (Optional Convenience)

These features enhance reading *without claiming ownership of content*.

---

### 12. Reader Mode

Provide a temporary, distraction-free reading view.

Constraints:

* content is extracted on demand
* extracted text is never persisted
* no offline access
* no redistribution or indexing

Reader mode is a convenience layer, not a content system.

---

### 13. Notes & Highlights

Allow users to add personal notes and highlights.

Rules:

* entirely manual
* stored separately from article content
* no analytics, sharing, or ranking

This must not evolve into a research or annotation platform.

---

## Phase 5 — Automation & Intelligence (Explicitly Optional)

Automation augments organisation but never judgement.

---

### 14. AI Tag Suggestions

Optionally suggest tags using AI.

Constraints:

* explicitly enabled
* suggestions only (never automatic application)
* externalised via n8n

AI must not create hidden structure or priority.

---

### 15. AI Summaries

Optionally generate summaries for Saved Items.

Rules:

* user-initiated
* non-authoritative
* never influence state or ordering

Summaries exist to refresh memory, not replace reading.

---

## Phase 6 — Capture Expansion

These features expand capture surfaces without changing behaviour.

---

### 16. Chrome Extension

Provide a browser extension for fast URL capture.

Requirements:

* uses the same account and ingestion pipeline
* fire-and-forget capture
* no mandatory editing or confirmation step

All ingestion methods must behave identically.

---

## Phase 7 — Sharing & Social (Deferred)

These features are deliberately postponed.

---

### 17. Shared Lists / Friends

Allow explicit sharing of Saved Items or lists.

Rules:

* opt-in only
* private by default
* additive, never required

This must not introduce discovery, feeds, or engagement mechanics.

---

## Phase 8 — Data Portability

These features complete user ownership.

---

### 18. CSV Export

Allow users to export their data as CSV.

The export must:

* include all Saved Item fields
* be user-initiated
* require no special permissions

---

### 19. JSON Export

Provide a structured JSON export for advanced users.

This is a transparency and ownership feature, not an integration API.

---

## Closing Notes

This roadmap intentionally:

* prioritises **trust and clarity over power**
* finishes the MVP properly before expanding
* treats automation as optional and subordinate
* resists feature creep disguised as “helpfulness”

All future outlines and tasks should reference this roadmap directly.

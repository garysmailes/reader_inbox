# URL Handling & Deduplication

**Status:** Canonical  
**Applies to:** URL ingestion across all interfaces  
**Audience:** Developers, designers, automation, and AI assistants

This document defines the rules and guarantees for handling URLs in Reading Inbox.

URL ingestion is the **primary action** of the system.  
It must be fast, predictable, and trustworthy.

---

## Core principle

Saving a URL is a **single, intentional act** by the user.

The system’s responsibility is to:
- accept the URL quickly
- avoid accidental duplication
- preserve user intent

It must not:
- block capture
- over-normalise URLs
- promise perfect canonicalisation

---

## URL saving rules

### Uniqueness

- A URL may be saved **only once per user**.
- Uniqueness is scoped **per user**, not globally.

Two different users may save the same URL independently.

---

### Duplicate handling

If a user attempts to save a URL that already exists:

- no new Saved Item is created
- the existing Saved Item is returned
- the UI clearly indicates **“already saved”**

This feedback must be:
- explicit
- non-alarming
- non-blocking

The system should not silently fail or ignore the action.

---

## Canonicalisation policy

URL canonicalisation is **best-effort only**.

The system may attempt light normalisation such as:
- trimming whitespace
- removing trailing slashes
- normalising scheme where safe

The system must **not** attempt:
- aggressive query-string stripping
- content-based canonical resolution
- external canonical lookups
- guarantees of dedupe across all URL variants

**Why:**  
Perfect canonicalisation is brittle and risks false negatives or false positives.

---

## Failure tolerance

If URL parsing or normalisation fails:

- the raw URL is still saved
- the Saved Item remains valid
- metadata fetching may fail independently

Capture must always succeed unless the URL is structurally invalid.

---

## UX expectations

- Saving a URL is a **single-step action**
- No confirmation flow is required
- No forced editing or metadata correction
- Errors must be clear and human-readable

The system should feel forgiving, not strict.

---

## Interface parity

These rules apply equally to all ingestion surfaces:

- web UI
- future Chrome extension
- future API endpoints
- automation (e.g. n8n)

No interface may introduce stricter or looser rules.

---

## Explicit non-goals

The URL system will never:

- promise perfect deduplication
- track referral parameters
- rewrite URLs for tracking purposes
- validate content accessibility
- infer article identity across domains

---

## Canonical rule

If a future feature proposes:
- stronger canonicalisation
- global deduplication
- content identity resolution

it must:
1. update this document first
2. preserve the capture-first guarantee
3. remain optional and user-controlled

URL handling exists to support **intent**, not correctness.


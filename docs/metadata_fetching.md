# Metadata Fetching & Failure Behaviour

**Status:** Canonical  
**Applies to:** Title and domain fetching  
**Audience:** Developers, designers, automation, and AI assistants

This document defines how Reading Inbox handles metadata associated with Saved Items.

Metadata exists to **improve legibility**, not correctness or authority.

---

## Core principle

Metadata fetching must:

- be best-effort
- be non-blocking
- never prevent saving a URL

A Saved Item is valid **with or without metadata**.

---

## Metadata scope (MVP)

The system may attempt to fetch:

- page title
- domain name

No other metadata is required in MVP.

Metadata is:
- informational
- non-authoritative
- replaceable

---

## Fetch timing

Metadata fetching may occur:

- synchronously if fast and safe
- asynchronously via background job

Regardless of timing:
- the URL must be saved immediately
- user flow must not be blocked

---

## Failure handling

If metadata fetching fails:

- the Saved Item is still created
- the URL remains the primary identifier
- the UI displays a clean version of the URL (persisted on the Saved Item as a fallback display value)
- the UI indicates that metadata was not available

Failure must be:
- visible
- non-fatal
- non-alarming

Silent failure is not allowed.

---

## Partial success

If only some metadata is available:

- use what is available
- do not retry synchronously
- do not block display

Example:
- domain fetched, title missing → acceptable

---

## Re-fetching policy (MVP)

In MVP:

- automatic re-fetching is not required
- manual re-fetching is not required

Future re-fetching may exist but must:
- remain optional
- never alter state
- never block user actions

---

## Separation from state

Metadata must never:

- influence reading state
- trigger state transitions
- imply engagement or completion

Metadata and state are **orthogonal concerns**.

---

## AI interaction boundary

AI systems may:

- consume metadata
- summarise content using fetched data

AI systems may **never**:

- correct metadata automatically
- use metadata to infer reading behaviour
- mutate Saved Item state

---

## UX expectations

Metadata exists to:
- make the inbox scannable
- reduce visual noise
- improve recognition

If metadata is missing:
- the experience remains fully functional
- the system remains trustworthy

---

## Canonical rule

If a feature proposes:

- richer metadata
- preview content
- metadata-driven sorting
- metadata-based inference

this document must be updated first.

Metadata supports reading.  
It does not define it.


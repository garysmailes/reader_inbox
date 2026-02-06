# Product Outline — Reading Inbox

**Status:** Canonical  
**Applies to:** MVP and all future development  
**Audience:** Developers, designers, operators, and AI assistants

This document defines the **authoritative product truth** for Reading Inbox.  
All features, implementations, and documentation must be traceable back to this outline.

---

## 1. Purpose & Boundary

### Purpose

The system exists to operate a personal, mobile-first reading inbox that allows a user to:

- capture long-form articles quickly via URL  
- return to them later in a calm, focused environment  
- track basic reading progression  
- maintain a permanent personal archive of things worth reading  

The system optimises for **capture speed, clarity, and low distraction**.

It is **not** a productivity dashboard, recommendation engine, or content platform.

---

### Boundary (explicit)

The system never:

- evaluates article quality  
- decides what the user should read  
- marks items as “read” automatically  
- tracks engagement time, scroll depth, or attention  
- hosts or republishes third-party content  
- optimises for social sharing, virality, or growth loops  

**Why this matters:**  
This prevents the product from drifting into surveillance, optimisation theatre, or content ownership.

---

## 2. Identity & Roles

### User model

- One `User` model  
- Authentication via Rails 8 built-in authentication  
- Accounts are required from day one  
- Simple onboarding is expected  

This is a personal tool first, but data separation must be correct to support invited users later.

---

### Roles (MVP vs roadmap)

#### MVP

- Single role: `user`  
- No admin behaviour exposed  

#### Roadmap

- Admin role  
- Admin may:
  - enable or disable AI features  
  - manage integrations  

Admins are operators, not participants.

**Why this matters:**  
Role separation exists conceptually early, without contaminating the MVP with premature governance logic.

---

## 3. Core Object: Saved Item

The core unit of the system is a **Saved Item**.

Each Saved Item represents **one unique article URL saved by a user**.

---

### Stored data (MVP)

- URL (required)  
- Fetched title (best-effort)  
- Domain  
- State  
- Created at  
- Last viewed at (if applicable)  
- Clean URL (persisted display fallback; derived from URL for use when metadata is unavailable)

Metadata fetching is opportunistic and **must never block saving**.



---

### URL rules

- A URL may be saved **only once per user**  
- If a user attempts to save a URL that already exists:
  - the system does not duplicate it  
  - the system clearly indicates “already saved”  

Deduplication is **best-effort**, not a promise of perfect canonicalisation.

**Why this matters:**  
It avoids duplicates without over-engineering URL normalisation.

---

## 4. State Model (Reading Lifecycle)

Each Saved Item exists in **one explicit state**.

---

### Core states

- **Unread**  
  Initial state. The item has not been opened.

- **Viewed**  
  Automatically set the first time the user opens the link.  
  Meaning: “Opened at least once”, not “engaged with”.

- **Read**  
  Explicitly set by the user.  
  Never automatic.

- **Archived**  
  Removed from the active inbox but retained permanently.

States are **persistent and reversible**.

---

### State philosophy

- “Viewed” is a real state, not derived analytics  
- No time-based or behavioural inference is allowed  
- User intent always overrides automation  

**Why this matters:**  
This preserves trust and avoids creeping surveillance logic.

---

## 5. Primary User Flow (Mobile-First)

The system is designed **iPhone-first**.

---

### Primary action

- The homepage prioritises adding a URL  
- This is the dominant interaction  

---

### Secondary actions

- Scanning the inbox  
- Tapping an item to open it  
- Manually updating its state  

Desktop usage is supported but secondary.

**Why this matters:**  
The product is shaped around capture and return, not management.

---

## 6. Ordering & Presentation

### Default ordering

- Most recently added first  

This is the **canonical inbox view**.

---

### Roadmap

- Ordering by tag  
- Filtering by category  
- Alternate sort modes  

**Why this matters:**  
The default view must remain predictable and low-cognitive-load.

---

## 7. Metadata Fetching & Failure Handling

Metadata fetching (title, domain) is:

- best-effort  
- non-blocking  
- non-authoritative  

If metadata fails:

- the URL is still saved  
- the UI displays the clean URL  
- a note indicates metadata was not available  

Future re-fetching may exist but is **not required in MVP**.

**Why this matters:**  
Capture must never fail silently or block user intent.

---

## 8. Reader Mode (Roadmap)

A future reader mode may:

- extract article text on demand  
- present it in a distraction-free, read-only view  

---

### Hard rules

- extracted content is not persisted  
- no offline storage  
- no redistribution  
- no indexing  
- user-initiated only  

Reader mode is a **temporary convenience**, not content ownership.

---

## 9. Notes & Highlights (Roadmap)

The system may later support:

- personal notes  
- highlights  

These are **explicitly out of scope for MVP**.

**Why this matters:**  
This prevents premature evolution into a research or annotation system.

---

## 10. Automation & AI (Roadmap)

AI features are:

- optional  
- explicitly enabled  
- externalised via n8n  

AI may:

- suggest tags  
- generate summaries  

AI may **never**:

- change item state  
- mark items as read or archived  
- decide importance or priority  

**Why this matters:**  
AI augments organisation, not judgement.

---

## 11. Chrome Extension (Roadmap)

A future Chrome extension may:

- authenticate against the same user account  
- save URLs via a fire-and-forget action  
- mirror core ingestion behaviour  

No confirmation or editing step is required at capture time.

The system treats URL ingestion as a **first-class action**, regardless of interface.

---

## 12. Sharing & Social Features (Explicitly Not MVP)

All Saved Items are **private by default**.

MVP includes:

- no sharing  
- no discoverability  
- no social surface  

Roadmap may include:

- friends  
- shared URLs  
- shared lists  

All sharing must be:

- explicit  
- opt-in  
- additive  

---

### Deletion & Retention

Saved Items persist in the system until the user explicitly deletes them.

**Delete** is a permanent, irreversible action that removes a Saved Item entirely from the user’s Reading Inbox and history. Once deleted, the item no longer exists in the system and cannot be recovered.

Deletion is not part of the reading lifecycle and is distinct from Archiving.

**Archive** preserves a Saved Item for long-term retention while removing it from the active Inbox. Archived items remain available until explicitly deleted by the user.

The system does not provide:
- a trash or recycle bin
- undo or restore functionality
- automated or time-based deletion


---

## 14. Data Portability (Roadmap)

The system should be designed to support:

- CSV export  
- JSON export  

Export is **not required in MVP** but must be feasible without schema rewrites.

---

## 15. Explicit Non-Goals

The system will never:

- track reading time  
- gamify reading  
- issue reminders or nudges  
- rank or score content  
- optimise engagement  
- become a public content platform  
- act as a bookmark sync service  

---

## Closing Commentary

This outline deliberately:

- locks down scope  
- protects user intent  
- avoids behavioural tracking  
- keeps automation optional and subordinate  
- prioritises calm over cleverness  

It is designed to let you:

- build a fast, trustworthy MVP  
- add automation without loss of control  
- extend into sharing or intelligence without rewriting fundamentals  
- resist feature creep disguised as “helpfulness”  

**This document should be treated as canonical.**

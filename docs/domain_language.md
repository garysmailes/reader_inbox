# Domain Language — Reading Inbox

**Status:** Canonical  
**Applies to:** Code, UI copy, documentation, and automation  
**Audience:** Developers, designers, and AI assistants

This document defines the **canonical domain language** for Reading Inbox.

All naming in:
- models
- controllers
- views
- UI copy
- documentation
- automation and AI tooling

must conform to the terms defined here.

If a concept is not named here, it should not be casually introduced elsewhere.

---

## Core domain nouns

### Saved Item

**Canonical term:** Saved Item  
**Meaning:**  
A single article URL saved by a user for later reading.

Each Saved Item:
- belongs to exactly one user
- represents one unique URL per user
- has one explicit reading state

**Must not be called:**
- bookmark
- read-later item
- article
- link
- entry

**Why:**  
“Saved Item” is intentionally neutral. It does not imply reading, completion, or quality.

---

### Inbox

**Canonical term:** Inbox  
**Meaning:**  
The active list of Saved Items that are not archived.

The Inbox is:
- the default view
- ordered by most recently added first
- intentionally simple and scannable

**Must not be called:**
- list
- feed
- queue
- library

**Why:**  
“Inbox” reinforces capture-and-return without implying optimisation or throughput.

---

### Archive

**Canonical term:** Archive  
**Meaning:**  
A persistent collection of Saved Items that have been removed from the Inbox.

Archived items:
- remain fully accessible
- retain their state history
- are never auto-deleted

**Must not be called:**
- trash
- bin
- history
- storage

**Why:**  
Archive implies retention, not disposal.

---

## Reading states

States are **explicit user-facing concepts**, not derived analytics.

---

### Unread

**Meaning:**  
The Saved Item has not been opened.

- This is the default state on creation.
- No inference is allowed.

---

### Viewed

**Meaning:**  
The Saved Item has been opened at least once.

- Set automatically on first open.
- Does **not** imply reading, engagement, or completion.

**Must not be described as:**
- read
- started
- in progress

---

### Read

**Meaning:**  
The user has explicitly marked the item as read.

- This state is **never automatic**.
- It always reflects user intent.

---

### Archived

**Meaning:**  
The Saved Item has been removed from the active Inbox but retained permanently.

- Archiving does not imply reading.
- Archived items may still be Unread, Viewed, or Read.

---

## Actions & verbs

### Save

**Meaning:**  
Create a new Saved Item from a URL.

- Saving must never block.
- Saving the same URL twice does not create duplicates.

---

### Open

**Meaning:**  
Navigate to the Saved Item’s URL.

- Opening an item may change state from Unread → Viewed.
- Opening never changes state to Read.

---

### Mark as Read

**Meaning:**  
Explicit user action indicating completion.

- This action is always manual.
- No automation may trigger it.

---

### Archive

**Meaning:**  
Move a Saved Item out of the Inbox.

- Archiving is reversible.
- Archiving does not delete.

---

### Delete

**Meaning:**  
Permanently remove a Saved Item.

- Deletion is a hard delete.
- There is no trash or recovery state.

---

## Forbidden language

The system must never use language that implies:

- surveillance (“tracking”, “monitoring”, “attention”)
- optimisation (“prioritised”, “ranked”, “recommended”)
- judgement (“important”, “valuable”, “high quality”)
- gamification (“progress”, “streak”, “completion rate”)

These concepts are explicitly out of scope.

---

## AI & automation language

AI-related features must use **suggestive**, not authoritative language.

Allowed:
- “suggested tags”
- “generated summary”

Forbidden:
- “AI marked this as read”
- “AI decided this was important”
- “AI archived this item”

AI may assist organisation, never judgement.

---

## Canonical rule

If a new feature introduces:
- a new noun
- a new state
- a new verb
- a new implied meaning

this document **must be updated first**.

The language defines the system.  
The implementation follows.


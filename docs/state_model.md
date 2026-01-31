# State Model — Reading Lifecycle

**Status:** Canonical  
**Applies to:** Saved Items  
**Audience:** Developers, designers, automation, and AI assistants

This document defines the **explicit reading lifecycle** for Saved Items.

State is a first-class domain concept.  
It is **not derived**, **not inferred**, and **not analytical**.

All state changes must conform to the rules defined here.

---

## Core principle

A Saved Item is always in **exactly one state**.

State reflects:
- explicit user intent, or
- a single, clearly defined automatic action

State must never reflect:
- engagement
- time spent
- behavioural inference
- heuristics or scoring

---

## State definitions

### Unread

**Meaning:**  
The Saved Item has not been opened.

**Entry conditions:**
- Default state when a Saved Item is created.

**Exit conditions:**
- Automatically transitions to **Viewed** on first open.

---

### Viewed

**Meaning:**  
The Saved Item has been opened at least once.

This state means **only**:
> “The user opened the link at least once.”

It does **not** imply:
- reading
- engagement
- completion

**Entry conditions:**
- Automatic transition when an Unread item is opened for the first time.

**Exit conditions:**
- Manual transition to **Read**
- Manual transition to **Archived**


---

## last_viewed_at

`last_viewed_at` is a best-effort timestamp recorded **only** when an Unread item is opened for the first time and transitions to **Viewed**.

Rules:
- Set `last_viewed_at` when the automatic transition **Unread → Viewed** occurs.
- Do not update `last_viewed_at` on subsequent opens automatically.
- Do not use `last_viewed_at` to infer engagement, reading completion, or to drive any automatic transition (especially never to Read).


---

### Read

**Meaning:**  
The user has explicitly indicated they have read the item.

**Entry conditions:**
- Manual user action only.

**Automatic entry:**  
- Never allowed.

**Exit conditions:**
- Manual transition back to **Unread** or **Viewed**
- Manual transition to **Archived**

---

### Archived

**Meaning:**  
The Saved Item has been removed from the active Inbox but retained permanently.

Archived is a **location state**, not a reading judgement.

**Entry conditions:**
- Manual user action only.

**Exit conditions:**
- Manual unarchive back to Inbox
- Manual deletion

---

## Allowed transitions

The following transitions are explicitly allowed:

| From       | To        | Trigger                |
|-----------|-----------|------------------------|
| Unread    | Viewed    | Automatic (first open) |
| Unread    | Archived  | Manual                 |
| Viewed    | Read      | Manual                 |
| Viewed    | Archived  | Manual                 |
| Read      | Archived  | Manual                 |
| Read      | Viewed    | Manual                 |
| Read      | Unread    | Manual                 |
| Archived  | Unread    | Manual (unarchive)     |
| Archived  | Viewed    | Manual (unarchive)     |
| Archived  | Read      | Manual (unarchive)     |

No other transitions are permitted.

---

## Explicit prohibitions

The system must never:

- mark items as **Read** automatically
- infer reading completion
- change state based on:
  - time spent
  - scroll depth
  - revisit count
  - metadata analysis
- allow AI or automation to mutate state

---

## Viewed state integrity

The **Viewed** state is intentionally preserved.

It must not be:
- collapsed into Unread/Read
- derived from analytics
- removed for simplicity

Viewed exists to:
- acknowledge user interaction
- without implying judgement or completion



---

## Reversibility

All states are **reversible**.

There are:
- no terminal states
- no irreversible transitions (except deletion)

User intent always overrides prior state.

---

## Deletion interaction

Deletion is **orthogonal to state**.

- Deleting a Saved Item removes it permanently.
- Deletion bypasses all state transitions.
- There is no “Deleted” state.

---

## Canonical rules

- State changes must be explicit and visible.
- Automatic transitions must be minimal and obvious.
- If a feature proposes a new state or transition:
  - this document must be updated first
  - Product Outline must remain consistent

State is not a metric.  
State is not insight.  
State is intent, recorded.


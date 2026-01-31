# UI Principles — Reading Inbox

**Status:** Canonical  
**Applies to:** All user-facing interfaces  
**Audience:** Developers, designers, and automation tooling

This document defines the interaction principles that govern the Reading Inbox user interface.

The UI exists to **support reading**, not to optimise behaviour.

---

## Core UX goals

The interface must feel:

- calm
- predictable
- fast
- low-distraction

Every interaction should reinforce:
- capture
- return
- trust

---

## Mobile-first truth

Reading Inbox is designed **iPhone-first**.

This is not a responsive afterthought:
- mobile is the primary context
- desktop is secondary support

Design decisions should prioritise:
- thumb reach
- one-handed use
- short attention windows

---

## Primary action hierarchy

### Primary action

**Save a URL**

- This must be the most prominent action on the homepage.
- It should be reachable without scrolling.
- It should require minimal input and no setup.

---

### Secondary actions

- Scan the inbox
- Open an item
- Manually change its state

Secondary actions must never compete visually with the primary action.

---

## Inbox presentation

The Inbox should be:

- vertically scannable
- uncluttered
- ordered by most recent first

Avoid:
- dense toolbars
- nested menus
- multi-step flows
- bulk operations in MVP

---

## State interaction

State changes must be:

- explicit
- reversible
- obvious in outcome

The UI must never:
- imply state change without confirmation
- hide state transitions
- auto-mark items as read

---

## Feedback & affordances

User feedback should be:

- immediate
- calm
- informative

Avoid:
- celebratory animations
- gamified language
- progress indicators
- urgency cues

---

## Error handling

Errors should be:

- human-readable
- non-technical
- non-alarming

The UI must never:
- punish failed actions
- block capture unnecessarily
- demand corrective input for non-critical issues

---

## Modals & interruptions

Avoid:
- modals
- pop-ups
- forced confirmations

If a modal is introduced:
- it must be clearly justified
- it must protect against data loss

---

## Consistency over cleverness

Prefer:
- predictable layouts
- repeated patterns
- boring interactions

Avoid:
- experimental UI metaphors
- novelty interactions
- “smart” behaviours

---

## Explicit non-goals

The UI must never:

- encourage binge reading
- visualise productivity
- show reading statistics
- introduce streaks or scores
- nudge or remind the user

---

## Canonical rule

If a UI change proposes:
- additional actions
- new surfaces
- increased density
- behavioural cues

this document must be consulted and updated first.

The UI should feel quiet enough to disappear.

## Visual styling reference

The Reading Inbox UI should feel **editorial and quiet**, similar in spirit to Instapaper:

- narrow, readable columns
- generous whitespace
- minimal chrome (no heavy panels or dashboards)
- typography-forward (serif-forward reading tone, system-ui for form controls)
- restrained color usage (links are visible but not loud)

This is a **directional reference**, not a template:
we do not copy layouts verbatim, but we do preserve the same *calm reading-first* feeling.

### Typography (Canonical)

The UI uses **Open Props font families exclusively**.

- **Primary reading and headings:** `--font-transitional`
  - Editorial, book-like tone suitable for long-form reading
- **UI controls and forms:** `--font-system-ui`
  - Native system fonts for speed, familiarity, and mobile ergonomics

No custom font stacks or external font services are used.
All typography decisions must reference Open Props variables directly.

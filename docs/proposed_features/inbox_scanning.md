## Inbox list scanning
**Status:** Not created ❌  
This feature is the “reading surface” of the app: a fast, low-distraction way to scan saved items at a glance (title/URL fallback, state, and key cues) and decide what to open next. It should optimise for clarity and speed rather than dense controls or filters.

## Feature: Inbox list scanning
**Status:** Not created ❌  

This feature provides the canonical inbox view where a user can scan their saved items in a calm, predictable way. It supports the core “capture and return” loop by making it easy to come back later and decide what to read next, without introducing dashboards or distraction.

### Detailed outline

#### Purpose
- Provide a **canonical inbox view** where a user can **scan their saved items**.
- Ensure the default list is **ordered by most recently added first**.

#### Why this feature exists
- Supports the product’s “capture and return” loop by making it easy to **return later in a calm, focused environment**.
- Reinforces the system’s focus on **clarity and low distraction** over dashboard-style management.

#### Core concept
- The inbox is the default, predictable place a user goes to 
This feature allows a user to permanently remove a saved item from their account. Deletion is final by design: there is no trash, no recovery, and no retention beyond immediate removal.

### Detailed outline

#### Purpose**see Saved Items**.
- The canonical ordering is fixed for MVP: **most recently added first**.

#### Actors
- **User** (only MVP role)
  - Views and scans their own inbox list of Saved Items.

#### Model / data rules
- **Primary model:** SavedItem
- Relevant stored data that impacts the inbox list:
  - `created_at` (used for default ordering)
  - `state` (Unread / Viewed / Read / Archived)
  - `url`
  - `fetched_title` (best-effort; may be missing)
  - `domain`
  - `last_viewed_at` (not used for ordering in MVP)

#### Inbox list contents (MVP)
- **Archived** items are defined as removed from the active inbox but retained permanently.
- Therefore:
  - **Archived items must not appear** in the active inbox list.

#### Ordering rules (MVP)
- Default ordering is **most recently added first** (`created_at DESC`).

#### Metadata failure handling
- Metadata fetching is non-blocking and best-effort.
- If metadata fetch fails:
  - The item **still appears** in the inbox list.
  - The UI displays the **clean URL**.
  - A note indicates **metadata was not available**.

#### Deletion & retention
- Deletion is a **hard delete** with permanent removal.
- A deleted item **must not appear** in the inbox list.

#### Gating & access control
- Accounts are required from day one.
- The inbox list shows **only the authenticated user’s Saved Items**.
- No admin or multi-role behaviour is exposed in MVP.

#### UX & UI principles
- **Mobile-first (iPhone-first)**: inbox scanning is secondary to URL capture but must remain clean and usable on mobile.
- **Low distraction / low cognitive load**
  - Maintain predictable, canonical ordering.
  - Avoid dashboard-style signals (scores, rankings, analytics).
- **Clarity when data is missing**
  - Show clean URL and a clear metadata-unavailable indicator when enrichment fails.

#### Extensibility requirements
- Do not implement in MVP, but do not block:
  - Ordering by tag
  - Filtering by category
  - Alternate sort modes
- Ensure data separation supports **invited users later**, even though MVP is single-role.

#### What “done” means
- An authenticated user can open the inbox and **scan a list of their Saved Items**.
- Items are ordered **most recently added first**.
- **Archived items are excluded** from the active inbox.
- Items with failed metadata still display clearly:
  - URL is visible
  - Metadata-unavailable state is indicated
- No non-MVP behaviour is introduced.

#### Explicit non-goals
- Any non-default sorting or filtering in MVP:
  - Ordering by tag
  - Filtering by category
  - Alternate sort modes
- Social or sharing features.
- Behavioural tracking or engagement analytics.
- Reader mode, notes, highlights, or AI features.

#### Open questions
- Should the inbox list display **all non-archived states** (Unread, Viewed, Read) together, or exclude some (e.g. Read)? The guideline doc only specifies that Archived is removed.
- Is ordering strictly `created_at DESC`, or does re-saving an already-saved URL affect position?
- What exactly constitutes a “clean URL” display format (truncation, protocol removal, etc.)?


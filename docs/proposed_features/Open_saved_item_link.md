
## Feature: Open saved item link
**Status:** Not created ❌  

This feature allows a user to open the original article URL for a saved item directly from the inbox. Opening an item also advances its reading lifecycle in a minimal, intentional way by recording that it has been opened at least once.

### Detailed outline

#### Purpose
- Allow users to tap a Saved Item in the inbox to open the underlying article URL.
- Ensure that opening an item updates its reading lifecycle state appropriately, as defined in the guideline doc.

#### Why this feature exists
- The core loop of the product is to capture long-form articles quickly and return later to read them in a calm, focused environment.
- The guideline doc explicitly identifies “tapping an item to open it” as a primary secondary action in the mobile-first flow.

#### Core concept
- A Saved Item represents a single unique article URL saved by a user.
- When a user taps a Saved Item in the inbox:
  - The system opens the URL.
  - If this is the first open, the item transitions from **Unread** to **Viewed**.

#### Actors
- **User (MVP)**  
  - An authenticated account holder accessing their own Saved Items.

#### Model / data rules
- **Primary model:** SavedItem
- Relevant stored data for this feature:
  - `url` (required)
  - `state` (Unread / Viewed / Read / Archived)
  - `last_viewed_at` (if applicable)

#### Rules when opening a Saved Item
- **Opening behavior**
  - Tapping an item opens the Saved Item’s URL.
- **State transition**
  - If the current state is **Unread**, transition to **Viewed** on first open only.
  - “Viewed” must continue to mean *opened at least once*, not engagement.
- **`last_viewed_at` handling**
  - Update `last_viewed_at` when the user opens the link.
- **Prohibited behavior**
  - Do not automatically mark items as **Read**.
  - Do not track engagement time, scroll depth, or attention.
  - Do not infer reading completion from behavioral signals.

#### Deletion & retention
- Opening a Saved Item does not delete or modify retention.
- Hard deletion is handled by a separate feature and is not invoked here.

#### Gating & access control
- The user must be authenticated.
- A user may only open Saved Items that belong to their account.
- Cross-user access is prohibited.

#### UX & UI principles
- **Mobile-first**
  - Tapping an item to open it is a core interaction on iPhone-sized screens.
- **Low distraction**
  - Opening a link should be a direct action with no added surfaces or interruptions.
- **Clear state philosophy**
  - The UI must not imply analytics or “reading time” tracking when an item is opened.
- **Metadata failure tolerance**
  - If title metadata is unavailable, the clean URL may be displayed, but the open-link action must still work reliably.

#### Extensibility requirements
- Preserve lifecycle semantics for future features:
  - “Viewed” remains a persistent, explicit state.
- Future Reader Mode or in-app reading experiences are separate, user-initiated features.
- The data model must continue to support `last_viewed_at` without schema changes.

#### What “done” means
- From the inbox, a user can tap a Saved Item and the system opens the item’s URL.
- On first open of an **Unread** item:
  - State transitions to **Viewed**.
  - `last_viewed_at` is set or updated.
- On subsequent opens:
  - The URL opens normally.
  - The item is not automatically marked **Read**.
  - `last_viewed_at` reflects the open event.
- No engagement tracking or analytics are introduced.

#### Explicit non-goals
- Reader Mode or extracted article rendering.
- Automatic “Read” marking.
- Reading time, scroll depth, or attention tracking.
- Recommendations, prioritisation, or ranking.
- Any analytics-driven behaviour.

#### Open questions
- Should the URL open in the same tab, a new tab, or an in-app browser view?
- When exactly should `last_viewed_at` be updated: on tap, after navigation, or on return?
- Should items in **Read** or **Archived** states still open normally when tapped?
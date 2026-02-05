## Feature: Hard delete items
**Status:** Not created ❌  

This feature allows a user to permanently remove a saved item from their account. Deletion is final by design: there is no trash, no recovery, and no retention beyond immediate removal.

### Detailed outline

#### Purpose
- Allow a user to permanently remove a previously saved item from their account.
- Ensure deletion has **no trash**, **no recovery**, and **no retention semantics** beyond immediate removal.

#### Why this feature exists
- The product treats saved items as a permanent personal archive **until the user explicitly deletes them**.
- The guideline doc explicitly defines deletion as **hard delete** to avoid trash, recovery flows, or retention complexity.

#### Core concept
- A user can delete a Saved Item, and that deletion is **final**:
  - The item is permanently removed.
  - There is no undo, trash, or recovery mechanism.

#### Actors
- **User (MVP)**  
  - Deletes their own Saved Items.
- No admin or elevated roles are exposed in MVP.

#### Model / data rules
- **Object affected:** SavedItem
- **Deletion rules (MVP)**
  - Deletion is a **hard delete**.
  - Deleted items are permanently removed.
  - No trash or recovery semantics exist.
- **Retention rule**
  - The archive is permanent only until the user deletes an item.
- **Scope constraint**
  - Deletion applies only to the user’s own Saved Items.
- **Not specified by the guideline**
  - Whether deletion is allowed from all states (Unread / Viewed / Read / Archived).
  - Whether confirmation or other UX safeguards are required.

#### Gating & access control
- Authentication is required from day one.
- A user may only delete Saved Items they own.
- Cross-user deletion is prohibited.
- MVP exposes a single role: **user**.

#### UX & UI principles
- Maintain **clarity** and **low distraction**, especially on mobile.
- Avoid introducing management-heavy UI or workflows.
- Deletion UX specifics (confirmation, placement, bulk actions) are intentionally undefined at this stage.

#### Extensibility requirements
- Deletion semantics are intentionally constrained:
  - Do not introduce trash, recovery, or retention windows.
- Ensure compatibility with:
  - Future invited users (correct data separation).
  - Future export functionality (roadmap), noting that deleted items are excluded.

#### What “done” means
- A signed-in user can delete a Saved Item they own.
- After deletion:
  - The item is permanently removed.
  - There is no undo, trash, or recovery.
- Access control prevents deleting another user’s data.

#### Explicit non-goals
- Trash bins, recovery flows, undo actions, or retention periods.
- “Recently deleted” views or recycle-bin semantics.
- Automated backups or recovery behavior.
- Admin-only deletion tools.

#### Open questions
- Is deletion allowed from all Saved Item states, or only some?
- Should deletion require explicit confirmation, or be immediate?
- Is deletion supported only one item at a time, or in bulk?


# Feature Outline

## 1. Feature Metadata

* **Feature name:** Explicit Delete (Hard Delete)
* **Short description:**
  Provide a clear, user-initiated way for a user to permanently delete a Saved Item. Deletion is irreversible, distinct from Archiving, and requires explicit user intent.
* **MVP / phase context:**
  MVP feature. Applies to core Saved Item lifecycle as defined in canonical documentation.

---

## 2. Purpose

This feature allows a user to permanently remove a Saved Item from their personal Reading Inbox.

It exists to:

* enforce the product’s explicit retention philosophy
* ensure the archive remains intentional and meaningful
* provide a clear, final alternative to Archiving

Deletion exists because not all saved items are meant to be retained indefinitely, and because long-term trust in the archive requires the ability to remove items completely by explicit choice.

---

## 3. Source of Truth & Rationale

This feature is grounded in the following canonical documents:

* `docs/outline/00_product_outline.md`

  * Defines the system as a **personal archive** governed by explicit user intent.
  * Establishes that Reading Inbox is not a productivity or analytics system.
* `docs/state_model.md`

  * Defines Saved Item lifecycle as explicit and intentional.
  * Treats state as a first-class concept, reinforcing the need for deletion to be conceptually distinct from state transitions.
* `docs/domain_language.md`

  * Defines **Saved Item** as a core domain noun belonging to exactly one user.
* `docs/ui_principles.md`

  * Requires calm, predictable, low-distraction interactions.
  * Implies that destructive actions must be clear and intentional.

Interpretation boundaries:

* Deletion is not described as a state.
* No trash, recovery, or soft-delete semantics are defined in documentation.
* Documentation silence on recovery is treated as prohibition.

---

## 4. Core Concept

Explicit Delete is a **terminal, destructive action** on a Saved Item.

Conceptually:

* Archiving preserves an item for later reconsideration.
* Deletion removes the item entirely from the user’s system and history.

The feature should be understood as:

> “I no longer want this item to exist in my Reading Inbox.”

It is not part of the reading lifecycle, but an explicit exit from it.

---

## 5. Actors & Roles

* **Authenticated user**

  * The sole actor capable of deleting a Saved Item.
* **Explicitly excluded roles**

  * No admin role
  * No shared or collaborative roles
  * No system-initiated deletion

---

## 6. User Perspective & Intent

The user:

* consciously chooses to delete a specific Saved Item
* understands deletion as permanent and irreversible

The user is not expected to:

* recover deleted items
* manage a trash or recycle bin
* rely on automated cleanup or system suggestions

All intent is:

* manual
* explicit
* user-initiated

---

## 7. Scope

### In Scope

* Permanent removal of a Saved Item by the owning user
* Clear distinction between Delete and Archive
* Explicit user action to initiate deletion
* Immediate effect once confirmed

### Out of Scope

* Soft delete or trash states
* Recovery, undo, or restore mechanisms
* Bulk deletion
* Automated deletion based on age, state, or behaviour
* System prompts or nudges to delete

---

## 8. Behavioral Rules & Constraints

* Deletion must:

  * be explicit
  * be intentional
  * be irreversible
* Deletion must not:

  * be inferred from behaviour
  * be triggered automatically
  * be conflated with state changes
* UX must:

  * remain calm and predictable
  * avoid accidental activation
  * clearly communicate finality

---

## 9. Data & Structural Assumptions

* **Primary domain entity:** Saved Item
* Each Saved Item:

  * belongs to exactly one user
  * exists independently of other Saved Items
* Deletion:

  * removes the Saved Item entirely for that user
* No cross-user or global effects are implied or permitted.

---

## 10. State & Lifecycle (if applicable)

* Deletion is **not** a Saved Item state.
* Deletion:

  * terminates the Saved Item lifecycle
  * removes the item from all states (Unread, Viewed, Read, Archived)
* Deletion is irreversible.

---

## 11. UI Responsibilities (Non-Visual)

The UI must:

* provide a clear, discoverable delete action
* distinguish Delete from Archive in wording and intent
* require explicit user confirmation of deletion
* avoid accidental activation through gesture or proximity

The UI must not:

* imply recoverability
* hide or obscure the destructive nature of the action

---

## 12. Permissions & Ownership Rules

* Only an authenticated user may delete Saved Items.
* A user may delete **only their own** Saved Items.
* No administrative or system-level deletion exists in MVP.

---

## 13. Failure States & Edge Cases

* Attempting to delete a non-existent Saved Item
* Attempting to delete a Saved Item not owned by the user
* Duplicate delete attempts on the same item
* User cancellation before confirmation

User-facing feedback must:

* be clear
* be minimal
* avoid technical language

---

## 14. Dependencies & Preconditions

* User authentication must exist.
* Saved Item creation and ownership must already be implemented.
* Archive functionality may exist but is not a prerequisite.

---

## 15. Extensibility & Forward Compatibility

* The feature must not assume future recovery or trash systems.
* Future expansion must not retroactively change deletion semantics.
* MVP implementation should remain minimal and final by design.

---

## 16. Documentation Impact

This feature:

* implements behavior implied by the Product Outline’s retention philosophy
* does not introduce new domain nouns or states

If accepted, the following documents may require updates:

* `docs/outline/01_feature_list.md` (feature inclusion)
* Potential clarification in `docs/domain_language.md` regarding deletion semantics

---

## 17. Acceptance Criteria (Feature-Level)

The feature is complete when:

* A user can permanently delete a Saved Item they own
* Deleted items are no longer visible or accessible
* Deletion is clearly distinct from Archiving
* No recovery path exists
* All actions require explicit user intent

---

## 18. Explicit Non-Goals

* Trash or recycle bin
* Undo or restore
* Bulk deletion
* Automated or suggested deletion
* Deletion analytics or tracking

---

## 19. Open Questions (only if required)

* None.

---

## Prior work acknowledgement

**Relied-on existing capabilities**

* **Saved Item domain entity** and ownership rules are already defined and implemented (per `docs/domain_language.md`).
* **Authentication** and per-user data isolation already exist (precondition in Feature Outline §14).
* **State model** (Unread / Viewed / Read / Archived) is implemented and explicitly excludes deletion as a state (`docs/state_model.md`).
* **Archive functionality** exists or may exist, but is conceptually distinct and not reused for deletion.

**Explicitly excluded as already covered or out of scope**

* No soft-delete, trash, recovery, or undo mechanisms (explicit non-goals).
* No bulk operations.
* No automated or system-initiated deletion.
* No analytics, logging, or optimisation work.

---

## Canonical implementation tasks

### Task 1: Enforce ownership and authorization for Saved Item deletion

#### Task Purpose

Ensure that permanent deletion can only be initiated by an authenticated user for their own Saved Items, preserving the personal-archive model.

#### Task Responsibility

This task owns the authorization rules that gate deletion, ensuring deletion requests are valid, user-initiated, and ownership-bound.

#### Explicit Non-Responsibilities

* Does not define or expose any UI controls.
* Does not implement the deletion action itself.
* Does not introduce administrative or system-level permissions.
* Does not handle confirmation or user feedback.

#### Feature Outline Traceability

* §5 Actors & Roles
* §12 Permissions & Ownership Rules
* §13 Failure States & Edge Cases

#### Completion Signal

Deletion requests are permitted only for authenticated users acting on Saved Items they own, and rejected otherwise.

---

### Task 2: Provide a terminal delete action for a single Saved Item

#### Task Purpose

Introduce a user-invoked operation that permanently removes a Saved Item from the system, distinct from any state transition.

#### Task Responsibility

This task owns the actual removal of the Saved Item such that it no longer exists in any state or listing for the user.

#### Explicit Non-Responsibilities

* Does not model deletion as a Saved Item state.
* Does not support bulk deletion.
* Does not introduce recovery, undo, or retention semantics.
* Does not modify or infer reading progress.

#### Feature Outline Traceability

* §4 Core Concept
* §7 Scope (In Scope)
* §10 State & Lifecycle
* §17 Acceptance Criteria

#### Completion Signal

A deleted Saved Item is fully removed and cannot be accessed or observed by the user in any context.

---

### Task 3: Add explicit user confirmation for irreversible deletion

#### Task Purpose

Prevent accidental deletion by requiring an explicit, deliberate confirmation before the delete action is executed.

#### Task Responsibility

This task owns the confirmation step that clearly communicates finality and requires the user to affirm deletion intent.

#### Explicit Non-Responsibilities

* Does not implement visual design or styling details.
* Does not provide undo or grace periods.
* Does not reuse archive-related language or affordances.
* Does not introduce additional decision flows.

#### Feature Outline Traceability

* §8 Behavioral Rules & Constraints
* §11 UI Responsibilities (Non-Visual)
* §6 User Perspective & Intent

#### Completion Signal

Deletion cannot occur without an explicit confirmation that clearly signals irreversibility.

---

### Task 4: Expose a clear, distinct Delete action in the Saved Item interface

#### Task Purpose

Make deletion discoverable and clearly distinct from Archiving, while maintaining calm, low-distraction interaction principles.

#### Task Responsibility

This task owns the presence and wording of the delete affordance so users can intentionally choose deletion.

#### Explicit Non-Responsibilities

* Does not determine layout, styling, or gesture mechanics.
* Does not surface deletion suggestions or prompts.
* Does not alter Archive behavior or placement.
* Does not add bulk or contextual actions.

#### Feature Outline Traceability

* §11 UI Responsibilities (Non-Visual)
* §7 Scope (In Scope / Out of Scope)
* §8 Behavioral Rules & Constraints

#### Completion Signal

Users can clearly identify and initiate a Delete action that is unambiguously different from Archive.

---

### Task 5: Handle deletion failure and edge cases with minimal user feedback

#### Task Purpose

Ensure predictable, calm behavior when deletion cannot be completed due to invalid targets, ownership violations, or repeated attempts.

#### Task Responsibility

This task owns the user-facing handling of deletion edge cases, keeping feedback minimal and non-technical.

#### Explicit Non-Responsibilities

* Does not expose internal error details.
* Does not retry or auto-correct user actions.
* Does not log or analyse deletion attempts.
* Does not provide recovery paths.

#### Feature Outline Traceability

* §13 Failure States & Edge Cases
* §8 Behavioral Rules & Constraints

#### Completion Signal

Invalid or failed deletion attempts result in clear, minimal feedback without breaking user flow.

---

### Task 6: Update documentation to reflect explicit hard-delete behavior

#### Task Purpose

Ensure the documentation accurately reflects the existence and semantics of irreversible deletion.

#### Task Responsibility

This task owns updating canonical documentation to include this feature without introducing new domain concepts.

#### Explicit Non-Responsibilities

* Does not redefine Saved Item states.
* Does not introduce future recovery or trash concepts.
* Does not modify product philosophy or scope.
* Does not add roadmap speculation.

#### Feature Outline Traceability

* §16 Documentation Impact
* §3 Source of Truth & Rationale

#### Completion Signal

Documentation clearly describes deletion as a permanent, explicit action consistent with the product’s retention philosophy.

---

**Stop condition reached:**
All Feature Outline acceptance criteria are satisfied by the tasks above. No additional tasks are required or permitted under the defined scope.

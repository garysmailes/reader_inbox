# Feature List

This document lists the **core product features** of the Reading Inbox application and the **implementation tasks** associated with each feature.

Each feature is represented as a top-level section, with a clear status indicating whether the feature is active or not yet created. Where applicable, features include a short description explaining their intent and scope, followed by a list of completed or planned tasks that describe the concrete work carried out to implement the feature.

This file is intended to act as a **high-level, canonical overview** of the product surface. It is not exhaustive technical documentation. If more detail is required for a feature or task, it should be captured in the relevant feature-specific documentation or in the codebase itself.

---

## Feature 01: User accounts authentication
**Status:** Active ✅  

Reading Inbox is a personal system, so every saved item is tied to a single authenticated user. The entire product surface is gated behind sign-in to guarantee data separation and keep the app “deny by default.”

### Completed tasks
- ✅ Generate User model and authentication using Rails 8 built-in authentication  
- ✅ Associate SavedItem records to User for per-user ownership  
- ✅ Add database constraints and indexes to enforce SavedItem user ownership  
- ✅ Require authentication to access the application's reading inbox routes  
- ✅ Scope SavedItem queries and lookups to current user to enforce per-user data separation  
- ✅ Implement sign-up screen and flow using Rails 8 built-in authentication defaults  
- ✅ Implement sign-out action using Rails 8 built-in authentication defaults  
- ✅ Make authentication screens mobile-first  

---

## Feature 02: Simple user onboarding
**Status:** Active ✅  

Onboarding is intentionally minimal: once a user signs up or signs in, they are taken directly to the authenticated core experience. The system avoids tutorials, profiles, or setup steps, optimising purely for fast access to the inbox and first URL capture.

### Completed tasks
- ✅ Set post-sign-up redirect to the authenticated core experience entry point  
- ✅ Set post-sign-in redirect to the authenticated core experience entry point  

---

## Feature 03: Save article URL
**Status:** Active ✅  

This feature provides the core capture mechanism of Reading Inbox: allowing an authenticated user to save an article URL quickly and reliably. Saving is designed to be resilient and user-first, with best-effort metadata enrichment, strict per-user ownership, and clear feedback when a URL has already been saved.

### Completed tasks
- ✅ Generate SavedItem model with user reference, url, fetched_title, domain, state, last_viewed_at, timestamps  
- ✅ Add foreign key constraint from saved_items.user_id to users.id  
- ✅ Add unique database index on saved_items (user_id, url)  
- ✅ Add SavedItem state definition with initial state Unread  
- ✅ Add SavedItem validations for presence of url and user  
- ✅ Implement SavedItem metadata fetch service to best-effort populate fetched_title and domain without blocking save  
- ✅ Implement SavedItems create action scoped to current user with best-effort deduplication by url  
- ✅ Require Rails 8 built-in authentication for SavedItems create and destroy routes  
- ✅ Implement SavedItems destroy action as hard delete scoped to current user  
- ✅ Add mobile-first homepage URL submission form to create a Saved Item  
- ✅ Show “already saved” indication when URL submission matches an existing Saved Item for the user  
- ✅ Render Saved Item display using fetched title and domain when available  
- ✅ Render clean URL and a metadata-unavailable note when metadata is not available  

---

## Feature 04: Per user URL deduplication
**Status:** Active ✅  

This feature ensures that a user cannot save the same URL more than once, keeping the inbox clean and intentional. Deduplication is enforced at both the database and application layers, with clear user feedback when a duplicate is detected rather than silently failing.

### Completed tasks
- ✅ Add per-user uniqueness constraint for saved_items on user_id and url  
- ✅ Add per-user uniqueness validation for SavedItem url scoped to user  
- ✅ Update SavedItems create flow to find existing item for user by url and skip creation  
- ✅ Render “already saved” indication when a duplicate URL is submitted  

---

## Feature 05: Saved item metadata
**Status:** Active ✅  

This feature enriches saved items with lightweight, best-effort metadata to make the inbox easier to scan and use. Metadata is opportunistic rather than guaranteed: failures are handled gracefully, and the UI clearly communicates when enrichment is unavailable instead of guessing.

### Completed tasks
- ✅ Add SavedItem model fields: url, fetched_title, domain, state, last_viewed_at  
- ✅ Add database timestamps to saved_items  
- ✅ Add user association to SavedItem  
- ✅ Add per-user unique index on saved_items url  
- ✅ Implement SavedItem URL required validation  
- ✅ Implement create-or-reuse SavedItem by user+url  
- ✅ Return “already saved” response when user saves an existing URL  
- ✅ Derive and persist domain from saved URL  
- ✅ Implement non-blocking best-effort metadata fetch to populate fetched_title  
- ✅ Render Saved Item title and domain when available  
- ✅ Render clean URL fallback when metadata is unavailable  
- ✅ Render “metadata was not available” indicator when metadata fetch fails  

---

## Feature 06: Non blocking metadata fetching
**Status:** Active ✅  

This feature ensures that saving a URL is always fast and reliable, regardless of whether metadata can be fetched. Metadata enrichment runs after the item is created and never blocks the save response, allowing failures or delays without impacting the core capture experience.

### Completed tasks
- ✅ Add SavedItem fields for url, fetched_title, domain, state, last_viewed_at  
- ✅ Enforce per-user uniqueness constraint on SavedItem url  
- ✅ Validate presence of url on SavedItem  
- ✅ Create SavedItem with required URL without requiring metadata  
- ✅ Run metadata fetching after SavedItem creation without blocking the save response  
- ✅ Persist fetched title and domain when metadata fetching succeeds  
- ✅ Render a clean URL when title metadata is unavailable  
- ✅ Display a “metadata was not available” note when metadata fetching fails  

---

## Feature 07: Reading lifecycle states
**Status:** Active ✅  

This feature defines the explicit lifecycle of a saved item as it moves from capture to completion. States are intentionally simple, user-visible, and persistent, avoiding inference or engagement tracking while still supporting clear reading progress.

### Completed tasks
- ✅ Add SavedItem state column as required with allowed values Unread / Viewed / Read / Archived  
- ✅ Add SavedItem last_viewed_at column  
- ✅ Backfill existing Saved Items state to Unread  
- ✅ Validate SavedItem state inclusion in Unread / Viewed / Read / Archived  
- ✅ Default SavedItem state to Unread on create  
- ✅ Scope SavedItem queries to the authenticated user for state read/update  
- ✅ Implement “first open” transition to set state to Viewed when current state is Unread  
- ✅ Set last_viewed_at when applying the Unread-to-Viewed transition  
- ✅ Add controller/service action to update a Saved Item state explicitly  
- ✅ Filter Archived items out of the canonical inbox view  
- ✅ Show Saved Item state indicator in inbox list  
- ✅ Add UI control to manually set Saved Item state to Read  
- ✅ Add UI control to set and unset Saved Item state to Archived  

---

## Feature 08: Automatic viewed state
**Status:** Active ✅  

This feature automatically records the first time a user opens a saved item, transitioning it from *Unread* to *Viewed*. The transition is intentionally minimal and one-way, capturing only “opened at least once” without inferring reading completion or engagement.

### Completed tasks
- ✅ Add database columns for saved_items.state and saved_items.last_viewed_at  
- ✅ Add database NOT NULL constraint for saved_items.url  
- ✅ Add database uniqueness constraint on saved_items (user_id, url)  
- ✅ Implement SavedItem model default state = Unread on creation  
- ✅ Add SavedItem model validation for required url  
- ✅ Add SavedItem model validation for uniqueness of url scoped to user  
- ✅ Implement SavedItem instance method to mark first-open as Viewed and set last_viewed_at  
- ✅ Add authenticated controller action to record first-open for a Saved Item owned by current user  
- ✅ Update Saved Item open-link flow to call first-open action before redirecting to the URL  

---

## Feature 09: Manual read state
**Status:** Active ✅  

This feature allows a user to explicitly mark a saved item as *Read* when they decide they have finished with it. The system never infers this state automatically; moving an item to *Read* is always a deliberate, reversible user action.

### Completed tasks
- ✅ Add SavedItem state enum with Unread, Viewed, Read, Archived  
- ✅ Set SavedItem initial state to Unread on create  
- ✅ Add SavedItem last_viewed_at timestamp field  
- ✅ Implement per-user URL uniqueness validation for SavedItem  
- ✅ Scope SavedItem state update actions to the authenticated user  
- ✅ Implement automatic transition to Viewed on first link open without setting Read  
- ✅ Implement manual SavedItem state update to Read  
- ✅ Implement manual SavedItem state updates for reversibility  
- ✅ Expose a secondary inbox action to manually set a SavedItem to Read  

---

## Feature 10: Archive saved items
**Status:** Active ✅  

This feature allows users to remove items from the active inbox without deleting them. Archiving is an explicit, reversible state change that keeps the inbox focused while preserving long-term access to saved content.

### Completed tasks
- ✅ Add “Archived” to SavedItem state enum and validation  
- ✅ Add SavedItem scope for active inbox items excluding Archived  
- ✅ Add SavedItem scope for archived items  
- ✅ Add SavedItemsController action to set state to Archived for current user  
- ✅ Add SavedItemsController action to unarchive by setting state to an explicit non-archived state  
- ✅ Enforce ownership checks for archive/unarchive state updates  
- ✅ Update canonical inbox query to order by created_at desc and exclude Archived  
- ✅ Add archived items index view scoped to current user  
- ✅ Add archive action control on Saved Item UI  
- ✅ Add unarchive action control on Archived Saved Item UI  

---

## Feature 11: Mobile first homepage capture
**Status:** Active ✅  

This feature optimises the homepage for fast, low-friction URL capture on mobile devices. The interface prioritises clarity and resilience, ensuring that saved items display sensibly even when metadata is unavailable or delayed.

### Completed tasks
- ✅ Persist clean URL display value for cases where metadata is unavailable  
- ✅ Render saved item using fetched title and domain when available  
- ✅ Render clean URL and “metadata not available” indicator when metadata fetch fails  
# Feature 001 — User accounts authentication

**Status:** Canonical  
**Source of truth:** Product Outline (Identity & Roles)

## Purpose
Accounts are required from day one so the product functions as a personal reading inbox and data separation is correct immediately.

## Implementation (MVP)
- Uses Rails 8 built-in authentication generator (`bin/rails generate authentication`)
- One User model (`email_address`, `password_digest`)
- Session-based auth via generated Session model and Authentication concern
- Entire product surface is gated (unauthenticated users are redirected to sign-in)
- Simple onboarding: sign-up with email + password + confirmation, then auto sign-in

## Out of scope (MVP)
- Admin role / admin UI
- Invitations
- SSO, MFA, passwordless login
- Profile editing / account deletion flows

### Global Authentication Enforcement (Canonical)

The application uses a **deny-by-default** access model.

Authentication is enforced **globally** at the application controller level.

All routes and controllers require authentication unless explicitly exempted.

Public access is limited to a small, explicit set of routes required for authentication itself (e.g. sign-in, sign-up, password reset).

This ensures:

- Accounts are required from day one.
- No new product surface can be accidentally exposed without authentication.
- Per-user privacy expectations are enforced structurally, not by convention.

Any new unauthenticated route must be:

- explicitly documented, and
- explicitly exempted from authentication.

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

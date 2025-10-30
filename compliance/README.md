Compliance documentation folder

Purpose
This directory contains documents, policies, and templates to support SOC 1 compliance efforts for the meet-v0 and meet-backend projects.

Structure
- `SOC1_PLAN.md` — high-level plan and timeline.
- `TODO.md` — tracked tasks and progress.
- `policies/` — policy templates (AccessControl.md, ChangeManagement.md, BackupPolicy.md, IncidentResponse.md).
- `evidence/` — guidance for storing collected evidence (do not store real secrets here).

How to use
- Keep this directory under version control.
- Update `TODO.md` as items progress.
- Place policy drafts in `policies/` and mark them as reviewed when approved.
- Use `evidence/` to store references to evidence locations (S3 URIs, log exports) — avoid storing sensitive data in the repo.

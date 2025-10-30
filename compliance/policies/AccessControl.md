Access Control Policy (Draft)

Purpose
Define how access to systems, applications, and data is managed and reviewed.

Scope
Applies to all systems in scope for SOC 1: `meet-v0` frontend, `meet-backend`, infrastructure components, and related services.

Policy
- Principle of least privilege.
- Use SSO and RBAC; no shared user accounts for interactive access.
- MFA required for all interactive accounts with access to production or sensitive data.
- Service accounts must be limited in scope, rotated or managed via secrets manager.
- Access requests must be documented and approved by the resource owner.
- Offboarding must remove access promptly and be documented.
- Quarterly access reviews for production systems; ad-hoc reviews for high-risk roles.

Evidence
- IAM configurations and role mappings.
- MFA enablement logs and snapshots.
- Access request tickets and approvals.
- Quarterly access review logs and remediation tickets.

Responsibilities
- Engineering: implement IAM/RBAC and enforce policies.
- HR/People Ops: notify of employee exits.
- Security/Ops: conduct periodic reviews and audits.

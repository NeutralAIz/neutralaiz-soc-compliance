Change Management Policy (Draft)

Purpose
Ensure controlled, auditable changes to systems that affect the service and financial reporting.

Scope
All production-facing systems, CI/CD pipelines, IaC, and configuration changes.

Policy
- All changes must be proposed via a ticket with a business justification and impact analysis.
- Use Git-based PR workflows; require at least one approver (two for high-risk changes).
- Link PRs to change tickets and include test evidence.
- Emergency changes must be documented and post-approved with a retrospective.
- Maintain deployment history and rollback procedures.

Evidence
- Change tickets, PR history, merge approvals, CI build logs, deployment logs.

Responsibilities
- Developers: provide test evidence and link PRs to tickets.
- Engineering manager/owner: approve changes.
- Ops/SRE: perform deployments and monitor post-deploy.

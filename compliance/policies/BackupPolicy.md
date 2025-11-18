Backup & Recovery Policy (Draft)

Purpose
Ensure availability and recoverability of systems and data in scope for SOC 1.

Policy
- Daily backups of production databases and critical storage; frequency may vary by data classification.
- Backups must be encrypted in transit and at rest.
- Backup retention: minimum 90 days; retention period may be extended per business needs.
- Periodic (quarterly) restore tests with documented results.
- Offsite or separate-region backups for disaster recovery.

Evidence
- Backup schedules and logs.
- Encryption configuration and KMS policies.
- Restore test reports and remediation tickets.

Responsibilities
- Ops/SRE: manage backup jobs and run restore tests.
- Engineering: identify critical data and support restores.

SOC 1 Gap Analysis — initial (meet-v0 & meet-backend)

Purpose
Map current artifacts and processes against SOC 1 control categories relevant to financial reporting and identify gaps, priorities, owners, evidence required, and remediation steps. This is a repo-driven, initial assessment and should be validated against cloud account configurations and operational practices.

Scope
- Applications: `meet-v0` frontend and `meet-backend` agent
- Environments: production, staging, development
- Infrastructure: containers, Cloud Run, Artifact Registry, S3, Cloud Build, GitHub Actions

Method
- Used repository scan outputs (`Dockerfile`, `docker-compose.yml`, `cloudbuild.yaml`, workflows, code) and created an initial mapping to common SOC 1 control objectives (Access, Change Management, System Operations, Backup & Recovery, Logging & Monitoring, Vendor Management).

Summary control matrix (high level)

1) Logical Access Controls
- Expected controls: Unique user IDs, MFA, Role-based access, Periodic access reviews, Service account management.
- Evidence required: IAM policies, list of privileged accounts, MFA logs, access review records.
- Current findings:
  - No IAM manifests in repo. Secrets and envs referenced in Dockerfiles and `.env.example`.
  - GitHub workflows exist; check for admin-level service accounts.
- Gaps:
  - No documented access review process or evidence in repo.
  - No centralized IAM policy artifacts captured.
- Priority: High
- Remediation:
  - Inventory all accounts (GCP, AWS, GitHub), implement MFA and RBAC, schedule quarterly access reviews, and document in `compliance/policies/AccessControl.md`.
  - Evidence collection: export IAM snapshots, MFA enablement logs, access review outputs.
- Suggested owner: Security/Ops + Engineering lead

2) Change Management
- Expected controls: Change requests, approvals, PR-based reviews, CI/CD evidence, emergency change logs.
- Evidence required: Change tickets, PR/merge approvals, CI/CD logs, deployment audit trail.
- Current findings:
  - Repo uses GitHub PRs and has workflows; `cloudbuild.yaml` for production deploys.
  - No documented change management process in repo (policy draft exists but not formalized).
- Gaps:
  - No formal change ticket linking PR->change record; emergency change procedures not documented.
- Priority: High
- Remediation:
  - Formalize `ChangeManagement.md` (in `compliance/policies`), require change ticket IDs on PRs, implement PR approval rules (e.g., branch protection requiring 1-2 approvals), and retain CI/CD logs for the audit period.
  - Evidence collection: PR history exports, deployment logs from Cloud Build, change tickets.
- Suggested owner: Engineering Manager / DevOps

3) System Operations & Availability
- Expected controls: Monitoring, alerting, incident response, patching, capacity planning.
- Evidence required: Monitoring configs, alert history, incident tickets, patch records.
- Current findings:
  - Logging libs present (Datadog client, Cloud Logging in cloudbuild), but no centralized SIEM config in repo.
  - Incident response policy draft exists.
- Gaps:
  - No documented monitoring/alerting configs or retention policy in repo.
  - No evidence of patch management or scheduled maintenance logs.
- Priority: Medium
- Remediation:
  - Document monitoring architecture and retention policies; enable centralized logging (Cloud Logging -> Datadog/SIEM) and capture alert rules and incident tickets.
  - Evidence collection: log retention config, sample alerts, incident reports.
- Suggested owner: Ops/SRE

4) Backup & Recovery
- Expected controls: Scheduled backups, encryption, restore tests, retention policy.
- Evidence required: Backup logs, restore test reports, backup configuration.
- Current findings:
  - No DBs detected in repo; S3 bucket env implies object storage usage.
- Gaps:
  - No documented backup schedules or restore test records in repo.
- Priority: High (if persistent data impacts financial reporting)
- Remediation:
  - Identify all persisted data stores in cloud accounts, configure scheduled encrypted backups, run and document restore tests quarterly, and add `BackupPolicy.md` to evidence.
  - Suggested owner: Ops/SRE + Engineering

5) Logging & Monitoring (Audit trails)
- Expected controls: Immutable audit logs, time synchronization, centralized retention, tamper-evidence.
- Evidence required: Log configuration, retention settings, time-sync evidence, sample logs.
- Current findings:
  - Cloud Build uses `CLOUD_LOGGING_ONLY`; Docker json-file for backend local logs.
  - No explicit log retention configs or time-sync evidence in repo.
- Gaps:
  - Missing central SIEM config, missing log retention evidence.
- Priority: High
- Remediation:
  - Enable centralized log aggregation, set retention per policy (e.g., 12–24 months), ensure time sync via NTP, and collect sample logs covering user access and changes.
  - Suggested owner: Ops/SRE

6) Vendor & Subservice Management
- Expected controls: Vendor due diligence, SOC/ISO reports for subservice providers, contract clauses.
- Evidence required: Vendor contracts, third-party SOC reports.
- Current findings:
  - Third-party services in use: LiveKit, OpenAI, Deepgram, Twilio, AWS, Datadog, GCP Cloud Build.
- Gaps:
  - No vendor evidence collected in repo.
- Priority: Medium
- Remediation:
  - Collect vendor security reports and record them in `compliance/vendor_manifest.md`. Define compensating controls where vendor reports are unavailable.
  - Suggested owner: Legal + Finance + Security

7) Data Classification & Handling
- Expected controls: Data classification, PII protection, retention/deletion rules.
- Evidence required: Data classification policy, deletion/retention logs.
- Current findings:
  - No data classification artifacts in repo.
- Gaps:
  - No documented data classification or handling procedures.
- Priority: Medium
- Remediation:
  - Create `DataClassification.md` and map data flows to classification levels. Configure data retention and deletion.
  - Suggested owner: Product + Security

8) Secrets Management
- Expected controls: Secrets in secret managers, automated rotation, audit logs.
- Evidence required: Secret Manager configs, rotation logs, access logs.
- Current findings:
  - Many env vars used; `.env` referenced but in `.gitignore`. No secrets manager IaC found.
- Gaps:
  - No documented secret storage or rotation policies.
- Priority: High
- Remediation:
  - Move secrets to Secret Manager, implement rotation, restrict access, and collect audit logs.
  - Suggested owner: Security/DevOps

Recommended remediation roadmap (high-level)
- Week 0-2: Inventory cloud accounts, produce IAM snapshots, confirm secret locations, and initiate urgent rotations if secrets were exposed.
- Week 2-6: Implement or enforce RBAC/MFA, formalize change management, CI/CD pipeline hardening, and begin centralized logging.
- Week 6-12: Implement backup/restore testing, vendor manifest collection, and evidence automation (log exports, IAM snapshots, CI/CD exports).
- Week 12+: Start internal tests and prepare for audit (Type I or begin Type II observation period).

Evidence collection templates
- IAM snapshot: `gcloud iam roles list` and `gcloud projects get-iam-policy` exports (or AWS `aws iam list-users` equivalents).
- Change evidence: export PR/merge history via GitHub API and CI/CD build logs (Cloud Build logs).
- Logs: export sample logs for the audit period to secure storage (S3 or Artifact Registry bucket with access control).
- Backups: store backup logs and restore test reports in `compliance/evidence/evidence_index.json` pointing to secure storage URIs.

Next steps I will take (if you want me to proceed)
1. Produce a prioritized remediation tracker (CSV) mapping gaps to tickets, owners, and ETA.
2. Implement automated evidence collectors (scripts) for IAM snapshots, CI/CD pipeline logs, and environment variable scans.
3. Start drafting missing policy documents (Vendor Management, Data Classification, Logging & Monitoring) and sample evidence exports.

Status update
- `Perform SOC 1 gap analysis` is completed and `compliance/gap_analysis.md` created. Please review and confirm priority assignments or provide owners so I can generate the remediation tracker.

Evidence storage guidance

Do not store real secrets or PII in this repository. Use this folder to store pointers to evidence locations (S3 URIs, secure share links) and redacted examples.

Structure
- `evidence_index.json` — index file listing evidence items and locations.
- `samples/` — redacted samples for the auditor (logs with redacted PII, screenshots, policy signatures).
- `outputs/` — local script outputs prior to upload (do not commit raw outputs containing sensitive data).

Automation
- Use the scripts in `../scripts/` to collect evidence locally. Example:

  export PROJECT_ID=meet-frontend
  export OUTPUT_DIR=./compliance/evidence/outputs/gcp
  ./compliance/scripts/collect_iam_gcp.sh

- After verifying outputs, upload them to a secure evidence store (GCS/S3) and add a pointer in `evidence_index.json`.

Adding entries to `evidence_index.json`
- Each evidence item should include: id, title, location (URI), notes.
- Do not include secrets or PII in the repo. Use signed URLs or restricted-bucket URIs.

Retention
Evidence storage and access

This folder contains guidance and the `evidence_index.json` manifest used to record evidence artifacts collected for SOC 1 readiness and auditor review.

## Purpose
- Provide a single manifest of collected evidence items.
- Store presigned links for temporary auditor access and permanent s3:// or gs:// pointers for long-term evidence tracking.

## Retention & expiry
- Presigned URLs are short-lived and are used to give auditors temporary access; they must not be relied on as the permanent record.
- Permanent evidence should be stored in the encrypted S3/GCS bucket (recommended naming convention: `s3://neutralaiz-soc-compliance/evidence/<category>/YYYYMMDD/<artifact>.zip`).
- Retention period: maintain evidence for at least 3 years for SOC 1 purposes unless contractual terms require longer. Adjust per corporate retention policy.

## Access control
- Limit bucket access with IAM so only the security team and auditors have read access to evidence buckets.
- Use bucket-level logging and object versioning to track and recover evidence changes.
- When sharing presigned URLs, only share directly with the auditor and record who received the link and why in the evidence manifest notes.

## How to add evidence
1. Run collection scripts under `../scripts/` which create outputs under `./outputs/`.
2. Use `upload_and_presign_s3.sh` to upload zipped evidence and generate presigned URLs. The script writes `presigned_manifest.json`.
3. Add an entry to `evidence_index.json` with fields: `id`, `title`, `location` (s3:// or presigned URL), `notes`.

## Audit considerations
- For Type II audits, collect evidence snapshots across the audit period; keep a timestamped index of exports.
- Where possible, provide s3:// or gs:// paths and grant the auditor a time-limited IAM role instead of relying solely on presigned URLs.

## Contacts
- Security owner: security@neutralaiz.example
- Evidence custodian: infra@neutralaiz.example


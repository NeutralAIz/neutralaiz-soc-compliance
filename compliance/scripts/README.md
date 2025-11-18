Evidence automation scripts

Where
- Scripts are stored in `compliance/scripts/` and write outputs to `compliance/evidence/outputs/` by default.

What they do
- `collect_iam_gcp.sh` — export GCP IAM policy, service accounts, roles, enabled APIs.
- `collect_iam_aws.sh` — export AWS IAM users, roles, policies, account alias.
- `collect_cloudbuild_logs.sh` — export Cloud Build logs for a date/time range.
- `collect_github_prs.sh` — export GitHub PR list and details using `gh`.
- `collect_cloudrun_envs.sh` — export Cloud Run service descriptions and IAM policy.

How to use
- Ensure CLI tools are installed and authenticated: `gcloud`, `aws`, `gh`, `jq`.
- Run scripts with appropriate environment variables set.
- Upload outputs to secure evidence storage (GCS/S3) and add URIs to `compliance/evidence/evidence_index.json`.

Security notes
- Do not commit outputs containing secrets to the repo.
- Store outputs in a restricted GCS or S3 bucket and provide auditor access via signed URLs or restricted IAM roles.

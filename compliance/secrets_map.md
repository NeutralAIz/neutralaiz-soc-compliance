Secrets & Env Map — automated scan results

This file documents environment variable and secret-like references found in the repository, their locations, risk rating, and recommended remediation steps. This is an automated repository scan — verify against CI providers, cloud consoles, and secrets managers for completeness.

Summary
- Total distinct secret-like names found (examples): LIVEKIT_API_KEY, LIVEKIT_API_SECRET, OPENAI_API_KEY, DEEPGRAM_API_KEY, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, GOOGLE_API_KEY, etc.
- Locations: Dockerfiles, `.env.example`, `docker-compose.yml`, `cloudbuild.yaml`, Python files, Node `Dockerfile`, and GitHub Actions workflows.

Scan findings (by file)

1) `meet-backend/.env.example`
- LIVEKIT_URL
- LIVEKIT_API_KEY
- LIVEKIT_API_SECRET
- OPENAI_API_KEY
- DEEPGRAM_API_KEY
- AWS_S3_BUCKET
- AWS_REGION
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- TWILIO_ACCOUNT_SID
- TWILIO_AUTH_TOKEN
- TWILIO_PHONE_NUMBER
- LIVEKIT_SIP_URI

Risk: High — these are direct pointers to secrets required for runtime. Ensure `.env` is never committed and values are stored in a secrets manager.
Remediation:
- Use cloud provider Secret Manager (GCP Secret Manager or AWS Secrets Manager) or GitHub Actions secrets.
- Reference secrets via environment injection at deploy time, not via checked-in files.
- Rotate any secrets that may have been committed previously.

2) `meet-backend/Dockerfile`
- ENV LIVEKIT_API_KEY=""
- ENV LIVEKIT_API_SECRET=""
- ENV OPENAI_API_KEY=""
- ENV DEEPGRAM_API_KEY=""
- ENV AWS_S3_BUCKET=""
- ENV AWS_REGION=""
- ENV AWS_ACCESS_KEY_ID=""
- ENV AWS_SECRET_ACCESS_KEY=""
- ENV TWILIO_ACCOUNT_SID=""
- ENV TWILIO_AUTH_TOKEN=""
- ENV TWILIO_PHONE_NUMBER=""
- ENV LIVEKIT_SIP_URI=""

Risk: Medium — Dockerfile exposes env var names (fine) but avoid hardcoding values here. Ensure build-time args and environment injection are used safely.
Remediation:
- Do not bake secrets into images. Use runtime env injection or secrets mounted at runtime.
- Use build args only for non-sensitive values.

3) `meet-v0/Dockerfile` and `meet-v0/Dockerfile` (prod/dev)
- ENV LIVEKIT_URL
- ENV LIVEKIT_API_KEY
- ENV LIVEKIT_API_SECRET
- ENV GOOGLE_API_KEY
- ENV AWS_REGION
- ENV AWS_ACCESS_KEY_ID
- ENV AWS_SECRET_ACCESS_KEY
- ENV OPENAI_API_KEY
- ENV TWILIO_ACCOUNT_SID
- ENV TWILIO_AUTH_TOKEN

Risk: Medium — same as backend Dockerfile notes.
Remediation: same as above.

4) `meet-backend/docker-compose.yml`
- env_file: .env (local development env)

Risk: Medium — dev env files commonly contain secrets; ensure `.env` is in `.gitignore` and never pushed.
Remediation:
- Keep `.env` local only and use `.env.example` in repo. Use a secrets manager in CI and production.

5) `meet-v0/docker-compose.yml`
- env_file: .env.local

Risk: Medium — same as above.
Remediation: Use local-only files and do not commit them.

6) `meet-v0/cloudbuild.yaml`
- Substitutions show `_AR_PROJECT_ID`, `_AR_REPOSITORY`, `_SERVICE_NAME`, `_DEPLOY_REGION` etc. No plaintext secrets found, but CI substitution mechanism may reference secrets in Cloud Build triggers.

Risk: Low/Medium — ensure Cloud Build triggers don't include plaintext secrets and that service account used by Cloud Build has minimal permissions.
Remediation:
- Use Cloud Build substitutions populated from Secret Manager or use service account with minimal scopes.

7) `meet-v0/.github/workflows/sync-to-production.yaml`
- Uses `${{ secrets.GITHUB_TOKEN }}` to push branches — GitHub-managed token (fine). Verify no other secrets exposed here.

Risk: Low — GitHub Actions uses `secrets` storage; verify other workflow files.

8) `meet-backend/demo/scripts/summarize_service_procedures.py`
- Loads `.env` and calls OpenAI with `os.environ.get("OPENAI_API_KEY")`.

Risk: Medium — code expects env var; ensure runtime provides secret via secure store.

9) Code references and use
- Multiple Python modules call `os.getenv(...)` for OPENAI_API_KEY and other env vars (example: transcriber.py uses `os.getenv("AWS_S3_BUCKET")` for S3 egress).
- This repository relies on runtime env vars; map all `os.getenv` and `process.env` calls to known secret names.

Automated list of distinct secret-like names found
- LIVEKIT_URL
- LIVEKIT_API_KEY
- LIVEKIT_API_SECRET
- OPENAI_API_KEY
- DEEPGRAM_API_KEY
- AWS_S3_BUCKET
- AWS_REGION
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- TWILIO_ACCOUNT_SID
- TWILIO_AUTH_TOKEN
- TWILIO_PHONE_NUMBER
- LIVEKIT_SIP_URI
- GOOGLE_API_KEY
- NEXT_PUBLIC_PHONE_NUMBER
- PROD_URL
- GITHUB_TOKEN

Remediation checklist (priority)
1. Immediate (within 1 week)
   - Verify no secrets committed in git history. If any, rotate them and perform a git history purge (git filter-repo) or rotate affected secrets.
   - Configure Secret Manager (GCP Secret Manager / AWS Secrets Manager) and move all production secrets into it.
   - Ensure `.env` and `.env.local` are in `.gitignore`. Confirm by scanning repo for `.env` files.
2. Short term (2–4 weeks)
   - Update deployment pipelines to inject secrets from Secret Manager rather than hardcoded env files.
   - Restrict access to CI/CD service accounts and rotate keys.
   - Implement automated scanning (pre-commit hooks or CI step) to detect accidental secret commits (git-secrets, truffleHog, detect-secrets).
3. Medium (1–3 months)
   - Implement least-privilege IAM for service accounts and regular access reviews.
   - Enable audit logging for Secret Manager and cloud IAM actions.
4. Long term (ongoing)
   - Implement centralized secrets lifecycle management with rotation policies, automated rotation where possible, and strong access controls.

Next steps I can take
- Produce `compliance/secrets_map.md` with the full list and suggested templates to fetch secrets from GCP/AWS depending on your chosen cloud.
- Run a targeted grep to list exact lines and file paths for each `os.getenv` / `process.env` occurrence and put them into a CSV for remediation tracking.
- Scan git history for accidental secret commits (requires more invasive operations and approval).

I will now mark the `Generate secrets map` todo as completed and add the file to the repo. If you want the CSV or git-history scan, tell me and I'll run it.

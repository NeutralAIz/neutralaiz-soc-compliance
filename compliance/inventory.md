Inventory — environment & scope (initial)

Purpose
This is an initial inventory for SOC 1 scoping based on a repo scan. It covers both `meet-v0` (frontend) and `meet-backend` (backend agent). Use this as the canonical inventory draft to refine with architecture diagrams and cloud account role lists.

Summary of components

1) Frontend: `meet-v0`
- Type: Next.js web application (Node 20, pnpm). See `meet-v0/package.json`.
- Docker: multi-stage Dockerfile at `meet-v0/Dockerfile` (dev/prod targets).
- Build/Deploy: `meet-v0/cloudbuild.yaml` targets Google Cloud Build and deploys to Cloud Run (service name: `meet-v0`, region: northamerica-northeast2).
- Runtime envs (observed in Dockerfile and compose): LIVEKIT_URL, LIVEKIT_API_KEY, LIVEKIT_API_SECRET, GOOGLE_API_KEY, AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, PROD_URL, NEXT_PUBLIC_PHONE_NUMBER, TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, OPENAI_API_KEY, etc.
- CI / workflows: `.github/workflows/test.yaml` and `sync-to-production.yaml` exist — check workflow configs for secrets used and triggers.
- Logging libs: `@datadog/browser-logs`, `winston`, `winston-daily-rotate-file` appear in `package.json`.
- Local env files referenced: `.env.local` in `docker-compose.yml`.
- Notable third-party integrations (from deps/envs): LiveKit, AWS (S3, maybe KMS), Datadog, Twilio, OpenAI.

Repo files pointing to frontend deployment/CI
- `meet-v0/cloudbuild.yaml` (Cloud Run + container registry substitutions)
- `meet-v0/Dockerfile`
- `meet-v0/package.json`
- `meet-v0/docker-compose.yml`
- `meet-v0/.github/workflows/*.yaml`


2) Backend: `meet-backend`
- Type: Python agent/transcriber and supporting demo/services. See `meet-backend/demo/transcriber.py` and `meet-backend/Dockerfile`.
- Docker: `meet-backend/Dockerfile` (python:3.10 base image) and `meet-backend/docker-compose.yml` for local run.
- Runtime envs (observed in Dockerfile): LIVEKIT_API_KEY, LIVEKIT_API_SECRET, OPENAI_API_KEY, DEEPGRAM_API_KEY, AWS_S3_BUCKET, AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, LIVEKIT_SIP_URI, etc.
- Logging: docker-compose uses `json-file` logging driver; application likely logs to stdout (check `demo/*` for log config).
- Requirements: `meet-backend/requirements.txt`.
- Data: `meet-backend/demo/data/` includes YAML/JSON payloads; `service_procedures/` contains PDFs used by demo. No explicit DB config found in repo; likely uses object storage (S3) and external APIs.

Repo files pointing to backend deployment/runtime
- `meet-backend/Dockerfile`
- `meet-backend/docker-compose.yml`
- `meet-backend/requirements.txt`
- `meet-backend/demo/` (transcriber, handlers, models)


3) Infrastructure & IaC
- No Terraform/CloudFormation/ARM templates detected in repo scan (no `*.tf` or cloudformation stacks found).
- Deploy pipeline for frontend uses Google Cloud Build -> Cloud Run per `cloudbuild.yaml`.
- Container images likely stored in Artifact Registry (see `_AR_HOSTNAME` substitutions in `cloudbuild.yaml`).
- No explicit managed database or VPC configs in repo. Check cloud console for hosted services.


4) Secrets and env management
- Env vars are used heavily in both apps and referenced via `.env` / `.env.local` and Dockerfile ENV placeholders.
- No secrets manager IaC observed. Plan to map where secrets live (GitHub Actions secrets, GCP Secret Manager, AWS Secrets Manager, or environment variables in Cloud Run).
- Action: inventory all secret locations across cloud accounts and CI providers.


5) Logging, monitoring, alerts
- Frontend: Datadog Browser Logs SDK referenced. Backend: no hosted SIEM found in code; docker json-file driver for local logs.
- CI build uses Cloud Logging only per `cloudbuild.yaml` (option `logging: CLOUD_LOGGING_ONLY`).
- Action: identify where logs are aggregated (Cloud Logging, Datadog, ELK) and retention policies.


6) Backups and persistence
- No DB or backup configs were found in the repo; S3 bucket env indicates object storage usage.
- Action: determine persisted systems in cloud accounts (buckets, DB instances) and current backup/retention settings.


7) Third-party / subservice providers
- LiveKit (RTC), OpenAI, Deepgram, Twilio, AWS (S3), Datadog, Google Cloud Build / Cloud Run. These are subservice providers for which the auditor may request SOC/ISO reports or compensating controls.
- Action: collect vendor contracts and SOC/ISO reports where available.


8) Users, roles, and access
- No IAM manifests in-repo. Action: request lists of cloud console admin/service accounts, GitHub org admins, and CI/CD service accounts. Identify privileged personnel.


Evidence pointers (files in repo that are useful now)
- `compliance/` — plan, policies, TODO (this directory)
- `meet-v0/cloudbuild.yaml` — frontend deployment pipeline
- `meet-v0/Dockerfile`, `meet-v0/docker-compose.yml`, `meet-v0/package.json` — frontend runtime and deps
- `meet-backend/Dockerfile`, `meet-backend/docker-compose.yml`, `meet-backend/requirements.txt`, `meet-backend/demo/` — backend runtime and deps
- `.github/workflows/*.yaml` — CI workflows for tests and sync actions


Assumptions & notes
- This inventory is repository-driven; it does not query cloud accounts, CI settings, or secrets stores. It assumes deployment artifacts referenced in repo reflect actual production systems.
- Some infra (databases, VPC, logging aggregation) is likely configured in cloud providers and not present in repo; those must be inventoried by account access or by the team.


Immediate next actions (to complete scoping)
1. Produce architecture diagram(s) showing: frontend Cloud Run service, backend agent hosts/containers, data flows to third parties (LiveKit, OpenAI, Twilio, S3), and storage locations for logs/backups.
2. Inventory cloud accounts and list: projects/accounts for GCP (Cloud Run), AWS account(s) for S3/KMS, GitHub org and Actions secrets, and any other provider consoles.
3. Extract all environment variable usage and secret references (search repo for common secret/env names) and build a secrets location map.
4. Identify owners for each component (Engineering, Ops, Product) and collect a list of privileged users and service accounts.


How I validated
- Scanned repo for Dockerfiles, docker-compose, CI config, `package.json`, `requirements.txt`, and `cloudbuild.yaml` to extract runtime dependencies and env usage.


Done here
- Created initial inventory draft in `compliance/inventory.md`. Please review and edit to fill missing cloud-account details and owners.


Next step I can take
- Generate an architecture diagram (mermaid or draw.io) and add it to `compliance/architecture.md`.
- Or run an automated scan for env var/secret references and produce `compliance/secrets_map.md` (I can run targeted grep commands if you want).

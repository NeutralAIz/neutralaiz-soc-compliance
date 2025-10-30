Architecture diagram — initial (Mermaid)

This diagram represents the high-level architecture for `meet-v0` (frontend) and `meet-backend` (backend agent), their deployments, and integrations. Edit as needed to match real cloud topology.

Mermaid diagram

```mermaid
flowchart LR
  subgraph Frontend
    FE[Next.js app<br/>(meet-v0) - Cloud Run]
    FE -->|API calls / Webhooks| BEAPI[Backend API or Agent Endpoint]
    FE -->|Realtime| LiveKit[LiveKit (RTC)]
    FE -->|Telemetry| Datadog[Datadog / Browser Logs]
  end

  subgraph Backend
    BE[Transcriber Agent<br/>(meet-backend) - Container]
    BE -->|S3/Storage| S3[AWS S3 / Object Storage]
    BE -->|Realtime| LiveKit
    BE -->|Speech->LLM| OpenAI[OpenAI] & Deepgram[Deepgram]
    BE -->|SMS/Telephony| Twilio[Twilio]
    BE -->|Logs| CloudLogging[Cloud Logging / Datadog]
  end

  subgraph CI/CD
    GitHub[GitHub Actions]
    CloudBuild[Cloud Build]
    GitHub -->|Push/PR| CloudBuild
    CloudBuild -->|Build & Push| ArtifactRegistry[Artifact Registry]
    ArtifactRegistry -->|Deploy| CloudRun[Cloud Run]
  end

  FE --- CloudRun
  CloudRun -->|Env/Secrets| SecretManager[GCP Secret Manager / KMS]
  BEAPI -->|Secrets| SecretManager
  S3 -->|Backups| BackupStorage[Backups (multi-region)]

  subgraph Monitoring
    CloudLogging -->|Forward| SIEM[SIEM / Datadog / Splunk]
    SIEM -->|Alerts| PagerDuty[PagerDuty / Ops Alerts]
  end

  LiveKit ---|external| Internet
  OpenAI ---|external| Internet
  Deepgram ---|external| Internet
  Twilio ---|external| Internet

  style Frontend fill:#f9f,stroke:#333,stroke-width:1px
  style Backend fill:#ff9,stroke:#333,stroke-width:1px
  style CI/CD fill:#9ff,stroke:#333,stroke-width:1px
  style Monitoring fill:#f99,stroke:#333,stroke-width:1px
```

Notes
- Cloud Run is used for `meet-v0` per `cloudbuild.yaml`.
- Backend agent runs as a container (Dockerfile) — deployment target unspecified; could run on Cloud Run, GKE, or EC2-like hosts.
- Secrets should be stored in a secrets manager (GCP Secret Manager or AWS Secrets Manager/KMS) and not in repo or env files.
- Logging should be centralized (Cloud Logging -> SIEM/Datadog) and retained per policy.

Next steps
- Replace placeholder nodes with actual project/account IDs and service names.
- Add network boundaries (VPC, firewall) and data classification markers for sensitive flows.
- Export PNG/SVG of this diagram for auditor pack if desired.

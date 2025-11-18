#!/usr/bin/env bash
# Export Cloud Run service environment variable configuration
# Usage:
#  export PROJECT_ID=my-gcp-project
#  export SERVICE_NAME=meet-v0
#  export OUTPUT_DIR=./compliance/evidence/outputs/cloudrun
#  ./compliance/scripts/collect_cloudrun_envs.sh

set -euo pipefail

PROJECT_ID=${PROJECT_ID:-}
SERVICE_NAME=${SERVICE_NAME:-}
OUTPUT_DIR=${OUTPUT_DIR:-./compliance/evidence/outputs/cloudrun}

if [ -z "$PROJECT_ID" ] || [ -z "$SERVICE_NAME" ]; then
  echo "ERROR: PROJECT_ID and SERVICE_NAME must be set."
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H%M%SZ")

# Describe the service

gcloud run services describe "$SERVICE_NAME" --project="$PROJECT_ID" --region=all --format=json > "$OUTPUT_DIR/cloudrun_${SERVICE_NAME}_desc_$TIMESTAMP.json" || true

# Also export IAM policy for the service

gcloud run services get-iam-policy "$SERVICE_NAME" --project="$PROJECT_ID" --format=json > "$OUTPUT_DIR/cloudrun_${SERVICE_NAME}_iam_$TIMESTAMP.json" || true


echo "Cloud Run service export complete. Upload outputs to secure evidence store and reference them in compliance/evidence/evidence_index.json"

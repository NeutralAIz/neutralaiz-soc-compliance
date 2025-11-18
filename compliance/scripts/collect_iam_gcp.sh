#!/usr/bin/env bash
# Collect GCP IAM snapshots and related information for auditor evidence
# Usage:
#  export PROJECT_ID=my-gcp-project
#  export OUTPUT_DIR=./compliance/evidence/outputs
#  ./compliance/scripts/collect_iam_gcp.sh

set -euo pipefail

PROJECT_ID=${PROJECT_ID:-}
OUTPUT_DIR=${OUTPUT_DIR:-./compliance/evidence/outputs/gcp}

if [ -z "$PROJECT_ID" ]; then
  echo "ERROR: PROJECT_ID is not set. Export PROJECT_ID before running."
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H%M%SZ")

echo "Exporting IAM policy for project $PROJECT_ID"
gcloud projects get-iam-policy "$PROJECT_ID" --format=json > "$OUTPUT_DIR/iam_policy_${PROJECT_ID}_${TIMESTAMP}.json"

echo "Listing service accounts"
gcloud iam service-accounts list --project="$PROJECT_ID" --format=json > "$OUTPUT_DIR/service_accounts_${PROJECT_ID}_${TIMESTAMP}.json"

echo "Listing roles (custom and predefined)"
gcloud iam roles list --project="$PROJECT_ID" --format=json > "$OUTPUT_DIR/roles_project_${PROJECT_ID}_${TIMESTAMP}.json" || true

echo "Listing enabled APIs"
gcloud services list --project="$PROJECT_ID" --format=json > "$OUTPUT_DIR/enabled_apis_${PROJECT_ID}_${TIMESTAMP}.json"

echo "GCP IAM snapshot completed. Outputs in $OUTPUT_DIR"

echo "NOTE: Upload outputs to secure evidence store (GCS bucket with restricted access) and add URIs to compliance/evidence/evidence_index.json"

#!/usr/bin/env bash
# Export Cloud Build logs for a given build or time range
# Requires gcloud installed and authenticated with access to Cloud Logging
# Usage:
#  export PROJECT_ID=meet-frontend
#  export OUTPUT_DIR=./compliance/evidence/outputs/cloudbuild
#  ./compliance/scripts/collect_cloudbuild_logs.sh 2025-10-01T00:00:00Z 2025-10-30T23:59:59Z

set -euo pipefail

PROJECT_ID=${PROJECT_ID:-}
OUTPUT_DIR=${OUTPUT_DIR:-./compliance/evidence/outputs/cloudbuild}
START_TIME=${1:-}
END_TIME=${2:-}

if [ -z "$PROJECT_ID" ]; then
  echo "ERROR: PROJECT_ID is not set. Export PROJECT_ID before running."
  exit 2
fi

if [ -z "$START_TIME" ] || [ -z "$END_TIME" ]; then
  echo "Usage: $0 <START_TIME> <END_TIME>"
  echo "Example: $0 2025-10-01T00:00:00Z 2025-10-30T23:59:59Z"
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H%M%SZ")

FILTER="resource.type=cloud_build_build AND timestamp>\"$START_TIME\" AND timestamp<\"$END_TIME\""

echo "Exporting Cloud Build logs for $PROJECT_ID from $START_TIME to $END_TIME"
gcloud logging read "$FILTER" --project="$PROJECT_ID" --format=json > "$OUTPUT_DIR/cloudbuild_logs_${START_TIME}_${END_TIME}_$TIMESTAMP.json"

echo "Cloud Build logs exported to $OUTPUT_DIR"

echo "Note: upload to secure evidence store and add reference to compliance/evidence/evidence_index.json"

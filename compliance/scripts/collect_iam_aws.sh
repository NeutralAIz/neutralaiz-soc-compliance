#!/usr/bin/env bash
# Collect AWS IAM snapshots for auditor evidence
# Usage:
#  export AWS_PROFILE=your-profile
#  export OUTPUT_DIR=./compliance/evidence/outputs
#  ./compliance/scripts/collect_iam_aws.sh

set -euo pipefail

OUTPUT_DIR=${OUTPUT_DIR:-./compliance/evidence/outputs/aws}
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H%M%SZ")

echo "Listing IAM users"
aws iam list-users --output json > "$OUTPUT_DIR/iam_users_$TIMESTAMP.json"

echo "Listing IAM roles"
aws iam list-roles --output json > "$OUTPUT_DIR/iam_roles_$TIMESTAMP.json"

echo "Listing policies"
aws iam list-policies --scope Local --output json > "$OUTPUT_DIR/iam_policies_local_$TIMESTAMP.json" || true
aws iam list-policies --scope All --output json > "$OUTPUT_DIR/iam_policies_all_$TIMESTAMP.json" || true

echo "Getting account alias"
aws iam list-account-aliases --output json > "$OUTPUT_DIR/account_alias_$TIMESTAMP.json"

echo "AWS IAM snapshot completed. Upload outputs to secure evidence store and reference them in compliance/evidence/evidence_index.json"

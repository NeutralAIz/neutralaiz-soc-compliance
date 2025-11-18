#!/usr/bin/env bash
# Zip each subfolder in compliance/evidence/outputs, upload to S3 with server-side encryption (AES256),
# and print presigned URLs for each uploaded zip. Requires AWS CLI configured locally.
# Usage:
#  export S3_BUCKET=neutralaiz-soc-compliance
#  export EXPIRATION_SECONDS=604800  # default 7 days
#  ./compliance/scripts/upload_and_presign_s3.sh

set -euo pipefail

S3_BUCKET=${S3_BUCKET:-}
EXPIRATION_SECONDS=${EXPIRATION_SECONDS:-604800}
EVID_DIR=${EVID_DIR:-./compliance/evidence/outputs}
MANIFEST=${MANIFEST:-./compliance/evidence/presigned_manifest.json}

if [ -z "$S3_BUCKET" ]; then
  echo "ERROR: Set S3_BUCKET env var e.g. export S3_BUCKET=neutralaiz-soc-compliance"
  exit 2
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: aws CLI not found. Install and configure it before running."
  exit 2
fi

rm -f "$MANIFEST"
echo "[]" > "$MANIFEST"

for dir in "$EVID_DIR"/*/; do
  [ -d "$dir" ] || continue
  folder_name=$(basename "$dir")
  ts=$(date -u +"%Y%m%dT%H%M%SZ")
  zipname="${folder_name}_${ts}.zip"
  tmpzip="/tmp/$zipname"

  echo "Zipping $dir -> $tmpzip"
  (cd "$dir" && zip -r "$tmpzip" .) >/dev/null 2>&1

  s3key="evidence/$folder_name/$zipname"
  echo "Uploading s3://$S3_BUCKET/$s3key"
  aws s3 cp "$tmpzip" "s3://$S3_BUCKET/$s3key" --sse AES256

  echo "Generating presigned URL (expires in $EXPIRATION_SECONDS seconds)"
  url=$(aws s3 presign "s3://$S3_BUCKET/$s3key" --expires-in "$EXPIRATION_SECONDS")

  jq --arg id "EVID-$(date +%s)" \
     --arg path "s3://$S3_BUCKET/$s3key" \
     --arg url "$url" \
     --arg note "Uploaded by upload_and_presign_s3.sh" \
     '. += [{id:$id, path:$path, presigned_url:$url, timestamp:now|todate, note:$note}]' \
     "$MANIFEST" > "$MANIFEST.tmp" && mv "$MANIFEST.tmp" "$MANIFEST"

  rm -f "$tmpzip"
  echo "Uploaded and presigned: $url"
done

echo "All done. Manifest at $MANIFEST"

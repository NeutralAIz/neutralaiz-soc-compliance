#!/usr/bin/env bash
# Export GitHub PR metadata for a repository using GitHub CLI (gh)
# Usage:
#  gh auth login
#  export OUTPUT_DIR=./compliance/evidence/outputs/github
#  ./compliance/scripts/collect_github_prs.sh owner/repo

set -euo pipefail

REPO=${1:-}
OUTPUT_DIR=${OUTPUT_DIR:-./compliance/evidence/outputs/github}

if [ -z "$REPO" ]; then
  echo "Usage: $0 owner/repo"
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H%M%SZ")

echo "Exporting PRs for $REPO"
gh pr list --repo "$REPO" --json number,title,author,createdAt,mergedAt,mergeCommit --limit 1000 > "$OUTPUT_DIR/pr_list_$TIMESTAMP.json"

echo "For each PR, you may also export timeline events or reviews"

# Example: export reviews for the most recent 100 PRs
PR_NUMBERS=$(jq -r '.[].number' "$OUTPUT_DIR/pr_list_$TIMESTAMP.json" | head -n 100)
for num in $PR_NUMBERS; do
  echo "Exporting reviews for PR #$num"
  gh pr view --repo "$REPO" "$num" --json reviews,commits,files,mergeCommit,timelineItems --jq '.' > "$OUTPUT_DIR/pr_${num}_details_$TIMESTAMP.json" || true
done


echo "GitHub PR export complete. Upload outputs to secure evidence store and reference them in compliance/evidence/evidence_index.json"

Remediation tracker — how to use

Location: `compliance/remediation_tracker.csv`

Purpose
This tracker maps identified gaps from `compliance/gap_analysis.md` to remediation tasks that can be turned into tickets. Each row includes a suggested owner and ETA (weeks). Adjust owners and ETAs to match your team's capacity.

Suggested workflow
1. Convert each CSV row into a ticket in your issue tracker (GitHub Issues, Jira, etc.).
2. Assign the suggested owner and set priority according to the CSV. Adjust ETA as needed.
3. When a remediation is complete, update the `status` column and add links to evidence in `compliance/evidence/evidence_index.json`.

Quick notes
- For high-priority items (Access, Secrets, Logging, Backup), aim to complete initial remediation within the first 6 weeks.
- Use `compliance/evidence/` to store pointers to exported evidence (do not commit raw secrets).

Next steps I can take
- Create starter issue templates (GitHub/GitLab/Jira) for each remediation row with a checklist and evidence fields.
- Implement automated scripts to collect evidence (IAM snapshot, Cloud Build log exporter, backup verification script).

If you'd like, I'll convert these CSV rows into GitHub Issues and fill in assignees. Authorize me to create issues or provide the preferred issue tracker and I will proceed.

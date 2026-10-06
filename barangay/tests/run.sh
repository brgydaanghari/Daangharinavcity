#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
find "$ROOT" -name '*.php' -not -path '*/vendor/*' -print0 | xargs -0 -n1 php -l >/dev/null
for file in database.sql login.php verify_otp.php staff_accounts.php audit.php notifications.php privacy.php privacy_admin.php issue_document.php verify.php backup.php backup_cron.php; do test -s "$ROOT/$file"; done
grep -q 'CREATE TABLE IF NOT EXISTS audit_logs' "$ROOT/database.sql"
grep -q 'CREATE TABLE IF NOT EXISTS login_challenges' "$ROOT/database.sql"
grep -q 'CREATE TABLE IF NOT EXISTS document_verifications' "$ROOT/database.sql"
grep -q 'No residents, staff' "$ROOT/retention.php"
echo "Barangay capstone smoke tests passed"

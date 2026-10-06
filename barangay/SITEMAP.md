# Barangay Information System — Sitemap

## 1. Access and authentication

- `setup.php` — first-run administrator setup
- `login.php` — username and password login
- `verify_otp.php` — six-digit Gmail OTP verification
- `logout.php` — sign out and clear the session

## 2. Resident portal

- `resident_portal.php?tab=documents`
  - Request a barangay document
  - Track request status
  - View the official document number after issuance
- `resident_portal.php?tab=report`
  - Report incident, blotter, road issue, power outage, water interruption, garbage collection, noise disturbance, public safety, or other concern
  - Identify the **person involved or affected**
  - Track the case number and status
- `resident_portal.php?tab=feedback`
  - Submit service feedback and rating
  - View previous feedback
- `resident_portal.php?tab=announcements`
  - View the latest published barangay announcements
- `resident_accounts.php` — staff-managed resident account expiration, suspension, and move-out handling

## 3. Staff and administrator portal

- `index.php` — official dashboard
- `residents.php` — resident directory and profile updates
- `documents.php` — document issuance queue
  - Staff can open `print_document.php?id=...` to print a request processing copy
  - Staff can update status to Pending, For review, On hold, or Issued
- `blotters.php` — blotter and incident records
- `feedback.php` — review resident feedback
- `reports.php` — analytics dashboard with charts and itemized registers
- `report_export.php?format=pdf|csv|word` — report exports
- `announcements.php` — publish and manage barangay announcements

## 4. Governance and security

- `retention.php` — data retention periods and archive-only maintenance
  - Resident and staff identity records are never deleted
  - Expired resident accounts can be marked Archived
  - Closed operational records remain protected
- `backup.php` — local SQL backup generation and backup history
- `config/mail.php` — Gmail SMTP configuration
- `includes/mailer.php` — PHPMailer helper for OTP and notifications
- `vendor/phpmailer/src/` — bundled PHPMailer library

## Core workflows

### Resident document request

`Resident Documents tab → documents.php queue → Staff Print → Status Issued → Official document number → Resident tracking + email notification`

### Resident issue report

`Resident Report an issue tab → blotters.php → Staff status update → Resident case tracking + email notification`

### Secure sign-in

`login.php password check → Gmail OTP email → verify_otp.php → Resident portal or Official dashboard`

### Retention and continuity

`retention.php policy review → Archive eligible expired accounts → Keep resident/staff records → backup.php for SQL backup`

## Diagram

See the Mermaid source in [`sitemap.mmd`](./sitemap.mmd) and the rendered PNG in [`sitemap.png`](./sitemap.png).

## 5. Extended capstone controls

- `staff_accounts.php` — administrator-managed staff roles: admin, staff, records officer, blotter officer, and treasurer
- `audit.php` — protected activity log
- `notifications.php` — in-app notification inbox
- `privacy.php` — resident/staff privacy notice and data-subject requests
- `privacy_admin.php` — staff review of privacy requests
- `issue_document.php?id=...` — type-specific official document printout with verification URL/QR
- `verify.php?document=...` — public official-document verification
- `assets/attachments/` — validated JPG, PNG, and PDF evidence storage
- `backup.php` — encrypted or plain SQL backup download with backup policy and audit history

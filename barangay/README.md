# Barangay Information System — PHP / XAMPP Capstone Starter

This folder is a working PHP + MySQL/MariaDB version of the Barangay Information System. It is designed to run on **localhost** with XAMPP Apache and MySQL.

## Requirements

- XAMPP with Apache, MySQL, and PHP 8.0+
- A browser

## Installation on localhost

1. Copy the application folder into `C:\xampp\htdocs\barangay`. In the clean ZIP package, the folder is already named `barangay`, so extracting the ZIP directly into `C:\xampp\htdocs` gives the correct path.
2. Start **Apache** and **MySQL** in the XAMPP Control Panel.
3. Open `http://localhost/phpmyadmin`.
4. Create/import the database by opening the **Import** tab and selecting `database.sql` from this folder. For an older prototype database, export it first if needed, then create a fresh `barangay_db` because this version adds account and retention columns/tables.
5. Confirm that `http://localhost/barangay/setup.php` loads. If it says the database is not ready, MySQL is not running or `database.sql` has not been imported yet.
6. Open `http://localhost/barangay/login.php`.
7. Because there is intentionally **no seed account**, the first visit redirects to `setup.php`. Create the first administrator there.
8. Sign in using the administrator account you created.

The connection settings are in `config/database.php`. The XAMPP default is user `root` with a blank password. If your MySQL installation uses a password, update `DB_PASS` there.

## Working modules

- First-run administrator creation; no default account or default password is shipped
- Login/logout session flow with active, suspended, and expired account checks
- Resident CRUD: create, search, edit, and delete
- Resident portal accounts linked to resident records
- Resident portal document requests with request tracking
- Resident portal incident reporting with case tracking
- Resident feedback submission with rating and official review status
- Official feedback review queue for staff and administrators
- Resident account expiration dates; expired accounts cannot sign in
- Move-out control that expires the account and changes the resident status to `Moved out`
- Document issuance: create requests and update status to Pending, Issued, On hold, or For review
- Unique official document numbers are generated when a request is issued, in the format `BRGY-DOC-YYYY-######`
- Blotter management: record incidents and update case status
- Resident report categories: incident, blotter, road issue, power outage, water interruption, garbage collection, noise disturbance, public safety, and other concern
- Resident announcement tab with the latest published barangay updates
- Reports and analytics with bar graphs, status graphs, itemized registers, designated signatory, and report metadata
- Report export formats: PDF, CSV, and Word-compatible `.doc`
- Data retention settings for expired resident accounts, closed records, and backup history
- Non-destructive retention policy: resident and staff identity records are never deleted; expired accounts are disabled and may only be marked `Archived`
- Resident directory delete actions are greyed out; retention actions never delete residents, staff, documents, reports, feedback, or backups
- Downloadable SQL backup generated from the local database plus backup history
- PDO prepared statements, escaping helpers, sessions, CSRF tokens, and flash messages
- Responsive blue civic-service UI for desktop and mobile
- PHPMailer + Gmail SMTP two-step login using a six-digit email OTP
- Gmail notifications for new resident accounts, resident document requests, incident reports, and issued documents
- Staff document queue includes a protected **Print** action that opens an official processing copy with request number, document details, requester, fee, status, and signature lines
- Resident portal is separated into **Documents**, **Report an issue**, **Feedback**, and **Announcements** tabs
- Issue reports identify the respondent as the person, office, provider, or group involved or affected

## Resident account lifecycle

An administrator creates a resident portal account from **Resident accounts**, assigns an expiration date, and can suspend it at any time. When a resident moves out or transfers to another barangay, use **Move out**. The system sets the resident status to `Moved out`, records the move-out time, expires portal access, and keeps the historical resident record until the retention policy is executed.

## Gmail SMTP and PHPMailer setup

The package includes PHPMailer under `vendor/phpmailer/src`, so Composer is not required. Gmail requires **2-Step Verification** and a **Google App Password**; do not use the normal Gmail password. Copy `.env.example` to a secure local reference and configure the following values as Apache/PHP environment variables or in `config/mail.php` for a private local capstone installation: `MAIL_USERNAME`, `MAIL_APP_PASSWORD`, `MAIL_FROM_EMAIL`, `MAIL_FROM_NAME`, `MAIL_HOST`, `MAIL_PORT`, and `MAIL_ENCRYPTION`.

The first administrator must have a valid email address. Each resident portal account also requires a valid email address. Login first validates the password, then sends a six-digit OTP that expires after 10 minutes and allows five attempts. Notifications are sent when a resident account is created, a resident submits a document request or report, and a document is issued. Never commit the Gmail app password to Git or upload it in the ZIP.

## Data retention and backup

Open **Retention** to configure how many days expired resident accounts and closed records remain under review. The maintenance action is archive-only: it marks eligible expired resident accounts as `Archived` while preserving their identity and service history. Resident delete controls are greyed out. Open **Backups** to download a timestamped `.sql` file. Store downloaded backups outside `htdocs` or on a separate drive. For recovery, create a fresh database in phpMyAdmin and import the downloaded SQL file.

## Capstone demonstration flow

Create the first administrator, add a resident, create a resident portal account with an expiration date, sign in as that resident, submit a document request, report an incident, track both records, and send feedback. Sign in as the official user to review the feedback, then move the resident out and confirm that resident login is blocked. Download an encrypted backup, adjust retention settings, and demonstrate the archive-only workflow without deleting any identity or service records.

## Extended capstone modules

The package now includes administrator-managed staff roles, protected staff identities, an audit-log viewer, in-app notifications, a privacy request workflow, validated JPG/PNG/PDF attachments for resident requests and issue reports, type-specific official document printing, public document verification, and encrypted backup downloads. Manual payment processing remains outside the system as requested; fees are recorded for staff reference only.

Before using encrypted backups, set `BACKUP_ENCRYPTION_KEY` in the Apache/PHP environment and store it separately from the backup files. The public verification page is `verify.php?document=BRGY-DOC-YYYY-######`. Official staff roles are `admin`, `staff`, `records_officer`, `blotter_officer`, and `treasurer`, with role-based page access.

## Final deployment checklist

For a new local deployment, extract the latest localhost ZIP into `C:\xampp\htdocs\barangay`, start Apache and MySQL, import `database.sql` into a fresh `barangay_db`, open `setup.php`, create the administrator with a real email address, and configure the Gmail SMTP App Password. Set `BACKUP_ENCRYPTION_KEY` outside the web root before using encrypted backups.

To restore a backup without deleting the live system, create a separate empty database in phpMyAdmin, import the `.sql` backup into that database, and verify the records before switching the application database configuration. For `.sql.enc` backups, decrypt the file using the same `BACKUP_ENCRYPTION_KEY` before importing. The application intentionally does not provide a one-click destructive restore because resident and staff identity records are protected by policy.

For the remaining official operational decisions, the barangay should approve the retention periods, designate the records/privacy officer, confirm signatories and certificate wording, and document its manual payment and official-receipt procedure.

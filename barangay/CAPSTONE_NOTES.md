# Capstone implementation notes

This delivery is a working PHP/MySQL foundation rather than a hosted production deployment. It is intentionally easy to demonstrate in XAMPP: import one SQL file, start Apache/MySQL, and use the browser.

The current database-backed flows are authentication, dashboard metrics, resident CRUD, document request creation/status updates, and blotter case creation/status updates. Every write flow uses POST requests, PDO prepared statements, CSRF tokens, server-side sessions, and escaped HTML output.

For a formal capstone defense, demonstrate the following sequence: sign in as the administrator, create a resident, search and edit that resident, create a document request and change it to Issued, record a blotter incident and change its status, then refresh the dashboard to show the database-driven counts.

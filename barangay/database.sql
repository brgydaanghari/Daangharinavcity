CREATE DATABASE IF NOT EXISTS barangay_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE barangay_db;

CREATE TABLE IF NOT EXISTS residents (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  barangay_id VARCHAR(30) NOT NULL UNIQUE,
  full_name VARCHAR(120) NOT NULL,
  address VARCHAR(180) NOT NULL,
  age TINYINT UNSIGNED NOT NULL,
  sector VARCHAR(60) NOT NULL,
  household VARCHAR(120) NOT NULL,
  civil_status VARCHAR(30) NOT NULL DEFAULT 'Single',
  contact_number VARCHAR(30) DEFAULT NULL,
  status ENUM('Active','Pending','For review','Moved out','Archived') NOT NULL DEFAULT 'Active',
  moved_out_at DATETIME NULL,
  moved_to_barangay VARCHAR(160) DEFAULT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  resident_id INT UNSIGNED NULL,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(190) NOT NULL,
  username VARCHAR(100) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','staff','resident') NOT NULL DEFAULT 'staff',
  account_status ENUM('active','suspended','expired') NOT NULL DEFAULT 'active',
  account_expires_at DATE NULL,
  archived_at DATETIME NULL,
  last_login_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_resident FOREIGN KEY (resident_id) REFERENCES residents(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS login_challenges (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  code_hash VARCHAR(255) NOT NULL,
  expires_at DATETIME NOT NULL,
  attempts TINYINT UNSIGNED NOT NULL DEFAULT 0,
  used_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_login_challenge_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS document_requests (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  resident_id INT UNSIGNED NULL,
  request_no VARCHAR(30) NOT NULL UNIQUE,
  document_no VARCHAR(40) NULL UNIQUE,
  document_type VARCHAR(100) NOT NULL,
  requester_name VARCHAR(120) NOT NULL,
  purpose VARCHAR(180) NOT NULL,
  fee DECIMAL(10,2) NOT NULL DEFAULT 0,
  status ENUM('Pending','Issued','On hold','For review') NOT NULL DEFAULT 'Pending',
  requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  released_at DATETIME NULL,
  CONSTRAINT fk_document_resident FOREIGN KEY (resident_id) REFERENCES residents(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS blotters (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  resident_id INT UNSIGNED NULL,
  case_no VARCHAR(30) NOT NULL UNIQUE,
  report_type VARCHAR(100) NOT NULL DEFAULT 'Incident report',
  incident_type VARCHAR(100) NOT NULL,
  complainant VARCHAR(120) NOT NULL,
  respondent VARCHAR(120) NOT NULL,
  location VARCHAR(180) NOT NULL,
  incident_date DATETIME NOT NULL,
  narrative TEXT NOT NULL,
  status ENUM('Recorded','Pending','For review','Resolved') NOT NULL DEFAULT 'Recorded',
  priority ENUM('Normal','High') NOT NULL DEFAULT 'Normal',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_blotter_resident FOREIGN KEY (resident_id) REFERENCES residents(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS feedback (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  resident_id INT UNSIGNED NULL,
  category VARCHAR(80) NOT NULL,
  rating TINYINT UNSIGNED NULL,
  message TEXT NOT NULL,
  status ENUM('New','Reviewed','Resolved') NOT NULL DEFAULT 'New',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_feedback_resident FOREIGN KEY (resident_id) REFERENCES residents(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS retention_settings (
  id TINYINT UNSIGNED PRIMARY KEY,
  resident_account_days INT UNSIGNED NOT NULL DEFAULT 365,
  closed_record_days INT UNSIGNED NOT NULL DEFAULT 2555,
  backup_retention_days INT UNSIGNED NOT NULL DEFAULT 90,
  updated_by INT UNSIGNED NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS announcements (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(160) NOT NULL,
  body TEXT NOT NULL,
  category VARCHAR(60) NOT NULL DEFAULT 'Community',
  published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_published TINYINT(1) NOT NULL DEFAULT 1
);
INSERT INTO announcements (title, body, category, published_at, is_published) VALUES
('Barangay assembly this Saturday','Join us at the covered court on October 12 at 8:00 AM for the quarterly community assembly.','Community','2026-10-08 08:00:00',1),
('Free health screening schedule','The barangay health center will hold free blood pressure and blood sugar screening for residents 18+.','Health','2026-10-10 08:00:00',1),
('Typhoon preparedness reminder','Keep emergency kits ready and follow official advisories from the barangay DRRM desk.','Advisory','2026-10-04 08:00:00',1);
INSERT INTO retention_settings (id) VALUES (1) ON DUPLICATE KEY UPDATE id = id;

CREATE TABLE IF NOT EXISTS backup_logs (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  file_name VARCHAR(180) NOT NULL,
  created_by INT UNSIGNED NULL,
  file_size BIGINT UNSIGNED NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO residents (barangay_id, full_name, address, age, sector, household, civil_status, contact_number, status) VALUES
('BRG-240184','Maria Lourdes Santos','Purok 3 · Maharlika St.',42,'Women','Santos Household','Married','09171234567','Active'),
('BRG-240183','Juan Carlo Dela Cruz','Purok 1 · Rizal Ave.',36,'Worker','Dela Cruz Household','Married','09181234567','Active'),
('BRG-240182','Rosario Villanueva','Purok 5 · Mabini St.',67,'Senior citizen','Villanueva Household','Widowed','09191234567','Pending'),
('BRG-240181','Kevin Miguel Ramos','Purok 2 · Bonifacio St.',21,'Youth','Ramos Household','Single','09201234567','Active'),
('BRG-240180','Angela Mae Bautista','Purok 4 · Katipunan St.',29,'Women','Bautista Household','Single','09211234567','Active')
ON DUPLICATE KEY UPDATE full_name = VALUES(full_name);

INSERT INTO document_requests (request_no, document_type, requester_name, purpose, fee, status) VALUES
('DOC-2026-0042','Barangay clearance','Carla R. Mendoza','Local employment',50,'Pending'),
('DOC-2026-0041','Certificate of residency','Joel T. Mercado','School requirement',30,'Issued'),
('DOC-2026-0040','Certificate of indigency','Rosario Villanueva','Medical assistance',0,'On hold'),
('DOC-2026-0039','Business clearance','Dela Cruz Sari-Sari Store','Business renewal',100,'For review')
ON DUPLICATE KEY UPDATE document_type = VALUES(document_type);

INSERT INTO blotters (case_no, incident_type, complainant, respondent, location, incident_date, narrative, status, priority) VALUES
('BLT-2026-018','Noise disturbance','Rosario Villanueva','Unidentified neighbor','Purok 5 · Mabini St.','2026-10-08 10:42:00','Resident reported repeated loud music after quiet hours. Barangay tanods conducted an initial visit and requested a mediation schedule.','For review','Normal'),
('BLT-2026-017','Property boundary concern','Edgar Ocampo','Juan Santos','Purok 6 · Luna St.','2026-10-07 15:18:00','Parties requested barangay assistance in documenting a property boundary concern.','Recorded','High'),
('BLT-2026-016','Lost mobile phone','Kevin Miguel Ramos','N/A','Purok 2 · Bonifacio St.','2026-10-06 17:02:00','Resident reported a lost mobile phone and requested an incident record for reference.','Resolved','Normal')
ON DUPLICATE KEY UPDATE incident_type = VALUES(incident_type);

-- Capstone security and records extensions
CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NULL,
  action VARCHAR(80) NOT NULL,
  entity VARCHAR(80) NULL,
  entity_id BIGINT UNSIGNED NULL,
  details TEXT NULL,
  ip_address VARCHAR(45) NULL,
  user_agent VARCHAR(255) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_audit_created (created_at),
  CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS notifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  title VARCHAR(160) NOT NULL,
  message TEXT NOT NULL,
  link VARCHAR(255) NULL,
  read_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_notification_user (user_id,read_at),
  CONSTRAINT fk_notification_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS attachments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  uploaded_by INT UNSIGNED NULL,
  entity VARCHAR(80) NOT NULL,
  entity_id BIGINT UNSIGNED NOT NULL,
  original_name VARCHAR(255) NOT NULL,
  stored_path VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  file_size INT UNSIGNED NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_attachment_user FOREIGN KEY (uploaded_by) REFERENCES users(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS privacy_requests (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NULL,
  request_type ENUM('Access','Correction','Privacy question','Complaint') NOT NULL,
  details TEXT NOT NULL,
  status ENUM('Received','Under review','Resolved','Denied') NOT NULL DEFAULT 'Received',
  resolution TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_privacy_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS document_verifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  document_request_id INT UNSIGNED NOT NULL UNIQUE,
  verification_token CHAR(64) NOT NULL UNIQUE,
  revoked_at DATETIME NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_verification_document FOREIGN KEY (document_request_id) REFERENCES document_requests(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS backup_settings (
  id TINYINT UNSIGNED PRIMARY KEY,
  enabled TINYINT(1) NOT NULL DEFAULT 0,
  frequency ENUM('daily','weekly') NOT NULL DEFAULT 'daily',
  encrypted TINYINT(1) NOT NULL DEFAULT 1,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
INSERT INTO backup_settings (id,enabled,frequency,encrypted) VALUES (1,0,'daily',1) ON DUPLICATE KEY UPDATE id=id;
ALTER TABLE users MODIFY role ENUM('admin','staff','records_officer','blotter_officer','treasurer','resident') NOT NULL DEFAULT 'staff';
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(30) NULL;

<?php
require_once __DIR__ . '/functions.php';
require_once __DIR__ . '/../config/database.php';
function current_user(): ?array { return $_SESSION['user'] ?? null; }
function database_is_ready(): bool { try { db()->query('SELECT 1 FROM users LIMIT 1'); return true; } catch(Throwable $e) { return false; } }
function system_is_setup(): bool { return database_is_ready() && (int)db()->query('SELECT COUNT(*) FROM users')->fetchColumn()>0; }
function require_login(): void { if(!current_user()) redirect('login.php'); if(!empty($_SESSION['last_activity'])&&time()-(int)$_SESSION['last_activity']>1800){audit_action('session_timeout','users',(int)($_SESSION['user']['id']??0));session_destroy();redirect('login.php?timeout=1');}$_SESSION['last_activity']=time();$user=current_user();if(!empty($user['account_expires_at'])&&$user['account_expires_at']<date('Y-m-d')){$_SESSION['user']['account_status']='expired';session_destroy();redirect('login.php?expired=1');}if(($user['account_status']??'active')!=='active'){session_destroy();redirect('login.php?disabled=1');} }
function require_staff(): void { require_login(); if(current_user()['role']==='resident') redirect('resident_portal.php'); }
function require_permission(string $permission): void { require_login(); if(!user_can($permission)){http_response_code(403);exit('You do not have permission to access this page.');} }

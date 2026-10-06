<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    ini_set('session.cookie_httponly','1'); ini_set('session.cookie_samesite','Lax');
    if (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ini_set('session.cookie_secure','1');
    session_start();
}
function h(?string $value): string { return htmlspecialchars($value ?? '', ENT_QUOTES, 'UTF-8'); }
function redirect(string $path): never { header('Location: ' . $path); exit; }
function flash(string $type, string $message): void { $_SESSION['flash'] = ['type'=>$type,'message'=>$message]; }
function pull_flash(): ?array { $message=$_SESSION['flash']??null; unset($_SESSION['flash']); return $message; }
function csrf_token(): string { if(empty($_SESSION['csrf'])) $_SESSION['csrf']=bin2hex(random_bytes(32)); return $_SESSION['csrf']; }
function verify_csrf(): void { if(!hash_equals($_SESSION['csrf']??'',$_POST['csrf']??'')){http_response_code(419);exit('Invalid CSRF token. Please go back and try again.');} }
function old(string $key,string $default=''): string { return h($_POST[$key]??$default); }
function audit_action(string $action,string $entity='',?int $entityId=null,?string $details=null): void { try { $pdo=db();$u=$_SESSION['user']['id']??null;$pdo->prepare('INSERT INTO audit_logs (user_id,action,entity,entity_id,details,ip_address,user_agent) VALUES (?,?,?,?,?,?,?)')->execute([$u,$action,$entity,$entityId,$details,$_SERVER['REMOTE_ADDR']??null,substr($_SERVER['HTTP_USER_AGENT']??'',0,255)]); } catch(Throwable $e) { error_log('Audit log error: '.$e->getMessage()); } }
function notify_user(int $userId,string $title,string $message,string $link=''): void { try { db()->prepare('INSERT INTO notifications (user_id,title,message,link) VALUES (?,?,?,?)')->execute([$userId,$title,$message,$link]); } catch(Throwable $e) { error_log('Notification error: '.$e->getMessage()); } }
function notify_staff(string $title,string $message,string $link=''): void { try { $rows=db()->query("SELECT id FROM users WHERE role<>'resident' AND account_status='active'")->fetchAll(PDO::FETCH_COLUMN); foreach($rows as $id) notify_user((int)$id,$title,$message,$link); } catch(Throwable $e) { error_log('Staff notification error: '.$e->getMessage()); } }
function user_can(string $permission): bool { $role=$_SESSION['user']['role']??''; $map=['admin'=>['*'],'staff'=>['dashboard','residents','documents','blotters','feedback','reports','announcements','print','notifications','privacy_admin'],'records_officer'=>['dashboard','residents','documents','reports','announcements','notifications','print'],'blotter_officer'=>['dashboard','blotters','reports','notifications'],'treasurer'=>['dashboard','documents','reports','notifications'],'resident'=>['portal','announcements','privacy','notifications']]; return in_array('*',$map[$role]??[],true)||in_array($permission,$map[$role]??[],true); }
function rate_limit(string $key,int $max=8,int $window=900): bool { $now=time();$data=$_SESSION['rate_limits'][$key]??['start'=>$now,'count'=>0];if($now-$data['start']>$window)$data=['start'=>$now,'count'=>0];$data['count']++;$_SESSION['rate_limits'][$key]=$data;return $data['count']<=$max; }
function secure_upload(array $file,string $folder='uploads'): ?string { if(($file['error']??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_OK)return null;if(($file['size']??0)>5*1024*1024)return null;$allowed=['image/jpeg'=>'jpg','image/png'=>'png','application/pdf'=>'pdf'];$mime=(new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);if(!isset($allowed[$mime]))return null;$base=__DIR__.'/../assets/'.$folder;if(!is_dir($base))mkdir($base,0750,true);$name=bin2hex(random_bytes(16)).'.'.$allowed[$mime];if(!move_uploaded_file($file['tmp_name'],$base.'/'.$name))return null;return 'assets/'.$folder.'/'.$name;}

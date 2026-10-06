<?php
require_once __DIR__ . '/../config/mail.php';
require_once __DIR__ . '/../vendor/phpmailer/src/Exception.php';
require_once __DIR__ . '/../vendor/phpmailer/src/PHPMailer.php';
require_once __DIR__ . '/../vendor/phpmailer/src/SMTP.php';
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
function mail_is_configured(): bool { return mail_setting('MAIL_USERNAME', MAIL_USERNAME) !== '' && mail_setting('MAIL_APP_PASSWORD', MAIL_APP_PASSWORD) !== '' && mail_setting('MAIL_FROM_EMAIL', MAIL_FROM_EMAIL) !== ''; }
function send_notification(string $to, string $subject, string $html): bool { if (!filter_var($to,FILTER_VALIDATE_EMAIL) || !mail_is_configured()) return false; try { $mail=new PHPMailer(true);$mail->isSMTP();$mail->Host=mail_setting('MAIL_HOST',MAIL_HOST);$mail->SMTPAuth=true;$mail->Username=mail_setting('MAIL_USERNAME',MAIL_USERNAME);$mail->Password=mail_setting('MAIL_APP_PASSWORD',MAIL_APP_PASSWORD);$mail->SMTPSecure=mail_setting('MAIL_ENCRYPTION',MAIL_ENCRYPTION);$mail->Port=(int)mail_setting('MAIL_PORT',(string)MAIL_PORT);$mail->setFrom(mail_setting('MAIL_FROM_EMAIL',MAIL_FROM_EMAIL),mail_setting('MAIL_FROM_NAME',MAIL_FROM_NAME));$mail->addAddress($to);$mail->isHTML(true);$mail->Subject=$subject;$mail->Body=$html;$mail->AltBody=strip_tags($html);return $mail->send(); } catch (Exception $e) { error_log('Barangay mail error: '.$e->getMessage()); return false; } }
function send_login_otp(string $to, string $code): bool { return send_notification($to,'Your Barangay portal verification code','<h2>Barangay verification code</h2><p>Your one-time code is:</p><p style="font-size:28px;font-weight:bold;letter-spacing:6px">'.htmlspecialchars($code,ENT_QUOTES,'UTF-8').'</p><p>This code expires in 10 minutes. If you did not request it, ignore this email.</p>'); }

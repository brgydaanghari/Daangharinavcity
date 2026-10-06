<?php
// Configure these as Apache/PHP environment variables. Never use your normal Gmail password.
const MAIL_HOST = 'smtp.gmail.com';
const MAIL_PORT = 587;
const MAIL_ENCRYPTION = 'tls';
const MAIL_USERNAME = 'brgydaangharinavcity@gmail.com';
const MAIL_APP_PASSWORD = 'oehytbdkcwpdjrxl';
const MAIL_FROM_EMAIL = 'brgydaangharinavcity@gmail.com';
const MAIL_FROM_NAME = 'Barangay Daang Hari Navotas City';
function mail_setting(string $name, string $fallback = ''): string { $value = getenv($name); return ($value === false || $value === '') ? $fallback : $value; }

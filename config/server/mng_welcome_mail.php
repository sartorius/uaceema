<?php

require_once('_server_config.php');

$username = DB_USER;
$password = DB_PASSWORD;
$hostname = DB_HOST;
$selecteddb = DB_NAME;

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] START: config/server/mng_welcome_mail.php' . PHP_EOL;

// We create the DB connection here !
$mysqli = new mysqli($hostname, $username, $password, $selecteddb);

// we queue the account to be sent here 
$readquery = "CALL SRV_CRT_MailWelcomeNewUser()";
$mysqli->query( $readquery );

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] END config/server/mng_welcome_mail.php' . PHP_EOL;

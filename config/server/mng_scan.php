<?php

require_once('_server_config.php');

$username = DB_USER;
$password = DB_PASSWORD;
$hostname = DB_HOST;
$selecteddb = DB_NAME;

// We create the DB connection here !
$mysqli = new mysqli($hostname, $username, $password, $selecteddb);

$readquery = "CALL SRV_MNG_Scan(NULL)";
$mysqli->query( $readquery );

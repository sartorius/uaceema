<?php

require_once('_server_config.php');

// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE
// DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE * DEAD_CODE

$username = DB_USER;
$password = DB_PASSWORD;
$hostname = DB_HOST;
$selecteddb = DB_NAME;

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] START config/server/mng_uac_showuser.php' . PHP_EOL;

// We create the DB connection here !
$mysqli = new mysqli($hostname, $username, $password, $selecteddb);

$readquery = "CALL SRV_UPD_UACShower()";
$mysqli->query( $readquery );

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] END config/server/mng_uac_showuser.php' . PHP_EOL;

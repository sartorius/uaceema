<?php

require_once('_server_config.php');

$username = DB_USER;
$password = DB_PASSWORD;
$hostname = DB_HOST;
$selecteddb = DB_NAME;

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] START config/server/prg_reset_daily.php' . PHP_EOL;

// We create the DB connection here !
$mysqli = new mysqli($hostname, $username, $password, $selecteddb);

# Scan here but without uas_scan
$readquery = "CALL SRV_PRG_Scan()";
$mysqli->query( $readquery );

# Assiduite are handled here
$readquery = "CALL SRV_PRG_Ass()";
$mysqli->query( $readquery );

$readquery = 'UPDATE uac_param SET par_int = 0 WHERE key_code = \'DMAILCT\'';
$mysqli->query( $readquery );

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] END config/server/prg_reset_daily.php' . PHP_EOL;

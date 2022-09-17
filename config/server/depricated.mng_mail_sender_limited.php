<?php

require_once('_server_config.php');

$username = DB_USER;
$password = DB_PASSWORD;
$hostname = DB_HOST;
$selecteddb = DB_NAME;

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] START: config/server/mng_mail_sender_limited.php' . PHP_EOL;

      // We create the DB connection here !
      $mysqli = new mysqli($hostname, $username, $password, $selecteddb);

      $readquery = "CALL SRV_GRP_WelcomeEMail()";
      $result = $mysqli->query( $readquery );

      // Count the number of lines
      $row_cnt = $result->num_rows;

      if($row_cnt < 1){
            // We did not find the page we go out
            $dt=time();
            echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] We found nothing to send' . PHP_EOL;

      }else{
            $dt=time();
            echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] We found data: ' . $row_cnt . PHP_EOL;

            // MailManager::sendSimpleEmail();

            while ($line = $result->fetch_array(MYSQLI_ASSOC)) {
                sleep(1);
                echo "Send this username: " .
                  $line['USERNAME'] . ' - ' .
                  $line['FIRSTNAME'] . ' - ' .
                  $line['LASTNAME'] . ' - ' .
                  $line['MATRICULE'] . ' - ' .
                  $line['PAGE_URL'] . ' - ' .
                  $line['PARENT_EMAIL'] . ' to ' .
                  $line['EMAIL'] . PHP_EOL;
            }


      }

$dt=time();
echo 'TU+0[' . date("Y-m-d H:i:s",$dt) . '] END config/server/mng_mail_sender_limited.php' . PHP_EOL;

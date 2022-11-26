<?php

namespace App\DBUtils;
use App\DBUtils\DBConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ConnectionManager
{
  public function connectMe($input_username, $input_pwd, LoggerInterface $logger){

      $dbconnectioninst = DBConnectionManager::getInstance();

      $query_connection = 'SELECT ua.id AS ID, mdl.username AS USERNAME, mdl.firstname AS FIRSTNAME, mdl.lastname AS LASTNAME, ua.scale_right AS SCALE_RIGHT, mdl.email AS EMAIL FROM mdl_user mdl JOIN uac_admin ua on ua.id = mdl.id WHERE mdl.username = \'' . $input_username . '\' AND ua.pwd = \'' . MD5($input_pwd) . '\'';
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $result = $dbconnectioninst->query($query_connection)->fetchAll(PDO::FETCH_ASSOC);

      $logger->debug("query_connection: " . $query_connection);

      if(count($result) == 0){
          //We found nothing retrieve zero
          $logger->debug("We found no one: " . count($result));
          // We are not connected
          if (session_status() != PHP_SESSION_NONE){
              // remove all session variables
              session_unset();
              // destroy the session
              session_destroy();
          }
      }
      else{
          // Be carefull if you have array of array
          $logger->debug("We found someone: " . implode("|", $result[0]) . " Here is the count: " . count($result));
          $logger->debug("Show me value: " . $result[0]['USERNAME']);

          $dbconnectioninst->query("INSERT IGNORE INTO uac_connection_log (user_id) VALUES (" . $result[0]['ID'] . ");")->fetchAll(PDO::FETCH_ASSOC);

          //We are connected

          if (session_status() == PHP_SESSION_NONE) {
              session_start();
          }
          $_SESSION["id"] = $result[0]['ID'];
          $_SESSION["username"] = $result[0]['USERNAME'];
          $_SESSION["firstname"] = $result[0]['FIRSTNAME'];
          $_SESSION["lastname"] = $result[0]['LASTNAME'];
          $_SESSION["scale_right"] = $result[0]['SCALE_RIGHT'];
          $_SESSION["email"] = $result[0]['EMAIL'];

          /*
          $logger->debug("Hash password: lanatureestverte " . md5("lanatureestverte"));
          $logger->debug("Hash password: lebleuduciel " . md5("lebleuduciel"));
          $logger->debug("Hash password: lelapinblanc " . md5("lelapinblanc"));
          $logger->debug("Hash password: unetortuegasy " . md5("unetortuegasy"));
          $logger->debug("Hash password: lelemurientoutnoir " . md5("lelemurientoutnoir"));
          $logger->debug("Hash password: unnuagedansleciel " . md5("unnuagedansleciel"));
          $logger->debug("Hash password: unesardinedanslamer " . md5("unesardinedanslamer"));
          $logger->debug("Hash password: lelionestleroi " . md5("lelionestleroi"));
          $logger->debug("Hash password: unrequindanslocean " . md5("unrequindanslocean"));
          $logger->debug("Hash password: leratdesvilles " . md5("leratdesvilles"));
          */
      }




      /*
      // We create a session as we are connected and we save the info
      if (session_status() == PHP_SESSION_NONE) {
          session_start();
      }
      */

  }

  public static function amIConnectedOrNot(){
      if (session_status() == PHP_SESSION_NONE) {
          session_start();
      }
      if (isset($_SESSION['username'])) {
          return $_SESSION["username"];
      }
      else{
          return '';
      }
  }

  public static function whatScaleRight(){
      if (session_status() == PHP_SESSION_NONE) {
          session_start();
      }
      if (isset($_SESSION['scale_right'])) {
          return $_SESSION["scale_right"];
      }
      else{
          return '';
      }
  }

}

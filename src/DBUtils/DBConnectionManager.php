<?php
// src/Controller/AdvertController.php

namespace App\DBUtils;
use \PDO;

class DBConnectionManager
{
  private $PDOInstance = null;
  private static $instance = null;
  private static $lasttestconnection = null;

  private function __construct()
  {

// START connection
    $current_env = $_ENV['APP_ENV'];
    $servername = $_ENV['DB_SERVER_NAME'];
    $username = $_ENV['DB_USER_NAME'];
    $password = $_ENV['DB_PASSWORD'];
    $database = $_ENV['DB_DATABASE'];
    $port = $_ENV['DB_PORT'];

    try {

      $this->PDOInstance = new PDO("mysql:host=$servername; port=$port; dbname=$database", $username, $password);

      $conn = $this->PDOInstance;
      // set the PDO error mode to exception
      $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      //echo "Connected successfully";
      self::$lasttestconnection = "Connected successfully";
    } catch(PDOException $e) {
      //echo "Connection failed: " . $e->getMessage();
      self::$lasttestconnection = "Connection failed: " . $e->getMessage();
    }
  }

  public static function getInstance()
  {
    if(is_null(self::$instance))
    {
      self::$instance = new DBConnectionManager();
    }
    return self::$instance;
  }

  public static function getLastTestConnection()
  {
    return self::$lasttestconnection;
  }

  public function query($query)
  {
    return $this->PDOInstance->query($query);
  }

}

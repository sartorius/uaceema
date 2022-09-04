<?php

namespace App\DBUtils;
use App\DBUtils\DBConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ConnectionManager
{
  public function connectMe(){
      // Manage DB Connection
      if (session_status() == PHP_SESSION_NONE) {
          session_start();
      }

  }

}

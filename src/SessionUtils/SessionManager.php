<?php
// src/Controller/AdvertController.php

namespace App\SessionUtils;

class SessionManager
{

  public static function getSecureSession(){
    ini_set('session.cookie_secure', '1');
    ini_set('session.cookie_httponly', '1');
    ini_set('session.use_only_cookies', '1');

    session_start();
  }

}

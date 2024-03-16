<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\SessionUtils\SessionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ConnectionController extends AbstractController
{
  public function login(Environment $twig, LoggerInterface $logger)
  {

    $content = $twig->render('Connection/login.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    return new Response($content);
  }


  public function logout(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
      SessionManager::getSecureSession();
    }
    if (session_status() != PHP_SESSION_NONE){
        // remove all session variables
        session_unset();
        // destroy the session
        session_destroy();

        $logger->debug('Clean session.');
    }
    else{
        //$logger->debug('Not clean session:' . $_SESSION["username"]);
    }
    $content = $twig->render('Connection/login.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight(), 'logmeout' => 'yes']);
    return new Response($content);
  }


  public function verify(Environment $twig, LoggerInterface $logger)
  {

    if ($_SERVER["REQUEST_METHOD"] == "POST"){
      if ( (!empty($_POST["inputUserName"]))
            and (!empty($_POST["inputPassword"]))
          ) {

          $logger->debug("READ Username: " . $_POST["inputUserName"] . " READ Password: " . $_POST["inputPassword"]);

          $the_connection = new ConnectionManager;
          $the_connection->connectMe($_POST["inputUserName"], $_POST["inputPassword"], $logger);

          if (session_status() == PHP_SESSION_NONE) {
              $content = $twig->render('Connection/login.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight(), 'mgverifynotfound' => 'no']);
          }
          else{
              $content = $twig->render('Home/home.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight(), 'connected' => 'yes']);
              $logger->debug('Show me session: ' . $_SESSION["firstname"]);
          }


      }
    }

    return new Response($content);
  }
}

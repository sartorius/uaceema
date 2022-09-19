<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class AdminEDTController extends AbstractController
{
  public function loadedt(Environment $twig, LoggerInterface $logger)
  {

    session_start();
    $scale_right = ConnectionManager::whatScaleRight();


    if(isset($scale_right) && ($scale_right == 0)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $content = $twig->render('Scan/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                  'firstname' => $_SESSION["firstname"],
                                                  'lastname' => $_SESSION["lastname"],
                                                  'id' => $_SESSION["id"],
                                                  'scale_right' => ConnectionManager::whatScaleRight()]);


        $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    return new Response($content);
  }
}

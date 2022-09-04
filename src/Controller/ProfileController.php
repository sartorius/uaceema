<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ProfileController extends AbstractController
{
  public function show(Environment $twig, LoggerInterface $logger, $page)
  {


    $logger->debug("This page: " . $page);

    if(strlen($page) < 6){
      // Error Code 404
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    else{

      $logger->debug("Secret: " . substr($page, 0, 5) . " ID: " . substr($page, 5, strlen($page) - 5));

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $result = $dbconnectioninst->query('SELECT NOW()')->fetchAll(PDO::FETCH_ASSOC);
      $logger->debug("Show me: " . implode("|", $result[0]));






      $content = $twig->render('Profile/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }








    return new Response($content);
  }
}

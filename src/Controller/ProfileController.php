<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ProfileController extends AbstractController
{
  public function show(Environment $twig, LoggerInterface $logger)
  {

    $dbconnectioninst = DBConnectionManager::getInstance();

    //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
    $result = $dbconnectioninst->query('SELECT NOW()')->fetchAll(PDO::FETCH_ASSOC);

    // Be carefull if you have array of array
    $logger->debug("Show me: " . implode("|", $result[0]));




    $content = $twig->render('Profile/main.html.twig');
    return new Response($content);
  }
}

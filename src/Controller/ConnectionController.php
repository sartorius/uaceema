<?php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ConnectionController extends AbstractController
{
  public function login(Environment $twig, LoggerInterface $logger)
  {

    $content = $twig->render('Connection/login.html.twig');
    return new Response($content);
  }
}

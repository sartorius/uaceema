<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use App\DBUtils\ConnectionManager;
use App\DBUtils\MailManager;
use Twig\Environment;
use Psr\Log\LoggerInterface;


class TutorialController extends AbstractController
{

  public function tutoinscription(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    // This email works !!
    //MailManager::sendSimpleEmail();

    $content = $twig->render('Tutorial/tutoinscription.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }
}

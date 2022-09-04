<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use App\DBUtils\ConnectionManager;
use Twig\Environment;

class StaticController extends AbstractController
{
  public function mention(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/mention.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }

  public function news(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/news.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }

  public function partner(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/partner.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }

  public function universite(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/universite.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }
}

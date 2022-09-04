<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use App\DBUtils\ConnectionManager;
use Twig\Environment;

class MentionController extends AbstractController
{
  public function index(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Mention/mention.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }
}

<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;

class MentionController extends AbstractController
{
  public function index(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Mention/mention.html.twig', ['debug' => $debug_session]);

    return new Response($content);
  }
}

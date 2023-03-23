<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use App\DBUtils\MailManager;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;


class StaticController extends AbstractController
{
  public function mention(Environment $twig, LoggerInterface $logger)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/mention.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

  public function vieetudiante(Environment $twig, LoggerInterface $logger)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/vieetudiante.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

  public function provinceint(Environment $twig, LoggerInterface $logger)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/provinceint.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }


  public function news(Environment $twig)
  {

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/news.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

  public function partner(Environment $twig, LoggerInterface $logger)
  {

    $debug_session = "prod.21.a";

    // This email works !!
    $liste_partner_query = "SELECT urp.title AS title, urp.img_path AS path, urp.website AS website FROM uac_ref_partner urp ORDER BY urp.title; ";
    $logger->debug("Show me liste_partner_query: " . $liste_partner_query);


    $dbconnectioninst = DBConnectionManager::getInstance();
    $result_all_partner = $dbconnectioninst->query($liste_partner_query)->fetchAll(PDO::FETCH_ASSOC);


    $content = $twig->render('Static/partner.html.twig', ['debug' => $debug_session,
                                                          'amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                          'result_all_partner'=>$result_all_partner,
                                                          'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }




  public function universite(Environment $twig, LoggerInterface $logger)
  {
    $ipAddress=$_SERVER['REMOTE_ADDR'];

    $logger->debug("This ipAddress: " . $ipAddress);

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/universite.html.twig', ['debug' => $debug_session, 'mac_address' => $ipAddress, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

  public function cgu(Environment $twig)
  {
    $debug_session = 0;

    $content = $twig->render('Static/cgu.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

  public function reglassiduite(Environment $twig)
  {
    $debug_session = 0;

    $content = $twig->render('Static/reglassiduite.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

  public function reglementinterieur(Environment $twig)
  {

    $content = $twig->render('Static/reglementinterieur.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }



  public function contact(Environment $twig)
  {
    $content = $twig->render('Static/contact.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }

}

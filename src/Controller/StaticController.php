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

require '../vendor/autoload.php';
use \Mailjet\Resources;

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

    // This email works !!
    //MailManager::sendSimpleEmail();
    /**************/


    $apikey = '6532da700924bb9f1c446083039c4566';
    $apisecret = '77eaf825c21d0015e6cda0fbaed1d6c7';

    $mj = new \Mailjet\Client($apikey, $apisecret);

    // Use your saved credentials, specify that you are using Send API v3.1

    $mj = new \Mailjet\Client(getenv('MJ_APIKEY_PUBLIC'), getenv('MJ_APIKEY_PRIVATE'),true,['version' => 'v3.1']);

    // Define your request body

    $body = [
        'Messages' => [
            [
                'From' => [
                    'Email' => "ne-pas-repondre@mgsuivi.com",
                    'Name' => "Me"
                ],
                'To' => [
                    [
                        'Email' => "ratinahirana@gmail.com",
                        'Name' => "You"
                    ]
                ],
                'Subject' => "My first Mailjet Email!",
                'TextPart' => "Greetings from Mailjet!",
                'HTMLPart' => "<h3>Dear passenger 1, welcome to <a href=\"https://www.mailjet.com/\">Mailjet</a>!</h3>
                <br />May the delivery force be with you!"
            ]
        ]
    ];

    // All resources are located in the Resources class

    $response = $mj->post(Resources::$Email, ['body' => $body]);

    // Read the response

    $response->success() && var_dump($response->getData());


    /**************/

    $content = $twig->render('Static/partner.html.twig', ['debug' => $debug_session, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }

  public function universite(Environment $twig, LoggerInterface $logger)
  {
    $ipAddress=$_SERVER['REMOTE_ADDR'];

    $logger->debug("This ipAddress: " . $ipAddress);

    $debug_session = "Pass variable to check";

    $content = $twig->render('Static/universite.html.twig', ['debug' => $debug_session, 'mac_address' => $ipAddress, 'amiconnected' => ConnectionManager::amIConnectedOrNot()]);

    return new Response($content);
  }
}

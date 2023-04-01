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


class AdminPayController extends AbstractController
{

  public function addpay(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be exactly 21 or more than 99
    if(isset($scale_right) &&  (($scale_right == 51) || ($scale_right > 99))){


        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        // Get All USERNAME
        $allusrn_query = " SELECT *  from v_payfoundusrn; ";

        $logger->debug("Show me allusrn_query: " . $allusrn_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_usrn = $dbconnectioninst->query($allusrn_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_usrn));



        $content = $twig->render('Admin/PAY/addpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_all_usrn'=>$result_all_usrn,
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }

}

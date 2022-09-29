<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class AdminSTUController extends AbstractController
{

  public function dashboardstu(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();



    if(isset($scale_right) && ($scale_right > 4)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);


        $allstu_query = " SELECT mu.id AS ID, mu.username AS USERNAME, uas.secret AS SECRET, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, "
                              . " mr.shortname AS ROLE_SHORTNAME, REPLACE(UPPER(mu.firstname), \"'\", \" \") AS FIRSTNAME, REPLACE(UPPER(mu.lastname), \"'\", \" \") AS LASTNAME, mu.email AS EMAIL, vaco.id AS CLASS_ID, "
                              . " vaco.mention AS CLASS_MENTION, vaco.niveau AS CLASS_NIVEAU, vaco.parcours AS CLASS_PARCOURS, vaco.groupe AS CLASS_GROUPE, "
                              . " REPLACE(UPPER(CONCAT(mu.firstname, mu.lastname, vaco.mention, vaco.niveau, vaco.parcours, vaco.groupe)), \"'\", \" \") AS raw_data "
                              . " FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username "
                              . " JOIN mdl_role mr ON mr.id = uas.roleid "
                              . " JOIN v_class_cohort vaco ON vaco.id = uas.cohort_id "
                              . " WHERE mr.shortname = 'student' ORDER BY CLASS_NIVEAU ASC; ";


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));

        $content = $twig->render('Admin/STU/dashboardstu.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'result_all_stu'=>$result_all_stu,
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

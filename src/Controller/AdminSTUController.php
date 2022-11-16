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

  public function managerstu(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();



    if(isset($scale_right) && ($scale_right > 4)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);


        $allstu_query = " SELECT mu.id AS ID, UPPER(mu.username) AS USERNAME, uas.secret AS SECRET, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, "
                              . " mr.shortname AS ROLE_SHORTNAME, REPLACE(UPPER(mu.firstname), \"'\", \" \") AS FIRSTNAME, REPLACE(UPPER(mu.lastname), \"'\", \" \") AS LASTNAME, mu.email AS EMAIL, vaco.id AS CLASS_ID, "
                              . " vaco.mention AS CLASS_MENTION, vaco.niveau AS CLASS_NIVEAU, vaco.parcours AS CLASS_PARCOURS, vaco.groupe AS CLASS_GROUPE, "
                              . " REPLACE(UPPER(CONCAT(mu.username, mu.firstname, mu.lastname, vaco.mention, vaco.niveau, vaco.parcours, vaco.groupe)), \"'\", \" \") AS raw_data "
                              . " FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username "
                              . " JOIN mdl_role mr ON mr.id = uas.roleid "
                              . " JOIN v_class_cohort vaco ON vaco.id = uas.cohort_id "
                              . " WHERE mr.shortname = 'student' ORDER BY CONCAT(CLASS_NIVEAU, CLASS_MENTION) ASC; ";


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));

        $content = $twig->render('Admin/STU/managerstu.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
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


  public function checklastscan(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();



    if(isset($scale_right) && ($scale_right > -1)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $allstu_query = " SELECT UPPER(uls.scan_username) AS USERNAME, DATE_FORMAT(uls.scan_date, '%d/%m') AS SCAN_DATE, uls.scan_time AS SCAN_TIME, uls.status AS SCAN_STATUS, uls.in_out AS IN_OUT, "
                        . " CASE WHEN uls.status = 'END' THEN REPLACE(UPPER(mu.firstname), \"'\", \" \") ELSE 'na' END AS FIRSTNAME, "
                        . " CASE WHEN uls.status = 'END' THEN REPLACE(UPPER(mu.lastname), \"'\", \" \") ELSE 'na' END AS LASTNAME "
                        . " FROM uac_load_scan uls LEFT JOIN mdl_user mu ON UPPER(mu.username) = UPPER(uls.scan_username) "
                        . " WHERE uls.scan_date = CURRENT_DATE  ORDER BY uls.id desc;";


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));

        $content = $twig->render('Admin/STU/checklastscan.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
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

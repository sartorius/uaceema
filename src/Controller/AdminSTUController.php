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
use App\SessionUtils\SessionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class AdminSTUController extends AbstractController{
  // - Teacher access
  private static $my_exact_teacher_access_right = 45;

  public function managerstu(Environment $twig, LoggerInterface $logger)
  {

    $logger->debug("1: session_status() " . session_status());

    if (!isset($_SESSION)) {
      $logger->debug("_SESSION NO");
    }
    else{
      $logger->debug("_SESSION YES");
    }

    if (session_status() == PHP_SESSION_NONE) {
      SessionManager::getSecureSession();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();
    $logger->debug("2: session_status() " . session_status());

    $logger->debug("Username: " . $_SESSION["username"]);
    $logger->debug("my scale rights: " . $scale_right);

    if(isset($scale_right) && ($scale_right > 4)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        //By default it is not teacher
        $is_teacher = 'N';
        $teach_clause = '';
        if(isset($scale_right) && ($scale_right == self::$my_exact_teacher_access_right)){
            $is_teacher = 'Y';
            $teach_clause = " AND vaco.mention_code IN ( SELECT utea.mention_code FROM uac_teacher utea WHERE utea.id = " . $_SESSION["id"] . ") ";
        }



        $allstu_query = " SELECT mu.id AS ID, UPPER(mu.username) AS USERNAME, mu.matricule AS MATRICULE, uas.secret AS SECRET, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, "
                              . " fCapitalizeStr(REPLACE(UPPER(mu.firstname), \"'\", \" \")) AS FIRSTNAME, REPLACE(UPPER(mu.lastname), \"'\", \" \") AS LASTNAME, mu.genre AS GENRE, mu.situation_matrimoniale AS SITM, mu.email AS EMAIL, vaco.id AS CLASS_ID, "
                              . " vaco.mention AS CLASS_MENTION, vaco.niveau AS CLASS_NIVEAU, vaco.parcours AS CLASS_PARCOURS, vaco.groupe AS CLASS_GROUPE, "
                              . " mu.phone1 AS PHONE, mu.address AS ADRESSE, mu.city AS QUARTIER, DATE_FORMAT(mu.datedenaissance, '%d/%m/%Y') AS DATEDENAISSANCE, fEscapeStr(UPPER(ifnull(mu.lieu_de_naissance, 'na'))) AS LIEUDN, DATE_FORMAT(mu.create_date, '%d/%m/%Y') AS INSCDATE, ifnull(mu.compte_fb, 'na') AS FB, fEscapeStr(mu.etablissement_origine) AS ORIGINE, "
                              . " mu.serie_bac AS SERIE_BAC, mu.annee_bac AS ANNEE_BAC, ifnull(mu.numero_cin, 'na') AS NUMCIN, ifnull(DATE_FORMAT(mu.date_cin, '%d/%m/%Y'), 'na') AS DATECIN, fEscapeStr(ifnull(mu.lieu_cin, 'na')) AS LIEU_CIN, fEscapeStr(ifnull(mu.nom_pnom_par1, 'na')) AS NOMPNOMP1, "
                              . " ifnull(mu.phone_par1, 'na') AS PHONEPAR1, fEscapeStr(ifnull(mu.profession_par1, 'na')) AS PROFPAR1, fEscapeStr(ifnull(mu.adresse_par1, 'na')) AS ADDRPAR1, fEscapeStr(ifnull(mu.city_par1, 'na')) AS CITYPAR1, fEscapeStr(ifnull(mu.nom_pnom_par2, 'na')) AS NOMPNOMP2, fEscapeStr(ifnull(mu.profession_par2, 'na')) AS PROFPAR2, "
                              . " ifnull(mu.phone_par2, 'na') AS PHONEPAR2, fEscapeStr(ifnull(mu.centres_interets, 'na')) AS CENTINT, "
                              . " REPLACE(UPPER(CONCAT(mu.username, mu.firstname, mu.lastname, vaco.mention, vaco.niveau, vaco.parcours, vaco.groupe, vaco.short_classe, mu.matricule)), \"'\", \" \") AS raw_data "
                              . " FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username "
                              . " JOIN v_class_cohort vaco ON vaco.id = uas.cohort_id WHERE 1 = 1 "
                              . $teach_clause
                              . " ORDER BY CONCAT(CLASS_NIVEAU, CLASS_MENTION) ASC; ";

        $logger->debug("Show me allstu_query: " . $allstu_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));

        $content = $twig->render('Admin/STU/managerstu.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'result_all_stu'=>$result_all_stu,
                                                                  'is_teacher'=>$is_teacher,
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
      SessionManager::getSecureSession();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();



    if(isset($scale_right) && ($scale_right > -1)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $allstu_query = " SELECT UPPER(uls.scan_username) AS USERNAME, DATE_FORMAT(uls.scan_date, '%d/%m') AS SCAN_DATE, uls.scan_time AS SCAN_TIME, uls.status AS SCAN_STATUS, uls.in_out AS IN_OUT, "
                        . " CASE WHEN uls.status = 'END' THEN REPLACE(UPPER(mu.firstname), \"'\", \" \") WHEN uls.status = 'MIS' THEN 'Echec Lecture' ELSE 'En cours' END AS FIRSTNAME, "
                        . " CASE WHEN uls.status = 'END' THEN REPLACE(UPPER(mu.lastname), \"'\", \" \") WHEN uls.status = 'MIS' THEN 'Echec Lecture' ELSE 'En cours' END AS LASTNAME,  CASE WHEN uls.status = 'END' THEN vcc.short_classe WHEN uls.status = 'MIS' THEN 'Echec Lecture' ELSE 'En cours' END AS CLASSE"
                        . " FROM uac_load_scan uls LEFT JOIN mdl_user mu ON UPPER(mu.username) = UPPER(uls.scan_username) LEFT JOIN v_showuser vsw ON mu.id = vsw.ID LEFT JOIN v_class_cohort vcc ON vsw.COHORT_ID = vcc.id "
                        . " WHERE uls.scan_date = CURRENT_DATE  ORDER BY uls.id desc;";

        $logger->debug("Show me allstu_query: " . $allstu_query);

        $distinct_query = "SELECT count(distinct uls.scan_username) AS SCAN_UNIQUE FROM uac_load_scan uls WHERE uls.scan_date = CURRENT_DATE; ";
        $logger->debug("Show me distinct_query: " . $distinct_query);

        $miss_query = "SELECT count(uls.scan_username) AS SCAN_MISS FROM uac_load_scan uls WHERE uls.status = 'MIS' AND uls.scan_date = CURRENT_DATE; ";
        $logger->debug("Show me distinct_query: " . $miss_query);

        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));


        $result_distinct = $dbconnectioninst->query($distinct_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_distinct));

        $result_miss = $dbconnectioninst->query($miss_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_miss));

        $content = $twig->render('Admin/STU/checklastscan.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'result_all_stu'=>$result_all_stu,
                                                                  'result_distinct'=>$result_distinct,
                                                                  'result_miss'=>$result_miss,
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

<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class ProfileController extends AbstractController
{
  public function show(Environment $twig, LoggerInterface $logger, $page, $week)
  {


    $logger->debug("This page: " . $page);
    // Usually this means N for No
    $from_admin = 'N';

    //Check if we are coming from POST
    if(isset($_POST["poststu_page"]))
    {
        // Get data from ajax
        $logger->debug("See poststu_page: " . $_POST["poststu_page"]);
        $logger->debug("See Session ID: " . $_SESSION["id"]);

        $page = $_POST["poststu_page"];
        // Student
        $from_admin = 'S';
    }
    else if(isset($_POST["postfromdashass_page"])){
          // Coming from dash ass
          $page = $_POST["postfromdashass_page"];
          // Dashboard Assiduite
          $from_admin = 'A';
    }

    $logger->debug("See from_admin: " . $from_admin);
    // N : default No - S : Student from Manager Etudiant - A : Assiduite from Dashboard Retard


    if(strlen($page) < 11){
      // Error Code 404
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    else{

      $param_secret = substr($page, 0, 10);
      $param_username = substr($page, 10, strlen($page) - 10);

      $logger->debug("Secret: " . $param_secret . " ID: " . $param_username);

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $query_get_profile = ' SELECT * FROM v_showuser WHERE UPPER(USERNAME) = \'' . $param_username . '\' AND CONVERT(SECRET, CHAR) = \'' . $param_secret . '\'';
      $logger->debug("Query query_get_profile: " . $query_get_profile);

      $result = $dbconnectioninst->query($query_get_profile)->fetchAll(PDO::FETCH_ASSOC);


      $logger->debug("Show me: " . count($result));

      if(count($result) != 1){
            // We did not find the page we go out
            $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

      }else{
            // We found the student
            $logger->debug("We found: " . $result[0]['FIRSTNAME'] . ' ' . $result[0]['LASTNAME']);

            // log the connection :
            $dashorigin = "'S', NULL";

            //Check if we are coming from POST
            if($from_admin == 'Y')
            {
                // It is from Admin
                $dashorigin = "'A', " . $_SESSION["id"];
            };
            $query_add_log = " INSERT INTO uac_studashboard_log(user_id, origin, admin_id) VALUE ( " . $result[0]['ID'] . ", " . $dashorigin . ");";
            $dbconnectioninst->query($query_add_log)->fetchAll(PDO::FETCH_ASSOC);

            // Retrieve the result for assiduité
            $query_ass_trace = " SELECT uas.in_out AS IN_OUT,  DATE_FORMAT(uas.scan_date, '%d/%m') AS SCANDATE, "
                            . " uas.scan_time AS SCANTIME "
                            . " FROM uac_scan uas "
                                   . " WHERE user_id = " . $result[0]['ID']
                                   . " AND uas.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)  "
                                   . " ORDER BY ADDTIME(uas.scan_date, uas.scan_time) DESC;  ";

            $result_assiduite = $dbconnectioninst->query($query_ass_trace)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Query query_ass_trace: " . $query_ass_trace);

            $query_queued_ass = " SELECT COUNT(1) AS QUEUED_ASS FROM uac_edt_line uel JOIN uac_edt_master uem ON uel.master_id = uem.id AND uem.cohort_id = " . $result[0]['COHORT_ID']
                                . " WHERE uel.day < CURRENT_DATE and uel.compute_late_status = 'NEW' AND uel.course_status = 'A' and uel.duration_hour > 0; ";
            $logger->debug("Show me query_queued_ass: " . $query_queued_ass);

            $result_query_queued_ass = $dbconnectioninst->query($query_queued_ass)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_query_queued_ass));



            $query_ass_recap = " SELECT ass.status AS STATUS, "
                                      .  " uae.hour_starts_at AS DEBUT, DATE_FORMAT(uae.day, '%d/%m') AS JOUR, REPLACE(SUBSTRING(uae.raw_course_title, 1, 20), '\n', ' ') AS COURS, sca.scan_date AS SCAN_DATE, sca.scan_time AS SCAN_TIME, "
                                      . " CASE WHEN day_code = 1 THEN 'LUNDI' WHEN day_code = 2 THEN 'MARDI' WHEN day_code = 3 THEN 'MERCREDI' "
                                      . " WHEN day_code = 4 THEN 'JEUDI' WHEN day_code = 5 THEN 'VENDREDI' ELSE 'SAMEDI' END AS LABEL_DAY_FR, uae.day AS TECH_DAT, uae.hour_starts_at AS TECH_DEBUT "
                                      . " FROM uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id "
                      								. " JOIN uac_showuser uas ON mu.username = uas.username "
                      									  . " JOIN uac_edt_line uae ON uae.id = ass.edt_id "
                      									  . " LEFT JOIN uac_scan sca ON sca.id = ass.scan_id "
                                          . " WHERE mu.id = " . $result[0]['ID']
                                          . " AND uae.day NOT IN (SELECT working_date FROM uac_assiduite_off) UNION ";
            $query_ass_recap = "SELECT * FROM ( "
                                . $query_ass_recap
                                . " SELECT 'XXX' AS STATUS, '0' AS DEBUT, DATE_FORMAT(working_date, '%d/%m') AS JOUR, 'XXX' AS COURS, NULL AS SCAN_DATE, NULL AS SCAN_TIME, CASE WHEN day_code = 2 THEN "
                                . " 'LUNDI' WHEN day_code = 3 THEN 'MARDI' WHEN day_code = 4 THEN 'MERCREDI' WHEN day_code = 5 THEN 'JEUDI' WHEN day_code = 6 THEN 'VENDREDI' ELSE 'SAMEDI' END AS "
                                . " LABEL_DAY_FR, working_date AS TECH_DAT, 0 AS TECH_DEBUT FROM uac_assiduite_off ) a "
                                          . " ORDER BY ADDTIME(TECH_DAT, CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(TECH_DEBUT) = 1) THEN CONCAT('0', TECH_DEBUT) ELSE TECH_DEBUT END, ':00:00'), TIME)) DESC;";

            $logger->debug("Query query_ass_recap: " . $query_ass_recap);

            $result_assiduite_recap = $dbconnectioninst->query($query_ass_recap)->fetchAll(PDO::FETCH_ASSOC);


            $query_list_bdaymonth = "SELECT fCapitalizeStr(TRIM(FIRSTNAME)) AS FNAMEBDAY FROM v_showuser WHERE COHORT_ID = " . $result[0]['COHORT_ID']
                                    . " AND MONTHBDAY = DATE_FORMAT(CURRENT_DATE, '%m')";

            $logger->debug("Query query_list_bdaymonth: " . $query_list_bdaymonth);
            $result_list_bdaymonth = $dbconnectioninst->query($query_list_bdaymonth)->fetchAll(PDO::FETCH_ASSOC);


            // End of assiduité
            $prec_maxweek = $_ENV['PRECMAXWEEK'];
            $next_maxweek = $_ENV['NEXTMAXWEEK'];
            // We force week to keep in -1 + 2
            if(is_numeric($week)){
              if (($week < $prec_maxweek) or ($week > $next_maxweek)){
                $week = 0;
              }
            }else{
              $week = 0;
            }

            /** Manage emploi du temps **/
            // Be carefull if you have array of array
            $dbconnectioninst = DBConnectionManager::getInstance();
            // Perform the importation
            // Change the option here !
            $import_query = "CALL CLI_GET_FWEDT('" . $result[0]['USERNAME'] . "', " . $week . ", 'N')";
            $resultsp = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

            $week_p_one = array();
            $week_p_two = array();

            for($k = 0; $k < count($resultsp); $k++){
                if($resultsp[$k]['day_code'] < 4){
                  array_push($week_p_one, $resultsp[$k]);
                }
                else{
                  array_push($week_p_two, $resultsp[$k]);
                }
            }

            $import_query = "CALL CLI_GET_FWEDT('" . $result[0]['USERNAME'] . "', " . $week . ", 'Y')";
            $logger->debug("Get EDT with backup: " . $import_query);
            $resultspbackup = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

            $content = $twig->render('Profile/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight(), 'profile' => $result[0],
                                      'assiduites' => $result_assiduite, 'moodle_url' => $_ENV['MDL_URL'],
                                      'recap_assiduites'=>$result_assiduite_recap, 'from_admin' => $from_admin,
                                      "sp_result"=>$resultsp, "resultsp_sm"=>$week_p_one, "resultsp_sm_bkp"=>$resultspbackup,
                                      "week"=>$week, "page"=>$page, "prec_maxweek"=>$prec_maxweek, "next_maxweek"=>$next_maxweek,
                                      "result_query_queued_ass"=>$result_query_queued_ass,
                                      "result_list_bdaymonth"=>$result_list_bdaymonth,
                                      "week_p_one"=>$week_p_one, "week_p_two"=>$week_p_two]);
      }
    }








    return new Response($content);
  }


  public function didiapply(Environment $twig, LoggerInterface $logger)
  {

    $content = $twig->render('Profile/didiapply.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    return new Response($content);
  }

  public function verifyapplication(Environment $twig, LoggerInterface $logger)
  {

    if ($_SERVER["REQUEST_METHOD"] == "POST"){
      if ( (!empty($_POST["inputLastName"]))
            and (!empty($_POST["inputBirthday"]))
          ) {

          $logger->debug("READ Lastname: " . $_POST["inputLastName"] . " READ Birthday: " . $_POST["inputBirthday"]);


          // Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $query_didapp = " SELECT mu.email AS EMAIL, mu.lastname AS LASTNAME, mu.firstname AS FIRSTNAME, vs.SHORTCLASS AS CLASS, DATE_FORMAT(mu.datedenaissance,'%d-%m-%Y') AS DATEDENAISSANCE , CASE WHEN um.status = 'NEW' THEN 'Email carte étudiant en cours - env. 72h' ELSE CONCAT('Email carte étudiant envoyé le ', DATE_FORMAT(um.last_update, '%d/%m/%Y vers %H:%i UTC')) END AS EMAIL_STATUS "
                          . " FROM v_showuser vs JOIN mdl_user mu ON mu.id = vs.ID "
                          . " JOIN uac_mail um ON um.user_id = mu.id AND um.flow_code = 'MLWELCO' "
                          . " WHERE fEscapeStr(vs.LASTNAME) = fEscapeStr(UPPER('" . $_POST["inputLastName"] . "')) AND mu.datedenaissance = STR_TO_DATE('" . $_POST["inputBirthday"] . "','%d-%m-%Y'); ";
          $logger->debug("Query query_didapp: " . $query_didapp);
          $result_query_didapp = $dbconnectioninst->query($query_didapp)->fetchAll(PDO::FETCH_ASSOC);


          $content = $twig->render('Profile/resultapplication.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                            'result_query_didapp' => $result_query_didapp,
                                                                            'inputLN' => $_POST["inputLastName"],
                                                                            'inputBirthD' => $_POST["inputBirthday"]]);

      }
      else{
          // Error Code 404
          $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
      }
    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }

    return new Response($content);
  }
}

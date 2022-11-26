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
    $from_admin = 'N';

    //Check if we are coming from POST
    if(isset($_POST["poststu_page"]))
    {
        // Get data from ajax
        $logger->debug("See poststu_page: " . $_POST["poststu_page"]);
        $page = $_POST["poststu_page"];
        $from_admin = 'Y';
    }



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
      $result = $dbconnectioninst->query('
      SELECT *
        FROM v_showuser
                 WHERE UPPER(USERNAME) = \'' . $param_username . '\'
                 AND CONVERT(SECRET, CHAR) = \'' . $param_secret . '\'' )->fetchAll(PDO::FETCH_ASSOC);

      $logger->debug("Show me: " . count($result));

      if(count($result) != 1){
            // We did not find the page we go out
            $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

      }else{
            // We found the student
            $logger->debug("We found: " . $result[0]['FIRSTNAME'] . ' ' . $result[0]['LASTNAME']);

            // Retrieve the result for assiduité

            $query_ass_trace = " SELECT uas.in_out AS IN_OUT,  DATE_FORMAT(uas.scan_date, '%d/%m') AS SCANDATE, "
                            . " uas.scan_time AS SCANTIME "
                            . " FROM uac_scan uas "
                                   . " WHERE user_id = " . $result[0]['ID']
                                   . " AND uas.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)  "
                                   . " ORDER BY ADDTIME(uas.scan_date, uas.scan_time) DESC;  ";

            $result_assiduite = $dbconnectioninst->query($query_ass_trace)->fetchAll(PDO::FETCH_ASSOC);

            $logger->debug("Query query_ass_trace: " . $query_ass_trace);



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
                                      "week_p_one"=>$week_p_one, "week_p_two"=>$week_p_two]);
      }
    }








    return new Response($content);
  }
}

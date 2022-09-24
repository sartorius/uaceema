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

    if(strlen($page) < 11){
      // Error Code 404
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    else{

      $param_secret = substr($page, 0, 10);
      $param_username = substr($page, 10, strlen($page) - 10);

      $logger->debug("Secret: " . $param_secret . " ID: " . $param_username);

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $result = $dbconnectioninst->query('
      SELECT
          mu.id AS ID,
          mu.username AS USERNAME,
           uas.secret AS SECRET,
           CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
           mr.shortname AS ROLE_SHORTNAME,
           UPPER(mu.firstname) AS FIRSTNAME,
           UPPER(mu.lastname) AS LASTNAME,
           mu.email AS EMAIL,
           mu.phone1 AS PHONE,
           mu.phone2 AS PARENT_PHONE,
           mf.contextid AS PIC_CONTEXT_ID,
           mu.picture AS PICTURE_ID,
           SUBSTRING(mf.contenthash, 1, 2) AS D1,
           SUBSTRING(mf.contenthash, 3, 2) AS D2,
           mf.contenthash AS FILENAME
        FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
                 JOIN mdl_role mr ON mr.id = uas.roleid
                 LEFT JOIN mdl_files mf ON mu.picture = mf.id
                 WHERE UPPER(mu.username) = \'' . $param_username . '\'
                 AND CONVERT(uas.secret, CHAR) = \'' . $param_secret . '\'' )->fetchAll(PDO::FETCH_ASSOC);

      $logger->debug("Show me: " . count($result));

      if(count($result) != 1){
            // We did not find the page we go out
            $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);

      }else{
            // We found the student
            $logger->debug("We found: " . $result[0]['FIRSTNAME'] . ' ' . $result[0]['LASTNAME']);

            // Retrieve the result for assiduité

            $result_assiduite = $dbconnectioninst->query('
            SELECT
                scan_date AS SCANDATE,
                scan_time AS SCANTIME
              FROM uac_scan
                       WHERE user_id = ' . $result[0]['ID'] . ' ORDER BY SCANDATE, SCANTIME DESC; ' )->fetchAll(PDO::FETCH_ASSOC);


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
            $resultspbackup = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

            $content = $twig->render('Profile/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'profile' => $result[0],
                                      'assiduites' => $result_assiduite, 'moodle_url' => $_ENV['MDL_URL'],
                                      "sp_result"=>$resultsp, "resultsp_sm"=>$week_p_one, "resultsp_sm_bkp"=>$resultspbackup,
                                      "week"=>$week, "page"=>$page, "prec_maxweek"=>$prec_maxweek, "next_maxweek"=>$next_maxweek,
                                      "week_p_one"=>$week_p_one, "week_p_two"=>$week_p_two]);
      }
    }








    return new Response($content);
  }
}

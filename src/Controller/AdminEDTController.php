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
use \ZipArchive;

class AdminEDTController extends AbstractController
{

  public function dashboardass(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();


    // Level ONE is necessary to load EDT
    if(isset($scale_right) && ($scale_right > 4)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);


        $late_query = " SELECT mu.city AS CITY, COUNT(1) AS CPT from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id "
									        . " JOIN uac_showuser uas ON mu.username = uas.username "
                          . " WHERE ass.status = 'LAT' "
											    . " GROUP BY mu.city, ass.status; ";
        $logger->debug("Show me late_query: " . $late_query);

        $mis_query = " SELECT mu.city AS CITY, COUNT(1) AS CPT from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id "
									        . " JOIN uac_showuser uas ON mu.username = uas.username "
                          . " WHERE ass.status = 'ABS' "
											    . " GROUP BY mu.city, ass.status; ";
        $logger->debug("Show me mis_query: " . $mis_query);

        $mis_query_pp = " SELECT REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), \"'\", \" \") AS NAME, COUNT(1) AS VAL from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id "
									        . " JOIN uac_showuser uas ON mu.username = uas.username "
                          . " WHERE ass.status = 'ABS' "
											    . " GROUP BY mu.firstname, mu.lastname, ass.status ORDER BY COUNT(1) DESC LIMIT 100; ";
        $logger->debug("Show me mis_query_pp: " . $mis_query_pp);

        $query_report = " SELECT UPPER(mu.username) AS USERNAME, REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), \"'\", \" \") AS NAME, "
									        . " CASE WHEN ass.status = 'ABS' THEN 'Absent(e)' WHEN ass.status = 'LAT' THEN 'Retard' WHEN ass.status = 'QUI' THEN 'Quitté' ELSE 'à l\'heure' END AS STATUS, "
                          . " CASE WHEN uel.day_code = 1 THEN 'Lundi' "
                          . " WHEN uel.day_code = 2 THEN 'Mardi' "
                          . " WHEN uel.day_code = 3 THEN 'Mercredi' "
                          . " WHEN uel.day_code = 4 THEN 'Jeudi' "
                          . " WHEN uel.day_code = 5 THEN 'Vendredi' "
                          . " ELSE 'Samedi' "
                          . " END AS JOUR, "
                          . " DATE_FORMAT(uel.day, '%d/%m') AS COURS_DATE, CONCAT(uel.hour_starts_at, 'h00') AS DEBUT_COURS, "
                          . " CONCAT(vcc.niveau, '/', vcc.mention, '/', vcc.parcours, '/', vcc.groupe) AS CLASSE, REPLACE(REPLACE(uel.raw_course_title, '\n', ' - '), ',', '') AS COURS_DETAILS "
                          . " FROM uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id JOIN uac_edt_line uel ON uel.id = ass.edt_id JOIN uac_showuser uas ON mu.username = uas.username "
                          . " JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id WHERE ass.status IN ('ABS', 'LAT', 'QUI') ORDER BY uel.day DESC LIMIT 2000; ";
        $logger->debug("Show me query_report: " . $query_report);


        $query_course_report = " SELECT * FROM rep_course_dash; ";
        $logger->debug("Show me query_course_report: " . $query_course_report);


        $query_lastupd = " select DATE_FORMAT(MAX(last_update), '%d-%m-%Y à %Hh%i') AS LASTUPDATE from uac_working_flow where flow_code IN ('ASSIDUI') order by 1 desc; ";
        $logger->debug("Show me query_lastupd: " . $query_lastupd);


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_stat_late = $dbconnectioninst->query($late_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_stat_late));


        $result_stat_mis = $dbconnectioninst->query($mis_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_stat_mis));

        $result_stat_mis_pp = $dbconnectioninst->query($mis_query_pp)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_stat_mis_pp));

        $result_report = $dbconnectioninst->query($query_report)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_report));

        $result_course_report = $dbconnectioninst->query($query_course_report)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_course_report));

        $result_lastupd = $dbconnectioninst->query($query_lastupd)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_lastupd));


        $content = $twig->render('Admin/EDT/dashboardass.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'stats_late'=>$result_stat_late,
                                                                  'stats_mis'=>$result_stat_mis,
                                                                  'stats_mis_pp'=>$result_stat_mis_pp,
                                                                  'result_report'=>$result_report,
                                                                  'result_course_report'=>$result_course_report,
                                                                  'result_lastupd'=>$result_lastupd,
                                                                  'scale_right' => ConnectionManager::whatScaleRight(),
                                                                  'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }



  public function showedt(Environment $twig, LoggerInterface $logger, $master_id)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("Enter the show ! ");

    //Check if we are coming from POST
    if(isset($_POST["postmaster_id"]))
    {
        // Get data from ajax
        $logger->debug("See postmaster_id: " . $_POST["postmaster_id"]);
        $master_id = $_POST["postmaster_id"];
    }


    // Level ONE is necessary to load EDT
    if($master_id == 0){
        // Error 404
        $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    else{
          if(isset($scale_right) && ($scale_right > 0)){
              $logger->debug("Firstname: " . $_SESSION["firstname"]);

              $dbconnectioninst = DBConnectionManager::getInstance();

              $import_query = "CALL CLI_GET_SHOWEDTForADM(" . $master_id . ")";
              $resultsp = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

              $content = $twig->render('Admin/EDT/showedt.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                        'firstname' => $_SESSION["firstname"],
                                                                        'lastname' => $_SESSION["lastname"],
                                                                        'id' => $_SESSION["id"],
                                                                        "sp_result"=>$resultsp,
                                                                        'scale_right' => ConnectionManager::whatScaleRight(),
                                                                        'errtype' => '', 'master_id' => $master_id]);

          }
          else{
              // Error Code 404
              $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
          }
    }
    return new Response($content);
  }

  public function validateedt(Environment $twig, LoggerInterface $logger, $master_id)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()


    $zip_list_validate = '';
    $is_zip = 'N';
    //Check if we are coming from POST
    if(isset($_POST["postzip_val"]))
    {
        // Get data from ajax
        $logger->debug("See postzip_val: " . $_POST["postzip_val"]);
        $zip_list_validate = $_POST["postzip_val"];
        $is_zip = 'Y';
    }

    $scale_right = ConnectionManager::whatScaleRight();


    // Level ONE is necessary to load EDT
    if(isset($scale_right) && ($scale_right > 0)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $validate_queue = "UPDATE uac_working_flow uwf SET uwf.status = 'QUE' WHERE uwf.flow_code = 'QUEASSI' AND uwf.status = 'NEW' AND uwf.filename IN (SELECT p2._filename FROM (SELECT uac_working_flow.filename AS _filename, uac_edt_master.id AS _id  FROM uac_working_flow JOIN uac_edt_master ON uac_edt_master.flow_id = uac_working_flow.id) p2 WHERE p2._id ";

        if($is_zip ==  'N'){
            $validate_query = "UPDATE uac_edt_master SET visibility = 'V' WHERE id =" . $master_id . ";";
            $validate_queue = $validate_queue . " IN (" . $master_id . "));";
        }
        else{
            $validate_query = "UPDATE uac_edt_master SET visibility = 'V' WHERE id IN (" . $zip_list_validate . ");";
            $validate_queue = $validate_queue . " IN (" . $zip_list_validate . "));";
        }
        $logger->debug("validate_queue: " . $validate_queue);

        // Be carefull if you have array of array
        $dbconnectioninst = DBConnectionManager::getInstance();

        $result = $dbconnectioninst->query($validate_queue)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result));

        $result = $dbconnectioninst->query($validate_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result));




        $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'scale_right' => ConnectionManager::whatScaleRight(),
                                                                  'errtype' => '', 'validated' => $master_id]);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }



  public function manageredt(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    if(isset($scale_right) && ($scale_right > 4)){


        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $query_all_edt = "CALL CLI_GET_MngEDTp3()";


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_edt = $dbconnectioninst->query($query_all_edt)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_edt));



        $content = $twig->render('Admin/EDT/manageredt.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'all_edt' => $result_all_edt,
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }


  /* ***************************************************************** */
  /* ***************************************************************** */
  /* ***************************************************************** */
  /* *********************** LOADER ********************************** */
  /* ***************************************************************** */
  /* ***************************************************************** */
  /* ***************************************************************** */


  public function loadedt(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    if(isset($scale_right) && ($scale_right > 0)){


        $logger->debug("Firstname: " . $_SESSION["firstname"]);



        $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }




  public function checkandloadedt(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();
    if(isset($scale_right) && ($scale_right > 0)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);


        $zip_results = array();
        $zip_comments = '';
        $zip_all_master_id_inq = '0'; // looks like 0, 12, 13, 16, 16

        $logger->debug("Filename: " . $_FILES['fileToUpload']['name']);
        if (strlen($_FILES['fileToUpload']['name']) == 0){
            $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1115 Le Fichier est vide.</span>' . '<br>',
                                            "extract_queries"=>"Erreur Lecture de fichier.<br>");
            $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'errtype' => '', 'nofile' => 'nofile']);

        } else {
              if (str_ends_with($_FILES['fileToUpload']['name'], '.csv')) {
                  // We are in one file mode
                  $result_for_one_file = $this->extractFileInsertLines('.csv', $_FILES['fileToUpload'], null, 0, null, $logger, $scale_right);

              } elseif (str_ends_with($_FILES['fileToUpload']['name'], '.zip')) {
                  // We are in zip mode
                  // Work on the zip
                  $zip = new ZipArchive;
                  $zip_rawfilename_loaded = $_FILES["fileToUpload"]["tmp_name"];
                  $logger->debug("Number of file: " . $zip_rawfilename_loaded);

                  if (($zip_rawfilename_loaded != null) && ($zip->open($zip_rawfilename_loaded) === TRUE))
                  {
                       $logger->debug("We have opened the file ");
                       $logger->debug("Number of file: " . $zip->numFiles);
                       $count_csv = 0;

                       for($i = 0; $i < $zip->numFiles; $i++){
                         $stat = $zip->statIndex($i);
                         if(!(str_starts_with(basename( $stat['name']), '.')) &&
                                  (str_ends_with(basename( $stat['name']), '.csv'))){
                                      $count_csv = $count_csv + 1;
                                  }
                       }

                       $zip_comments = '<span class="icon-arrow-down nav-icon-fa nav-text"></span>&nbsp; Fichier(s) lu(s): ' . $count_csv . '<br>' . $zip_comments;

                       if($count_csv < $_ENV['ZIP_LIMIT']){
                           for($i = 0; $i < $zip->numFiles; $i++)
                           {
                             $stat = $zip->statIndex($i);
                             //$logger->debug("Here is one file: " . basename( $stat['name']));
                             if(!(str_starts_with(basename( $stat['name']), '.')) &&
                                      (str_ends_with(basename( $stat['name']), '.csv'))){

                                $logger->debug("Look to open: " . basename( $stat['name']));

                                /********************************************************************************/
                                /********************************************************************************/
                                /********************************************************************************/
                                /******************************  DO THE WORK ************************************/
                                /********************************************************************************/
                                /********************************************************************************/
                                /********************************************************************************/
                                // We iterate thru the file

                                $result_for_one_file = $this->extractFileInsertLines('.zip', null, $zip, $i, basename( $stat['name']), $logger, $scale_right);
                                array_push($zip_results, $result_for_one_file);
                                $zip_comments = $zip_comments . '<br>' . $result_for_one_file['zip_one_comment'];

                                // We do quiet error here. Most of the time when the access is current week
                                // If we have at least 1 value
                                if(count($result_for_one_file['sp_result']) > 0){
                                    $zip_all_master_id_inq = $zip_all_master_id_inq . ', ' . $result_for_one_file['sp_result'][0]['master_id'];
                                }

                                /*
                                $fp = $zip->getStream($zip->getNameIndex($i));
                                $logger->debug("Read fp: " . $fp);
                                $logger->debug("******************************************************************");
                                if(!$fp) exit("failed\n");
                                while ((($data = fgetcsv($fp, 1000, ",")) !== FALSE)){



                                    $logger->debug("See content: " . $data[0] . '/' . $data[1]);
                                }
                                fclose($fp);
                                */


                             }
                           }
                       }
                       else{
                         $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;Nombre de fichier .csv maximum possible ' . $_ENV['ZIP_LIMIT'] . '/ Le fichier ' . $_FILES['fileToUpload']['name'] . ' en contient ' . $count_csv . '.</span>' . '<br>',
                                                      "extract_queries"=>"Veuillez recharger avec un Zip qui contient moins de fichiers.", "sp_result"=>null);

                       }
                  }
                  else
                  {
                       $logger->debug("Erreur lecture archive zip: " . $zip_rawfilename_loaded);
                       $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR789 de lecture fichier zip: ' . $zip_rawfilename_loaded . '</span>' . '<br>',
                                                       "extract_queries"=>"<br>Nous attendons un .zip ou un .csv <br> Vérifiez que également <strong>que le fichier .zip ne contient que des fichiers .csv</strong>", "sp_result"=>null);
                  }





              } else {
                  // Error
                  $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR11282 Le fichier ' . $_FILES['fileToUpload']['name'] . ' n\'est pas lisible.</span>' . '<br>',
                                                  "extract_queries"=>"Erreur Lecture de fichier.<br>Nous attendons un .csv", "sp_result"=>null);
              }
              $content = $twig->render('Admin/EDT/afterloadreport.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                'firstname' => $_SESSION["firstname"],
                                                                                'lastname' => $_SESSION["lastname"],
                                                                                'id' => $_SESSION["id"],
                                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                                'result_for_one_file' => $result_for_one_file,
                                                                                /*
                                                                                'reportcmt' => $result_for_one_file['extract_report'],
                                                                                'reportqueries' => $result_for_one_file['extract_queries'],
                                                                                'sp_result' => $result_for_one_file['sp_result'],
                                                                                */

                                                                                'zip_results' => $zip_results,
                                                                                'zip_comments' => '<div class="ace-sm report-val">' . $zip_comments . '</div>',
                                                                                'zip_all_master_id_inq' => $zip_all_master_id_inq]
                                                                              );
        }





    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }




  public function extractFileInsertLines($load_type, $load_file, $load_zip, $i_zip, $zip_inside_filename, LoggerInterface $logger, $scale_right){
          /**************************** START : CHECK THE FILE CONTENT HERE ****************************/

          $report_comment = '';
          $zip_one_comment = '';

          $report_queries = '';
          $insert_lines = '';
          $mention = '';
          $niveau = '';
          $parcours = '';
          $groupe = '';
          $monday = '';
          $tuesday = '';
          $wednesday = '';
          $thursday = '';
          $friday = '';
          $saturday = '';
          $days = array();
          $insert_queries = array();
          $resultsp = array();
          $overpassday = '';
          // Code is valid here. We can work
          if (($load_type == '.csv') && (!file_exists($load_file['tmp_name']))) {
            $report_comment =  '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1728 Erreur lecture fichier.</span>' . '<br>'
                                              . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                              . 'Il semble que le fichier que vous avez chargé n\'existe pas.' . '<br>'
                                              . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>' . $report_comment;
          }
          else{
            // Properly do the importation here
            if (($load_type == '.csv') && (is_uploaded_file($load_file['tmp_name']))) {
              $report_comment = $report_comment . '<br>' . "<div class='report-title'>" . "<span class='icon-check-square nav-icon-fa nav-text'></span>&nbsp;Fichier .csv : ". $load_file['name'] ."<br>Traces techniques:" . "</div>";
            }
            else{
              $report_comment = $report_comment . '<br>' . "<div class='report-title'>" . "<span class='icon-check-square nav-icon-fa nav-text'></span>&nbsp;Fichier intérieur au .zip : ". $zip_inside_filename ."<br>Traces techniques:" . "</div>";
            }

            $report_comment = $report_comment . '<br><hr>' . 'Ligne(s) lue(s)<br/>';

            //Import uploaded file to Database
            $filename_to_log_in = 'na';
            if($load_type == '.csv'){
                // We are in .csv mode
                $handle = fopen($load_file['tmp_name'], "r");
                $filename_to_log_in = $_FILES['fileToUpload']['name'];
            }
            else{
                // we are in .zip mode
                $handle = $load_zip->getStream($load_zip->getNameIndex($i_zip));
                $filename_to_log_in = 'zip/' . $zip_inside_filename;
            }

            $i = 1;
            $file_is_still_valid = true;
            $report_comment = $report_comment . '<div class="ace-sm report-val">';
            $max_cell_length = 129;

            try {


                    while ((($data = fgetcsv($handle, 1000, ",")) !== FALSE) && $file_is_still_valid) {
                      // read the whole file
                      // Read Fixed valuable data
                      if ( $i ==  1){
                          $mention = $data[1];
                          $parcours = $data[3];
                      }
                      if ( $i ==  2){
                          $niveau = $data[1];
                          $groupe = $data[3];
                      }
                      if ( $i ==  6){
                          $read_date = explode("/", $data[1]);
                          $monday = $read_date[2] . '-' . $read_date[1] . '-' . $read_date[0];
                          if(date('w', strtotime($monday)) != 1){
                              $file_is_still_valid = false;
                              $logger->debug('Monday: ' . date('w', strtotime($monday)) . '/' . $monday);
                          }

                          $read_date = explode("/", $data[2]);
                          $tuesday = $read_date[2] . '-' . $read_date[1] . '-' . $read_date[0];
                          if(date('w', strtotime($tuesday)) != 2){
                              $file_is_still_valid = false;
                              $logger->debug('Tuesday: ' . date('w', strtotime($tuesday)) . '/' . $tuesday);
                          }

                          $read_date = explode("/", $data[3]);
                          $wednesday = $read_date[2] . '-' . $read_date[1] . '-' . $read_date[0];
                          if(date('w', strtotime($wednesday)) != 3){
                              $file_is_still_valid = false;
                              $logger->debug('Wednesday: ' . date('w', strtotime($wednesday)) . '/' . $wednesday);
                          }

                          $read_date = explode("/", $data[4]);
                          $thursday = $read_date[2] . '-' . $read_date[1] . '-' . $read_date[0];
                          if(date('w', strtotime($thursday)) != 4){
                              $file_is_still_valid = false;
                              $logger->debug('Thursday: ' . date('w', strtotime($thursday)) . '/' . $thursday);
                          }

                          $read_date = explode("/", $data[5]);
                          $friday = $read_date[2] . '-' . $read_date[1] . '-' . $read_date[0];
                          if(date('w', strtotime($friday)) != 5){
                              $file_is_still_valid = false;
                              $logger->debug('Friday: ' . date('w', strtotime($friday)) . '/' . $friday);
                          }


                          $read_date = explode("/", $data[6]);
                          $saturday = $read_date[2] . '-' . $read_date[1] . '-' . $read_date[0];
                          if(date('w', strtotime($saturday)) != 6){
                              $file_is_still_valid = false;
                              $logger->debug('Saturday: ' . date('w', strtotime($saturday)) . '/' . $saturday);
                          }

                          // Prepare Array for work
                          array_push($days, 'na', $monday, $tuesday, $wednesday, $thursday, $friday, $saturday);

                          if(!$file_is_still_valid){
                            $report_comment =  '<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR112 Erreur lecture fichier : Les jours ne correspondent pas aux dates</span>' . '<br>'
                                                              . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                                              . 'Vérifiez que les jours sont bons : <i class="err">Est-ce que ' . $data[1] . ' est bien un lundi ?</i> <br>'
                                                              . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>' . $report_comment;
                          }
                      }

                      // Courses are starting at 7
                      if($i > 6){
                          // Now line by line $i is the hour
                          // Shift is [mention][niveau][Jour][Heure début][Cours][Durée]
                          for ($k = 1; $k <= 6; $k++) {
                              $logger->debug('i/k: ' . $i . '/' . $k);

                              // Initiate the line
                              $raw_course_title = 'NULL';
                              $insert_lines = $insert_lines . '<br>' . $mention . '/' . $niveau . '/' . date('l', strtotime($days[$k])) . ':' . $days[$k] . '/' . $i ;
                              $course_details = array();
                              $kduration = '';
                              $hduration = 0;
                              $verify_duration = '';
                              switch ($data[$k]) {
                                  case '':
                                      $insert_lines = $insert_lines . 'h/Shift vide';
                                      $kduration = 'NULL';
                                      break;
                                  default:
                                      $insert_lines = $insert_lines . 'h/[' . $data[$k] . ']' ;
                                      $raw_course_title = ltrim($data[$k],"\n");
                                      $raw_course_title = rtrim($raw_course_title,"\n");
                                      $raw_course_title = str_replace('"', "", $raw_course_title);
                                      $raw_course_title = str_replace("'", "", $raw_course_title);
                                      // Check the size of raw course raw_course_title
                                      if(strlen($raw_course_title) > $max_cell_length){
                                          $file_is_still_valid = false;
                                          $report_comment =  '<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR4523 Erreur la cellule en : ligne ' . $i . ' - colonne ' . $k . ' est trop longue. Elle fait ' . strlen($raw_course_title) - $max_cell_length . ' caractères de trop.</span>' . '<br>'
                                                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                                                            . 'Veuillez réduire la taille du texte.<br>'
                                                                            . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>' . $report_comment;
                                          $resultsp = array();
                                      }
                                      $course_details = explode("\n", $raw_course_title);
                                      $kduration = '\'' . $course_details[count($course_details) - 1] . '\'';
                                      $verify_duration = preg_match("/[1]?[0-9][h](30|15)?$/", trim($course_details[count($course_details) - 1]));
                                      if($verify_duration == 0){
                                          // The duration does not match
                                          $file_is_still_valid = false;
                                          $report_comment = $report_comment . '<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR9012 Erreur de lecture de durée près de : ligne ' . $i . ' - colonne ' . ($k + 1) . '. Vérifiez bien que vous avez un h minuscule comme par exemple 4h.</span>' . '<br>'
                                                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                                                            . 'Les durées doivent être de la forme Xh ou XXh ou XXh30 - exemple 2h30 ou 1h.<br>'
                                                                            . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>';

                                      }
                                      // We take only the hour
                                      $hduration = explode("h", trim($course_details[count($course_details) - 1]))[0];
                                      $raw_course_title = '\'' . $raw_course_title . '\'';

                                      $logger->debug('Read course: ' . count($course_details) . '/' . $data[$k]);
                              }

                              $my_insert_query = 'INSERT INTO uac_load_edt (user_id, status, filename, mention, niveau, monday_ofthew, label_day, day, day_code, hour_starts_at, raw_duration, duration_hour, log_pos, raw_course_title)' .
                                                    'VALUES ( ' . $_SESSION["id"] . ', \'NEW\', \'' . $filename_to_log_in . '\', \'' . $mention . '\', \'' . $niveau  .'\', \'' . $monday . '\', UPPER(\'' .
                                                     date('l', strtotime($days[$k])) . '\'), \'' . $days[$k] . '\', ' . date('w', strtotime($days[$k])) . ', ' . $i . ', ' . $kduration . ', ' . $hduration . ', \'' . $i . ':' . $k . ':' . $verify_duration . '\', ' . $raw_course_title . ');';
                              array_push($insert_queries, $my_insert_query);
                          }
                      }




                      $report_comment = $report_comment . '<br>Line ' . $i . ' OK: ' . $data[0] . ' | '
                                                                                     . str_replace(array("\r", "\n"), '-<', $data[1])  . ' | '
                                                                                     . str_replace(array("\r", "\n"), '-<', $data[2])  . ' | '
                                                                                     . str_replace(array("\r", "\n"), '-<', $data[3])  . ' | '
                                                                                     . str_replace(array("\r", "\n"), '-<', $data[4])  . ' | '
                                                                                     . str_replace(array("\r", "\n"), '-<', $data[5])  . ' | '
                                                                                     . str_replace(array("\r", "\n"), '-<', $data[6]);

                      $i = $i + 1;
                    }


                    fclose($handle);

                    // Read data
                    $report_comment = $report_comment . '<br><br>'. 'Mention: ' . $mention . '<br>'
                                                      . 'Niveau: ' . $niveau . '<br>'
                                                      . 'Parcours: ' . $parcours . '<br>'
                                                      . 'Groupe: ' . $groupe . '<br>'
                                                      . 'Lundi: ' . $monday . '<br>'
                                                      . 'Mardi: ' . $tuesday . '<br>'
                                                      . 'Mercredi: ' . $wednesday . '<br>'
                                                      . 'Jeudi: ' . $thursday . '<br>'
                                                      . 'Vendredi: ' . $friday . '<br>'
                                                      . 'Samedi: ' . $saturday . '<br><hr><br>'
                                                      . 'Nombre de lignes de Emploi du Temps: ' . ($i - 1) . '<br>'
                                                      . $insert_lines;



                    /**************************************************************/
                    // We cannot upload a file for the current week
                    $current_date = date("Y-m-d", time());
                    //$date = "2022-09-27";
                    if ($monday > $current_date){
                      // Everything is fine as we look to upload in future
                    }
                    elseif($scale_right > 10){
                      // It is still OK
                      $overpassday = date("d/m/Y", time());
                    }
                    else{
                      $file_is_still_valid = false;
                      $zip_one_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERRB192 Erreur : vous ne pouvez pas charger d\'emploi du temps pour une semaine en cours ou passée ' . $monday . '. Si cette opération est nécessaire, vous devez utilisez un login avec des droits de hierarchie 11. Vos droits actuels sont de ' . $scale_right . '.</span>' . '<br>';

                      $report_comment =  '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERRB192 Erreur : vous ne pouvez pas charger d\'emploi du temps pour une semaine en cours ou passée.</span>' . '<br>'
                                                        . 'Semaine chargée : ' . $monday . ' Nous sommes le: ' . $current_date . '<br><br>'
                                                        . 'Désolé ! <span class="err">Si cette opération est nécessaire, vous devez avoir les droits de priorité 11. Vos droits actuels sont de ' . $scale_right . '.</span>. Contactez nous dans ce cas. ' . '<br>'
                                                        . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                        . $report_comment;

                    }

                    /**************************************************************/






                    if($file_is_still_valid){
                      // Do the DB Load operation here
                      $dbqueries_insert = '';
                      for($j = 0;$j < count($insert_queries);$j++){
                        $report_queries = $report_queries . '<br>' . $insert_queries[$j];
                        $dbqueries_insert = $dbqueries_insert . ' ' . $insert_queries[$j];
                      }



                      // Be carefull if you have array of array
                      $dbconnectioninst = DBConnectionManager::getInstance();

                      $result = $dbconnectioninst->query($dbqueries_insert)->fetchAll(PDO::FETCH_ASSOC);

                      $logger->debug("Show me: " . count($result));

                      // Perform the importation
                      // Change the option here !
                      //`SRV_CRT_EDT` (IN param_filename VARCHAR(300), IN param_monday_date DATE, IN param_mention VARCHAR(100), IN param_niveau CHAR(2), IN param_uaparcours VARCHAR(100), IN param_uagroupe VARCHAR(100))
                      $import_query = "CALL SRV_CRT_EDT('" . $filename_to_log_in . "', '" . $monday . "', '" . $mention . "', '" . $niveau . "', '" . $parcours . "', '" . $groupe . "')";
                      $logger->debug("Here is import_query: " . $import_query);
                      $resultsp = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);



                      $report_queries = '<br><hr><div class="ace-sm report-val"> Nombre des input: ' . count($insert_queries) . '<br><br>' . $report_queries . '<br><br><br><br>' . $import_query . '</div>';
                      $report_comment = $report_comment . '<br><span class="icon-check-square nav-icon-fa nav-text"></span>&nbsp;Chargement en DB. Return count: ' . count($resultsp)  . '<br>';

                      $zip_one_comment = 'Chargement OK pour ' . $filename_to_log_in . ' /nbr lg: ' . count($resultsp) . ' ' . $zip_one_comment;

                      // If we return the empty line means the course has not been found
                      if(count($resultsp) == 1){
                          $report_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR182C Erreur Nous ne pouvons pas identifier la classe de l\'emploi du temps. Veuillez vérifier qu\'elle existe.</span>' . '<br>'
                                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br><br>'
                                                            . 'Vérifiez Mention: <strong>' . $mention . '</strong><br>'
                                                            . 'Vérifiez Niveau: <strong>' . $niveau . '</strong><br>'
                                                            . 'Vérifiez Parcours: <strong>' . $parcours . '</strong><br>'
                                                            . 'Vérifiez Groupe: <strong>' . $groupe . '</strong><br><br>'
                                                            . 'Nous n\'arrivons pas à identifier la classe.<br>'
                                                            . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                            . $report_comment;
                      }
                      if(count($resultsp) == 0){
                          $report_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR187G Erreur Nous n\'arrivons pas à enregistrer l\'emploi du temps, veuillez contacter le support technique.</span>' . '<br>'
                                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br><br>'
                                                            . 'Vérifiez Mention: <strong>' . $mention . '</strong><br>'
                                                            . 'Vérifiez Niveau: <strong>' . $niveau . '</strong><br>'
                                                            . 'Vérifiez Parcours: <strong>' . $parcours . '</strong><br>'
                                                            . 'Vérifiez Groupe: <strong>' . $groupe . '</strong><br><br>'
                                                            . 'Nous n\'arrivons pas à identifier la classe.<br>'
                                                            . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                            . $report_comment;
                      }
                    }
                    else{
                      // Display the error here
                      $report_comment = '<br>Error8927 when load in DB.' . $report_comment;
                    }

            } catch (\Exception $e) {
                $report_comment =  '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1724 Erreur lecture fichier : ' . $e->getMessage() . '</span>' . '<br>'
                                                  . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                                  . 'Il semble que le fichier ne soit pas un csv.<br>'
                                                  . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                  . $report_comment;
            }

            $report_comment = $report_comment . '</div>';
          }
          /**************************** END : CHECK THE FILE CONTENT HERE ****************************/

          return array("extract_report"=>$report_comment,
                        "extract_queries"=>$report_queries,
                        "sp_result"=>$resultsp,
                        "overpassday"=>$overpassday,
                        "zip_one_comment" => $zip_one_comment);

  }

}

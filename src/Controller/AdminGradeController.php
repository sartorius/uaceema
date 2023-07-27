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

class AdminGradeController extends AbstractController{
    private static $my_exact_access_right = 41;
    private static $my_minimum_access_right = 39;

    public function addgradetoexam(Environment $twig, LoggerInterface $logger){
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
    
        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);
            $logger->debug("****************************************************************");

            $result_get_token = $this->getDailyTokenGRAStr($logger);

            $allusr_query = " SELECT vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME, 'x' AS HID_GRA FROM v_showuser vsh where vsh.cohort_id = 26 ORDER BY VSH_FIRSTNAME ASC; ";
            $logger->debug("Show me allusr_query: " . $allusr_query);

            $dbconnectioninst = DBConnectionManager::getInstance();
            $result_all_usr = $dbconnectioninst->query($allusr_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_all_usr));


            $param_limit_page_query = " SELECT par_int AS PG_LIMIT FROM uac_param WHERE key_code = 'GRASTUL'; ";
            $logger->debug("Show me param_limit_page_query: " . $param_limit_page_query);
            $result_param_limit_page = $dbconnectioninst->query($param_limit_page_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_param_limit_page: " . $result_param_limit_page[0]['PG_LIMIT']);
            
            $mention_query = " SELECT * FROM uac_ref_mention; ";
            $logger->debug("Show me mention_query: " . $mention_query);
            $result_mention_query = $dbconnectioninst->query($mention_query)->fetchAll(PDO::FETCH_ASSOC);

            $allclass_query = " SELECT * FROM v_class_cohort; ";
            $logger->debug("Show me allclass_query: " . $allclass_query);
            $result_allclass_query = $dbconnectioninst->query($allclass_query)->fetchAll(PDO::FETCH_ASSOC);

            $count_stu_query = " SELECT COHORT_ID AS COHORT_ID, COUNT(1) AS CPT_STU FROM v_showuser GROUP BY COHORT_ID; ";
            $logger->debug("Show me count_stu_query: " . $count_stu_query);
            $result_count_stu_query = $dbconnectioninst->query($count_stu_query)->fetchAll(PDO::FETCH_ASSOC);

            $teacher_query = " SELECT urt.id, xm.mention_code, urt.name FROM uac_ref_teacher urt JOIN uac_xref_teacher_mention xm ON xm.teach_id = urt.id;";
            $logger->debug("Show me usedroom_query: " . $teacher_query);
            $result_teacher_query = $dbconnectioninst->query($teacher_query)->fetchAll(PDO::FETCH_ASSOC);

            $page_maximum = intval(count($result_all_usr) / $result_param_limit_page[0]['PG_LIMIT']);
            if((count($result_all_usr) % $result_param_limit_page[0]['PG_LIMIT']) > 0){
                $page_maximum = $page_maximum + 1;
            }


            $content = $twig->render('Admin/GRA/addgradetoexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_get_token' => $result_get_token,
                                                                'result_mention_query'=>$result_mention_query,
                                                                'result_allclass_query'=>$result_allclass_query,
                                                                'result_count_stu_query'=>$result_count_stu_query,
                                                                "result_teacher_query"=>$result_teacher_query,
                                                                'result_all_usr' => $result_all_usr,
                                                                'page_limit' => $result_param_limit_page[0]['PG_LIMIT'],
                                                                'page_maximum' => $page_maximum,
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


    public function loadgrascan(Environment $twig, LoggerInterface $logger){
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
    
        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);
            $logger->debug("****************************************************************");

            $dbconnectioninst = DBConnectionManager::getInstance();
            $param_limit_jpg_query = " SELECT par_int AS JPG_LIMIT FROM uac_param WHERE key_code = 'GRAJPGL'; ";
            $logger->debug("Show me param_limit_page_query: " . $param_limit_jpg_query);
            $result_param_limit_jpg_query = $dbconnectioninst->query($param_limit_jpg_query)->fetchAll(PDO::FETCH_ASSOC);
            //$logger->debug("Show me param_limit_page_query: " . $result_param_limit_jpg_query[0]['JPG_LIMIT']);

            $param_limit_page_query = " SELECT par_int AS PG_LIMIT FROM uac_param WHERE key_code = 'GRASTUL'; ";
            $logger->debug("Show me param_limit_page_query: " . $param_limit_page_query);
            $result_param_limit_page = $dbconnectioninst->query($param_limit_page_query)->fetchAll(PDO::FETCH_ASSOC);
            //$logger->debug("Show me result_param_limit_page: " . $result_param_limit_page[0]['PG_LIMIT']);
            

            $mention_query = " SELECT * FROM uac_ref_mention; ";
            $logger->debug("Show me mention_query: " . $mention_query);
            $result_mention_query = $dbconnectioninst->query($mention_query)->fetchAll(PDO::FETCH_ASSOC);

            $teacher_query = " SELECT urt.id, xm.mention_code, urt.name FROM uac_ref_teacher urt JOIN uac_xref_teacher_mention xm ON xm.teach_id = urt.id;";
            $logger->debug("Show me usedroom_query: " . $teacher_query);
            $result_teacher_query = $dbconnectioninst->query($teacher_query)->fetchAll(PDO::FETCH_ASSOC);

            // * *********** * *********** * *********** * *********** * *********** * *********** * ***********
            // * *********** * *********** * *********** * *********** * *********** * *********** * ***********
            // * *********** * *********** * *********** * *********** * *********** * *********** * ***********
            // Manage the subject selection *********** * *********** * *********** * *********** * ************
            // * *********** * *********** * *********** * *********** * *********** * *********** * ***********
            // * *********** * *********** * *********** * *********** * *********** * *********** * ***********
            // * *********** * *********** * *********** * *********** * *********** * *********** * ***********

            $nivsemester_query = " SELECT DISTINCT urs.mention_code AS URS_MENTION_CODE, CONCAT(urs.niveau_code, '/', urs.semester) AS URS_NIVSEM FROM uac_ref_subject urs ORDER BY 1, 2; ";
            $logger->debug("Show me nivsemester_query: " . $nivsemester_query);
            $result_nivsemester_query = $dbconnectioninst->query($nivsemester_query)->fetchAll(PDO::FETCH_ASSOC);

            $title_per_niv_query = " SELECT urs.id AS URS_ID, urs.mention_code AS URS_MENTION_CODE, CONCAT(urs.niveau_code, '/', urs.semester) AS URS_NIVSEM, UPPER(fEscapeStr(urs.subject_title)) AS URS_SUBJECT_TITLE, "
                                    . " urs.credit AS URS_CREDIT FROM uac_ref_subject urs ORDER BY 1, 2; ";
            $logger->debug("Show me title_per_niv_query: " . $title_per_niv_query);
            $result_title_per_niv_query = $dbconnectioninst->query($title_per_niv_query)->fetchAll(PDO::FETCH_ASSOC);

            $class_per_subject_query = " SELECT urs.id AS URS_ID, GROUP_CONCAT(vcc.short_classe ORDER BY vcc.id ASC SEPARATOR ' + ') AS GRP_VCC_SHORT_CLASS, GROUP_CONCAT(vcc.ID SEPARATOR '|') AS GRP_VCC_ID FROM uac_ref_subject urs  "
                                        . " JOIN uac_xref_subject_cohort xref ON urs.id = xref.subject_id "
                                        . " JOIN v_class_cohort vcc ON vcc.id = xref.cohort_id GROUP BY urs.id; ";
            $logger->debug("Show me class_per_subject_query: " . $class_per_subject_query);
            $result_class_per_subject_query = $dbconnectioninst->query($class_per_subject_query)->fetchAll(PDO::FETCH_ASSOC);

            $nbr_of_stu_mod_query = " SELECT urs.id AS URS_ID, COUNT(1) AS CPT_STU, MOD(COUNT(1), " . $result_param_limit_page[0]['PG_LIMIT'] . ") AS CPT_MODULO FROM uac_ref_subject urs "
                                    . " JOIN uac_xref_subject_cohort xref ON urs.id = xref.subject_id "
                                    . " JOIN v_showuser vsh ON vsh.COHORT_ID = xref.cohort_id GROUP BY urs.id ORDER BY 1; ";
            $logger->debug("Show me nbr_of_stu_mod_query: " . $nbr_of_stu_mod_query);
            $result_nbr_of_stu_mod_query = $dbconnectioninst->query($nbr_of_stu_mod_query)->fetchAll(PDO::FETCH_ASSOC);

            $allstu_query = " SELECT UPPER(vsh.USERNAME) AS VSH_USERNAME, vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, vsh.COHORT_ID AS VSH_COHORT_ID from v_showuser vsh ORDER BY vsh.USERNAME ASC; ";
            $logger->debug("Show me allstu_query: " . $allstu_query);
            $result_allstu_query = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);

            $result_get_token = $this->getDailyTokenGRAStr($logger);


            $content = $twig->render('Admin/GRA/loadgrascan.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'jpg_limit' => $result_param_limit_jpg_query[0]['JPG_LIMIT'],
                                                                'page_limit' => $result_param_limit_page[0]['PG_LIMIT'],
                                                                'result_mention_query'=>$result_mention_query,
                                                                "result_teacher_query"=>$result_teacher_query,
                                                                // Subject selection are starting here
                                                                "result_nivsemester_query"=>$result_nivsemester_query,
                                                                "result_title_per_niv_query"=>$result_title_per_niv_query,
                                                                "result_class_per_subject_query"=>$result_class_per_subject_query,
                                                                "result_nbr_of_stu_mod_query"=>$result_nbr_of_stu_mod_query,
                                                                "result_allstu_query"=>$result_allstu_query,
                                                                "result_get_token"=>$result_get_token,
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }




    public function checkandloadgra(Environment $twig, LoggerInterface $logger)
    {
        $is_still_valid = true;
        $full_error_msg = '';
        $max_file_size = 0;

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);

            $maxziplimit = $_ENV['ZIP_LIMIT'];
            $zip_results = array();
            $zip_comments = '';
            $zip_all_master_id_inq = '0'; // looks like 0, 12, 13, 16, 16



            $logger->debug("*** GRA Filename: " . $_FILES['fileToUpload']['name']);
            $logger->debug("*** GRA fPageNbr: " . $_POST["fPageNbr"]);
            $logger->debug("*** GRA fSubToken: " . $_POST["fSubToken"]);

            if($_POST["fSubToken"] != $this->getDailyTokenGRAStr($logger)){
                $is_still_valid = false;
                $full_error_msg = $full_error_msg . 'Error728G - Contactez le support technique.<br>';
            }
            if ((!str_ends_with($_FILES['fileToUpload']['name'], '.zip')) && (!str_ends_with($_FILES['fileToUpload']['name'], '.jpg'))){
                $is_still_valid = false;
                $full_error_msg = $full_error_msg . 'Error729G - Seuls les fichiers .zip ou .jpg sont supportés.<br>';
            }
            if (strlen($_FILES['fileToUpload']['name']) == 0){
                $is_still_valid = false;
                $full_error_msg = $full_error_msg . 'Error730G - Le fichier lu est vide.<br>';
            }

            // If still OK then we retrieve max file size
            if($is_still_valid){
                $get_max_file_query = "SELECT par_int AS GRAMAX_SIZE FROM uac_param WHERE key_code = 'GRAJPGL';";
                $dbconnectioninst = DBConnectionManager::getInstance();
                $result_get_max_file_query = $dbconnectioninst->query($get_max_file_query)->fetchAll(PDO::FETCH_ASSOC);
                //$logger->debug("result_get_token: " . $result_get_max_file_query[0]["GRAMAX_SIZE"]);
            
                $max_file_size =  $result_get_max_file_query[0]["GRAMAX_SIZE"];
            }
            $logger->debug("*** GRA max_file_size: " . $max_file_size);
            $logger->debug("*** GRA file size: " . filesize($_FILES['fileToUpload']['tmp_name']));

            // If it is an unique file .jpg we check the size
            if (($is_still_valid) 
                    && (filesize($_FILES['fileToUpload']['tmp_name']) > $max_file_size*1000)
                    && (str_ends_with($_FILES['fileToUpload']['name'], '.jpg'))){
                        $is_still_valid = false;
                        $full_error_msg = $full_error_msg . 'Error731G - Le fichier ' . $_FILES['fileToUpload']['name'] . ' dépasse la taille de ' . $max_file_size . 'ko.<br>';
            }
            $logger->debug("*** GRA full_error_msg: " . $full_error_msg);
            
            // TODO : Keep going on file verification and loading
            
            /*
            if (strlen($_FILES['fileToUpload']['name']) == 0){
                $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1115 Le Fichier est vide.</span>' . '<br>',
                                                "extract_queries"=>"Erreur Lecture de fichier.<br>");
                $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                        'firstname' => $_SESSION["firstname"],
                                                                        'lastname' => $_SESSION["lastname"],
                                                                        'id' => $_SESSION["id"],
                                                                        'maxziplimit' => $maxziplimit,
                                                                        'scale_right' => ConnectionManager::whatScaleRight(),
                                                                        'errtype' => '', 'nofile' => 'nofile']);

            } else {
                if (str_ends_with($_FILES['fileToUpload']['name'], '.csv')) {
                    // We are in one file mode
                    $result_for_one_file = $this->extractFileInsertLines('.csv', $_FILES['fileToUpload'], null, 0, null, 1, $logger, $scale_right);

                } elseif (str_ends_with($_FILES['fileToUpload']['name'], '.zip')) {
                    // We are in zip mode
                    // Work on the zip
                    $zip = new ZipArchive;
                    $zip_rawfilename_loaded = $_FILES["fileToUpload"]["tmp_name"];
                    $logger->debug("Number of file: " . $zip_rawfilename_loaded);
                    $previsualisation_line_counter = 1;

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

                                    //********************************************************************************
                                    //********************************************************************************
                                    //********************************************************************************
                                    //******************************  DO THE WORK ************************************
                                    //********************************************************************************
                                    //********************************************************************************
                                    //********************************************************************************
                                    // We iterate thru the file


                                    $result_for_one_file = $this->extractFileInsertLines('.zip', null, $zip, $i, basename( $stat['name']), $previsualisation_line_counter, $logger, $scale_right);
                                    // we use previsualization counter only for the client
                                    $previsualisation_line_counter = $previsualisation_line_counter + 1;

                                    array_push($zip_results, $result_for_one_file);
                                    $status_msg = '<strong><span class="icon-check-square nav-icon-fa-sm nav-text"></span>&nbsp; Attente de validation</strong>';
                                    if($result_for_one_file['short_err'] != ''){
                                    $status_msg = '<i class="err"><strong><span class="icon-exclamation-circle nav-icon-fa-sm nav-text"></span>&nbsp;' . $result_for_one_file['short_err'] . '.&nbsp;Ce fichier ne sera pas chargé.</strong></i>';
                                    }
                                    $zip_comments = $zip_comments . '<br>' . $result_for_one_file['zip_one_comment'] . '&nbsp;' . $status_msg . '' ;

                                    // We do quiet error here. Most of the time when the access is current week
                                    // If we have at least 1 value
                                    if(count($result_for_one_file['sp_result']) > 0){
                                        $zip_all_master_id_inq = $zip_all_master_id_inq . ', ' . $result_for_one_file['sp_result'][0]['master_id'];
                                    }
                                }
                            }
                        }
                        else{

                            $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR671 Nombre de fichier .csv maximum possible ' . ($_ENV['ZIP_LIMIT'] - 1) . '/ Le fichier ' . $_FILES['fileToUpload']['name'] . ' en contient ' . $count_csv . '.</span>' . '<br>',
                                                        "extract_queries"=>"Veuillez recharger avec un Zip qui contient moins de fichiers.", "sp_result"=>null, "overpassday"=>null);

                        }
                    }
                    else
                    {
                        $logger->debug("Erreur lecture archive zip: " . $zip_rawfilename_loaded);
                        $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR789 de lecture fichier zip: ' . $zip_rawfilename_loaded . '</span>' . '<br>',
                                                        "extract_queries"=>"<br>Nous attendons un .zip ou un .csv <br> Vérifiez que également <strong>que le fichier .zip ne contient que des fichiers .csv</strong>", "sp_result"=>null, "overpassday"=>null);
                    }





                } else {
                    // Error
                    $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR11282 Le fichier ' . $_FILES['fileToUpload']['name'] . ' n\'est pas lisible.</span>' . '<br>',
                                                    "extract_queries"=>"Erreur Lecture de fichier.<br>Nous attendons un .csv", "sp_result"=>null, "overpassday"=>null);
                }
                $content = $twig->render('Admin/GRA/afterloadreport.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                    'firstname' => $_SESSION["firstname"],
                                                                                    'lastname' => $_SESSION["lastname"],
                                                                                    'id' => $_SESSION["id"],
                                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                                    'result_for_one_file' => $result_for_one_file,
                                                                                    'zip_results' => $zip_results,
                                                                                    'zip_comments' => '<div class="ace-sm report-val">' . $zip_comments . '</div>',
                                                                                    'zip_all_master_id_inq' => $zip_all_master_id_inq]
                                                                                );
            }
            */





        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/
    /********************************************************************************************************/

    public function exampleFunction(Environment $twig, LoggerInterface $logger){
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
    
        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);
            $logger->debug("****************************************************************");


            $content = $twig->render('Admin/GRA/addgradetoexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
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

    private function getDailyTokenGRAStr(LoggerInterface $logger){
        // Get me the token !
        $get_token_query = "SELECT fGetDailyTokenGEN() AS TOKEN;";
        $logger->debug("Show me get_token_query: " . $get_token_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_get_token = $dbconnectioninst->query($get_token_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("result_get_token: " . $result_get_token[0]["TOKEN"]);
    
        return $result_get_token[0]["TOKEN"];
    }


}
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

    private static $my_gra_repository = "/img/ace_gra";

    

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

            
            

            if((isset($_POST["read-master-id"]))
                && ($_POST["read-master-id"] != null)){

                $post_master_id = $_POST["read-master-id"];

                $dbconnectioninst = DBConnectionManager::getInstance();
    
                $get_exam_query = " SELECT * FROM v_master_exam WHERE UGM_ID = " . $post_master_id . "; ";
                $logger->debug("Show me get_exam_query: " . $get_exam_query);
                $result_get_exam_query = $dbconnectioninst->query($get_exam_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_get_exam_query: " . count($result_get_exam_query));
    
                $inv_subject_id = $result_get_exam_query[0]['UGM_SUBJECT_ID'];
    
                // TODO Review list of stu
                $allusr_query = " SELECT vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME, 'x' AS HID_GRA FROM v_showuser vsh where vsh.cohort_id IN (SELECT cohort_id FROM uac_xref_subject_cohort WHERE subject_id = " . $inv_subject_id . ") ORDER BY VSH_USERNAME ASC; ";
                $logger->debug("Show me allusr_query: " . $allusr_query);
                $result_all_usr = $dbconnectioninst->query($allusr_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me: " . count($result_all_usr));
    
    
                $param_limit_page_query = " SELECT par_int AS PG_LIMIT FROM uac_param WHERE key_code = 'GRASTUL'; ";
                $logger->debug("Show me param_limit_page_query: " . $param_limit_page_query);
                $result_param_limit_page = $dbconnectioninst->query($param_limit_page_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_param_limit_page: " . $result_param_limit_page[0]['PG_LIMIT']);
                
    
                $page_maximum = $result_get_exam_query[0]['UGM_NBR_OF_PAGE'];
    
    
                $get_all_page_query = " SELECT * FROM uac_gra_line WHERE master_id = " . $post_master_id . " ORDER BY page_i ASC; ";
                $logger->debug("Show me get_all_page_query: " . $get_all_page_query);
                $result_get_all_page_query = $dbconnectioninst->query($get_all_page_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_get_all_page_query: " . count($result_get_all_page_query));
    
    
                $content = $twig->render('Admin/GRA/addgradetoexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'result_get_token' => $result_get_token,
                                                                    'result_all_usr' => $result_all_usr,
                                                                    'result_get_exam_query' => $result_get_exam_query,
                                                                    'result_get_all_page_query' => $result_get_all_page_query,
                                                                    'page_limit' => $result_param_limit_page[0]['PG_LIMIT'],
                                                                    'page_maximum' => $page_maximum,
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'errtype' => '']);

            }
            else{
                
                $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
            }
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
        $full_feedback_msg = '';
        $max_file_size = 0;

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);

            $zip_list_of_files = array();
            $zip_comments = '';



            $logger->debug("*** GRA Filename: " . $_FILES['fileToUpload']['name']);
            $logger->debug("*** GRA fPageNbr: " . $_POST["fPageNbr"]);
            $logger->debug("*** GRA fSubToken: " . $_POST["fSubToken"]);

            $nbr_page = intval($_POST["fPageNbr"]);
            $mention_code = $_POST["fMentionCode"];
            // fTeacherId fCustTeacherName fSubjectId fExamDate


            $param_teacher_id = $_POST["fTeacherId"];
            $param_cust_teacher_name = $_POST["fCustTeacherName"];
            $param_subject_id = $_POST["fSubjectId"];
            $param_exam_date = $_POST["fExamDate"];
            $param_browser = $_POST["fBrowser"];
            $param_niveau = $_POST["fNiveau"];
            $param_subject = $_POST["fSubject"];

            $trace_report = "<div class='trac-rep'><strong>Paramètres lus:</strong> <br>Mention: " . $mention_code . '<br>Niveau: ' . $param_niveau . '<br>Sujet: ' . $param_subject . '<br>Date technique: ' . $param_exam_date . '<br>Navigateur web: ' . $param_browser . '<br>Sujet ID: ' . $param_subject_id . '</div>';

            $master_id = '0';
            // Contains couple 'originale filename' => _i
            // Provides: <body text='black'>
            // $bodytag = str_replace("%body%", "black", "<body text='%body%'>");
            $page_i_array = array();
            // param_teacher_id param_cust_teacher_name param_subject_id param_exam_date

            if($_POST["fSubToken"] != $this->getDailyTokenGRAStr($logger)){
                $is_still_valid = false;
                $full_error_msg = $full_error_msg . 'Error728G - Contactez le support technique.<br>';
            }
            if ((!str_ends_with($_FILES['fileToUpload']['name'], '.zip')) && (!str_ends_with($_FILES['fileToUpload']['name'], '.jpg')) && (!str_ends_with($_FILES['fileToUpload']['name'], '.jpeg'))){
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
            
                $max_file_size =  intval($result_get_max_file_query[0]["GRAMAX_SIZE"]);
            }
            $logger->debug("*** GRA max_file_size: " . $max_file_size);
            $logger->debug("*** GRA file size: " . filesize($_FILES['fileToUpload']['tmp_name']));

            // If it is an unique file .jpg we check the size
            if (($is_still_valid) 
                    && (filesize($_FILES['fileToUpload']['tmp_name']) > $max_file_size*1000)
                    && ((str_ends_with($_FILES['fileToUpload']['name'], '.jpg')) || (str_ends_with($_FILES['fileToUpload']['name'], '.jpeg')))
                    ){
                        $is_still_valid = false;
                        $full_error_msg = $full_error_msg . 'Error731G - Le fichier ' . $_FILES['fileToUpload']['name'] . ' dépasse la taille de ' . $max_file_size . 'ko.&nbsp;<br>';
            }
            $logger->debug("*** GRA full_error_msg: " . $full_error_msg);
            
            if(($nbr_page ==  1) 
                    && ((str_ends_with($_FILES['fileToUpload']['name'], '.zip')))){
                        $is_still_valid = false;
                        $full_error_msg = $full_error_msg . 'Error732G - Le nombre de page attendu est 1. Vous devez charger un unique .jpg et pas un zip. Fichier reçu : ' . $_FILES['fileToUpload']['name'];
            }

            if(($nbr_page >  1) 
                    && ((str_ends_with($_FILES['fileToUpload']['name'], '.jpg')) || (str_ends_with($_FILES['fileToUpload']['name'], '.jpeg')))){
                        $is_still_valid = false;
                        $full_error_msg = $full_error_msg . 'Error733G - Plusieurs pages sont attendues. Vous devez charger un unique .zip et pas un jpg. Fichier reçu : ' . $_FILES['fileToUpload']['name'];
            }

            // Now read the zip if we are in a zip case
            // We check the name
            if(($is_still_valid)
                && ((str_ends_with($_FILES['fileToUpload']['name'], '.zip')))){
                    // We are in zip mode
                    // Work on the zip
                    $zip = new ZipArchive;
                    $zip_rawfilename_loaded = $_FILES["fileToUpload"]["tmp_name"];
                    $list_of_files_read = "";
                    $temp_end_file = "";
                    $list_of_page_missing = "";
                    $zip_counter_check_page = array();
                    $is_too_heavy = false;
                    $report_filename_too_heavy = "";
                    for($i = 1; $i <= $nbr_page; $i++){
                        array_push($zip_counter_check_page, '_' . $i);
                    }
                    if (($zip_rawfilename_loaded != null) && ($zip->open($zip_rawfilename_loaded) === TRUE)){
                        $logger->debug("*** We have opened the file ");
                        $logger->debug("*** Number of file: " . $zip->numFiles);
                        $count_csv = 0;

                        for($i = 0; $i < $zip->numFiles; $i++){
                            $stat = $zip->statIndex($i);
                            if(!(str_starts_with(basename( $stat['name']), '.')) &&
                                    ((str_ends_with(basename( $stat['name']), '.jpg'))
                                            || (str_ends_with(basename( $stat['name']), '.jpeg'))
                                    )
                                ){
                                        $count_csv = $count_csv + 1;
                                        $list_of_files_read = $list_of_files_read . '<br>' . basename( $stat['name']);
                                        array_push($zip_list_of_files, basename( $stat['name']));
                                        // ***********************************************************************
                                        // ***********************************************************************
                                        // ***********************************************************************

                                        // Check the page name here
                                        // We expect to get for each page _1 _2 _3 and _4 if 4 pages are ncessary
                                        if((str_ends_with(basename( $stat['name']), '.jpg'))){
                                            $temp_end_file = ".jpg";
                                        }
                                        else{
                                            $temp_end_file = ".jpeg";
                                        }
                                        $j = 0;
                                        $found = 'N';
                                        // Check the size of the file to avoid loop first
                                        if(intval($stat['size']) > $max_file_size*1000){
                                            $is_too_heavy = true;
                                            $report_filename_too_heavy = basename( $stat['name']);
                                            $found = 'Y';
                                            $logger->debug("*** Heavy: " . $is_too_heavy . ' set found: ' . $found);
                                        }
                                        $logger->debug("*** Before log: " . count($zip_counter_check_page) . ' >>> ' . $j . ' +++ ' . $found);
                                        while (($j < count($zip_counter_check_page)) && ($found == 'N')):
                                            if(str_ends_with(basename( $stat['name']), $zip_counter_check_page[$j] . $temp_end_file)){
                                                $found = 'Y';
                                            }
                                            else{
                                                $found = 'N';
                                                $j++;
                                            }
                                            $logger->debug("*** in log: " . count($zip_counter_check_page) . ' >>> ' . $j . ' +++ ' . $found);
                                        endwhile;

                                        // We are on a valid case so we can move on
                                        if(($found == 'Y') && (!$is_too_heavy)){
                                            // Save the page number
                                            $new_array = array(basename( $stat['name'])=>$zip_counter_check_page[$j]);
                                            $page_i_array = array_merge($page_i_array, $new_array);
                                            array_splice($zip_counter_check_page, $j, 1);
                                        }

                                        // ***********************************************************************
                                        // ***********************************************************************
                                        // ***********************************************************************
                                        
                                    }
                        }
                        $zip_comments = '<span class="icon-arrow-down nav-icon-fa nav-text"></span>&nbsp; Fichier(s) lu(s): ' . $count_csv . '<br>' . $zip_comments . '<br>' . $list_of_files_read;
                        if($is_too_heavy){
                            $is_still_valid = false;
                            $full_error_msg = $full_error_msg . 'Error734G - Un des fichiers du zip dépasse la taille maximale de ' . $max_file_size . 'ko - Vérifiez : zip/' . $report_filename_too_heavy;
                        }
                        if($count_csv != $nbr_page){
                            $is_still_valid = false;
                            $full_error_msg = $full_error_msg . 'Error735G - Le nombre de pages attendue est ' . $nbr_page . ' alors que nous trouvons ' . $count_csv . ' pages dans le fichier: ' . $_FILES['fileToUpload']['name'];
                        }
                        if(count($zip_counter_check_page) > 0){
                            $is_still_valid = false;
                            for($i = 0; $i < count($zip_counter_check_page); $i++){
                                $list_of_page_missing = $list_of_page_missing . $zip_counter_check_page[$i] . '/';
                            }
                            $full_error_msg = $full_error_msg . 'Error736G - Les pages suivantes sont manquantes dans le zip : ' . $list_of_page_missing . '<br> Vérifiez le fichier: ' . $_FILES['fileToUpload']['name'];
                        }
                    }
                    else{
                        $is_still_valid = false;
                        $full_error_msg = $full_error_msg . 'Error737G - Erreur dans extraction du fichier zip. Contactez le support et partagez leur le fichier: ' . $_FILES['fileToUpload']['name'];
                    }
                    $zip->close();
            }

            $logger->debug("*** pwd: " . getcwd());
            // /Users/ratinahirana/Sites/localhost/uaceema/public


            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // From here if we are valid, then we need to start the work *************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            // ***********************************************************************
            $master_id = 0;
            if($is_still_valid){
                $master_id = $this->getMasterIdAndStartFlow($_SESSION['id'], $param_exam_date, $param_subject_id, $param_teacher_id, $nbr_page, $param_cust_teacher_name, $logger);
                if($master_id == '0'){
                    //There is an issue here
                    $is_still_valid = false;
                    $full_error_msg = $full_error_msg . "Error738G - Un chargement est en cours de traitement ou alors le dernier ne s'est pas terminé correctement.<br>Veuillez reessayer plus tard et si le problème persiste, contactez le support technique.";
                }
                if($master_id == -1){
                    //There is an issue here
                    $is_still_valid = false;
                    $full_error_msg = $full_error_msg . "Error739G - Un examen pour le même sujet et la même date existe déjà. Vous devez d'abord l'annuler dans le manager examen.";
                }
            }
            //We have a valid Master ID
            if($is_still_valid){
                // We have to retrieve the master_id

                if ((str_ends_with($_FILES['fileToUpload']['name'], '.jpg')) || (str_ends_with($_FILES['fileToUpload']['name'], '.jpeg'))){
                    // Do something for jpeg
                    // We are good we need to save
                    $this->saveFileUnitary($master_id . '_' . $param_subject_id . '_', $mention_code, $_FILES, $logger, $scale_right);
                    // As jpg, we save the file page 1 on 1
                    $this->generateLoadGra($master_id, '/' . $mention_code . '/', $master_id . '_' . $param_subject_id . '_' . $_FILES['fileToUpload']['name'], 1, $param_browser, $nbr_page, $logger);
                    $this->closeFlowAndWINMasterId($master_id, $logger);
                }
                else{
                    // Do something for zip
                    // We have to loop in the zip
                    $zip = new ZipArchive;
                    $target_dir = getcwd() . self::$my_gra_repository;
                    $path_filename_repo = $target_dir . "/" . $mention_code . "/";
                    $zip_rawfilename_loaded = $_FILES["fileToUpload"]["tmp_name"];
                    if (($zip_rawfilename_loaded != null) && ($zip->open($zip_rawfilename_loaded) === TRUE)) {
                        $zip->extractTo($path_filename_repo, $zip_list_of_files);
                        $zip->close();
                        $logger->debug("*** Master - File unzipped ");
                    } else {
                        $logger->debug("*** Master - Error File unzipped ");
                    }
                    foreach ($zip_list_of_files as $in_zip_file) {
                        rename($path_filename_repo . '/' . $in_zip_file, $path_filename_repo . '/' . $master_id . '_' . $param_subject_id . '_' . $in_zip_file);
                        $this->generateLoadGra($master_id, '/' . $mention_code . '/', $master_id . '_' . $param_subject_id . '_' . $in_zip_file, str_replace('_', '', $page_i_array[$in_zip_file]), $param_browser, $nbr_page, $logger);
                    }
                    $this->closeFlowAndWINMasterId($master_id, $logger);

                    
                }
            }
            
            $result_operation = '';
            $success_operation = 'Y';
            $full_feedback_msg = $zip_comments;
            $full_error_msg = '<div class="err">' . $full_error_msg . '</div>';
            if($is_still_valid) {
                $result_operation = '<h2>REF #' . $master_id . ' : Opération terminée avec succès</h2><br>' . $trace_report;
                $content = $twig->render('Admin/GRA/afterloadreport.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                    'firstname' => $_SESSION["firstname"],
                                                                                    'lastname' => $_SESSION["lastname"],
                                                                                    'id' => $_SESSION["id"],
                                                                                    'full_error_msg' => $full_error_msg,
                                                                                    'result_operation' => $result_operation,
                                                                                    'success_operation' => $success_operation,
                                                                                    'master_id' => $master_id,
                                                                                    'full_feedback_msg' => $full_feedback_msg,
                                                                                    'scale_right' => ConnectionManager::whatScaleRight()]
                                                                                );
            }
            else{
                $success_operation = 'N';
                $result_operation = '<h2>Opération en erreur</h2><br>';
                $full_error_msg = '<span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;Erreur intégration fichier<br>' . $full_error_msg . $trace_report;
                $content = $twig->render('Admin/GRA/afterloadreport.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                    'firstname' => $_SESSION["firstname"],
                                                                                    'lastname' => $_SESSION["lastname"],
                                                                                    'id' => $_SESSION["id"],
                                                                                    'full_error_msg' => $full_error_msg,
                                                                                    'result_operation' => $result_operation,
                                                                                    'success_operation' => $success_operation,
                                                                                    'master_id' => $master_id,
                                                                                    'full_feedback_msg' => $full_feedback_msg,
                                                                                    'scale_right' => ConnectionManager::whatScaleRight()]
                                                                                );
            }



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

    private function getMasterIdAndStartFlow($param_session_id, $param_exam_date, $param_subject_id, $param_teacher_id, $nbr_page, $param_cust_teacher_name, LoggerInterface $logger){
        // Get me the token !
        $get_start_master_query = "CALL CLI_START_GraFlowMaster('" . $_FILES['fileToUpload']['name'] . "', '". $param_session_id . "', ' " . $param_exam_date . "', " . $param_subject_id . ", " . $param_teacher_id . ", " . $nbr_page . ", '" . $param_cust_teacher_name . "');";
        $logger->debug("Show me get_start_master_query: " . $get_start_master_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_get_start_master_query = $dbconnectioninst->query($get_start_master_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("result_get_token: " . $result_get_start_master_query[0]["INV_GRA_MASTER_ID"]);
    
        return $result_get_start_master_query[0]["INV_GRA_MASTER_ID"];
    }

    private function generateLoadGra($param_master_id, $param_path, $param_filename, $param_page_i, $browser, $nbr_page, LoggerInterface $logger){
        // Get me the token !
        $get_generate_load_gra_query = " INSERT INTO uac_load_gra (master_id, gra_path, gra_filename, page_i, browser, nbr_of_page) VALUES (" . $param_master_id . ", '" . $param_path . "', '" . $param_filename . "', " . $param_page_i . ", '" . $browser . "', " . $nbr_page . "); ";
        $logger->debug("Show me get_generate_load_gra_query: " . $get_generate_load_gra_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $dbconnectioninst->query($get_generate_load_gra_query)->fetchAll(PDO::FETCH_ASSOC);
    }

    private function closeFlowAndWINMasterId($param_master_id, LoggerInterface $logger){
        // Get me the token !
        $get_close_master_query = "CALL CLI_END_GraFlowMasterGenGraLine(" . $param_master_id . ");";
        $logger->debug("Show me get_close_master_query: " . $get_close_master_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $dbconnectioninst->query($get_close_master_query)->fetchAll(PDO::FETCH_ASSOC);
    }

    // $result_for_one_file = $this->saveFileUnitary($prefix, $param_file, LoggerInterface $logger, $scale_right)
    // u is for unique (jpg and jpeg) and m is for multiple (zip)
    public function saveFileUnitary($prefix, $mention, $param_file, LoggerInterface $logger, $scale_right){
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("*** pwd: " . getcwd());
                    
            // Where the file is going to be stored
            $target_dir = getcwd() . self::$my_gra_repository;
            $file = $param_file['fileToUpload']['name'];
            $path = pathinfo($file);
            $filename = $path['filename'];
            $ext = $path['extension'];
            $temp_name = $param_file['fileToUpload']['tmp_name'];
            $path_filename_ext = $target_dir . "/" . $mention . "/" . $prefix . $filename . "." . $ext;
                
            // Check if file already exists
            if (file_exists($path_filename_ext)) {
                $logger->debug("*** err: saveFileUnitary file already exists.");
            }
            else{
                move_uploaded_file($temp_name, $path_filename_ext);
                $logger->debug("*** succ: saveFileUnitary File Uploaded Successfully.");
            }
        }
    }


    public function managergraexam(Environment $twig, LoggerInterface $logger)
    {

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();

        $logger->debug("scale_right: " . $scale_right);
        // Anyone can access to the manager but only limited people can input the date
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){


            

            $query_all_ugm = " SELECT * FROM v_master_exam ORDER BY UGM_TECH_LAST_UPDATE DESC; ";

            $logger->debug("Firstname: " . $_SESSION["firstname"]);
            $logger->debug("query_all_ugm: " . $query_all_ugm);


            $dbconnectioninst = DBConnectionManager::getInstance();
            $result_all_ugm = $dbconnectioninst->query($query_all_ugm)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_all_ugm: " . count($result_all_ugm));

            $content = $twig->render('Admin/gra/managergraexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'result_all_ugm' => $result_all_ugm,
                                                                    'errtype' => '']);

        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


}
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
                $exam_status = $result_get_exam_query[0]['UGM_STATUS'];
                $exam_mention_code = $result_get_exam_query[0]['URS_MENTION_CODE'];
                // TODO Review list of stu
                // NEW* > LOA > FED > REV* > END*
                if(($exam_status == 'FED')
                    || ($exam_status == 'REV')
                    || ($exam_status == 'END')){
                    // Review cases !
                    // Data already exists. We need to load them.
                    $allusr_query = " SELECT vsh.ID AS VSH_ID, vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME, ugg.grade AS HID_GRA, ugg.gra_status AS GRA_STATUS, 'N' AS DIRTY_GRA, ugg.id AS GRA_ID FROM v_showuser vsh JOIN uac_gra_grade ugg ON vsh.ID = ugg.user_id AND ugg.master_id = " . $post_master_id . " ORDER BY ugg.id ASC; ";
                    
                    $allothermentionusr_query = " SELECT vsh.ID AS VSH_ID, vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME, vsh.SHORTCLASS AS OTH_CLASS, 'x' AS HID_GRA, 'x' AS GRA_STATUS, "
                                                . " 'x' AS DIRTY_GRA, 0 AS GRA_ID FROM v_showuser vsh where vsh.cohort_id IN (SELECT id FROM v_class_cohort vcc WHERE vcc.mention_code = '" . $exam_mention_code . "') AND vsh.ID NOT "
                                                . " IN (SELECT ugg.user_id FROM uac_gra_grade ugg WHERE ugg.master_id = " . $post_master_id . "); ";
                }
                else{
                    // Creation cases !
                    $allusr_query = " SELECT vsh.ID AS VSH_ID, vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME, 'x' AS HID_GRA, 'x' AS GRA_STATUS, 'x' AS DIRTY_GRA, 0 AS GRA_ID FROM v_showuser vsh where vsh.cohort_id IN (SELECT cohort_id FROM uac_xref_subject_cohort WHERE subject_id = " . $inv_subject_id . ") ORDER BY VSH_USERNAME ASC; ";
                    
                    $allothermentionusr_query = " SELECT vsh.ID AS VSH_ID, vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME, vsh.SHORTCLASS AS OTH_CLASS, 'x' AS HID_GRA, 'x' AS GRA_STATUS, "
                                                . " 'x' AS DIRTY_GRA, 0 AS GRA_ID FROM v_showuser vsh where vsh.cohort_id IN (SELECT id FROM v_class_cohort vcc WHERE vcc.mention_code = '" . $exam_mention_code . "') AND vsh.ID NOT "
                                                . " IN (SELECT vsh.ID FROM v_showuser vsh where vsh.cohort_id IN (SELECT cohort_id FROM uac_xref_subject_cohort WHERE subject_id = " . $inv_subject_id . ")); ";
                }
                
                $logger->debug("Show me allusr_query: " . $allusr_query);
                $result_all_usr = $dbconnectioninst->query($allusr_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me: " . count($result_all_usr));
                
                $result_allothermentionusr_query = array();
                if($allothermentionusr_query != null){
                    $logger->debug("Show me allothermentionusr_query: " . $allothermentionusr_query);
                    $result_allothermentionusr_query = $dbconnectioninst->query($allothermentionusr_query)->fetchAll(PDO::FETCH_ASSOC);
                    $logger->debug("Show me: " . count($result_allothermentionusr_query));
                }
    
    
                $param_limit_page_query = " SELECT par_int AS PG_LIMIT FROM uac_param WHERE key_code = 'GRASTUL'; ";
                $logger->debug("Show me param_limit_page_query: " . $param_limit_page_query);
                $result_param_limit_page = $dbconnectioninst->query($param_limit_page_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_param_limit_page: " . $result_param_limit_page[0]['PG_LIMIT']);
                
    
                $page_maximum = $result_get_exam_query[0]['UGM_NBR_OF_PAGE'];
    
    
                $get_all_page_query = " SELECT * FROM uac_gra_line WHERE master_id = " . $post_master_id . " ORDER BY page_i ASC; ";
                $logger->debug("Show me get_all_page_query: " . $get_all_page_query);
                $result_get_all_page_query = $dbconnectioninst->query($get_all_page_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_get_all_page_query: " . count($result_get_all_page_query));

                $get_default_bookmark_query = " SELECT par_value AS DEF_BOOKMARK FROM uac_param WHERE key_code = 'GRACSBK'; ";
                $logger->debug("Show me get_default_bookmark_query: " . $get_default_bookmark_query);
                $result_get_default_bookmark_query = $dbconnectioninst->query($get_default_bookmark_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me: " . $result_get_default_bookmark_query[0]['DEF_BOOKMARK']);

                $default_bookmark = $result_get_default_bookmark_query[0]['DEF_BOOKMARK'];
                // If exists we use the save bookmark
                if($result_get_exam_query[0]['UGM_CROSS_BOOKMARK'] != null){
                    $default_bookmark = $result_get_exam_query[0]['UGM_CROSS_BOOKMARK'];
                }

                
                $exam_last_agent_id = $result_get_exam_query[0]['UGM_LAST_AGENT_ID'];
                $last_agent_id_same_as_current = 'N';
                if($exam_last_agent_id == $_SESSION["id"]){
                    $last_agent_id_same_as_current = 'Y';
                }

                $class_per_subject_query = " SELECT urs.id AS URS_ID, GROUP_CONCAT(vcc.short_classe ORDER BY vcc.id ASC SEPARATOR ' + ') AS GRP_VCC_SHORT_CLASS, GROUP_CONCAT(vcc.ID SEPARATOR '|') AS GRP_VCC_ID FROM uac_ref_subject urs  "
                                        . " JOIN uac_xref_subject_cohort xref ON urs.id = xref.subject_id "
                                        . " JOIN v_class_cohort vcc ON vcc.id = xref.cohort_id WHERE urs.id = " . $result_get_exam_query[0]['UGM_SUBJECT_ID'] . " GROUP BY urs.id; ";
                $logger->debug("Show me class_per_subject_query: " . $class_per_subject_query);
                $result_class_per_subject_query = $dbconnectioninst->query($class_per_subject_query)->fetchAll(PDO::FETCH_ASSOC);
    
                
                $content = $twig->render('Admin/GRA/addgradetoexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'result_get_token' => $result_get_token,
                                                                    'result_all_usr' => $result_all_usr,
                                                                    'result_allothermentionusr_query' => $result_allothermentionusr_query,
                                                                    'post_master_id' => $post_master_id,
                                                                    'exam_status' => $exam_status,
                                                                    'exam_last_agent_id' => $exam_last_agent_id,
                                                                    'last_agent_id_same_as_current' => $last_agent_id_same_as_current,
                                                                    'result_get_exam_query' => $result_get_exam_query,
                                                                    'result_get_all_page_query' => $result_get_all_page_query,
                                                                    'page_limit' => $result_param_limit_page[0]['PG_LIMIT'],
                                                                    'result_class_per_subject_query' => $result_class_per_subject_query,
                                                                    'page_maximum' => $page_maximum,
                                                                    'default_bookmark' => $default_bookmark,
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
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){
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

            $allstu_query = " SELECT UPPER(vsh.USERNAME) AS VSH_USERNAME, vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, fGetMatriculeNum(vsh.MATRICULE) AS VSH_SMATRICULE, vsh.COHORT_ID AS VSH_COHORT_ID from v_showuser vsh ORDER BY vsh.USERNAME ASC; ";
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



    
    public function cancelexam(Environment $twig, LoggerInterface $logger){

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
        $scale_right = ConnectionManager::whatScaleRight();

        if(isset($_POST["fCustTeacherName"])
            && isset($_POST["fExamDate"])
            && isset($_POST["fMention"])
            && isset($_POST["fNiveau"])
            && isset($_POST["fSubject"])
            && isset($_POST["fCredit"])
            && isset($_POST["can-master-id"])
            ){
            if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
                $logger->debug("cancelexam : Firstname: " . $_SESSION["firstname"]);
    
                $param_cust_teacher_name = $_POST["fCustTeacherName"];
                $param_exam_date = $_POST["fExamDate"];
                $param_mention = $_POST["fMention"];
                $param_niveau_semester = $_POST["fNiveau"];
                $param_subject = $_POST["fSubject"];
                $param_credit = $_POST["fCredit"]/10;
                $master_id = $_POST["can-master-id"];
    
                $confirmation_msg = '<strong>Mention: </strong>' . $param_mention . '<br><strong>Niveau: </strong>' . $param_niveau_semester . '<br><strong>Sujet: </strong>' . $param_subject . '<br><strong>Crédit: </strong>' . $param_credit . '<br><strong>Enseignant: </strong>' . $param_cust_teacher_name . '<br><strong>Date examen: </strong>' . $param_exam_date;
                
                $content = $twig->render('Admin/GRA/cancelexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                    'firstname' => $_SESSION["firstname"],
                                                                                    'lastname' => $_SESSION["lastname"],
                                                                                    'id' => $_SESSION["id"],
                                                                                    'confirmation_msg' => $confirmation_msg,
                                                                                    'master_id' => $master_id,
                                                                                    'scale_right' => ConnectionManager::whatScaleRight()]
                                                                                );
    
            }
            else{
                // Error Code 404
                $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
            }
        }
        else{
            $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
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

    public function generategradetoexamDB(Request $request, LoggerInterface $logger){


      // This is optional.
      // Only include it if the function is reserved for ajax calls only.
      if (!$request->isXmlHttpRequest()) {
          return new JsonResponse(array(
              'status' => 'Error',
              'message' => 'Error'),
          400);
      }

      if(isset($request->request))
      {

          // Token control
          $result_get_token = $this->getDailyTokenGRAStr($logger);
          $param_token = $request->request->get('token');

          if(strcmp($result_get_token, $param_token) !== 0){
              // We need to out as error
              // This may be a corrupted action
              return new JsonResponse(array(
                  'status' => 'Error',
                  'message' => 'Err678GRA ticket corrompu'),
              400);
          }

          // Get data from ajax
          $param_agent_id = $request->request->get('agentId');
          $param_master_id = $request->request->get('masterId');
          // Load the complicated collection
          $param_jsondata = json_decode($request->request->get('loadGradeData'), true);
          $param_jsondata_othgra = json_decode($request->request->get('loadOtherGradeData'), true);

          $param_crossbookmark = $request->request->get('crossBookmark');
          $param_browser = $request->request->get('browser');

          //echo $param_jsondata[0]['username'];
          // INSERT INTO uac_gra_grade (master_id, user_id, operation, grade) VALUES (1, 1, 'CRE', 18.5);
          /*
          $query_value = 'INSERT IGNORE INTO uac_gra_grade (master_id, user_id, operation, grade, gra_status) VALUES (';
          $first_comma = '';
          foreach ($param_jsondata as $read)
          {
                if(($read['HID_GRA'] == 'A')
                    || ($read['HID_GRA'] == 'E')){
                    $query_value = $query_value . $first_comma . $param_master_id . ',' . $read['VSH_ID'] . ",'CRE',0,'" . $read['HID_GRA'] . "')";
                }
                else{
                    $query_value = $query_value . $first_comma . $param_master_id . ',' . $read['VSH_ID'] . ",'CRE'," . $read['HID_GRA'] . ",'P')";
                }
                $first_comma = ', (';
          }
          $query_value = $query_value . ';';
          */

          $query_value = $this->getInsertQueryGraGra($param_master_id, $param_jsondata, 'ORI', $logger);
          sleep(1);


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          //$query_value = " CALL CLI_CRT_PayAddFacilite( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_ticket_type . "', " . $param_red_pc . ", " . $param_inv_fsc_id . ")";

          $logger->debug("generategradetoexamDB - Show me query_value: " . $query_value);

          $dbconnectioninst = DBConnectionManager::getInstance();

          $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
          $logger->debug("-- We have insert the lines");

          if(count($param_jsondata_othgra) > 0){
                //We need to take care of the other data
                $query_value_othgra = $this->getInsertQueryGraGra($param_master_id, $param_jsondata_othgra, 'OTH', $logger);
                sleep(1);
                $logger->debug("generategradetoexamDB - Show me query_value_othgra: " . $query_value_othgra);
                $dbconnectioninst->query($query_value_othgra)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("-- We have insert the lines OTHER");
          }


          // NEW > LOA > FED > END -- CAN
          $query_update_master = "UPDATE uac_gra_master SET status = 'FED', last_update = CURRENT_TIMESTAMP, last_agent_id = " . $param_agent_id . ", "
                                    . " cross_bookmark = '" . $param_crossbookmark . "', cross_browser = '" . $param_browser . "', "
                                    . " avg_grade = (SELECT TRUNCATE(AVG(grade), 2) FROM uac_gra_grade ugg WHERE ugg.master_id = " . $param_master_id . " and ugg.gra_status = 'P') "
                                    . " WHERE id = " . $param_master_id . " ; ";
          $logger->debug("-- query_update_master: " . $query_update_master);
          $dbconnectioninst->query($query_update_master)->fetchAll(PDO::FETCH_ASSOC);

          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'param_master_id' => $param_master_id,
              'message' => 'Tout est OK: '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation notation DB'),
      400);
    }

    public function generatereviewexamDB(Request $request, LoggerInterface $logger){


      // This is optional.
      // Only include it if the function is reserved for ajax calls only.
      if (!$request->isXmlHttpRequest()) {
          return new JsonResponse(array(
              'status' => 'Error',
              'message' => 'Error'),
          400);
      }

      if(isset($request->request))
      {

          // Token control
          $result_get_token = $this->getDailyTokenGRAStr($logger);
          $param_token = $request->request->get('token');

          if(strcmp($result_get_token, $param_token) !== 0){
              // We need to out as error
              // This may be a corrupted action
              return new JsonResponse(array(
                  'status' => 'Error',
                  'message' => 'Err679GRA ticket corrompu'),
              400);
          }

          // Get data from ajax
          $param_agent_id = $request->request->get('agentId');
          $param_master_id = $request->request->get('masterId');
          // Load the complicated collection
          $param_jsondata = json_decode($request->request->get('loadReviewData'), true);
          $param_jsondata_othgra = json_decode($request->request->get('loadOtherGradeData'), true);

          $param_crossbookmark = $request->request->get('crossBookmark');
          $param_browser = $request->request->get('browser');

          $dbconnectioninst = DBConnectionManager::getInstance();

          // We do not do any update if there is no data to update
          if(count($param_jsondata) > 0){
            //echo $param_jsondata[0]['username'];
            //UPDATE uac_gra_grade SET grade = 13, gra_status = 'P', operation = 'REV', last_update = CURRENT_TIMESTAMP WHERE id = 7;
            //UPDATE uac_gra_grade SET grade = 0, gra_status = 'E', operation = 'REV', last_update = CURRENT_TIMESTAMP WHERE id = 7;
            $query_value = '';
            $query_prefix = 'UPDATE uac_gra_grade SET grade = ';
            foreach ($param_jsondata as $read)
            {
                  if(($read['HID_GRA'] == 'A')
                      || ($read['HID_GRA'] == 'E')){
                      $query_value = $query_value . $query_prefix . "0" . ",gra_status ='" . $read['HID_GRA'] . "', last_update=CURRENT_TIMESTAMP WHERE id =" . $read['GRA_ID'] . ";";
                  }
                  else{
                      $query_value = $query_value . $query_prefix . $read['HID_GRA'] . ",gra_status ='P', last_update=CURRENT_TIMESTAMP WHERE id =" . $read['GRA_ID'] . ";";
                  }
            }
            sleep(2);
  
  
            //echo $param_jsondata[0]['username'];
            //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
            //$query_value = " CALL CLI_CRT_PayAddFacilite( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_ticket_type . "', " . $param_red_pc . ", " . $param_inv_fsc_id . ")";
  
            $logger->debug("generatereviewexamDB - Show me query_value: " . $query_value);
  
            
  
            $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("-- We have updated the lines");
          }

          if(count($param_jsondata_othgra) > 0){
                //We need to take care of the other data
                $query_value_othgra = $this->getInsertQueryGraGra($param_master_id, $param_jsondata_othgra, 'OTH', $logger);
                sleep(1);
                $logger->debug("generategradetoexamDB - Show me query_value_othgra: " . $query_value_othgra);
                $dbconnectioninst->query($query_value_othgra)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("-- We have insert the lines OTHER");
          }

          // NEW > LOA > FED > END -- CAN
          $query_update_master = "UPDATE uac_gra_master SET status = 'END', last_update = CURRENT_TIMESTAMP, last_agent_id = " . $param_agent_id . ", "
                                    . " cross_bookmark = '" . $param_crossbookmark . "', cross_browser = '" . $param_browser . "', "
                                    . " avg_grade = (SELECT TRUNCATE(AVG(grade), 2) FROM uac_gra_grade ugg WHERE ugg.master_id = " . $param_master_id . " and ugg.gra_status = 'P') "
                                    . " WHERE id = " . $param_master_id . " ; ";
          $logger->debug("-- query_update_master: " . $query_update_master);
          $dbconnectioninst->query($query_update_master)->fetchAll(PDO::FETCH_ASSOC);

          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'param_master_id' => $param_master_id,
              'message' => 'Tout est OK: '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation notation DB'),
      400);
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

    private function getInsertQueryGraGra($param_master_id, $param_array, $param_operation, LoggerInterface $logger){
        $temp_query = '';

        $temp_query = 'INSERT IGNORE INTO uac_gra_grade (master_id, user_id, operation, grade, gra_status) VALUES (';
          $first_comma = '';
          foreach ($param_array as $read)
          {
                if(($read['HID_GRA'] == 'A')
                    || ($read['HID_GRA'] == 'E')){
                    $temp_query = $temp_query . $first_comma . $param_master_id . ',' . $read['VSH_ID'] . ",'" . $param_operation . "',0,'" . $read['HID_GRA'] . "')";
                }
                else{
                    $temp_query = $temp_query . $first_comma . $param_master_id . ',' . $read['VSH_ID'] . ",'" . $param_operation . "'," . $read['HID_GRA'] . ",'P')";
                }
                $first_comma = ', (';
          }
        $temp_query = $temp_query . ';';
        return $temp_query;
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

            $dbconnectioninst = DBConnectionManager::getInstance();
            $confirm_cancel_id = 0;
            $create_grades_master_id = 0;
            $review_grades_master_id = 0;
            if(isset($_POST["confirm-cancel-id"])){
                $confirm_cancel_id = $_POST["confirm-cancel-id"];
                // We are in a cancel case
                $query_cancel_id = " UPDATE uac_gra_master SET status = 'CAN', last_agent_id = " . $_SESSION["id"] . " WHERE id = " . $confirm_cancel_id . "; ";
                $result_query_cancel_id = $dbconnectioninst->query($query_cancel_id)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("query_cancel_id: " . $query_cancel_id);
                $logger->debug("count result_query_cancel_id: " . count($result_query_cancel_id));

                $query_delete_id = " DELETE FROM uac_gra_grade WHERE master_id = " . $confirm_cancel_id . "; ";
                $result_query_delete_id = $dbconnectioninst->query($query_delete_id)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("query_delete_id: " . $query_delete_id);
                $logger->debug("count result_query_cancel_id: " . count($result_query_delete_id));
            }

            if(isset($_POST["create-master-id"])){
                if(intval($_POST["create-master-id"]) > 0){
                    $create_grades_master_id = intval($_POST["create-master-id"]);
                }
            }

            if(isset($_POST["review-master-id"])){
                if(intval($_POST["review-master-id"]) > 0){
                    $review_grades_master_id = intval($_POST["review-master-id"]);
                }
            }
            

            $query_all_ugm = " SELECT * FROM v_master_exam ORDER BY UGM_TECH_LAST_UPDATE DESC; ";
            $logger->debug("query_all_ugm: " . $query_all_ugm);
            $logger->debug("managergraexam - Firstname: " . $_SESSION["firstname"]);
            

            if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
                $edit_access = 'Y';
            }
            else{
                $edit_access = 'N';
            }
            
            $result_all_ugm = $dbconnectioninst->query($query_all_ugm)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_all_ugm: " . count($result_all_ugm));

            $content = $twig->render('Admin/GRA/managergraexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'edit_access' => $edit_access,
                                                                    'confirm_cancel_id' => $confirm_cancel_id,
                                                                    'create_grades_master_id' => $create_grades_master_id,
                                                                    'review_grades_master_id' => $review_grades_master_id,
                                                                    'result_all_ugm' => $result_all_ugm,
                                                                    'errtype' => '']);

        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


    public function missingstudent(Environment $twig, LoggerInterface $logger)
    {

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();

        $logger->debug("scale_right: " . $scale_right);
        // Anyone can access to the manager but only limited people can input the date
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){

            $dbconnectioninst = DBConnectionManager::getInstance();
            
            $query_missing_stu = " SELECT vpl.*, vpl.URS_NIVEAU_CODE AS EXAM_NIVEAU, vcc.niveau AS STU_NIVEAU FROM v_primitif_line vpl JOIN v_class_cohort vcc ON vpl.VSH_COHORT_ID = vcc.id "
                              .  " WHERE NOT(vpl.URS_NIVEAU_CODE = vcc.niveau) ORDER BY UGG_ID DESC; ";
            $logger->debug("missingstudent - Firstname: " . $_SESSION["firstname"]);
            

            $result_query_missing_stu = $dbconnectioninst->query($query_missing_stu)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_missing_stu: " . count($result_query_missing_stu));

            $content = $twig->render('Admin/GRA/missingstudent.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'result_query_missing_stu' => $result_query_missing_stu,
                                                                    'errtype' => '']);

        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }

    public function managerprimitif(Environment $twig, LoggerInterface $logger)
    {

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();

        $logger->debug("scale_right: " . $scale_right);
        // Anyone can access to the manager but only limited people can input the date
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){

            $dbconnectioninst = DBConnectionManager::getInstance();
            
            $query_all_primitif_niv = " SELECT * FROM v_primitif_niv; ";
            $logger->debug("query_all_primitif_level: " . $query_all_primitif_niv);
            $logger->debug("managergragrade - Firstname: " . $_SESSION["firstname"]);
            
            $result_query_all_primitif_niv = $dbconnectioninst->query($query_all_primitif_niv)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_all_primitif_niv: " . count($result_query_all_primitif_niv));

            $query_all_subject = " SELECT * FROM v_ref_subject; ";
            $logger->debug("query_all_subject: " . $query_all_subject);
            $logger->debug("managergragrade - Firstname: " . $_SESSION["firstname"]);
            
            $result_query_all_subject = $dbconnectioninst->query($query_all_subject)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_all_subject: " . count($result_query_all_subject));

            // *******************************************************************************
            // *******************************************************************************
            // *******************************************************************************
            // Get the data for new subject
            // *******************************************************************************
            // *******************************************************************************
            // *******************************************************************************

            // Mention
            $query_subj_mention = " SELECT par_code, title FROM uac_ref_mention; ";
            $logger->debug("query_subj_mention: " . $query_subj_mention);
            
            $result_query_subj_mention = $dbconnectioninst->query($query_subj_mention)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_subj_mention: " . count($result_query_subj_mention));

            // Semester
            $query_subj_semester = " SELECT DISTINCT vcc.mention_code AS MENTION_CODE, urs.niveau AS NIVEAU, urs.semestre AS SEMESTRE "
                                    . " FROM uac_ref_semester urs JOIN v_class_cohort vcc ON urs.niveau = vcc.niveau; ";
            $logger->debug("query_subj_semester: " . $query_subj_semester);
            
            $result_query_subj_semester = $dbconnectioninst->query($query_subj_semester)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_subj_semester: " . count($result_query_subj_semester));

            // Parcours
            $query_subj_parcours = " SELECT vcc.mention_code, vcc.niveau, vcc.parcours, COUNT(1) AS CPT_STU "
                                    . " FROM v_class_cohort vcc JOIN uac_showuser uas ON vcc.id = uas.cohort_id "
                                    . " JOIN mdl_user mu ON mu.username = uas.username  "
                                    . " GROUP BY vcc.mention_code, vcc.niveau, vcc.parcours ORDER BY 1, 2, 3; ";
            $logger->debug("query_subj_parcours: " . $query_subj_parcours);
            
            $result_query_subj_parcours = $dbconnectioninst->query($query_subj_parcours)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_subj_parcours: " . count($result_query_subj_parcours));

            // Classes
            $query_subj_class = " SELECT id, mention_code, niveau, parcours, groupe FROM v_class_cohort; ";
            $logger->debug("query_subj_class: " . $query_subj_class);
            
            $result_query_subj_class = $dbconnectioninst->query($query_subj_class)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_subj_class: " . count($result_query_subj_class));

            $result_get_token = $this->getDailyTokenGRAStr($logger);
            
            $content = $twig->render('Admin/GRA/managerprimitif.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"],
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'result_get_token' => $result_get_token,
                                                                    'result_query_all_primitif_level' => $result_query_all_primitif_niv,
                                                                    'result_query_all_subject' => $result_query_all_subject,
                                                                    'result_query_subj_mention' => $result_query_subj_mention,
                                                                    'result_query_subj_semester' => $result_query_subj_semester,
                                                                    'result_query_subj_parcours' => $result_query_subj_parcours,
                                                                    'result_query_subj_class' => $result_query_subj_class,
                                                                    'errtype' => '']); 
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


    public function generateNewSubjectDB(Request $request, LoggerInterface $logger){


    // This is optional.
    // Only include it if the function is reserved for ajax calls only.
    if (!$request->isXmlHttpRequest()) {
        return new JsonResponse(array(
            'status' => 'Error',
            'message' => 'Error'),
        400);
    }

    if(isset($request->request))
    {

        // Token control
        $result_get_token = $this->getDailyTokenGRAStr($logger);
        $param_token = $request->request->get('token');

        if(strcmp($result_get_token, $param_token) !== 0){
            // We need to out as error
            // This may be a corrupted action
            return new JsonResponse(array(
                'status' => 'Error',
                'message' => 'Err673GRA ticket corrompu'),
            400);
        }

        // Get data from ajax

        $param_mention_code = $request->request->get('tempMentionCode');
        $logger->debug("param_mention_code: " . $param_mention_code);

        $param_niveau_id = $request->request->get('tempNiveauID');
        $logger->debug("param_niveau_id: " . $param_niveau_id);
        
        $param_semestre_id = $request->request->get('tempSemestreID');
        $logger->debug("param_semestre_id: " . $param_semestre_id);
        
        $param_credit = $request->request->get('tempCredit');
        $param_credit = intval(floatval($param_credit) * 10);
        $logger->debug("param_credit: " . $param_credit);
        
        $param_title = $request->request->get('tempTitle');
        $logger->debug("param_title: " . $param_title);
        
        $param_jsondata = json_decode($request->request->get('tempParcoursArray'), true);

        $dbconnectioninst = DBConnectionManager::getInstance();

        // Retrieve SUBJ ID
        $query_prepare = " SELECT IFNULL(MAX(id)+1, 1) AS NEW_REF_SUBJ_ID FROM uac_ref_subject; ";
        $result_query_prepare = $dbconnectioninst->query($query_prepare)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_prepare: " . $result_query_prepare[0]['NEW_REF_SUBJ_ID']);
        $new_subj_id = $result_query_prepare[0]['NEW_REF_SUBJ_ID'];

        
        $query_insert_subj = " INSERT IGNORE INTO uac_ref_subject (id, mention_code, niveau_code, semester, subject_title, credit, ue) VALUES ("
                                . $new_subj_id . ", '" . $param_mention_code . "', '" . $param_niveau_id . "', " . $param_semestre_id . ", '"
                                . $param_title . "', " . $param_credit . ", 1); ";
        $logger->debug("query_insert_subj: " . $query_insert_subj);
        $dbconnectioninst->query($query_insert_subj)->fetchAll(PDO::FETCH_ASSOC);


        // Prepare load data
        $query_part1 = " INSERT INTO uac_load_subject_from_screen (mention_code, niveau_id, semester_id, subject_title, parcours, subject_id) VALUES ('";
        $query_part2 = $param_mention_code . "', '" . $param_niveau_id . "', " . $param_semestre_id . ", '" . $param_title ;

        $all_query_load = "";
        // We do not do any update if there is no data to update
        if(count($param_jsondata) > 0){
            foreach ($param_jsondata as $read)
            {
                $big_query = $query_part1 . $query_part2 . "', '". $read . "'," . $new_subj_id . "); ";
                $logger->debug("Query insert: " . $big_query);
                $all_query_load = $all_query_load . $big_query;
            }
        }
        // Perform the load operation
        $dbconnectioninst->query($all_query_load)->fetchAll(PDO::FETCH_ASSOC);

        // Then we go to migration
        $query_migrate_to_core = " CALL CLI_CRT_GraNewSubj(" . $new_subj_id . "); ";
        $logger->debug("query_migrate_to_core: " . $query_migrate_to_core);
        $dbconnectioninst->query($query_migrate_to_core)->fetchAll(PDO::FETCH_ASSOC);
        // THEN RUN THE INSERT IN XREF WITH A STORED PROCEDURE
        /*
        $query_update_master = "UPDATE uac_gra_master SET status = 'END', last_update = CURRENT_TIMESTAMP, last_agent_id = " . $param_agent_id . ", "
                                    . " cross_bookmark = '" . $param_crossbookmark . "', cross_browser = '" . $param_browser . "', "
                                    . " avg_grade = (SELECT TRUNCATE(AVG(grade), 2) FROM uac_gra_grade ugg WHERE ugg.master_id = " . $param_master_id . " and ugg.gra_status = 'P') "
                                    . " WHERE id = " . $param_master_id . " ; ";
        $logger->debug("-- query_update_master: " . $query_update_master);
        $dbconnectioninst->query($query_update_master)->fetchAll(PDO::FETCH_ASSOC);
        */

        // Send all this back to client
        return new JsonResponse(array(
            'status' => 'OK',
            'param_mention_code' => $param_mention_code,
            'return_new_subject_id' => $new_subj_id,
            'message' => 'Tout est OK: '),
        200);
    }

    // If we reach this point, it means that something went wrong
    return new JsonResponse(array(
        'status' => 'Error',
        'message' => 'Error generation notation DB'),
    400);
    }


    public function generateDeleteSubjectDB(Request $request, LoggerInterface $logger){


    // This is optional.
    // Only include it if the function is reserved for ajax calls only.
    if (!$request->isXmlHttpRequest()) {
        return new JsonResponse(array(
            'status' => 'Error',
            'message' => 'Error'),
        400);
    }

    if(isset($request->request))
    {

        // Token control
        $result_get_token = $this->getDailyTokenGRAStr($logger);
        $param_token = $request->request->get('token');

        if(strcmp($result_get_token, $param_token) !== 0){
            // We need to out as error
            // This may be a corrupted action
            return new JsonResponse(array(
                'status' => 'Error',
                'message' => 'Err676GRA ticket corrompu'),
            400);
        }

        // Get data from ajax

        $param_subj_id_to_delete = $request->request->get('tempSubjectIdToDelete');
        $logger->debug("param_subj_id_to_delete: " . $param_subj_id_to_delete);

        $dbconnectioninst = DBConnectionManager::getInstance();

        // Retrieve SUBJ ID
        $query_delete_x = " DELETE FROM uac_xref_subject_cohort WHERE subject_id = " . $param_subj_id_to_delete . "; ";
        $logger->debug("Show me query_delete_x: " . $query_delete_x);

        $dbconnectioninst->query($query_delete_x)->fetchAll(PDO::FETCH_ASSOC);

        $query_delete_main = " DELETE FROM uac_ref_subject WHERE id = " . $param_subj_id_to_delete . "; ";
        $logger->debug("Show me query_delete_main: " . $query_delete_main);

        $dbconnectioninst->query($query_delete_main)->fetchAll(PDO::FETCH_ASSOC);

        // Send all this back to client
        return new JsonResponse(array(
            'status' => 'OK',
            'param_subj_id_to_delete' => $param_subj_id_to_delete,
            'message' => 'Tout est OK: '),
        200);
    }

    // If we reach this point, it means that something went wrong
    return new JsonResponse(array(
        'status' => 'Error',
        'message' => 'Error generation notation DB'),
    400);
    }


    public function primitifline(Environment $twig, LoggerInterface $logger)
    {

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();

        $logger->debug("scale_right: " . $scale_right);
        // Anyone can access to the manager but only limited people can input the date
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){

            $is_class_valid = false;
            $vcc_id = 0;
            $vcc_shortclass = '';
            $nbr_exam = 0;
            if(isset($_POST["vcc-id"])){
                if(intval($_POST["vcc-id"]) > 0){
                    $vcc_id = intval($_POST["vcc-id"]);
                    $is_class_valid = true;
                }
            }
            if(isset($_POST["vcc-shortclass"])){
                $vcc_shortclass = $_POST["vcc-shortclass"];
                $is_class_valid = true;
            }
            else{
                $is_class_valid = false;
            }

            if(isset($_POST["nbrExam"])){
                if(intval($_POST["nbrExam"]) > 0){
                    $nbr_exam = intval($_POST["nbrExam"]);
                    $is_class_valid = true;
                }
            }

            if(!$is_class_valid){
                $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
            }
            else{
                $dbconnectioninst = DBConnectionManager::getInstance();
                
                $query_all_primitif_line = " SELECT * FROM v_primitif_line WHERE VSH_COHORT_ID = " . $vcc_id . "; ";
                $logger->debug("query_all_primitif_line: " . $query_all_primitif_line);
                $logger->debug("primitifline - Firstname: " . $_SESSION["firstname"]);
                
                $result_query_all_primitif_line = $dbconnectioninst->query($query_all_primitif_line)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_query_all_primitif_line: " . count($result_query_all_primitif_line));


                $get_default_year_query = " SELECT par_value AS DEF_YEAR FROM uac_param WHERE key_code = 'YEARAAA'; ";
                $logger->debug("Show me get_default_year_query: " . $get_default_year_query);
                $result_get_default_year_query = $dbconnectioninst->query($get_default_year_query)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me: " . $result_get_default_year_query[0]['DEF_YEAR']);

                $default_year = $result_get_default_year_query[0]['DEF_YEAR'];
                
                $content = $twig->render('Admin/GRA/primitifline.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                        'firstname' => $_SESSION["firstname"],
                                                                        'lastname' => $_SESSION["lastname"],
                                                                        'id' => $_SESSION["id"],
                                                                        'scale_right' => ConnectionManager::whatScaleRight(),
                                                                        'result_query_all_primitif_line' => $result_query_all_primitif_line,
                                                                        'vcc_shortclass' => $vcc_shortclass,
                                                                        'nbr_exam' => $nbr_exam,
                                                                        'default_year' => $default_year,
                                                                        'errtype' => '']);
            }
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }

    public function readonlyexam(Environment $twig, LoggerInterface $logger)
    {

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();

        $logger->debug("readonlyexam -- scale_right: " . $scale_right);
        // Anyone can access to the manager but only limited people can input the date
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){

            if(isset($_POST["readonly-master-id"]) && (intval($_POST["readonly-master-id"]) > 0)){
                $master_id = intval($_POST["readonly-master-id"]);
                $dbconnectioninst = DBConnectionManager::getInstance();

                $query_one_ugm = " SELECT * FROM v_master_exam WHERE UGM_ID=" . $master_id . "; ";
                $logger->debug("query_all_ugm: " . $query_one_ugm);
                $logger->debug("readonlyexam - Firstname: " . $_SESSION["firstname"]);
                $result_one_ugm = $dbconnectioninst->query($query_one_ugm)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_all_ugm: " . count($result_one_ugm));
    


                $query_all_ugg = " SELECT * FROM v_grade_exam WHERE UGG_MASTER_ID =" . $master_id . " ORDER BY VSH_USERNAME; ";
                $logger->debug("query_all_ugg: " . $query_all_ugg);
                $result_all_ugg = $dbconnectioninst->query($query_all_ugg)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show me result_all_ugm: " . count($result_all_ugg));

                $class_per_subject_query = " SELECT urs.id AS URS_ID, GROUP_CONCAT(vcc.short_classe ORDER BY vcc.id ASC SEPARATOR ' + ') AS GRP_VCC_SHORT_CLASS, GROUP_CONCAT(vcc.ID SEPARATOR '|') AS GRP_VCC_ID FROM uac_ref_subject urs  "
                                        . " JOIN uac_xref_subject_cohort xref ON urs.id = xref.subject_id "
                                        . " JOIN v_class_cohort vcc ON vcc.id = xref.cohort_id WHERE urs.id = " . $result_one_ugm[0]['UGM_SUBJECT_ID'] . " GROUP BY urs.id; ";
                $logger->debug("Show me class_per_subject_query: " . $class_per_subject_query);
                $result_class_per_subject_query = $dbconnectioninst->query($class_per_subject_query)->fetchAll(PDO::FETCH_ASSOC);


                $stat_average = " SELECT CASE WHEN ugg.gra_status IN ('A', 'E') THEN ugg.gra_status WHEN ugg.grade < 10 THEN 'BAVG' ELSE 'AAVG' END AS CATEGORY, COUNT(1) AS COUNT_PART FROM uac_gra_grade ugg "
                                . " WHERE ugg.master_id = " . $master_id . " GROUP BY CASE WHEN ugg.gra_status IN ('A', 'E') THEN ugg.gra_status WHEN ugg.grade < 10 THEN 'BAVG' ELSE 'AAVG' END; ";
                $logger->debug("Show stat_average: " . $stat_average);
                $result_stat_average = $dbconnectioninst->query($stat_average)->fetchAll(PDO::FETCH_ASSOC);

                $stat_grade_rep = " SELECT CASE WHEN ugg.grade < 2 THEN '0' WHEN ugg.grade < 4 THEN '1' WHEN ugg.grade < 6 THEN '2' WHEN ugg.grade < 8 THEN '3' WHEN ugg.grade < 10 THEN '4' "
                                    . " WHEN ugg.grade < 12 THEN '5' WHEN ugg.grade < 14 THEN '6' WHEN ugg.grade < 16 THEN '7' WHEN ugg.grade < 18 THEN '8' ELSE '9' END AS ORD, "
                                    . " CASE WHEN ugg.grade < 2 THEN '0-2' WHEN ugg.grade < 4 THEN '2-4' WHEN ugg.grade < 6 THEN '4-6' WHEN ugg.grade < 8 THEN '6-8' WHEN ugg.grade < 10 THEN '8-10' "
                                    . " WHEN ugg.grade < 12 THEN '10-12' WHEN ugg.grade < 14 THEN '12-14' WHEN ugg.grade < 16 THEN '14-16' WHEN ugg.grade < 18 THEN '16-18' ELSE '18-20' END AS CATEGORY, "
                                    . " COUNT(1) AS CPT FROM uac_gra_grade ugg WHERE ugg.master_id = " . $master_id . " AND ugg.gra_status IN ('P') "
                                    . " GROUP BY CATEGORY, ORD ORDER BY ORD; ";
                $logger->debug("Show stat_grade_rep: " . $stat_grade_rep);
                $result_stat_grade_rep = $dbconnectioninst->query($stat_grade_rep)->fetchAll(PDO::FETCH_ASSOC);
    
                $content = $twig->render('Admin/GRA/readonlyexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                        'firstname' => $_SESSION["firstname"],
                                                                        'lastname' => $_SESSION["lastname"],
                                                                        'id' => $_SESSION["id"],
                                                                        'scale_right' => ConnectionManager::whatScaleRight(),
                                                                        'result_one_ugm' => $result_one_ugm,
                                                                        'result_all_ugg' => $result_all_ugg,
                                                                        'result_class_per_subject_query' => $result_class_per_subject_query,
                                                                        'result_stat_average' => $result_stat_average,
                                                                        'result_stat_grade_rep' => $result_stat_grade_rep,
                                                                        'errtype' => '']);
            }
            else{
                //404
                $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
            }
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


}
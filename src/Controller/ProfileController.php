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

class ProfileController extends AbstractController{
  private static $my_exact_access_right = 41;

  public function show(Environment $twig, LoggerInterface $logger, $page, $week)
  {


    $logger->debug("This page: " . $page);
    // Usually this means N for No
    $from_admin = 'N';
    $write_access = 'N';
    $result_query_get_all_classes = [];
    $result_query_get_all_mention = [];
    $agent_id = 0;

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
    else if(isset($_POST["postfrompaymngr_page"])){
          // Coming from payment manager
          $page = $_POST["postfrompaymngr_page"];
          // Coming from payment manager
          $from_admin = 'P';
    }
    else{
      //Do nothing
    }

    $logger->debug("See from_admin: " . $from_admin);
    // N : default No - S : Student from Manager Etudiant - A : Assiduite from Dashboard Retard - P : Payment Manager


    if(strlen($page) < 11){
      // Error Code 404
      $logger->debug("Went here (strlen(page) < 11) ");
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
            $result_get_token = "NA";
            //Check if we are coming from POST
            if($from_admin == 'Y')
            {
                // It is from Admin
                $dashorigin = "'A', " . $_SESSION["id"];
            };

            // S is from Student Manager
            // I need to retrieve session information
            if($from_admin == 'S'){
              if (session_status() == PHP_SESSION_NONE) {
                SessionManager::getSecureSession();
              }
          
              $scale_right = ConnectionManager::whatScaleRight();
              if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
                  $result_get_token = $this->getDailyTokenPayStr($logger);
                  $write_access = 'Y';

                  $agent_id = $_SESSION["id"];
                  $query_get_all_mention = " SELECT * FROM uac_ref_mention; ";
                  $logger->debug("Query query_get_all_mention: " . $query_get_all_mention);
                  $result_query_get_all_mention = $dbconnectioninst->query($query_get_all_mention)->fetchAll(PDO::FETCH_ASSOC);
                  $logger->debug("Show result_query_get_all_mention: " . count($result_query_get_all_mention));

                  $query_get_all_classes = " SELECT vcc.id AS VCC_ID, vcc.mention_code AS VCC_MENTION_CODE, vcc.mention AS VCC_MENTION_TITLE, vcc.short_classe AS VCC_SHORT_CLASSE FROM v_class_cohort vcc ORDER BY vcc.short_classe; ";
                  $logger->debug("Query query_get_all_classes: " . $query_get_all_classes);
                  $result_query_get_all_classes = $dbconnectioninst->query($query_get_all_classes)->fetchAll(PDO::FETCH_ASSOC);
                  $logger->debug("Show result_query_get_all_classes: " . count($result_query_get_all_classes));
              }
            }
            
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

            $query_msg_ass = " SELECT key_code AS KEY_CODE, IFNULL(par_value, 'na') AS PAR_VALUE FROM uac_param WHERE key_code = 'MSGASSI'; ";
            $logger->debug("Show me query_msg_ass: " . $query_msg_ass);
            $result_query_msg_ass = $dbconnectioninst->query($query_msg_ass)->fetchAll(PDO::FETCH_ASSOC);

            $query_ass_recap = " SELECT ass.status AS STATUS, "
                                      .  " uae.hour_starts_at AS DEBUT, DATE_FORMAT(uae.day, '%d/%m') AS JOUR, REPLACE(SUBSTRING(uae.raw_course_title, 1, 20), '\n', ' ') AS COURS, sca.scan_date AS SCAN_DATE, sca.scan_time AS SCAN_TIME, "
                                      . " UPPER(DAYNAME(uae.day)) AS LABEL_DAY_EN, uae.day AS TECH_DAT, uae.hour_starts_at AS TECH_DEBUT, uae.min_starts_at AS TECH_DEBUT_HALF "
                                      . " FROM uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id "
                      								. " JOIN uac_showuser uas ON mu.username = uas.username "
                      									  . " JOIN uac_edt_line uae ON uae.id = ass.edt_id "
                      									  . " LEFT JOIN uac_scan sca ON sca.id = ass.scan_id "
                                          . " WHERE mu.id = " . $result[0]['ID']
                                          . " AND uae.day NOT IN (SELECT working_date FROM uac_assiduite_off) UNION ";
            $query_ass_recap = "SELECT * FROM ( "
                                . $query_ass_recap
                                . " SELECT 'XXX' AS STATUS, '0' AS DEBUT, DATE_FORMAT(working_date, '%d/%m') AS JOUR, 'XXX' AS COURS, NULL AS SCAN_DATE, NULL AS SCAN_TIME, UPPER(DAYNAME(working_date)) AS "
                                . " LABEL_DAY_EN, working_date AS TECH_DAT, 0 AS TECH_DEBUT, 0 AS TECH_DEBUT_HALF FROM uac_assiduite_off ) a "
                                          . " ORDER BY ADDTIME(TECH_DAT, CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(TECH_DEBUT) = 1) THEN CONCAT('0', TECH_DEBUT) ELSE TECH_DEBUT END, ':',  CASE WHEN (CHAR_LENGTH(TECH_DEBUT_HALF) = 1) THEN '00' ELSE TECH_DEBUT_HALF END,':00'), TIME)) DESC;";

            $logger->debug("Query query_ass_recap: " . $query_ass_recap);

            $result_assiduite_recap = $dbconnectioninst->query($query_ass_recap)->fetchAll(PDO::FETCH_ASSOC);


            $query_list_bdaymonth = "SELECT fCapitalizeStr(TRIM(FIRSTNAME)) AS FNAMEBDAY FROM v_showuser WHERE COHORT_ID = " . $result[0]['COHORT_ID']
                                    . " AND MONTHBDAY = DATE_FORMAT(CURRENT_DATE, '%m')";

            $logger->debug("Query query_list_bdaymonth: " . $query_list_bdaymonth);
            $result_list_bdaymonth = $dbconnectioninst->query($query_list_bdaymonth)->fetchAll(PDO::FETCH_ASSOC);

            $query_stat_ass = " CALL CLI_ASS_GetAssStatPerStu(" . $result[0]['ID'] . ");";
            $logger->debug("Query query_stat_ass: " . $query_stat_ass);
            $result_query_stat_ass = $dbconnectioninst->query($query_stat_ass)->fetchAll(PDO::FETCH_ASSOC);

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
            // Try first the JQ importation
            $import_query = "CALL CLI_GET_FWEDTJQ('" . $result[0]['USERNAME'] . "', " . $week . ", 'N')";
            $logger->debug("Get EDT CLI_GET_FWEDTJQ: " . $import_query);
            $resultsp = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

            $techInvMonday = $resultsp[0]['inv_tech_monday'];

            $import_query = "CALL CLI_GET_FWEDTJQ('" . $result[0]['USERNAME'] . "', " . $week . ", 'Y')";
            $logger->debug("Get EDT with backup: " . $import_query);
            $resultspbackup = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

            // By default we consider we are on EDT JQ
            $modeIsJQ = 'Y';
            if($resultsp[0]['jq_edt_type'] == 'N'){
              $modeIsJQ = 'N';

              // Depricated
              // Perform the importation
              // Change the option here !
              $import_query = "CALL CLI_GET_FWEDT('" . $result[0]['USERNAME'] . "', " . $week . ", 'N')";
              $logger->debug("Get EDT CLI_GET_FWEDT: " . $import_query);
              $resultsp = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

              $import_query = "CALL CLI_GET_FWEDT('" . $result[0]['USERNAME'] . "', " . $week . ", 'Y')";
              $logger->debug("Get EDT with backup: " . $import_query);
              $resultspbackup = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

            }

            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /******************************************************************  START PAYMENT  ************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/

            $does_pay_display = " SELECT par_code FROM uac_param WHERE key_code = 'PAYDSHV'; ";
            $result_does_pay_display = $dbconnectioninst->query($does_pay_display)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show does_pay_display: " . $result_does_pay_display[0]['par_code']);
    
            $param_does_pay_display = $result_does_pay_display[0]['par_code'];

            $does_pay_public = " SELECT par_code FROM uac_param WHERE key_code = 'PAYPUBL'; ";
            $result_does_pay_public = $dbconnectioninst->query($does_pay_public)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show does_pay_public: " . $result_does_pay_public[0]['par_code']);
    
            $param_does_pay_public = $result_does_pay_public[0]['par_code'];


            if($param_does_pay_display == 'Y'){

                // Get frais mvola
                $param_frais_mvola = 0;
                $frais_mvola = " SELECT amount AS FRAIS_RETRAIT_MVOLA FROM uac_ref_frais_scolarite WHERE code = 'FRMVOLA'; ";
                $result_frais_mvola = $dbconnectioninst->query($frais_mvola)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show result_frais_mvola: " . $result_frais_mvola[0]['FRAIS_RETRAIT_MVOLA']);
        
                $param_frais_mvola = $result_frais_mvola[0]['FRAIS_RETRAIT_MVOLA'];

                $last_mvola = " SELECT DATE_FORMAT(par_date, '%d/%m/%Y') AS LAST_DATE, par_time AS LAST_TIME FROM uac_param WHERE key_code = 'MVOLUPD'; ";
                $result_last_mvola = $dbconnectioninst->query($last_mvola)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show result_last_mvola: " . $result_last_mvola[0]['LAST_DATE']);


                $query_getpay = " SELECT * FROM v_histopayment_for_user vpu WHERE VSH_USERNAME = '" . $param_username . "' AND CONCAT(vpu.REF_TYPE, IFNULL(vpu.UP_PAYMENT_REF, '')) NOT IN ('T') ORDER BY REF_FS_ORDER, UP_PAY_DATE ASC; ";
                $logger->debug("Show me query_getpay: " . $query_getpay);
      
                $query_getfrais = " SELECT * FROM v_histo_frais_for_user vpu WHERE VSH_USERNAME = '" . $param_username . "' ORDER BY REF_FS_ORDER, UP_PAY_DATE ASC; ";
                $logger->debug("Show me query_getfrais: " . $query_getfrais);
      
                $query_getsumpertranche = " CALL CLI_PAY_GetSumUpTranche('" . $param_username . "'); ";
                $logger->debug("Show me query_getsumpertranche: " . $query_getsumpertranche);

                $param_le_limit = 0;
                $query_limit_le = " SELECT par_int AS LE_LIMIT FROM uac_param WHERE key_code = 'PAYLEXX'; ";
                $result_query_limit_le = $dbconnectioninst->query($query_limit_le)->fetchAll(PDO::FETCH_ASSOC);
                $logger->debug("Show result_query_limit_le: " . $result_query_limit_le[0]['LE_LIMIT']);
                $param_le_limit = $result_query_limit_le[0]['LE_LIMIT'];

                $query_sumupfds = "SELECT CASE WHEN (FF_COUNT = 'KO') THEN 1 WHEN (SCNLATE >= 0) THEN 0 WHEN (SCRTP > 0) AND (SCLE = 'L') AND (SCNLATE > -" . $param_le_limit . ") THEN 0 ELSE SCRTP END AS RES_SCRTP FROM v_scan_for_late_user WHERE SCUSN = '" . $param_username . "'; ";
                $logger->debug("Show me query_sumupfds: " . $query_sumupfds);
      
                //Be carefull if you have array of array
                $dbconnectioninst = DBConnectionManager::getInstance();
      
                $result_pay = $dbconnectioninst->query($query_getpay)->fetchAll(PDO::FETCH_ASSOC);
                $result_frais = $dbconnectioninst->query($query_getfrais)->fetchAll(PDO::FETCH_ASSOC);
                $result_query_sumupfds = $dbconnectioninst->query($query_sumupfds)->fetchAll(PDO::FETCH_ASSOC);
                
                $result_histo_pay = array();
                if(count($result_frais) > 0){
                  $result_histo_pay = array_merge($result_pay, $result_frais); 
                }
                else{
                  $result_histo_pay = $result_pay;
                }
                $resultSumPerTranche = $dbconnectioninst->query($query_getsumpertranche)->fetchAll(PDO::FETCH_ASSOC);
      
                $logger->debug("Show me count result_histo_pay: " . count($result_histo_pay));
                $logger->debug("Show me count resultSumPerTranche: " . count($resultSumPerTranche));
            }
            else{
                $param_frais_mvola = 0;
                $param_le_limit = 0;
                $result_histo_pay = array();
                $resultSumPerTranche = array();
                $result_query_sumupfds = array();
            }




            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /******************************************************************   END PAYMENT   ************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/

            $does_gra_module = " SELECT par_code FROM uac_param WHERE key_code = 'GRAMODV'; ";
            $result_does_gra_module = $dbconnectioninst->query($does_gra_module)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show does_pay_public: " . $result_does_gra_module[0]['par_code']);
    
            $param_does_gra_module = $result_does_gra_module[0]['par_code'];

            $does_gra_public = " SELECT par_code FROM uac_param WHERE key_code = 'GRAPUBL'; ";
            $result_does_gra_public = $dbconnectioninst->query($does_gra_public)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show does_pay_public: " . $result_does_gra_public[0]['par_code']);
    
            $param_does_gra_public = $result_does_gra_public[0]['par_code'];
            $result_query_all_grade = array();

            if($param_does_gra_module == 'Y'){
              $query_all_grade = " SELECT * FROM v_stu_grade WHERE UGG_STU_ID=" . $result[0]['ID'] . "; ";
              $result_query_all_grade = $dbconnectioninst->query($query_all_grade)->fetchAll(PDO::FETCH_ASSOC);
              $logger->debug("Show result_query_all_grade: " . count($result_query_all_grade));
            }


            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /******************************************************************    END GRADE    ************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/

            $query_user_ass_info = " SELECT * FROM uac_user_info WHERE id =" . $result[0]['ID'] . "; ";
            $logger->debug("Show me query_user_ass_info: " . $query_user_ass_info);

            $result_query_user_ass_info = $dbconnectioninst->query($query_user_ass_info)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_user_ass_info: " . count($result_query_user_ass_info));

            $query_eph = " SELECT eph_year AS EPH_YEAR, description AS EPH_DESCRIPTION FROM uac_ref_ephemeride WHERE eph_day = DATE_FORMAT(CURDATE(), '%d-%m') ORDER BY RAND() LIMIT 2; ";
            $logger->debug("Show me query_eph: " . $query_eph);

            $result_query_eph = $dbconnectioninst->query($query_eph)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_eph: " . count($result_query_eph));

            $content = $twig->render('Profile/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight(), 'profile' => $result[0],
                                      'agent_id' => $agent_id,
                                      'assiduites' => $result_assiduite, 'moodle_url' => $_ENV['MDL_URL'], 'current_url' => $_ENV['MAIN_URL'],
                                      'recap_assiduites'=>$result_assiduite_recap, 'from_admin' => $from_admin,
                                      'modeIsJQ' => $modeIsJQ,
                                      'techInvMonday' => $techInvMonday,
                                      "sp_result"=>$resultsp, /*"resultsp_sm"=>$week_p_one,*/ "resultsp_sm_bkp"=>$resultspbackup,
                                      "week"=>$week, "page"=>$page, "prec_maxweek"=>$prec_maxweek, "next_maxweek"=>$next_maxweek,
                                      "result_query_queued_ass"=>$result_query_queued_ass,
                                      "result_query_msg_ass"=>$result_query_msg_ass,
                                      "result_list_bdaymonth"=>$result_list_bdaymonth,
                                      "param_does_pay_display"=>$param_does_pay_display,
                                      "param_does_pay_public"=>$param_does_pay_public,
                                      "result_histo_pay"=>$result_histo_pay,
                                      "result_query_sumupfds"=>$result_query_sumupfds,
                                      "resultSumPerTranche"=>$resultSumPerTranche,
                                      'result_query_eph'=>$result_query_eph,
                                      "param_le_limit"=>$param_le_limit,
                                      "param_frais_mvola"=>$param_frais_mvola,
                                      "result_last_mvola"=>$result_last_mvola,
                                      "result_query_get_all_classes"=>$result_query_get_all_classes,
                                      "result_query_get_all_mention"=>$result_query_get_all_mention,
                                      "result_query_stat_ass"=>$result_query_stat_ass,
                                      "param_does_gra_module"=>$param_does_gra_module,
                                      "param_does_gra_public"=>$param_does_gra_public,
                                      'result_get_token'=>$result_get_token,
                                      'write_access'=>$write_access,
                                      "result_query_user_ass_info"=>$result_query_user_ass_info,
                                      "result_query_all_grade"=>$result_query_all_grade
                                    ]);
      }
    }








    return new Response($content);
  }


  public function generateProfileModifyDB(Request $request, LoggerInterface $logger)
  {


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
          $result_get_token = $this->getDailyTokenPayStr($logger);
          $param_token = $request->request->get('token');

          if(strcmp($result_get_token, $param_token) !== 0){
              // We need to out as error
              // This may be a corrupted action
              return new JsonResponse(array(
                  'status' => 'Error',
                  'message' => 'Err672 ticket corrompu'),
              400);
          }

          // TOKEN IS OK

          // Get data from ajax
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_user_id = $request->request->get('foundUserId');
          $param_living_conf = $request->request->get('paramLivinConf');
          $param_cohort_id = $request->request->get('paramCohortId');
          $param_lastname = $request->request->get('paramLastname');
          $param_firstname = $request->request->get('paramFirstname');
          $param_othfirstname = $request->request->get('paramOthfirstname');
          $param_matricule = $request->request->get('paramMatricule');
          $param_phone1 = $request->request->get('paramPhone1');
          $param_phone_par1 = $request->request->get('paramPhonePar1');
          $param_phone_par2 = $request->request->get('paramPhonePar2');
          $param_ass_info = $request->request->get('paramNoteStu');
          //echo $param_jsondata[0]['username'];
          $query_call_modify = " CALL CLI_STU_Modify(" . $param_agent_id . ", " . $param_user_id . ", '" . $param_living_conf . "', " . $param_cohort_id . ", '"
                    . $param_lastname . "', '" . $param_firstname . "', '" . $param_othfirstname . "', '" . $param_matricule . "', '". $param_phone1 . "', '"
                    . $param_phone_par1 . "', '" . $param_phone_par2 . "', '" . $param_ass_info . "');";
          $logger->debug("Show me query_call_modify: " . $query_call_modify);

 
          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();
          $resultquery_call_modify = $dbconnectioninst->query($query_call_modify)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count resultquery_call_modify: " . count($resultquery_call_modify));

          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'result' => $resultquery_call_modify,
              'message' => 'Tout est OK: '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Err134P récupération payments'),
      400);
  }


  public function didiapply(Environment $twig, LoggerInterface $logger)
  {

    $content = $twig->render('Profile/didiapply.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    return new Response($content);
  }

  // We use the pay token
  private function getDailyTokenPayStr(LoggerInterface $logger){
    // Get me the token !
    $get_token_query = "SELECT fGetDailyTokenPayment() AS TOKEN;";
    $logger->debug("Show me get_token_query: " . $get_token_query);
    $dbconnectioninst = DBConnectionManager::getInstance();
    $result_get_token = $dbconnectioninst->query($get_token_query)->fetchAll(PDO::FETCH_ASSOC);
    $logger->debug("result_get_token: " . $result_get_token[0]["TOKEN"]);

    return $result_get_token[0]["TOKEN"];
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

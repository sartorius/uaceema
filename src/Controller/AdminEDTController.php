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
  public function jqcreateedt(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();
    // Must be exactly 8 or more than 99
    if(isset($scale_right) &&  (($scale_right == 11) || ($scale_right > 99))){

        $edit_rights = 'N';
        if(($scale_right == 11) || ($scale_right > 99)){
          $edit_rights = 'Y';
        }
        $mode = 'CRT';
        // Create it as empty
        $result_load_edt = array();

        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $logger->debug("****************************************************************");
        /****************** Start : Cartouche ******************/
        /*
        $mention_query = " SELECT * FROM uac_ref_mention; ";
        $logger->debug("Show me mention_query: " . $mention_query);

        $allclass_query = " SELECT * FROM v_class_cohort; ";
        $logger->debug("Show me allclass_query: " . $allclass_query);

        $count_stu_query = " SELECT COHORT_ID AS COHORT_ID, COUNT(1) AS CPT_STU FROM v_showuser GROUP BY COHORT_ID; ";
        $logger->debug("Show me count_stu_query: " . $count_stu_query);

        $allroom_query = " SELECT id, name, capacity, category, size, is_video FROM uac_ref_room WHERE available = 'Y' ORDER BY rm_order, capacity ASC; ";
        $logger->debug("Show me allroom_query: " . $allroom_query);


        $dbconnectioninst = DBConnectionManager::getInstance();

        $result_mention_query = $dbconnectioninst->query($mention_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_mention_query));

        $result_allclass_query = $dbconnectioninst->query($allclass_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_allclass_query));

        $result_count_stu_query = $dbconnectioninst->query($count_stu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_count_stu_query));

        $result_allroom_query = $dbconnectioninst->query($allroom_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_allroom_query));
        */
        /****************** End : Cartouche ******************/
        $logger->debug("****************************************************************");
        /*
        $log_timestamp = strtotime('2023-04-10');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Monday code : " . $log_day_of_week . " Date: " . $log_day );

        $log_timestamp = strtotime('2023-04-11');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Tuesday code : " . $log_day_of_week . " Date: " . $log_day );

        $log_timestamp = strtotime('2023-04-12');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Wednesday code : " . $log_day_of_week . " Date: " . $log_day );

        $log_timestamp = strtotime('2023-04-13');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Thursday code : " . $log_day_of_week . " Date: " . $log_day );

        $log_timestamp = strtotime('2023-04-14');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Friday code : " . $log_day_of_week . " Date: " . $log_day );

        $log_timestamp = strtotime('2023-04-15');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Saturday code : " . $log_day_of_week . " Date: " . $log_day );

        $log_timestamp = strtotime('2023-04-16');
        $log_day = date('D', $log_timestamp);
        $log_day_of_week = date('w', $log_timestamp);
        $logger->debug("Show me Sunday code : " . $log_day_of_week . " Date: " . $log_day );
        */

        /*
        ****************************************************************
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Monday code : 1 Date: Mon
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Tuesday code : 2 Date: Tue
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Wednesday code : 3 Date: Wed
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Thursday code : 4 Date: Thu
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Friday code : 5 Date: Fri
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Saturday code : 6 Date: Sat
        [Application] Apr 16 11:20:55 |DEBUG  | APP    Show me Sunday code : 0 Date: Sun

        */



        $my_date_current = date('Y-m-d');
        $day_of_week = date('w', strtotime($my_date_current));

        if($day_of_week == 0){
          // Then we are Sunday
          $day_of_week = 6;
        }
        else{
          $day_of_week = $day_of_week - 1;
        }
        $my_tech_monday = $my_date_current. ' - ' . $day_of_week . ' days';
        /*
        $my_date_mon_s0 =date('Y-m-d', strtotime($my_date_current. ' - ' . $day_of_week . ' days'));
        $my_date_mon_s_1 =date('Y-m-d', strtotime($my_date_mon_s0. ' - 7 days'));
        $my_date_mon_s1 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 7 days'));
        $my_date_mon_s2 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 14 days'));
        $my_date_mon_s3 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 21 days'));

        $logger->debug("Show me my_date_current: " . $my_date_current . " Day: " . $day_of_week . " S0: " . $my_date_mon_s0);

        $logger->debug("Show me my_date_mon_s0: " . $my_date_mon_s0 . " : " . date_format(date_create($my_date_mon_s0),"d/m"));
        $logger->debug("Show me my_date_mon_s_1: " . $my_date_mon_s_1 . " : " . date_format(date_create($my_date_mon_s_1),"d/m"));
        $logger->debug("Show me my_date_mon_s1: " . $my_date_mon_s1 . " : " . date_format(date_create($my_date_mon_s1),"d/m"));
        $logger->debug("Show me my_date_mon_s3: " . $my_date_mon_s3 . " : " . date_format(date_create($my_date_mon_s3),"d/m"));

        $logger->debug("****************************************************************");
        $tech_mondays = array($my_date_mon_s_1, $my_date_mon_s0, $my_date_mon_s1, $my_date_mon_s3);
        $disp_mondays = array(date_format(date_create($my_date_mon_s_1),"d/m"),
                              date_format(date_create($my_date_mon_s0),"d/m"),
                              date_format(date_create($my_date_mon_s1),"d/m"),
                              date_format(date_create($my_date_mon_s3),"d/m"));
        */
        $tech_mondays = array();
        $disp_mondays = array();
        $result_mention_query = array();
        $result_allclass_query = array();
        $result_count_stu_query = array();
        $result_allroom_query = array();
        
        // Hydrate everything
        $this->hydrateJQEDT(
                            $my_tech_monday,
                            $tech_mondays, 
                            $disp_mondays, 
                            $result_mention_query, 
                            $result_allclass_query,
                            $result_count_stu_query,
                            $result_allroom_query,
                            $logger);




        $result_get_token = $this->getDailyTokenEDTStr($logger);

        $content = $twig->render('Admin/EDT/jqcreateedt.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'edit_rights' => $edit_rights,
                                                                'mode' => $mode,
                                                                'tech_mondays'=>$tech_mondays,
                                                                'disp_mondays'=>$disp_mondays,
                                                                'result_get_token'=>$result_get_token,
                                                                'result_mention_query'=>$result_mention_query,
                                                                'result_allclass_query'=>$result_allclass_query,
                                                                'result_allroom_query'=>$result_allroom_query,
                                                                'result_count_stu_query'=>$result_count_stu_query,
                                                                "result_load_edt"=>$result_load_edt,
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }

  public function jqPostEDTDB(Request $request, LoggerInterface $logger)
  {

      if (session_status() == PHP_SESSION_NONE) {
          session_start();
      }

      $scale_right = ConnectionManager::whatScaleRight();
      // Must be exactly 8 or more than 99
      if(isset($scale_right) &&  (($scale_right == 11) || ($scale_right > 99))){
          // We are good
      }
      else{
        // Return error message that access right are KO
        return new JsonResponse(array(
            'status' => 'Err1402',
            'message' => 'Erreur droits access'),
        400);
      }


      // This is optional.
      // Only include it if the function is reserved for ajax calls only.
      if (!$request->isXmlHttpRequest()) {
          return new JsonResponse(array(
              'status' => 'Err1403',
              'message' => 'Erreur mauvaise requete'),
          400);
      }

      if(isset($request->request))
      {

          // Token control
          $result_get_token = $this->getDailyTokenEDTStr($logger);
          $param_token = $request->request->get('token');

          if(strcmp($result_get_token, $param_token) !== 0){
              // We need to out as error
              // This may be a corrupted action
              return new JsonResponse(array(
                  'status' => 'Err1672',
                  'message' => 'Erreur token corrompu'),
              400);
          }

          // Get data from ajax
          $param_user_id = $request->request->get('currentUserId');
          $logger->debug("Show me param_user_id: " . $param_user_id);

          $param_cohort_id = $request->request->get('invCohortId');
          $logger->debug("Show me param_cohort_id: " . $param_cohort_id);

          $param_inv_tech_monday = $request->request->get('invTechMonday');
          $logger->debug("Show me param_inv_tech_monday: " . $param_inv_tech_monday);

          $param_order = $request->request->get('orderEDT');
          $logger->debug("Show me param_order: " . $param_order);

          $param_my_edt_array = json_decode($request->request->get('myEDTArray'), true);
          $logger->debug("Show me param_my_edt_array: " . json_encode($param_my_edt_array));

          //sleep(2);

          // The stamp is to allow us to find back our lines
          $get_time_stamp = time();
          $tag_stamp_for_export = substr($get_time_stamp, -4);
          $logger->debug("Show me get_time_stamp: " . $get_time_stamp . " Stamp: " . $tag_stamp_for_export);
          // tag_stamp_for_export

          //echo $param_jsondata[0]['username'];
          $query_value = ' INSERT INTO uac_load_jqedt ';
          $query_value = $query_value . ' (user_id, tag_stamp_for_export, cohort_id, course_status, label_day, tech_date, day_code, hour_starts_at, min_starts_at, duration_hour, duration_min, raw_course_title, course_id, monday_ofthew, room_id, course_room, display_date, shift_duration, end_time, end_time_hour, end_time_min, start_time, start_time_hour, start_time_min, tech_day, tech_hour) VALUES (';
          // room_id, course_room, display_date, shift_duration, end_time,
          // end_time_hour, end_time_min, start_time, start_time_hour, start_time_min, tech_day, tech_hour) VALUES ';
          $first_comma = ' ';
          foreach ($param_my_edt_array as $read)
          {
              $query_value = $query_value . $first_comma . $param_user_id . ", " . $tag_stamp_for_export . ", " . $param_cohort_id . ", '" . $read['courseStatus'] . "', '"  . $read['refEnglishDay'] . "', '" . $read['techDate'] . "', " . $read['refDayCode'] . ", " . $read['startTimeHour'];
              $query_value = $query_value . ", " . $read['startTimeMin'] . ", " . $read['hourDuration'] . ", " . $read['minuteDuration'] . ", '" . addslashes($read['rawCourseTitle']) . "', '" . $read['courseId'] . "', '" . $read['techDateMonday'];
              $query_value = $query_value . "', " . $read['courseRoomId'] . ", '" . $read['courseRoom'] . "', '" . $read['displayDate'] . "', " . $read['shiftDuration'] . ", '" . $read['endTime'];
              $query_value = $query_value . "', " . $read['endTimeHour'] . ", " . $read['endTimeMin'] . ", '" . $read['startTime'] . "', " . $read['startTimeHour'] . ", " . $read['startTimeMin'];
              $query_value = $query_value . ", '" . $read['techDay'] . "', '" . $read['techDay'];
              $first_comma = "'), (";
          }
          $query_value = $query_value . "');";

          $logger->debug("Show me query_value: " . $query_value);

          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
          $logger->debug("Show me count result: " . count($result));


          $query_integration_EDT = "CALL SRV_CRT_JQEDT (" . $tag_stamp_for_export . ", '" . $param_inv_tech_monday . "', " . $param_cohort_id . ", '" . $param_order .  "' );";
          $logger->debug("Show me query_integration_EDT: " . $query_integration_EDT);

          $result_integration_EDT = $dbconnectioninst->query($query_integration_EDT)->fetchAll(PDO::FETCH_ASSOC);


          // Send all this back to client
          $my_datetime_current = date('d/m/y h:i:s');
          return new JsonResponse(array(
              'status' => 'OK',
              'last_update' => $my_datetime_current,
              'result_integration_EDT' => $result_integration_EDT,
              'message' => 'Termine avec succes'),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Err1567',
          'message' => 'Error publication EDT DB'),
      400);
  }

  private function getDailyTokenEDTStr(LoggerInterface $logger){
    // Get me the token !
    $get_token_query = "SELECT fGetDailyTokenEDT() AS TOKEN;";
    $logger->debug("Show me get_token_query: " . $get_token_query);
    $dbconnectioninst = DBConnectionManager::getInstance();
    $result_get_token = $dbconnectioninst->query($get_token_query)->fetchAll(PDO::FETCH_ASSOC);
    $logger->debug("result_get_token: " . $result_get_token[0]["TOKEN"]);

    return $result_get_token[0]["TOKEN"];
  }

  /*                         UP IS MANUAL CREATION OF EDT FOR HALF TIME                        */
  public function dashboardass(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();


    // Level 4 is necessary to load EDT
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

        $mis_query_pp = " SELECT vcc.short_classe AS CLASSE, REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), \"'\", \" \") AS NAME, COUNT(1) AS VAL, vsu.PAGE AS PAGE from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id "
									        . " JOIN uac_showuser uas ON mu.username = uas.username JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id "
                          . " JOIN v_showuser vsu ON mu.id = vsu.ID "
                          . " WHERE ass.status = 'ABS' "
											    . " GROUP BY mu.firstname, mu.lastname, ass.status, vcc.short_classe, vsu.PAGE ORDER BY COUNT(1) DESC LIMIT 100; ";
        $logger->debug("Show me mis_query_pp: " . $mis_query_pp);

        $query_report = " SELECT UPPER(mu.username) AS USERNAME, mu.matricule AS MATRICULE, REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), \"'\", \" \") AS NAME, "
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
                          . " JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id WHERE ass.status IN ('ABS', 'LAT', 'QUI') AND uel.day NOT IN (SELECT working_date FROM uac_assiduite_off) ORDER BY uel.day DESC LIMIT 2000; ";
        $logger->debug("Show me query_report: " . $query_report);


        $query_course_report = " SELECT * FROM rep_course_dash; ";
        $logger->debug("Show me query_course_report: " . $query_course_report);

        $query_noexit_report = " SELECT * FROM rep_no_exit UNION SELECT * FROM rep_no_entry; ";
        $logger->debug("Show me query_noexit_report: " . $query_noexit_report);

        $query_noexit_graph = " SELECT CLASSE, COUNT(1) AS CPT FROM rep_no_exit WHERE TECH_DATE > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY) GROUP BY CLASSE; ";
        $logger->debug("Show me query_noexit_graph: " . $query_noexit_graph);

        $query_noentry_graph = " SELECT CLASSE, COUNT(1) AS CPT FROM rep_no_entry WHERE TECH_DATE > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY) GROUP BY CLASSE; ";
        $logger->debug("Show me query_noentry_graph: " . $query_noentry_graph);

        $query_lastupd = " select DATE_FORMAT(MAX(last_update), '%d-%m-%Y à %Hh%i') AS LASTUPDATE from uac_working_flow where flow_code IN ('ASSIDUI') order by 1 desc; ";
        $logger->debug("Show me query_lastupd: " . $query_lastupd);

        $query_queued_ass = " SELECT COUNT(1) AS QUEUED_ASS from uac_working_flow where status = 'QUE'; ";
        $logger->debug("Show me query_queued_ass: " . $query_queued_ass);


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


        $result_noexit_report = $dbconnectioninst->query($query_noexit_report)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_noexit_report));

        $result_noentry_report = $dbconnectioninst->query($query_noentry_graph)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_noentry_report));

        $result_noexit_graph = $dbconnectioninst->query($query_noexit_graph)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_noexit_graph));

        $result_lastupd = $dbconnectioninst->query($query_lastupd)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_lastupd));

        $result_query_queued_ass = $dbconnectioninst->query($query_queued_ass)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_query_queued_ass));


        $content = $twig->render('Admin/EDT/dashboardass.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'stats_late'=>$result_stat_late,
                                                                  'stats_mis'=>$result_stat_mis,
                                                                  'stats_mis_pp'=>$result_stat_mis_pp,
                                                                  'result_report'=>$result_report,
                                                                  'result_course_report'=>$result_course_report,
                                                                  'result_noexit_report'=>$result_noexit_report,
                                                                  'result_noexit_graph'=>$result_noexit_graph,
                                                                  'result_noentry_report'=>$result_noentry_report,
                                                                  'result_lastupd'=>$result_lastupd,
                                                                  'result_query_queued_ass'=>$result_query_queued_ass,
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

    // Default is N as old fashin, the new version is Y
    $jq_type = 'N';
    //Check if we are coming from POST
    if(isset($_POST["postmaster_id"]))
    {
        // Get data from ajax
        $logger->debug("See postmaster_id: " . $_POST["postmaster_id"]);
        $master_id = $_POST["postmaster_id"];
    }

    if(isset($_POST["postjq_type"]))
    {
        // Get data from ajax
        $logger->debug("See postjq_type: " . $_POST["postjq_type"]);
        $jq_type = $_POST["postjq_type"];
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

              if($jq_type == 'N'){

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
                  $result_get_token = $this->getDailyTokenEDTStr($logger);

                  $edit_rights = 'N';
                  if(($scale_right == 11) || ($scale_right > 99)){
                    $edit_rights = 'Y';
                  }
                  $mode = 'LOA'; //'mode' => $mode,

                  $import_query = "CALL CLI_GET_SHOWJQEDTForADM(" . $master_id . ")";
                  $logger->debug("Show me import_query: " . $import_query);
                  $result_load_edt = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);

                  
                  /************************************ START: CALCULATE THE MONDAYS ************************************/
                  /*
                  $my_date_mon_s0 =date('Y-m-d', strtotime($result_load_edt[0]['inv_tech_monday']));
                  $my_date_mon_s_1 =date('Y-m-d', strtotime($my_date_mon_s0. ' - 7 days'));
                  $my_date_mon_s1 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 7 days'));
                  $my_date_mon_s2 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 14 days'));
                  $my_date_mon_s3 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 21 days'));


                  $logger->debug("Show me my_date_mon_s0: " . $my_date_mon_s0 . " : " . date_format(date_create($my_date_mon_s0),"d/m"));
                  $logger->debug("Show me my_date_mon_s_1: " . $my_date_mon_s_1 . " : " . date_format(date_create($my_date_mon_s_1),"d/m"));
                  $logger->debug("Show me my_date_mon_s1: " . $my_date_mon_s1 . " : " . date_format(date_create($my_date_mon_s1),"d/m"));
                  $logger->debug("Show me my_date_mon_s3: " . $my_date_mon_s3 . " : " . date_format(date_create($my_date_mon_s3),"d/m"));

                  $logger->debug("****************************************************************");
                  $tech_mondays = array($my_date_mon_s_1, $my_date_mon_s0, $my_date_mon_s1, $my_date_mon_s3);
                  $disp_mondays = array(date_format(date_create($my_date_mon_s_1),"d/m"),
                                        date_format(date_create($my_date_mon_s0),"d/m"),
                                        date_format(date_create($my_date_mon_s1),"d/m"),
                                        date_format(date_create($my_date_mon_s3),"d/m"));

                  $logger->debug("Show me tech_mondays: " . json_encode($tech_mondays));
                  $logger->debug("Show me disp_mondays: " . json_encode($disp_mondays));
                  */
                  /************************************ END: CALCULATE THE MONDAYS ************************************/
                  $tech_mondays = array();
                  $disp_mondays = array();
                  $result_mention_query = array();
                  $result_allclass_query = array();
                  $result_count_stu_query = array();
                  $result_allroom_query = array();
                  
                  // Hydrate everything
                  $this->hydrateJQEDT(
                                        $result_load_edt[0]['inv_tech_monday'],
                                        $tech_mondays, 
                                        $disp_mondays, 
                                        $result_mention_query, 
                                        $result_allclass_query,
                                        $result_count_stu_query,
                                        $result_allroom_query,
                                        $logger);

                
                  $logger->debug("****************************************************************");
                  /****************** Start : Cartouche ******************/
                  /*
                  $mention_query = " SELECT * FROM uac_ref_mention; ";
                  $logger->debug("Show me mention_query: " . $mention_query);

                  $allclass_query = " SELECT * FROM v_class_cohort; ";
                  $logger->debug("Show me allclass_query: " . $allclass_query);

                  $count_stu_query = " SELECT COHORT_ID AS COHORT_ID, COUNT(1) AS CPT_STU FROM v_showuser GROUP BY COHORT_ID; ";
                  $logger->debug("Show me count_stu_query: " . $count_stu_query);

                  $allroom_query = " SELECT id, name, capacity, category, size, is_video FROM uac_ref_room WHERE available = 'Y' ORDER BY rm_order, capacity ASC; ";
                  $logger->debug("Show me allroom_query: " . $allroom_query);


                  $dbconnectioninst = DBConnectionManager::getInstance();

                  

                  $result_mention_query = $dbconnectioninst->query($mention_query)->fetchAll(PDO::FETCH_ASSOC);
                  $logger->debug("Show me: " . count($result_mention_query));

                  $result_allclass_query = $dbconnectioninst->query($allclass_query)->fetchAll(PDO::FETCH_ASSOC);
                  $logger->debug("Show me: " . count($result_allclass_query));

                  $result_count_stu_query = $dbconnectioninst->query($count_stu_query)->fetchAll(PDO::FETCH_ASSOC);
                  $logger->debug("Show me: " . count($result_count_stu_query));

                  $result_allroom_query = $dbconnectioninst->query($allroom_query)->fetchAll(PDO::FETCH_ASSOC);
                  $logger->debug("Show me: " . count($result_allroom_query));
                  */
                  /****************** End : Cartouche ******************/
                  $logger->debug("****************************************************************");

                  $content = $twig->render('Admin/EDT/jqcreateedt.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                          'firstname' => $_SESSION["firstname"],
                                                                          'lastname' => $_SESSION["lastname"],
                                                                          'id' => $_SESSION["id"],
                                                                          'edit_rights' => $edit_rights,
                                                                          'mode' => $mode,

                                                                          'tech_mondays'=>$tech_mondays,
                                                                          'disp_mondays'=>$disp_mondays,
                                                                          'result_get_token'=>$result_get_token,

                                                                          'result_mention_query'=>$result_mention_query,
                                                                          'result_allclass_query'=>$result_allclass_query,
                                                                          'result_allroom_query'=>$result_allroom_query,
                                                                          'result_count_stu_query'=>$result_count_stu_query,

                                                                          "result_load_edt"=>$result_load_edt,
                                                                          'scale_right' => ConnectionManager::whatScaleRight(),
                                                                          'errtype' => '']);

              }

          }
          else{
              // Error Code 404
              $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
          }
    }
    return new Response($content);
  }

  private function hydrateJQEDT(
                    $my_tech_monday,
                    &$tech_mondays,
                    &$disp_mondays,
                    &$result_mention_query,
                    &$result_allclass_query,
                    &$result_count_stu_query,
                    &$result_allroom_query,
                    LoggerInterface $logger
  ){
            $my_date_mon_s0 =date('Y-m-d', strtotime($my_tech_monday));
            $my_date_mon_s_1 =date('Y-m-d', strtotime($my_date_mon_s0. ' - 7 days'));
            $my_date_mon_s1 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 7 days'));
            $my_date_mon_s2 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 14 days'));
            $my_date_mon_s3 =date('Y-m-d', strtotime($my_date_mon_s0. ' + 21 days'));


            $logger->debug("Show me my_date_mon_s0: " . $my_date_mon_s0 . " : " . date_format(date_create($my_date_mon_s0),"d/m"));
            $logger->debug("Show me my_date_mon_s_1: " . $my_date_mon_s_1 . " : " . date_format(date_create($my_date_mon_s_1),"d/m"));
            $logger->debug("Show me my_date_mon_s1: " . $my_date_mon_s1 . " : " . date_format(date_create($my_date_mon_s1),"d/m"));
            $logger->debug("Show me my_date_mon_s3: " . $my_date_mon_s3 . " : " . date_format(date_create($my_date_mon_s3),"d/m"));

            $logger->debug("****************************************************************");
            $tech_mondays = array($my_date_mon_s_1, $my_date_mon_s0, $my_date_mon_s1, $my_date_mon_s3);
            $disp_mondays = array(date_format(date_create($my_date_mon_s_1),"d/m"),
                                date_format(date_create($my_date_mon_s0),"d/m"),
                                date_format(date_create($my_date_mon_s1),"d/m"),
                                date_format(date_create($my_date_mon_s3),"d/m"));

            $logger->debug("Show me tech_mondays: " . json_encode($tech_mondays));
            $logger->debug("Show me disp_mondays: " . json_encode($disp_mondays));

            /****************** Start : Cartouche ******************/
            
            $mention_query = " SELECT * FROM uac_ref_mention; ";
            $logger->debug("Show me mention_query: " . $mention_query);

            $allclass_query = " SELECT * FROM v_class_cohort; ";
            $logger->debug("Show me allclass_query: " . $allclass_query);

            $count_stu_query = " SELECT COHORT_ID AS COHORT_ID, COUNT(1) AS CPT_STU FROM v_showuser GROUP BY COHORT_ID; ";
            $logger->debug("Show me count_stu_query: " . $count_stu_query);

            $allroom_query = " SELECT id, name, capacity, category, size, is_video FROM uac_ref_room WHERE available = 'Y' ORDER BY rm_order, capacity ASC; ";
            $logger->debug("Show me allroom_query: " . $allroom_query);

            $dbconnectioninst = DBConnectionManager::getInstance();

            $result_mention_query = $dbconnectioninst->query($mention_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_mention_query));

            $result_allclass_query = $dbconnectioninst->query($allclass_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_allclass_query));

            $result_count_stu_query = $dbconnectioninst->query($count_stu_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_count_stu_query));

            $result_allroom_query = $dbconnectioninst->query($allroom_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_allroom_query));
            
            /****************** End : Cartouche ******************/

  }

  public function validateedt(Environment $twig, LoggerInterface $logger, $master_id)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $maxziplimit = $_ENV['ZIP_LIMIT'];
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
                                                                  'maxziplimit' => $maxziplimit,
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
        $logger->debug("query_all_edt: CALL CLI_GET_MngEDTp3()");

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
    $maxziplimit = $_ENV['ZIP_LIMIT'];
    // Must be exactly 8 or more than 99
    if(isset($scale_right) &&  (($scale_right == 11) || ($scale_right > 99))){


        $logger->debug("Firstname: " . $_SESSION["firstname"]);



        $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'maxziplimit' => $maxziplimit,
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
    // Must be exactly 8 or more than 99
    if(isset($scale_right) && (($scale_right == 11) || ($scale_right > 99))){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $maxziplimit = $_ENV['ZIP_LIMIT'];
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

                                /********************************************************************************/
                                /********************************************************************************/
                                /********************************************************************************/
                                /******************************  DO THE WORK ************************************/
                                /********************************************************************************/
                                /********************************************************************************/
                                /********************************************************************************/
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




  public function extractFileInsertLines($load_type, $load_file, $load_zip, $i_zip, $zip_inside_filename, $previsualisation_line_counter, LoggerInterface $logger, $scale_right){
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
          $short_err = '';


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
                                          $short_err = 'ERR9012 Durée incorrecte';
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
                    elseif(($scale_right == 11) || ($scale_right > 99)){
                      // It is still OK
                      $overpassday = date("d/m/Y", time());
                    }
                    else{
                      $file_is_still_valid = false;
                      $short_err = 'ERRB192 Erreur EDT date passée';
                      $zip_one_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERRB192 Erreur : vous ne pouvez pas charger d\'emploi du temps pour une semaine en cours ou passée ' . $monday . '. Si cette opération est nécessaire, vous devez utilisez un login avec des droits de hierarchie 11* ou Administrateur. Vos droits actuels sont de ' . $scale_right . '.</span>' . '<br>';

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

                      $zip_one_comment = '#'. $previsualisation_line_counter . ' Prévisualisation: ' . $filename_to_log_in . ' /nbr lg: ' . count($resultsp) . ' ' . $zip_one_comment;

                      // If we return the empty line means the course has not been found
                      if(count($resultsp) == 1){
                          $short_err =  'ERR182C Classe introuvable';
                          $report_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR182C Erreur Nous ne pouvons pas identifier la classe de l\'emploi du temps. Veuillez vérifier qu\'elle existe.</span>' . '<br>'
                                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier : ' . $filename_to_log_in . '<br><br>'
                                                            . 'Vérifiez Mention: <strong>' . $mention . '</strong><br>'
                                                            . 'Vérifiez Niveau: <strong>' . $niveau . '</strong><br>'
                                                            . 'Vérifiez Parcours: <strong>' . $parcours . '</strong><br>'
                                                            . 'Vérifiez Groupe: <strong>' . $groupe . '</strong><br><br>'
                                                            . 'Nous n\'arrivons pas à identifier la classe.<br>'
                                                            . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                            . $report_comment;
                      }
                      if(count($resultsp) == 0){
                          $short_err =  'ERR187G Erreur technique';
                          $report_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR187G Erreur Nous n\'arrivons pas à enregistrer l\'emploi du temps, veuillez contacter le support technique.</span>' . '<br>'
                                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier : ' . $filename_to_log_in . '<br><br>'
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
                      $short_err = 'Error8927 Erreur connexion DB';
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
                        "short_err"=>$short_err,
                        "zip_one_comment" => $zip_one_comment);

  }

}

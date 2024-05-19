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

class AdminTeacherController extends AbstractController{
  // - Same as EDT
  private static $my_exact_edtmng_teachermng_access_right = 11;
  // - Teacher access
  private static $my_exact_teacher_access_right = 45;

  public function managertea(Environment $twig, LoggerInterface $logger)
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

        //Writer only EDT access write
        $edit_access = 'N';
        $result_get_token = "NA";
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_edtmng_teachermng_access_right) || ($scale_right > 99))){
          $result_get_token = $this->getDailyTokenPayStr($logger);
          $edit_access = 'Y';
        }

        //By default it is not teacher
        $is_teacher = 'N';
        $teach_clause = '';
        if(isset($scale_right) && ($scale_right == self::$my_exact_teacher_access_right)){
            $is_teacher = 'Y';
            $teach_clause = " AND urt.id IN ( SELECT x.teach_id FROM uac_xref_teacher_mention x JOIN uac_teacher utea ON x.mention_code = utea.mention_code WHERE utea.id = " . $_SESSION["id"] . ") ";
        }



        $allteach_query = " SELECT urt.*, 'N' AS IS_DIRTY, urc.contract_label, TEA_ID, TEA_ALL_MENTION_CODE, IFNULL(SUM_P_SHIFT_DURATION, 0) AS MANSUM_P_SHIFT_DURATION, IFNULL(SUM_M_SHIFT_DURATION, 0) AS MANSUM_M_SHIFT_DURATION, "
                          . " vuel.UEL_TEA_MENTION, vugm.UGM_TEA_MENTION, "
                          . " UPPER(CONCAT(TEA_ID, urt.name, TEA_ALL_MENTION_CODE)) AS raw_data FROM uac_ref_teacher urt JOIN v_all_mention_teacher vat ON urt.id = vat.TEA_ID LEFT JOIN uac_ref_teacher_contract urc ON urt.contract = urc.contract_code "
                          
                          . " LEFT JOIN v_all_presented_per_teacher vp ON vp.VPC_TEA_ID = urt.id "
                          . " LEFT JOIN v_all_missing_per_teacher vm ON vm.VMC_TEA_ID = urt.id "
                          . " LEFT JOIN v_all_exist_uel_mention_teacher vuel ON vuel.UEL_TEA_ID = urt.id "
                          . " LEFT JOIN v_all_exist_ugm_mention_teacher vugm ON vugm.UGM_TEA_ID = urt.id "
                          . " WHERE 1=1 " . $teach_clause . " ORDER BY MANSUM_P_SHIFT_DURATION DESC; ";

        $logger->debug("Show me allteach_query: " . $allteach_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_allteach_query = $dbconnectioninst->query($allteach_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_allteach_query));

        $allmention_code = " SELECT par_code FROM uac_ref_mention; ";
        $logger->debug("Show me allmention_code: " . $allmention_code);
        $result_allmention_code = $dbconnectioninst->query($allmention_code)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_allmention_code: " . count($result_allmention_code));

        $alltitle = " SELECT * FROM uac_ref_title; ";
        $logger->debug("Show me alltitle: " . $alltitle);
        $result_alltitle = $dbconnectioninst->query($alltitle)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_alltitle: " . count($result_alltitle));

        $allcontract = " SELECT * FROM uac_ref_teacher_contract; ";
        $logger->debug("Show me allcontract: " . $allcontract);
        $result_allcontract = $dbconnectioninst->query($allcontract)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_allcontract: " . count($result_allcontract));

        $query_course_report_m0 = " SELECT * FROM rep_course_dash WHERE (UEL_TECH_DAY between  DATE_FORMAT(NOW() ,'%Y-%m-01') AND last_day(curdate())) ORDER BY UEL_TECH_DAY DESC; ";
        $logger->debug("Show me query_course_report_m0: " . $query_course_report_m0);

        $result_query_course_report_m0 = $dbconnectioninst->query($query_course_report_m0)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_course_report_m0: " . count($result_query_course_report_m0));

        $query_course_report_m1 = " SELECT * FROM rep_course_dash " 
                                  // After or equal the first day of last month
                                  . " WHERE UEL_TECH_DAY >= (last_day(curdate() - interval 2 month) + interval 1 day) " 
                                  // Before or equal 
                                  . " AND UEL_TECH_DAY <= (last_day(curdate() - interval 1 month))  "
                                  . " ORDER BY UEL_TECH_DAY DESC; ";
        $logger->debug("Show me query_course_report_m1: " . $query_course_report_m1);

        $result_query_course_report_m1 = $dbconnectioninst->query($query_course_report_m1)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_course_report_m1: " . count($result_query_course_report_m1));
        

        $content = $twig->render('Admin/TEA/managertea.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'result_allmention_code'=>$result_allmention_code,
                                                                  'result_alltitle'=>$result_alltitle,
                                                                  'result_allcontract'=>$result_allcontract,
                                                                  'result_allteach_query'=>$result_allteach_query,
                                                                  'edit_access'=>$edit_access,
                                                                  'result_query_course_report_m0'=>$result_query_course_report_m0,
                                                                  'result_query_course_report_m1'=>$result_query_course_report_m1,
                                                                  'is_teacher'=>$is_teacher,
                                                                  'result_get_token'=>$result_get_token,
                                                                  'scale_right' => ConnectionManager::whatScaleRight(),
                                                                  'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }


  public function generateTeacherModifyCreateDB(Request $request, LoggerInterface $logger)
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
          $param_mode = $request->request->get('paramMode');

          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_id = $request->request->get('paramId');
          $param_title = $request->request->get('paramTitle');
          // Note that it is separated by "," for mysql but "/" on javascript
          $param_all_mention_code = $request->request->get('paramTeaAllMentionCode');
          $param_email = $request->request->get('paramEmail');
          $param_name = $request->request->get('paramName');
          $param_firstname = $request->request->get('paramFirstname');
          $param_lastname = $request->request->get('paramLastname');
          $param_othfirstname = $request->request->get('paramOtherfirstname');
          $param_contract = $request->request->get('paramContract');
          $param_phone_alt = $request->request->get('paramPhoneAlt');
          $param_phone_main = $request->request->get('paramPhoneMain');
          $param_comment = $request->request->get('paramComment');


          
          //echo $param_jsondata[0]['username'];
          $query_call_modify_teacher = " CALL CLI_TEA_Modify('" . $param_mode . "', " . $param_agent_id . ", " . $param_id . ", '" . $param_name . "', '" . $param_title . "', '"
                    . $param_lastname . "', '" . $param_firstname . "', '" . $param_othfirstname . "', '" . $param_contract . "', '". $param_phone_main . "', '"
                    . $param_phone_alt . "', '" . $param_email . "', '" . $param_comment . "', '" . $param_all_mention_code . "');";
          $logger->debug("Show me query_call_modify_teacher: " . $query_call_modify_teacher);

          
          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();
          $resultquery_call_modify_teacher = $dbconnectioninst->query($query_call_modify_teacher)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count resultquery_call_modify_teacher: " . $resultquery_call_modify_teacher[0]['RETURN_VALUE']);
          
          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'result' => $resultquery_call_modify_teacher[0]['RETURN_VALUE'],
              'message' => 'Tout est OK: '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Err834P récupération teacher'),
      400);
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




}

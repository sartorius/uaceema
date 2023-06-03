<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use App\DBUtils\MailManager;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;


class AdminPayController extends AbstractController
{



  public function refpay(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be connected backoffice
    if(isset($scale_right)){


        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        // Get All USERNAME
        $refpay_query = " SELECT * FROM uac_ref_frais_scolarite ORDER BY fs_order ASC; ";

        $logger->debug("Show me allusrn_query: " . $refpay_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_ref_pay = $dbconnectioninst->query($refpay_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_ref_pay: " . count($result_ref_pay));



        $content = $twig->render('Admin/PAY/refpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_ref_pay'=>$result_ref_pay,
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }



  public function addpay(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be exactly 21 or more than 99
    if(isset($scale_right) &&  (($scale_right == 51) || ($scale_right > 99))){


        $result_get_token = $this->getDailyTokenPayStr($logger);


        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        // Get All USERNAME
        $allusrn_query = " SELECT *  from v_payfoundusrn; ";
        $logger->debug("Show me allusrn_query: " . $allusrn_query);

        $allreduc_query = " SELECT UPPER(vhu.USERNAME) AS USERNAME, ufp.ticket_ref AS TICKET_REF, ufp.status AS UFP_STATUS FROM uac_facilite_payment ufp JOIN v_showuser vhu ON ufp.user_id = vhu.ID WHERE ufp.category IN ('R') AND ufp.status IN ('I', 'A', 'D'); ";
        $logger->debug("Show me allreduc_query: " . $allreduc_query);

        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_usrn = $dbconnectioninst->query($allusrn_query)->fetchAll(PDO::FETCH_ASSOC);

        $result_all_reduc = $dbconnectioninst->query($allreduc_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_usrn));



        $content = $twig->render('Admin/PAY/addpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_all_usrn'=>$result_all_usrn,
                                                                'result_all_reduc'=>$result_all_reduc,
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

  public function addpaiddoc(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be exactly 21 or more than 99
    if(isset($scale_right) &&  (($scale_right == 51) || ($scale_right > 99))){


        $result_get_token = $this->getDailyTokenPayStr($logger);


        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        // Get All USERNAME
        $allusrn_query = " SELECT *  from v_payfoundusrn; ";

        $logger->debug("Show me allusrn_query: " . $allusrn_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_usrn = $dbconnectioninst->query($allusrn_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_usrn));



        $content = $twig->render('Admin/PAY/addpaiddoc.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_all_usrn'=>$result_all_usrn,
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


  public function generatefaciliteDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_user_id = $request->request->get('foundUserId');
          $param_ticket_ref = $request->request->get('ticketRef');
          $param_ticket_type = $request->request->get('ticketType');
          $param_red_pc = $request->request->get('redPc');
          // If we in CL this is ignored in the SP
          $param_inv_fsc_id = $request->request->get('invFscId');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddFacilite( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_ticket_type . "', " . $param_red_pc . ", " . $param_inv_fsc_id . ")";

          $logger->debug("Show me query_value: " . $query_value);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'message' => 'Tout est OK: ' . $param_ticket_ref . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket facilité DB'),
      400);
  }

  public function generateDeleteRedDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_ticket_ref = $request->request->get('ticketRef');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " UPDATE uac_facilite_payment SET status = 'D' WHERE ticket_ref = '" . $param_ticket_ref . "'; ";

          $logger->debug("Show me query_value: " . $query_value);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'paramTicketRef' => $param_ticket_ref,
              'message' => 'Tout est OK: ' . $param_ticket_ref . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket facilité DB'),
      400);
  }

  public function generateCancelPaymentDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_ticket_ref = $request->request->get('ticketRef');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CAN_PayCanPaymentPerRef('" . $param_ticket_ref . "'); ";

          $logger->debug("Show me query_value: " . $query_value);

          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'paramTicketRef' => $param_ticket_ref,
              'message' => 'Tout est OK: ' . $param_ticket_ref . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket facilité DB'),
      400);
  }


  public function generateValidateRedDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_user_id = $request->request->get('foundUserId');
          $param_ticket_ref = $request->request->get('ticketRef');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_VAL_PayAddValidate( " . $param_user_id . ", '" . $param_ticket_ref . ")";

          $logger->debug("Show me query_value: " . $query_value);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'paramTicketRef' => $param_ticket_ref,
              'message' => 'Tout est OK: ' . $param_ticket_ref . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket facilité DB'),
      400);
  }

  public function generatepaymentDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_user_id = $request->request->get('foundUserId');
          $param_ticket_ref = $request->request->get('ticketRef');
          $param_amount = $request->request->get('invAmountToPay');
          $param_fsc_id = $request->request->get('invFscId');
          $param_type_of_payment = $request->request->get('invTypeOfPayment');
          

          $pay_uni_left_array = json_decode($request->request->get('payUniLeftOperationForUserJsonArray'), true);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          if(($param_amount == 0) && ($param_fsc_id ==  0)){
                // In that case when amount and fsc id are 0 both then we are on total mode
                foreach ($pay_uni_left_array as $read)
                {
                    $query_value = " CALL CLI_CRT_PayAddPayment( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $read['fscId'] . "', " . $read['inputAmount'] . ", '" . $read['typeOfPayment'] . "')";
                    $logger->debug("Left Operation show me query_value: " . $query_value);
                    $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

                    $logger->debug("Show me count: " . count($result));
                }
          }
          else{
                //echo $param_jsondata[0]['username'];
                //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
                $query_value = " CALL CLI_CRT_PayAddPayment( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_fsc_id . "', " . $param_amount . ", '" . $param_type_of_payment . "')";
                $logger->debug("Show me query_value: " . $query_value);
                $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

                $logger->debug("Show me count: " . count($result));
          }


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'message' => 'Tout est OK: ' . $param_ticket_ref . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket facilité DB'),
      400);
  }


  public function getPaymentDetailsDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_ticket_ref = $request->request->get('ticketRef');
          //echo $param_jsondata[0]['username'];
          $query_getpaydetails = " SELECT vsh.FIRSTNAME AS FIRSTNAME, vsh.LASTNAME AS LASTNAME, vsh.MATRICULE AS MATRICULE, vsh.SHORTCLASS AS SHORTCLASS, vpu.* "
                    . " FROM v_histopayment_for_user vpu JOIN v_showuser vsh ON vsh.ID = vpu.VSH_USER_ID "
                    . " WHERE UP_PAYMENT_REF = '" . $param_ticket_ref . "'; ";
          $logger->debug("Show me query_getpay: " . $query_getpaydetails);

 
          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();
          $result = $dbconnectioninst->query($query_getpaydetails)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));

          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'result' => $result,
              'message' => 'Tout est OK: '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Err134P récupération payments'),
      400);
  }

  public function getpaymentforuserDB(Request $request, LoggerInterface $logger)
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

          // Get data from ajax
          $param_username = $request->request->get('foundUserName');
          //echo $param_jsondata[0]['username'];
          $query_getpay = " SELECT * FROM v_histopayment_for_user vpu WHERE VSH_USERNAME = '" . $param_username . "' ORDER BY REF_FS_ORDER, UP_PAY_DATE ASC; ";
          $logger->debug("Show me query_getpay: " . $query_getpay);

          //$query_getleftoperation = " SELECT MAX(vhu.REF_ID) AS REF_ID, vhu.ref_type AS REF_TYPE from v_histopayment_for_user vhu WHERE vhu.VSH_USERNAME = '" . $param_username . "' AND vhu.UP_ID IS NULL GROUP BY vhu.ref_type; ";
          // This complexe query retrieve a grouping to know if we still have a T or U left (to invalidate or no the button)
          $query_getleftoperation = " SELECT t1.SUM_INPUT, t1.REF_TYPE FROM ( "
                                . " SELECT SUM(vhu.UP_INPUT_AMOUNT) AS SUM_INPUT, vhu.ref_type AS REF_TYPE FROM v_histopayment_for_user vhu "
                                . " WHERE vhu.VSH_USERNAME = '" . $param_username . "' AND vhu.ref_type IN ('T', 'U') "
                                . " GROUP BY vhu.ref_type "
                                . " ) t1 WHERE (t1.SUM_INPUT, t1.REF_TYPE) NOT IN ( "
                                . " SELECT SUM(ref.amount), ref.type "
                                . " FROM uac_xref_cohort_fsc xref JOIN v_showuser vsh ON vsh.COHORT_ID = xref.cohort_id "
                                . " JOIN uac_ref_frais_scolarite ref ON ref.id = xref.fsc_id AND ref.type IN ('T', 'U') "
                                . " AND vsh.USERNAME = '" . $param_username . "' GROUP BY ref.type ) ";
          $logger->debug("Show me query_getleftoperation: " . $query_getleftoperation);

          //We retrieve here the left to be paid and original
          $query_getsumpertranche = " SELECT * FROM (  "
                    . " SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER FROM v_original_to_pay_for_user vop "
                    . " LEFT JOIN uac_payment up ON vop.REF_ID = up.ref_fsc_id AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L' "
                    . " WHERE vop.VSH_USERNAME = '" . $param_username . "' AND vop.TRANCHE_CODE NOT IN ( "
                    . " SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu WHERE tvpu.VSH_USERNAME = '" . $param_username . "') UNION "
                    . " SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER FROM v_left_to_pay_for_user vpu "
                    . " LEFT JOIN uac_payment up ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L' "
                    . " WHERE VSH_USERNAME ='". $param_username . "') t ORDER BY t.URF_FS_ORDER ASC;";

          $logger->debug("Show me query_getsumpertranche: " . $query_getsumpertranche);
 
          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_getpay)->fetchAll(PDO::FETCH_ASSOC);
          $resultLeftOperation = $dbconnectioninst->query($query_getleftoperation)->fetchAll(PDO::FETCH_ASSOC);
          $resultSumPerTranche = $dbconnectioninst->query($query_getsumpertranche)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));

          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'result' => $result,
              'resultLeftOperation' => $resultLeftOperation,
              'resultSumPerTranche' => $resultSumPerTranche,
              'message' => 'Tout est OK: '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Err134P récupération payments'),
      400);
  }

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

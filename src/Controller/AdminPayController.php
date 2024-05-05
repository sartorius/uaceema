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
use App\SessionUtils\SessionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;


class AdminPayController extends AbstractController
{

  private static $my_exact_access_right = 51;
  private static $my_minimum_access_right = 49;
  // self::$my_exact_access_right

  public function refpay(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be connected backoffice
    if(isset($scale_right)){


        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        // Get All USERNAME
        $refpay_query = " SELECT * FROM uac_ref_frais_scolarite WHERE code NOT IN ('UNUSEDM', 'CANCELX') ORDER BY fs_order ASC; ";

        $logger->debug("Show me allusrn_query: " . $refpay_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_ref_pay = $dbconnectioninst->query($refpay_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_ref_pay: " . count($result_ref_pay));



        $alldisplay_discount_query = " SELECT *, fCapitalizeStr(DIS_DESC) AS DIS_DESC_DISP FROM v_all_display_discount; ";
        $logger->debug("Show me alldisplay_discount_query: " . $alldisplay_discount_query);
        $result_alldisplay_discount_query = $dbconnectioninst->query($alldisplay_discount_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_alldisplay_discount_query: " . count($result_alldisplay_discount_query));
        



        $content = $twig->render('Admin/PAY/refpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_ref_pay'=>$result_ref_pay,
                                                                'result_alldisplay_discount_query'=>$result_alldisplay_discount_query,
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
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be exactly 21 or more than 99 
    if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){


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

        $allope_query = " SELECT * FROM uac_ref_frais_scolarite WHERE code NOT IN ('UNUSEDM', 'CANCELX') and type = 'M' ORDER BY fs_order ASC; ";
        $logger->debug("Show me allope_query: " . $allope_query);
        $result_allope_query = $dbconnectioninst->query($allope_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_allope_query));

        $alldisplay_discount_query = " SELECT * FROM v_all_display_discount; ";
        $logger->debug("Show me alldisplay_discount_query: " . $alldisplay_discount_query);
        $result_alldisplay_discount_query = $dbconnectioninst->query($alldisplay_discount_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_alldisplay_discount_query: " . count($result_alldisplay_discount_query));

        $allsetup_discount_query = " SELECT * FROM v_all_detail_discount; ";
        $logger->debug("Show me allsetup_discount_query: " . $allsetup_discount_query);
        $result_allsetup_discount_query = $dbconnectioninst->query($allsetup_discount_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_allsetup_discount_query: " . count($result_allsetup_discount_query));

        $param_le_limit = 0;
        $query_limit_le = " SELECT par_int AS LE_LIMIT FROM uac_param WHERE key_code = 'PAYLEXX'; ";
        $result_query_limit_le = $dbconnectioninst->query($query_limit_le)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show result_query_limit_le: " . $result_query_limit_le[0]['LE_LIMIT']);
        $param_le_limit = $result_query_limit_le[0]['LE_LIMIT'];

        

        $content = $twig->render('Admin/PAY/addpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_all_usrn'=>$result_all_usrn,
                                                                'result_all_reduc'=>$result_all_reduc,
                                                                'result_allope_query'=>$result_allope_query,
                                                                'result_alldisplay_discount_query'=>$result_alldisplay_discount_query,
                                                                'result_allsetup_discount_query'=>$result_allsetup_discount_query,
                                                                'result_get_token'=>$result_get_token,
                                                                'param_le_limit'=>$param_le_limit,
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
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_user_id = $request->request->get('foundUserId');
          $param_ticket_ref = $request->request->get('ticketRef');
          $param_ticket_type = $request->request->get('ticketType');
          $param_red_pc = $request->request->get('redPc');
          // If we in CL this is ignored in the SP
          $param_inv_fsc_id = $request->request->get('invFscId');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddFacilite( " . $param_agent_id . ", " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_ticket_type . "', " . $param_red_pc . ", " . $param_inv_fsc_id . ")";

          $logger->debug("Show me query_value: " . $query_value);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me count: " . count($result));


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'param_user_id' => $param_user_id,
              'message' => 'Tout est OK: ' . $param_ticket_ref . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket facilité DB'),
      400);
  }

  public function generateCertificatScoDB(Request $request, LoggerInterface $logger)
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
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_user_id = $request->request->get('foundUserId');
          $param_type_of_payment = $request->request->get('invTypeOfPayment');
          $param_ticket_ref = $request->request->get('ticketRef');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddCertificatSco(" . $param_agent_id . ", " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_type_of_payment . "'); ";

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

  public function generateJustDB(Request $request, LoggerInterface $logger)
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
                  'message' => 'Err122 ticket corrompu'),
              400);
          }

          // Get data from ajax
          $param_just_ref = $request->request->get('paramJustRef');
          $param_tech_hd = $request->request->get('paramTechHd');
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_category_code = $request->request->get('paramCategoryCode');
          $param_amount_just = $request->request->get('paramAmountJust');
          $param_type_of_payment = $request->request->get('paramTypeOfPayment');
          $param_comment = $request->request->get('paramComment');

          
          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddJust (" 
                            . $param_category_code .", '" . $param_just_ref . "', '" . $param_tech_hd . "', " . $param_amount_just . ", '" . $param_type_of_payment . "', " 
                            . $param_agent_id . ", '" . $param_comment . "');  ";

          $logger->debug("Show me generateJustDB query_value: " . $query_value);
          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();
          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
          $logger->debug("Show me generateJustDB count SP: " . count($result) . ' last id: ' . $result[0]['JUST_LAST_ID']);

          /*
          $query_value_last_id = " SELECT LAST_INSERT_ID() AS JUST_NEW_ID; ";
          $result_last_id = $dbconnectioninst->query($query_value_last_id)->fetchAll(PDO::FETCH_ASSOC);
          $logger->debug("Show me generateJustDB last ID: " . $result_last_id[0]['JUST_NEW_ID']);
          */
          //$logger->debug("Show me generateJustDB last ID: " .implode(', ', $result) . ' count : ' . count($result));
          //$logger->debug("Show me generateJustDB last ID: " . $result[0]['JUST_NEW_ID']);


        //$logger->debug("Show result_last_mvola: " . $result_last_mvola[0]['LAST_DATE']);


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'paramTicketRef' => $param_just_ref,
              'justLastID' => $result[0]['JUST_LAST_ID'],
              'message' => 'Tout est OK: ' . $param_just_ref . '/ '),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error generation ticket justificatif'),
      400);
  }

  public function generateOpeMultiDB(Request $request, LoggerInterface $logger)
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
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_user_id = $request->request->get('foundUserId');
          $param_type_of_payment = $request->request->get('invTypeOfPayment');
          $param_ticket_ref = $request->request->get('ticketRef');
          $param_type_of_operation = $request->request->get('typeOfOperation');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddOpeMulti(" . $param_agent_id .", " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_type_of_payment . "', '" . $param_type_of_operation . "'); ";

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
          $param_agent_id = $request->request->get('currentAgentIdStr');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CAN_PayCanPaymentPerRef(" . $param_agent_id . ", '" . $param_ticket_ref . "'); ";

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
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_user_id = $request->request->get('foundUserId');
          $param_ticket_ref = $request->request->get('ticketRef');


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_VAL_PayAddRedValidate( " . $param_agent_id . ", " . $param_user_id . ", '" . $param_ticket_ref . "')";

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
          $param_agent_id = $request->request->get('currentAgentIdStr');
          $param_user_id = $request->request->get('foundUserId');
          $param_ticket_ref = $request->request->get('ticketRef');
          $param_amount = $request->request->get('invAmountToPay');
          $param_fsc_id = $request->request->get('invFscId');
          $param_comment = $request->request->get('invComment');
          $param_short_cut_discount_id = $request->request->get('invShortCutDiscountId');
          $param_type_of_payment = $request->request->get('invTypeOfPayment');
          

          $pay_multi_ope_array = json_decode($request->request->get('payMultiOperationForUserJsonArray'), true);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          // If we are zero then there is no shortcut
          // Else we have to handle several payments
          if($param_short_cut_discount_id == 0){

                if(($param_amount == 0) && ($param_fsc_id ==  0)){
                    // In that case when amount and fsc id are 0 both then we are on total mode
                    foreach ($pay_multi_ope_array as $read)
                    {
                        $query_value = " CALL CLI_CRT_PayAddPayment( " . $param_agent_id . ", " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $read['fscId'] . "', " . $read['inputAmount'] . ", '" . $param_type_of_payment . "', '" . $param_comment . "')";
                        $logger->debug("Left Operation show me query_value: " . $query_value);
                        $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
    
                        $logger->debug("Show me count: " . count($result));
                    }
                }
                else{
                    //echo $param_jsondata[0]['username'];
                    //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
                    $query_value = " CALL CLI_CRT_PayAddPayment( " . $param_agent_id . ", " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_fsc_id . "', " . $param_amount . ", '" . $param_type_of_payment . "', '" . $param_comment . "')";
                    $logger->debug("Show me unique query_value: " . $query_value);
                    $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
    
                    $logger->debug("Show me count: " . count($result));
                }
            
          }
          else{
            //We are tarif transfert
            // TODO fill the different operation
            $logger->debug("We are in shortcut discount case");
            // In that case when amount and fsc id are 0 both then we are on total mode
            foreach ($pay_multi_ope_array as $read)
            {
                // We have to manage exemption here
                // If the payment is an exemption then we keep it as E. Else it is the payment type proposed by the agent
                $inv_type_payment_exemption = $param_type_of_payment;
                if($read['typeOfPayment'] ==  'E'){
                    $inv_type_payment_exemption = 'E';
                }
                $query_value = " CALL CLI_CRT_PayAddPayment( " . $param_agent_id . ", " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $read['fscId'] . "', " . $read['inputAmount'] . ", '" . $inv_type_payment_exemption . "', '" . $param_comment . "')";
                $logger->debug("Left Operation show me query_value: " . $query_value);
                $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

                $logger->debug("Show me count: " . count($result));
            }

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
          $param_details = $request->request->get('paramDetails');
          //echo $param_jsondata[0]['username'];
          if($param_details == 'PAY'){
            $query_getpaydetails = " SELECT vsh.FIRSTNAME AS FIRSTNAME, vsh.LASTNAME AS LASTNAME, vsh.MATRICULE AS MATRICULE, vsh.SHORTCLASS AS SHORTCLASS, vpu.* "
                      . " FROM v_histopayment_for_user vpu JOIN v_showuser vsh ON vsh.ID = vpu.VSH_USER_ID "
                      . " WHERE UP_PAYMENT_REF = '" . $param_ticket_ref . "'; ";
          }
          else{
            // == 'MULTI'
            $query_getpaydetails = " SELECT vsh.FIRSTNAME AS FIRSTNAME, vsh.LASTNAME AS LASTNAME, vsh.MATRICULE AS MATRICULE, vsh.SHORTCLASS AS SHORTCLASS, vpu.* "
                      . " FROM v_multiope_payment vpu JOIN v_showuser vsh ON vsh.ID = vpu.VSH_USER_ID "
                      . " WHERE UP_PAYMENT_REF = '" . $param_ticket_ref . "'; ";
          }
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

  public function generateattribuerMvoDB(Request $request, LoggerInterface $logger)
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
          $param_username = $request->request->get('paramFoundUsername');
          $param_mvo_id = $request->request->get('paramMvoId');
          $param_inv_case_operation = $request->request->get('paramInvCaseOperation');
          $param_agent_id = $request->request->get('currentAgentIdStr');

          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

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
          $resultQueryGetLeftOperation = $dbconnectioninst->query($query_getleftoperation)->fetchAll(PDO::FETCH_ASSOC);

          $feedbackMsg = 'OK';
          $feedbackLongMsg = '';
          if(count($resultQueryGetLeftOperation) == 0){
            // We are in a case there is nothing more to pay !
            // So we need to reject the payment and say to the user there is nothing to pay
            // There is nothing left
            $feedbackMsg = 'NL';
          }
          else{
                //echo $param_jsondata[0]['username'];
                //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
                $query_value = " CALL CLI_CRT_LineAttribuerMvola(" . $param_agent_id . ", '" . $param_username . "', " . $param_mvo_id . ", 'Y', '" . $param_inv_case_operation . "'); ";
                $logger->debug("Show me query_value: " . $query_value);
                $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);
    
                $logger->debug("Show me count: " . count($result));
                $feedbackLongMsg = 'Paiement Mvola attribue : ' . $param_username . ' : ' . $param_mvo_id;
          }


          // Send all this back to client
          return new JsonResponse(array(
              'status' => $feedbackMsg,
              'message' => $feedbackLongMsg),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error attribution Mvola DB'),
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

          $query_getfrais = " SELECT * FROM v_histo_frais_for_user vpu WHERE VSH_USERNAME = '" . $param_username . "' ORDER BY REF_FS_ORDER, UP_PAY_DATE ASC; ";
          $logger->debug("Show me query_getfrais: " . $query_getfrais);

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
          /*
          $query_getsumpertranche = " SELECT * FROM (  "
                    . " SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER FROM v_original_to_pay_for_user vop "
                    . " LEFT JOIN uac_payment up ON vop.REF_ID = up.ref_fsc_id AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L' "
                    . " WHERE vop.VSH_USERNAME = '" . $param_username . "' AND vop.TRANCHE_CODE NOT IN ( "
                    . " SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu WHERE tvpu.VSH_USERNAME = '" . $param_username . "') UNION "
                    . " SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER FROM v_left_to_pay_for_user vpu "
                    . " LEFT JOIN uac_payment up ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L' "
                    . " WHERE VSH_USERNAME ='". $param_username . "') t ORDER BY t.URF_FS_ORDER ASC;";
          */
          $query_getsumpertranche = " CALL CLI_PAY_GetSumUpTranche('" . $param_username . "'); ";
          $logger->debug("Show me query_getsumpertranche: " . $query_getsumpertranche);
 
          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result_pay = $dbconnectioninst->query($query_getpay)->fetchAll(PDO::FETCH_ASSOC);
          $result_frais = $dbconnectioninst->query($query_getfrais)->fetchAll(PDO::FETCH_ASSOC);
          
          $result = array();
          if(count($result_frais) > 0){
            $result = array_merge($result_pay, $result_frais); 
          }
          else{
            $result = $result_pay;
          }
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

  /*********************************************************************/
  /*********************************************************************/
  /*********************************************************************/
  /******************************* MVOLA *******************************/
  /*********************************************************************/
  /*********************************************************************/
  /*********************************************************************/

  public function loadmvo(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    // Must be exactly 21 or more than 99
    if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){


        $result_get_token = $this->getDailyTokenPayStr($logger);


        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        // Get All USERNAME
        $allusrn_query = " SELECT *  from v_payfoundusrn; ";

        $logger->debug("Show me allusrn_query: " . $allusrn_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_usrn = $dbconnectioninst->query($allusrn_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_usrn));



        $content = $twig->render('Admin/PAY/loadmvo.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
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

  // $this->cleanStrInsert($input_str)
  private function cleanStrInsert($input_str){
    $raw_title = ltrim($input_str,"\n");
    $raw_title = rtrim($raw_title,"\n");
    $raw_title = str_replace('"', "", $raw_title);
    $raw_title = str_replace("'", "", $raw_title);
    // print is taking only printable character
    $raw_title = preg_replace('/[[:^print:]]/', 'x', $raw_title);

    return $raw_title;
  }

  public function checkandloadmvo(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();
    // Must be exactly 8 or more than 99
    if(isset($scale_right) && (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);


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
                  $result_for_one_file = $this->extractFileInsertLinesMvo('.csv', $_FILES['fileToUpload'], $logger);

              } else {
                  // Error
                  $result_for_one_file = array("extract_report"=>'<br><span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR11282 Le fichier ' . $_FILES['fileToUpload']['name'] . ' n\'est pas lisible.</span>' . '<br>',
                                                  "extract_queries"=>"Erreur Lecture de fichier.<br>Nous attendons un .csv", "sp_result"=>null, "overpassday"=>null);
              }
              $content = $twig->render('Admin/PAY/afterloadreport.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                'firstname' => $_SESSION["firstname"],
                                                                                'lastname' => $_SESSION["lastname"],
                                                                                'id' => $_SESSION["id"],
                                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                                'result_for_one_file' => $result_for_one_file]
                                                                              );
        }

    }
    else{
        // Error Code 736
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }

    public function extractFileInsertLinesMvo($load_type, $load_file, LoggerInterface $logger){
        /**************************** START : CHECK THE FILE CONTENT HERE ****************************/

        $report_comment = '';

        $report_queries = '';
        $insert_lines = '';
        $CSV_SEPARATOR = ';';
        $HEADER_INSERT_QUERY = 'INSERT INTO uac_load_mvola (load_cra_date, transac_ref, from_phone, to_phone, mvo_type, details_a, load_amount) VALUES (';

        $insert_queries = array();
        $resultsp = array();
        $short_err = '';
        $filename_to_log_in = 'na';


        // Code is valid here. We can work
        if (($load_type == '.csv') && (!file_exists($load_file['tmp_name']))) {
        $report_comment =  '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1728 Erreur lecture fichier.</span>' . '<br>'
                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                            . 'Il semble que le fichier que vous avez chargé n\'existe pas.' . '<br>'
                                            . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>' . $report_comment;
        }
        else{
                // Properly do the importation here
                $report_comment = $report_comment . '<br>' . "<div class='report-title'>" . "<span class='icon-check-square nav-icon-fa nav-text'></span>&nbsp;Fichier .csv : ". $load_file['name'] ."<br>Traces techniques:" . "</div>";

                $report_comment = $report_comment . '<br><hr>' . 'Ligne(s) lue(s)<br/>';

                //Import uploaded file to Database
                
                /*
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
                */

                // We are in .csv mode
                $handle = fopen($load_file['tmp_name'], "r");
                $filename_to_log_in = $_FILES['fileToUpload']['name'];
                $logger->debug("START: CRA File " . $filename_to_log_in);


                $i = 0;
                $file_is_still_valid = true;
                $report_comment = $report_comment . '<div class="ace-sm report-val">';
                $header_msg = '';
                $header_account = array();;
                $header_account_phone = null;
                $header_account_name = null;
                $header_dates = array();
                $header_start_date = null;
                $header_end_date = null;
                $header_balance_before = '';
                $header_balance_after = '';

                try {


                        while ((($data = fgetcsv($handle, 1000, $CSV_SEPARATOR)) !== FALSE) && $file_is_still_valid) {
                            // read the whole file
                            // Read Fixed valuable data
                            /*
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
                            */

                            // Courses are starting at 7
                            /*
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
                            */
                            // End of read line by line



                            /*
                            $report_comment = $report_comment . '<br>Line ' . $i . ' OK: ' . $data[0] . ' | '
                                                                                        . str_replace(array("\r", "\n"), '-<', $data[1])  . ' | '
                                                                                        . str_replace(array("\r", "\n"), '-<', $data[2])  . ' | '
                                                                                        . str_replace(array("\r", "\n"), '-<', $data[3])  . ' | '
                                                                                        . str_replace(array("\r", "\n"), '-<', $data[4])  . ' | '
                                                                                        . str_replace(array("\r", "\n"), '-<', $data[5])  . ' | '
                                                                                        . str_replace(array("\r", "\n"), '-<', $data[6]);
                            */
                            // The first line is header
                            // Note that it seems the secund line is always empty

                            // (load_cra_date, transac_ref, from_phone, to_phone, mvo_type, details_a, load_amount) 
                            if ($i == 1){
                                if((count($data) == 2)){
                                    $header_account = explode("-", $this->cleanStrInsert($data[1]));
                                    
                                    $header_account_phone = ltrim(rtrim($header_account[0]," ")," ");
                                    $header_account_name = ltrim(rtrim($header_account[1]," ")," ");

                                    $logger->debug("Header account: " . $header_account_phone . " owned: " . $header_account_name);
                                }
                                else{
                                    $file_is_still_valid = false;
                                    $header_msg = ' Erreur header ligne 1/Compte ';
                                }

                            }
                            else if ($i == 2){
                                if((count($data) == 2)){
                                    $header_dates = explode("-", $this->cleanStrInsert($data[1]));
                                    $header_start_date = date_create_from_format("j/m/Y", ltrim(rtrim($header_dates[0]," ")," "));
                                    $header_end_date = date_create_from_format("j/m/Y", ltrim(rtrim($header_dates[1]," ")," "));

                                    $logger->debug("Header date string read: " . ltrim(rtrim($header_dates[0]," ")," ") . "_to_" . ltrim(rtrim($header_dates[1]," ")," "));
                                    $logger->debug("Header date: " . date_format($header_start_date, "Y-m-d") . "_to_" . date_format($header_end_date, "Y-m-d"));

                                }
                                else{
                                    $file_is_still_valid = false;
                                    $header_msg = ' Erreur header ligne 2/Dates ';
                                }

                            }
                            else if ($i == 3){
                                if((count($data) == 2)){
                                    $header_balance_before = $this->cleanStrInsert($data[1]);
                                }
                                else{
                                    $file_is_still_valid = false;
                                    $header_msg = ' Erreur header ligne 2/Dates ';
                                }

                            }
                            else if ($i == 4){
                                if((count($data) == 2)){
                                    $header_balance_after = $this->cleanStrInsert($data[1]);
                                }
                                else{
                                    $file_is_still_valid = false;
                                    $header_msg = ' Erreur header ligne 2/Dates ';
                                }

                            }
                            else if(($i > 5) && (count($data) == 7)){
                                //$logger->debug("Try to read MVOLA file: " . $data[0] . "/" . $data[1] . "/" . $data[2] . "/" . $data[3] . "/" . $data[4] . "/" . $data[5] . "/" );
                                $my_insert_query = $HEADER_INSERT_QUERY . " '" . $this->cleanStrInsert($data[0]) . "', '"
                                                        . $this->cleanStrInsert($data[1]) . "', '"
                                                        . $this->cleanStrInsert($data[2]) . "', '"
                                                        . $this->cleanStrInsert($data[3]) . "', '"
                                                        . $this->cleanStrInsert($data[4]) . "', '"
                                                        . $this->cleanStrInsert($data[5]) . "', '"
                                                        . $this->cleanStrInsert($data[6]) . "'); ";
                                array_push($insert_queries, $my_insert_query);
                            }

                            $i = $i + 1;
                        }


                        fclose($handle);

                        // Read data
                        $report_comment = $report_comment . '<br><br>'. 'Fichier: ' . $filename_to_log_in . '<br>'
                                                            . 'Nombre de lignes de votre CRA Mvola: ' . ($i - 1) . '<br>'
                                                            . $insert_lines;


                        if($file_is_still_valid){
                            // Do the DB Load operation here
                            $dbqueries_insert = '';
                            for($j = 0;$j < count($insert_queries);$j++){
                                $report_queries = $report_queries . '<br>' . '-- #' . $j . ' :<br>'  . $insert_queries[$j];
                                $dbqueries_insert = $dbqueries_insert . ' ' . $insert_queries[$j];
                                
                            }
                            //$logger->debug("Insert query dbqueries_insert: " . $dbqueries_insert);
                            // Be carefull if you have array of array
                            $dbconnectioninst = DBConnectionManager::getInstance();
                            $result = $dbconnectioninst->query($dbqueries_insert)->fetchAll(PDO::FETCH_ASSOC);
                            $logger->debug("Insert show me: " . count($result));
                            
                            // Perform the importation
                            // Change the option here !
                            //`SRV_CRT_EDT` (IN param_filename VARCHAR(300), IN param_monday_date DATE, IN param_mention VARCHAR(100), IN param_niveau CHAR(2), IN param_uaparcours VARCHAR(100), IN param_uagroupe VARCHAR(100))
                            //$import_query = "CALL SRV_CRT_EDT('" . $filename_to_log_in . "', '" . $monday . "', '" . $mention . "', '" . $niveau . "', '" . $parcours . "', '" . $groupe . "')";
                            
                            $import_query = "CALL SRV_CRT_CRAMvola(" . $_SESSION["id"] . ", '" . $header_account_phone . "', '"
                                                                        . $header_account_name . "', '"
                                                                        . date_format($header_start_date, "Y-m-d") . "', '"
                                                                        . date_format($header_end_date, "Y-m-d") . "', "
                                                                        . $header_balance_before . ", "
                                                                        . $header_balance_after . ", '"
                                                                        . $filename_to_log_in . "');";
                            $logger->debug("Here is import_query: " . $import_query);
                            $resultsp = $dbconnectioninst->query($import_query)->fetchAll(PDO::FETCH_ASSOC);
                            
                            

                            $report_queries = '<br><hr><div class="ace-sm report-val"> Nombre des input: ' . count($insert_queries) . '<br><br>' . $report_queries . '<br><br><br><br>' . $import_query . '</div>';
                            $report_comment = $report_comment . '<br><span class="icon-check-square nav-icon-fa nav-text"></span>&nbsp;Chargement en DB. Return count: ' . count($resultsp)  . '<br>';

                            // If we return the empty line means the course has not been found
                            if(count($resultsp) == 1){
                                if(strcmp($resultsp[0]['CODE_SP'], '0') == 0){
                                    $short_msg =  'Code : ' . $resultsp[0]['CODE_SP'] . '/' . $resultsp[0]['FEEDBACK_SP'];
                                    $report_comment = '<span class="ace-sm report-val"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;' . $short_msg . '.</span>' . '<br>'
                                                                    . 'Chargement du fichier : ' . $filename_to_log_in . '<br><br>'
                                                                    . $report_comment;
                                }
                                else{
                                    $short_err =  'ERR182MV Erreur fichier - Code retour: ' . $resultsp[0]['CODE_SP'] . '/' . $resultsp[0]['FEEDBACK_SP'];
                                    $report_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;' . $short_err . ' chargement du CRA impossible.</span>' . '<br>'
                                                                    . 'Désolé ! Nous avons rencontré un problème de lecture du fichier : ' . $filename_to_log_in . '<br><br>'
                                                                    . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                                    . $report_comment;
                                }
                            }
                            else{
                                //if(count($resultsp) == 0)
                                $short_err =  'ERR187MV Erreur technique';
                                $report_comment = '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR187MV Erreur Nous n\'arrivons pas à enregistrer le CRA, veuillez contacter le support technique.</span>' . '<br>'
                                                                . $short_err . ' Retour Stored Procedure : ' . count($resultsp) . '<br>'
                                                                . 'Désolé ! Nous avons rencontré un problème de lecture du fichier : ' . $filename_to_log_in . '<br><br>'
                                                                . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                                . $report_comment;
                            }
                        }
                        else{
                            // Display the error here
                            $short_err = 'Error1927 Erreur lecture fichier CRA Mvola ' . $header_msg;
                            $report_comment = '<br>' . $short_err . ' when load in DB.' . $report_comment;
                        }

                } catch (\Exception $e) {
                    $logger->debug("Exception error: " . $e->getMessage());
                    $report_comment =  '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1724MVO Erreur lecture fichier : ' . $e->getMessage() . '</span>' . '<br>'
                                                        . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                                        . 'Il semble que le fichier ne soit pas un csv.<br>'
                                                        . 'Si le problème persiste, veuillez contacter le support technique.<br><br><br>'
                                                        . $report_comment;
                }

                $report_comment = $report_comment . '</div>';
        }
        /**************************** END : CHECK THE FILE CONTENT HERE ****************************/
        $logger->debug("END: CRA File " . $filename_to_log_in);
        return array("extract_report"=>$report_comment,
                    "extract_queries"=>$report_queries,
                    "sp_result"=>$resultsp,
                    "short_err"=>$short_err);

    }


  public function managermvo(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){


        $result_get_token = $this->getDailyTokenPayStr($logger);

        $query_all_mvo = " SELECT * FROM v_mvola_manager; ";

        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        $logger->debug("query_all_edt: " . $query_all_mvo);

        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_mvo = $dbconnectioninst->query($query_all_mvo)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me query_all_mvo: " . count($result_all_mvo));

        $allusrn_query = " SELECT * FROM v_all_usr_mvola_case_inscription; ";
        $logger->debug("Show me allusrn_query: " . $allusrn_query);
        $result_all_usrn = $dbconnectioninst->query($allusrn_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_all_usrn: " . count($result_all_usrn));

        $alldisplay_discount_query = " SELECT * FROM v_all_display_discount; ";
        $logger->debug("Show me alldisplay_discount_query: " . $alldisplay_discount_query);
        $result_alldisplay_discount_query = $dbconnectioninst->query($alldisplay_discount_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_alldisplay_discount_query: " . count($result_alldisplay_discount_query));

        $allfixed_fares_query = " SELECT * FROM uac_ref_frais_scolarite urf WHERE id IN (1, 2, 3, 14) ORDER BY id ASC; ";
        $logger->debug("Show me allfixed_fares_query: " . $allfixed_fares_query);
        $result_allfixed_fares_query = $dbconnectioninst->query($allfixed_fares_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_allfixed_fares_query: " . count($result_allfixed_fares_query));

        $allsetup_discount_query = " SELECT * FROM v_all_detail_discount ORDER BY DIS_ID; ";
        $logger->debug("Show me allsetup_discount_query: " . $allsetup_discount_query);
        $result_allsetup_discount_query = $dbconnectioninst->query($allsetup_discount_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_allsetup_discount_query: " . count($result_allsetup_discount_query));

        $content = $twig->render('Admin/PAY/managermvo.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'result_get_token'=>$result_get_token,
                                                                'all_mvo' => $result_all_mvo,
                                                                'result_alldisplay_discount_query' => $result_alldisplay_discount_query,
                                                                'result_allfixed_fares_query' => $result_allfixed_fares_query,
                                                                'result_allsetup_discount_query' => $result_allsetup_discount_query,
                                                                'result_all_usrn' => $result_all_usrn,
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }

  public function managerpay(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){


        

        $query_all_pay = " SELECT * FROM v_all_pay; ";

        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        $logger->debug("query_all_pay: " . $query_all_pay);


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_pay = $dbconnectioninst->query($query_all_pay)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me count result_all_pay: " . count($result_all_pay));

        $content = $twig->render('Admin/PAY/managerpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'all_pay' => $result_all_pay,
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }

  // Manager just pay allow anyone with payment rights to see but there will be access only for write
  public function managerjust(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();
    $logger->debug("scale_right: " . $scale_right);








    if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){


        $dbconnectioninst = DBConnectionManager::getInstance();

        // In case we have a cancellation
        $confirm_cancel_id = 0;
        if(isset($_POST["confirm-cancel-id"])){
            $confirm_cancel_id = $_POST["confirm-cancel-id"];
            // We are in a cancel case
            $query_cancel_id = " UPDATE uac_just SET status = 'C', agent_id = " . $_SESSION["id"] . " , last_update = CURRENT_TIMESTAMP WHERE id = " . $confirm_cancel_id . "; ";
            $result_query_cancel_id = $dbconnectioninst->query($query_cancel_id)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("managerjust query_cancel_id: " . $query_cancel_id);
            $logger->debug("count result_query_cancel_id: " . count($result_query_cancel_id));
        }





        // J is for Justificatif de caisse
        // K is for Justificatif de coffre
        $query_all_just = " SELECT * FROM v_all_just WHERE UJ_CAT_FAMILY = 'J' ORDER BY 1 DESC; ";
        $logger->debug("query_all_just: " . $query_all_just);
        $result_all_just = $dbconnectioninst->query($query_all_just)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me count result_all_just: " . count($result_all_just));

        $query_all_category = " SELECT * FROM uac_ref_just_category; ";
        $logger->debug("query_all_category: " . $query_all_category);
        $result_query_all_category = $dbconnectioninst->query($query_all_category)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me count result_query_all_category: " . count($result_query_all_category));

        $result_get_token = $this->getDailyTokenPayStr($logger);
        $write_access = 'N';
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $write_access = 'Y';
        }


        $content = $twig->render('Admin/PAY/managerjust.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'agent_id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'result_get_token'=>$result_get_token,
                                                                'write_access' => $write_access,
                                                                'all_just' => $result_all_just,
                                                                'confirm_cancel_id' => $confirm_cancel_id,
                                                                'result_query_all_category' => $result_query_all_category,
                                                                'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }



    
  public function canceljust(Environment $twig, LoggerInterface $logger){

      if (session_status() == PHP_SESSION_NONE) {
          SessionManager::getSecureSession();
      }
      $scale_right = ConnectionManager::whatScaleRight();

      if(isset($_POST["fJustRef"])
          && isset($_POST["fId"])
          && isset($_POST["fJustDate"])
          && isset($_POST["fCategory"])
          && isset($_POST["fAmount"])
          && isset($_POST["fComment"])
          ){
          if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
              $logger->debug("cancelexam : Firstname: " . $_SESSION["firstname"]);
  
              $param_just_ref = $_POST["fJustRef"];
              $param_just_id = $_POST["fId"];
              $param_just_date = $_POST["fJustDate"];
              $param_category = $_POST["fCategory"];
              $param_amount = $_POST["fAmount"];
              $param_comment = $_POST["fComment"];
  
              $confirmation_msg = '<strong>Reference : </strong>' . $param_just_ref 
                                . '<br><strong>ID : </strong>' . $param_just_id 
                                . '<br><strong>Date de paiement : </strong>' . $param_just_date 
                                . '<br><strong>Catégorie : </strong>' . $param_category 
                                . '<br><strong>Montant : </strong>' . $param_amount 
                                . '<br><strong>Commentaire: </strong>' . $param_comment;
              
              $content = $twig->render('Admin/PAY/canceljust.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                  'firstname' => $_SESSION["firstname"],
                                                                                  'lastname' => $_SESSION["lastname"],
                                                                                  'id' => $_SESSION["id"],
                                                                                  'confirmation_msg' => $confirmation_msg,
                                                                                  'just_id' => $param_just_id,
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

  public function dashboardpay(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }

    $scale_right = ConnectionManager::whatScaleRight();

    $logger->debug("scale_right: " . $scale_right);

    if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){


        

        $logger->debug("Firstname: " . $_SESSION["firstname"]);
        $query_concat_mvola = " SELECT * FROM v_dash_concat_mvola; ";

        $logger->debug("query_all_edt: " . $query_concat_mvola);


        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_concat_mvola = $dbconnectioninst->query($query_concat_mvola)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_concat_mvola: " . count($result_concat_mvola));

        $last_mvola = " SELECT DATE_FORMAT(par_date, '%d/%m/%Y') AS LAST_DATE, par_time AS LAST_TIME FROM uac_param WHERE key_code = 'MVOLUPD'; ";
        $result_last_mvola = $dbconnectioninst->query($last_mvola)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show result_last_mvola: " . $result_last_mvola[0]['LAST_DATE']);

        $last_master_mvola = " SELECT * FROM uac_mvola_master ORDER BY id DESC LIMIT 1; ";
        $logger->debug("Show last_master_mvola: " . $last_master_mvola);
        $result_last_master_mvola = $dbconnectioninst->query($last_master_mvola)->fetchAll(PDO::FETCH_ASSOC);

        $get_solde_mvola = 0;
        if(count($result_last_master_mvola) == 1){
            $get_solde_mvola = $result_last_master_mvola[0]['core_balance_after'];
        }

        /*
        $count_tranche_one = " SELECT * FROM v_dash_sum_up_tranche_grid WHERE TRANCHE = 'Tranche 1'; ";
        $logger->debug("Show count_tranche_one: " . $count_tranche_one);
        $result_count_tranche_one = $dbconnectioninst->query($count_tranche_one)->fetchAll(PDO::FETCH_ASSOC);

        $count_tranche_two = " SELECT * FROM v_dash_sum_up_tranche_grid WHERE TRANCHE = 'Tranche 2'; ";
        $logger->debug("Show count_tranche_two: " . $count_tranche_two);
        $result_count_tranche_two = $dbconnectioninst->query($count_tranche_two)->fetchAll(PDO::FETCH_ASSOC);

        $count_tranche_three = " SELECT * FROM v_dash_sum_up_tranche_grid WHERE TRANCHE = 'Tranche 3'; ";
        $logger->debug("Show count_tranche_three: " . $count_tranche_three);
        $result_count_tranche_three = $dbconnectioninst->query($count_tranche_three)->fetchAll(PDO::FETCH_ASSOC);

        */
        

        $count_tranche_grid = " SELECT * FROM v_dash_sum_up_tranche_grid_fullv; ";
        $logger->debug("Show count_tranche_grid: " . $count_tranche_grid);
        $result_count_tranche_grid = $dbconnectioninst->query($count_tranche_grid)->fetchAll(PDO::FETCH_ASSOC);


        $today_pv = " SELECT SUM(up.input_amount) AS TOD_AMOUNT, up.type_of_payment AS TOD_TYPE_OF_PAYMENT FROM uac_payment up WHERE up.type_of_payment NOT IN ('L', 'M') "
                    . " AND up.pay_date > CURRENT_DATE GROUP BY up.type_of_payment; ";
        $logger->debug("Show today_pv: " . $today_pv);
        $result_today_pv = $dbconnectioninst->query($today_pv)->fetchAll(PDO::FETCH_ASSOC);

        $today_nbr_check_pv = " SELECT COUNT(1) AS TOD_NBR_OF_CHECK FROM uac_payment up WHERE up.type_of_payment IN ('H') "
                    . " AND up.pay_date > CURRENT_DATE GROUP BY up.type_of_payment; ";
        $logger->debug("Show today_nbr_check_pv: " . $today_nbr_check_pv);
        $result_today_nbr_check_pv = $dbconnectioninst->query($today_nbr_check_pv)->fetchAll(PDO::FETCH_ASSOC);

        $rep_year_recap = " SELECT * FROM v_rep_year_recap; ";
        $logger->debug("Show rep_year_recap: " . $rep_year_recap);
        $result_rep_year_recap = $dbconnectioninst->query($rep_year_recap)->fetchAll(PDO::FETCH_ASSOC);

        $rep_year_det_recap = " SELECT * FROM v_rep_year_det_recap; ";
        $logger->debug("Show rep_year_det_recap: " . $rep_year_det_recap);
        $result_rep_year_det_recap = $dbconnectioninst->query($rep_year_det_recap)->fetchAll(PDO::FETCH_ASSOC);



        $rep_all_red = " SELECT * FROM v_dash_all_reduction; ";
        $logger->debug("Show rep_all_red: " . $rep_all_red);
        $result_rep_all_red = $dbconnectioninst->query($rep_all_red)->fetchAll(PDO::FETCH_ASSOC);
        
        $rep_all_tranche = " SELECT * FROM v_dash_all_tranche; ";
        $logger->debug("Show rep_all_tranche: " . $rep_all_tranche);
        $result_rep_all_tranche = $dbconnectioninst->query($rep_all_tranche)->fetchAll(PDO::FETCH_ASSOC);

        $rep_rec_journee = " SELECT * FROM v_recette_journee; ";
        $logger->debug("Show rep_rec_journee: " . $rep_rec_journee);
        $result_rep_rec_journee = $dbconnectioninst->query($rep_rec_journee)->fetchAll(PDO::FETCH_ASSOC);

        $query_param_year = " SELECT par_value AS PARAM_YEAR FROM uac_param WHERE key_code = 'YEARAAA'; ";
        $logger->debug("Show me query_param_year: " . $query_param_year);

        $result_query_param_year = $dbconnectioninst->query($query_param_year)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_param_year: " . count($result_query_param_year));

        $query_nud_mvola = " SELECT IFNULL(SUM(CAST(load_amount AS UNSIGNED)), 0) AS NUD_AMOUNT FROM uac_load_mvola WHERE status = 'NUD' AND load_amount IS NOT NULL; ";
        $logger->debug("Show me query_nud_mvola: " . $query_nud_mvola);

        $result_query_nud_mvola = $dbconnectioninst->query($query_nud_mvola)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_nud_mvola: " . count($result_query_nud_mvola));

        $query_rep_month_mention = " SELECT * FROM v_rep_month_per_mention; ";
        $logger->debug("Show me query_rep_month_mention: " . $query_rep_month_mention);

        $result_query_rep_month_mention = $dbconnectioninst->query($query_rep_month_mention)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_rep_month_mention: " . count($result_query_rep_month_mention));

        $query_get_sumup_ff = " SELECT FF_COUNT, COUNT(1) AS COUNT from v_scan_for_late_user GROUP BY FF_COUNT ORDER BY FF_COUNT ASC; ";
        $logger->debug("Show me query_get_sumup_ff: " . $query_get_sumup_ff);

        $result_query_get_sumup_ff = $dbconnectioninst->query($query_get_sumup_ff)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_get_sumup_ff: " . count($result_query_get_sumup_ff));

        /************************************************************/
        /************************************************************/
        /************************************************************/
        /************************************************************/
        /************************************************************/
        /************************************************************/

        $query_all_just_day = " SELECT * FROM v_dsh_day_just; ";
        $logger->debug("Show query_all_just_day: " . $query_all_just_day);
        $result_query_all_just_day = $dbconnectioninst->query($query_all_just_day)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_all_just_day: " . count($result_query_all_just_day));

        $query_all_just_day_nbr_check = " SELECT * FROM v_dsh_just_day_nbr_check; ";
        $logger->debug("Show query_all_just_day_nbr_check: " . $query_all_just_day_nbr_check);
        $result_query_all_just_day_nbr_check = $dbconnectioninst->query($query_all_just_day_nbr_check)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_all_just_day_nbr_check: " . count($result_query_all_just_day_nbr_check));

        $query_rep_month_just = " SELECT * FROM v_rep_month_just; ";
        $logger->debug("Show me query_rep_month_just: " . $query_rep_month_just);

        $result_query_rep_month_just = $dbconnectioninst->query($query_rep_month_just)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_rep_month_just: " . count($result_query_rep_month_just));

        $query_rep_all_just = " SELECT IFNULL(SUM(input_amount), 0) AS ALL_JUST_AMT FROM uac_just; ";
        $logger->debug("Show me query_rep_all_just: " . $query_rep_all_just);

        $result_query_rep_all_just = $dbconnectioninst->query($query_rep_all_just)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me result_query_rep_all_just: " . count($result_query_rep_all_just));

        $content = $twig->render('Admin/PAY/dashboardpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'result_concat_mvola' => $result_concat_mvola,
                                                                "result_last_mvola"=>$result_last_mvola,
                                                                /*
                                                                "result_count_tranche_one"=>$result_count_tranche_one,
                                                                "result_count_tranche_two"=>$result_count_tranche_two,
                                                                "result_count_tranche_three"=>$result_count_tranche_three,
                                                                */
                                                                "result_count_tranche_grid"=>$result_count_tranche_grid,
                                                                "get_solde_mvola"=>$get_solde_mvola,
                                                                "result_today_pv"=>$result_today_pv,
                                                                "result_today_nbr_check_pv"=>$result_today_nbr_check_pv,
                                                                "result_rep_all_red"=>$result_rep_all_red,
                                                                "result_rep_year_recap"=>$result_rep_year_recap,
                                                                "result_rep_year_det_recap"=>$result_rep_year_det_recap,
                                                                "result_rep_all_tranche"=>$result_rep_all_tranche,
                                                                "result_rep_rec_journee"=>$result_rep_rec_journee,
                                                                "result_query_rep_month_mention"=>$result_query_rep_month_mention,
                                                                "result_query_get_sumup_ff"=>$result_query_get_sumup_ff,
                                                                "result_query_all_just_day"=>$result_query_all_just_day,
                                                                "result_query_rep_month_just"=>$result_query_rep_month_just,
                                                                "result_query_all_just_day_nbr_check"=>$result_query_all_just_day_nbr_check,
                                                                "result_query_rep_all_just"=>$result_query_rep_all_just[0]['ALL_JUST_AMT'],
                                                                "param_non_attr_mvola"=>$result_query_nud_mvola[0]['NUD_AMOUNT'],
                                                                'param_year' => $result_query_param_year[0]['PARAM_YEAR'],
                                                                'errtype' => '']);
                                                                

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }

}

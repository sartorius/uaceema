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
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_usrn = $dbconnectioninst->query($allusrn_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_usrn));



        $content = $twig->render('Admin/PAY/addpay.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
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


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddFacilite( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_ticket_type . "', " . $param_red_pc . ")";

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


  public function generatepayDB(Request $request, LoggerInterface $logger)
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


          //echo $param_jsondata[0]['username'];
          //INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES (
          $query_value = " CALL CLI_CRT_PayAddPayment( " . $param_user_id . ", '" . $param_ticket_ref . "', '" . $param_fsc_id . "', " . $param_amount . ", '" . $param_type_of_payment . "')";

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
          $query_getpay = " SELECT * FROM v_payment_for_user vpu JOIN uac_showuser uas ON vpu.COHORT_ID = uas.cohort_id AND uas.username = '" . $param_username . "' ORDER BY UP_USER_ID, REF_FS_ORDER ASC; ";

          $logger->debug("Show me query_getpay: " . $query_getpay);


          //Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_getpay)->fetchAll(PDO::FETCH_ASSOC);

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

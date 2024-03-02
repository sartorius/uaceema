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

class ScanController extends AbstractController
{
  public function scan(Environment $twig, LoggerInterface $logger, $rule)
  {

    if (session_status() == PHP_SESSION_NONE) {
        SessionManager::getSecureSession();
    }
    $scale_right = ConnectionManager::whatScaleRight();


    if(isset($scale_right) && ($scale_right > -1)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $twig_page = '';

        if(isset($rule) && (($rule == 'in') or ($rule == 'out'))){
            $twig_page = 'Scan/main.html.twig';
        }
        else{
          $rule = 'unk';
          $twig_page = 'Static/error314.html.twig';
        }

        $content = $twig->render($twig_page, ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                  'firstname' => $_SESSION["firstname"],
                                                  'lastname' => $_SESSION["lastname"],
                                                  'id' => $_SESSION["id"],
                                                  'rule' => $rule,
                                                  'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }


  public function loadscan(Request $request, LoggerInterface $logger, )
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

          // Get data from ajax
          $param_username = $request->request->get('loadusername');
          $param_userid = $request->request->get('loaduserid');
          $param_order = $request->request->get('loardorder');

          //$param_json = $request->request->get('loaddata');
          $param_jsondata = json_decode($request->request->get('loaddata'), true);

          /*
          if ($template_id == 0)
          {
              // You can customize error messages
              // However keep in mind that this data is visible client-side
              // You shouldn't give out clues to what went wrong to potential attackers
              return new JsonResponse(array(
                  'status' => 'Error',
                  'message' => 'Error'),
              400);
          }
          */


          //echo $param_jsondata[0]['username'];
          $query_value = 'INSERT INTO uac_load_scan (user_id, scan_username, scan_date, scan_time, status, in_out) VALUES (';
          $first_comma = '';
          foreach ($param_jsondata as $read)
          {
              $query_value = $query_value . $first_comma . $param_userid . ', LOWER(\'' . $read['username'] . '\'), \''  . $read['date'] . '\', \'' . $read['time'] . '\', \'NEW\', \'' . $param_order . '\')';
              $first_comma = ', (';
          }
          $query_value = $query_value . ';';

          sleep(2);

          // Be carefull if you have array of array
          $dbconnectioninst = DBConnectionManager::getInstance();

          $result = $dbconnectioninst->query($query_value)->fetchAll(PDO::FETCH_ASSOC);

          $logger->debug("Show me: " . count($result));


          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'message' => 'Tout est OK: ' . $param_username . ' : ' . sizeof($param_jsondata) . ' : ' . $query_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error'),
      400);
  }
}

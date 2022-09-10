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

class ScanController extends AbstractController
{
  public function scan(Environment $twig, LoggerInterface $logger)
  {

    session_start();
    $scale_right = ConnectionManager::whatScaleRight();


    if(isset($scale_right) && ($scale_right == 0)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $content = $twig->render('Scan/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                  'firstname' => $_SESSION["firstname"],
                                                  'lastname' => $_SESSION["lastname"],
                                                  'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    return new Response($content);
  }


  public function loadscan(Request $request)
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
          $read_value = '';
          foreach ($param_jsondata as $read) {
              $read_value = $read_value . ' - ' . $read['username'] . ' ' . $read['date'] . ' ' . $read['time'];
          }

          sleep(2);

          // Send all this back to client
          return new JsonResponse(array(
              'status' => 'OK',
              'message' => 'Tout va bien les cocos: ' . $param_username . ' : ' . sizeof($param_jsondata) . ' : ' . $read_value),
          200);
      }

      // If we reach this point, it means that something went wrong
      return new JsonResponse(array(
          'status' => 'Error',
          'message' => 'Error'),
      400);
  }
}

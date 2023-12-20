<?php
// src/Controller/HomeController.php

namespace App\Controller;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Twig\Environment;
use App\DBUtils\DBConnectionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class DiplomaController extends AbstractController
{

    private static $my_exact_length_page = 18;
    private static $my_exact_length_secret = 11;

    private static $my_minimum_access_right = 4;
    
  public function show(Environment $twig, LoggerInterface $logger, $page)
  {


    $logger->debug("Dip page: " . $page);

    // self::$my_exact_length_page 18
    if(strlen($page) < self::$my_exact_length_page){
      // Error Code 404
      $logger->debug("Went here (strlen(page) < " . self::$my_exact_length_page . ") ");
      $content = $twig->render('Static/error414.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    else{

      $param_secret = substr($page, 0, self::$my_exact_length_secret);
      // self::$my_exact_length_secret 11
      $param_codename = substr($page, self::$my_exact_length_secret, strlen($page) - self::$my_exact_length_secret);

      $logger->debug("Secret: " . $param_secret . " CodeName: " . $param_codename);

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $query_get_diploma = ' SELECT * FROM v_get_dip WHERE UPPER(UD_CODENAME) = \'' . $param_codename . '\' AND CONVERT(UD_SECRET, CHAR) = \'' . $param_secret . '\'';
      $logger->debug("Query query_get_diploma: " . $query_get_diploma);

      $result = $dbconnectioninst->query($query_get_diploma)->fetchAll(PDO::FETCH_ASSOC);


      $logger->debug("Show me: " . count($result));

      if(count($result) != 1){
            // We did not find the page we go out
            $content = $twig->render('Static/error414.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

      }else{
            // We found the student
            $logger->debug("We found: " . $result[0]['UD_FIRSTNAME'] . ' ' . $result[0]['UD_LASTNAME']);
            
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /******************************************************************    END GRADE    ************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/



            $content = $twig->render('Diploma/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 
                                        'scale_right' => ConnectionManager::whatScaleRight(), 
                                        'diploma' => $result[0],
                                        'moodle_url' => $_ENV['MDL_URL'], 
                                        'current_url' => $_ENV['MAIN_URL']
                                    ]);
      }
    }
    return new Response($content);
  }

  public function dematdiploma(Environment $twig, LoggerInterface $logger, $page)
  {


    $logger->debug("Demat diploma page: " . $page);

    // self::$my_exact_length_page 18
    if(strlen($page) < self::$my_exact_length_page){
      // Error Code 404 check
      $logger->debug("dematdiploma (strlen(page) < " . self::$my_exact_length_page . ") ");
      $content = $twig->render('Static/error414.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    else{

      $param_secret = substr($page, 0, self::$my_exact_length_secret);
      // self::$my_exact_length_secret 11
      $param_codename = substr($page, self::$my_exact_length_secret, strlen($page) - self::$my_exact_length_secret);

      $logger->debug("Secret: " . $param_secret . " CodeName: " . $param_codename);

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $query_get_diploma = ' SELECT * FROM v_get_dip WHERE UPPER(UD_CODENAME) = \'' . $param_codename . '\' AND CONVERT(UD_SECRET, CHAR) = \'' . $param_secret . '\'';
      $logger->debug("Query query_get_diploma: " . $query_get_diploma);

      $result = $dbconnectioninst->query($query_get_diploma)->fetchAll(PDO::FETCH_ASSOC);


      $logger->debug("Show me: " . count($result));

      if(count($result) != 1){
            // We did not find the page we go out
            $content = $twig->render('Static/error414.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

      }else{
            // We found the student
            $logger->debug("We found: " . $result[0]['UD_FIRSTNAME'] . ' ' . $result[0]['UD_LASTNAME']);
            
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /******************************************************************    END GRADE    ************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/
            /***********************************************************************************************************************************************************/



            $content = $twig->render('Diploma/dematdiploma.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 
                                        'scale_right' => ConnectionManager::whatScaleRight(), 
                                        'diploma' => $result[0],
                                        'page' => $page,
                                        'moodle_url' => $_ENV['MDL_URL'], 
                                        'current_url' => $_ENV['MAIN_URL']
                                    ]);
      }
    }
    return new Response($content);
  }


  public function managerdiploma(Environment $twig, LoggerInterface $logger)
    {

        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }

        $scale_right = ConnectionManager::whatScaleRight();

        $logger->debug("scale_right: " . $scale_right);
        // Anyone can access to the manager but only limited people can input the date
        if(isset($scale_right) && ($scale_right > self::$my_minimum_access_right)){

            $dbconnectioninst = DBConnectionManager::getInstance();
            
            $query_all_diploma = " SELECT * FROM v_get_dip; ";
            $logger->debug("query_all_diploma: " . $query_all_diploma);
            
            $result_query_all_diploma = $dbconnectioninst->query($query_all_diploma)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me result_query_all_diploma: " . count($result_query_all_diploma));
            
            $content = $twig->render('Diploma/managerdiploma.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'firstname' => $_SESSION["firstname"],
                                                                    'lastname' => $_SESSION["lastname"],
                                                                    'id' => $_SESSION["id"], 
                                                                    'current_url' => $_ENV['MAIN_URL'],
                                                                    'scale_right' => ConnectionManager::whatScaleRight(),
                                                                    'result_query_all_diploma' => $result_query_all_diploma,
                                                                    'errtype' => '']);
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }

}

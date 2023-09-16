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
  public function show(Environment $twig, LoggerInterface $logger, $page)
  {


    $logger->debug("Dip page: " . $page);

    // self::$my_exact_length_page 18
    if(strlen($page) < self::$my_exact_length_page){
      // Error Code 404
      $logger->debug("Went here (strlen(page) < " . self::$my_exact_length_page . ") ");
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
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
            $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);

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

}

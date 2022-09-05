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

class ProfileController extends AbstractController
{
  public function show(Environment $twig, LoggerInterface $logger, $page)
  {


    $logger->debug("This page: " . $page);

    if(strlen($page) < 11){
      // Error Code 404
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    else{

      $param_secret = substr($page, 0, 10);
      $param_username = substr($page, 10, strlen($page) - 10);

      $logger->debug("Secret: " . $param_secret . " ID: " . $param_username);

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $result = $dbconnectioninst->query('
      SELECT
          mu.id AS ID,
          mu.username AS USERNAME,
           uas.secret AS SECRET,
           CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
           mr.shortname AS ROLE_SHORTNAME,
           UPPER(mu.firstname) AS FIRSTNAME,
           UPPER(mu.lastname) AS LASTNAME,
           mu.email AS EMAIL,
           mu.phone1 AS PHONE,
           mu.phone2 AS PARENT_PHONE,
           mf.contextid AS PIC_CONTEXT_ID,
           mu.picture AS PICTURE_ID
        FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
                 JOIN mdl_role mr ON mr.id = uas.roleid
                 LEFT JOIN mdl_files mf ON mu.picture = mf.id
                 WHERE UPPER(mu.username) = \'' . $param_username . '\'
                 AND CONVERT(uas.secret, CHAR) = \'' . $param_secret . '\'' )->fetchAll(PDO::FETCH_ASSOC);

      $logger->debug("Show me: " . count($result));

      if(count($result) != 1){
            // We did not find the page we go out
            $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);

      }else{
            // We found the student
            $logger->debug("We found: " . $result[0]['FIRSTNAME'] . ' ' . $result[0]['LASTNAME']);

            $content = $twig->render('Profile/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'profile' => $result[0], 'moodle_url' => $_ENV['MDL_URL']]);
      }
    }








    return new Response($content);
  }
}

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
use App\DBUtils\MailManager;
use \PDO;

class ServmailController extends AbstractController
{
  public function send(Environment $twig, LoggerInterface $logger, $key)
  {


    $logger->debug("This page: " . $key);

    if(isset($key) && ($key == 'LSQKFJSQIDFILZAEOZIALZKEJRLHSK727')){
      // The key is OK

      // Be carefull if you have array of array
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $result = $dbconnectioninst->query('CALL SRV_GRP_WelcomeEMail()')->fetchAll(PDO::FETCH_ASSOC);

      $logger->debug("Show me: " . count($result));

      $list_of_mail = '';
      foreach ($result as $row => $line) {
        sleep(1);
        //MailManager::sendWelcomeEmail('ratinahirana@gmail.com', $line['FIRSTNAME'], $line['USERNAME'], $line['MATRICULE']);

        $list_of_mail = $list_of_mail .  ' ' .
              $line['USERNAME'] . ' - ' .
              $line['FIRSTNAME'] . ' - ' .
              $line['LASTNAME'] . ' - ' .
              $line['MATRICULE'] . ' - ' .
              $line['PAGE_URL'] . ' - ' .
              $line['PARENT_EMAIL'] . ' to ' .
              $line['EMAIL'] . PHP_EOL;

      }



      $content = $twig->render('Service/servmail.html.twig', ['resultService' => 'KEY is OK ' . count($result) . '/' . $list_of_mail]);
    }
    else{
      $content = $twig->render('Service/servmail.html.twig', ['resultService' => 'Unknown Service']);

    }


    return new Response($content);
  }
}

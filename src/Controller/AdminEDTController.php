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

class AdminEDTController extends AbstractController
{
  public function loadedt(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();


    if(isset($scale_right) && ($scale_right == 0)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $content = $twig->render('Scan/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                  'firstname' => $_SESSION["firstname"],
                                                  'lastname' => $_SESSION["lastname"],
                                                  'id' => $_SESSION["id"],
                                                  'scale_right' => ConnectionManager::whatScaleRight()]);


        $content = $twig->render('Admin/EDT/loader.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    return new Response($content);
  }


  public function checkandloadedt(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
        session_start();
    }

    $scale_right = ConnectionManager::whatScaleRight();
    if(isset($scale_right) && ($scale_right == 0)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $content = $twig->render('Scan/main.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                  'firstname' => $_SESSION["firstname"],
                                                  'lastname' => $_SESSION["lastname"],
                                                  'id' => $_SESSION["id"],
                                                  'scale_right' => ConnectionManager::whatScaleRight()]);



        /**************************** START : CHECK THE FILE CONTENT HERE ****************************/
        $report_comment = '';
        $insert_lines = '';
        $mention = '';
        $niveau = '';
        $monday = '';
        $tuesday = '';
        $wednesday = '';
        $thursday = '';
        $friday = '';
        $saturday = '';
        $days = array();
        $days_name = array('na', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi');
        // Code is valid here. We can work
        if ( !file_exists($_FILES['fileToUpload']['tmp_name']) ) {
          $report_comment = $report_comment . '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1728 Erreur lecture fichier.</span>' . '<br>'
                                            . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                            . 'Il semble que le fichier que vous avez chargé n\'existe pas.' . '<br>'
                                            . 'Veuillez contacter le support technique.';
        }
        else{
          // Properly do the importation here
          if (is_uploaded_file($_FILES['fileToUpload']['tmp_name'])) {
            $report_comment = $report_comment . '<br>' . "<div class='report-title'>" . "<span class='icon-check-square nav-icon-fa nav-text'></span>&nbsp;Fichier : ". $_FILES['fileToUpload']['name'] ."<br>a été pris en compte avec succés." . "</div>";

          }

          $report_comment = $report_comment . '<br><hr>' . 'Ligne(s) lue(s)<br/>';

          //Import uploaded file to Database
          $handle = fopen($_FILES['fileToUpload']['tmp_name'], "r");
          $i = 1;
          $file_is_still_valid = true;
          $report_comment = $report_comment . '<div class="ace-sm report-val">';

          try {


                  while ((($data = fgetcsv($handle, 1000, ",")) !== FALSE) && $file_is_still_valid) {
                    // read the whole file
                    // Read Fixed valuable data
                    if ( $i ==  1){
                        $mention = $data[1];
                    }
                    if ( $i ==  2){
                        $niveau = $data[1];
                    }
                    if ( $i ==  6){
                        $monday = $data[1];
                        $tuesday = $data[2];
                        $wednesday = $data[3];
                        $thursday = $data[4];
                        $friday = $data[5];
                        $saturday = $data[6];
                        // Prepare Array for work
                        array_push($days, 'na', $monday, $tuesday, $wednesday, $thursday, $friday, $saturday);
                    }

                    // Courses are starting at 7
                    if($i > 6){
                        // Now line by line $i is the hour
                        // Shift is [mention][niveau][Jour][Heure début][Cours][Durée]
                        for ($k = 1; $k <= 6; $k++) {
                            $logger->debug('i/k: ' . $i . '/' . $k);
                            switch ($data[$k]) {
                                case '':
                                    $insert_lines = $insert_lines . '<br>' . $mention . '/' . $niveau . '/' . $days_name[$k] . ':' . $days[$k] . '/' . $i . 'h/Shift vide';
                                    break;
                                default:

                                    $insert_lines = $insert_lines . '<br>' . $mention . '/' . $niveau . '/' . $days_name[$k] . ':' . $days[$k] . '/' . $i . 'h/[' . $data[$k] . ']' ;
                            }
                        }
                    }

                    $report_comment = $report_comment . '<br>Line ' . $i . ' OK: ' . $data[0] . ' | '
                                                                                   . str_replace(array("\r", "\n"), 'XXXX', $data[1])  . ' | '
                                                                                   . str_replace(array("\r", "\n"), 'XXXX', $data[2])  . ' | '
                                                                                   . str_replace(array("\r", "\n"), 'XXXX', $data[3])  . ' | '
                                                                                   . str_replace(array("\r", "\n"), 'XXXX', $data[4])  . ' | '
                                                                                   . str_replace(array("\r", "\n"), 'XXXX', $data[5])  . ' | '
                                                                                   . str_replace(array("\r", "\n"), 'XXXX', $data[6]);
                    $i = $i + 1;
                  }


                  fclose($handle);

                  // Read data
                  $report_comment = $report_comment . '<br><br>'. 'Mention: ' . $mention . '<br>'
                                                    . 'Niveau: ' . $niveau . '<br>'
                                                    . 'Lundi: ' . $monday . '<br>'
                                                    . 'Mardi: ' . $tuesday . '<br>'
                                                    . 'Mercredi: ' . $wednesday . '<br>'
                                                    . 'Jeudi: ' . $thursday . '<br>'
                                                    . 'Vendredi: ' . $friday . '<br>'
                                                    . 'Samedi: ' . $saturday . '<br><hr><br>'
                                                    . $insert_lines;




                  if($file_is_still_valid){
                    // Do the DB Load operation here
                    $report_comment = $report_comment . '<br>Load in DB.';
                  }
                  else{
                    // Display the error here
                    $report_comment = $report_comment . '<br>Error when load in DB.';
                  }

          } catch (\Exception $e) {
              $report_comment = $report_comment . '<span class="err"><span class="icon-exclamation-circle nav-icon-fa nav-text"></span>&nbsp;ERR1724 Erreur lecture fichier : ' . $e->getMessage() . '</span>' . '<br>'
                                                . 'Désolé ! Nous avons rencontré un problème de lecture du fichier. ' . '<br>'
                                                . 'Il semble que le fichier ne soit pas un csv.<br>'
                                                . 'Veuillez contacter le support technique.';
          }

          $report_comment = $report_comment . '</div>';
        }
        /**************************** END : CHECK THE FILE CONTENT HERE ****************************/

        $content = $twig->render('Admin/EDT/afterloadreport.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'reportcmt' => $report_comment]);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot()]);
    }
    return new Response($content);
  }
}

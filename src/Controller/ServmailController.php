<?php
// src/Controller/HomeController.php
namespace App\Controller;

require __DIR__ . '/../../vendor/autoload.php'; // If you're using Composer (recommended)

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


      /*

      // This is the raw operation to send the email

      $username = 'superus777';
      $password = 'tongasoaaceem';
      $cartezp = 'https://127.0.0.1:8000/cartezp/3739252247ANAESTU003';
      $dashboard = 'https://127.0.0.1:8000/profile/3739252247ANAESTU003';

      $email = new \SendGrid\Mail\Mail();
      $email->setFrom("ne-pas-repondre@uaceem.com", "Information UACEEM");
      $email->setSubject("Bienvenu à l'UACEEM !");
      $email->addTo("ratinahirana@gmail.com", "Example User");
      $email->addContent("text/plain", "Bienvenu à l'université UACEEM !\nNous sommes très heureux de vous avoir parmi nous. Votre username est " . $username . " et votre mot de passe: " . $password . "\n Connectez vous sur https://intranet.uaceem.com"
                          . " Le lien vers votre carte d'étudiant virtuelle : " . $cartezp . " \n"
                          . " Le lien vers votre dashboard étudiant : " . $dashboard . " \n"
                          . " \n Plus de détails sur https://www.uaceem.com/tutoinscription");
      $email->addContent(
          "text/html", $twig->render('ModelMail/welcome_mail.html.twig', ['username' => $username, 'password' => $password, 'cartezp' => $cartezp, 'dashboard' => $dashboard ])
      );
      $sendgrid = new \SendGrid($_ENV['MAIL_SEND_GRID_API']);
      try {
          $response = $sendgrid->send($email);
          print $response->statusCode() . "\n";
          print_r($response->headers());
          print $response->body() . "\n";
      } catch (Exception $e) {
          echo 'Caught exception: '. $e->getMessage() ."\n";
      }

      */


      // Be carefull if you have array of array
      // This to retrieve the data for email
      $dbconnectioninst = DBConnectionManager::getInstance();
      //$result = $dbconnectioninst->query('select answera from myquery;')->fetch(PDO::FETCH_ASSOC);
      $result = $dbconnectioninst->query('CALL SRV_GRP_WelcomeEMail()')->fetchAll(PDO::FETCH_ASSOC);

      $logger->debug("Show me: " . count($result));

      $list_of_mail = '';
      foreach ($result as $row => $line) {
        sleep(1);
        // We don't use Mail Manager but Sendmail
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

      
      $path = __DIR__;

      // Not called by operational
      $content = $twig->render('Service/servmail.html.twig', ['resultService' => 'KEY is OK ' . $path ]);
    }
    else{
      $content = $twig->render('Service/servmail.html.twig', ['resultService' => 'Unknown Service']);

    }


    return new Response($content);
  }
}

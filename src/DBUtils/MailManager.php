<?php
// src/Controller/MailerController.php
namespace App\DBUtils;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mailer\MailerInterface;
use Symfony\Component\Mime\Email;

use Symfony\Bridge\Twig\Mime\BodyRenderer;
use Symfony\Bridge\Twig\Mime\TemplatedEmail;
use Symfony\Component\EventDispatcher\EventDispatcher;
use Symfony\Component\Mailer\EventListener\MessageListener;
use Symfony\Component\Mailer\Mailer;
use Symfony\Component\Mailer\Transport;

use Symfony\Component\Routing\Annotation\Route;

class MailManager
{


    public static function sendSimpleEmail(){

      $transport = Transport::fromDsn($_ENV['MAILER_DSN']);
      $mailer = new Mailer($transport);

      $email = (new Email())
            ->from('ne-pas-repondre@mgsuivi.com')
            ->to('ratinahirana@gmail.com')
            //->cc('cc@example.com')
            //->bcc('bcc@example.com')
            //->replyTo('fabien@example.com')
            //->priority(Email::PRIORITY_HIGH)
            ->subject('[UACEEM] Bienvenu à l\'ACEEM Test 2')
            ->text('Bienvenu à l\'ACEEM, nous sommes heureux de vous avoir parmi nous !')
            ->html('<p>Bienvenu à l\'ACEEM, nous sommes heureux de vous avoir parmi nous !</p><br><p>Ne pas répondre à cet email. Votre réponse ne sera pas reçue.</p>');

        $mailer->send($email);
    }

    public static function sendWelcomeEmail($receiver, $firstname, $username, $matricule){

      $transport = Transport::fromDsn($_ENV['MAILER_DSN']);
      $mailer = new Mailer($transport);

      $email = (new Email())
            ->from('ne-pas-repondre@mgsuivi.com')
            ->to($receiver)
            //->cc('cc@example.com')
            //->bcc('bcc@example.com')
            //->replyTo('fabien@example.com')
            //->priority(Email::PRIORITY_HIGH)
            ->subject('[UACEEM] Bienvenu à l\'ACEEM ' . $firstname)
            ->text('Bienvenu à l\'ACEEM, nous sommes heureux de vous avoir parmi nous ! Voici votre username: ' . $username . ', votre matricule: ' . $matricule)
            ->html('<p>Bienvenu à l\'ACEEM, nous sommes heureux de vous avoir parmi nous !' .  ' Voici votre username: ' . $username . ', votre matricule: ' . $matricule . ' </p><br><p>Ne pas répondre à cet email. Votre réponse ne sera pas reçue.</p>');

        $mailer->send($email);
    }
}

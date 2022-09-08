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
            ->subject('Time for Symfony Mailer!')
            ->text('Sending emails is fun again!')
            ->html('<p>See Twig integration for better HTML integration!</p>');

        $mailer->send($email);
    }
}

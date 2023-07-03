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
use \ZipArchive;

class AdminGradeController extends AbstractController{
    private static $my_exact_access_right = 41;
    private static $my_minimum_access_right = 39;

    public function addgradetoexam(Environment $twig, LoggerInterface $logger){
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
    
        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);
            $logger->debug("****************************************************************");

            $result_get_token = $this->getDailyTokenGRAStr($logger);

            $allusr_query = " SELECT vsh.FIRSTNAME AS VSH_FIRSTNAME, vsh.LASTNAME AS VSH_LASTNAME, UPPER(vsh.USERNAME) AS VSH_USERNAME FROM v_showuser vsh where vsh.cohort_id = 26 ORDER BY VSH_FIRSTNAME ASC; ";
            $logger->debug("Show me allusr_query: " . $allusr_query);

            $dbconnectioninst = DBConnectionManager::getInstance();
            $result_all_usr = $dbconnectioninst->query($allusr_query)->fetchAll(PDO::FETCH_ASSOC);
            $logger->debug("Show me: " . count($result_all_usr));


            
            $mention_query = " SELECT * FROM uac_ref_mention; ";
            $logger->debug("Show me mention_query: " . $mention_query);
            $result_mention_query = $dbconnectioninst->query($mention_query)->fetchAll(PDO::FETCH_ASSOC);

            $allclass_query = " SELECT * FROM v_class_cohort; ";
            $logger->debug("Show me allclass_query: " . $allclass_query);
            $result_allclass_query = $dbconnectioninst->query($allclass_query)->fetchAll(PDO::FETCH_ASSOC);

            $count_stu_query = " SELECT COHORT_ID AS COHORT_ID, COUNT(1) AS CPT_STU FROM v_showuser GROUP BY COHORT_ID; ";
            $logger->debug("Show me count_stu_query: " . $count_stu_query);
            $result_count_stu_query = $dbconnectioninst->query($count_stu_query)->fetchAll(PDO::FETCH_ASSOC);

            $teacher_query = " SELECT urt.id, xm.mention_code, urt.name FROM uac_ref_teacher urt JOIN uac_xref_teacher_mention xm ON xm.teach_id = urt.id;";
            $logger->debug("Show me usedroom_query: " . $teacher_query);
            $result_teacher_query = $dbconnectioninst->query($teacher_query)->fetchAll(PDO::FETCH_ASSOC);


            $content = $twig->render('Admin/GRA/addgradetoexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'result_get_token' => $result_get_token,
                                                                'result_mention_query'=>$result_mention_query,
                                                                'result_allclass_query'=>$result_allclass_query,
                                                                'result_count_stu_query'=>$result_count_stu_query,
                                                                "result_teacher_query"=>$result_teacher_query,
                                                                'result_all_usr' => $result_all_usr,
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }


    public function exampleFunction(Environment $twig, LoggerInterface $logger){
        if (session_status() == PHP_SESSION_NONE) {
            session_start();
        }
    
        $scale_right = ConnectionManager::whatScaleRight();
        // Must be exactly 8 or more than 99
        if(isset($scale_right) &&  (($scale_right == self::$my_exact_access_right) || ($scale_right > 99))){
            $logger->debug("Firstname: " . $_SESSION["firstname"]);
            $logger->debug("****************************************************************");


            $content = $twig->render('Admin/GRA/addgradetoexam.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                'firstname' => $_SESSION["firstname"],
                                                                'lastname' => $_SESSION["lastname"],
                                                                'id' => $_SESSION["id"],
                                                                'scale_right' => ConnectionManager::whatScaleRight(),
                                                                'errtype' => '']);
        }
        else{
            // Error Code 404
            $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
        }
        return new Response($content);
    }

    private function getDailyTokenGRAStr(LoggerInterface $logger){
        // Get me the token !
        $get_token_query = "SELECT fGetDailyTokenEDT() AS TOKEN;";
        $logger->debug("Show me get_token_query: " . $get_token_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_get_token = $dbconnectioninst->query($get_token_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("result_get_token: " . $result_get_token[0]["TOKEN"]);
    
        return $result_get_token[0]["TOKEN"];
    }


}
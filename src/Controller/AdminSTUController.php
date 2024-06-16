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
use App\SessionUtils\SessionManager;
use App\DBUtils\ConnectionManager;
use Psr\Log\LoggerInterface;
use \PDO;

class AdminSTUController extends AbstractController{
  // - Teacher access
  private static $my_exact_teacher_access_right = 45;

  private static $secret_code_cross_check = 'KDUZHKU26';

  public function managerstu(Environment $twig, LoggerInterface $logger)
  {

    $logger->debug("1: session_status() " . session_status());

    if (!isset($_SESSION)) {
      $logger->debug("_SESSION NO");
    }
    else{
      $logger->debug("_SESSION YES");
    }

    if (session_status() == PHP_SESSION_NONE) {
      SessionManager::getSecureSession();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();
    $logger->debug("2: session_status() " . session_status());

    $logger->debug("Username: " . $_SESSION["username"]);
    $logger->debug("my scale rights: " . $scale_right);

    if(isset($scale_right) && ($scale_right > 4)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        //By default it is not teacher
        $is_teacher = 'N';
        $teach_clause = '';
        if(isset($scale_right) && ($scale_right == self::$my_exact_teacher_access_right)){
            $is_teacher = 'Y';
            $teach_clause = " AND vaco.mention_code IN ( SELECT utea.mention_code FROM uac_teacher utea WHERE utea.id = " . $_SESSION["id"] . ") ";
        }



        $allstu_query = " SELECT mu.id AS ID, UPPER(mu.username) AS USERNAME, mu.matricule AS MATRICULE, uas.secret AS SECRET, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, "
                              . " fCapitalizeStr(REPLACE(UPPER(mu.firstname), \"'\", \" \")) AS FIRSTNAME, REPLACE(UPPER(mu.lastname), \"'\", \" \") AS LASTNAME, mu.genre AS GENRE, mu.situation_matrimoniale AS SITM, mu.email AS EMAIL, vaco.id AS CLASS_ID, "
                              . " vaco.mention AS CLASS_MENTION, vaco.niveau AS CLASS_NIVEAU, vaco.parcours AS CLASS_PARCOURS, vaco.groupe AS CLASS_GROUPE, "
                              . " mu.phone1 AS PHONE, mu.address AS ADRESSE, mu.city AS QUARTIER, DATE_FORMAT(mu.datedenaissance, '%d/%m/%Y') AS DATEDENAISSANCE, fEscapeStr(UPPER(ifnull(mu.lieu_de_naissance, 'na'))) AS LIEUDN, DATE_FORMAT(mu.create_date, '%d/%m/%Y') AS INSCDATE, ifnull(mu.compte_fb, 'na') AS FB, fEscapeStr(mu.etablissement_origine) AS ORIGINE, "
                              . " mu.serie_bac AS SERIE_BAC, mu.annee_bac AS ANNEE_BAC, ifnull(mu.numero_cin, 'na') AS NUMCIN, ifnull(DATE_FORMAT(mu.date_cin, '%d/%m/%Y'), 'na') AS DATECIN, fEscapeStr(ifnull(mu.lieu_cin, 'na')) AS LIEU_CIN, fEscapeStr(ifnull(mu.nom_pnom_par1, 'na')) AS NOMPNOMP1, "
                              . " ifnull(mu.phone_par1, 'na') AS PHONEPAR1, fEscapeStr(ifnull(mu.profession_par1, 'na')) AS PROFPAR1, fEscapeStr(ifnull(mu.adresse_par1, 'na')) AS ADDRPAR1, fEscapeStr(ifnull(mu.city_par1, 'na')) AS CITYPAR1, fEscapeStr(ifnull(mu.nom_pnom_par2, 'na')) AS NOMPNOMP2, fEscapeStr(ifnull(mu.profession_par2, 'na')) AS PROFPAR2, "
                              . " ifnull(mu.phone_par2, 'na') AS PHONEPAR2, fEscapeStr(ifnull(mu.centres_interets, 'na')) AS CENTINT, "
                              . " REPLACE(UPPER(CONCAT(mu.username, mu.firstname, mu.lastname, vaco.mention, vaco.niveau, vaco.parcours, vaco.groupe, vaco.short_classe, mu.matricule)), \"'\", \" \") AS raw_data "
                              . " FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username "
                              . " JOIN v_class_cohort vaco ON vaco.id = uas.cohort_id WHERE 1 = 1 "
                              . $teach_clause
                              . " ORDER BY CONCAT(CLASS_NIVEAU, CLASS_MENTION) ASC; ";

        $logger->debug("Show me allstu_query: " . $allstu_query);
        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));

        $content = $twig->render('Admin/STU/managerstu.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'result_all_stu'=>$result_all_stu,
                                                                  'is_teacher'=>$is_teacher,
                                                                  'scale_right' => ConnectionManager::whatScaleRight(),
                                                                  'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }


  public function checklastscan(Environment $twig, LoggerInterface $logger)
  {

    if (session_status() == PHP_SESSION_NONE) {
      SessionManager::getSecureSession();
    }
    //'scale_right' => ConnectionManager::whatScaleRight()

    $scale_right = ConnectionManager::whatScaleRight();



    if(isset($scale_right) && ($scale_right > -1)){
        $logger->debug("Firstname: " . $_SESSION["firstname"]);

        $allstu_query = " SELECT UPPER(uls.scan_username) AS USERNAME, DATE_FORMAT(uls.scan_date, '%d/%m') AS SCAN_DATE, uls.scan_time AS SCAN_TIME, uls.status AS SCAN_STATUS, uls.in_out AS IN_OUT, "
                        . " CASE WHEN uls.status = 'END' THEN REPLACE(UPPER(mu.firstname), \"'\", \" \") WHEN uls.status = 'MIS' THEN 'Echec Lecture' ELSE 'En cours' END AS FIRSTNAME, "
                        . " CASE WHEN uls.status = 'END' THEN REPLACE(UPPER(mu.lastname), \"'\", \" \") WHEN uls.status = 'MIS' THEN 'Echec Lecture' ELSE 'En cours' END AS LASTNAME,  CASE WHEN uls.status = 'END' THEN vcc.short_classe WHEN uls.status = 'MIS' THEN 'Echec Lecture' ELSE 'En cours' END AS CLASSE"
                        . " FROM uac_load_scan uls LEFT JOIN mdl_user mu ON UPPER(mu.username) = UPPER(uls.scan_username) LEFT JOIN v_showuser vsw ON mu.id = vsw.ID LEFT JOIN v_class_cohort vcc ON vsw.COHORT_ID = vcc.id "
                        . " WHERE uls.scan_date = CURRENT_DATE  ORDER BY uls.id desc;";

        $logger->debug("Show me allstu_query: " . $allstu_query);

        $distinct_query = "SELECT count(distinct uls.scan_username) AS SCAN_UNIQUE FROM uac_load_scan uls WHERE uls.scan_date = CURRENT_DATE; ";
        $logger->debug("Show me distinct_query: " . $distinct_query);

        $miss_query = "SELECT count(uls.scan_username) AS SCAN_MISS FROM uac_load_scan uls WHERE uls.status = 'MIS' AND uls.scan_date = CURRENT_DATE; ";
        $logger->debug("Show me distinct_query: " . $miss_query);

        $dbconnectioninst = DBConnectionManager::getInstance();
        $result_all_stu = $dbconnectioninst->query($allstu_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_all_stu));


        $result_distinct = $dbconnectioninst->query($distinct_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_distinct));

        $result_miss = $dbconnectioninst->query($miss_query)->fetchAll(PDO::FETCH_ASSOC);
        $logger->debug("Show me: " . count($result_miss));

        $content = $twig->render('Admin/STU/checklastscan.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                  'firstname' => $_SESSION["firstname"],
                                                                  'lastname' => $_SESSION["lastname"],
                                                                  'id' => $_SESSION["id"],
                                                                  'result_all_stu'=>$result_all_stu,
                                                                  'result_distinct'=>$result_distinct,
                                                                  'result_miss'=>$result_miss,
                                                                  'scale_right' => ConnectionManager::whatScaleRight(),
                                                                  'errtype' => '']);

    }
    else{
        // Error Code 404
        $content = $twig->render('Static/error736.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }



  public function reapplication(Environment $twig, LoggerInterface $logger)
  {
    $dbconnectioninst = DBConnectionManager::getInstance();

    $query_param_currrent_year = " SELECT par_value AS CUR_YEAR FROM uac_param WHERE key_code = 'YEARAAA'; ";
    $logger->debug("Show me query_param_currrent_year: " . $query_param_currrent_year);
    $result_query_param_currrent_year = $dbconnectioninst->query($query_param_currrent_year)->fetchAll(PDO::FETCH_ASSOC);
    $logger->debug("Show me result_query_param_currrent_year : " . $result_query_param_currrent_year[0]['CUR_YEAR']);
    $cur_year = $result_query_param_currrent_year[0]['CUR_YEAR'];

    $query_param_prev_year = " SELECT par_value AS PREV_YEAR FROM uac_param WHERE key_code = 'PYEARAA'; ";
    $logger->debug("Show me query_param_prev_year: " . $query_param_prev_year);
    $result_query_param_prev_year = $dbconnectioninst->query($query_param_prev_year)->fetchAll(PDO::FETCH_ASSOC);
    $logger->debug("Show me result_query_param_currrent_year : " . $result_query_param_prev_year[0]['PREV_YEAR']);
    $prev_year = $result_query_param_prev_year[0]['PREV_YEAR'];

    $query_param_new_link_l = " SELECT par_value AS APPLNKL FROM uac_param WHERE key_code = 'APPLNKL'; ";
    $logger->debug("Show me query_param_new_link_l: " . $query_param_new_link_l);
    $result_query_param_new_link_l = $dbconnectioninst->query($query_param_new_link_l)->fetchAll(PDO::FETCH_ASSOC);
    $logger->debug("Show me result_query_param_new_link_l : " . $result_query_param_new_link_l[0]['APPLNKL']);
    $param_new_link_l = $result_query_param_new_link_l[0]['APPLNKL'];

    $query_param_new_link_m = " SELECT par_value AS APPLNKM FROM uac_param WHERE key_code = 'APPLNKM'; ";
    $logger->debug("Show me query_param_new_link_m: " . $query_param_new_link_m);
    $result_query_param_new_link_m = $dbconnectioninst->query($query_param_new_link_m)->fetchAll(PDO::FETCH_ASSOC);
    $logger->debug("Show me result_query_param_new_link_m : " . $result_query_param_new_link_m[0]['APPLNKM']);
    $param_new_link_m = $result_query_param_new_link_m[0]['APPLNKM'];

    $result_get_token = $this->getDailyTokenREAPPStr($logger);


    $content = $twig->render('Admin/STU/reapplication.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                    'cur_year'=>$cur_year,
                                                                    'prev_year'=>$prev_year,
                                                                    'param_new_link_l'=>$param_new_link_l,
                                                                    'param_new_link_m'=>$param_new_link_m,
                                                                    'result_get_token'=>$result_get_token,
                                                                    'scale_right' => ConnectionManager::whatScaleRight()]);

    return new Response($content);
  }



  public function verifys1reapp(Environment $twig, LoggerInterface $logger)
  {

    if(isset($_POST["fUsername"])
            && isset($_POST["fEmail"])
            // fLocaleName is the hiddent name of the token !
            && isset($_POST["fLocaleName"])
            ){
            $result_get_token = $this->getDailyTokenREAPPStr($logger);
            // We verify that token is OK
            if($result_get_token == $_POST["fLocaleName"]){

                    $param_username = $_POST["fUsername"];
                    $param_email = $_POST["fEmail"];

                    $logger->debug("Show me param_username : " . $param_username);
                    $logger->debug("Show me param_email : " . $param_email);

                    $dbconnectioninst = DBConnectionManager::getInstance();



                    $query_param_currrent_year = " SELECT par_value AS CUR_YEAR FROM uac_param WHERE key_code = 'YEARAAA'; ";
                    $logger->debug("Show me query_param_currrent_year: " . $query_param_currrent_year);
                    $result_query_param_currrent_year = $dbconnectioninst->query($query_param_currrent_year)->fetchAll(PDO::FETCH_ASSOC);
                    $logger->debug("Show me result_query_param_currrent_year : " . $result_query_param_currrent_year[0]['CUR_YEAR']);
                    $cur_year = $result_query_param_currrent_year[0]['CUR_YEAR'];

                    //Verify first if we are not trying to enroll an already enrolled user
                    $query_already_enrolled = " SELECT 1 AS DOES_EXIST "
                                        . " FROM mdl_user WHERE username =  '" . $param_username . "' OR email = '" . $param_email . "' ;";
                    $result_query_already_enrolled = $dbconnectioninst->query($query_already_enrolled)->fetchAll(PDO::FETCH_ASSOC);
                    $logger->debug("Show me count result_query_already_enrolled : " . count($result_query_already_enrolled));

                    
                    if(count($result_query_already_enrolled) > 0){
                      // Then we cannot do the reapp
                      if($param_username == "na"){
                        $param_username = "vide";
                      }
                      if($param_email == "na"){
                        $param_email = "vide";
                      }
                      $content = $twig->render('Admin/STU/alreadyenrolledreapp.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                          'cur_year'=>$cur_year,
                                                                                          'param_username'=>$param_username,
                                                                                          'param_email'=>$param_email,
                                                                                          'scale_right' => ConnectionManager::whatScaleRight()]);




                    }
                    else{
                          //We can enroll the user


                          $query_param_tech_prev_year = " SELECT par_value AS TECH_PREV_YEAR FROM uac_param WHERE key_code = 'PYEARTC'; ";
                          $logger->debug("Show me query_param_tech_prev_year: " . $query_param_tech_prev_year);
                          $result_query_param_tech_prev_year = $dbconnectioninst->query($query_param_tech_prev_year)->fetchAll(PDO::FETCH_ASSOC);
                          $logger->debug("Show me result_query_param_tech_prev_year : " . $result_query_param_tech_prev_year[0]['TECH_PREV_YEAR']);
                          $tech_prev_year = $result_query_param_tech_prev_year[0]['TECH_PREV_YEAR'];



                          $query_identify_username = " SELECT hmu.username AS USERNAME, "
                                              . " hmu.lastname AS LASTNAME, hmu.firstname AS FIRSTNAME, hmu.autre_prenom AS OTHERFIRSTNAME, hmu.email AS EMAIL, hmu.phone1 AS PHONE1, "
                                              . " hmu.matricule AS MATRICULE, hus.cohort_id AS HCOHORT_ID, VCC.short_classe AS HVCC_SHORT_CLASSE, "
                                              . " IFNULL(huui.living_configuration, 'F') AS HUUI_LVG_C "
                                              . " FROM histo_mdl_user hmu JOIN histo_uac_showuser hus "
                                                                                . " ON hmu.school_year = hus.school_year "
                                                                                . " AND hmu.username = hus.username "
                                              . " JOIN v_class_cohort VCC ON VCC.id = hus.cohort_id "
                                              . " LEFT JOIN histo_uac_user_info huui ON huui.id = hmu.id "
                                              . " WHERE hmu.school_year = " . $tech_prev_year . " AND (hmu.username =  '" . $param_username . "' OR hmu.email = '" . $param_email . "') ;";
                          $result_query_identify_username = $dbconnectioninst->query($query_identify_username)->fetchAll(PDO::FETCH_ASSOC);

                          $found_username = "na";
                          $found_lastname = "na";
                          $found_firstname = "na";
                          $found_otherfirstname = "na";
                          $found_email = "na";
                          $found_phone1 = "na";
                          $found_matricule = "na";
                          $found_cohort_id = "na";
                          $found_living_configuration = "F";
                          $found_vcc_short_classe = "na";

                          if(count($result_query_identify_username) == 1){

                            $logger->debug("Show me result_query_param_currrent_year : " . $result_query_identify_username[0]['USERNAME']);
                            $found_username = $result_query_identify_username[0]['USERNAME'];

                            $found_lastname = $result_query_identify_username[0]['LASTNAME'];
                            $found_firstname = $result_query_identify_username[0]['FIRSTNAME'];
                            $found_otherfirstname = $result_query_identify_username[0]['OTHERFIRSTNAME'];
                            $found_email = $result_query_identify_username[0]['EMAIL'];
                            $found_phone1 = $result_query_identify_username[0]['PHONE1'];
                            $found_matricule = $result_query_identify_username[0]['MATRICULE'];
                            $found_cohort_id = $result_query_identify_username[0]['HCOHORT_ID'];
                            $found_living_configuration = $result_query_identify_username[0]['HUUI_LVG_C'];
                            $found_vcc_short_classe = $result_query_identify_username[0]['HVCC_SHORT_CLASSE'];
                          }
                          //If currrent username is empty then not found !

                          if($param_username == "na"){
                            $param_username = "vide";
                          }
                          if($param_email == "na"){
                            $param_email = "vide";
                          }
                      
                          $query_param_prev_year = " SELECT par_value AS PREV_YEAR FROM uac_param WHERE key_code = 'PYEARAA'; ";
                          $logger->debug("Show me query_param_prev_year: " . $query_param_prev_year);
                          $result_query_param_prev_year = $dbconnectioninst->query($query_param_prev_year)->fetchAll(PDO::FETCH_ASSOC);
                          $logger->debug("Show me result_query_param_currrent_year : " . $result_query_param_prev_year[0]['PREV_YEAR']);
                          $prev_year = $result_query_param_prev_year[0]['PREV_YEAR'];

                          $query_param_new_link_l = " SELECT par_value AS APPLNKL FROM uac_param WHERE key_code = 'APPLNKL'; ";
                          $logger->debug("Show me query_param_new_link_l: " . $query_param_new_link_l);
                          $result_query_param_new_link_l = $dbconnectioninst->query($query_param_new_link_l)->fetchAll(PDO::FETCH_ASSOC);
                          $logger->debug("Show me result_query_param_new_link_l : " . $result_query_param_new_link_l[0]['APPLNKL']);
                          $param_new_link_l = $result_query_param_new_link_l[0]['APPLNKL'];
                      
                          $query_param_new_link_m = " SELECT par_value AS APPLNKM FROM uac_param WHERE key_code = 'APPLNKM'; ";
                          $logger->debug("Show me query_param_new_link_m: " . $query_param_new_link_m);
                          $result_query_param_new_link_m = $dbconnectioninst->query($query_param_new_link_m)->fetchAll(PDO::FETCH_ASSOC);
                          $logger->debug("Show me result_query_param_new_link_m : " . $result_query_param_new_link_m[0]['APPLNKM']);
                          $param_new_link_m = $result_query_param_new_link_m[0]['APPLNKM'];


                          $query_get_all_mention = " SELECT * FROM uac_ref_mention; ";
                          $logger->debug("Query query_get_all_mention: " . $query_get_all_mention);
                          $result_query_get_all_mention = $dbconnectioninst->query($query_get_all_mention)->fetchAll(PDO::FETCH_ASSOC);
                          $logger->debug("Show result_query_get_all_mention: " . count($result_query_get_all_mention));

                          $query_get_all_classes = " SELECT vcc.id AS VCC_ID, vcc.mention_code AS VCC_MENTION_CODE, vcc.mention AS VCC_MENTION_TITLE, vcc.short_classe AS VCC_SHORT_CLASSE FROM v_class_cohort vcc ORDER BY vcc.short_classe; ";
                          $logger->debug("Query query_get_all_classes: " . $query_get_all_classes);
                          $result_query_get_all_classes = $dbconnectioninst->query($query_get_all_classes)->fetchAll(PDO::FETCH_ASSOC);
                          $logger->debug("Show result_query_get_all_classes: " . count($result_query_get_all_classes));
                      
                          $result_get_token = md5($found_username . self::$secret_code_cross_check) . $this->getDailyTokenREAPPStr($logger);
                      
                        

                          $content = $twig->render('Admin/STU/verifys1reapp.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                          'cur_year'=>$cur_year,
                                                                                          'prev_year'=>$prev_year,
                                                                                          'result_get_token'=>$result_get_token,
                                                                                          'found_username'=>$found_username,
                                                                                          'param_username'=>$param_username,
                                                                                          'param_email'=>$param_email,

                                                                                          'found_lastname'=>$found_lastname,
                                                                                          'found_firstname'=>$found_firstname,
                                                                                          'found_otherfirstname'=>$found_otherfirstname,
                                                                                          'found_email'=>$found_email,
                                                                                          'found_phone1'=>$found_phone1,
                                                                                          'found_matricule'=>$found_matricule,
                                                                                          'found_cohort_id'=>$found_cohort_id,
                                                                                          'found_living_configuration'=>$found_living_configuration,
                                                                                          'found_vcc_short_classe'=>$found_vcc_short_classe,


                                                                                          "result_query_get_all_classes"=>$result_query_get_all_classes,
                                                                                          "result_query_get_all_mention"=>$result_query_get_all_mention,

                                                                                          'param_new_link_l'=>$param_new_link_l,
                                                                                          'param_new_link_m'=>$param_new_link_m,
                                                                                          'scale_right' => ConnectionManager::whatScaleRight()]);

                    }

            }
            else{
                $content = $twig->render('Static/error124.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
            }
    }
    else{
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }
  




  public function submitreapp(Environment $twig, LoggerInterface $logger)
  {

    if(isset($_POST["fUsername"])
            && isset($_POST["fEmail"])
            && isset($_POST["fLastname"])
            && isset($_POST["fFirstname"])
            && isset($_POST["fOthfirstname"])
            && isset($_POST["fMatricule"])
            && isset($_POST["fTelstu"])
            && isset($_POST["fLivingconfiguration"])
            && isset($_POST["fClasseid"])
            && isset($_POST["fMakeUp"])
            // fLocaleName is the hiddent name of the token !
            && isset($_POST["fLocaleName"])
            ){
            


            $param_username = htmlspecialchars($_POST["fUsername"],ENT_QUOTES);
            $result_get_token = md5($param_username . self::$secret_code_cross_check) . $this->getDailyTokenREAPPStr($logger);
            // We verify that token is OK
            if($result_get_token == $_POST["fLocaleName"]){


                    // Check first if we have an already register user. In that case, we say that already registered.

                    
                    $param_email = htmlspecialchars($_POST["fEmail"],ENT_QUOTES);

                    $logger->debug("Show me htmlspecialchars param_username : " . htmlspecialchars($param_username,ENT_QUOTES));
                    $logger->debug("Show me htmlspecialchars param_email : " . htmlspecialchars($param_email,ENT_QUOTES) );

                    $dbconnectioninst = DBConnectionManager::getInstance();

                    $query_identify_username = " SELECT 1 AS DOES_EXIST "
                                        . " FROM mdl_user WHERE username =  '" . $param_username . "' ;";
                    $result_query_identify_username = $dbconnectioninst->query($query_identify_username)->fetchAll(PDO::FETCH_ASSOC);
                    $logger->debug("Show me count result_query_identify_username : " . count($result_query_identify_username));

                    $is_already_enrolled = 'Y';
                    $result_save_reapp = 'KO';
                    if(count($result_query_identify_username) == 0){
                        // Then we can do the reapp
                        // *************************************
                        // *************************************
                        // *************************************
                        $is_already_enrolled = 'N';

                        $param_lastname = $_POST["fLastname"];
                        $param_firstname = $_POST["fFirstname"];
                        $param_othfirstname = $_POST["fOthfirstname"];
                        $param_matricule = $_POST["fMatricule"];
                        $param_telstu = $_POST["fTelstu"];
                        $param_livingconfiguration = $_POST["fLivingconfiguration"];
                        $param_classeid = $_POST["fClasseid"];
                        $param_makeup = $_POST["fMakeUp"];

                        $logger->debug("Show me param_lastname : " . $param_lastname);
                        $logger->debug("Show me param_firstname : " . $param_firstname);
                        $logger->debug("Show me param_othfirstname : " . $param_othfirstname);
                        $logger->debug("Show me param_matricule : " . $param_matricule);
                        $logger->debug("Show me param_telstu : " . $param_telstu);
                        $logger->debug("Show me param_livingconfiguration : " . $param_livingconfiguration);
                        $logger->debug("Show me param_classeid : " . $param_classeid);
                        $logger->debug("Show me param_makeup : " . $param_makeup);

                        $query_do_the_reapp = " CALL CLI_STUReInscripstion( '" . $param_email . "', '" . $param_username . "', '" . $param_lastname . "', '" 
                                                . $param_firstname . "', '" . $param_othfirstname . "', '" . $param_matricule . "', '" 
                                                . $param_telstu . "', '" . $param_livingconfiguration . "', " . $param_classeid . ", '" . $param_makeup . "' ) ;";
                        $logger->debug("Show me query_do_the_reapp: " . $query_do_the_reapp);
                        $result_query_do_the_reapp = $dbconnectioninst->query($query_do_the_reapp)->fetchAll(PDO::FETCH_ASSOC);
                        $logger->debug("Show me result_query_do_the_reapp : " . $result_query_do_the_reapp[0]['END_MSG']);
                        $result_save_reapp = $result_query_do_the_reapp[0]['END_MSG'];
                    }

                    $query_param_currrent_year = " SELECT par_value AS CUR_YEAR FROM uac_param WHERE key_code = 'YEARAAA'; ";
                    $logger->debug("Show me query_param_currrent_year: " . $query_param_currrent_year);
                    $result_query_param_currrent_year = $dbconnectioninst->query($query_param_currrent_year)->fetchAll(PDO::FETCH_ASSOC);
                    $logger->debug("Show me result_query_param_currrent_year : " . $result_query_param_currrent_year[0]['CUR_YEAR']);
                    $cur_year = $result_query_param_currrent_year[0]['CUR_YEAR'];

                    $content = $twig->render('Admin/STU/finalscreenreapp.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(),
                                                                                    'is_already_enrolled'=>$is_already_enrolled,
                                                                                    'param_username'=>$param_username,
                                                                                    'param_email'=>$param_email,
                                                                                    'cur_year'=>$cur_year,
                                                                                    'result_save_reapp'=>$result_save_reapp,
                                                                                    'scale_right' => ConnectionManager::whatScaleRight()]);

            }
            else{
              

                $logger->debug("125 : Show me fUsername : " . $_POST["fUsername"]);
                $logger->debug("125 : Show me fEmail : " . $_POST["fEmail"]);
                $logger->debug("125 : Show me fLastname : " . $_POST["fLastname"]);
                $logger->debug("125 : Show me fFirstname : " . $_POST["fFirstname"]);

                $logger->debug("125 : Show me fOthfirstname : " . $_POST["fOthfirstname"]);
                $logger->debug("125 : Show me fMatricule : " . $_POST["fMatricule"]);
                $logger->debug("125 : Show me fTelstu : " . $_POST["fTelstu"]);
                $logger->debug("125 : Show me fLivingconfiguration : " . $_POST["fLivingconfiguration"]);
                $logger->debug("125 : Show me fClasseid : " . $_POST["fClasseid"]);
                $logger->debug("125 : Show me fMakeUp : " . $_POST["fMakeUp"]);
                $logger->debug("125 : Show me fLocaleName : " . $_POST["fLocaleName"]);

                $content = $twig->render('Static/error125.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
            }
    }
    else{
      $content = $twig->render('Static/error404.html.twig', ['amiconnected' => ConnectionManager::amIConnectedOrNot(), 'scale_right' => ConnectionManager::whatScaleRight()]);
    }
    return new Response($content);
  }




  private function getDailyTokenREAPPStr(LoggerInterface $logger){
      // Get me the token !
      $get_token_query = "SELECT fGetDailyTokenGEN() AS TOKEN;";
      $logger->debug("Show me get_token_query: " . $get_token_query);
      $dbconnectioninst = DBConnectionManager::getInstance();
      $result_get_token = $dbconnectioninst->query($get_token_query)->fetchAll(PDO::FETCH_ASSOC);
      $logger->debug("result_get_token: " . $result_get_token[0]["TOKEN"]);
  
      return $result_get_token[0]["TOKEN"];
  }



}

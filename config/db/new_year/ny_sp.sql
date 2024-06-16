

DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_ReInscripstion_Prep$$
CREATE PROCEDURE `MAN_ReInscripstion_Prep` (IN prev_school_year SMALLINT)
BEGIN
    -- CALL MAN_ReInscripstion_Prep(2023);
    DECLARE exist_new	SMALLINT;

    DECLARE duplicate_username	SMALLINT;

    DECLARE duplicate_email	SMALLINT;

    DECLARE all_duplicate	SMALLINT;


    SELECT 0 INTO duplicate_username;
    SELECT 0 INTO duplicate_email;

    SELECT 0 INTO exist_new;
    SELECT 0 INTO all_duplicate;

    UPDATE reinscription_load_mdl_user SET username = LOWER(username);
    UPDATE reinscription_load_mdl_user SET firstname = TRIM(CONCAT(UPPER(SUBSTRING(firstname,1,1)),LOWER(SUBSTRING(firstname,2))));

    -- ************************************
    -- ************************************
    -- Complexity try USERNAME **
    -- ************************************
    -- ************************************
    UPDATE reinscription_load_mdl_user INNER JOIN histo_mdl_user
                                        ON reinscription_load_mdl_user.username = histo_mdl_user.username
                                        AND histo_mdl_user.school_year = prev_school_year
    -- Here is the magic !
    SET reinscription_load_mdl_user.id = histo_mdl_user.id WHERE status = 'NEW';
    UPDATE reinscription_load_mdl_user SET status = 'FND' WHERE id IS NOT NULL;

    -- ************************************
    -- ************************************
    -- Complexity try EMAIL  **
    -- ************************************
    -- ************************************
    UPDATE reinscription_load_mdl_user INNER JOIN histo_mdl_user
                                        ON reinscription_load_mdl_user.email = histo_mdl_user.email
                                        AND histo_mdl_user.school_year = prev_school_year
    -- Here is the magic !
    SET reinscription_load_mdl_user.id = histo_mdl_user.id, reinscription_load_mdl_user.username = histo_mdl_user.username WHERE status = 'NEW';

    UPDATE reinscription_load_mdl_user SET status = 'FND' WHERE id IS NOT NULL;

    -- Here if some are still NEW then we are in trouble
    SELECT COUNT(1) INTO exist_new FROM reinscription_load_mdl_user WHERE status IN ('NEW');

    -- Check duplicate if there is no error
    SELECT count(1) INTO duplicate_username FROM reinscription_load_mdl_user rmlu WHERE rmlu.username IN (SELECT mu.username FROM mdl_user mu);
    SELECT count(1) INTO duplicate_email FROM reinscription_load_mdl_user rmlu WHERE rmlu.email IN (SELECT mu.email FROM mdl_user mu);

    SELECT exist_new + duplicate_username + duplicate_email INTO all_duplicate;

    IF (all_duplicate > 0) THEN

      UPDATE reinscription_load_mdl_user SET status = 'ERU' WHERE username IN (SELECT mu.username FROM mdl_user mu);
      UPDATE reinscription_load_mdl_user SET status = 'ERE' WHERE email IN (SELECT mu.email FROM mdl_user mu);


      SELECT 'Some students are not found or duplicate - STOP' AS END_MSG;
    ELSE
      -- Set the old cohort
      UPDATE reinscription_load_mdl_user INNER JOIN histo_uac_showuser
                                          ON reinscription_load_mdl_user.username = histo_uac_showuser.username
                                          AND histo_uac_showuser.school_year = prev_school_year
      -- Here is the magic !
      SET reinscription_load_mdl_user.old_cohort_id = histo_uac_showuser.cohort_id, status = 'OCO' WHERE status = 'FND';

      -- Set the current cohort
      UPDATE reinscription_load_mdl_user INNER JOIN v_class_cohort
                                          ON reinscription_load_mdl_user.current_cohorte_short_name = v_class_cohort.short_classe
      -- Here is the magic !
      SET reinscription_load_mdl_user.current_cohort_id = v_class_cohort.id, status = 'NCO' WHERE status = 'OCO';


      -- ************************************
      -- ************************************
      -- IT IS THE GREAT COME BACK
      -- ************************************
      -- ************************************
      -- NOW WE HAVE TO DO THE COME BACK IN MDL USR !

      -- COME BACK MDL !
      INSERT INTO mdl_user
      (id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
      SELECT id, username, CURRENT_TIMESTAMP, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
      FROM histo_mdl_user hmu WHERE hmu.username IN (
          SELECT username FROM reinscription_load_mdl_user WHERE status = 'NCO'
      );

      -- Update UAC SHOW USER
      INSERT INTO uac_showuser (username, roleid, secret, cohort_id, last_update, create_date)
      SELECT username, roleid, secret, cohort_id, CURRENT_TIMESTAMP, create_date FROM histo_uac_showuser huas_main
      WHERE huas_main.username IN (
          SELECT username FROM reinscription_load_mdl_user WHERE status = 'NCO'
      );

      -- Check if we have user infos involved
      INSERT INTO uac_user_info (id, living_configuration, assiduite_info, agent_id, last_update, create_date)
      SELECT id, living_configuration, assiduite_info, agent_id, CURRENT_TIMESTAMP, create_date FROM histo_uac_user_info huui
      WHERE huui.id IN (
          SELECT id FROM reinscription_load_mdl_user WHERE status = 'NCO'
      );

      -- This link is not necessary so we insert if it does not exist
      -- We do not insert if it is En Famille
      INSERT IGNORE INTO uac_user_info (id, living_configuration, assiduite_info, agent_id, last_update, create_date)
      SELECT id, CASE WHEN str_living_configuration = 'En collocation' THEN 'C' ELSE 'A' END, NULL, 11, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM reinscription_load_mdl_user rlm WHERE rlm.status = 'NCO'
      AND NOT(str_living_configuration = 'En famille');

      -- Update email to be re-sent again to notify them
      UPDATE uac_mail user_id SET status = 'NEW'
        WHERE user_id IN (
           SELECT id FROM histo_mdl_user hmu WHERE hmu.username IN (SELECT username FROM reinscription_load_mdl_user WHERE status = 'NCO')
        )
        AND flow_code = 'MLWELCO';

      -- UPDATE COHORT
      UPDATE uac_showuser INNER JOIN reinscription_load_mdl_user
                                ON uac_showuser.username = reinscription_load_mdl_user.username
      -- Here is the magic !
      SET uac_showuser.cohort_id = reinscription_load_mdl_user.current_cohort_id WHERE status = 'NCO';

      -- insert debt
      INSERT INTO debt_mdl_user (user_id, old_cohort_id, current_cohort_id, current_school_year)
      SELECT id, old_cohort_id, current_cohort_id, prev_school_year FROM reinscription_load_mdl_user WHERE has_debt = 'O' AND status = 'NCO';



      -- BE CAREFULL DELETE !
      DELETE FROM histo_mdl_user
        WHERE username IN (
          SELECT username FROM reinscription_load_mdl_user WHERE status = 'NCO'
        )
        AND school_year = prev_school_year;

      DELETE FROM histo_uac_showuser
        WHERE username IN (
          SELECT username FROM reinscription_load_mdl_user WHERE status = 'NCO'
        )
        AND school_year = prev_school_year;

      DELETE FROM histo_uac_user_info
        WHERE id IN (
          SELECT id FROM reinscription_load_mdl_user WHERE status = 'NCO'
        )
        AND school_year = prev_school_year;

      UPDATE reinscription_load_mdl_user SET status = 'END' WHERE status = 'NCO';

      SELECT 'Ended successfully - OK' AS END_MSG;

    END IF;

END$$
-- Remove $$ for OVH



/*
$param_lastname = $_POST["fLastname"];
                      $param_firstname = $_POST["fFirstname"];
                      $param_othfirstname = $_POST["fOthfirstname"];
                      $param_matricule = $_POST["fMatricule"];
                      $param_telstu = $_POST["fTelstu"];
                      $param_livingconfiguration = $_POST["fLivingconfiguration"];
                      $param_new_cohort_id = $_POST["fClasseid"];
*/

DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_STUReInscripstion$$
CREATE PROCEDURE `CLI_STUReInscripstion` (
                                                  IN param_email VARCHAR(150),
                                                  IN param_username CHAR(10),
                                                  IN param_lastname VARCHAR(100),
                                                  IN param_firstname VARCHAR(100),
                                                  IN param_autre_prenom VARCHAR(50),
                                                  IN param_matricule VARCHAR(45),
                                                  IN param_phone1 VARCHAR(20),
                                                  IN param_livingconfiguration CHAR(1),
                                                  IN param_new_cohort_id INT,
                                                  IN param_makeup CHAR(1)
                                                )
BEGIN

      DECLARE count_duplicate_email INT;
      DECLARE inv_old_cohort_id	INT;
      DECLARE inv_username	CHAR(10);
      DECLARE inv_user_id 	BIGINT;
      DECLARE inv_tech_prev_year	SMALLINT;
      DECLARE inv_tech_cur_year	SMALLINT;


      -- Get previous year
      SELECT CAST(par_value AS UNSIGNED) INTO inv_tech_prev_year FROM uac_param WHERE key_code = 'PYEARTC';
      SELECT CAST(par_value AS UNSIGNED) INTO inv_tech_cur_year FROM uac_param WHERE key_code = 'CYEARTC';
      SET inv_username = LOWER(param_username);
      SELECT id INTO inv_user_id FROM histo_mdl_user WHERE histo_mdl_user.school_year = inv_tech_prev_year AND histo_mdl_user.username = inv_username;

      -- Check first that email is not used yet
      SELECT COUNT(1) INTO count_duplicate_email FROM mdl_user where email = param_email;

      IF (count_duplicate_email > 0) THEN
                -- Then we have duplicate
                -- Say that there is a duplicate value
                SELECT 'DUP' AS END_MSG;
      ELSE
                -- DO THE mdl_user
                -- Do the set up now
                UPDATE histo_mdl_user SET
                    email = param_email,
                    lastname = UPPER(param_lastname),
                    firstname = fCapitalizeStr(param_firstname),
                    autre_prenom = fCapitalizeStr(param_autre_prenom),
                    matricule = param_matricule,
                    phone1 = param_phone1,
                    last_update = CURRENT_TIMESTAMP
                WHERE histo_mdl_user.school_year = inv_tech_prev_year AND histo_mdl_user.username = inv_username;

                -- Then do the re-inscription now
                INSERT INTO mdl_user
                (id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
                SELECT id, username, CURRENT_TIMESTAMP, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
                FROM histo_mdl_user WHERE histo_mdl_user.school_year = inv_tech_prev_year AND histo_mdl_user.username = inv_username;


                -- Be carefull ! We use the param_new_cohort_id here
                -- Update UAC SHOW USER
                INSERT INTO uac_showuser (username, roleid, secret, cohort_id, last_update, create_date)
                SELECT username, roleid, secret, param_new_cohort_id, CURRENT_TIMESTAMP, create_date FROM histo_uac_showuser
                WHERE histo_uac_showuser.school_year = inv_tech_prev_year AND histo_uac_showuser.username = inv_username;

                -- Check if we have user infos involved
                INSERT INTO uac_user_info (id, living_configuration, assiduite_info, agent_id, last_update, create_date)
                SELECT id, param_livingconfiguration, assiduite_info, agent_id, CURRENT_TIMESTAMP, create_date FROM histo_uac_user_info
                WHERE histo_uac_user_info.school_year = inv_tech_prev_year AND histo_uac_user_info.id = inv_user_id;

                -- We save only if the student is alone
                -- We do not do if the student is in family
                IF (param_livingconfiguration IN ('C', 'A')) THEN
                      -- This link is not necessary so we insert if it does not exist
                      -- We do not insert if it is En Famille
                      INSERT IGNORE INTO uac_user_info (id, living_configuration, assiduite_info, agent_id, last_update, create_date)
                      SELECT inv_user_id, param_livingconfiguration, NULL, 11, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP;
                END IF;



                -- insert debt
                SELECT cohort_id INTO inv_old_cohort_id FROM histo_uac_showuser
                WHERE histo_uac_showuser.school_year = inv_tech_prev_year AND histo_uac_showuser.username = inv_username;

                INSERT IGNORE INTO debt_mdl_user (user_id, old_cohort_id, current_cohort_id, current_school_year)
                  SELECT inv_user_id, inv_old_cohort_id, param_new_cohort_id, inv_tech_cur_year;

                -- *************************************************************************
                -- *************************************************************************
                -- BE CAREFULL DELETE !
                -- *************************************************************************
                -- *************************************************************************
                DELETE FROM histo_mdl_user WHERE histo_mdl_user.school_year = inv_tech_prev_year AND histo_mdl_user.username = inv_username;
                DELETE FROM histo_uac_showuser WHERE histo_uac_showuser.school_year = inv_tech_prev_year AND histo_uac_showuser.username = inv_username;
                DELETE FROM histo_uac_user_info WHERE histo_uac_user_info.school_year = inv_tech_prev_year AND histo_uac_user_info.id = inv_user_id;
                DELETE FROM debt_mdl_user WHERE debt_mdl_user.current_school_year = inv_tech_prev_year AND debt_mdl_user.user_id = inv_user_id;


                -- End of all operation we notify the user
                -- Update email to be re-sent again to notify them
                UPDATE uac_mail user_id
                    SET status = 'NEW',
                        last_update = CURRENT_TIMESTAMP
                  WHERE user_id = inv_user_id
                  AND flow_code = 'MLWELCO';

                SELECT 'OK' AS END_MSG;

      END IF;
END$$
-- Remove $$ for OVH



-- MANUAL operation ONLY
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_MANHistorizeOneStudent$$
CREATE PROCEDURE `CLI_MANHistorizeOneStudent` (

                                                  IN param_username CHAR(10),
                                                  IN param_school_year SMALLINT
                                                )
BEGIN


      DECLARE inv_username	CHAR(10);
      DECLARE inv_user_id 	BIGINT;


      -- Get previous year
      SET inv_username = LOWER(param_username);
      SELECT id INTO inv_user_id FROM mdl_user WHERE username = inv_username;


      -- Part 1
      INSERT INTO histo_mdl_user
      (school_year, id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
      SELECT param_school_year, id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
      FROM mdl_user mu WHERE mu.username IN (
          inv_username
      );

      -- Part 2
      INSERT INTO histo_uac_showuser (school_year, username, roleid, secret, cohort_id, last_update, create_date)
      SELECT param_school_year, username, roleid, secret, cohort_id, last_update, create_date FROM uac_showuser uas_main WHERE uas_main.username IN (
          inv_username
      );

      -- Part 3
      INSERT INTO histo_uac_user_info (school_year, id, living_configuration, assiduite_info, agent_id, last_update, create_date)
      SELECT param_school_year, id, living_configuration, assiduite_info, agent_id, last_update, create_date FROM uac_user_info uui WHERE uui.id IN (
        inv_user_id
      );


      -- *****************************************************
      -- *****************************************************
      -- *****************************************************
      -- *****************************************************
      -- DELETE Manage paiement and grade !!!


      -- *****************************************************
      -- *****************************************************
      -- *****************************************************
      -- *****************************************************
      -- DELETE

      -- Go first because it need other tables
      DELETE FROM uac_user_info  WHERE id IN (
          inv_user_id
      );

      -- Then you go because you need uac_show user
      DELETE FROM mdl_user WHERE username IN (
          inv_username
      );

      -- Then you are last
      DELETE FROM uac_showuser  WHERE username IN (
          inv_username
      );

END$$
-- Remove $$ for OVH

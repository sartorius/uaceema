/*
TO BE RUN
-- Migrate Administration

INSERT INTO mdl_userx (id, username, firstname, lastname, email, phone1, address, city, matricule, genre, datedenaissance)
SELECT mu.id, mu.username, mu.firstname, mu.lastname, mu.email, '0344950074', 'PRVO 26B', 'Manakambahiny', 'na', 'X', '1970-01-01'
FROM mdl_user mu
WHERE mu.id IN (SELECT ua.id FROM uac_admin ua)

-- Deploy the changes
-- Load the picutes !!!
https://drive.google.com/file/d/1w3e_7l-mzQiULzzcF_-UX-aWUrqryjVe/view?usp=share_link

1w3e_7l-mzQiULzzcF_-UX-aWUrqryjVe

-- DO the migration !!!


-- ATOMIC BOMB
RENAME TABLE mdl_user TO mdl_user_old, mdl_userx TO mdl_user;

+++ Reload ALL Views !!!


*/


DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_LOAD_MDLUser$$
CREATE PROCEDURE `MAN_LOAD_MDLUser` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;

    DECLARE duplicate_username	SMALLINT;
    DECLARE duplicate_husername	SMALLINT;

    DECLARE duplicate_email	SMALLINT;
    DECLARE duplicate_hemail	SMALLINT;

    DECLARE all_duplicate	SMALLINT;
    -- CALL SRV_PRG_Scan();

    SELECT 'MANLODU' INTO flow_code;


    SELECT 0 INTO duplicate_username;
    SELECT 0 INTO duplicate_husername;
    SELECT 0 INTO duplicate_email;
    SELECT 0 INTO duplicate_hemail;

    SELECT 0 INTO all_duplicate;



    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    UPDATE mdl_load_user SET flow_id = inv_flow_id WHERE status = 'NEW';

    UPDATE mdl_load_user SET lastname = TRIM(UPPER(lastname)), last_update = NOW() WHERE flow_id = inv_flow_id;
    UPDATE mdl_load_user SET firstname = TRIM(CONCAT(UPPER(SUBSTRING(firstname,1,1)),LOWER(SUBSTRING(firstname,2)))), last_update = NOW() WHERE flow_id = inv_flow_id;

    UPDATE mdl_load_user SET phone_mvola = NULL, last_update = NOW() WHERE phone_mvola = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET autre_prenom = NULL, last_update = NOW() WHERE autre_prenom = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET compte_fb = NULL, last_update = NOW() WHERE compte_fb = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET numero_cin = NULL, last_update = NOW() WHERE numero_cin = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET lieu_cin = NULL, last_update = NOW() WHERE lieu_cin = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET nom_pnom_par1 = NULL, last_update = NOW() WHERE nom_pnom_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET email_par1 = NULL, last_update = NOW() WHERE email_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET phone_par1 = NULL, last_update = NOW() WHERE phone_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET profession_par1 = NULL, last_update = NOW() WHERE profession_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET nom_pnom_par2 = NULL, last_update = NOW() WHERE nom_pnom_par2 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET phone_par2 = NULL, last_update = NOW() WHERE phone_par2 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET profession_par2 = NULL, last_update = NOW() WHERE profession_par2 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET centres_interets = NULL, last_update = NOW() WHERE centres_interets = '' AND flow_id = inv_flow_id;

    UPDATE mdl_load_user SET core_status_matrimonial = SUBSTRING(situation_matrimoniale, 1, 1), last_update = NOW() WHERE flow_id = inv_flow_id;

    -- ************************************
    -- ************************************
    -- Complexity here is for the set up **
    -- ************************************
    -- ************************************
    UPDATE mdl_load_user INNER JOIN v_class_cohort
                                  ON mdl_load_user.cohorte_short_name = v_class_cohort.short_classe
    -- Here is the magic !
    SET mdl_load_user.core_cohort_id = v_class_cohort.id,
      mdl_load_user.last_update = NOW()
      WHERE mdl_load_user.flow_id = inv_flow_id;

    -- Check duplicate if there is no error
    SELECT count(1) INTO duplicate_username FROM mdl_load_user mlu WHERE mlu.username IN (SELECT mu.username FROM mdl_user mu);
    SELECT count(1) INTO duplicate_husername FROM mdl_load_user mlu WHERE mlu.username IN (SELECT hmu.username FROM histo_mdl_user hmu);
    SELECT count(1) INTO duplicate_email FROM mdl_load_user mlu WHERE mlu.email IN (SELECT mu.email FROM mdl_user mu);
    SELECT count(1) INTO duplicate_hemail FROM mdl_load_user mlu WHERE mlu.email IN (SELECT hmu.email FROM histo_mdl_user hmu);

    SELECT duplicate_username + duplicate_husername + duplicate_email + duplicate_hemail INTO all_duplicate;



    IF (all_duplicate > 0) THEN
        -- At this step we are NEW for each lines
        UPDATE mdl_load_user SET status = 'ERU', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW'
          AND username IN (SELECT mu.username FROM mdl_user mu);
        UPDATE mdl_load_user SET status = 'ERH', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW'
          AND username IN (SELECT hmu.username FROM histo_mdl_user hmu);

        UPDATE mdl_load_user SET status = 'ERE', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW'
          AND email IN (SELECT mu.email FROM mdl_user mu);
        UPDATE mdl_load_user SET status = 'ERM', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW'
          AND email IN (SELECT hmu.email FROM histo_mdl_user hmu);


        UPDATE uac_working_flow SET status = 'ERR', last_update = NOW(), comment = 'Error duplicate for import' WHERE id = inv_flow_id;

        SELECT 'ERROR Duplicate check mdl_load_user status not NEW';
    ELSE
        -- At this step we are NEW for each lines
        UPDATE mdl_load_user SET status = 'QUE', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW';
        -- cohort id must be in uac_showuser;
        -- We need to check first the gsheet id versus id then do the load
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Ready for import' WHERE id = inv_flow_id;
        SELECT 'End successfully';
    END IF;
END$$
-- Remove $$ for OVH


-- SELECT * FROM mig_check_id;

-- ************************************************************************
-- Do the changes if necessary ! ******************************************
-- ************************************************************************

-- ALREADY STOPPED the script SRV_UPD_UACShower

DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_CRT_MDLUser$$
CREATE PROCEDURE `MAN_CRT_MDLUser` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_PRG_Scan();

    SELECT 'MANMDLU' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    -- Loaded lines are QUEUED
    UPDATE mdl_load_user SET flow_id = inv_flow_id WHERE status = 'QUE';

    -- Do the load
    -- *********************************************************
    -- CHANGE MDL X ! ******************************************
    -- *********************************************************

    -- DO THE LOAD HERE TO WORK ON THE MDL USER

    INSERT INTO mdl_user
    (id, username, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
    SELECT
    gsheet_id, username, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, core_status_matrimonial, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
    FROM mdl_load_user WHERE status = 'QUE' AND flow_id = inv_flow_id;



    -- cohort id must be in uac_showuser;
    -- We need to check first the gsheet id versus id then do the load
    INSERT IGNORE INTO uac_showuser (roleid, username, cohort_id)
    SELECT 5, username, core_cohort_id FROM mdl_load_user WHERE status = 'QUE' AND flow_id = inv_flow_id;

    -- Add secret
    UPDATE uac_showuser SET secret = 3000000000 + FLOOR(RAND()*1000000000), last_update = NOW() WHERE secret IS NULL;


    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Done for import' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH

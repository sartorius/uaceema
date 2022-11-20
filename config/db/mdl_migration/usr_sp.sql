DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_LOAD_MDLUser$$
CREATE PROCEDURE `MAN_LOAD_MDLUser` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_PRG_Scan();

    SELECT 'MANLODU' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    UPDATE mdl_load_user SET flow_id = inv_flow_id WHERE status = 'NEW';

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
    UPDATE mdl_load_user SET cohorte_mention = NULL, last_update = NOW() WHERE cohorte_mention = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET cohorte_niveau = NULL, last_update = NOW() WHERE cohorte_niveau = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET cohorte_parcours = NULL, last_update = NOW() WHERE cohorte_parcours = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET cohorte_groupe = NULL, last_update = NOW() WHERE cohorte_groupe = '' AND flow_id = inv_flow_id;

    UPDATE mdl_load_user SET core_status_matrimonial = SUBSTRING(situation_matrimoniale, 1, 1), last_update = NOW() WHERE flow_id = inv_flow_id;

    -- ************************************
    -- ************************************
    -- Complexity here is for the set up **
    -- ************************************
    -- ************************************
    UPDATE mdl_load_user INNER JOIN v_class_cohort
                                  ON mdl_load_user.cohorte_mention = v_class_cohort.mention
                                  AND mdl_load_user.cohorte_niveau = v_class_cohort.niveau
                                  AND mdl_load_user.cohorte_parcours = v_class_cohort.parcours
                                  AND mdl_load_user.cohorte_groupe = v_class_cohort.groupe
    -- Here is the magic !
    SET mdl_load_user.core_cohort_id = v_class_cohort.id,
      mdl_load_user.last_update = NOW()
      WHERE mdl_load_user.flow_id = inv_flow_id;

    -- At this step we are NEW for each lines
    UPDATE mdl_load_user SET status = 'QUE', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW';
    -- cohort id must be in uac_showuser;
    -- We need to check first the gsheet id versus id then do the load

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Ready for import' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH

-- Do the following checks :
DROP VIEW IF EXISTS mig_check_id;
CREATE VIEW mig_check_id AS
SELECT mlu.id AS load_id, mlu.gsheet_id AS mlu_gsheet_id, mu.id AS mu_id, mu.username AS mig_username FROM mdl_load_user mlu
	JOIN mdl_user mu ON mu.username = mlu.username
		WHERE NOT(mu.id = mlu.gsheet_id);

-- SELECT * FROM mig_check_id;

-- ************************************************************************
-- Do the changes if necessary ! ******************************************
-- ************************************************************************


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

    INSERT IGNORE INTO mdl_userx
    (id, username, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
    SELECT
    gsheet_id, username, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, core_status_matrimonial, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
    FROM mdl_load_user WHERE status = 'QUE' AND flow_id = inv_flow_id;


    -- cohort id must be in uac_showuser;
    -- We need to check first the gsheet id versus id then do the load

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Done for import' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH

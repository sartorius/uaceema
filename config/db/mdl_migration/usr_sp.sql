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

    UPDATE mdl_load_user SET flow_id = inv_flow_id WHERE status = 'NEW';

    UPDATE mdl_load_user SET phone_mvola = NULL WHERE phone_mvola = '';
    UPDATE mdl_load_user SET autre_prenom = NULL WHERE autre_prenom = '';
    UPDATE mdl_load_user SET compte_fb = NULL WHERE compte_fb = '';
    UPDATE mdl_load_user SET numero_cin = NULL WHERE numero_cin = '';
    UPDATE mdl_load_user SET lieu_cin = NULL WHERE lieu_cin = '';
    UPDATE mdl_load_user SET nom_pnom_par1 = NULL WHERE nom_pnom_par1 = '';
    UPDATE mdl_load_user SET email_par1 = NULL WHERE email_par1 = '';
    UPDATE mdl_load_user SET phone_par1 = NULL WHERE phone_par1 = '';
    UPDATE mdl_load_user SET profession_par1 = NULL WHERE profession_par1 = '';
    UPDATE mdl_load_user SET nom_pnom_par2 = NULL WHERE nom_pnom_par2 = '';
    UPDATE mdl_load_user SET phone_par2 = NULL WHERE phone_par2 = '';
    UPDATE mdl_load_user SET profession_par2 = NULL WHERE profession_par2 = '';
    UPDATE mdl_load_user SET centres_interets = NULL WHERE centres_interets = '';
    UPDATE mdl_load_user SET cohorte_mention = NULL WHERE cohorte_mention = '';
    UPDATE mdl_load_user SET cohorte_niveau = NULL WHERE cohorte_niveau = '';
    UPDATE mdl_load_user SET cohorte_parcours = NULL WHERE cohorte_parcours = '';
    UPDATE mdl_load_user SET cohorte_groupe = NULL WHERE cohorte_groupe = '';

    UPDATE mdl_load_user SET core_status_matrimonial = SUBSTRING(situation_matrimoniale, 1, 1) WHERE flow_id = inv_flow_id;


    UPDATE mdl_load_user SET last_update = NOW(), status = 'END' WHERE flow_id = inv_flow_id;

    -- cohort id must be in uac_showuser;

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Ready for import' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH

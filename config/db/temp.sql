

-- This SP will pay the amount from MVOLA
-- It will take first the Frai Mvola then pay Frais fixe
-- Then pay Tranche 1, 2 and 3
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_CRAMvola$$
CREATE PROCEDURE `SRV_CRT_CRAMvola` (IN param_account_phone VARCHAR(20),
                                      IN param_account_name VARCHAR(100),
                                      IN param_start_date VARCHAR(10),
                                      IN param_end_date VARCHAR(10),
                                      IN param_balance_before INT,
                                      IN param_balance_after INT,
                                      IN param_filename VARCHAR(300))
BEGIN
    DECLARE inv_flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    DECLARE inv_master_id	BIGINT;

    DECLARE concurrent_flow INT;

    DECLARE param_last_update DATETIME;


    DECLARE nbr_new_line INT;
    DECLARE nbr_dup_line INT;
    DECLARE nbr_emp_line INT;
    DECLARE nbr_nud_line INT;
    DECLARE nbr_inv_line INT;
    -- nbr_new_line, nbr_dup_line, nbr_emp_line

    DECLARE uac_param_min_amount INT;
    DECLARE uac_param_frais_mvola INT;

    -- Loop variable
    DECLARE i SMALLINT UNSIGNED;
    DECLARE nbr_of_mvola_line SMALLINT UNSIGNED;
    DECLARE inv_working_mvola_id BIGINT;
    DECLARE in_loop_username    VARCHAR(10);

    /*
    DECLARE in_loop_user_id     BIGINT;
    DECLARE in_loop_amount      INT;
    DECLARE in_loop_paydate     DATETIME;
    DECLARE in_loop_fsc_id      INT;
    DECLARE in_loop_xref_pay_id BIGINT;



    -- run the loop now of Frais Fixe and Tranche now
    -- Loop inside the loop
    DECLARE nbr_of_unpaid_u     SMALLINT UNSIGNED;
    DECLARE i_u                 SMALLINT UNSIGNED;
    DECLARE in_loop_u_ref_id    INT UNSIGNED;
    DECLARE in_loop_u_amount    INT;

    DECLARE nbr_of_unpaid_t     SMALLINT UNSIGNED;
    DECLARE i_t                 SMALLINT UNSIGNED;
    DECLARE in_loop_t_ref_id    INT UNSIGNED;
    DECLARE in_loop_t_amount    INT;
    */


    SELECT NOW() INTO param_last_update;
    SELECT 'MVOLOAD' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
        -- A flow is running we input a CAN line
        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update, comment) VALUES (inv_flow_code, 'CAN', CURRENT_DATE, 0, NOW(), 'Concurrent flow running');

        SELECT 5 AS CODE_SP, 'ERR892MV Fichier encore en cours integration. ' AS FEEDBACK_SP;
    ELSE

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, param_filename, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;


        INSERT INTO uac_mvola_master (
          flow_id,
          status,
          cra_filename,
          core_balance_before,
          core_balance_after,
          phone_account,
          account_name,
          start_date,
          end_date)
        VALUES (
          inv_flow_id,
          'INP',
          param_filename,
          param_balance_before,
          param_balance_after,
          param_account_phone,
          param_account_name,
          param_start_date,
          param_end_date
        );
        SELECT LAST_INSERT_ID() INTO inv_master_id;

        /************************************************************************************/
        /************************************************************************************/
        /************************************************************************************/
        /** START : LOAD CONTROL ************************************************************/
        /************************************************************************************/
        /************************************************************************************/

        UPDATE uac_load_mvola SET
                master_id = inv_master_id,
                status = 'INP'
                  WHERE status = 'NEW';

        UPDATE uac_load_mvola SET
                reject_reason = 'En-tete fichier',
                status = 'INV',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND TRIM(transac_ref) = 'REFERENCE';

        UPDATE uac_load_mvola SET
                reject_reason = 'Transaction reference vide',
                status = 'EMP',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND TRIM(transac_ref) = '';

        UPDATE uac_load_mvola SET
                reject_reason = 'Montant vide',
                status = 'EMP',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND load_amount = '';

        UPDATE uac_load_mvola SET
                reject_reason = 'RPP vide',
                status = 'EMP',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND load_rrp = '';

        UPDATE uac_load_mvola SET
                reject_reason = 'Compte vide',
                status = 'EMP',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND account = '';

        -- Prepare the data
        UPDATE uac_load_mvola SET
                core_username = UPPER(TRIM(details_a)),
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id;

        -- detail b if other csv format is used
        UPDATE uac_load_mvola SET
                core_username = UPPER(TRIM(details_b)),
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND core_username = '';

        UPDATE uac_load_mvola
          INNER JOIN v_showuser ON uac_load_mvola.core_username = v_showuser.USERNAME
          SET uac_load_mvola.core_user_id = v_showuser.ID
          WHERE status = 'INP' AND master_id = inv_master_id;

        -- We do not get here another introuvable for the same reference to avoid the user to create 2 lines
        UPDATE uac_load_mvola ulmnew JOIN uac_load_mvola ulmold ON
                                          ulmnew.transac_ref = ulmold.transac_ref
                                          AND ulmnew.status = 'INP'
                                          AND ulmnew.master_id = inv_master_id
                                          AND ulmold.master_id NOT IN (inv_master_id)
                                          AND ulmold.status = 'NUD'
                SET
                ulmnew.reject_reason = 'Duplicat - utilisateur introuvable',
                ulmnew.status = 'DUP',
                ulmnew.update_date = NOW()
                  WHERE ulmnew.status = 'INP' AND ulmnew.master_id = inv_master_id;

        UPDATE uac_load_mvola SET
                reject_reason = 'Username user id introuvable',
                status = 'NUD',
                update_date = NOW()
                  WHERE status = 'INP'
                  AND master_id = inv_master_id
                  -- We handle here the Credit only
                  AND CAST(load_amount AS SIGNED) > 0
                  AND core_user_id IS NULL;


        -- Control the CRA data
        UPDATE uac_load_mvola SET
                core_amount = CAST(load_amount AS SIGNED),
                core_cra_datetime = STR_TO_DATE(load_cra_date,'%d/%m/%Y %H:%i:%s'),
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id;

        UPDATE uac_load_mvola SET
                reject_reason = 'Credit Debit invalide',
                status = 'INV',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND core_amount = 0;

        UPDATE uac_load_mvola SET
                reject_reason = 'Date transaction invalide',
                status = 'INV',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id AND core_cra_datetime IS NULL;

        UPDATE uac_load_mvola SET
                reject_reason = 'Duplicat - référence déjà intégrée',
                status = 'DUP',
                update_date = NOW()
                  WHERE status = 'INP' AND master_id = inv_master_id
                  AND transac_ref IN (
                    SELECT transac_ref FROM uac_mvola_line
                  );

        /************************************************************************************/
        /************************************************************************************/
        /************************************************************************************/
        /** END : LOAD CONTROL **************************************************************/
        /************************************************************************************/
        /************************************************************************************/
        -- We need to handle debit and frais
        -- Unique Credit here
        INSERT IGNORE INTO uac_mvola_line (
          id,
          status,
          master_id,
          transac_ref,
          mvo_type,
          from_phone,
          to_phone,
          core_cra_datetime,
          core_amount,
          user_id,
          order_direction,
          nbr_of_load_line,
          comment
          )
        SELECT
        	 MAX(id),
           'END',
        	 inv_master_id,
        	 transac_ref,
        	 GROUP_CONCAT(mvo_type SEPARATOR '+'),
        	 from_phone,
        	 MIN(to_phone),
        	 MAX(core_cra_datetime),
        	 SUM(core_amount),
        	 0,
        	 CASE WHEN SUM(core_amount) > 0 THEN 'C' ELSE 'D' END,
        	 COUNT(1),
           'Debit vers autre numéro incluant frais de transfer'
        	 FROM uac_load_mvola
        WHERE status = 'INP' AND master_id = inv_master_id
        GROUP BY transac_ref, from_phone
        HAVING COUNT(1) > 1;

        -- All Debit lines here are closed
        UPDATE uac_load_mvola
          SET status = 'END',
              update_date = NOW()
          WHERE master_id = inv_master_id
          AND status = 'INP'
          AND transac_ref IN (
              SELECT transac_ref
              	 FROM uac_mvola_line
              WHERE master_id = inv_master_id
          );

        -- Unique Credit here
        INSERT INTO uac_mvola_line (
          id,
          master_id,
          transac_ref,
          x_payment_id,
          mvo_initiator,
          mvo_type,
          canal,
          cra_statut,
          account,
          from_phone,
          to_phone,
          details_a,
          details_b,
          validator,
          notif_ref,
          core_cra_datetime,
          core_amount,
          core_rrp,
          core_balance_before,
          core_balance_after,
          user_id,
          order_direction
          )
        SELECT
          id,
          inv_master_id,
          transac_ref,
          NULL,
          mvo_initiator,
          mvo_type,
          canal,
          cra_statut,
          account,
          from_phone,
          to_phone,
          details_a,
          details_b,
          validator,
          notif_ref,
          core_cra_datetime,
          core_amount,
          core_rrp,
          core_balance_before,
          core_balance_after,
          CASE WHEN core_amount > 0 THEN core_user_id ELSE 0 END,
          CASE WHEN core_amount > 0 THEN 'C' ELSE 'D' END
        FROM uac_load_mvola WHERE status = 'INP' AND master_id = inv_master_id;

        SELECT amount INTO uac_param_frais_mvola FROM uac_ref_frais_scolarite WHERE code = 'FRMVOLA';
        SELECT par_int INTO uac_param_min_amount FROM uac_param WHERE key_code = 'MINAMOU';

        -- STILL Need to be created in mvola line because we need to show it to the student
        UPDATE uac_mvola_line
            SET status = 'INV',
            comment = 'Frais Mvola - montant insuffisant'
            WHERE master_id = inv_master_id
            AND order_direction = 'C'
            AND core_amount < (uac_param_frais_mvola + uac_param_min_amount);

        -- Update the load lines because it will be the lines retrieved by the report
        UPDATE uac_load_mvola
            SET status = 'INV',
            reject_reason = 'Frais Mvola - montant insuffisant'
            WHERE id IN (SELECT id FROM uac_mvola_line
                          WHERE master_id = inv_master_id
                          AND status = 'INV'
                          AND order_direction = 'C'
                          AND core_amount < (uac_param_frais_mvola + uac_param_min_amount));


        SELECT COUNT(1) INTO nbr_of_mvola_line
          FROM uac_mvola_line uml WHERE uml.master_id = inv_master_id AND uml.order_direction = 'C';
        -- Perform the loop here
        SET i = 0;
        WHILE i < nbr_of_mvola_line DO
          -- START Do the operation
          SELECT MAX(uml.id) INTO inv_working_mvola_id
            FROM uac_mvola_line uml WHERE uml.master_id = inv_master_id AND uml.order_direction = 'C' AND uml.status = 'NEW';


          SELECT uml.user_id INTO in_loop_user_id FROM uac_mvola_line uml WHERE uml.id = inv_working_mvola_id;

          SELECT USERNAME INTO in_loop_username FROM v_showuser WHERE ID = in_loop_user_id;

          -- We call here the main operation !
          -- Line by line we will loop
          CALL CLI_CRT_LineAttribuerMvola(in_loop_username, inv_working_mvola_id);
          SET i = i + 1;
        END WHILE;

        UPDATE uac_mvola_line uml
          SET uml.status = 'END',
              uml.comment = 'Debit raison inconnue'
          WHERE uml.master_id = inv_master_id
                AND status = 'NEW'
                AND core_amount < 0;

        /************************************************************************************/
        /************************************************************************************/
        /************************************************************************************/
        /** END : PAYMENT *******************************************************************/
        /************************************************************************************/
        /************************************************************************************/



        -- END the flow
        SELECT IFNULL(MAX(core_cra_datetime), CURRENT_TIMESTAMP) INTO param_last_update
            FROM uac_load_mvola WHERE master_id = inv_master_id AND core_cra_datetime IS NOT NULL;

        UPDATE uac_param SET
                par_date = CAST(param_last_update AS DATE),
                par_time = CAST(param_last_update AS TIME),
                last_update = NOW()
        WHERE  key_code = 'MVOLUPD';

        -- All lines here are closed
        UPDATE uac_load_mvola SET status = 'END', update_date = NOW() WHERE master_id = inv_master_id AND status = 'INP';

        -- nbr_new_line, nbr_dup_line, nbr_emp_line, nbr_inv_line
        SELECT COUNT(1) INTO nbr_new_line FROM uac_load_mvola WHERE master_id = inv_master_id AND status = 'END';
        SELECT COUNT(1) INTO nbr_dup_line FROM uac_load_mvola WHERE master_id = inv_master_id AND status = 'DUP';
        SELECT COUNT(1) INTO nbr_emp_line FROM uac_load_mvola WHERE master_id = inv_master_id AND status = 'EMP';
        SELECT COUNT(1) INTO nbr_nud_line FROM uac_load_mvola WHERE master_id = inv_master_id AND status = 'NUD';
        SELECT COUNT(1) INTO nbr_inv_line FROM uac_load_mvola WHERE master_id = inv_master_id AND status = 'INV';



        -- update master
        UPDATE
            uac_mvola_master
            SET status = 'END',
            update_date = NOW(),
            new_count = nbr_new_line,
            duplicate_count = nbr_dup_line,
            empty_count = nbr_emp_line,
            not_found_count = nbr_nud_line,
            invalid_count = nbr_inv_line
            WHERE id = inv_master_id AND status = 'INP';


        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

        SELECT 0 AS CODE_SP, CONCAT('Integration effectue avec succes. Nouvelles lignes : ', nbr_new_line, '/Invalides: ',  nbr_inv_line, '/User ID introuvables: ', nbr_nud_line, ' /Duplicats : ', nbr_dup_line, ' /Vides : ', nbr_emp_line) AS FEEDBACK_SP;
    END IF;

END$$
-- End of SRV_CRT_CRAMvola
-- Remove $$ for OVH

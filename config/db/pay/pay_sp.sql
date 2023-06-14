-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_CRT_PayAddFacilite$$
CREATE PROCEDURE `CLI_CRT_PayAddFacilite` (IN param_user_id BIGINT, IN param_ticket_ref CHAR(10), IN param_ticket_type CHAR(1), IN param_red_pc TINYINT, IN param_fsc_id INT)
BEGIN
    DECLARE inv_status	CHAR(1);
    DECLARE inv_fac_id	BIGINT;

    -- END OF DECLARE
    SET inv_status = 'A';

    -- Set the correct status value
    -- If we are on e Reduction
    IF param_ticket_type = 'R' THEN
        SET inv_status = 'I';
    END IF;

    INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES ( param_user_id, param_ticket_ref, param_ticket_type, param_red_pc, inv_status);
    SELECT LAST_INSERT_ID() INTO inv_fac_id;

    -- We need to create the line for Commitment Letter
    IF param_ticket_type = 'L' THEN
        -- Set the correct status value
        INSERT INTO uac_payment (user_id, ref_fsc_id, status, payment_ref, input_amount, type_of_payment, pay_date, facilite_id)
            VALUES (param_user_id, param_fsc_id, 'P', param_ticket_ref, 0, param_ticket_type, CURRENT_TIMESTAMP, inv_fac_id);
    END IF;

END$$
-- Remove $$ for OVH

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_CRT_PayAddPayment$$
CREATE PROCEDURE `CLI_CRT_PayAddPayment` (IN param_user_id BIGINT, IN param_ticket_ref CHAR(10), IN param_fsc_id INT, IN param_input_amount INT, IN param_type_payment CHAR(1))
BEGIN
    DECLARE inv_status	CHAR(1);
    -- END OF DECLARE

    SELECT 'P' INTO inv_status;

    -- Set the correct status value
    INSERT INTO uac_payment (user_id, ref_fsc_id, status, payment_ref, input_amount, type_of_payment, pay_date)
    VALUES (param_user_id, param_fsc_id, inv_status, param_ticket_ref, param_input_amount, param_type_payment, CURRENT_TIMESTAMP);

END$$
-- Remove $$ for OVH

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_CRT_PayAddCertificatSco$$
CREATE PROCEDURE `CLI_CRT_PayAddCertificatSco` (IN param_user_id BIGINT, IN param_ticket_ref CHAR(10), IN param_type_payment CHAR(1))
BEGIN
    DECLARE inv_fsc_id	INT;
    DECLARE inv_amount	INT;
    -- END OF DECLARE

    SELECT ref.id, ref.amount INTO inv_fsc_id, inv_amount
    FROM v_showuser vsh JOIN uac_xref_cohort_fsc xref ON xref.cohort_id = vsh.COHORT_ID
                          JOIN uac_ref_frais_scolarite ref ON ref.id = xref.fsc_id
                                                           AND ref.code = 'CERTSCO'
                                                           WHERE vsh.ID = param_user_id;

    -- Set the correct status value
    INSERT INTO uac_payment (user_id, ref_fsc_id, status, payment_ref, input_amount, type_of_payment, pay_date)
        VALUES (param_user_id, inv_fsc_id, 'P', param_ticket_ref, inv_amount, param_type_payment, CURRENT_TIMESTAMP);

END$$
-- Remove $$ for OVH


-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_VAL_PayAddRedValidate$$
CREATE PROCEDURE `CLI_VAL_PayAddRedValidate` (IN param_user_id BIGINT, IN param_ticket_ref CHAR(10))
BEGIN
    DECLARE param_red_pc	TINYINT;
    DECLARE param_id_red	BIGINT;
    DECLARE param_cohort_id	INT;

    -- Amount management
    DECLARE param_total_amount_to_reduce	 INT;
    DECLARE inc_leftover_amount_to_reduce	 INT;
    DECLARE actual_full_reduction       	 INT;
    DECLARE i_part_amount             	   INT;
    DECLARE split_amount_to_reduce    	   INT;
    DECLARE inc_i_already_paid        	   INT;

    DECLARE inv_fsc_id                	   INT;
    DECLARE param_modulo                	 INT;
    DECLARE nbr_of_part                    TINYINT;
    DECLARE i                              TINYINT default 0;
    DECLARE found_red_id                   TINYINT;
    -- END OF DECLARE


    SELECT COUNT(1) INTO found_red_id
        FROM uac_facilite_payment
        WHERE ticket_ref = param_ticket_ref AND user_id = param_user_id AND status = 'I';

    IF found_red_id = 1 THEN
      -- WE ARE OK

          -- BEGIN OF THE OPERATION
          SELECT red_pc, id INTO param_red_pc, param_id_red
              FROM uac_facilite_payment
              WHERE ticket_ref = param_ticket_ref AND user_id = param_user_id AND status = 'I';
          SELECT COHORT_ID INTO param_cohort_id FROM v_showuser WHERE ID = param_user_id;

          SELECT TRUNCATE(SUM(urf.amount) * param_red_pc * 0.01, 0) INTO param_total_amount_to_reduce FROM uac_ref_frais_scolarite urf
      			JOIN uac_xref_cohort_fsc xref ON xref.fsc_id = urf.id
      												AND urf.type = 'T'
      			WHERE xref.cohort_id = param_cohort_id;
          -- Get number of part
          SELECT COUNT(1) INTO nbr_of_part FROM uac_ref_frais_scolarite urf
      			JOIN uac_xref_cohort_fsc xref ON xref.fsc_id = urf.id
      												AND urf.type = 'T'
      			WHERE xref.cohort_id = param_cohort_id;



          SET inc_leftover_amount_to_reduce = 0;
          SET split_amount_to_reduce = 0;
          SET actual_full_reduction = 0;

          SET param_modulo = 500;

          -- split_amount_to_reduce
          SELECT TRUNCATE(param_total_amount_to_reduce/nbr_of_part, 0) INTO split_amount_to_reduce;
          -- ROUND with the MODULO
          SET split_amount_to_reduce = split_amount_to_reduce + (param_modulo - MOD(split_amount_to_reduce, param_modulo));
          -- ********************************************
          -- ********************************************
          -- ****************** START *******************
          -- ********************************************
          -- ********************************************
          SET inv_fsc_id = 0;
          SET i = 0;
          WHILE i < nbr_of_part DO
            -- START Do the operation
            SELECT MIN(urf.id) INTO inv_fsc_id FROM uac_ref_frais_scolarite urf
        			JOIN uac_xref_cohort_fsc xref ON xref.fsc_id = urf.id
        												AND urf.type = 'T'
        			WHERE xref.cohort_id = param_cohort_id
              -- This allow us to specifically increment
              AND urf.id > inv_fsc_id;

              -- i_part_amount
              SELECT urf.amount INTO i_part_amount FROM uac_ref_frais_scolarite urf
          			JOIN uac_xref_cohort_fsc xref ON xref.fsc_id = urf.id
          												AND urf.type = 'T'
          			WHERE xref.cohort_id = param_cohort_id AND urf.id = inv_fsc_id;

              -- inc_i_already_paid
              SELECT IFNULL(SUM(up.input_amount), 0) INTO inc_i_already_paid
                  FROM uac_payment up WHERE up.user_id = param_user_id AND up.ref_fsc_id = inv_fsc_id;

              -- NOW we need to fill the part ready for Tx
              -- Of course if the student has already paid then it will be lost money for the student

              IF i_part_amount >= (split_amount_to_reduce + inc_i_already_paid + inc_leftover_amount_to_reduce) THEN
                  -- Set the correct status value
                  INSERT INTO uac_payment (user_id, ref_fsc_id, status, payment_ref, input_amount, type_of_payment, pay_date, facilite_id)
                    VALUES (param_user_id, inv_fsc_id, 'P', param_ticket_ref, (split_amount_to_reduce + inc_leftover_amount_to_reduce), 'R', CURRENT_TIMESTAMP, param_id_red);
                  -- As it has been used we remove the leftover
                  SET inc_leftover_amount_to_reduce = 0;
                  SET actual_full_reduction = actual_full_reduction + (split_amount_to_reduce + inc_leftover_amount_to_reduce);
              ELSE
                  -- INSERT the MAXIMUM and keep the rest
                  INSERT INTO uac_payment (user_id, ref_fsc_id, status, payment_ref, input_amount, type_of_payment, pay_date, facilite_id)
                    VALUES (param_user_id, inv_fsc_id, 'P', param_ticket_ref, (i_part_amount - inc_i_already_paid), 'R', CURRENT_TIMESTAMP, param_id_red);
                  -- We keep the left over here
                  SET inc_leftover_amount_to_reduce = (split_amount_to_reduce - (i_part_amount - inc_i_already_paid) + inc_leftover_amount_to_reduce);
                  SET actual_full_reduction = actual_full_reduction + (i_part_amount - inc_i_already_paid);
              END IF;



            -- END Do the operation
            SET i = i + 1;
          END WHILE;

          -- END of the operation
          UPDATE uac_facilite_payment SET status = 'A'
            WHERE ticket_ref = param_ticket_ref AND user_id = param_user_id AND status = 'I';
    ELSE
      -- WE DID NOT FOUND THE REDUCTION OR MORE
      SET actual_full_reduction = -1;
    END IF;

    SELECT actual_full_reduction AS ACTUAL_FULL_REDUCTION;
END$$
-- Remove $$ for OVH
-- CLI_VAL_PayAddRedValidate

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_CAN_PayCanPaymentPerRef$$
CREATE PROCEDURE `CLI_CAN_PayCanPaymentPerRef` (IN param_ticket_ref CHAR(10))
BEGIN

    UPDATE uac_payment up SET
      up.status = 'C',
      up.ref_fsc_id = 0,
      up.comment = CONCAT('Annulation: ', CONVERT(up.input_amount, CHAR), 'AR'),
      up.input_amount =  0,
      up.last_update = CURRENT_TIMESTAMP
      WHERE payment_ref = param_ticket_ref
      -- We do not cancel Reduction or Letter of Commitment
      AND type_of_payment NOT IN ('R', 'L');

END$$
-- Remove $$ for OVH



-- Use this SP to get the sum up of tranche
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_PAY_GetSumUpTranche$$
CREATE PROCEDURE `CLI_PAY_GetSumUpTranche` (IN param_username CHAR(10))
BEGIN
    -- Sum Up Tranche
    SELECT * FROM (
      SELECT
        vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
        FROM v_original_to_pay_for_user vop
        LEFT JOIN uac_payment up ON vop.REF_ID = up.ref_fsc_id
                                AND up.user_id = vop.VSH_ID
                                AND up.type_of_payment = 'L'
        WHERE vop.VSH_USERNAME = param_username
        AND vop.TRANCHE_CODE NOT IN (
            SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
            WHERE tvpu.VSH_USERNAME = param_username)
            UNION  SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
            FROM v_left_to_pay_for_user vpu  LEFT JOIN uac_payment up ON vpu.REF_ID = up.ref_fsc_id
                                                                      AND up.user_id = vpu.VSH_ID
                                                                      AND up.type_of_payment = 'L'
            WHERE VSH_USERNAME = param_username
    ) t ORDER BY t.URF_FS_ORDER ASC;

END$$



-- ***********************************************************************************
-- ***********************************************************************************
-- ***********************************************************************************
-- MVOLA
-- ***********************************************************************************
-- ***********************************************************************************
-- ***********************************************************************************


-- MVOLA
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MINAMOU', 'Minimum amount to pay', 100, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MVOLOAD', 'Integration Mvola', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MVOLUPD', 'Last update Mvola', NULL, NULL);
-- INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('TELMVOL', 'Mvola phone number', NULL, '346776199');
-- PROD
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MVOLTEL', 'Mvola phone number', NULL, '344960000');



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

    DECLARE in_loop_username    VARCHAR(10);
    DECLARE nbr_of_unpaid_t     SMALLINT UNSIGNED;
    DECLARE i_t                 SMALLINT UNSIGNED;
    DECLARE in_loop_t_ref_id    INT UNSIGNED;
    DECLARE in_loop_t_amount    INT;



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
          -- Update the line on which we are working on
          UPDATE uac_mvola_line uml
            SET uml.status = 'INP'
            WHERE uml.id = inv_working_mvola_id AND status = 'NEW';

            -- DECLARE in_loop_user_id     BIGINT;
            -- DECLARE in_loop_amount      INT;
            -- DECLARE in_loop_paydate     DATETIME;
            SELECT
              uml.user_id,
              uml.core_amount,
              uml.core_cra_datetime
                INTO
                in_loop_user_id,
                in_loop_amount,
                in_loop_paydate
              FROM uac_mvola_line uml WHERE uml.id = inv_working_mvola_id;

            -- Pay the frais Mvola
            SET in_loop_amount =  in_loop_amount - uac_param_frais_mvola;
            SELECT id INTO in_loop_fsc_id FROM uac_ref_frais_scolarite WHERE code = 'FRMVOLA';

            -- Insert here the frais
            INSERT INTO uac_payment (
              user_id,
              ref_fsc_id,
              status,
              payment_ref,
              input_amount,
              type_of_payment,
              pay_date,
              comment
            )
            VALUES (
              in_loop_user_id,
              in_loop_fsc_id,
              'P',
              CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(inv_working_mvola_id, 5, '0'), 'P'),
              uac_param_frais_mvola,
              'M',
              in_loop_paydate,
              'Frais transaction Mvola'
            );
            SELECT LAST_INSERT_ID() INTO in_loop_xref_pay_id;
            -- Update the xref
            INSERT INTO uac_xref_payment_mvola (payment_id, mvola_id) VALUES (in_loop_xref_pay_id, inv_working_mvola_id);

            -- run the loop now of Frais Fixe and Tranche now
            -- Loop inside the loop
            -- nbr_of_unpaid_u
            -- i_u
            -- in_loop_u_ref_id
            -- in_loop_u_amount

            SELECT COUNT(1) INTO nbr_of_unpaid_u FROM v_histopayment_for_user vpu
              WHERE vpu.VSH_USER_ID = in_loop_user_id
              AND vpu.REF_TYPE = 'U'
              AND vpu.UP_ID IS NULL;

            -- ****************************************
            -- Perform the loop here for payment U here
            -- ****************************************
            SET i_u = 0;
                        WHILE (i_u < nbr_of_unpaid_u)
                              AND (in_loop_amount > 0)
                              DO

                              -- Retrieve the ref id first
                              SELECT MIN(REF_ID) INTO in_loop_u_ref_id
                              FROM v_histopayment_for_user vpu
                                WHERE vpu.VSH_USER_ID = in_loop_user_id
                                AND vpu.REF_TYPE = 'U'
                                AND vpu.UP_ID IS NULL;

                              -- Retrieve the amount  first
                              SELECT REF_AMOUNT INTO in_loop_u_amount
                              FROM v_histopayment_for_user vpu
                                WHERE vpu.VSH_USER_ID = in_loop_user_id
                                AND vpu.REF_TYPE = 'U'
                                AND vpu.UP_ID IS NULL
                                AND vpu.REF_ID = in_loop_u_ref_id;

                              IF (in_loop_amount > in_loop_u_amount) THEN
                                  -- Then create the payment
                                  INSERT INTO uac_payment (
                                    user_id,
                                    ref_fsc_id,
                                    status,
                                    payment_ref,
                                    input_amount,
                                    type_of_payment,
                                    pay_date,
                                    comment
                                  )
                                  VALUES (
                                    in_loop_user_id,
                                    in_loop_u_ref_id,
                                    'P',
                                    CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(inv_working_mvola_id, 5, '0'), 'P'),
                                    in_loop_u_amount,
                                    'M',
                                    in_loop_paydate,
                                    'Paiement frais fixe avec Mvola'
                                  );
                                  SELECT LAST_INSERT_ID() INTO in_loop_xref_pay_id;
                                  -- Update the xref
                                  INSERT INTO uac_xref_payment_mvola (payment_id, mvola_id) VALUES (in_loop_xref_pay_id, inv_working_mvola_id);
                                  SET in_loop_amount = in_loop_amount - in_loop_u_amount;

                              -- ELSE
                                -- We keep the amount for future in Tranche
                                -- Do nothing
                                -- SELECT 1;
                              END IF;


                          SET i_u = i_u + 1;
                        END WHILE;



            -- in_loop_username
            -- nbr_of_unpaid_t
            -- i_t
            -- in_loop_t_ref_id
            -- in_loop_t_amount

            -- ****************************************
            -- Perform the loop here for payment T here
            -- ****************************************
            SELECT USERNAME INTO in_loop_username FROM v_showuser WHERE ID = in_loop_user_id;
            SELECT COUNT(1) INTO nbr_of_unpaid_t FROM (
              SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                FROM v_original_to_pay_for_user vop
                  LEFT JOIN uac_payment up
                    ON vop.REF_ID = up.ref_fsc_id
                    AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L'
                    WHERE vop.VSH_USERNAME = in_loop_username
                    AND vop.TRANCHE_CODE NOT IN (
                      SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
                      WHERE tvpu.VSH_USERNAME = in_loop_username)
                      UNION
                      SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                      FROM v_left_to_pay_for_user vpu
                      LEFT JOIN uac_payment up
                      ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L'
                      WHERE VSH_USERNAME = in_loop_username) t WHERE t.REST_TO_PAY > 0;

            SET i_t = 0;
                    WHILE (i_t < nbr_of_unpaid_t)
                          AND (in_loop_amount > 0)
                          DO

                          -- Retrieve the first ref id
                          SELECT MIN(REF_ID) INTO in_loop_t_ref_id FROM (
                            SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                              FROM v_original_to_pay_for_user vop
                                LEFT JOIN uac_payment up
                                  ON vop.REF_ID = up.ref_fsc_id
                                  AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L'
                                  WHERE vop.VSH_USERNAME = in_loop_username
                                  AND vop.TRANCHE_CODE NOT IN (
                                    SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
                                    WHERE tvpu.VSH_USERNAME = in_loop_username)
                                    UNION
                                    SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                                    FROM v_left_to_pay_for_user vpu
                                    LEFT JOIN uac_payment up
                                    ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L'
                                    WHERE VSH_USERNAME = in_loop_username) t WHERE t.REST_TO_PAY > 0;

                            -- Retrieve the loop t amount
                            SELECT REST_TO_PAY INTO in_loop_t_amount FROM (
                              SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                                FROM v_original_to_pay_for_user vop
                                  LEFT JOIN uac_payment up
                                    ON vop.REF_ID = up.ref_fsc_id
                                    AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L'
                                    WHERE vop.VSH_USERNAME = in_loop_username
                                    AND vop.TRANCHE_CODE NOT IN (
                                      SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
                                      WHERE tvpu.VSH_USERNAME = in_loop_username)
                                      UNION
                                      SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                                      FROM v_left_to_pay_for_user vpu
                                      LEFT JOIN uac_payment up
                                      ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L'
                                      WHERE VSH_USERNAME = in_loop_username) t WHERE t.REST_TO_PAY > 0 AND t.REF_ID = in_loop_t_ref_id;

                                -- Then create the payment
                                INSERT INTO uac_payment (
                                  user_id,
                                  ref_fsc_id,
                                  status,
                                  payment_ref,
                                  input_amount,
                                  type_of_payment,
                                  pay_date,
                                  comment
                                )
                                VALUES (
                                  in_loop_user_id,
                                  in_loop_t_ref_id,
                                  'P',
                                  CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(inv_working_mvola_id, 5, '0'), 'P'),
                                  CASE WHEN (in_loop_amount > in_loop_t_amount) THEN in_loop_t_amount ELSE in_loop_amount END,
                                  'M',
                                  in_loop_paydate,
                                  'Paiement tranche avec Mvola'
                                );
                                SELECT LAST_INSERT_ID() INTO in_loop_xref_pay_id;
                                -- Update the xref
                                INSERT INTO uac_xref_payment_mvola (payment_id, mvola_id) VALUES (in_loop_xref_pay_id, inv_working_mvola_id);
                                -- We need to manage the rest of amount
                                IF (in_loop_amount > in_loop_t_amount) THEN
                                    SET in_loop_amount = in_loop_amount - in_loop_t_amount;
                                ELSE
                                    SET in_loop_amount = 0;
                                END IF;

                      SET i_t = i_t + 1;
                    END WHILE;


                    -- HANDLE TOO MUCH AMOUNT OF MONEY !!!
                    -- In this case if we have still too much money from the student then we have to save it somewhere
                    -- It will be saved has solde excedent to not be used
                    IF (in_loop_amount > 0) THEN
                        INSERT INTO uac_payment (
                          user_id,
                          ref_fsc_id,
                          status,
                          payment_ref,
                          input_amount,
                          type_of_payment,
                          pay_date,
                          comment
                        )
                        VALUES (
                          in_loop_user_id,
                          (SELECT MAX(id) FROM uac_ref_frais_scolarite WHERE code = 'UNUSEDM'),
                          'P',
                          CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(inv_working_mvola_id, 5, '0'), 'P'),
                          in_loop_amount,
                          'M',
                          in_loop_paydate,
                          'Solde excedent Mvola'
                        );
                        SELECT LAST_INSERT_ID() INTO in_loop_xref_pay_id;
                        -- Update the xref
                        INSERT INTO uac_xref_payment_mvola (payment_id, mvola_id) VALUES (in_loop_xref_pay_id, inv_working_mvola_id);
                        -- Make sure the amount has been used fully
                        SET in_loop_amount = 0;
                    END IF;

          -- END the line
          UPDATE uac_mvola_line uml
            SET uml.status = 'END'
            WHERE uml.id = inv_working_mvola_id AND status = 'INP';

          -- END Do the operation
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

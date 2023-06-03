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
DROP PROCEDURE IF EXISTS CLI_VAL_PayAddValidate$$
CREATE PROCEDURE `CLI_VAL_PayAddValidate` (IN param_user_id BIGINT, IN param_ticket_ref CHAR(10))
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
    -- END OF DECLARE


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

    SELECT actual_full_reduction AS ACTUAL_FULL_REDUCTION;
END$$
-- Remove $$ for OVH

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

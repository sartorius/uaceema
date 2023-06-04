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

DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_CRAMvola$$
CREATE PROCEDURE `SRV_CRT_CRAMvola` (IN param_filename VARCHAR(300))
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;

    DECLARE inv_master_id	BIGINT;
    DECLARE inv_old_master_id	BIGINT;

    DECLARE exist_cohort_id	TINYINT;
    DECLARE inv_cohort_id	INTEGER;


    DECLARE inv_time_stamp	DATETIME;
    DECLARE inv_date	      DATE;
    DECLARE inv_date_m12	  DATE;

    -- 1/ Check amount
    -- 2/ Check if valid date
    -- SELECT IFNULL(CONVERT('2022-08-17 97:13:28', DATETIME), CONVERT('2000-01-01 12:00:00', DATETIME));

    
    SELECT 'EDTLOAD' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, param_filename, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    UPDATE uac_load_edt SET flow_id = inv_flow_id, status = 'INP' WHERE filename = param_filename AND status = 'NEW';

    SELECT COUNT(1) INTO exist_cohort_id FROM uac_cohort uc
            				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
            					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
            					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
            					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                      WHERE urm.title = param_mention
                      AND uc.niveau = param_niveau
                      AND urp.title = param_uaparcours
                      AND urg.title = param_uagroupe;

    IF (exist_cohort_id = 0) THEN
      -- We have found no cohort so the file is probably corrupt
      UPDATE uac_load_edt SET status = 'ERR' WHERE flow_id = inv_flow_id;
      UPDATE uac_working_flow SET status = 'ERR', comment = 'Cohort not found', last_update = NOW() WHERE id = inv_flow_id;

      -- Return empty
      -- Return the list for control
      SELECT
        0 AS master_id,
        NULL AS mention,
        NULL AS niveau,
        NULL AS parcours,
        NULL AS groupe,
        DATE_FORMAT(param_monday_date, "%d/%m/%Y") AS mondayw,
        NULL AS nday,
        'X' AS course_status,
        0 AS day_code,
        0 AS hour_starts_at,
        0 AS duration_hour,
        NULL AS raw_course_title,
        NULL AS last_update;

    ELSE
      -- A cohort id exist !
      SELECT uc.id INTO inv_cohort_id FROM uac_cohort uc
              				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
              					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
              					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
              					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                        WHERE urm.title = param_mention
                        AND uc.niveau = param_niveau
                        AND urp.title = param_uaparcours
                        AND urg.title = param_uagroupe;


      -- Delete old lines
      -- Delete old lines to keep only one for this cohort
      SELECT id INTO inv_old_master_id
              FROM uac_edt_master
              WHERE monday_ofthew = param_monday_date
              AND cohort_id = inv_cohort_id;

      -- **********************************************************
      -- Delete the assiduite
      -- **********************************************************
      DELETE FROM uac_assiduite WHERE edt_id IN (
        SELECT id FROM uac_edt_line WHERE master_id = inv_old_master_id
      );
      DELETE FROM uac_edt_line WHERE master_id = inv_old_master_id;
      DELETE FROM uac_edt_master WHERE id = inv_old_master_id;

      -- Proceed to new lines !

      INSERT INTO uac_edt_master (flow_id, cohort_id, monday_ofthew) VALUES (inv_flow_id, inv_cohort_id, param_monday_date);
      SELECT LAST_INSERT_ID() INTO inv_master_id;

      INSERT INTO uac_edt_line (master_id, label_day, day, day_code, hour_starts_at, duration_hour, raw_course_title, course_status)
            SELECT inv_master_id, label_day, day, day_code, hour_starts_at, duration_hour,
                    -- Remove the A: in the file
                    CASE WHEN (raw_course_title like 'A:%') OR (raw_course_title like 'H:%') OR (raw_course_title like 'O:%')
                      THEN TRIM(SUBSTRING(raw_course_title, 3, length(raw_course_title))) ELSE TRIM(raw_course_title) END,
                    CASE
                          WHEN raw_course_title like 'A:%' THEN 'C'
                          -- H is for Hors Site when it is not Manankambahiny
                          WHEN raw_course_title like 'H:%' THEN 'H'
                          -- O is for Optionnal when course is not required
                          WHEN raw_course_title like 'O:%' THEN 'O'
                          -- A is for Active
                          ELSE 'A' END
            FROM uac_load_edt
            WHERE status = 'INP'
            AND flow_id = inv_flow_id;



      -- Remove duplicate
      UPDATE uac_working_flow uwf SET uwf.status = 'DUP'
      WHERE uwf.flow_code = 'QUEASSI'
      AND uwf.status IN ('NEW', 'QUE')
      AND uwf.working_date IN (
        SELECT DISTINCT ule.day FROM uac_load_edt ule
        WHERE ule.flow_id = inv_flow_id
      );


      -- Recalculate Assiduite If they have been in the past Add recalculation line here !!!
      SELECT CURRENT_DATE INTO inv_date;
      SELECT CURRENT_TIMESTAMP INTO inv_time_stamp;
      SELECT DATE_ADD(inv_date, INTERVAL -12 DAY) INTO inv_date_m12;


      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update)
            SELECT DISTINCT 'QUEASSI', 'NEW', day, 0, filename, inv_time_stamp
            FROM uac_load_edt
            WHERE flow_id = inv_flow_id
            AND status = 'INP'
            AND day < inv_date
            AND inv_date_m12 < day;

      UPDATE uac_load_edt SET status = 'END' WHERE flow_id = inv_flow_id AND status = 'INP';

      -- End of the flow correctly
      UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

      -- Return the list for control
      SELECT
        uem.id AS master_id,
        urm.title AS mention,
        uc.niveau AS niveau,
        urp.title AS parcours,
        urg.title AS groupe,
        DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
        DATE_FORMAT(uel.day, "%d/%m") AS nday,
        uel.day_code AS day_code,
        uel.hour_starts_at AS hour_starts_at,
        uel.duration_hour AS duration_hour,
        uel.raw_course_title AS raw_course_title,
        uel.course_status AS course_status,
        DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
      FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                            JOIN uac_cohort uc ON uc.id = uem.cohort_id
                  				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                  					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                  					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                  					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
      WHERE uem.id = inv_master_id
      ORDER BY uel.hour_starts_at, uel.day_code ASC;


    END IF;



END$$
-- End of SRV_CRT_CRAMvola
-- Remove $$ for OVH

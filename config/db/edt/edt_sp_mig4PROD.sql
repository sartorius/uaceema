DELIMITER ;;
DROP PROCEDURE IF EXISTS SRV_CRT_JQEDT;;
CREATE PROCEDURE `SRV_CRT_JQEDT` (IN param_stamp INT, IN param_monday_date DATE, IN param_cohort_id INT, IN param_order CHAR(1), IN param_title VARCHAR(300))
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;

    DECLARE inv_master_id	BIGINT;
    DECLARE inv_old_master_id	BIGINT;


    DECLARE inv_time_stamp	DATETIME;
    DECLARE inv_date	      DATE;
    DECLARE inv_date_m12	  DATE;
    DECLARE count_que_recal	SMALLINT;

    DECLARE sunday_date	DATE;

    -- CALL SRV_PRG_Scan();
    -- EDTLOAD

    SELECT 'EDTLOAD' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, CONCAT(param_cohort_id, '_', CONVERT(param_stamp, CHAR)), NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    -- Here we update all load lines with the same stamp
    UPDATE uac_load_jqedt SET flow_id = inv_flow_id, status = 'INP' WHERE tag_stamp_for_export = param_stamp AND cohort_id = param_cohort_id AND status = 'NEW';

    -- No error is possible on the cohort ID as we have the correct information

    -- Delete old lines
    -- Delete old lines to keep only one for this cohort
    SELECT id INTO inv_old_master_id
            FROM uac_edt_master
            WHERE monday_ofthew = param_monday_date
            AND cohort_id = param_cohort_id;

    -- **********************************************************
    -- Delete the assiduite
    -- **********************************************************
    DELETE FROM uac_assiduite WHERE edt_id IN (
      SELECT id FROM uac_edt_line WHERE master_id = inv_old_master_id
    );
    DELETE FROM uac_edt_line WHERE master_id = inv_old_master_id;
    DELETE FROM uac_edt_master WHERE id = inv_old_master_id;


    -- Proceed to new lines !
    -- Add the timestamp for Madagascar timezone
    INSERT INTO uac_edt_master (flow_id, cohort_id, monday_ofthew, visibility, jq_edt_type, edt_title, last_update) VALUES (inv_flow_id, param_cohort_id, param_monday_date, param_order, 'Y', fRemoveLineFeed(param_title), DATE_ADD(UTC_TIMESTAMP(), INTERVAL 3 HOUR));
    SELECT LAST_INSERT_ID() INTO inv_master_id;

    -- uac_edt_line INSERT HERE
    INSERT INTO uac_edt_line (
      master_id,
      label_day,
      course_status,
      day,
      day_code,
      hour_starts_at,
      duration_hour,
      raw_course_title,
      room_id,
      min_starts_at,
      duration_min,
      course_id,
      start_time,
      end_time,
      teacher_id,
      shift_duration)
          SELECT
          inv_master_id,
          label_day,
          course_status,
          tech_date,
          day_code,
          hour_starts_at,
          duration_hour,
          fEscapeStr(raw_course_title),
          room_id,
          min_starts_at,
          duration_min,
          course_id,
          start_time,
          end_time,
          teacher_id,
          shift_duration
          FROM uac_load_jqedt
          WHERE status = 'INP'
          AND flow_id = inv_flow_id;

    -- Recalculate Assiduite If they have been in the past Add recalculation line here !!!
    SELECT CURRENT_DATE INTO inv_date;
    SELECT CURRENT_TIMESTAMP INTO inv_time_stamp;
    SELECT DATE_ADD(inv_date, INTERVAL -12 DAY) INTO inv_date_m12;


    SELECT DATE_ADD(param_monday_date, INTERVAL 6 DAY) INTO sunday_date;

    -- Remove duplicate
    UPDATE uac_working_flow uwf SET uwf.status = 'DUP'
    WHERE uwf.flow_code = 'QUEASSI'
    AND uwf.status IN ('NEW', 'QUE')
    AND uwf.working_date < inv_date
    AND uwf.working_date < sunday_date
    AND uwf.working_date >= param_monday_date;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update)
          SELECT DISTINCT 'QUEASSI', 'NEW', DATE_ADD(param_monday_date, INTERVAL dq.id DAY), 0, CONCAT(param_cohort_id, '_', CONVERT(param_stamp, CHAR)), inv_time_stamp
            FROM uac_ref_day_queue dq
            WHERE dq.id < 6
            AND DATE_ADD(param_monday_date, INTERVAL dq.id DAY) < CURRENT_DATE
            AND inv_date_m12 < DATE_ADD(param_monday_date, INTERVAL dq.id DAY);


    SELECT 0 INTO count_que_recal;
    SELECT COUNT(1) INTO count_que_recal
      FROM uac_ref_day_queue dq
      WHERE dq.id < 6
      AND DATE_ADD(param_monday_date, INTERVAL dq.id DAY) < CURRENT_DATE
      AND inv_date_m12 < DATE_ADD(param_monday_date, INTERVAL dq.id DAY);


    UPDATE uac_load_jqedt SET status = 'END' WHERE flow_id = inv_flow_id AND status = 'INP';
    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

    -- Return the result with flow ID and the number of day recalculated
    SELECT
      inv_flow_id AS flow_id,
      count_que_recal AS day_recalc,
      DATE_FORMAT(NOW(), '%d/%m/%Y %H:%i') AS last_update;

END;;
DELIMITER ;

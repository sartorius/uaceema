DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_EDT$$
CREATE PROCEDURE `SRV_CRT_EDT` (IN param_filename VARCHAR(300), IN param_mention VARCHAR(100), IN param_niveau CHAR(2), IN param_option VARCHAR(45), IN param_monday_date DATE)
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_PRG_Scan();
    -- EDTLOAD

    SELECT 'EDTLOAD' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, param_filename, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    UPDATE uac_load_edt SET flow_id = inv_flow_id, status = 'INP' WHERE filename = param_filename AND status = 'NEW';

    -- Clean if the file has already been loaded

    IF param_option IS NULL THEN
      -- handle case option is NULL
          DELETE FROM uac_edt
            WHERE monday_ofthew = param_monday_date
            AND mention = param_mention
            AND niveau = param_niveau
            AND uaoption IS NULL;

   ELSE
         DELETE FROM uac_edt
           WHERE monday_ofthew = param_monday_date
           AND mention = param_mention
           AND niveau = param_niveau
           AND uaoption = param_option;
   END IF;


    INSERT IGNORE INTO uac_edt (flow_id, mention, niveau, uaoption, monday_ofthew, label_day, day, hour_starts_at, duration_hour, raw_course_title)
            SELECT inv_flow_id, param_mention, param_niveau, param_option, param_monday_date, label_day, day, hour_starts_at, duration_hour, raw_course_title
            FROM uac_load_edt
            WHERE status = 'INP'
            AND flow_id = inv_flow_id;

    UPDATE uac_load_edt SET status = 'END' WHERE filename = param_filename AND status = 'INP';

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH

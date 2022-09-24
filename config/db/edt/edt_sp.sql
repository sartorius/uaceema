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


    INSERT IGNORE INTO uac_edt (flow_id, mention, niveau, uaoption, monday_ofthew, label_day, day, day_code, hour_starts_at, duration_hour, raw_course_title)
            SELECT inv_flow_id, param_mention, param_niveau, param_option, param_monday_date, label_day, day, day_code, hour_starts_at, duration_hour, raw_course_title
            FROM uac_load_edt
            WHERE status = 'INP'
            AND flow_id = inv_flow_id;

    UPDATE uac_load_edt SET status = 'END' WHERE filename = param_filename AND status = 'INP';

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

    -- Return the list for control
    SELECT
      flow_id,
      mention,
      niveau,
      uaoption,
      DATE_FORMAT(monday_ofthew, "%d/%m/%Y") AS mondayw,
      DATE_FORMAT(day, "%d/%m") AS nday,
      day_code,
      hour_starts_at,
      duration_hour,
      raw_course_title
    FROM uac_edt WHERE flow_id = inv_flow_id ORDER BY hour_starts_at, day_code ASC;


END$$
-- Remove $$ for OVH

-- Read the EDT for a specific username
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_FWEDT$$
CREATE PROCEDURE `CLI_GET_FWEDT` (IN param_username VARCHAR(25))
BEGIN
    -- Return the list for control
    SELECT
      flow_id,
      mention,
      niveau,
      uaoption,
      DATE_FORMAT(monday_ofthew, "%d/%m/%Y") AS mondayw,
      DATE_FORMAT(day, "%d/%m") AS nday,
      day_code,
      hour_starts_at,
      duration_hour,
      raw_course_title
    FROM uac_edt WHERE monday_ofthew = '2022-09-26' AND visibility = 'V'
    ORDER BY hour_starts_at, day_code ASC;
END$$
-- Remove $$ for OVH

-- Read the EDT for a specific username
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_SMEDT$$
CREATE PROCEDURE `CLI_GET_SMEDT` (IN param_username VARCHAR(25))
BEGIN
    -- Return the list for control
    SELECT
      flow_id,
      mention,
      niveau,
      uaoption,
      DATE_FORMAT(monday_ofthew, "%d/%m/%Y") AS mondayw,
      DATE_FORMAT(day, "%d/%m") AS nday,
      day_code,
      hour_starts_at,
      duration_hour,
      raw_course_title
    FROM uac_edt WHERE monday_ofthew = '2022-09-26' AND visibility = 'V'
    AND day_code IN (1, 2, 3, 4, 5)
    ORDER BY hour_starts_at, day_code ASC;
END$$
-- Remove $$ for OVH

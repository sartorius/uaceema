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
CREATE PROCEDURE `CLI_GET_FWEDT` (IN param_username VARCHAR(25), IN param_week TINYINT, IN param_bkp CHAR(1))
BEGIN
    DECLARE inv_cur_date	DATE;
    DECLARE inv_monday_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;
    DECLARE count_result_set	INT;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL (7 * param_week) DAY) INTO inv_cur_date;
    -- inv_cur_dayw will be 7 or 1 for week end
    -- Check the week involved
    SELECT DAYOFWEEK(inv_cur_date) INTO inv_cur_dayw;

    -- If WE, we take next Monday
    IF inv_cur_dayw IN (7) THEN
        SELECT DATE_ADD(inv_cur_date, INTERVAL 2 DAY) INTO inv_monday_date;
    ELSEIF inv_cur_dayw IN (1) THEN
        SELECT DATE_ADD(inv_cur_date, INTERVAL 1 DAY) INTO inv_monday_date;
    ELSE
        SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO inv_monday_date;
    END IF;


    SELECT COUNT(1) INTO count_result_set FROM uac_edt WHERE monday_ofthew = inv_monday_date AND visibility = 'V';

    IF (count_result_set = 0) THEN
          SELECT
              NULL AS flow_id,
              NULL AS mention,
              NULL AS niveau,
              NULL AS uaoption,
              NULL AS label_day_fr,
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS mondayw,
              DATE_FORMAT(inv_cur_date, "%d/%m") AS nday,
              0 AS day_code,
              0 AS hour_starts_at,
              0 AS duration_hour,
              NULL AS raw_course_title;
    ELSE
      -- We have result
          IF (param_bkp = 'N') THEN
                -- Return the list for control
                SELECT
                  flow_id,
                  mention,
                  niveau,
                  uaoption,
                  label_day,
                  DATE_FORMAT(monday_ofthew, "%d/%m/%Y") AS mondayw,
                  DATE_FORMAT(day, "%d/%m") AS nday,
                  day_code,
                  hour_starts_at,
                  duration_hour,
                  raw_course_title
                FROM uac_edt WHERE monday_ofthew = inv_monday_date AND visibility = 'V'
                ORDER BY hour_starts_at, day_code ASC;

         ELSE
                 -- Return the list for control
                 SELECT
                   flow_id,
                   mention,
                   niveau,
                   uaoption,
                   CASE
                      WHEN day_code = 1 THEN "LUNDI"
                      WHEN day_code = 2 THEN "MARDI"
                      WHEN day_code = 3 THEN "MERCREDI"
                      WHEN day_code = 4 THEN "JEUDI"
                      WHEN day_code = 5 THEN "VENDREDI"
                      ELSE "SAMEDI"
                      END AS label_day_fr,
                   DATE_FORMAT(monday_ofthew, "%d/%m/%Y") AS mondayw,
                   DATE_FORMAT(day, "%d/%m") AS nday,
                   day_code,
                   hour_starts_at,
                   duration_hour,
                   raw_course_title
                 FROM uac_edt WHERE monday_ofthew = inv_monday_date AND visibility = 'V'
                 ORDER BY day_code, hour_starts_at  ASC;
         END IF;
    END IF;
END$$
-- Remove $$ for OVH

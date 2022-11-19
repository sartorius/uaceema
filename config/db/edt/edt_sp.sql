DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_EDT$$
CREATE PROCEDURE `SRV_CRT_EDT` (IN param_filename VARCHAR(300), IN param_monday_date DATE, IN param_mention VARCHAR(100), IN param_niveau CHAR(2), IN param_uaparcours VARCHAR(100), IN param_uagroupe VARCHAR(100))
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

    -- CALL SRV_PRG_Scan();
    -- EDTLOAD

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
        NULL AS raw_course_title;

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
                    CASE WHEN raw_course_title like 'A:%' THEN TRIM(SUBSTRING(raw_course_title, 3, length(raw_course_title))) ELSE TRIM(raw_course_title) END,
                    CASE WHEN raw_course_title like 'A:%' THEN 'C' ELSE 'A' END
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
        uel.course_status AS course_status
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
-- Remove $$ for OVH

-- Read the EDT for a specific username
-- param_bkp is to read the EDT per line if the display does not work
-- Display EDT for specific username
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


    SELECT COUNT(1) INTO count_result_set
        FROM uac_edt_master uem JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                AND uas.username = param_username
        WHERE monday_ofthew = inv_monday_date
        AND visibility = 'V';

    IF (count_result_set = 0) THEN
          SELECT
              NULL AS flow_id,
              NULL AS mention,
              NULL AS niveau,
              NULL AS parcours,
              NULL AS groupe,
              NULL AS label_day_fr,
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS mondayw,
              DATE_FORMAT(inv_cur_date, "%d/%m") AS nday,
              0 AS day_code,
              0 AS hour_starts_at,
              0 AS duration_hour,
              'X' AS course_status,
              NULL AS raw_course_title;
    ELSE
      -- We have result
          IF (param_bkp = 'N') THEN
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
                  /*
                  CASE WHEN (uel.course_status = 'C') THEN CONCAT('<i class="err"><strong>ANNULÉ</strong>: <i class="ua-line">', uel.raw_course_title, '</i></i>') ELSE uel.raw_course_title END AS html_raw_course_title,
                  CASE WHEN (uel.duration_hour MOD 2 = 1) THEN (uel.duration_hour DIV 2) + 1 ELSE (uel.duration_hour DIV 2) END AS html_start_disp,
                  (uel.duration_hour MOD 2) AS html_odd_even,
                  */
                  uel.course_status AS course_status
                FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                      JOIN uac_cohort uc ON uc.id = uem.cohort_id
                            				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                WHERE uem.monday_ofthew = inv_monday_date
                AND uem.visibility = 'V'
                ORDER BY uel.hour_starts_at, uel.day_code ASC;

         ELSE
                 -- Return the list for control
                 SELECT
                   uem.id AS master_id,
                   urm.title AS mention,
                   uc.niveau AS niveau,
                   urp.title AS parcours,
                   urg.title AS groupe,
                   CASE
                      WHEN uel.day_code = 1 THEN "LUNDI"
                      WHEN uel.day_code = 2 THEN "MARDI"
                      WHEN uel.day_code = 3 THEN "MERCREDI"
                      WHEN uel.day_code = 4 THEN "JEUDI"
                      WHEN uel.day_code = 5 THEN "VENDREDI"
                      ELSE "SAMEDI"
                      END AS label_day_fr,
                   DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                   DATE_FORMAT(uel.day, "%d/%m") AS nday,
                   uel.day_code AS day_code,
                   uel.hour_starts_at AS hour_starts_at,
                   uel.duration_hour AS duration_hour,
                   uel.raw_course_title AS raw_course_title,
                   uel.course_status AS course_status
                 FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                       JOIN uac_cohort uc ON uc.id = uem.cohort_id
                             				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                             					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                             					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                             					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                 WHERE uem.monday_ofthew = inv_monday_date
                 AND uem.visibility = 'V'
                 -- We need another order because we do not display per line here
                 ORDER BY uel.day_code, uel.hour_starts_at ASC;


         END IF;
    END IF;
END$$
-- Remove $$ for OVH



DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_MngEDTp3$$
CREATE PROCEDURE `CLI_GET_MngEDTp3` ()
BEGIN
    DECLARE monday_m_one	DATE;
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;
    DECLARE monday_two	DATE;
    DECLARE monday_three	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_monday_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;
    DECLARE count_result_set	INT;


    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_two;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_three;

    -- Specific day calulation from Monday zero
    SELECT DATE_ADD(monday_zero, INTERVAL -7 DAY) INTO monday_m_one;

    SELECT * FROM (SELECT 'S-1' AS s, 0 AS inv_w, DATE_FORMAT(monday_m_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S-1', DATE_FORMAT(monday_m_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_m_one ORDER BY cohort_id ASC) as a
    UNION ALL
    SELECT * FROM (SELECT 'S0' AS s, 0 AS inv_w, DATE_FORMAT(monday_zero, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S0', DATE_FORMAT(monday_zero, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_zero ORDER BY cohort_id ASC) as b
    UNION ALL
    SELECT * FROM (SELECT 'S1' AS s, 1 AS inv_w, DATE_FORMAT(monday_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S1', DATE_FORMAT(monday_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_one ORDER BY cohort_id ASC) as c
    UNION ALL
    SELECT * FROM (SELECT	'S2' AS s, 2 AS inv_w, DATE_FORMAT(monday_two, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S2', DATE_FORMAT(monday_two, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_two ORDER BY cohort_id ASC) as d
    UNION ALL
    SELECT * FROM (SELECT 'S3' AS s, 3 AS inv_w, DATE_FORMAT(monday_three, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S3', DATE_FORMAT(monday_three, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_three ORDER BY cohort_id ASC) as e;

END$$
-- Remove $$ for OVH

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_SHOWEDTForADM$$
CREATE PROCEDURE `CLI_GET_SHOWEDTForADM` (IN param_master_id VARCHAR(25))
BEGIN

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
      uel.course_status AS course_status
    FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                          JOIN uac_cohort uc ON uc.id = uem.cohort_id
                          JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                          JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                          JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                          JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
    WHERE uem.id = param_master_id
    AND uem.visibility = 'V'
    ORDER BY uel.hour_starts_at, uel.day_code ASC;

END$$
-- Remove $$ for OVH

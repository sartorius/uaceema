DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_JQEDT$$
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
    INSERT INTO uac_edt_master (flow_id, cohort_id, monday_ofthew, visibility, jq_edt_type, edt_title, last_update) VALUES (inv_flow_id, param_cohort_id, param_monday_date, param_order, 'Y', param_title, DATE_ADD(UTC_TIMESTAMP(), INTERVAL 3 HOUR));
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
          raw_course_title,
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

END$$
-- Remove $$ for OVH

DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_MngEDTp3$$
CREATE PROCEDURE `CLI_GET_MngEDTp3` (IN param_allow_draft_read CHAR(1))
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


    DECLARE draft_value_set	CHAR(1);

    IF (param_allow_draft_read = 'Y') THEN
      SELECT 'D' INTO draft_value_set;
    ELSE
      -- 0 is a value we must never use for this
      SELECT '0' INTO draft_value_set;
    END IF;


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

    SELECT * FROM (
        SELECT * FROM (SELECT 'S-1' AS s, -1 AS inv_w, DATE_FORMAT(monday_m_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S-1', DATE_FORMAT(monday_m_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_m_one ORDER BY cohort_id ASC) as a
        UNION ALL
        SELECT * FROM (SELECT 'S0' AS s, 0 AS inv_w, DATE_FORMAT(monday_zero, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S0', DATE_FORMAT(monday_zero, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_zero ORDER BY cohort_id ASC) as b
        UNION ALL
        SELECT * FROM (SELECT 'S1' AS s, 1 AS inv_w, DATE_FORMAT(monday_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S1', DATE_FORMAT(monday_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_one ORDER BY cohort_id ASC) as c
        UNION ALL
        SELECT * FROM (SELECT	'S2' AS s, 2 AS inv_w, DATE_FORMAT(monday_two, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S2', DATE_FORMAT(monday_two, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_two ORDER BY cohort_id ASC) as d
        UNION ALL
        SELECT * FROM (SELECT 'S3' AS s, 3 AS inv_w, DATE_FORMAT(monday_three, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S3', DATE_FORMAT(monday_three, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_three ORDER BY cohort_id ASC) as e
        ) union_all_tab ORDER BY tech_last_update DESC;

END$$
-- Remove $$ for OVH

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_SHOWJQEDTForADM$$
CREATE PROCEDURE `CLI_GET_SHOWJQEDTForADM` (IN param_master_id VARCHAR(25), IN param_allow_note_read CHAR(1))
BEGIN
    -- We must now how many line we have because if there is no line because no course we cannot fail
    DECLARE count_edt_line	SMALLINT;

    SELECT COUNT(1) INTO count_edt_line
    FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                          JOIN uac_cohort uc ON uc.id = uem.cohort_id
                          JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                          JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                          JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                          JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          JOIN uac_ref_room urr ON urr.id = uel.room_id
                          JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
    WHERE uem.id = param_master_id
    AND uem.visibility IN ('V', 'D');

    IF (count_edt_line > 0) THEN

          IF (param_allow_note_read = 'Y') THEN
                SELECT
                  uem.id AS master_id,
                  uem.jq_edt_type AS jq_edt_type,
                  uem.visibility AS visibility,
                  uem.cohort_id AS cohort_id,
                  uem.edt_title AS master_title,
                  vcc.short_classe AS short_classe,
                  urm.par_code AS mention_code,
                  urm.title AS mention,
                  uc.niveau AS niveau,
                  urp.title AS parcours,
                  urg.title AS groupe,
                  DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                  DATE_FORMAT(uel.day, "%d/%m") AS nday,
                  DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                  uel.day_code AS day_code,
                  uel.hour_starts_at AS uel_hour_starts_at,
                  uel.duration_hour AS uel_duration_hour,
                  fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                  uel.course_status AS course_status,
                  uel.course_id AS course_id,
                  uel.duration_min AS uel_duration_min,
                  uel.min_starts_at AS uel_min_starts_at,
                  uel.end_time AS uel_end_time,
                  uel.start_time AS uel_start_time,
                  uel.shift_duration AS uel_shift_duration,
                  uel.label_day AS uel_label_day,
                  urr.id AS urr_id,
                  urr.name AS urr_name,
                  urr.capacity AS room_capacity,
                  urt.id AS teacher_id,
                  urt.name AS teacher_name,
                  DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
                FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                      JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                      JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                      JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                      JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                      JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_ref_room urr ON urr.id = uel.room_id
                                      JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                      JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
                WHERE uem.id = param_master_id
                AND uem.visibility IN ('V', 'D')
                ORDER BY uel.hour_starts_at, uel.day_code ASC;
          ELSE
              -- Notes are note allowed for this user
              SELECT
                uem.id AS master_id,
                uem.jq_edt_type AS jq_edt_type,
                uem.visibility AS visibility,
                uem.cohort_id AS cohort_id,
                uem.edt_title AS master_title,
                vcc.short_classe AS short_classe,
                urm.par_code AS mention_code,
                urm.title AS mention,
                uc.niveau AS niveau,
                urp.title AS parcours,
                urg.title AS groupe,
                DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                DATE_FORMAT(uel.day, "%d/%m") AS nday,
                DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                uel.day_code AS day_code,
                uel.hour_starts_at AS uel_hour_starts_at,
                uel.duration_hour AS uel_duration_hour,
                fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                uel.course_status AS course_status,
                uel.course_id AS course_id,
                uel.duration_min AS uel_duration_min,
                uel.min_starts_at AS uel_min_starts_at,
                uel.end_time AS uel_end_time,
                uel.start_time AS uel_start_time,
                uel.shift_duration AS uel_shift_duration,
                uel.label_day AS uel_label_day,
                urr.id AS urr_id,
                urr.name AS urr_name,
                urr.capacity AS room_capacity,
                urt.id AS teacher_id,
                urt.name AS teacher_name,
                DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
              FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                    JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                    JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                    JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                    JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                    JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                    JOIN uac_ref_room urr ON urr.id = uel.room_id
                                    JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                    JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
              WHERE uem.id = param_master_id
              AND uem.visibility IN ('V')
              AND uel.course_status NOT IN ('1', '2')
              ORDER BY uel.hour_starts_at, uel.day_code ASC;
          END IF;

    ELSE
    SELECT
          uem.id AS master_id,
          uem.jq_edt_type AS jq_edt_type,
          uem.visibility AS visibility,
          uem.cohort_id AS cohort_id,
          uem.edt_title AS master_title,
          vcc.short_classe AS short_classe,
          urm.par_code AS mention_code,
          urm.title AS mention,
          uc.niveau AS niveau,
          urp.title AS parcours,
          urg.title AS groupe,
          DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
          DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
          NULL AS nday,
          NULL AS tech_date,
          NULL AS day_code,
          NULL AS hour_starts_at,
          NULL AS duration_hour,
          NULL AS raw_course_title,
          NULL AS course_status,
          NULL AS course_id,
          NULL AS uel_duration_min,
          NULL AS uel_min_starts_at,
          NULL AS uel_end_time,
          NULL AS uel_start_time,
          NULL AS uel_shift_duration,
          NULL AS uel_label_day,
          NULL AS urr_id,
          NULL AS urr_name,
          NULL AS room_capacity,
          0 AS teacher_id,
          NULL AS teacher_name,
          DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
          FROM uac_edt_master uem
          JOIN uac_cohort uc ON uc.id = uem.cohort_id
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                            JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                  WHERE uem.id = param_master_id;
    END IF;

END$$
-- Remove $$ for OVH


-- Read the EDT for a specific username
-- param_bkp is to read the EDT per line if the display does not work
-- Display EDT for specific username
-- Does not see any note 1 or 2
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_FWEDTJQ$$
CREATE PROCEDURE `CLI_GET_FWEDTJQ` (IN param_username VARCHAR(25), IN param_week TINYINT, IN param_bkp CHAR(1))
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
              NULL AS master_title,
              'N' AS jq_edt_type,
              NULL AS mention,
              NULL AS niveau,
              NULL AS parcours,
              NULL AS groupe,
              NULL AS label_day_fr,
              DATE_FORMAT(inv_monday_date, "%Y-%m-%d") AS inv_tech_monday,
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS monday,
              -- To be removed as duplicate old fashion
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS mondayw,
              DATE_FORMAT(inv_cur_date, "%d/%m") AS nday,
              0 AS day_code,
              0 AS hour_starts_at,
              0 AS duration_hour,
              'X' AS course_status,
              0 AS urr_id,
              'X' AS urr_name,
              'X' AS course_id,
              0 AS duration_min,
              0 AS min_starts_at,
              NULL AS end_time,
              NULL AS start_time,
              0 AS shift_duration,
              NULL AS raw_course_title,
              0 AS teacher_id,
              NULL AS teacher_name,
              NULL AS last_update;
    ELSE
      -- We have result
          IF (param_bkp = 'N') THEN
                -- Return the list for control
                SELECT
                  uem.id AS master_id,
                  uem.edt_title AS master_title,
                  uem.jq_edt_type AS jq_edt_type,
                  uem.visibility AS visibility,
                  uem.cohort_id AS cohort_id,
                  vcc.short_classe AS short_classe,
                  urm.title AS mention,
                  uc.niveau AS niveau,
                  urp.title AS parcours,
                  urg.title AS groupe,
                  DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS monday,
                  -- To be removed as duplicate old fashion
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                  DATE_FORMAT(uel.day, "%d/%m") AS nday,
                  DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                  uel.day_code AS day_code,
                  uel.hour_starts_at AS uel_hour_starts_at,
                  -- To be removed as duplicate old fashion
                  uel.hour_starts_at AS hour_starts_at,
                  uel.duration_hour AS uel_duration_hour,
                  -- To be removed as duplicate old fashion
                  uel.duration_hour AS duration_hour,
                  fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                  uel.course_status AS course_status,
                  urr.id AS urr_id,
                  urr.name AS urr_name,
                  urr.capacity AS room_capacity,
                  uel.course_id AS course_id,
                  uel.duration_min AS uel_duration_min,
                  uel.min_starts_at AS uel_min_starts_at,
                  uel.end_time AS uel_end_time,
                  uel.start_time AS uel_start_time,
                  uel.shift_duration AS uel_shift_duration,
                  urt.id AS teacher_id,
                  urt.name AS teacher_name,
                  uel.label_day AS uel_label_day,
                  DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
                FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                      JOIN uac_cohort uc ON uc.id = uem.cohort_id
                            				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_ref_room urr ON urr.id = uel.room_id
                                      JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                      JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                WHERE uem.monday_ofthew = inv_monday_date
                AND uem.visibility = 'V'
                AND uel.course_status NOT IN ('1', '2')
                ORDER BY uel.hour_starts_at, uel.day_code ASC;

         ELSE
                 -- Return the list for control
                 SELECT
                   uem.id AS master_id,
                   uem.edt_title AS master_title,
                   uem.jq_edt_type AS jq_edt_type,
                   uem.visibility AS visibility,
                   uem.cohort_id AS cohort_id,
                   vcc.short_classe AS short_classe,
                   urm.title AS mention,
                   uc.niveau AS niveau,
                   urp.title AS parcours,
                   urg.title AS groupe,
                   CASE
                      WHEN uel.day_code = 0 THEN "LUNDI"
                      WHEN uel.day_code = 1 THEN "MARDI"
                      WHEN uel.day_code = 2 THEN "MERCREDI"
                      WHEN uel.day_code = 3 THEN "JEUDI"
                      WHEN uel.day_code = 4 THEN "VENDREDI"
                      ELSE "SAMEDI"
                      END AS label_day_fr,
                   DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                   DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS monday,
                  -- To be removed as duplicate old fashion
                   DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                   DATE_FORMAT(uel.day, "%d/%m") AS nday,
                   DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                   uel.day_code AS day_code,
                   uel.hour_starts_at AS uel_hour_starts_at,
                  -- To be removed as duplicate old fashion
                   uel.hour_starts_at AS hour_starts_at,
                   uel.duration_hour AS uel_duration_hour,
                  -- To be removed as duplicate old fashion
                  uel.duration_hour AS duration_hour,
                   fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                   uel.course_status AS course_status,
                    urr.id AS urr_id,
                    urr.name AS urr_name,
                    urr.capacity AS room_capacity,
                    uel.course_id AS course_id,
                    uel.duration_min AS uel_duration_min,
                    uel.min_starts_at AS uel_min_starts_at,
                    uel.end_time AS uel_end_time,
                    uel.start_time AS uel_start_time,
                    uel.shift_duration AS uel_shift_duration,
                    urt.id AS teacher_id,
                    urt.name AS teacher_name,
                    uel.label_day AS uel_label_day,
                   DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
                 FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                       JOIN uac_cohort uc ON uc.id = uem.cohort_id
                             				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                             					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                             					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                             					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_ref_room urr ON urr.id = uel.room_id
                                      JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                      JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                 WHERE uem.monday_ofthew = inv_monday_date
                 AND uem.visibility = 'V'
                 AND uel.course_status NOT IN ('1', '2')
                 -- We need another order because we do not display per line here
                 ORDER BY uel.day_code, uel.hour_starts_at ASC;


         END IF;
    END IF;
END$$
-- Remove $$ for OVH


-- The export expect value as CHAR(1) 0, 1 or D and D i for the current day
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_EDTTextExport$$
CREATE PROCEDURE `CLI_GET_EDTTextExport` (IN param_type CHAR(1))
BEGIN
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;

    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    IF (param_type = '0') THEN
                SELECT
                 'S0' AS inv_s,
                 uem.id AS master_id,
                 uem.edt_title AS master_title,
                 uem.cohort_id AS cohort_id,
                 vcc.short_classe AS short_classe,
                 CASE
                    WHEN uel.day_code = 0 THEN "LUNDI"
                    WHEN uel.day_code = 1 THEN "MARDI"
                    WHEN uel.day_code = 2 THEN "MERCREDI"
                    WHEN uel.day_code = 3 THEN "JEUDI"
                    WHEN uel.day_code = 4 THEN "VENDREDI"
                    ELSE "SAMEDI"
                    END AS label_day_fr,
                 DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                 DATE_FORMAT(uel.day, "%d/%m") AS nday,
                 fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                 uel.course_status AS course_status,
                  urr.id AS urr_id,
                  urr.name AS urr_name,
                  uel.duration_min AS uel_duration_min,
                  uel.min_starts_at AS uel_min_starts_at,
                  uel.end_time AS uel_end_time,
                  uel.start_time AS uel_start_time,
                  urt.id AS teacher_id,
                  urt.name AS teacher_name,
                 DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
               FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                     JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                    JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                    JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                    JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                    JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                    JOIN uac_ref_room urr ON urr.id = uel.room_id
                                    JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                    JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
               WHERE uem.monday_ofthew = monday_zero
               AND uem.visibility = 'V'
               AND uem.jq_edt_type = 'Y'
               AND uel.course_status NOT IN ('1', '2')
               ORDER BY uem.cohort_id, uel.day_code, uel.hour_starts_at ASC;
    ELSEIF (param_type = '1')  THEN
              SELECT
               'S1' AS inv_s,
               uem.id AS master_id,
               uem.edt_title AS master_title,
               uem.cohort_id AS cohort_id,
               vcc.short_classe AS short_classe,
               CASE
                  WHEN uel.day_code = 0 THEN "LUNDI"
                  WHEN uel.day_code = 1 THEN "MARDI"
                  WHEN uel.day_code = 2 THEN "MERCREDI"
                  WHEN uel.day_code = 3 THEN "JEUDI"
                  WHEN uel.day_code = 4 THEN "VENDREDI"
                  ELSE "SAMEDI"
                  END AS label_day_fr,
               DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
               DATE_FORMAT(uel.day, "%d/%m") AS nday,
               fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
               uel.course_status AS course_status,
                urr.id AS urr_id,
                urr.name AS urr_name,
                uel.duration_min AS uel_duration_min,
                uel.min_starts_at AS uel_min_starts_at,
                uel.end_time AS uel_end_time,
                uel.start_time AS uel_start_time,
                urt.id AS teacher_id,
                urt.name AS teacher_name,
               DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
             FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                   JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                  JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                  JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                  JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                  JOIN uac_ref_room urr ON urr.id = uel.room_id
                                  JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                  JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
             WHERE uem.monday_ofthew = monday_one
             AND uem.visibility = 'V'
             AND uem.jq_edt_type = 'Y'
             AND uel.course_status NOT IN ('1', '2')
             ORDER BY uem.cohort_id, uel.day_code, uel.hour_starts_at ASC;
    ELSEIF (param_type = 'D')  THEN
              SELECT
               'D' AS inv_s,
               uem.id AS master_id,
               uem.edt_title AS master_title,
               uem.cohort_id AS cohort_id,
               vcc.short_classe AS short_classe,
               CASE
                  WHEN uel.day_code = 0 THEN "LUNDI"
                  WHEN uel.day_code = 1 THEN "MARDI"
                  WHEN uel.day_code = 2 THEN "MERCREDI"
                  WHEN uel.day_code = 3 THEN "JEUDI"
                  WHEN uel.day_code = 4 THEN "VENDREDI"
                  ELSE "SAMEDI"
                  END AS label_day_fr,
               DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
               DATE_FORMAT(uel.day, "%d/%m") AS nday,
               fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
               uel.course_status AS course_status,
                urr.id AS urr_id,
                urr.name AS urr_name,
                uel.duration_min AS uel_duration_min,
                uel.min_starts_at AS uel_min_starts_at,
                uel.end_time AS uel_end_time,
                uel.start_time AS uel_start_time,
                urt.id AS teacher_id,
                urt.name AS teacher_name,
               DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
             FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                   JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                  JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                  JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                  JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                  JOIN uac_ref_room urr ON urr.id = uel.room_id
                                  JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                  JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
             WHERE uem.last_update > CURRENT_DATE
             AND uem.monday_ofthew <= CURRENT_DATE
             AND uem.visibility = 'V'
             AND uem.jq_edt_type = 'Y'
             AND uel.course_status NOT IN ('1', '2')
             ORDER BY uem.cohort_id, uel.day_code, uel.hour_starts_at ASC;
    END IF;
END$$
-- Remove $$ for OVH


-- The export expect value as CHAR(1) 0, 1 or D and D i for the current day
-- We tell here if the EDT is empty or missing
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_EDTTextExportWarningS0S1$$
CREATE PROCEDURE `CLI_GET_EDTTextExportWarningS0S1` ()
BEGIN
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;

    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    SELECT
        'S0' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'M' AS status,
        monday_zero AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id NOT IN (SELECT cohort_id FROM uac_edt_master WHERE monday_ofthew = monday_zero AND visibility = 'V')
    UNION
    SELECT
        'S0' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'E' AS status,
        monday_zero AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id IN (SELECT cohort_id FROM uac_edt_master uem LEFT JOIN uac_edt_line uel
                                                                  ON uel.master_id = uem.id
                                                                  AND uem.visibility = 'V'
                                                                  AND uel.course_status IN ('A', 'H', 'O', 'C')
                                          WHERE uem.monday_ofthew = monday_zero
                                          AND uel.id IS NULL
                                          -- OR uel.id IS NOT NULL AND NOT EXISTS uel.course_status IN (A, H, O, C)
                                          )
    UNION
    SELECT
        'S1' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'M' AS status,
        monday_one AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id NOT IN (SELECT cohort_id FROM uac_edt_master WHERE monday_ofthew = monday_one AND visibility = 'V')
    UNION
    SELECT
        'S1' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'E' AS status,
        monday_one AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id IN (SELECT cohort_id FROM uac_edt_master uem LEFT JOIN uac_edt_line uel
                                                                  ON uel.master_id = uem.id
                                                                  AND uem.visibility = 'V'
                                                                  AND uel.course_status IN ('A', 'H', 'O', 'C')
                                          WHERE uem.monday_ofthew = monday_one
                                          AND uel.id IS NULL
                                          -- OR uel.id IS NOT NULL AND NOT EXISTS uel.course_status IN (A, H, O, C)
                                          )
    ORDER BY 1, 2, 4 DESC;


END$$
-- Remove $$ for OVH

-- Legacy to be dropped
-- DROP PROCEDURE IF EXISTS CLI_GET_SHOWEDTForADM$$
-- DROP PROCEDURE IF EXISTS CLI_GET_FWEDT$$


-- The export expect value as CHAR(1) 0, 1 or D and D i for the current day
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_PublishAllEDTS1$$
CREATE PROCEDURE `CLI_GET_PublishAllEDTS1` ()
BEGIN
    DECLARE monday_one	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;

    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    -- Main operation is done here !
    UPDATE uac_edt_master SET visibility = 'V' WHERE monday_ofthew = monday_one;
END$$
-- Remove $$ for OVH

DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_ComptAssdFlow$$
CREATE PROCEDURE `SRV_CRT_ComptAssdFlow` (IN param DATE)
BEGIN
    -- CALL SRV_CRT_ComptAssdFlow(NULL);
    DECLARE inv_date	DATE;
    -- On current day, we work on courses finished from 1h of current time
    DECLARE inv_time	TIME;

    DECLARE inv_flow_code	CHAR(7);
    DECLARE concurrent_flow INT;
    DECLARE inv_flow_id	BIGINT;
    DECLARE late_definition	VARCHAR(50);
    DECLARE wait_b_compute	VARCHAR(50);

    DECLARE inv_edt_id	BIGINT;
    DECLARE inv_edt_starts	TINYINT;
    DECLARE inv_edt_ends	TINYINT;
    DECLARE count_courses_todo INT;
    DECLARE inv_cohort_id	BIGINT;

    DECLARE i INT default 0;
    SET i = 0;



    SELECT 'ASSIDUI' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
      -- A flow is running we input a CAN line
      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'CAN', CURRENT_DATE, 0, NOW());
    ELSE
      -- Previous RUN has finished
      -- We can work !

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        SELECT par_value INTO late_definition FROM uac_param WHERE key_code = 'ASSLATE';
        SELECT par_value INTO wait_b_compute FROM uac_param WHERE key_code = 'ASSWAIT';


        -- If the parameter is null, we consider the day of today !
        IF param IS NULL THEN
            -- statements ;
            -- SELECT 'empty parameters';
            SELECT CURRENT_DATE INTO inv_date;
            select CURRENT_TIME INTO inv_time;

       ELSE
            -- statements ;
            -- We will work for the full day
            SELECT param INTO inv_date;
            SELECT CONVERT('23:59:59', TIME) INTO inv_time;

       END IF;
       -- Manage Date NULL

        -- BODY START
        -- We need to loop all courses of the day
        SELECT COUNT(1) INTO count_courses_todo
          FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
          AND ue.course_status = 'A'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.duration_hour > 0
          AND CONVERT(
                CONCAT(
                  CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                    THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                    -- we consider the cours which are finished after 25min otherwise they will be consider after
                    -- wait_b_compute ':25:00'
                    wait_b_compute), TIME) < inv_time;

        -- ********************************************
        -- ********************************************
        -- ****************** START *******************
        -- ********************************************
        -- ********************************************
        WHILE i < count_courses_todo DO

          -- INITIALIZATION
          SELECT MAX(id) INTO inv_edt_id
              FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
              AND ue.course_status = 'A'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.duration_hour > 0
              AND CONVERT(
                    CONCAT(
                      CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                        THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                        -- wait_b_compute ':20:00'
                        wait_b_compute), TIME) < inv_time;

          -- We need to consider only involved cohort_id and with visibility V
          SELECT cohort_id INTO inv_cohort_id FROM uac_edt_master WHERE id IN (SELECT master_id FROM uac_edt_line WHERE ID = inv_edt_id AND VISIBILITY = 'V');

          -- Initialize the hour start at & hour ends
          SELECT hour_starts_at INTO inv_edt_starts FROM uac_edt_line WHERE id = inv_edt_id;
          SELECT (hour_starts_at + duration_hour) INTO inv_edt_ends FROM uac_edt_line WHERE id = inv_edt_id;
          -- Je suis sensé bosser sur les cohorts id !!!


          -- ABS part 1 *** *** *** *** *** *** *** ***
          -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
          -- Final list of student missing or late over 10min !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, NULL, 'ABS' FROM mdl_user mu
          		 JOIN uac_showuser uas ON mu.username = uas.username
                                     AND uas.cohort_id = inv_cohort_id
          WHERE mu.username NOT IN (
          		SELECT t_student_in.username
          		FROM(
          					-- List of people who entered but not exit before 7:00
          					select mu.username, max(usa.scan_time) AS scan_in from uac_scan usa
          					join mdl_user mu on usa.user_id = mu.id
                    -- late_definition is like ':15:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username
          					) t_student_in
          		);

          -- People here are not ABS1
          -- ABS part 2 *** *** *** *** *** *** *** ***
          -- On met ceux qui sont sortis juste avant le +10
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student missing or late over 10min !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, NULL, 'ABS' FROM mdl_user mu
          		 JOIN uac_showuser uas ON mu.username = uas.username
                                     AND uas.cohort_id = inv_cohort_id
          WHERE mu.username IN (
          		SELECT t_student_in.username
          		FROM(
          					-- List of people who entered but not exit before 7:00
          					SELECT mu.username, usa.user_id, usa.scan_date, max(usa.scan_time) AS scan_in FROM uac_scan usa
          					join mdl_user mu on usa.user_id = mu.id
                    -- late_definition is like ':15:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username, usa.user_id, usa.scan_date
          					) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
												AND sca.user_id = t_student_in.user_id
												AND sca.scan_date = t_student_in.scan_date
                        -- the student went out before end of begining
												AND sca.in_out = 'O'
          		);

          -- People here are not ABS1 nor ABS2
          -- QUI : Quit when the student is leaving before the end of the course
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_ends) = 1) THEN CONCAT('0', inv_edt_ends) ELSE inv_edt_ends END, ':00:00'), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'O'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'O';

          -- People here are not ABS1 nor ABS2 nor QUI
          -- LAT *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student late 10min max !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'LAT' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'I';

          -- People here are not ABS1 nor ABS2 nor QUI nor LAT
          -- PON *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Student on time
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'PON' FROM (
          -- List of people who entered but not exit before 7:00
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'I';

          UPDATE uac_edt_line SET compute_late_status = 'END', last_update = NOW() WHERE id = inv_edt_id;
          SET i = i + 1;
        END WHILE;

        -- ********************************************
        -- ********************************************
        -- ****************** SEND ********************
        -- ********************************************
        -- ********************************************

        -- BODY END
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('EDT updated: ', count_courses_todo) WHERE id = inv_flow_id;

    END IF;
END$$
-- Remove $$ for OVH



DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_ResetAssdFlow$$
CREATE PROCEDURE `SRV_CRT_ResetAssdFlow` (IN param DATE)
BEGIN

    DECLARE inv_flow_code	CHAR(7);
    DECLARE concurrent_flow INT;
    DECLARE inv_flow_id	BIGINT;


    SELECT 'RESASSI' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
      -- A flow is running we input a CAN line
      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'CAN', CURRENT_DATE, 0, NOW());
    ELSE
      -- Previous RUN has finished
      -- We can work !

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        -- If the parameter is null, we consider the day of today !
        IF param IS NULL THEN
            -- statements ;
            -- Do not support empty
            UPDATE uac_working_flow SET status = 'ERR', comment = 'Missing param date', last_update = NOW() WHERE id = inv_flow_id;

       ELSE
            -- statements ;
            -- Do the work
            -- *********************************************
            -- B01: There is an issue here !
            -- Seems that the EDT have been deleted already !!!
            -- *********************************************
            DELETE FROM uac_assiduite WHERE edt_id IN (
              SELECT id FROM uac_edt_line WHERE day = param
            );

            UPDATE uac_edt_line SET compute_late_status = 'NEW' WHERE day = param;

       END IF;
       -- Manage Date NULL
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('Reset Assiduite day: ', param) WHERE id = inv_flow_id;

    END IF;
END$$
-- Remove $$ for OVH

DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_RUN_PastAssiduite$$
CREATE PROCEDURE `SRV_RUN_PastAssiduite` ()
BEGIN
    DECLARE inv_date	DATE;
    DECLARE inv_uwf_id	BIGINT;
    DECLARE count_past_todo INT;
    DECLARE i INT default 0;
    SET i = 0;

    -- We need to loop all past days
    SELECT COUNT(1) INTO count_past_todo
      FROM uac_working_flow uwf WHERE uwf.status = 'QUE' AND flow_code = 'QUEASSI';

    WHILE i < count_past_todo DO
      -- INITIALIZATION
      SELECT MAX(id) INTO inv_uwf_id
          FROM uac_working_flow uwf WHERE uwf.status = 'QUE' AND flow_code = 'QUEASSI';

      SELECT working_date INTO inv_date
          FROM uac_working_flow uwf WHERE id = inv_uwf_id;

      -- Do the reset actually and recalculation
      -- But be carefull we do it for the full new all day !
      CALL SRV_CRT_ResetAssdFlow(inv_date);
      CALL SRV_CRT_ComptAssdFlow(inv_date);

      UPDATE uac_working_flow SET status = 'END', comment = 'Run by Queue batch', last_update = NOW() WHERE id = inv_uwf_id;

      SET i = i + 1;
    END WHILE;


END$$
-- Remove $$ for OVH


DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_PRG_Ass$$
CREATE PROCEDURE `SRV_PRG_Ass` ()
BEGIN
    DECLARE prg_date	DATE;
    DECLARE prg_history_delta	INT;
    -- CALL SRV_PRG_Scan();

    SELECT par_int INTO prg_history_delta FROM uac_param WHERE key_code = 'ASSIPRG';
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -prg_history_delta DAY) INTO prg_date;

    -- Delete all old dates/ uas SCAN will be purged in ASSIDUITE
    DELETE FROM uac_scan WHERE scan_date < prg_date;
    -- We need to keep the off days for traceability purpose
    -- DELETE FROM uac_assiduite_off WHERE working_date < prg_date;
    DELETE FROM uac_assiduite WHERE edt_id IN (SELECT id FROM uac_edt_line WHERE day < prg_date) AND status IN ('PON');

    DELETE FROM uac_working_flow WHERE flow_code = 'ASSIDUI' AND create_date < prg_date;

END$$
-- Remove $$ for OVH

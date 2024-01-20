INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHLAT', 'Half late consideration minute LAT', 15, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHVLA', 'Half Very late consideration minute VLA', 59, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHWAI', 'Half late consideration minute', 25, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_time, par_code) VALUES ('LSTCRSD', 'Last course time end of the day', '18:00:00', NULL);

-- This does not delete old assiduite
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

    DECLARE late_jq_definition INT;
    DECLARE very_late_jq_definition INT;
    DECLARE wait_jq_b_compute INT;

    DECLARE inv_edt_id	BIGINT;
    DECLARE inv_edt_starts	TINYINT;
    DECLARE inv_edt_ends	TINYINT;
    DECLARE count_courses_todo INT;
    DECLARE count_courses_total INT;
    DECLARE inv_cohort_id	BIGINT;
    DECLARE inv_shifduration TINYINT;

    DECLARE inv_edt_starts_in_time	TIME;
    DECLARE inv_edt_ends_in_time	TIME;

    DECLARE all_course_finished_time	TIME;

    DECLARE i INT default 0;
    SET i = 0;
    SET count_courses_total = 0;
    SET inv_shifduration = 0;




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

    -- Last time of course to calculate no exit NEX
    SELECT par_time INTO all_course_finished_time FROM uac_param WHERE key_code = 'LSTCRSD';



    SELECT 'ASSIDUI' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
      -- A flow is running we input a CAN line
      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'CAN', inv_date, 0, NOW());
    ELSE
      -- Previous RUN has finished
      -- We can work !

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', inv_date, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        SELECT par_value INTO late_definition FROM uac_param WHERE key_code = 'ASSLATE';
        SELECT par_value INTO wait_b_compute FROM uac_param WHERE key_code = 'ASSWAIT';

        -- PARAMETERS FOR JQ EDT
        SELECT par_int INTO very_late_jq_definition FROM uac_param WHERE key_code = 'ASSHVLA';
        SELECT par_int INTO late_jq_definition FROM uac_param WHERE key_code = 'ASSHLAT';
        SELECT par_int INTO wait_jq_b_compute FROM uac_param WHERE key_code = 'ASSHWAI';

        -- BODY START
        -- Part one of two because we will redo the same for JQ
        -- We need to loop all courses of the day
        SELECT COUNT(1) INTO count_courses_todo
          FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
          AND ue.course_status = 'A'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.duration_hour > 0
          -- We check the JQ here
          -- For old fashion we dont check visibility here so visibility with I can move to END
          AND ue.master_id IN (
            SELECT id FROM uac_edt_master WHERE jq_edt_type = 'N'
          )
          AND CONVERT(
                CONCAT(
                  CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                    THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                    -- we consider the cours which are finished after 25min otherwise they will be consider after
                    -- wait_b_compute ':25:00'
                    wait_b_compute), TIME) < inv_time;

        -- ********************************************
        -- ********************************************
        -- *************** START NOT JQ ***************
        -- ********************************************
        -- ********************************************
        -- Old fashion for NOT JQ
        WHILE i < count_courses_todo DO

          -- INITIALIZATION
          SELECT MAX(id) INTO inv_edt_id
              FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
              AND ue.course_status = 'A'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.duration_hour > 0
              -- We check the JQ here
              -- For old fashion we dont check visibility here so visibility with I can move to END
              AND ue.master_id IN (
                SELECT id FROM uac_edt_master WHERE jq_edt_type = 'N'
              )
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

          -- NOT JQ
          -- ABS part 1 *** *** *** *** *** *** *** ***
          -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
          -- Final list of student missing or late over 15min !
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

          -- NOT IN JQ
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

          -- End the loop WHILE part one of two
          UPDATE uac_edt_line SET compute_late_status = 'END', last_update = NOW() WHERE id = inv_edt_id;
          SET i = i + 1;
        END WHILE;

        SET count_courses_total = count_courses_total + count_courses_todo;
        -- ********************************************
        -- ********************************************
        -- ************** END PART 1/2 ****************
        -- ********************************************
        -- ********************************************

        -- Part two of two because we will redo the same for JQ
        -- We need to loop all courses of the involved day and we restart the job
        -- We consider shift duration and timing per minute
        SELECT COUNT(1) INTO count_courses_todo
          FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
          AND ue.course_status = 'A'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.shift_duration > 0
          -- We check the JQ here
          -- For old fashion we dont check visibility here so visibility with I can move to END
          -- In new style we consider only V (we dont consider I or D)
          AND ue.master_id IN (
            SELECT id FROM uac_edt_master WHERE jq_edt_type = 'Y' AND visibility = 'V'
          )
          AND DATE_ADD(
            		CONVERT(
            		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
            					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
            					),
                -- wait_jq_b_compute is the minute we wait end of the cours
            		TIME),interval (wait_jq_b_compute + (ue.shift_duration * 30)) minute) < inv_time;

        -- START THE LOOP AGAIN !
        -- ********************************************
        -- ********************************************
        -- ***************** START JQ *****************
        -- ********************************************
        -- ********************************************
        -- New fashion for JQ
        SET i = 0;
        WHILE i < count_courses_todo DO
          -- In the loop
          -- Do something here
          -- INITIALIZATION
          SELECT MAX(id) INTO inv_edt_id
              FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
              AND ue.course_status = 'A'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.shift_duration > 0
              -- We check the JQ here
              -- For old fashion we dont check visibility here so visibility with I can move to END
              -- In new style we consider only V (we dont consider I or D)
              AND ue.master_id IN (
                SELECT id FROM uac_edt_master WHERE jq_edt_type = 'Y' AND visibility = 'V'
              )
              AND DATE_ADD(
                		CONVERT(
                		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
                					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
                					),
                    -- wait_jq_b_compute is the minute we wait end of the cours
                		TIME),interval (wait_jq_b_compute + (ue.shift_duration * 30)) minute) < inv_time;


          -- We need to consider only involved cohort_id and with visibility V and JQ Y
          SELECT cohort_id INTO inv_cohort_id FROM uac_edt_master WHERE id IN (SELECT master_id FROM uac_edt_line WHERE ID = inv_edt_id);

          -- INITIALIZATION OF SHIFT START AND END IN TIME
          -- *******************************************************************************
          -- Initialize shift duration hour start at & hour ends
          -- Shift duration we need to know if the course is longer than 1 hour
          SELECT shift_duration INTO inv_shifduration FROM uac_edt_line WHERE id = inv_edt_id;
          -- Get the start time : inv_edt_starts_in_time
          SELECT CONVERT(
                		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
                					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
                					),
                		TIME) INTO inv_edt_starts_in_time FROM uac_edt_line ue WHERE ue.id = inv_edt_id;
          -- Get the end time : inv_edt_ends_in_time
          SELECT DATE_ADD(
                		CONVERT(
                		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
                					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
                					),
                		TIME), interval (ue.shift_duration * 30) minute) INTO inv_edt_ends_in_time FROM uac_edt_line ue WHERE ue.id = inv_edt_id;
          -- *******************************************************************************


          IF (inv_shifduration > 2) THEN
            -- In that case we are longer than one hour

            -- We need to handle the very late
            -- I am JQ
            -- Longer than one hour !
            -- ABS part 1 *** *** *** *** *** *** *** ***
            -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
            -- Final list of student missing or late over 15min !
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
                      -- very late definition is like '59' Saying max 59 min late
            					WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval very_late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username
            					) t_student_in
              );

            -- I AM JQ
            -- Longer than one hour !
            -- People here are not ABS1
            -- ABS part 2 *** *** *** *** *** *** *** ***
            -- On met ceux qui sont sortis juste avant le +59
            -- MISSING LINK with the correct COHORT ID !
            -- Final list of student missing or late over 59min !
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
                      -- very late definition is like '59' Saying max 59 min late
                      WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval very_late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username, usa.user_id, usa.scan_date
                      ) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
                          AND sca.user_id = t_student_in.user_id
                          AND sca.scan_date = t_student_in.scan_date
                          -- the student went out before end of begining
                          AND sca.in_out = 'O'
                );
            -- I AM JQ
            -- Longer than one hour !
            -- People here are not ABS1 nor ABS2
            -- QUI : Quit when the student is leaving before the end of the course
            INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
            SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
            -- List of people who entered between 7:00 and 7:10
            SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
            JOIN mdl_user mu on usa.user_id = mu.id
            WHERE usa.scan_time > inv_edt_starts_in_time
            AND usa.scan_time < inv_edt_ends_in_time
            AND usa.scan_date = inv_date
            GROUP BY mu.username, in_out
            HAVING in_out = 'O'
            ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                                 AND uas.cohort_id = inv_cohort_id
            			   JOIN mdl_user mu on mu.username = uas.username
            			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
            			   	  							  AND max_scan.scan_time = scan_in
            			   	  							  AND max_scan.in_out = 'O';

            -- I AM JQ
            -- Longer than one hour !
            -- People here are not ABS1 nor ABS2 nor QUI
            -- LAT *** *** *** *** *** *** *** ***
            -- MISSING LINK with the correct COHORT ID !
            -- Final list of student late 59min max !
            INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
            SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'VLA' FROM (
            -- List of people who entered between 7:00 and 7:10
            SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
            JOIN mdl_user mu on usa.user_id = mu.id
            WHERE usa.scan_time > DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
            AND usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval very_late_jq_definition minute)
            AND usa.scan_date = inv_date
            GROUP BY mu.username, in_out
            HAVING in_out = 'I'
            ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                                 AND uas.cohort_id = inv_cohort_id
            			   JOIN mdl_user mu on mu.username = uas.username
            			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
            			   	  							  AND max_scan.scan_time = scan_in
            			   	  							  AND max_scan.in_out = 'I';


          -- Now we work for course less than one hour
          ELSE
            -- In that case we are not lesser than one hour
            -- We do not handle the very late
            -- In that case we are longer than one hour

            -- We do not handle the very late
            -- I am JQ
            -- Lesser than one hour !
            -- ABS part 1 *** *** *** *** *** *** *** ***
            -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
            -- Final list of student missing or late over 15min !
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
                      -- very late definition is like '59' Saying max 59 min late
            					WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username
            					) t_student_in
              );

            -- I AM JQ
            -- Lesser than one hour !
            -- People here are not ABS1
            -- ABS part 2 *** *** *** *** *** *** *** ***
            -- On met ceux qui sont sortis juste avant le +59
            -- MISSING LINK with the correct COHORT ID !
            -- Final list of student missing or late over 59min !
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
                      -- very late definition is like '59' Saying max 59 min late
                      WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username, usa.user_id, usa.scan_date
                      ) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
                          AND sca.user_id = t_student_in.user_id
                          AND sca.scan_date = t_student_in.scan_date
                          -- the student went out before end of begining
                          AND sca.in_out = 'O'
                );

                -- Note that QUI, LAT and PON are common to longer or lesser than 1 hour
                -- I AM JQ
                -- Lesser than one hour !
                -- People here are not ABS1 nor ABS2
                -- QUI : Quit when the student is leaving before the end of the course
                INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
                SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
                -- List of people who entered between 7:00 and 7:10
                SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
                JOIN mdl_user mu on usa.user_id = mu.id
                WHERE usa.scan_time > inv_edt_starts_in_time
                AND usa.scan_time < inv_edt_ends_in_time
                AND usa.scan_date = inv_date
                GROUP BY mu.username, in_out
                HAVING in_out = 'O'
                ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                                     AND uas.cohort_id = inv_cohort_id
                         JOIN mdl_user mu on mu.username = uas.username
                            JOIN uac_scan max_scan ON max_scan.user_id = mu.id
                                            AND max_scan.scan_time = scan_in
                                            AND max_scan.scan_date = inv_date
                                            AND max_scan.in_out = 'O';
          -- End of the duration > 2
          END IF;

          -- I AM JQ
          -- Common part
          -- People here are not ABS1 nor ABS2 nor QUI not VLA
          -- LAT *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student late 59min max !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'LAT' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > inv_edt_starts_in_time
          AND usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
                   JOIN mdl_user mu on mu.username = uas.username
                      JOIN uac_scan max_scan ON max_scan.user_id = mu.id
                                      AND max_scan.scan_time = scan_in
                                      AND max_scan.scan_date = inv_date
                                      AND max_scan.in_out = 'I';

          -- I AM JQ
          -- Longer than one hour !
          -- People here are not ABS1 nor ABS2 nor QUI nor LAT
          -- PON *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Student on time
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'PON' FROM (
          -- List of people who entered but not exit before 7:00
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time < inv_edt_starts_in_time
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
                   JOIN mdl_user mu on mu.username = uas.username
                      JOIN uac_scan max_scan ON max_scan.user_id = mu.id
                                      AND max_scan.scan_time = scan_in
                                      AND max_scan.scan_date = inv_date
                                      AND max_scan.in_out = 'I';



          -- End the loop WHILE part two of two
          UPDATE uac_edt_line SET compute_late_status = 'END', last_update = NOW() WHERE id = inv_edt_id;
          SET i = i + 1;

        END WHILE;
        SET count_courses_total = count_courses_total + count_courses_todo;

        -- ********************************************
        -- ********************************************
        -- ****************** SEND ********************
        -- ********************************************
        -- ********************************************

        -- *****************************************************************************
        -- *****************************************************************************
        -- ****************** START : HANDLE THE NO EXIT TO BE ABSENT ******************
        -- *****************************************************************************
        -- *****************************************************************************

        IF (CURRENT_TIME > all_course_finished_time) OR (CURRENT_DATE > inv_date) THEN
          -- DELETE ALL Lines for involved date
          DELETE FROM uac_assiduite_noexit WHERE inv_nex_date = inv_date;

          -- Fill it again
          INSERT IGNORE INTO uac_assiduite_noexit (user_id, max_scan_id, max_edt_id, inv_nex_date)
          -- Do an update with this couple of value
          SELECT max_scan.user_id, max_scan.id, MAX(uel.id), inv_date FROM (
                    -- List of last scan of people
                    SELECT mu.id AS mu_id, usa.scan_date AS nooutscan_date, max(usa.scan_time) AS scan_in from uac_scan usa
                    JOIN mdl_user mu on usa.user_id = mu.id
                    WHERE 1=1
                    -- For these specific dates
                    AND usa.scan_date = inv_date
                    GROUP BY mu.id, usa.scan_date
                    ) t_student_noout JOIN uac_scan max_scan
                                            -- Match the full scan if it is I
                                            ON max_scan.user_id = t_student_noout.mu_id
                                            AND max_scan.scan_time = scan_in
                                            AND max_scan.scan_date = t_student_noout.nooutscan_date
                                            AND max_scan.in_out = 'I'
                                      -- Need to know if he as been PON/LAT etc
                                      JOIN uac_assiduite uaa
                                              ON uaa.user_id = max_scan.user_id
                                             -- AND max_scan.id = uaa.scan_id
                                             AND uaa.status IN ('PON', 'LAT', 'VLA', 'QUI')
                                        JOIN uac_edt_line uel
                                        ON uel.id = uaa.edt_id
                                        AND uel.day = max_scan.scan_date
                                    JOIN v_showuser vsh ON vsh.id = max_scan.user_id
                                    JOIN v_class_cohort vcc ON vcc.id = vsh.cohort_id
                     GROUP BY max_scan.user_id, max_scan.id;

          -- We calculate here the student who has not exit for the end of the day
          UPDATE uac_assiduite
            SET status = 'NEX',
            last_update = CURRENT_TIMESTAMP
            WHERE (user_id, edt_id) IN (
              SELECT user_id, max_edt_id FROM uac_assiduite_noexit WHERE inv_nex_date = inv_date
            );

          -- UPDATE All lines which has been before the last entry no exit to ABS
          UPDATE uac_assiduite
            SET status = 'ABS',
            last_update = CURRENT_TIMESTAMP
            WHERE status NOT IN ('NEX')
            AND (user_id, scan_id) IN (
              SELECT user_id, max_scan_id FROM uac_assiduite_noexit WHERE inv_nex_date = inv_date
            );
          -- ELSE : Nothing to do
        END IF;
        -- *****************************************************************************
        -- *****************************************************************************
        -- ******************  STOP : HANDLE THE NO EXIT TO BE ABSENT  *****************
        -- *****************************************************************************
        -- *****************************************************************************


        -- BODY END
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('EDT updated: ', count_courses_total) WHERE id = inv_flow_id;

    END IF;
END$$
-- Remove $$ for OVH


-- Legacy  delete these ones
-- both following will be deprecated
-- INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSLATE', 'Late maximum consideration', ':15:00', NULL, NULL);
-- INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIT', 'Attente script avant compute', ':25:00', NULL, NULL);



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

    DELETE FROM uac_assiduite_noexit WHERE inv_nex_date < prg_date;

    DELETE FROM uac_working_flow WHERE flow_code = 'ASSIDUI' AND create_date < prg_date;

END$$
-- Remove $$ for OVH

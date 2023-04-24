-- Here are migration necessary for half update
-- Legacy is the new form for next year
DROP TABLE IF EXISTS uac_load_jqedt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_jqedt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `flow_id` BIGINT NULL,
  `tag_stamp_for_export` SMALLINT UNSIGNED NOT NULL,
  `cohort_id` INT NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `tech_date` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `min_starts_at` TINYINT NULL,
  `duration_hour` TINYINT NULL,
  `duration_min` TINYINT NULL,
  `course_status` CHAR(1) NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `course_id` VARCHAR(10) NULL,
  `monday_ofthew` DATE NOT NULL,
  `room_id` SMALLINT NULL,
  `course_room` VARCHAR(50) NULL,
  `display_date` VARCHAR(15) NULL,
  `shift_duration` TINYINT NULL,
  `end_time` VARCHAR(10) NULL,
  `end_time_hour` VARCHAR(5) NULL,
  `end_time_min` VARCHAR(5) NULL,
  `start_time` VARCHAR(10) NULL,
  `start_time_hour` VARCHAR(5) NULL,
  `start_time_min` VARCHAR(5) NULL,
  `tech_day` VARCHAR(3) NULL COMMENT 'Related to courseId',
  `tech_hour` VARCHAR(3) NULL COMMENT 'Related to courseId',
  `teacher_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


ALTER TABLE uac_edt_master
ADD COLUMN `jq_edt_type` CHAR(1) NOT NULL DEFAULT 'N' AFTER monday_ofthew;

ALTER TABLE uac_edt_line
ADD COLUMN `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half' AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `end_time` VARCHAR(5) NULL AFTER course_id;
ALTER TABLE uac_edt_line
ADD COLUMN `start_time` VARCHAR(5) NULL AFTER course_id;
ALTER TABLE uac_edt_line
ADD COLUMN `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number' AFTER end_time;
ALTER TABLE uac_edt_line
ADD COLUMN `teacher_id` SMALLINT NOT NULL DEFAULT 0 AFTER shift_duration;



DROP TABLE IF EXISTS uac_ref_day_queue;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_day_queue` (
  `id` TINYINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'INP',
  PRIMARY KEY (`id`));

INSERT INTO uac_ref_day_queue (id) VALUES (0);
INSERT INTO uac_ref_day_queue (id) VALUES (1);
INSERT INTO uac_ref_day_queue (id) VALUES (2);
INSERT INTO uac_ref_day_queue (id) VALUES (3);
INSERT INTO uac_ref_day_queue (id) VALUES (4);
INSERT INTO uac_ref_day_queue (id) VALUES (5);
INSERT INTO uac_ref_day_queue (id) VALUES (6);
INSERT INTO uac_ref_day_queue (id) VALUES (7);


DROP VIEW IF EXISTS v_edt_used_room;
CREATE VIEW v_edt_used_room AS
SELECT  uem.id AS uem_id,
        uem.monday_ofthew AS uem_monday_ofthew,
        course_id AS course_id,
        uel.shift_duration AS shift_duration,
        room_id AS room_id,
        vcc.short_classe AS short_classe,
        uel.start_time AS start_time,
        uel.end_time AS end_time,
        DATE_FORMAT(uem.monday_ofthew, '%d/%m') AS disp_monday,
        0 AS cell_1_shift,
        0 AS cell_2_day,
        0 AS cell_3_half
FROM uac_edt_master uem JOIN uac_edt_line uel
							          ON uel.master_id = uem.id
								        JOIN v_class_cohort vcc
								        ON vcc.id = uem.cohort_id
WHERE uem.visibility IN ('V', 'D')
AND uel.course_status NOT IN ('C')
-- We dont consider the non specified
AND room_id > 0
AND uel.shift_duration > 0;
-- AND uem.monday_ofthew >= '2023-04-10' AND uem.monday_ofthew <= '2023-05-01';


/************************************ Teacher Referential ************************************/
DROP TABLE IF EXISTS uac_ref_teacher;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_teacher` (
  `id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_xref_teacher_mention;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_teacher_mention` (
  `teach_id` SMALLINT UNSIGNED NOT NULL,
  `mention_code` CHAR(5) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`teach_id`, `mention_code`));



/************************************ View ************************************/
-- Report are here
DROP VIEW IF EXISTS rep_course_dash;
CREATE VIEW rep_course_dash AS
SELECT vcc.short_classe AS CLASSE,
	CASE
                      WHEN uel.day_code = 1 THEN "Lundi"
                      WHEN uel.day_code = 2 THEN "Mardi"
                      WHEN uel.day_code = 3 THEN "Mercredi"
                      WHEN uel.day_code = 4 THEN "Jeudi"
                      WHEN uel.day_code = 5 THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR,
    CASE WHEN uel.course_status = "A" THEN "Présenté" ELSE "Annulé" END AS COURSE_STATUS,
    REPLACE(REPLACE(uel.raw_course_title, "\n", " - "), ",", "") AS COURS_DETAILS,
    DATE_FORMAT(uel.day, "%d/%m") AS COURS_DATE,
    CASE
                      WHEN DATE_FORMAT(uel.day, "%m") = '01' THEN "Janvier"
                      WHEN DATE_FORMAT(uel.day, "%m") = '02' THEN "Février"
                      WHEN DATE_FORMAT(uel.day, "%m") = '03' THEN "Mars"
                      WHEN DATE_FORMAT(uel.day, "%m") = '04' THEN "Avril"
                      WHEN DATE_FORMAT(uel.day, "%m") = '05' THEN "Mai"
                      WHEN DATE_FORMAT(uel.day, "%m") = '06' THEN "Juin"
                      WHEN DATE_FORMAT(uel.day, "%m") = '07' THEN "Juillet"
                      WHEN DATE_FORMAT(uel.day, "%m") = '08' THEN "Aout"
                      WHEN DATE_FORMAT(uel.day, "%m") = '09' THEN "Septembre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '10' THEN "Octobre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '11' THEN "Novembre"
                      ELSE "Décembre"
                      END AS MOIS,
    CONCAT(uel.hour_starts_at, 'h', CASE WHEN (CHAR_LENGTH(uel.min_starts_at) = 1) THEN '00' ELSE uel.min_starts_at END) AS DEBUT_COURS,
    CASE WHEN t_abs.abs_cnt IS NULL THEN 0 ELSE t_abs.abs_cnt END AS NBR_ABS,
    CASE WHEN t_qui.qui_cnt IS NULL THEN 0 ELSE t_qui.qui_cnt END AS NBR_QUI, t_cohort_count.cohort_count AS NUMBER_STUD,
    CASE WHEN uao.id IS NULL THEN 'NON' ELSE 'OUI' END AS OFF_DAY, uel.day AS TECH_DAY, uel.hour_starts_at AS TECH_HOUR
	FROM (
		SELECT edt_id AS abs_edt_id, count(1) AS abs_cnt
		FROM uac_assiduite
		WHERE status = 'ABS'
		GROUP BY edt_id
  ) t_abs RIGHT JOIN uac_edt_line uel ON uel.id = t_abs.abs_edt_id
	 LEFT JOIN (
		SELECT edt_id AS qui_edt_id, count(1) AS qui_cnt
		FROM uac_assiduite
		WHERE status = 'QUI'
		GROUP BY edt_id
	 ) t_qui ON uel.id = t_qui.qui_edt_id
	 JOIN uac_edt_master uem ON uel.master_id = uem.id
								AND uem.visibility = 'V'
	JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
	JOIN (
	SELECT cohort_id AS vshcohort_id, count(1) AS cohort_count
	FROM v_showuser
	GROUP BY cohort_id
	) t_cohort_count ON t_cohort_count.vshcohort_id = uem.cohort_id
	LEFT JOIN uac_assiduite_off uao ON uao.working_date = uel.day
	WHERE uel.duration_hour > 0
	AND uel.day <= CURRENT_DATE
	ORDER BY uel.day DESC;

-- Find fill up here : https://docs.google.com/spreadsheets/d/1k0sESkSmMPVc2PPN-cL4oPznnEmClZLn5Qsjq4uDiZ0/edit?usp=sharing
-- INSERT INTO uac_ref_teacher (id, name) VALUES (NULL, NULL);

-- INSERT INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (NULL, NULL);

/*************************************** LEGACY ***************************************/

/*
DROP TABLE IF EXISTS uac_edt_line;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_line` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `master_id` BIGINT UNSIGNED NULL,
  `compute_late_status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `duration_hour` TINYINT UNSIGNED NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half',
  `start_time` VARCHAR(5) NULL,
  `end_time` VARCHAR(5) NULL,
  `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number',
  `teacher_id` SMALLINT NOT NULL DEFAULT 0,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))

DROP TABLE IF EXISTS uac_edt_master;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_master` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `cohort_id` BIGINT UNSIGNED NULL,
  `visibility` CHAR(1) NOT NULL DEFAULT 'I',
  `monday_ofthew` DATE NOT NULL,
  `jq_edt_type` CHAR(1) NOT NULL DEFAULT 'N',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

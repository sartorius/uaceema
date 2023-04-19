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

/*************************************** LEGACY ***************************************/
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
    -- Modication starts here
    `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half',
    `start_time` VARCHAR(5) NULL,
    `end_time` VARCHAR(5) NULL,
    `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number',
    -- Modification ends here
    `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`));

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

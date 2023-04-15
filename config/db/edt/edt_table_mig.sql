-- Here are migration necessary for half update
-- Legacy is the new form for next year
DROP TABLE IF EXISTS uac_load_jqedt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_jqedt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `flow_id` BIGINT NULL,
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



INSERT INTO uac_load_jqedt
(user_id, status, flow_id, label_day, tech_date, day_code, hour_starts_at, min_starts_at, duration_hour, duration_min, course_status, raw_course_title, course_id, monday_ofthew, room_id, course_room, display_date, shift_duration, end_time, end_time_hour, end_time_min, start_time, start_time_hour, start_time_min, tech_day, tech_hour)
VALUES
(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


ALTER TABLE uac_edt_line
ADD COLUMN `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half' AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;





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
  `duration_hour` TINYINT NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  -- Modication starts here
  `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half',
  -- Modification ends here
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

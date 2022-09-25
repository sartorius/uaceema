
-- Not compatible with the output of Workbench
DROP TABLE IF EXISTS uac_load_edt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_edt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `status` CHAR(3) NOT NULL,
  `flow_id` BIGINT NULL,
  `filename` VARCHAR(300) NOT NULL,
  `mention` VARCHAR(100) NOT NULL,
  `niveau` CHAR(2) NOT NULL,
  `uaoption` VARCHAR(45) NULL,
  `monday_ofthew` DATE NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `raw_duration` VARCHAR(10) NULL,
  `duration_hour` TINYINT NULL,
  `log_pos` VARCHAR(10) NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- INSERT INTO uac_load_edt (user_id, status, filename, mention, niveau, monday_ofthew, label_day, day, hour_starts_at, duration, log_pos, raw_course_title, create_date) VALUES (user_id, 'NEW', );

-- compute_late_status Can be NEW, END or CAN if it is CAN then the day has been trouble by internet 
-- Visibility is I or V to validate
DROP TABLE IF EXISTS uac_edt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `cohort_id` BIGINT UNSIGNED NULL,
  `visibility` CHAR(1) NOT NULL DEFAULT 'I',
  `compute_late_status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `mention` VARCHAR(100) NOT NULL,
  `niveau` CHAR(2) NOT NULL,
  `uaoption` VARCHAR(45) NULL,
  `monday_ofthew` DATE NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `duration_hour` TINYINT NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

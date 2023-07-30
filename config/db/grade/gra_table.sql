DROP TABLE IF EXISTS uac_load_gra;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_gra` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW' COMMENT 'NEW INP and END',
  `master_id` BIGINT NOT NULL,
  `gra_path` VARCHAR(20) NULL,
  `gra_filename` VARCHAR(300) NULL,
  `page_i` TINYINT NULL COMMENT 'The position of the page',
  `browser` VARCHAR(45) NULL,
  `nbr_of_page` TINYINT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_gra_master;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_gra_master` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW' COMMENT 'It can be NEW REV END it can be back to review for correction',
  `last_agent_id` BIGINT UNSIGNED NOT NULL COMMENT 'Last agent id who has done the operation',
  `exam_date` DATE NULL COMMENT 'To be input at the filling',
  `zip_filename` VARCHAR(300) NULL,
  `subject_id` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `teacher_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `nbr_of_page` TINYINT NOT NULL,
  `cust_teacher_name` VARCHAR(100) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_gra_line;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_gra_line` (
  `id` BIGINT UNSIGNED NOT NULL,
  `master_id` BIGINT UNSIGNED NOT NULL,
  `gra_path` VARCHAR(20) NOT NULL,
  `gra_filename` VARCHAR(300) NULL,
  `page_i` TINYINT NOT NULL COMMENT 'The position of the page',
  `cross_bookmark` VARCHAR(100) NULL,
  `browser` VARCHAR(45) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- INDEX be carefull
DROP TABLE IF EXISTS uac_gra_grade;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_gra_grade` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `master_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NULL,
  `grade` DECIMAL(4,2) NOT NULL DEFAULT 0,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `IDX_USER_ID` USING BTREE (`user_id`));

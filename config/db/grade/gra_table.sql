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

DROP VIEW IF EXISTS v_master_exam;
CREATE VIEW v_master_exam AS
SELECT ugm.id AS UGM_ID,
	   ugm.status AS UGM_STATUS,
		 ugm.last_agent_id AS UGM_LAST_AGENT_ID,
		 ugm.exam_date AS UGM_TECH_DATE,
		 DATE_FORMAT(ugm.exam_date, "%d/%m/%Y") AS UGM_DATE,
		 ugm.zip_filename AS UGM_FILENAME,
		 ugm.cust_teacher_name AS UGM_TEACHER_NAME,
		 ugm.teacher_id AS UGM_TEACHER_ID,
		 ugm.subject_id AS UGM_SUBJECT_ID,
		 ugm.nbr_of_page AS UGM_NBR_OF_PAGE,
		 ugm.last_update AS UGM_TECH_LAST_UPDATE,
		 DATE_FORMAT(ugm.last_update, "%d/%m/%Y") AS UGM_LAST_UPDATE,
		 urs.mention_code AS URS_MENTION_CODE,
		 urm.title AS URM_MENTION_TITLE,
		 urs.niveau_code AS URS_NIVEAU_CODE,
		 urs.semester AS URS_SEMESTER,
		 urs.subject_title AS URS_TITLE,
		 urs.credit AS URS_CREDIT,
		 mu.username AS LAST_AGENT_USERNAME,
		 mu.firstname AS LAST_AGENT_FIRSTNAME,
		 mu.lastname AS LAST_AGENT_LASTNAME,
     CONCAT(
       UPPER(IFNULL(DATE_FORMAT(ugm.exam_date, "%d/%m/%Y"), '')),
       UPPER(IFNULL(ugm.cust_teacher_name, '')),
       UPPER(IFNULL(ugm.zip_filename, '')),
       UPPER(IFNULL(urs.subject_title, '')),
       UPPER(IFNULL(urm.title, '')),
       UPPER(mu.username),
       UPPER(mu.firstname),
       UPPER(mu.lastname)
     ) AS raw_data
FROM uac_gra_master ugm JOIN uac_ref_subject urs ON ugm.subject_id = urs.id
						            JOIN uac_ref_mention urm ON urs.mention_code = urm.par_code
							          JOIN uac_admin uaa ON uaa.id = ugm.last_agent_id
							          JOIN mdl_user mu ON mu.id = uaa.id;

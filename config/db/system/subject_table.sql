
DROP TABLE IF EXISTS uac_load_subject;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_subject` (
  `id` INT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `mention_code` CHAR(5) NULL,
  `niveau_code` CHAR(2) NULL,
  `classe_str` VARCHAR(20) NULL,
  `semester` TINYINT NULL,
  `subject_title` VARCHAR(200) NULL,
  `load_credit` VARCHAR(10) NULL,
  `credit` SMALLINT UNSIGNED NULL COMMENT 'Credit are x10',
  `teacher_name` VARCHAR(100) NULL,
  `comment` VARCHAR(100) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- INSERT INTO uac_load_subject (id, mention_code, niveau_code, classe_str, semester, subject_title, load_credit, teacher_name) VALUES (
-- https://docs.google.com/spreadsheets/d/1y1l3fRNYpJVj9aSkpbDg4VMT0V8xVs09jvJ_ZjiAk5I/edit?usp=sharing

DROP TABLE IF EXISTS uac_ref_subject;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_subject` (
  `id` INT UNSIGNED NOT NULL,
  `mention_code` CHAR(5) NULL,
  `niveau_code` CHAR(2) NULL,
  `semester` TINYINT UNSIGNED NULL,
  `subject_title` VARCHAR(200) NULL,
  `credit` SMALLINT UNSIGNED NULL COMMENT 'Credit are x10',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

-- INSERT INTO uac_ref_subject (id, mention_code, niveau_code, semester, subject_title, credit, teacher_name)

DROP TABLE IF EXISTS uac_xref_subject_cohort;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_subject_cohort` (
  `cohort_id` INT UNSIGNED NOT NULL,
  `subject_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`cohort_id`, `subject_id`));


/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/
/****************************************************************************************************/

DO NOT RUN THIS AUTOMTICALLY

UPDATE uac_load_subject
  SET status = 'ERR',
  comment = 'Missing credit' where load_credit = 'x';

UPDATE uac_load_subject
  SET credit = CAST(load_credit AS DECIMAL(5,2)) * 10 WHERE status = 'NEW';

-- Table tech_number already exists
-- insert in xref
INSERT IGNORE INTO uac_xref_subject_cohort (subject_id, cohort_id)
  SELECT
    uac_load_subject.id,
    SUBSTRING_INDEX(SUBSTRING_INDEX(uac_load_subject.classe_str, '|', tech_number.id), '|', -1)
  FROM
    tech_number INNER JOIN uac_load_subject
    ON CHAR_LENGTH(uac_load_subject.classe_str)
       -CHAR_LENGTH(REPLACE(uac_load_subject.classe_str, '|', ''))>=tech_number.id-1
  ORDER BY
    uac_load_subject.id, tech_number.id;

-- Insert in the main ref table
INSERT IGNORE INTO uac_ref_subject (id, mention_code, niveau_code, semester, subject_title, credit)
  SELECT id, mention_code, niveau_code, semester, subject_title, credit FROM uac_load_subject where status = 'NEW';

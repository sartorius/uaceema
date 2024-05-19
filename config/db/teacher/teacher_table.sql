-- Migration
/*
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_teacher` (
  `id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NULL,
  `title` CHAR(3) NOT NULL DEFAULT 'MON' COMMENT 'Can be MON MAD DOC PRF',
  `lastname` VARCHAR(100) NOT NULL DEFAULT 'na',
  `firstname` VARCHAR(100) NOT NULL DEFAULT 'na',
  `other_firstname` VARCHAR(100) NULL,
  `contract` CHAR(3) NULL COMMENT 'Option can be CME Chef de mention - PRF Professeur - CLS Fermé',
  `phone_main` VARCHAR(20) NULL,
  `phone_alt` VARCHAR(20) NULL,
  `email` VARCHAR(200) NULL,
  `agent_id` BIGINT NULL,
  `teacher_info` VARCHAR(250) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

*/

ALTER TABLE uac_ref_teacher
ADD COLUMN `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `email` VARCHAR(200) NULL AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `phone_alt` VARCHAR(20) NULL AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `phone_main` VARCHAR(20) NULL AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `contract` CHAR(3) NULL COMMENT 'Option can be CME Chef de mention - PRF Professeur - CLS Fermé' AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `other_firstname` VARCHAR(100) NULL AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `firstname` VARCHAR(100) NOT NULL DEFAULT 'na' AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `lastname` VARCHAR(100) NOT NULL DEFAULT 'na' AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `title` CHAR(3) NOT NULL DEFAULT 'MON' COMMENT 'Can be MON MAD PRF DOC' AFTER name;
ALTER TABLE uac_ref_teacher
ADD COLUMN `agent_id` BIGINT NULL AFTER email;
ALTER TABLE uac_ref_teacher
ADD COLUMN `teacher_info` VARCHAR(250) NULL AFTER email;

/*
ALTER TABLE uac_ref_teacher MODIFY `email` VARCHAR(200);
ALTER TABLE uac_ref_teacher MODIFY `phone_main` VARCHAR(20);
ALTER TABLE uac_ref_teacher MODIFY `phone_alt` VARCHAR(20);
ALTER TABLE uac_ref_teacher MODIFY `contract` CHAR(3);
ALTER TABLE uac_ref_teacher MODIFY `other_firstname` VARCHAR(100);
*/


update uac_ref_teacher set other_firstname = TRIM(other_firstname);
update uac_ref_teacher set firstname = TRIM(firstname);
update uac_ref_teacher set contract = NULL where contract = 'na';
update uac_ref_teacher set phone_main = NULL where phone_main = 'na';
update uac_ref_teacher set phone_alt = NULL where phone_alt = 'na';
update uac_ref_teacher set contract = NULL where contract = 'na';
update uac_ref_teacher set phone_main = NULL where phone_main = 'na';
update uac_ref_teacher set email = NULL where email = 'na';

update uac_ref_teacher set other_firstname = NULL where other_firstname = '';

DROP TABLE IF EXISTS uac_ref_teacher_contract;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_teacher_contract` (
  `contract_code` CHAR(3) NOT NULL,
  `contract_label` VARCHAR(70) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`contract_code`));

INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('EXP', 'Exceptionnel');
INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('ASS', 'Assistant');
INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('TIT', 'Titulaire');
INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('MAI', 'Maître de conférence');
INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('CON', 'Consultant');
INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('PRF', 'Professeur');
INSERT INTO uac_ref_teacher_contract (`contract_code`, `contract_label`) VALUES ('OTH', 'Autre');

DROP TABLE IF EXISTS uac_ref_title;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_title` (
  `title_code` CHAR(3) NOT NULL,
  `title_label` VARCHAR(70) NOT NULL,
  `abreviation` VARCHAR(5) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`title_code`));

INSERT INTO uac_ref_title (`title_code`, `title_label`, `abreviation`) VALUES ('MON', 'Monsieur', 'M.');
INSERT INTO uac_ref_title (`title_code`, `title_label`, `abreviation`) VALUES ('MAD', 'Madame', 'Mme');
INSERT INTO uac_ref_title (`title_code`, `title_label`, `abreviation`) VALUES ('PRF', 'Professeur', 'Pr');
INSERT INTO uac_ref_title (`title_code`, `title_label`, `abreviation`) VALUES ('DOC', 'Docteur', 'Dr');
INSERT INTO uac_ref_title (`title_code`, `title_label`, `abreviation`) VALUES ('MAI', 'Maître', 'Me');


-- View for manager
DROP VIEW IF EXISTS v_all_mention_teacher;
CREATE VIEW v_all_mention_teacher AS
SELECT
  urt.id AS TEA_ID,
  GROUP_CONCAT(DISTINCT ux.mention_code
                      ORDER BY ux.mention_code DESC SEPARATOR '/') AS TEA_ALL_MENTION_CODE
FROM uac_ref_teacher urt JOIN uac_xref_teacher_mention ux
                          ON urt.id = ux.teach_id
                          GROUP BY urt.id
                          ORDER BY urt.id ASC;

DROP VIEW IF EXISTS v_all_exist_uel_mention_teacher;
CREATE VIEW v_all_exist_uel_mention_teacher AS
SELECT uel.teacher_id AS UEL_TEA_ID, GROUP_CONCAT(DISTINCT vcc.mention_code
                      ORDER BY vcc.mention_code DESC SEPARATOR '/') AS UEL_TEA_MENTION FROM uac_edt_line uel
				JOIN uac_edt_master uem ON uel.master_id = uem.id AND uel.teacher_id > 0
					JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
					GROUP BY uel.teacher_id;

DROP VIEW IF EXISTS v_all_exist_ugm_mention_teacher;
CREATE VIEW v_all_exist_ugm_mention_teacher AS
SELECT ugm.teacher_id AS UGM_TEA_ID, GROUP_CONCAT(DISTINCT vcc.mention_code
                      ORDER BY vcc.mention_code DESC SEPARATOR '/') AS UGM_TEA_MENTION FROM uac_gra_master ugm JOIN uac_ref_subject urs ON ugm.subject_id = urs.id
								 JOIN uac_xref_subject_cohort x ON x.subject_id = urs.id
								 		JOIN v_class_cohort vcc ON vcc.id = x.cohort_id
								 		GROUP BY ugm.teacher_id;


-- All presented courses current month
-- C is for cancelled and M is for Prof absent
DROP VIEW IF EXISTS v_all_presented_per_teacher;
CREATE VIEW v_all_presented_per_teacher AS
SELECT uel.teacher_id AS VPC_TEA_ID, SUM(uel.shift_duration) AS SUM_P_SHIFT_DURATION FROM uac_edt_line uel JOIN uac_edt_master uem ON uel.master_id = uem.id
																							 AND uem.visibility = 'V'
WHERE uel.teacher_id > 0
AND (uel.day between  DATE_FORMAT(NOW() ,'%Y-%m-01') AND last_day(curdate()))
AND uel.course_status NOT IN ('C', 'M')
GROUP BY uel.teacher_id;


-- All missing teacher courses current month
-- M is for Prof Absent
DROP VIEW IF EXISTS v_all_missing_per_teacher;
CREATE VIEW v_all_missing_per_teacher AS
SELECT uel.teacher_id AS VMC_TEA_ID, SUM(uel.shift_duration) AS SUM_M_SHIFT_DURATION FROM uac_edt_line uel JOIN uac_edt_master uem ON uel.master_id = uem.id
																							 AND uem.visibility = 'V'
WHERE uel.teacher_id > 0
AND (uel.day between  DATE_FORMAT(NOW() ,'%Y-%m-01') AND last_day(curdate()))
AND uel.course_status IN ('M')
GROUP BY uel.teacher_id;

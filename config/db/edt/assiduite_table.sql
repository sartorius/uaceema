-- Manage assiduité here
DROP TABLE IF EXISTS uac_assiduite;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_assiduite` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT UNSIGNED NOT NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `edt_id` BIGINT UNSIGNED NOT NULL,
  `scan_id` BIGINT UNSIGNED NULL,
  `status` CHAR(3) NOT NULL,
  `valid_exec_uid` BIGINT NULL,
  `valid_cmt` VARCHAR(500) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));
-- This constraint avoid to have duplicate. We do first : Absent/Late/Present
ALTER TABLE uac_assiduite
  ADD CONSTRAINT student_course UNIQUE (user_id, edt_id);

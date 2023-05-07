-- Manage assiduité here
DROP TABLE IF EXISTS uac_assiduite_noexit;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_assiduite_noexit` (
  `user_id` BIGINT UNSIGNED NOT NULL,
  `max_edt_id` BIGINT UNSIGNED NOT NULL,
  `inv_nex_date` DATE NOT NULL,
  `max_scan_id` BIGINT UNSIGNED NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `max_edt_id`));

ALTER TABLE uac_assiduite
ADD COLUMN `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER valid_cmt;

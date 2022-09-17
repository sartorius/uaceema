
-- Not compatible with the output of Workbench
DROP TABLE IF EXISTS uac_mail;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_mail` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `flow_code` CHAR(7) NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NOTIF` (`flow_code`, `user_id`));

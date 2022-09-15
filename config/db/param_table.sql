DROP TABLE IF EXISTS uac_param;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_param` (
  `key_code` CHAR(7) NOT NULL,
  `description` VARCHAR(50) NOT NULL,
  `par_int` INT NULL,
  `par_code` VARCHAR(50) NULL,
  `par_date` DATE NULL,
  PRIMARY KEY (`key_code`));

INSERT INTO uac_param (key_code, description, par_int, par_code, par_date) VALUES ('SCANXXX', 'Flow retard', NULL, NULL, CURDATE());
INSERT INTO uac_param (key_code, description, par_int, par_code, par_date) VALUES ('SCANPRG', 'Flow purge scan', 7, NULL, CURDATE());


DROP TABLE IF EXISTS uac_working_flow;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_working_flow` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_code` CHAR(7) NOT NULL,
  `status` CHAR(3) NOT NULL,
  `working_date` DATE NULL,
  `working_part` TINYINT NULL,
  `last_update` DATETIME NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

  -- INSERT INTO (flow_code, status) VALUES ('SCANXXX', 'NEW');

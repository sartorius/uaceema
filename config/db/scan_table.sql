DROP TABLE IF EXISTS uac_load_scan;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_scan` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `scan_username` VARCHAR(50) NOT NULL,
  `scan_date` DATE NOT NULL,
  `scan_time` TIME NOT NULL,
  `status` CHAR(3) NOT NULL,
  PRIMARY KEY (`id`));


INSERT INTO uac_load_scan (user_id, scan_username, scan_date, scan_time, status) VALUES (1, 'TOTO', '2022-09-11', '01:41:24', 'NEW');

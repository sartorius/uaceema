DROP TABLE IF EXISTS uac_load_scan;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_scan` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `scan_username` VARCHAR(50) NOT NULL,
  `scan_date` DATE NOT NULL,
  `scan_time` TIME NOT NULL,
  `status` CHAR(3) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));
-- INSERT INTO uac_load_scan (user_id, scan_username, scan_date, scan_time, status) VALUES (1, 'TOTO', '2022-09-11', '01:41:24', 'NEW');







DROP TABLE IF EXISTS uac_scan;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_scan` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `agent_id` BIGINT UNSIGNED NOT NULL,
  `scan_date` DATE NOT NULL,
  `scan_time` TIME NOT NULL,
  `status` CHAR(3) NOT NULL,
  `edt_involved` INT UNSIGNED NOT NULL DEFAULT 0,
  `valid_exc_uid` BIGINT UNSIGNED NOT NULL DEFAULT 0,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


DROP TABLE IF EXISTS uac_scan_ferie;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_scan_ferie` (
  `working_date` DATE NOT NULL,
  `working_part` TINYINT NOT NULL DEFAULT 0,
  `title` VARCHAR(50) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`working_date`, `working_part`));

  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2022-11-01', 'Toussaint');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2022-12-25', 'Noel');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2022-12-25', 'Noel');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-01-01', 'Jour de l\'An');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-03-29', 'Commémoration 1947');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-04-10', 'Lundi de Pâques');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-05-01', 'Fête du Travail');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-05-18', 'Ascension');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-05-29', 'Pentecôte');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-06-26', 'Fête Nationale');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-08-15', 'Assomption');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-11-01', 'Toussaint');
  INSERT IGNORE INTO uac_scan_ferie (working_date, title) VALUES ('2023-12-25', 'Noel');

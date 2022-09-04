DROP TABLE IF EXISTS uac_admin;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_admin` (
  `id` BIGINT NOT NULL,
  `pwd` VARCHAR(255) NOT NULL,
  `last_connection` DATETIME NULL,
  `scale_right` TINYINT(1) NOT NULL DEFAULT 0,
  `role` VARCHAR(60) NOT NULL,
  `accounting_write` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`));

INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'benrand1234'), 'e716e0cf70d3c6dbd840945d890f074d', 'Recteur', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'harrako1912'), '78e740abec0d61e6dd52452e6d9c2a32', 'SG', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'lalrako3819'), '9248153d95104975573f18e2852d6647', 'DAF', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'ionrako6172'), '2df68a85f1932ca876926252bbaa0820', 'CGE', NULL);

-- SHOW USERS

DROP TABLE IF EXISTS uac_showuser;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_showuser` (
  `username` VARCHAR(30) NOT NULL,
  `roleid` TINYINT UNSIGNED NOT NULL,
  `secret` INT UNSIGNED NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`));

-- Insert
  INSERT IGNORE INTO uac_showuser (roleid, username)
  SELECT MAX(roleid), username FROM mdl_role_assignments mra
                                JOIN mdl_role mr ON mr.id = mra.roleid
                                JOIN mdl_user mu ON mu.id = mra.userid
  GROUP BY username;
-- Add secret
  UPDATE uac_showuser SET secret = 3000000000 + FLOOR(RAND()*1000000000), last_update = NOW() WHERE secret IS NULL;
-- Control to save !
  SELECT mu.id, mu.username, uas.secret, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, mr.shortname, mu.firstname, mu.lastname, mu.email, mu.phone1, mu.phone2
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
           JOIN mdl_role mr ON mr.id = uas.roleid;

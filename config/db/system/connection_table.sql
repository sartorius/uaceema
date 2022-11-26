DROP TABLE IF EXISTS uac_admin;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_admin` (
  `id` BIGINT NOT NULL,
  `pwd` VARCHAR(255) NOT NULL,
  `last_connection` DATETIME NULL,
  `scale_right` TINYINT(1) NOT NULL DEFAULT 0,
  `role` VARCHAR(60) NOT NULL,
  `accounting_write` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`));

/*********************************************************
**********************************************************
**********************************************************
**********************************************************
******************   WARNING  ****************************
**********************************************************
**********************************************************
**********************************************************
**********************************************************
*********************************************************/



-- /!\ IL FAUT AVOIR CRÉE LES UTILISATEURS AVANT DE CHARGER CES REQUÊTES D'ABORD

INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'benrand123'), 'e716e0cf70d3c6dbd840945d890f074d', 'Recteur', NULL, 7);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'harrako912'), '78e740abec0d61e6dd52452e6d9c2a32', 'SG', NULL, 11);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'lalrako381'), '9248153d95104975573f18e2852d6647', 'DAF', NULL, 5);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'ionrako617'), '3182a20c71d20d919cb1f3b3035d5924', 'CGE', NULL, 5);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'minoraj172'), '9248153d95104975573f18e2852d6647', 'EDT', NULL, 11);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'radoand728'), 'd064a894fb8645879312b10d366cd604', 'INF', NULL, 5);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'tokrako283'), '3182a20c71d20d919cb1f3b3035d5924', 'TST', NULL, 5);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'tsirako227'), '3182a20c71d20d919cb1f3b3035d5924', 'TST', NULL, 5);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'blourat077'), 'a2d426e5a92f1bbf418a35869ffc7cc2', 'ADM', NULL, 12);


INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mikrama654'), 'c24d593b9266e7b8d0887d0dc7259705', 'Agent', NULL);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mborako321'), 'd064a894fb8645879312b10d366cd604', 'Agent', NULL);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mavrako128'), '9433c9064f0593da5727e2122a193a6e', 'Agent', NULL);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'menrako232'), '3165cef3bc67568c7d30f5a184f43766', 'Agent', NULL);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'manrako092'), '2df68a85f1932ca876926252bbaa0820', 'Agent', NULL);
INSERT IGNORE INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'paulrab367'), 'a2d426e5a92f1bbf418a35869ffc7cc2', 'Agent', NULL);


-- SHOW USERS
-- This drop table is to not have to review all secret
-- We need to drop it if needed

-- DROP TABLE IF EXISTS uac_showuser;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_showuser` (
  `username` VARCHAR(30) NOT NULL,
  `roleid` TINYINT UNSIGNED NOT NULL,
  `secret` INT UNSIGNED NULL,
  `cohort_id` INT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`));


/*
  -- Insert
    INSERT IGNORE INTO uac_showuser (roleid, username)
    SELECT MAX(roleid), username FROM mdl_role_assignments mra
                                  JOIN mdl_role mr ON mr.id = mra.roleid
                                  JOIN mdl_user mu ON mu.id = mra.userid
    GROUP BY username;
  -- Add secret
    UPDATE uac_showuser SET secret = 3000000000 + FLOOR(RAND()*1000000000), last_update = NOW() WHERE secret IS NULL;
*/

  -- Control to save !
  /*
  SELECT
      mu.id AS ID,
            mu.username AS USERNAME,
             uas.secret AS SECRET,
             CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
             mr.shortname AS ROLE_SHORTNAME,
             UPPER(mu.firstname) AS FIRSTNAME,
             UPPER(mu.lastname) AS LASTNAME,
             mu.email AS EMAIL,
             mu.phone1 AS PHONE,
             mu.address AS ADDRESS,
             mu.city AS CITY,
             mu.phone2 AS PARENT_PHONE,
             mf.contextid AS PIC_CONTEXT_ID,
             mu.picture AS PICTURE_ID,
             SUBSTRING(mf.contenthash, 1, 2) AS D1,
             SUBSTRING(mf.contenthash, 3, 2) AS D2,
             mf.contenthash AS FILENAME
    FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
             JOIN mdl_role mr ON mr.id = uas.roleid
             LEFT JOIN mdl_files mf ON mu.picture = mf.id;
*/

DROP VIEW IF EXISTS v_showuser;
CREATE VIEW v_showuser AS
SELECT
		mu.id AS ID,
          mu.username AS USERNAME,
           uas.secret AS SECRET,
           CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
           UPPER(mu.firstname) AS FIRSTNAME,
           UPPER(mu.lastname) AS LASTNAME,
           uas.cohort_id AS COHORT_ID,
           mu.email AS EMAIL,
           mu.phone1 AS PHONE,
           mu.address AS ADDRESS,
           mu.city AS CITY,
           mu.phone_par1 AS PARENT_PHONE,
           mu.adresse_par1 AS PARENT_ADDR
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username;


DROP TABLE IF EXISTS uac_connection_log;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_connection_log` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
 `user_id` BIGINT NOT NULL,
 `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (`id`));

DROP VIEW IF EXISTS v_connection_log;
CREATE VIEW v_connection_log AS
SELECT
     mu.username AS USERNAME,
     UPPER(mu.firstname) AS FIRSTNAME,
     UPPER(mu.lastname) AS LASTNAME,
     ucl.create_date AS CREATION_DATE
FROM mdl_user mu JOIN  uac_connection_log ucl ON ucl.user_id = mu.id ORDER BY ucl.id DESC;

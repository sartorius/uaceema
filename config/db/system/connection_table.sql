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
           mu.adresse_par1 AS PARENT_ADDR,
           mu.genre AS GENRE,
           mu.matricule AS MATRICULE,
           TIMESTAMPDIFF(YEAR, mu.datedenaissance, CURDATE()) AS AGE,
           mu.lieu_de_naissance AS PL_BIRTH,
           mu.serie_bac AS BAC,
           mu.annee_bac AS YEAR_BAC,
           DATE_FORMAT(mu.datedenaissance, "%d/%m/%Y") AS BIRTHDAY,
           DATE_FORMAT(mu.datedenaissance, "%m") AS MONTHBDAY,
           vcc.short_classe AS SHORTCLASS,
           IFNULL(mu.autre_prenom, '') AS OTHER_FIRSTNAME,
           IFNULL(mu.phone_par2, '') AS PARENT_ALT_PHONE,
           IFNULL(mu.city_par1, '') AS PARENT_CITY
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
                  JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id;


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
FROM mdl_user mu JOIN  uac_connection_log ucl ON ucl.user_id = mu.id ORDER BY ucl.create_date DESC;

DROP TABLE IF EXISTS uac_studashboard_log;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_studashboard_log` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `origin` CHAR(1) NOT NULL,
  `admin_id` BIGINT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP VIEW IF EXISTS v_studashboard_log;
CREATE VIEW v_studashboard_log AS
SELECT
     mu.username AS USERNAME,
     UPPER(mu.firstname) AS FIRSTNAME,
     UPPER(mu.lastname) AS LASTNAME,
     CASE WHEN usl.origin = 'A' THEN 'Admin' ELSE 'Student' END AS ORIGIN,
     UPPER(muadmin.firstname) AS ADMINFIRSTNAME,
     usl.create_date AS CREATION_DATE
FROM mdl_user mu JOIN uac_studashboard_log usl ON usl.user_id = mu.id
                 LEFT JOIN mdl_user muadmin ON usl.admin_id = muadmin.id
ORDER BY usl.create_date DESC;


DROP VIEW IF EXISTS v_showadmin;
CREATE VIEW v_showadmin AS
SELECT mu.id AS mu_id,
		mu.username,
		mu.firstname,
		mu.lastname,
		ua.*
FROM mdl_user mu JOIN uac_admin ua on mu.id = ua.id;


DROP TABLE IF EXISTS uac_sp_log;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_sp_log` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
 `sp_log` VARCHAR(150) NOT NULL,
 `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`));

-- INSERT INTO uac_sp_log (sp_log) VALUES ('This is a test');


DROP TABLE IF EXISTS uac_mvoline_attr_log;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_mvoline_attr_log` (
 `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
 `log_agent_id` BIGINT,
 `log_username` CHAR(10),
 `log_mvola_id` BIGINT,
 `log_attribution` CHAR(1),
 `log_case_operation` CHAR(1),
 `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`));

-- If a line does not exists then we run it else we log

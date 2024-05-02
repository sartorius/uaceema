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



/**************************/
/**************************/
/**************************/
/**************************/
/**************************/
/**************************/
/**************************/

-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1827, 'sehrakx010', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Seheno', 'RAKOTONDRASOA', 'timetotestme21@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1828, 'domrakx011', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Domoina', 'RAMANANTSEHENO', 'timetotestme22@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1829, 'jeaandr012', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Jean', 'ANDRIANTSOA', 'timetotestme23@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1830, 'elirast013', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Elisée', 'RASTEFANO', 'timetotestme24@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1831, 'marrobi014', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Marie', 'ROBIVELO', 'timetotestme25@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1832, 'cleandr015', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Clément', 'ANDRIANIERENANA', 'timetotestme26@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1833, 'borrana016', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Boris', 'RANAIVOSOA', 'timetotestme27@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- Teacher
INSERT IGNORE INTO `mdl_user` (`id`, `username`, `last_update`, `create_date`, `firstname`, `lastname`, `email`, `phone1`, `phone_mvola`, `address`, `city`, `matricule`, `autre_prenom`, `genre`, `datedenaissance`, `lieu_de_naissance`, `situation_matrimoniale`, `compte_fb`, `etablissement_origine`, `serie_bac`, `annee_bac`, `numero_cin`, `date_cin`, `lieu_cin`, `nom_pnom_par1`, `email_par1`, `phone_par1`, `profession_par1`, `adresse_par1`, `city_par1`, `nom_pnom_par2`, `phone_par2`, `profession_par2`, `centres_interets`)
VALUES
	(1834, 'herrakx017', '2022-11-26 12:50:11', '2022-11-26 12:50:11', 'Herizo', 'RAKOTONANAHARY', 'timetotestme28@test.com', '0344950074', NULL, 'PRVO 26B', 'Manakambahiny', 'na', NULL, 'X', '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);



/**************************/
/**************************/
/**************************/
/**************************/
/**************************/
/**************************/
/**************************/
/**
lelezardvertdelariziere
lenuageblancdanslecielbleu
lebareanoirdelavictoire
lecameleondetouteslescouleurs
lebleulevertlerougedelaforet
lelivrerosesurlatablejauneenbois
leburgeralaviandeetsaladeverte
lebouclierbleuprotegedeslancesnoires
**/
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1827, '15114b3bbfcb87659c6dea930d3fd662', NULL, 45, 'Chef de mention', 0);
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1828, 'ff848c37a93e14b1fef2119f121ead0d', NULL, 45, 'Chef de mention', 0);
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1829, '529bd8849c850b24f33cafb956ea185a', NULL, 45, 'Chef de mention', 0);
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1830, '71647dabc6b4d8c69c42248affa8f811', NULL, 45, 'Chef de mention', 0);
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1831, 'b221d83cb0575f74a829ca4a4cec8e91', NULL, 45, 'Chef de mention', 0);
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1832, '7271818e12577414f74a1fcc70a61654', NULL, 45, 'Chef de mention', 0);
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1833, '1fe0387dcfff33fdbb0b8346b8b9827c', NULL, 45, 'Chef de mention', 0);
--
INSERT INTO `uac_admin` (`id`, `pwd`, `last_connection`, `scale_right`, `role`, `accounting_write`)
VALUES
	(1834, 'f60316f1d87ada7a9bbb9509b37ae6b5', NULL, 45, 'Chef de mention', 0);

-- DELETE FROM uac_admin WHERE id IN (1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834);
-- UPDATE uac_admin SET scale_right = 45 WHERE id IN (1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834);


-- This is for teacher
DROP TABLE IF EXISTS uac_teacher;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_teacher` (
  `id` BIGINT NOT NULL,
  `mention_code` CHAR(5) NOT NULL,
  `teacher_level` CHAR(1) NOT NULL DEFAULT 'P' COMMENT 'C is for Chef de Mention and P is for Professeur',
  `description` VARCHAR(60) NOT NULL,
  `last_connection` DATETIME NULL,
  PRIMARY KEY (`id`));

INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1827, 'GESTI', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1828, 'ECONO', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1829, 'SIENS', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1830, 'INFOE', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1831, 'DROIT', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1832, 'COMMU', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1833, 'RIDXX', 'C', 'Chef de mention');
INSERT INTO uac_teacher (`id`, `mention_code`, `teacher_level`, `description`)
VALUES (1834, 'MBSXX', 'C', 'Chef de mention');


DROP VIEW IF EXISTS v_showteacher;
CREATE VIEW v_showteacher AS
SELECT mu.id AS mu_id,
		mu.username,
		mu.firstname,
		mu.lastname,
    ut.mention_code,
    ut.teacher_level,
    ut.description,
		ua.*
FROM mdl_user mu JOIN uac_admin ua on mu.id = ua.id
                 JOIN uac_teacher ut on ut.id = ua.id;

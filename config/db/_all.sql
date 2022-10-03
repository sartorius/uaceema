/*********************************************************
**********************************************************
**********************************************************
**********************************************************
*************   Uncomment ADMIN Account  *****************
**********************************************************
**********************************************************
**********************************************************
**********************************************************
*********************************************************/



DROP TABLE IF EXISTS uac_param;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_param` (
  `key_code` CHAR(7) NOT NULL,
  `description` VARCHAR(50) NOT NULL,
  `par_int` INT NULL,
  `par_code` VARCHAR(50) NULL,
  `par_date` DATE NULL,
  `par_value` VARCHAR(500) NULL,
  `par_time` TIME NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`key_code`));


INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('SYURLIA', 'URL Intranet', 'https://intranet.uaceem.com', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('SYURLIE', 'URL Internet', 'https://www.uaceem.com', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('SCANXXX', 'Flow retard', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MLWELCO', 'Mail Welcome qui envoie details', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSIDUI', 'Compute assiduite agains scan edt', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSLATE', 'Late maximum consideration', ':10:00', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIT', 'Attente script avant compute', ':20:00', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('SCANPRG', 'Flow purge scan', 5, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILLI', 'Limit of email per day', 90, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILCT', 'Compteur limit of email per day', 0, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILBA', 'Batch email per day', 9, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTLOAD', 'Integration des EDT', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTPRGL', 'Flow purge edt load', 5, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTPRGC', 'Flow purge edt core', 70, NULL);


DROP TABLE IF EXISTS uac_working_flow;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_working_flow` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_code` CHAR(7) NOT NULL,
  `status` CHAR(3) NOT NULL,
  `working_date` DATE NULL,
  `working_part` TINYINT NOT NULL DEFAULT 0,
  `filename` VARCHAR(300) NULL,
  `comment` VARCHAR(500) NULL,
  `last_update` DATETIME NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

  -- INSERT INTO (flow_code, status) VALUES ('SCANXXX', 'NEW');

-- Cohort System

DROP TABLE IF EXISTS uac_ref_mention;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_mention` (
  `par_code` CHAR(5) NOT NULL,
  `title` VARCHAR(50) NULL,
  `description` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`par_code`));

INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('COMMU', 'COMMUNICATION', 'COMMUNICATION');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('DROIT', 'DROIT', 'DROIT');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('ECONO', 'ECONOMIE', 'ECONOMIE');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('GESTI', 'GESTION', 'GESTION');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('INFOE', 'INFORMATIQUE ELECTRONIQUE', 'INFORMATIQUE ELECTRONIQUE');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('MBSXX', 'MBS', 'MALAGASY BUSINESS SCHOOL');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('RIDXX', 'RELATIONS INTERNATIONALES DIPLOMATIQUES', 'RELATIONS INTERNATIONALES DIPLOMATIQUES');
INSERT IGNORE INTO uac_ref_mention (par_code, title, description) VALUES ('SIENS', 'SCIENCES DE LA SANTE', 'SCIENCE DE LA SANTE');

DROP TABLE IF EXISTS uac_ref_niveau;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_niveau` (
  `par_code` CHAR(2) NOT NULL,
  `title` VARCHAR(50) NULL,
  PRIMARY KEY (`par_code`));

INSERT IGNORE INTO uac_ref_niveau (par_code, title) VALUES ('L1', 'Licence 1');
INSERT IGNORE INTO uac_ref_niveau (par_code, title) VALUES ('L2', 'Licence 2');
INSERT IGNORE INTO uac_ref_niveau (par_code, title) VALUES ('L3', 'Licence 3');
INSERT IGNORE INTO uac_ref_niveau (par_code, title) VALUES ('M1', 'Master 1');
INSERT IGNORE INTO uac_ref_niveau (par_code, title) VALUES ('M2', 'Master 2');

DROP TABLE IF EXISTS uac_ref_parcours;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_parcours` (
  `id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `description` VARCHAR(100) NULL,
  PRIMARY KEY (`id`));

INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (1, 'na');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (2, 'CEP');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (3, 'CMJ');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (4, 'Communication Multisectorielle');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (5, 'D1');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (6, 'D2');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (7, 'D3');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (8, 'D4');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (9, 'PRIVE');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (10, 'PUBLIC');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (11, 'G1');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (12, 'G2');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (13, 'G3');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (14, 'ACI');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (15, 'MCI');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (16, 'MMCI');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (17, 'FACG');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (18, 'INFORMATIQUE');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (19, 'ELECTRONIQUE');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (20, 'OPTICIEN');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (21, 'AGSS');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (22, 'IMAGERIE');
INSERT IGNORE INTO uac_ref_parcours (id, title) VALUES (23, 'TECH BIO');

DROP TABLE IF EXISTS uac_ref_groupe;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_groupe` (
  `id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(50) NULL,
  PRIMARY KEY (`id`));

INSERT IGNORE INTO uac_ref_groupe (id, title) VALUES (1, 'na');
INSERT IGNORE INTO uac_ref_groupe (id, title) VALUES (2, 'Groupe 1');
INSERT IGNORE INTO uac_ref_groupe (id, title) VALUES (3, 'Groupe 2');

CREATE TABLE IF NOT EXISTS `ACEA`.`uac_cohort` (
  `id` INT UNSIGNED NOT NULL,
  `mention` CHAR(5) NOT NULL,
  `niveau` CHAR(2) NOT NULL,
  `parcours_id` INT NOT NULL,
  `groupe_id` INT NOT NULL,
  PRIMARY KEY (`id`));



  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (1, (SELECT par_code FROM uac_ref_mention WHERE title = 'COMMUNICATION'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (2, (SELECT par_code FROM uac_ref_mention WHERE title = 'COMMUNICATION'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (3, (SELECT par_code FROM uac_ref_mention WHERE title = 'COMMUNICATION'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'CEP'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (4, (SELECT par_code FROM uac_ref_mention WHERE title = 'COMMUNICATION'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'CMJ'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (5, (SELECT par_code FROM uac_ref_mention WHERE title = 'COMMUNICATION'), 'M1', (SELECT id FROM uac_ref_parcours WHERE title = 'Communication Multisectorielle'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (6, (SELECT par_code FROM uac_ref_mention WHERE title = 'COMMUNICATION'), 'M2', (SELECT id FROM uac_ref_parcours WHERE title = 'Communication Multisectorielle'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (7, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D1'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (8, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D2'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (9, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D3'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (10, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D4'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (11, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'D1'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (12, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'D2'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (13, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'PRIVE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (14, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'PUBLIC'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (15, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'M1', (SELECT id FROM uac_ref_parcours WHERE title = 'PRIVE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (16, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'M1', (SELECT id FROM uac_ref_parcours WHERE title = 'PUBLIC'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (17, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'M2', (SELECT id FROM uac_ref_parcours WHERE title = 'PRIVE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (18, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'M2', (SELECT id FROM uac_ref_parcours WHERE title = 'PUBLIC'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (19, (SELECT par_code FROM uac_ref_mention WHERE title = 'ECONOMIE'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (20, (SELECT par_code FROM uac_ref_mention WHERE title = 'ECONOMIE'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (21, (SELECT par_code FROM uac_ref_mention WHERE title = 'ECONOMIE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (22, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'G1'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (23, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'G2'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (24, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'G3'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (25, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'G1'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (26, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'G2'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (27, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'ACI'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (28, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'MCI'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (29, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'M1', (SELECT id FROM uac_ref_parcours WHERE title = 'MMCI'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (30, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'M1', (SELECT id FROM uac_ref_parcours WHERE title = 'FACG'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (31, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'M2', (SELECT id FROM uac_ref_parcours WHERE title = 'MMCI'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (32, (SELECT par_code FROM uac_ref_mention WHERE title = 'GESTION'), 'M2', (SELECT id FROM uac_ref_parcours WHERE title = 'FACG'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (33, (SELECT par_code FROM uac_ref_mention WHERE title = 'INFORMATIQUE ELECTRONIQUE'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (34, (SELECT par_code FROM uac_ref_mention WHERE title = 'INFORMATIQUE ELECTRONIQUE'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (35, (SELECT par_code FROM uac_ref_mention WHERE title = 'INFORMATIQUE ELECTRONIQUE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'INFORMATIQUE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (36, (SELECT par_code FROM uac_ref_mention WHERE title = 'INFORMATIQUE ELECTRONIQUE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'ELECTRONIQUE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (37, (SELECT par_code FROM uac_ref_mention WHERE title = 'MBS'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (38, (SELECT par_code FROM uac_ref_mention WHERE title = 'RELATIONS INTERNATIONALES DIPLOMATIQUES'), 'M1', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (39, (SELECT par_code FROM uac_ref_mention WHERE title = 'RELATIONS INTERNATIONALES DIPLOMATIQUES'), 'M2', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (40, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'na'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (41, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'OPTICIEN'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (42, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'AGSS'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (43, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'IMAGERIE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (44, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'TECH BIO'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (45, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'OPTICIEN'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (46, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'AGSS'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (47, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'IMAGERIE'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (48, (SELECT par_code FROM uac_ref_mention WHERE title = 'SCIENCES DE LA SANTE'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'TECH BIO'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));


/*************
SELECTION COHORT !

select * from uac_cohort uc
				JOIN uac_ref_mention urm ON urm.par_code = uc.mention
					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id;

*******/


DROP VIEW IF EXISTS v_class_cohort;
CREATE VIEW v_class_cohort AS
SELECT 	uc.id AS id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe FROM uac_cohort uc
              				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
              					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
              					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
              					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id;
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

INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'benrand123'), 'e716e0cf70d3c6dbd840945d890f074d', 'Recteur', NULL, 7);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'harrako912'), '78e740abec0d61e6dd52452e6d9c2a32', 'SG', NULL, 7);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'lalrako381'), '9248153d95104975573f18e2852d6647', 'DAF', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'ionrako617'), '3182a20c71d20d919cb1f3b3035d5924', 'CGE', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'tokrako283'), '3182a20c71d20d919cb1f3b3035d5924', 'TST', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'tsirako227'), '3182a20c71d20d919cb1f3b3035d5924', 'TST', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mikrama654'), 'c24d593b9266e7b8d0887d0dc7259705', 'Agent', NULL);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mborako321'), 'd064a894fb8645879312b10d366cd604', 'Agent', NULL);



-- SHOW USERS

DROP TABLE IF EXISTS uac_showuser;
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
DROP TABLE IF EXISTS uac_load_scan;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_scan` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `scan_username` VARCHAR(50) NOT NULL,
  `scan_date` DATE NOT NULL,
  `scan_time` TIME NOT NULL,
  `status` CHAR(3) NOT NULL,
  `in_out` CHAR(1) NOT NULL,
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
  `in_out` CHAR(1) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_assiduite;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_assiduite` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `edt_id` BIGINT NOT NULL,
  `scan_id` BIGINT NULL,
  `status` CHAR(3) NOT NULL,
  `valid_exec_uid` BIGINT NULL,
  `valid_cmt` VARCHAR(500) NULL,
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

-- Not compatible with the output of Workbench
DROP TABLE IF EXISTS uac_load_edt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_edt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `status` CHAR(3) NOT NULL,
  `flow_id` BIGINT NULL,
  `filename` VARCHAR(300) NOT NULL,
  `mention` VARCHAR(100) NOT NULL,
  `niveau` CHAR(2) NOT NULL,
  `uaparcours` VARCHAR(100) NULL,
  `uagroupe` VARCHAR(100) NULL,
  `monday_ofthew` DATE NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `raw_duration` VARCHAR(10) NULL,
  `duration_hour` TINYINT NULL,
  `log_pos` VARCHAR(10) NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- INSERT INTO uac_load_edt (user_id, status, filename, mention, niveau, monday_ofthew, label_day, day, hour_starts_at, duration, log_pos, raw_course_title, create_date) VALUES (user_id, 'NEW', );

-- compute_late_status Can be NEW, END or CAN if it is CAN then the day has been trouble by internet
-- Visibility is I or V to validate
DROP TABLE IF EXISTS uac_edt_master;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_master` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `cohort_id` BIGINT UNSIGNED NULL,
  `visibility` CHAR(1) NOT NULL DEFAULT 'I',
  `monday_ofthew` DATE NOT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));



DROP TABLE IF EXISTS uac_edt;
DROP TABLE IF EXISTS uac_edt_line;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_line` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `master_id` BIGINT UNSIGNED NULL,
  `compute_late_status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `duration_hour` TINYINT NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));
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
-- Control to save !
  SELECT mu.id, mu.username, uas.secret, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, mr.shortname, mu.firstname, mu.lastname, mu.email, mu.phone1, mu.phone2
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
           JOIN mdl_role mr ON mr.id = uas.roleid;


 DELIMITER $$
 DROP PROCEDURE IF EXISTS SRV_UPD_UACShower$$
 CREATE PROCEDURE `SRV_UPD_UACShower` ()
 BEGIN
     -- CALL SRV_UPD_UACShower();
     -- Make sure this in the cron every minute !!!
     -- Insert
       INSERT IGNORE INTO uac_showuser (roleid, username)
       SELECT MAX(roleid), username FROM mdl_role_assignments mra
                                     JOIN mdl_role mr ON mr.id = mra.roleid
                                     JOIN mdl_user mu ON mu.id = mra.userid
       GROUP BY username;
     -- Add secret
       UPDATE uac_showuser SET secret = 3000000000 + FLOOR(RAND()*1000000000), last_update = NOW() WHERE secret IS NULL;

 END$$
 -- Remove $$ for OVH
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_MNG_Scan$$
CREATE PROCEDURE `SRV_MNG_Scan` (IN param DATE)
BEGIN
    DECLARE inv_date	DATE;
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_MNG_Scan(NULL);




    -- If the parameter is null, we consider the day of today !
    IF param IS NULL THEN
      -- statements ;
      -- SELECT 'empty parameters';
      SELECT current_date INTO inv_date;

   ELSE
      -- statements ;
      -- SELECT 'NOT EMPTY parameters';
      SELECT param INTO inv_date;

   END IF;

   INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES ('SCANXXX', 'NEW', inv_date, 0, NOW());
   SELECT LAST_INSERT_ID() INTO inv_flow_id;

   -- Do the treatment here
   -- We must map the data here

   INSERT INTO uac_scan (user_id, in_out, agent_id, scan_date, scan_time, status)
      SELECT mu.id, uls.in_out, uls.user_id, uls.scan_date, MIN(uls.scan_time), 'NEW'
      FROM uac_load_scan uls JOIN mdl_user mu on UPPER(mu.username) = UPPER(uls.scan_username)
      WHERE uls.scan_date = inv_date
      AND uls.status = 'NEW'
      GROUP BY mu.id, uls.in_out, uls.user_id, uls.scan_date;

   -- Set the load lines has read
   UPDATE uac_load_scan
   SET status = 'END'
   WHERE scan_date = inv_date AND status = 'NEW'
   AND EXISTS (SELECT 1 FROM mdl_user
                WHERE UPPER(uac_load_scan.scan_username) = UPPER(mdl_user.username));

   -- We set here when it is not found
   UPDATE uac_load_scan
    SET status = 'MIS'
    WHERE scan_date = inv_date AND status = 'NEW';

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END' WHERE id = inv_flow_id;

   SELECT CONCAT('SRV_MNG_Scan - END OK: ', NOW());

END$$
-- Remove $$ for OVH



DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_PRG_Scan$$
CREATE PROCEDURE `SRV_PRG_Scan` ()
BEGIN
    DECLARE prg_date	DATE;
    DECLARE prg_history_delta	INT;
    -- CALL SRV_PRG_Scan();

    SELECT par_int INTO prg_history_delta FROM uac_param WHERE key_code = 'SCANPRG';
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -prg_history_delta DAY) INTO prg_date;

    DELETE FROM uac_load_scan WHERE scan_date < prg_date;
    DELETE FROM uac_working_flow WHERE flow_code = 'SCANXXX' AND create_date < prg_date;

END$$
-- Remove $$ for OVH
-- This push account without email to be sent
-- These account will be prepared to be sent in uac_mail
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_MailWelcomeNewUser$$
CREATE PROCEDURE `SRV_CRT_MailWelcomeNewUser` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    DECLARE count_mail	INTEGER;
    -- CALL SRV_PRG_Scan();

    SELECT 'MLWELCO' INTO flow_code;

    -- SHALL WE RUN this process ?
    SELECT COUNT(1) INTO count_mail FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
    WHERE NOT EXISTS (SELECT 1 FROM uac_mail
                    WHERE (flow_code, user_id) = (flow_code, id));


    -- We do not find any email here
    IF (count_mail > 0) THEN

        -- We run the full process
        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        -- We need to insert missing new user without any email

        INSERT IGNORE INTO uac_mail (flow_id, flow_code, user_id, status)
          SELECT inv_flow_id, flow_code, mu.id, 'NEW' FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username;




        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('Mail created: ', count_mail) WHERE id = inv_flow_id;


     END IF;

END$$
-- Remove $$ for OVH


-- This is getting the list of email according to the limit
-- This is handling the daily limit of email to be sent
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_GRP_WelcomeEMail$$
CREATE PROCEDURE `SRV_GRP_WelcomeEMail` ()
BEGIN
    DECLARE grp_flow_code	CHAR(7);
    DECLARE inv_flow_code	CHAR(7);
    DECLARE url_intranet	VARCHAR(500);
    DECLARE url_internet	VARCHAR(500);
    DECLARE batch_count INTEGER;
    DECLARE inv_flow_id	BIGINT;


    DECLARE daily_count INTEGER;
    DECLARE current_count INTEGER;
    -- CALL SRV_PRG_Scan();

    SELECT par_int INTO daily_count FROM uac_param WHERE key_code = 'DMAILLI';
    SELECT par_int INTO current_count FROM uac_param WHERE key_code = 'DMAILCT';

    IF (daily_count > current_count) THEN

              SELECT 'GRPMLWC' INTO grp_flow_code;

              SELECT 'MLWELCO' INTO inv_flow_code;
              SELECT par_int INTO batch_count FROM uac_param WHERE key_code = 'DMAILBA';
              SELECT par_value INTO url_intranet FROM uac_param WHERE key_code = 'SYURLIA';
              SELECT par_value INTO url_internet FROM uac_param WHERE key_code = 'SYURLIE';



              INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (grp_flow_code, 'NEW', CURRENT_DATE, 0, NOW());
              SELECT LAST_INSERT_ID() INTO inv_flow_id;

              UPDATE uac_mail SET status = 'INP'
              WHERE id IN (
                  SELECT id FROM (
                      SELECT id FROM uac_mail WHERE status = 'NEW' and flow_code = inv_flow_code
                      ORDER BY id ASC
                      LIMIT 0, batch_count
                  ) tmp
              );

              -- Update the counter to not overload day limit
              SELECT COUNT(1) INTO batch_count FROM uac_mail WHERE status = 'INP' and flow_code = inv_flow_code;
              UPDATE uac_param SET par_int = par_int + batch_count WHERE key_code = 'DMAILCT';

              -- Download the list

              SELECT
                    mu.username AS USERNAME,
                    mu.email AS EMAIL,
                    muid2.data AS MATRICULE,
                    muid1.data AS PARENT_EMAIL,
                    mu.firstname AS FIRSTNAME,
                    mu.lastname AS LASTNAME,
                    url_intranet AS ULR_INTRANET,
                    CONCAT(url_internet, '/profile/',CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE_URL
              FROM uac_mail um JOIN mdl_user mu ON mu.id = um.user_id
                                JOIN mdl_user_info_data muid1 ON muid1.userid = mu.id
                                JOIN mdl_user_info_field muif1 ON muif1.id = muid1.fieldid
                                                        AND muif1.shortname = 'email_par1'
                                JOIN mdl_user_info_data muid2 ON muid2.userid = mu.id
                                JOIN mdl_user_info_field muif2 ON muif2.id = muid2.fieldid
                                                        AND muif2.shortname = 'matricule'
                                JOIN uac_showuser uas ON mu.username = uas.username
                                JOIN mdl_role mr ON mr.id = uas.roleid
                                LEFT JOIN mdl_files mf ON mu.picture = mf.id
              WHERE um.status = 'INP' and um.flow_code = inv_flow_code;

              -- End of the flow correctly
              UPDATE uac_mail SET status = 'END' WHERE status = 'INP' and flow_code = inv_flow_code;
              UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

    END IF;


END$$
-- Remove $$ for OVH
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_EDT$$
CREATE PROCEDURE `SRV_CRT_EDT` (IN param_filename VARCHAR(300), IN param_monday_date DATE, IN param_mention VARCHAR(100), IN param_niveau CHAR(2), IN param_uaparcours VARCHAR(100), IN param_uagroupe VARCHAR(100))
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;

    DECLARE inv_master_id	BIGINT;
    DECLARE inv_old_master_id	BIGINT;

    DECLARE exist_cohort_id	TINYINT;
    DECLARE inv_cohort_id	INTEGER;
    -- CALL SRV_PRG_Scan();
    -- EDTLOAD

    SELECT 'EDTLOAD' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, param_filename, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    UPDATE uac_load_edt SET flow_id = inv_flow_id, status = 'INP' WHERE filename = param_filename AND status = 'NEW';

    SELECT COUNT(1) INTO exist_cohort_id FROM uac_cohort uc
            				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
            					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
            					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
            					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                      WHERE urm.title = param_mention
                      AND uc.niveau = param_niveau
                      AND urp.title = param_uaparcours
                      AND urg.title = param_uaparcours;

    IF (exist_cohort_id = 0) THEN
      -- We have found no cohort so the file is probably corrupt
      UPDATE uac_load_edt SET status = 'ERR' WHERE flow_id = inv_flow_id;
      UPDATE uac_working_flow SET status = 'ERR', comment = 'Cohort not found', last_update = NOW() WHERE id = inv_flow_id;

      -- Return empty
      -- Return the list for control
      SELECT
        0 AS master_id,
        NULL AS mention,
        NULL AS niveau,
        NULL AS parcours,
        NULL AS groupe,
        DATE_FORMAT(param_monday_date, "%d/%m/%Y") AS mondayw,
        NULL AS nday,
        0 AS day_code,
        0 AS hour_starts_at,
        0 AS duration_hour,
        NULL AS raw_course_title;

    ELSE
      -- A cohort id exist !
      SELECT uc.id INTO inv_cohort_id FROM uac_cohort uc
              				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
              					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
              					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
              					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                        WHERE urm.title = param_mention
                        AND uc.niveau = param_niveau
                        AND urp.title = param_uaparcours
                        AND urg.title = param_uaparcours;


      -- Delete old lines
      -- Delete old lines to keep only one for this cohort
      SELECT id INTO inv_old_master_id
              FROM uac_edt_master
              WHERE monday_ofthew = param_monday_date
              AND cohort_id = inv_cohort_id;
      DELETE FROM uac_edt_line WHERE master_id = inv_old_master_id;
      DELETE FROM uac_edt_master WHERE id = inv_old_master_id;

      -- Proceed to new lines !

      INSERT INTO uac_edt_master (flow_id, cohort_id, monday_ofthew) VALUES (inv_flow_id, inv_cohort_id, param_monday_date);
      SELECT LAST_INSERT_ID() INTO inv_master_id;

      INSERT INTO uac_edt_line (master_id, label_day, day, day_code, hour_starts_at, duration_hour, raw_course_title)
            SELECT inv_master_id, label_day, day, day_code, hour_starts_at, duration_hour, raw_course_title
            FROM uac_load_edt
            WHERE status = 'INP'
            AND flow_id = inv_flow_id;
      UPDATE uac_load_edt SET status = 'END' WHERE flow_id = inv_flow_id AND status = 'INP';


      -- End of the flow correctly
      UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

      -- Return the list for control
      SELECT
        uem.id AS master_id,
        urm.title AS mention,
        uc.niveau AS niveau,
        urp.title AS parcours,
        urg.title AS groupe,
        DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
        DATE_FORMAT(uel.day, "%d/%m") AS nday,
        uel.day_code AS day_code,
        uel.hour_starts_at AS hour_starts_at,
        uel.duration_hour AS duration_hour,
        uel.raw_course_title AS raw_course_title
      FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                            JOIN uac_cohort uc ON uc.id = uem.cohort_id
                  				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                  					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                  					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                  					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
      WHERE uem.id = inv_master_id
      ORDER BY uel.hour_starts_at, uel.day_code ASC;


    END IF;



END$$
-- Remove $$ for OVH

-- Read the EDT for a specific username
-- param_bkp is to read the EDT per line if the display does not work
-- Display EDT for specific username
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_FWEDT$$
CREATE PROCEDURE `CLI_GET_FWEDT` (IN param_username VARCHAR(25), IN param_week TINYINT, IN param_bkp CHAR(1))
BEGIN
    DECLARE inv_cur_date	DATE;
    DECLARE inv_monday_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;
    DECLARE count_result_set	INT;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL (7 * param_week) DAY) INTO inv_cur_date;
    -- inv_cur_dayw will be 7 or 1 for week end
    -- Check the week involved
    SELECT DAYOFWEEK(inv_cur_date) INTO inv_cur_dayw;

    -- If WE, we take next Monday
    IF inv_cur_dayw IN (7) THEN
        SELECT DATE_ADD(inv_cur_date, INTERVAL 2 DAY) INTO inv_monday_date;
    ELSEIF inv_cur_dayw IN (1) THEN
        SELECT DATE_ADD(inv_cur_date, INTERVAL 1 DAY) INTO inv_monday_date;
    ELSE
        SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO inv_monday_date;
    END IF;


    SELECT COUNT(1) INTO count_result_set
        FROM uac_edt_master uem JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                AND uas.username = param_username
        WHERE monday_ofthew = inv_monday_date
        AND visibility = 'V';

    IF (count_result_set = 0) THEN
          SELECT
              NULL AS flow_id,
              NULL AS mention,
              NULL AS niveau,
              NULL AS parcours,
              NULL AS groupe,
              NULL AS label_day_fr,
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS mondayw,
              DATE_FORMAT(inv_cur_date, "%d/%m") AS nday,
              0 AS day_code,
              0 AS hour_starts_at,
              0 AS duration_hour,
              NULL AS raw_course_title;
    ELSE
      -- We have result
          IF (param_bkp = 'N') THEN
                -- Return the list for control
                SELECT
                  uem.id AS master_id,
                  urm.title AS mention,
                  uc.niveau AS niveau,
                  urp.title AS parcours,
                  urg.title AS groupe,
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                  DATE_FORMAT(uel.day, "%d/%m") AS nday,
                  uel.day_code AS day_code,
                  uel.hour_starts_at AS hour_starts_at,
                  uel.duration_hour AS duration_hour,
                  uel.raw_course_title AS raw_course_title
                FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                      JOIN uac_cohort uc ON uc.id = uem.cohort_id
                            				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                WHERE uem.monday_ofthew = inv_monday_date
                AND uem.visibility = 'V'
                ORDER BY uel.hour_starts_at, uel.day_code ASC;

         ELSE
                 -- Return the list for control
                 SELECT
                   uem.id AS master_id,
                   urm.title AS mention,
                   uc.niveau AS niveau,
                   urp.title AS parcours,
                   urg.title AS groupe,
                   CASE
                      WHEN uel.day_code = 1 THEN "LUNDI"
                      WHEN uel.day_code = 2 THEN "MARDI"
                      WHEN uel.day_code = 3 THEN "MERCREDI"
                      WHEN uel.day_code = 4 THEN "JEUDI"
                      WHEN uel.day_code = 5 THEN "VENDREDI"
                      ELSE "SAMEDI"
                      END AS label_day_fr,
                   DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                   DATE_FORMAT(uel.day, "%d/%m") AS nday,
                   uel.day_code AS day_code,
                   uel.hour_starts_at AS hour_starts_at,
                   uel.duration_hour AS duration_hour,
                   uel.raw_course_title AS raw_course_title
                 FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                       JOIN uac_cohort uc ON uc.id = uem.cohort_id
                             				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                             					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                             					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                             					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                 WHERE uem.monday_ofthew = inv_monday_date
                 AND uem.visibility = 'V'
                 ORDER BY uel.hour_starts_at, uel.day_code ASC;


         END IF;
    END IF;
END$$
-- Remove $$ for OVH



DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_MngEDTp3$$
CREATE PROCEDURE `CLI_GET_MngEDTp3` ()
BEGIN
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;
    DECLARE monday_two	DATE;
    DECLARE monday_three	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_monday_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;
    DECLARE count_result_set	INT;


    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_two;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_three;

    SELECT * FROM (SELECT 'S0' AS s, 0 AS inv_w, DATE_FORMAT(monday_zero, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S0', DATE_FORMAT(monday_zero, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_zero ORDER BY cohort_id ASC) as a
    UNION ALL
    SELECT * FROM (SELECT 'S1' AS s, 1 AS inv_w, DATE_FORMAT(monday_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S1', DATE_FORMAT(monday_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_one ORDER BY cohort_id ASC) as b
    UNION ALL
    SELECT * FROM (SELECT	'S2' AS s, 2 AS inv_w, DATE_FORMAT(monday_two, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S2', DATE_FORMAT(monday_two, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_two ORDER BY cohort_id ASC) as c
    UNION ALL
    SELECT * FROM (SELECT 'S3' AS s, 3 AS inv_w, DATE_FORMAT(monday_three, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                        UPPER(CONCAT('S3', DATE_FORMAT(monday_three, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                        FROM uac_cohort uc
                        JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                        JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                        JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                        JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                      AND uem.visibility = 'V'
                                                      AND uem.monday_ofthew = monday_three ORDER BY cohort_id ASC) as d;

END$$
-- Remove $$ for OVH

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_SHOWEDTForADM$$
CREATE PROCEDURE `CLI_GET_SHOWEDTForADM` (IN param_master_id VARCHAR(25))
BEGIN

    SELECT
      uem.id AS master_id,
      urm.title AS mention,
      uc.niveau AS niveau,
      urp.title AS parcours,
      urg.title AS groupe,
      DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
      DATE_FORMAT(uel.day, "%d/%m") AS nday,
      uel.day_code AS day_code,
      uel.hour_starts_at AS hour_starts_at,
      uel.duration_hour AS duration_hour,
      uel.raw_course_title AS raw_course_title
    FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                          JOIN uac_cohort uc ON uc.id = uem.cohort_id
                          JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                          JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                          JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                          JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
    WHERE uem.id = param_master_id
    AND uem.visibility = 'V'
    ORDER BY uel.hour_starts_at, uel.day_code ASC;

END$$
-- Remove $$ for OVH
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_ComptAssdFlow$$
CREATE PROCEDURE `SRV_CRT_ComptAssdFlow` (IN param DATE)
BEGIN
    -- CALL SRV_CRT_ComptAssdFlow(NULL);
    DECLARE inv_date	DATE;
    -- On current day, we work on courses finished from 1h of current time
    DECLARE inv_time	TIME;

    DECLARE inv_flow_code	CHAR(7);
    DECLARE concurrent_flow INT;
    DECLARE inv_flow_id	BIGINT;
    DECLARE late_definition	VARCHAR(50);
    DECLARE wait_b_compute	VARCHAR(50);

    DECLARE inv_edt_id	BIGINT;
    DECLARE inv_edt_starts	TINYINT;
    DECLARE count_courses_todo INT;
    DECLARE inv_cohort_id	BIGINT;

    DECLARE i INT default 0;
    SET i = 0;



    SELECT 'ASSIDUI' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
      -- A flow is running we input a CAN line
      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'CAN', CURRENT_DATE, 0, NOW());
    ELSE
      -- Previous RUN has finished
      -- We can work !

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        SELECT par_value INTO late_definition FROM uac_param WHERE key_code = 'ASSLATE';
        SELECT par_value INTO wait_b_compute FROM uac_param WHERE key_code = 'ASSWAIT';


        -- If the parameter is null, we consider the day of today !
        IF param IS NULL THEN
            -- statements ;
            -- SELECT 'empty parameters';
            SELECT CURRENT_DATE INTO inv_date;
            select CURRENT_TIME INTO inv_time;

       ELSE
            -- statements ;
            -- We will work for the full day
            SELECT param INTO inv_date;
            SELECT CONVERT('23:59:59', TIME) INTO inv_time;

       END IF;
       -- Manage Date NULL

        -- BODY START
        -- We need to loop all courses of the day
        SELECT COUNT(1) INTO count_courses_todo
          FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.duration_hour > 0
          AND CONVERT(
                CONCAT(
                  CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                    THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                    -- wait_b_compute ':20:00'
                    wait_b_compute), TIME) < inv_time;

        -- ********************************************
        -- ********************************************
        -- ****************** START *******************
        -- ********************************************
        -- ********************************************
        WHILE i < count_courses_todo DO

          -- INITIALIZATION
          SELECT MAX(id) INTO inv_edt_id
              FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.duration_hour > 0
              AND CONVERT(
                    CONCAT(
                      CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                        THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                        -- wait_b_compute ':20:00'
                        wait_b_compute), TIME) < inv_time;

          -- We need to consider only involved cohort_id
          SELECT cohort_id INTO inv_cohort_id FROM uac_edt_master WHERE id IN (SELECT master_id FROM uac_edt_line WHERE ID = inv_edt_id);

          -- Initialize the hour start at
          SELECT hour_starts_at INTO inv_edt_starts FROM uac_edt_line WHERE id = inv_edt_id;
          -- Je suis sensé bosser sur les cohorts id !!!


          -- ABS part 1 *** *** *** *** *** *** *** ***
          -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student missing or late over 10min !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, NULL, 'ABS' FROM mdl_user mu
          		 JOIN uac_showuser uas ON mu.username = uas.username
                                     AND uas.cohort_id = inv_cohort_id
          WHERE mu.username NOT IN (
          		SELECT t_student_in.username
          		FROM(
          					-- List of people who entered but not exit before 7:00
          					select mu.username, max(usa.scan_time) AS scan_in from uac_scan usa
          					join mdl_user mu on usa.user_id = mu.id
                    -- late_definition is like ':10:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username
          					) t_student_in
          		);

          -- ABS part 2 *** *** *** *** *** *** *** ***
          -- On met ceux qui sont sortis juste avant le +10
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student missing or late over 10min !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, NULL, 'ABS' FROM mdl_user mu
          		 JOIN uac_showuser uas ON mu.username = uas.username
                                     AND uas.cohort_id = inv_cohort_id
          WHERE mu.username IN (
          		SELECT t_student_in.username
          		FROM(
          					-- List of people who entered but not exit before 7:00
          					SELECT mu.username, usa.user_id, usa.scan_date, max(usa.scan_time) AS scan_in FROM uac_scan usa
          					join mdl_user mu on usa.user_id = mu.id
                    -- late_definition is like ':10:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username, usa.user_id, usa.scan_date
          					) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
												AND sca.user_id = t_student_in.user_id
												AND sca.scan_date = t_student_in.scan_date
                        -- La personne est sortie avant le cours
												AND sca.in_out = 'O'
          		);

          -- LAT *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student late 10min max !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'LAT' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'I';

          -- PON *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Student on time
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'PON' FROM (
          -- List of people who entered but not exit before 7:00
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'I';

          UPDATE uac_edt_line SET compute_late_status = 'END', last_update = NOW() WHERE id = inv_edt_id;
          SET i = i + 1;
        END WHILE;

        -- ********************************************
        -- ********************************************
        -- ****************** SEND ********************
        -- ********************************************
        -- ********************************************

        -- BODY END
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('EDT updated: ', count_courses_todo) WHERE id = inv_flow_id;

    END IF;
END$$
-- Remove $$ for OVH

-- From Connection SP
-- Launch the UACShower
CALL SRV_UPD_UACShower();

-- ONLY FOR Test
/*
UPDATE uac_showuser uas SET uas.cohort_id = ((SELECT id FROM mdl_user mu WHERE mu.username = uas.username) % 48) + 1 WHERE uas.cohort_id IS NULL;
select MAX(cohort_id) from uac_showuser;
select MIN(cohort_id) from uac_showuser;
*/

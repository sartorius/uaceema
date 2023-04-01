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
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('RESASSI', 'Reset Assiduite for the day', NULL, NULL);


INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MANLODU', 'Manual load MDL user', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MANMDLU', 'Manual creation MDL user', NULL, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSLATE', 'Late maximum consideration', ':15:00', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIT', 'Attente script avant compute', ':25:00', NULL, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('SCANPRG', 'Flow purge scan', 5, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSIPRG', 'Flow purge assiduite', 10, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GENEPRG', 'Flow purge generic', 10, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILLI', 'Limit of max email per day', 50, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILCT', 'Counter limit of email per day', 0, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILBA', 'Batch email per day', 10, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTLOAD', 'Integration des EDT', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTPRGL', 'Flow purge edt load', 5, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTPRGC', 'Flow purge edt core', 70, NULL);



INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('QUEASSI', 'Queue Assiduite', NULL, NULL);

-- Payment
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('PAYDSHV', 'Frais de scolarite visible 1 oui 0 non', 0, NULL);




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
  -- This to be changed in april 2022-23
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (10, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D4'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2'));
  -- This to be changed in april 2022-23
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (11, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'D1'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));
  -- This to be changed in april 2022-23
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



  DELETE FROM uac_cohort WHERE id = 10;
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (10, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L2', (SELECT id FROM uac_ref_parcours WHERE title = 'D3'), (SELECT id FROM uac_ref_groupe WHERE title = 'na'));

  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 11;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2') WHERE id = 12;

  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 22;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 23;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2') WHERE id = 24;


  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 25;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2') WHERE id = 26;

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
SELECT 	uc.id AS id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, CONCAT(uc.niveau, '/', SUBSTRING(urm.title, 1, 5), '/', SUBSTRING(urp.title, 1, 5), '/', SUBSTRING(urg.title, 1, 10)) AS short_classe
                        FROM uac_cohort uc
              				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
              					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
              					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
              					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id;

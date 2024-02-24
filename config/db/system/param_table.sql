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



INSERT IGNORE INTO uac_param (key_code, description, par_value) VALUES ('MSGASSI', 'Message to display for dash assiduite', 'Les Absences et Quittés des L2, L3, M1 et M2 ont été remises à zéro pour la rentrée de Jeudi 13 Avril 2023.');

INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('SYURLIA', 'URL Intranet', 'https://intranet.uaceem.com', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('SYURLIE', 'URL Internet', 'https://www.uaceem.com', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('SCANXXX', 'Flow retard', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MLWELCO', 'Mail Welcome qui envoie details', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSIDUI', 'Compute assiduite agains scan edt', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('RESASSI', 'Reset Assiduite for the day', NULL, NULL);


INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MANLODU', 'Manual load MDL user', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MANMDLU', 'Manual creation MDL user', NULL, NULL);

-- both following will be deprecated
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSLATE', 'Late maximum consideration', ':15:00', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIT', 'Attente script avant compute', ':25:00', NULL, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHLAT', 'Half late consideration minute LAT', 15, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHVLA', 'Half Very late consideration minute VLA', 59, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHWAI', 'Half late consideration minute', 25, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIT', 'Attente script avant compute', ':25:00', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIH', 'Attente script avant compute', ':50:00', NULL, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('SCANPRG', 'Flow purge scan', 5, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSIPRG', 'Flow purge assiduite', 10, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GENEPRG', 'Flow purge generic', 10, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILLI', 'Limit of max email per day', 50, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILCT', 'Counter limit of email per day', 0, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILBA', 'Batch email per day', 10, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTLOAD', 'Integration des EDT', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTPRGL', 'Flow purge edt load', 5, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('EDTPRGC', 'Flow purge edt core', 70, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRALOAD', 'Integration des notes', NULL, NULL);



INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('QUEASSI', 'Queue Assiduite', NULL, NULL);

-- Payment
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('PAYDSHV', 'Frais de scolarite module active Y oui N non', NULL, 'Y');
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('PAYPUBL', 'Frais de scolarite dashboard visible Y oui N non', NULL, 'Y');

-- Daily Token for the Payment Date
INSERT IGNORE INTO uac_param (key_code, description) VALUES ('TOKPAYD', 'Token daily for payement TOKDAND Current Date');

-- Daily Token for EDT
INSERT IGNORE INTO uac_param (key_code, description) VALUES ('TOKEDTD', 'Token daily for EDT TOKEDTD Current Date');

-- Daily Token Generic
INSERT IGNORE INTO uac_param (key_code, description) VALUES ('TOKEGEN', 'Token daily generic operation Current Date');

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MVOLOAD', 'Integration Mvola', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MVOLUPD', 'Last update Mvola', NULL, NULL);
-- INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('TELMVOL', 'Mvola phone number', NULL, '346776199');
-- PROD
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('MVOLTEL', 'Mvola phone number', NULL, '344960000');

INSERT IGNORE INTO uac_param (key_code, description, par_int, par_date) VALUES ('TECYEAR', 'Start of Year', NULL, '2023-11-01');


-- Grade
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRAMODV', 'Notes module visible Y oui N non', NULL, 'Y');
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRAPUBL', 'Notes dashboard visible etudiant Y oui N non', NULL, 'Y');
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRASTUL', 'Limite nombre student par page', 32, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRAJPGL', 'Taille limite fichier JPG en ko', 300, NULL);


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
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (13, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'PRIVE'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1'));
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

  -- L3 Groupe 1 & 2
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id) VALUES (49, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L3', (SELECT id FROM uac_ref_parcours WHERE title = 'PRIVE'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2'));

  -- L1 Groupe 2 D4
  INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id)
  VALUES
  (50, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D4'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2'));


  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 11;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 12;

  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 22;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 23;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2') WHERE id = 24;


  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 1') WHERE id = 25;
  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2') WHERE id = 26;

  UPDATE uac_cohort SET groupe_id = (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2') WHERE id = 10;


DROP TABLE IF EXISTS uac_ref_room;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_room` (
  `id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(50) NULL,
  `capacity` INT UNSIGNED NOT NULL,
  `category` VARCHAR(45) NULL,
  `size` CHAR(1) NOT NULL DEFAULT 'S',
  `is_video` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'N is for Not Video and Y is for Video',
  `rm_order` SMALLINT UNSIGNED NOT NULL,
  `available` CHAR(1) NULL DEFAULT 'Y',
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));



  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (0,'Non spécifiée',10000,'NA','L','N',1);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (1,'001',40,'PETITE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (2,'002',40,'PETITE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (3,'101',30,'PETITE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (4,'102',30,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (5,'103',40,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (6,'104',46,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (7,'105',50,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (8,'203',35,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (9,'302',46,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (10,'303',54,'PETITE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (11,'304',54,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (12,'305',58,'PETITE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (13,'306',40,'PETITE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (14,'307',44,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (15,'405',36,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (16,'406',48,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (17,'504',41,'PETITE','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (18,'201-202',100,'GRANDE','L','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (19,'205-206',150,'GRANDE','L','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (20,'502-503',100,'GRANDE','L','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (21,'301',30,'LABO','S','Y',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (22,'401',40,'LABO','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (23,'402',20,'LABO','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (24,'403',40,'LABO','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (25,'101',12,'ANNEXE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (26,'102',24,'ANNEXE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (27,'103',15,'ANNEXE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (28,'201',8,'ANNEXE','S','N',2);
  INSERT INTO uac_ref_room (id,name, capacity, category, size, is_video, rm_order) VALUES (29,'202',42,'ANNEXE','S','N',2);




DROP TABLE IF EXISTS uac_calendar;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_calendar` (
  `id` SMALLINT UNSIGNED NOT NULL,
  `calendar` CHAR(7) NOT NULL,
  `semester` CHAR(1) NOT NULL,
  `display_date` VARCHAR(60) NOT NULL,
  `display_info` VARCHAR(250) NOT NULL,
  `observation` VARCHAR(250) NULL,
  `is_displayed` CHAR(1) NOT NULL DEFAULT 'Y',
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


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
SELECT 	uc.id AS id, urm.title AS mention, urm.par_code AS mention_code, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, CONCAT(uc.niveau, '/', SUBSTRING(urm.title, 1, 5), '/', SUBSTRING(urp.title, 1, 5), '/', SUBSTRING(urg.title, 1, 10)) AS short_classe
                        FROM uac_cohort uc
              				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
              					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
              					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
              					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id;


DROP TABLE IF EXISTS tech_number;
CREATE TABLE IF NOT EXISTS `ACEA`.`tech_number` (
  `id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`));
INSERT IGNORE INTO tech_number (id) VALUES (1);
INSERT IGNORE INTO tech_number (id) VALUES (2);
INSERT IGNORE INTO tech_number (id) VALUES (3);
INSERT IGNORE INTO tech_number (id) VALUES (4);
INSERT IGNORE INTO tech_number (id) VALUES (5);
INSERT IGNORE INTO tech_number (id) VALUES (6);
INSERT IGNORE INTO tech_number (id) VALUES (7);


-- ----------------------------------------------------------------------------------------------------------------------------

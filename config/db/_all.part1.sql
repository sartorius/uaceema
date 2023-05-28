DELIMITER $$
DROP FUNCTION IF EXISTS fEscapeStr$$
CREATE FUNCTION fEscapeStr(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(input, "'", " "), '"', ' '), ',', ' '), ';', '');
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fEscapeLineFeed$$
CREATE FUNCTION fEscapeLineFeed(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN REPLACE(
	    REPLACE(input, '\r', '\\r'),
	    '\n',
	    '\\n'
	);
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fCapitalizeStr$$
CREATE FUNCTION fCapitalizeStr(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN TRIM(CONCAT(UPPER(SUBSTRING(input,1,1)),LOWER(SUBSTRING(input,2))));
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fGetDailyTokenPayment$$
CREATE FUNCTION fGetDailyTokenPayment()
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
	DECLARE param_exists	TINYINT;
	DECLARE token_value	VARCHAR(500);

	SELECT COUNT(1) INTO param_exists FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKPAYD';

	IF param_exists > 0 THEN
			-- We read the existing daily token
			SELECT par_value INTO token_value FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKPAYD';

	 ELSE
			-- statements ;
			-- SELECT 'NOT EMPTY parameters';
			SELECT MD5(CONCAT('TOKPAYD', CURRENT_DATE)) INTO token_value;
			UPDATE uac_param SET par_date = CURRENT_DATE, par_value = token_value WHERE key_code = 'TOKPAYD';

	 END IF;

	RETURN token_value;
END$$


DELIMITER $$
DROP FUNCTION IF EXISTS fGetDailyTokenEDT$$
CREATE FUNCTION fGetDailyTokenEDT()
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
	DECLARE param_exists	TINYINT;
	DECLARE token_value	VARCHAR(500);

	SELECT COUNT(1) INTO param_exists FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKEDTD';

	IF param_exists > 0 THEN
			-- We read the existing daily token
			SELECT par_value INTO token_value FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKEDTD';

	 ELSE
			-- statements ;
			-- SELECT 'NOT EMPTY parameters';
			SELECT MD5(CONCAT('TOKEDTD', CURRENT_DATE)) INTO token_value;
			UPDATE uac_param SET par_date = CURRENT_DATE, par_value = token_value WHERE key_code = 'TOKEDTD';

	 END IF;

	RETURN token_value;
END$$
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



INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('QUEASSI', 'Queue Assiduite', NULL, NULL);

-- Payment
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('PAYDSHV', 'Frais de scolarite dashboard visible Y oui N non', NULL, 'Y');

-- Daily Token for the Payment Date
INSERT IGNORE INTO uac_param (key_code, description) VALUES ('TOKPAYD', 'Token daily for payement TOKDAND Current Date');

-- Daily Token for EDT
INSERT IGNORE INTO uac_param (key_code, description) VALUES ('TOKEDTD', 'Token daily for EDT TOKEDTD Current Date');




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
           vcc.short_classe AS SHORTCLASS
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






-- save in same table uac_scan_arch
/*
INSERT IGNORE INTO uac_scan_arch (user_id, agent_id, scan_date, scan_time, status, in_out)
SELECT user_id, agent_id, scan_date, scan_time, status, in_out FROM uac_scan;
*/
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
/*
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
  */

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
  `course_status` CHAR(1) NOT NULL DEFAULT 'A',
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `duration_hour` TINYINT NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));
-- Here are migration necessary for half update
-- Legacy is the new form for next year
DROP TABLE IF EXISTS uac_load_jqedt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_jqedt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `flow_id` BIGINT NULL,
  `tag_stamp_for_export` SMALLINT UNSIGNED NOT NULL,
  `cohort_id` INT NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `tech_date` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `min_starts_at` TINYINT NULL,
  `duration_hour` TINYINT NULL,
  `duration_min` TINYINT NULL,
  `course_status` CHAR(1) NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `course_id` VARCHAR(10) NULL,
  `monday_ofthew` DATE NOT NULL,
  `room_id` SMALLINT NULL,
  `course_room` VARCHAR(50) NULL,
  `display_date` VARCHAR(15) NULL,
  `shift_duration` TINYINT NULL,
  `end_time` VARCHAR(10) NULL,
  `end_time_hour` VARCHAR(5) NULL,
  `end_time_min` VARCHAR(5) NULL,
  `start_time` VARCHAR(10) NULL,
  `start_time_hour` VARCHAR(5) NULL,
  `start_time_min` VARCHAR(5) NULL,
  `tech_day` VARCHAR(3) NULL COMMENT 'Related to courseId',
  `tech_hour` VARCHAR(3) NULL COMMENT 'Related to courseId',
  `teacher_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


ALTER TABLE uac_edt_master
ADD COLUMN `jq_edt_type` CHAR(1) NOT NULL DEFAULT 'N' AFTER monday_ofthew;

ALTER TABLE uac_edt_line
ADD COLUMN `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half' AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `end_time` VARCHAR(5) NULL AFTER course_id;
ALTER TABLE uac_edt_line
ADD COLUMN `start_time` VARCHAR(5) NULL AFTER course_id;
ALTER TABLE uac_edt_line
ADD COLUMN `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number' AFTER end_time;
ALTER TABLE uac_edt_line
ADD COLUMN `teacher_id` SMALLINT NOT NULL DEFAULT 0 AFTER shift_duration;



DROP TABLE IF EXISTS uac_ref_day_queue;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_day_queue` (
  `id` TINYINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'INP',
  PRIMARY KEY (`id`));

INSERT INTO uac_ref_day_queue (id) VALUES (0);
INSERT INTO uac_ref_day_queue (id) VALUES (1);
INSERT INTO uac_ref_day_queue (id) VALUES (2);
INSERT INTO uac_ref_day_queue (id) VALUES (3);
INSERT INTO uac_ref_day_queue (id) VALUES (4);
INSERT INTO uac_ref_day_queue (id) VALUES (5);
INSERT INTO uac_ref_day_queue (id) VALUES (6);
INSERT INTO uac_ref_day_queue (id) VALUES (7);


DROP VIEW IF EXISTS v_edt_used_room;
CREATE VIEW v_edt_used_room AS
SELECT  uem.id AS uem_id,
        uem.monday_ofthew AS uem_monday_ofthew,
        course_id AS course_id,
        uel.shift_duration AS shift_duration,
        room_id AS room_id,
        vcc.short_classe AS short_classe,
        uel.start_time AS start_time,
        uel.end_time AS end_time,
        DATE_FORMAT(uem.monday_ofthew, '%d/%m') AS disp_monday,
        0 AS cell_1_shift,
        0 AS cell_2_day,
        0 AS cell_3_half
FROM uac_edt_master uem JOIN uac_edt_line uel
							          ON uel.master_id = uem.id
								        JOIN v_class_cohort vcc
								        ON vcc.id = uem.cohort_id
WHERE uem.visibility IN ('V', 'D')
AND uel.course_status NOT IN ('C')
-- We dont consider the non specified
AND room_id > 0
AND uel.shift_duration > 0;
-- AND uem.monday_ofthew >= '2023-04-10' AND uem.monday_ofthew <= '2023-05-01';


/************************************ Teacher Referential ************************************/
DROP TABLE IF EXISTS uac_ref_teacher;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_teacher` (
  `id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_xref_teacher_mention;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_teacher_mention` (
  `teach_id` SMALLINT UNSIGNED NOT NULL,
  `mention_code` CHAR(5) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`teach_id`, `mention_code`));



/************************************ View ************************************/
DROP VIEW IF EXISTS rep_global_ass_dash;
CREATE VIEW rep_global_ass_dash AS
SELECT
	 UPPER(mu.username) AS USERNAME,
	 mu.matricule AS MATRICULE,
	 REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), "'", " ") AS NAME,
	 CASE WHEN ass.status = 'ABS' THEN 'Absent(e)' WHEN ass.status = 'LAT' THEN 'Retard' WHEN ass.status = 'VLA' THEN 'Tres en retard' WHEN ass.status = 'QUI' THEN 'Quitte' ELSE 'a l\'heure' END AS STATUS,
   CASE
       WHEN UPPER(DAYNAME(uel.day)) = 'MONDAY' THEN "Lundi"
       WHEN UPPER(DAYNAME(uel.day)) = 'TUESDAY' THEN "Mardi"
       WHEN UPPER(DAYNAME(uel.day)) = 'WEDNESDAY' THEN "Mercredi"
       WHEN UPPER(DAYNAME(uel.day)) = 'THURSDAY' THEN "Jeudi"
       WHEN UPPER(DAYNAME(uel.day)) = 'FRIDAY' THEN "Vendredi"
       ELSE "Samedi"
       END AS JOUR,
	  DATE_FORMAT(uel.day, '%d/%m') AS COURS_DATE,
    CONCAT(uel.hour_starts_at, 'h', CASE WHEN (CHAR_LENGTH(uel.min_starts_at) = 1) THEN CONCAT('0', uel.min_starts_at) ELSE uel.min_starts_at END) AS DEBUT_COURS,
	  CONCAT(vcc.niveau, '/', vcc.mention, '/', vcc.parcours, '/', vcc.groupe) AS CLASSE,
    REPLACE(REPLACE(REPLACE(fEscapeLineFeed(uel.raw_course_title), ' ', ' - '), ',', ''), '\\n', ' - ') AS COURS_DETAILS
	  FROM uac_assiduite ass JOIN mdl_user mu
                            ON mu.id = ass.user_id
                            JOIN uac_edt_line uel
                            ON uel.id = ass.edt_id
                            JOIN uac_showuser uas
                            ON mu.username = uas.username
                            JOIN v_class_cohort vcc
                            ON vcc.id = uas.cohort_id
	  WHERE ass.status IN ('ABS', 'LAT', 'VLA', 'QUI')
	  AND uel.day NOT IN (SELECT working_date FROM uac_assiduite_off)
    -- We take maximum 9 last days
	  AND uel.day > DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY)
	  ORDER BY uel.day DESC;

-- Report are here
DROP VIEW IF EXISTS rep_course_dash;
CREATE VIEW rep_course_dash AS
SELECT vcc.short_classe AS CLASSE,
	CASE
                      WHEN UPPER(DAYNAME(uel.day)) = 'MONDAY' THEN "Lundi"
                      WHEN UPPER(DAYNAME(uel.day)) = 'TUESDAY' THEN "Mardi"
                      WHEN UPPER(DAYNAME(uel.day)) = 'WEDNESDAY' THEN "Mercredi"
                      WHEN UPPER(DAYNAME(uel.day)) = 'THURSDAY' THEN "Jeudi"
                      WHEN UPPER(DAYNAME(uel.day)) = 'FRIDAY' THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR,
    CASE WHEN uel.course_status = "A" THEN "Présenté" ELSE "Annulé" END AS COURSE_STATUS,
    REPLACE(CONCAT(fEscapeLineFeed(fEscapeStr(uel.raw_course_title)), ' ', urt.name,
                CASE WHEN uel.start_time IS NOT NULL THEN CONCAT(" - Début ", uel.start_time) ELSE "" END,
                CASE WHEN uel.end_time IS NOT NULL THEN CONCAT(" - Fin ", uel.end_time) ELSE "" END), '\\n', ' - ') AS COURS_DETAILS,
    DATE_FORMAT(uel.day, "%d/%m") AS COURS_DATE,
    CASE
                      WHEN DATE_FORMAT(uel.day, "%m") = '01' THEN "Janvier"
                      WHEN DATE_FORMAT(uel.day, "%m") = '02' THEN "Février"
                      WHEN DATE_FORMAT(uel.day, "%m") = '03' THEN "Mars"
                      WHEN DATE_FORMAT(uel.day, "%m") = '04' THEN "Avril"
                      WHEN DATE_FORMAT(uel.day, "%m") = '05' THEN "Mai"
                      WHEN DATE_FORMAT(uel.day, "%m") = '06' THEN "Juin"
                      WHEN DATE_FORMAT(uel.day, "%m") = '07' THEN "Juillet"
                      WHEN DATE_FORMAT(uel.day, "%m") = '08' THEN "Aout"
                      WHEN DATE_FORMAT(uel.day, "%m") = '09' THEN "Septembre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '10' THEN "Octobre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '11' THEN "Novembre"
                      ELSE "Décembre"
                      END AS MOIS,
    CONCAT(uel.hour_starts_at, 'h', CASE WHEN (CHAR_LENGTH(uel.min_starts_at) = 1) THEN '00' ELSE uel.min_starts_at END) AS DEBUT_COURS,
    CASE WHEN t_abs.abs_cnt IS NULL THEN 0 ELSE t_abs.abs_cnt END AS NBR_ABS,
    CASE WHEN t_qui.qui_cnt IS NULL THEN 0 ELSE t_qui.qui_cnt END AS NBR_QUI, t_cohort_count.cohort_count AS NUMBER_STUD,
    CASE WHEN uao.id IS NULL THEN 'NON' ELSE 'OUI' END AS OFF_DAY, uel.day AS TECH_DAY, uel.hour_starts_at AS TECH_HOUR
	FROM (
		SELECT edt_id AS abs_edt_id, count(1) AS abs_cnt
		FROM uac_assiduite
		WHERE status = 'ABS'
		GROUP BY edt_id
  ) t_abs RIGHT JOIN uac_edt_line uel ON uel.id = t_abs.abs_edt_id
                JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
	 LEFT JOIN (
		SELECT edt_id AS qui_edt_id, count(1) AS qui_cnt
		FROM uac_assiduite
		WHERE status = 'QUI'
		GROUP BY edt_id
	 ) t_qui ON uel.id = t_qui.qui_edt_id
	 JOIN uac_edt_master uem ON uel.master_id = uem.id
								AND uem.visibility = 'V'
	JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
	JOIN (
	SELECT cohort_id AS vshcohort_id, count(1) AS cohort_count
	FROM v_showuser
	GROUP BY cohort_id
	) t_cohort_count ON t_cohort_count.vshcohort_id = uem.cohort_id
	LEFT JOIN uac_assiduite_off uao ON uao.working_date = uel.day
	WHERE uel.duration_hour > 0
	AND uel.day <= CURRENT_DATE
	AND (uel.day > (CURDATE() + interval -(30) day))
	ORDER BY uel.day DESC;

-- Find fill up here : https://docs.google.com/spreadsheets/d/1k0sESkSmMPVc2PPN-cL4oPznnEmClZLn5Qsjq4uDiZ0/edit?usp=sharing
-- INSERT INTO uac_ref_teacher (id, name) VALUES (NULL, NULL);

-- INSERT INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (NULL, NULL);


INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (0, '');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (1, 'M. ANDRIAMAHALY H. Alphonse J.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (2, 'Mme. ANDRIANANTOANINA Rija Fenosoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (3, 'Mme. ANDRIANAVALONA Harimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (4, 'M. ANDRIANIERENANA Clément Luc');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (5, 'M. ANDRIATIANA Mamy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (6, 'Mme. ANDRIMABOAHANGY Domoina Dyana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (7, 'Pr. ETIENNE STEFANO Rahelimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (8, 'M. MAKSIM Lucien Godefroy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (9, 'M. NY ANDRY NANTENAINA RAKOTONANDRASANA Andrianarisaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (10, 'M. RABEHARISON Jeannot');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (11, 'M. RABEMANAHAKA Lala Andrianaivo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (12, 'M. RAKOTONDRATSIMBA Edouard');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (13, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (14, 'Mme. RAKOTONIAINA Ionintsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (15, 'M. RAKOTONIRINA Gérard');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (16, 'M. RAKOTONIRINA Razafy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (17, 'Mme. RALAMBOZAFY Sahondra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (18, 'Mme. RAMAHATRA Hanitra S.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (19, 'Mme. RAMAROSON Mbolamamy Harinoro');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (20, 'M. RAMAROSON Tojonanahary Fetraniaina Romule');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (21, 'Dr. RAMILISON Haingotiana Henitsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (22, 'M. RANAIVOSON Jeannot Fils');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (23, 'Mme. RANDRIANASY Christelle Adriana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (24, 'M. RAVALITERA Jean Rabenalisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (25, 'M. RAVELONJATOVO Tantely Harinjaka');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (26, 'Mme. RAZANABAHINY Victorine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (27, 'M. RAZAFIMANDIMBY Fanomezana Pascal');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (28, 'M. ANDRIANARIJAONA Herizo V.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (29, 'M. RAVALISON Mampionona');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (30, 'M. RAHARIJAONA Lantonirina Joel');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (31, 'M. RAHARINIRINA Zinah');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (32, 'M. ANDRIAMPENITRA Serge');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (33, 'M. ANDRIANANTENAINA Mikaia Valisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (34, 'Pr. RAZAFIMAHEFA Reine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (35, 'M. ANDRIANETRAZAFY Hemerson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (36, 'Mme. ROBIJAOANA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (37, 'M. ANDRIAMAHAZO Jean Claude');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (38, 'M. ANDRIAMAHEFA Zo Nambinina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (39, 'Mme. ANDRIAMISEZA Noromanitra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (40, 'M. ANDRIANALY Jacquelin Solonirina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (41, 'Mme. ANDRIANANDRASANA Joëlle Jeannie');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (42, 'M. ANDRIANASOLO Léon Dolà');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (43, 'M. ANDRIANETRAZAFY Hemerson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (44, 'Mme. HANITRINIAINA Marie Elie');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (45, 'Mme. RAFELAMANILO Voahangy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (46, 'Mme. RAHARISON Aimée');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (47, 'M. RAKOTONANAHARY Herizo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (48, 'M. RAKOTONDRAMASY Franck');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (49, 'Dr. RAKOTOSON Philippe Victorien');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (50, 'Mme. RALAMBOSON Hantsa Iarivelo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (51, 'M. RAMAHANDRY Tsirava Maurice');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (52, 'M. RAMANITRARIVO Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (53, 'Mme. RASAMIMANANA Livasoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (54, 'Mme. RASOANAIVO Diana Hanta');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (55, 'M. RATOLONJANAHARY Odon');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (56, 'Mme. RATSIMBAZAFY Fara');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (57, 'M. RAMORASATA Henintsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (58, 'M. ROBIVELO Marie Michel Raphaël');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (59, 'M. ANDRIAMBOLATIANA Parson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (60, 'M. RAVELOALISON Haja Nirina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (61, 'M. MAKSIM Lucien');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (62, 'M. RAZAFINJATOVO MAHEFASON Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (63, 'Mme. ANDRIAMAMPIANINA Vonjiniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (64, 'M. BONNET Gérard-Louis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (65, 'Mme. ROBIJAONA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (66, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (67, 'M. RANAIVONTSOA Boris');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (68, 'Mme. ANDRIANASY Reine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (69, 'M. ANDRIAMANEHONTOANINA Solo Mihamina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (70, 'Pr. ANDRIAMANOHISOA Hery Zo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (71, 'Mme. ANDRIANARIZAKA Hantatiana Henimpitia');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (72, 'M. ANDRIATSIMIAFIMIRIJA Tojontsoa Clovin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (73, 'M. RABEMANAJARA Russel');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (74, 'M. ANDRIANANDRAINA Andry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (75, 'M. RAKOTOMAHENINA Pierre Benjamin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (76, 'Mme. RAKOTOMALALA Claudia');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (77, 'Mme. RAKOTONDRASOA Seheno');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (78, 'M. ANDRIAMANOHISOA Tahiana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (79, 'M. RAKOTOSALAMA Clément');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (80, 'M. RAKOTOSALAMA Lova');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (81, 'Mme. RANDRIAMAMPIANINA Valimbavaka');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (82, 'Pr. RANDRIANARIMALA Ansèlme');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (83, 'M. RAZAFIMBELO Florent');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (84, 'M. RAZAFINJATOVO MAHEFASON Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (85, 'Mme. RAZANADRAKOTO Jocelyne');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (86, 'M. RAJEMISON RAKOTOMAHARO Guy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (87, 'M. RAZAFIMAMONJY Jean Berger');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (88, 'Mme. RANAIVOSON Nirina Robsely');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (89, 'M. ANDRIANETRAZAFY Hemerson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (90, 'M. BONNET Gérard-Louis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (91, 'Mme. ROBIJAOANA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (92, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (93, 'Mme. ANDRIAMANALINARIVO Njiva');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (94, 'M. RANAIVONTSOA Boris');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (95, 'M. RABIBISOA Francis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (96, 'M. RAKOTOARIVONY Solofoniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (97, 'Dr. ANDRIAMIFALIHARIMANANA Rado');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (98, 'M. ANDRIAMIHARIVOLAMENA RAKOTONIAINA Jacob');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (99, 'Pr. MANDRARA Thosun Eric');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (100, 'M. RAKOTOARIMANANA Tsiriheriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (101, 'Mme. RAMANANTSEHENO Domoina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (102, 'Mme. RANDRIAMANAMPISOA Holimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (103, 'M. RANDRIAMISATA Mahitsison Danie Patrick');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (104, 'M. RANDRIANARIMANANA Andoniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (105, 'Mme. RANDRIANARIVONY Lanto Lancia');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (106, 'Mme. RAVELONTSALAMA Miora Gabrielle');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (107, 'M. RAZAFITRIMO Ny Aina Lazaharijaona');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (108, 'M. SOULEMAN IBRAHIM Andriamandimby');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (109, 'M. RAZAFIZANAKA Giannot Albert');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (110, 'M. RAZAFINDRALAMBO Manohisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (111, 'Mme. RANDRIAMAMPIANINA Andy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (112, 'Mme. RALAMBOZAFY Sahondra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (113, 'M. ANDRIAMANOHISOA Hery Zo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (114, 'M. ANDRIAMANOHISOA Tahiana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (115, 'M. RABEHARISON Jeannot');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (116, 'M. HANCEL Léonce Herbert');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (117, 'M. RAMAHANDRY Tsirava Maurice');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (118, 'M. ROBIVELO Marie Michel Raphaël');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (119, 'Mme. RAZAFIMANDIMBY Rian aina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (120, 'Mme. RAZAFIMANDIMBY Malala Tiana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (121, 'M. RAZAFIMANJATO Jocelyn Yves');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (122, 'M. RAZAFINJATOVO MAHEFASON Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (123, 'M. RAKOTOZAFY Rivo John');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (124, 'Mme. ROBIJAOANA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (125, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (126, 'M. ANDRIANTSOA Jean Rubis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (127, 'Mme. ANDRIANTSOA Nirifenohanitra Esther');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (128, 'Mme. ANDRIANTSOA RASOAVELONORO Violette');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (129, 'M. RABEZANAHARY Jean Emilien (Assistant Pr Jean Claude)');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (130, 'Mme. HARIJAONA Vololontsoa Vero');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (131, 'Mme. RAHARIMANANTSOA Onja Lalaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (132, 'M. RAJAONA Ranto Andriatsilavina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (133, 'M. RAJAONARISON Ny Ony Narindra Lova Hasina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (134, 'M. RAJAONARIVONY Tianarivelo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (135, 'Mme. RAKOTOARISOA RASAMINDRAKOTROKA Miora Tantely');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (136, 'M. RAKOTOARISOA Rivo Tahiry Rabetafika');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (137, 'Mme. RAMAMONJIARISOA Faramalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (138, 'M. RAMARISON Guy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (139, 'Mme. RANDRIANARISOA Hoby Lalaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (140, 'Mme. RANIVONTSOARIVONY Martine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (141, 'Mme. RARIVOHARILALA Esther');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (142, 'M. RASAMINDRAKOTROKA Andry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (143, 'Mme. RASOANAIVO Nivohanitra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (144, 'Mme. RATSIMBAZAFIMAHEFA RAHANTALALAO Henriette');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (145, 'Mme. RAVALOSON Ialiseheno');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (146, 'Mme. RAZAFIMAHEFA RAMILISON Reine Dorothée');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (147, 'Mme. ANDRIANANJA Volatiana (Assistante Pr Mamy RANDRIA)');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (148, 'M. RATOVOHERY Andry Nirilalaina (Informatique)');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (149, 'M. ANDRIAMBOLOLOA Falihery');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (150, 'Mme. ANDRIAMAMPIANINA Vonjiniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (151, 'M. ANDRIAMIJORO Mino');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (152, 'M. BONNET Gérard-Louis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (153, 'M. JAONARY Gérald');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (154, 'M. NARENDRA Mathieu');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (155, 'Mme. RABEZANDRINA Nirina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (156, 'M. RAKOTOARISOA Samimanana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (157, 'M. RAKOTOMAHANINA Mbelo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (158, 'M. RAKOTONINDRAINY Seraphin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (159, 'Mme. RANAIVOSON Nirina Robisely');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (160, 'M. RANDRIAMBOLOLONA Fabien');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (161, 'Mme. RASOLOFONIAINA RAZAKARIVONY Yollande');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (162, 'M. RASOLOFOSON Miarantsoa Fanomezana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (163, 'M. RATIARAIMAVO Solofo N. A.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (164, 'M. RATSIMBAZAFY Harilala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (165, 'Mme. RAZAFINDRALAMBO Harisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (166, 'M. ROBSON Sata');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (167, 'Mme. RAKOTONANDRASANA Norolalao');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (168, 'M. ANDRIAMANANTSOA Guy Danielson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (169, 'M. HERINANTENAINA Edmond Fils');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (170, 'M. RABESANDRATANA ANDRIAMIHAJA Mamisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (171, 'M. RAHARISON Christian Jean Noëllin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (172, 'M. RALAIVAO Michel Ludovic');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (173, 'M. RAMAHANDRISOA Tsirilalaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (174, 'M. RAMAHANDRISOA Fetraharijaona');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (175, 'M. RANDRIAMAROSON Rivo Mahandrisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (176, 'M. RAJEMIARIMIRAHO Lazaniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (177, 'M. RASTEFANO Elisée');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (178, 'M. RAKOTONINDRINA Benja');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (179, 'M. RATSIRARSON Shen Andriantsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (180, 'M. RANDRIAMAHALEO Fanilo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (181, 'M. RANDRIANANTOANDRO Solofo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (182, 'M. RAZANAMAHERY Zoé');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (183, 'Mme. RALAMBOSON Hantsa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (184, 'M. BONNET Gérard');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (185, 'Mme. RASOANAIVO Diana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (186, 'Mme. ANDRIANAVALONA Harimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (187, 'Mme. RABEARIMANANA Lucile');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (188, 'M. RAVALITERA Jean Rabenalisoa');

INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (1, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (2, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (3, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (4, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (5, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (6, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (7, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (8, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (9, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (11, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (12, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (13, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (14, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (15, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (16, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (17, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (18, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (19, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (20, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (21, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (22, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (23, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (24, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (25, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (26, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (27, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (28, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (29, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (30, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (31, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (32, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (33, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (34, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (35, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (36, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (37, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (38, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (39, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (40, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (41, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (42, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (43, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (44, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (45, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (46, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (47, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (48, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (49, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (50, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (51, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (52, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (53, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (54, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (55, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (56, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (57, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (58, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (59, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (60, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (61, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (62, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (63, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (64, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (65, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (66, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (67, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (68, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (69, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (70, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (71, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (72, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (73, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (74, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (75, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (76, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (77, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (78, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (79, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (80, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (81, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (82, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (83, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (84, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (85, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (86, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (87, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (88, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (89, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (90, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (91, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (92, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (93, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (94, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (95, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (96, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (97, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (98, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (99, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (100, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (101, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (102, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (103, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (104, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (105, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (106, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (107, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (108, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (109, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (110, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (111, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (112, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (113, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (114, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (115, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (116, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (117, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (118, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (119, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (120, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (121, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (122, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (123, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (124, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (125, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (126, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (127, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (128, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (129, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (130, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (131, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (132, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (133, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (134, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (135, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (136, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (137, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (138, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (139, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (140, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (141, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (142, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (143, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (144, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (145, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (146, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (147, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (148, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (149, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (150, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (151, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (152, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (153, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (154, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (155, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (156, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (157, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (158, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (159, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (160, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (161, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (162, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (163, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (164, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (165, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (166, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (167, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (168, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (169, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (170, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (171, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (172, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (173, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (174, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (175, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (176, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (177, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (178, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (179, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (180, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (181, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (182, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (183, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (184, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (185, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (186, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (187, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (188, 'RIDXX');
/*************************************** LEGACY ***************************************/

/*
DROP TABLE IF EXISTS uac_edt_line;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_line` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `master_id` BIGINT UNSIGNED NULL,
  `compute_late_status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `duration_hour` TINYINT UNSIGNED NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half',
  `start_time` VARCHAR(5) NULL,
  `end_time` VARCHAR(5) NULL,
  `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number',
  `teacher_id` SMALLINT NOT NULL DEFAULT 0,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))

DROP TABLE IF EXISTS uac_edt_master;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_master` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `cohort_id` BIGINT UNSIGNED NULL,
  `visibility` CHAR(1) NOT NULL DEFAULT 'I',
  `monday_ofthew` DATE NOT NULL,
  `jq_edt_type` CHAR(1) NOT NULL DEFAULT 'N',
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

-- Manage Day Off
DROP TABLE IF EXISTS uac_assiduite_off;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_assiduite_off` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `working_date` DATE NOT NULL,
  `day_code` TINYINT NOT NULL,
  `reason` VARCHAR(100) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


ALTER TABLE uac_assiduite_off
  ADD CONSTRAINT uac_assiduite_off_wd UNIQUE (working_date);

-- INSERT INTO uac_assiduite_off (working_date, day_code) VALUES ('2022-10-04', DAYOFWEEK('2022-10-04'));
-- Report are here
DROP VIEW IF EXISTS rep_course_dash;
CREATE VIEW rep_course_dash AS
SELECT vcc.short_classe AS CLASSE,
		CASE
        WHEN UPPER(DAYNAME(uel.day)) = 'MONDAY' THEN "Lundi"
        WHEN UPPER(DAYNAME(uel.day)) = 'TUESDAY' THEN "Mardi"
        WHEN UPPER(DAYNAME(uel.day)) = 'WEDNESDAY' THEN "Mercredi"
        WHEN UPPER(DAYNAME(uel.day)) = 'THURSDAY' THEN "Jeudi"
        WHEN UPPER(DAYNAME(uel.day)) = 'FRIDAY' THEN "Vendredi"
        ELSE "Samedi"
        END AS JOUR,
		-- C is for CANCEL the rest are not
    CASE WHEN uel.course_status = "C" THEN "Annulé" ELSE "Présenté" END AS COURSE_STATUS,
    REPLACE(REPLACE(uel.raw_course_title, "\n", " - "), ",", "") AS COURS_DETAILS,
    DATE_FORMAT(uel.day, "%d/%m") AS COURS_DATE,
    CASE
                      WHEN DATE_FORMAT(uel.day, "%m") = '01' THEN "Janvier"
                      WHEN DATE_FORMAT(uel.day, "%m") = '02' THEN "Février"
                      WHEN DATE_FORMAT(uel.day, "%m") = '03' THEN "Mars"
                      WHEN DATE_FORMAT(uel.day, "%m") = '04' THEN "Avril"
                      WHEN DATE_FORMAT(uel.day, "%m") = '05' THEN "Mai"
                      WHEN DATE_FORMAT(uel.day, "%m") = '06' THEN "Juin"
                      WHEN DATE_FORMAT(uel.day, "%m") = '07' THEN "Juillet"
                      WHEN DATE_FORMAT(uel.day, "%m") = '08' THEN "Aout"
                      WHEN DATE_FORMAT(uel.day, "%m") = '09' THEN "Septembre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '10' THEN "Octobre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '11' THEN "Novembre"
                      ELSE "Décembre"
                      END AS MOIS,
    CONCAT(uel.hour_starts_at, 'h', CASE WHEN (CHAR_LENGTH(uel.min_starts_at) = 1) THEN '00' ELSE uel.min_starts_at END) AS DEBUT_COURS,
    CASE WHEN t_abs.abs_cnt IS NULL THEN 0 ELSE t_abs.abs_cnt END AS NBR_ABS,
    CASE WHEN t_qui.qui_cnt IS NULL THEN 0 ELSE t_qui.qui_cnt END AS NBR_QUI, t_cohort_count.cohort_count AS NUMBER_STUD,
    CASE WHEN uao.id IS NULL THEN 'NON' ELSE 'OUI' END AS OFF_DAY, uel.day AS TECH_DAY, uel.hour_starts_at AS TECH_HOUR
	FROM (
		SELECT edt_id AS abs_edt_id, count(1) AS abs_cnt
		FROM uac_assiduite
		WHERE status = 'ABS'
		GROUP BY edt_id
  ) t_abs RIGHT JOIN uac_edt_line uel ON uel.id = t_abs.abs_edt_id
	 LEFT JOIN (
		SELECT edt_id AS qui_edt_id, count(1) AS qui_cnt
		FROM uac_assiduite
		WHERE status = 'QUI'
		GROUP BY edt_id
	 ) t_qui ON uel.id = t_qui.qui_edt_id
	 JOIN uac_edt_master uem ON uel.master_id = uem.id
								AND uem.visibility = 'V'
	JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
	JOIN (
	SELECT cohort_id AS vshcohort_id, count(1) AS cohort_count
	FROM v_showuser
	GROUP BY cohort_id
	) t_cohort_count ON t_cohort_count.vshcohort_id = uem.cohort_id
	LEFT JOIN uac_assiduite_off uao ON uao.working_date = uel.day
	WHERE (uel.duration_hour + uel.duration_min) > 0
	AND uel.course_status NOT IN ('1', '2')
	AND uel.day <= CURRENT_DATE
	ORDER BY uel.day DESC;


DROP VIEW IF EXISTS rep_no_exit;
CREATE VIEW rep_no_exit AS
SELECT DISTINCT REPLACE(CONCAT(vsh.FIRSTNAME, ' ', vsh.LASTNAME), "'", " ") AS NAME, UPPER(vsh.USERNAME) AS USERNAME, vsh.MATRICULE AS MATRICULE, vcc.short_classe AS CLASSE, DATE_FORMAT(max_scan.scan_date, "%d/%m") AS INVDATE, max_scan.scan_date AS TECH_DATE,
	CASE
                      WHEN DAYOFWEEK(max_scan.scan_date) = 2 THEN "Lundi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 3 THEN "Mardi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 4 THEN "Mercredi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 5 THEN "Jeudi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 6 THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR, 'Scan sortie manquant' AS REASON  FROM (
          -- List of last scan of people
          SELECT mu.id AS mu_id, usa.scan_date AS nooutscan_date, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE 1=1
					-- For these specific dates
          AND usa.scan_date < CURRENT_DATE
					AND usa.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)
          GROUP BY mu.id, usa.scan_date
          ) t_student_noout JOIN uac_scan max_scan
																	-- Match the full scan if it is I
                                  ON max_scan.user_id = t_student_noout.mu_id
                			   	  			AND max_scan.scan_time = scan_in
                			   	  			AND max_scan.scan_date = t_student_noout.nooutscan_date
                			   	  			AND max_scan.in_out = 'I'
														-- Need to know if he as been PON/LAT etc
          			   	  			JOIN uac_assiduite uaa
                                    ON uaa.user_id = max_scan.user_id
          			   	  				     -- AND max_scan.id = uaa.scan_id
          			   	  				     AND uaa.status IN ('PON', 'LAT', 'VLA', 'QUI')
          			   	  				JOIN uac_edt_line uel
          			   	  				ON uel.id = uaa.edt_id
          			   	  				AND uel.day = max_scan.scan_date
          			   	  		JOIN v_showuser vsh ON vsh.id = max_scan.user_id
          			   	  		JOIN v_class_cohort vcc ON vcc.id = vsh.cohort_id
          			   	  			ORDER BY TECH_DATE DESC;

DROP VIEW IF EXISTS rep_no_entry;
CREATE VIEW rep_no_entry AS
SELECT DISTINCT REPLACE(CONCAT(vsh.FIRSTNAME, ' ', vsh.LASTNAME), "'", " ") AS NAME, UPPER(vsh.USERNAME) AS USERNAME, vsh.MATRICULE AS MATRICULE, vcc.short_classe AS CLASSE, DATE_FORMAT(min_scan.scan_date, "%d/%m") AS INVDATE, min_scan.scan_date AS TECH_DATE,
	CASE
                      WHEN DAYOFWEEK(min_scan.scan_date) = 2 THEN "Lundi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 3 THEN "Mardi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 4 THEN "Mercredi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 5 THEN "Jeudi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 6 THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR, 'Scan entrée manquant' AS REASON  FROM (
          -- List of last scan of people
          SELECT mu.id AS mu_id, usa.scan_date AS nooutscan_date, min(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE 1=1
					-- For these specific dates
          AND usa.scan_date < CURRENT_DATE
					AND usa.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)
          GROUP BY mu.id, usa.scan_date
          ) t_student_noout JOIN uac_scan min_scan
																	-- Match the full scan if it is I
                                  ON min_scan.user_id = t_student_noout.mu_id
                			   	  			AND min_scan.scan_time = scan_in
                			   	  			AND min_scan.scan_date = t_student_noout.nooutscan_date
                			   	  			AND min_scan.in_out = 'O'
												-- Need to know if he as been PON/LAT etc
												JOIN uac_assiduite uaa
																ON uaa.user_id = min_scan.user_id
															 -- AND max_scan.id = uaa.scan_id
															 AND uaa.status IN ('PON', 'LAT', 'VLA', 'QUI')
													JOIN uac_edt_line uel
													ON uel.id = uaa.edt_id
													AND uel.day = min_scan.scan_date
          			   	  		JOIN v_showuser vsh ON vsh.id = min_scan.user_id
          			   	  		JOIN v_class_cohort vcc ON vcc.id = vsh.cohort_id
          			   	  			ORDER BY TECH_DATE DESC;
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- New table dont forget the REORG ------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- TABLE

DROP TABLE IF EXISTS uac_ref_frais_scolarite;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_frais_scolarite` (
  `id` INT UNSIGNED NOT NULL,
  `code` VARCHAR(7) NOT NULL COMMENT 'Codification is for reference',
  `title` VARCHAR(50) NOT NULL,
  `description` VARCHAR(250) NULL COMMENT 'Tranche will be 1 sur x',
  `fs_order` TINYINT NULL,
  `amount` INT UNSIGNED NOT NULL,
  `status` CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'By default A is active and I for inactive',
  `deadline` DATE NOT NULL COMMENT 'Deadline per each school year so to be revised every year during end of the year',
  `type` CHAR(1) NOT NULL DEFAULT 'U' COMMENT 'Can be U for Unique Payment or M for Multiple or T for Tranche',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  UNIQUE KEY `code_UNIQUE` (`code`));


-- DELETE FROM uac_ref_frais_scolarite;

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(1, 'DTSTENT', 'Droit test ou entretien', 'Droit test ou entretien', 1, 50000, 'A', '2022-12-05', 'U');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(2, 'DRTINSC', 'Droit inscription', 'Droit inscription', 2, 150000, 'A', '2022-12-19', 'U');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(3, 'FRAIGEN', 'Frais généraux', 'Frais généraux', 3, 200000, 'A', '2022-12-19', 'U');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(13, 'CERTSCO', 'Certificat Scolarité', 'Certificat Scolarité', 4, 5000, 'A', '2023-12-31', 'M');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(4, 'L1T1XXX', 'L1 Tranche 1 sur 3', 'L1 Tranche 1 sur 3', 20, 800000, 'A', '2023-01-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(5, 'L1T2XXX', 'L1 Tranche 2 sur 3', 'L1 Tranche 2 sur 3', 21, 850000, 'A', '2023-04-30', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(6, 'L1T3XXX', 'L1 Tranche 3 sur 3', 'L1 Tranche 3 sur 3', 22, 850000, 'A', '2023-07-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(7, 'L2L3T1X', 'L2/L3 Tranche 1 sur 3', 'L2/L3 Tranche 1 sur 3', 23, 850000, 'A', '2023-01-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(8, 'L2L3T2X', 'L2/L3 Tranche 2 sur 3', 'L2/L3 Tranche 2 sur 3', 24, 850000, 'A', '2023-04-30', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(9, 'L2L3T3X', 'L2/L3 Tranche 3 sur 3', 'L2/L3 Tranche 3 sur 3', 25, 850000, 'A', '2023-07-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(10, 'M1M2T1X', 'M1/M2 Tranche 1 sur 3', 'M1/M2 Tranche 1 sur 3', 26, 950000, 'A', '2023-04-30', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(11, 'M1M2T2X', 'M1/M2 Tranche 2 sur 3', 'M1/M2 Tranche 2 sur 3', 27, 950000, 'A', '2023-07-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(12, 'M1M2T3X', 'M1/M2 Tranche 3 sur 3', 'M1/M2 Tranche 3 sur 3', 28, 950000, 'A', '2023-09-30', 'T');


-- Cross ref table
DROP TABLE IF EXISTS uac_xref_cohort_fsc;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_cohort_fsc` (
  `cohort_id` INT UNSIGNED NOT NULL,
  `fsc_id` INT UNSIGNED NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cohort_id`, `fsc_id`));

-- DELETE FROM uac_xref_cohort_fsc;

-- Insert data for each level
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 1, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 2, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 3, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 13, id FROM v_class_cohort vcc;

-- Insert Tranche for L1
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 4, id FROM v_class_cohort vcc where vcc.niveau = 'L1';

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 5, id FROM v_class_cohort vcc where vcc.niveau = 'L1';

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 6, id FROM v_class_cohort vcc where vcc.niveau = 'L1';

-- Insert Tranche for L2/L3
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 7, id FROM v_class_cohort vcc where vcc.niveau IN ('L2', 'L3');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 8, id FROM v_class_cohort vcc where vcc.niveau IN ('L2', 'L3');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 9, id FROM v_class_cohort vcc where vcc.niveau IN ('L2', 'L3');

-- Insert Tranche for M1/M2
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 10, id FROM v_class_cohort vcc where vcc.niveau IN ('M1', 'M2');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 11, id FROM v_class_cohort vcc where vcc.niveau IN ('M1', 'M2');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 12, id FROM v_class_cohort vcc where vcc.niveau IN ('M1', 'M2');


-- REDUCTION FACILITE PAYMENT
DROP TABLE IF EXISTS uac_facilite_payment;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_facilite_payment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `category` CHAR(1) NOT NULL COMMENT 'R for Reduction, M for Mensualite, L for Letter of commitment',
  `ticket_ref` CHAR(10) NOT NULL,
  `red_pc` TINYINT UNSIGNED NULL COMMENT 'Percentage of reduction',
  `status` CHAR(1) NOT NULL DEFAULT 'I' COMMENT 'A is active and I for inactive',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  UNIQUE KEY `user_id_category_UNIQUE` (`user_id`, `category`),
  UNIQUE KEY `ticket_ref_UNIQUE` (`ticket_ref`));

-- WORKING TABLE FOR THE PAYMENTS
-- REDUCTION ARE CREATING FULL PAYMENT AS REDUCTION
-- NEED TO BE IN REORG !
DROP TABLE IF EXISTS uac_payment;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_payment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL COMMENT 'Codification is for reference',
  `ref_fsc_id` INT NULL COMMENT 'When not null then related to ref frais de scolarite else it is a manual payment',
  `status` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'N as Not Paid or P as Paid or F as Filled (by manual payment)  or E for Excused (example for payment test or entretien but you are not new comer)',
  `payment_ref` CHAR(10) NULL COMMENT 'Reference generated for Payment or reduction reference or empty because not yet paid',
  `facilite_id` BIGINT NULL,
  `manual_amount` INT NULL COMMENT 'Can be null then it is the ref fsc id or zero then it is engagement letter or free input then it is full manual',
  `type_of_payment` CHAR(1) NULL COMMENT 'C is for Cash, H for Check, M for Mvola, T for Transfert, R is for reduction',
  `pay_date` DATETIME NULL,
  `comment` VARCHAR(45) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`));

-- VIEW
-- Get the referential per class
DROP VIEW IF EXISTS v_fsc_xref_cc;
CREATE VIEW v_fsc_xref_cc AS
SELECT
  vcc.id AS vcc_id,
  vcc.niveau AS niveau,
  vcc.mention AS mention,
  vcc.parcours AS parcours,
  vcc.groupe AS groupe,
  vcc.short_classe AS short_classe,
  urfs.id AS urfs_id,
  urfs.code AS urfs_code,
  urfs.title AS urfs_title,
  urfs.description AS urfs_description,
  urfs.fs_order AS fs_order,
  urfs.amount AS amount,
  urfs.status AS status,
  urfs.deadline AS deadline,
  urfs.type AS type
  FROM v_class_cohort vcc JOIN uac_xref_cohort_fsc xref
                          ON xref.cohort_id = vcc.id
                          JOIN uac_ref_frais_scolarite urfs
                          ON urfs.id = xref.fsc_id;

-- Get the list of user and reduction they get
  DROP VIEW IF EXISTS v_payfoundusrn;
  CREATE VIEW v_payfoundusrn AS
  SELECT
        vsh.ID AS ID,
        UPPER(vsh.USERNAME) AS USERNAME,
        vsh.MATRICULE AS MATRICULE,
        REPLACE(CONCAT(fCapitalizeStr(vsh.FIRSTNAME), ' ', vsh.LASTNAME), "'", " ") AS NAME,
        vsh.SHORTCLASS AS CLASSE,
        GROUP_CONCAT(category, red_pc) AS EXISTING_FACILITE
        FROM v_showuser vsh LEFT JOIN uac_facilite_payment ufp ON vsh.ID = ufp.user_id
        GROUP BY ID, USERNAME, NAME, CLASSE;

-- Payment view
DROP VIEW IF EXISTS v_payment_for_user;
CREATE VIEW v_payment_for_user AS
    SELECT
      up.id AS UP_ID,
      up.user_id AS UP_USER_ID,
      IFNULL(up.status, 'N') AS UP_STATUS,
      up.payment_ref AS UP_PAYMENT_REF,
      up.facilite_id AS UP_FACILITE_ID,
      up.manual_amount AS UP_MANUAL_AMOUNT,
      up.type_of_payment AS UP_TYPE_OF_PAYMENT,
      up.comment AS UP_COMMENT,
      up.create_date AS UP_CREATE_DATE,
      up.last_update AS UP_LAST_UPDATE,
      ref.id AS REF_ID,
      ref.code AS REF_CODE,
      ref.title AS REF_TITLE,
      ref.amount AS REF_AMOUNT,
      ref.deadline AS REF_DEADLINE,
      DATEDIFF(ref.deadline, CURRENT_DATE) AS NEGATIVE_IS_LATE,
      ref.type AS REF_TYPE,
      ref.fs_order AS REF_FS_ORDER,
      vcc.id AS COHORT_ID
    FROM uac_payment up RIGHT JOIN uac_ref_frais_scolarite ref ON up.ref_fsc_id = ref.id
                            JOIN uac_xref_cohort_fsc xref ON ref.id = xref.fsc_id
                            JOIN v_class_cohort vcc ON vcc.id = xref.cohort_id
    -- We exclude multiple which has no real deadline
    WHERE ref.type IN ('T', 'U');
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- New table dont forget the REORG ------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------


DROP TABLE IF EXISTS uac_ref_partner;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_partner` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(250) NOT NULL,
  `description` VARCHAR(250) NULL,
  `img_path` VARCHAR(250) NULL,
  `website` VARCHAR(500) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Alliance Française de Madagascar', NULL, 'alliancefrancaise.png', 'http://www.alliancefr.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('BGFI Banque', NULL, 'bgfibank.png', 'https://madagascar.groupebgfibank.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Groupe Sipromad', NULL, 'groupesipromad.png', 'https://www.sipromad.com/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Masoala Laboratoire', NULL, 'masoalalaboratoire.png', 'https://masoala-laboratoire.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Université du Québec en Abitibi-Témiscamingue', NULL, 'uqat.png', 'https://www.uqat.ca/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Ambatovy', NULL, 'ambatovy.png', 'https://ambatovy.com/en/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('British Embassy', NULL, 'britishembassy.png', 'https://www.gov.uk/world/organisations/british-embassy-antananarivo');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Guanomad', NULL, 'guanomad.png', 'https://www.guanomad.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ("Ministère de l\'Enseignement Supérieur et de la Recherche Scientifique", NULL, 'mesupres.png', 'http://www.mesupres.gov.mg/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Vaniala', NULL, 'vaniala.png', 'https://vaniala-naturalspa.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Agence Universitère de la Francophonie', NULL, 'auf.png', 'https://www.auf.org/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Ethiopian Airlines', NULL, 'ethiopianairlines.png', 'https://www.ethiopianairlines.com/fr/fr');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Homeopharma', NULL, 'homeopharma.png', 'https://www.homeopharma.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Société Générale Madagasikara', NULL, 'societegeneralemadagasikara.png', 'https://societegenerale.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Bank of Africa', NULL, 'bankofafrica.png', 'https://boamadagascar.com/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Groupe Éducatif ACEEM', NULL, 'groupeaceem.png', 'https://aceemgroupe.com/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Madajeune', NULL, 'madajeune.png', 'https://www.facebook.com/profile.php?id=100072319024922');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Telma', NULL, 'telma.png', 'https://www.telma.mg/');

INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Ambassade de France à Madagascar', NULL, 'ambassadefrancemadagascar.png', 'https://mg.ambafrance.org/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('SBM Banque à Madagascar', NULL, 'sbmbank.png', 'https://globalpresence.sbmgroup.mu/fr/madagascar/');

-- Mai 2023
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('BNI', NULL, 'bni.png', 'https://www.bni.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Habibo', NULL, 'habibo.png', 'https://habibo.mg/');
INSERT INTO uac_ref_partner (title, description, img_path, website) VALUES ('Orange Madagascar', NULL, 'orangemadagascar.png', 'https://www.orange.mg/');

DROP TABLE IF EXISTS mdl_load_user;
CREATE TABLE IF NOT EXISTS `ACEA`.`mdl_load_user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` CHAR(10) NOT NULL,
  `status` CHAR(3) NULL DEFAULT 'NEW',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `phone1` VARCHAR(20) NOT NULL,
  `phone_mvola` VARCHAR(20) NULL,
  `address` VARCHAR(255) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `matricule` VARCHAR(45) NOT NULL,
  `autre_prenom` VARCHAR(50) NULL,
  `genre` CHAR(1) NULL,
  `datedenaissance` DATE NULL,
  `lieu_de_naissance` VARCHAR(50) NULL,
  `situation_matrimoniale` VARCHAR(20) NULL,
  `compte_fb` VARCHAR(200) NULL,
  `etablissement_origine` VARCHAR(200) NULL,
  `serie_bac` VARCHAR(150) NULL,
  `annee_bac` SMALLINT NULL,
  `numero_cin` VARCHAR(50) NULL,
  `date_cin` DATE NULL,
  `lieu_cin` VARCHAR(50) NULL,
  `nom_pnom_par1` VARCHAR(250) NULL,
  `email_par1` VARCHAR(50) NULL,
  `phone_par1` VARCHAR(20) NULL,
  `profession_par1` VARCHAR(200) NULL,
  `adresse_par1` VARCHAR(200) NULL,
  `city_par1` VARCHAR(50) NULL,
  `nom_pnom_par2` VARCHAR(250) NULL,
  `phone_par2` VARCHAR(20) NULL,
  `profession_par2` VARCHAR(200) NULL,
  `centres_interets` VARCHAR(500) NULL,
  `cohorte_short_name` VARCHAR(50) NULL,
  `core_cohort_id` TINYINT NULL,
  `gsheet_id` BIGINT NOT NULL,
  `flow_id` BIGINT NULL,
  `core_status_matrimonial` CHAR(1) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`));

-- cohort id must be in uac_showuser;
DROP TABLE IF EXISTS mdl_user;
CREATE TABLE IF NOT EXISTS `ACEA`.`mdl_user` (
  `id` BIGINT UNSIGNED NOT NULL,
  `username` CHAR(10) NOT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `phone1` VARCHAR(20) NOT NULL,
  `phone_mvola` VARCHAR(20) NULL,
  `address` VARCHAR(255) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `matricule` VARCHAR(45) NOT NULL,
  `autre_prenom` VARCHAR(50) NULL,
  `genre` CHAR(1) NOT NULL,
  `datedenaissance` DATE NOT NULL,
  `lieu_de_naissance` VARCHAR(50) NULL,
  `situation_matrimoniale` CHAR(1) NULL,
  `compte_fb` VARCHAR(200) NULL,
  `etablissement_origine` VARCHAR(200) NULL,
  `serie_bac` VARCHAR(150) NULL,
  `annee_bac` SMALLINT NULL,
  `numero_cin` VARCHAR(50) NULL,
  `date_cin` DATE NULL,
  `lieu_cin` VARCHAR(50) NULL,
  `nom_pnom_par1` VARCHAR(250) NULL,
  `email_par1` VARCHAR(50) NULL,
  `phone_par1` VARCHAR(20) NULL,
  `profession_par1` VARCHAR(200) NULL,
  `adresse_par1` VARCHAR(250) NULL,
  `city_par1` VARCHAR(50) NULL,
  `nom_pnom_par2` VARCHAR(250) NULL,
  `phone_par2` VARCHAR(20) NULL,
  `profession_par2` VARCHAR(200) NULL,
  `centres_interets` VARCHAR(500) NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`));
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
 DROP PROCEDURE IF EXISTS SRV_PRG_Generic$$
 CREATE PROCEDURE `SRV_PRG_Generic` ()
 BEGIN
     DECLARE prg_date	DATE;
     DECLARE prg_history_delta	INT;
     -- CALL SRV_PRG_Scan();

     SELECT par_int INTO prg_history_delta FROM uac_param WHERE key_code = 'GENEPRG';
     SELECT DATE_ADD(CURRENT_DATE, INTERVAL -prg_history_delta DAY) INTO prg_date;

     -- DELETE FROM uac_assiduite_off WHERE working_date < prg_date;
     DELETE FROM uac_connection_log WHERE create_date < prg_date;
     DELETE FROM uac_studashboard_log WHERE create_date < prg_date;


     -- **********************************************************
     -- DONT PURGE uac_mail **************************************
     -- **********************************************************

     -- Email massive
     DELETE FROM uac_working_flow WHERE flow_code = 'GRPMLWC' AND create_date < prg_date;
     DELETE FROM uac_working_flow WHERE flow_code = 'MLWELCO' AND create_date < prg_date;
     DELETE FROM uac_working_flow WHERE flow_code = 'EDTLOAD' AND create_date < prg_date;
     DELETE FROM uac_working_flow WHERE flow_code = 'QUEASSI' AND create_date < prg_date;


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

            -- *****************************************************
            -- START: Breakfix B01 16Nov
            -- We do not know the reason but we know how to solve it
            -- *****************************************************

            UPDATE uac_load_scan SET status = 'NEW', scan_username = REPLACE(scan_username, 'q', 'a')
              WHERE status = 'MIS'
              AND scan_date = CURRENT_DATE
              AND scan_time > (CURRENT_TIME - INTERVAL 1 HOUR);
            UPDATE uac_load_scan SET status = 'NEW', scan_username = REPLACE(scan_username, 'z', 'w')
              WHERE status = 'MIS'
              AND scan_date = CURRENT_DATE
              AND scan_time > (CURRENT_TIME - INTERVAL 1 HOUR);
              
            -- *****************************************************
            -- END: Breakfix B01 16Nov
            -- *****************************************************

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

    -- Delete all old dates/ uas_scan will be purged in ASSIDUITE
    DELETE FROM uac_load_scan WHERE scan_date < prg_date;

    -- This is deleting the migration flow only
    DELETE FROM uac_working_flow WHERE flow_code = 'SCANXXX' AND create_date < prg_date;

END$$
-- Remove $$ for OVH
-- This push account without email to be sent
-- These account will be prepared to be sent in uac_mail
DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_MailWelcomeNewUser$$
CREATE PROCEDURE `SRV_CRT_MailWelcomeNewUser` ()
BEGIN
    DECLARE inv_flow_code	  CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    DECLARE count_mail	INTEGER;
    -- CALL SRV_PRG_Scan();

    SELECT 'MLWELCO' INTO inv_flow_code;

    -- SHALL WE RUN this process ?
    SELECT COUNT(1) INTO count_mail FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
    WHERE mu.id NOT IN (SELECT user_id FROM uac_mail
                    WHERE (flow_code, user_id) = (inv_flow_code, user_id));


    -- We do not find any email here
    IF (count_mail > 0) THEN

        -- We run the full process
        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        -- We need to insert missing new user without any email

        INSERT IGNORE INTO uac_mail (flow_id, flow_code, user_id, status)
          SELECT inv_flow_id, inv_flow_code, mu.id, 'NEW' FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username;




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
                    mu.matricule AS MATRICULE,
                    mu.email_par1 AS PARENT_EMAIL,
                    mu.firstname AS FIRSTNAME,
                    mu.lastname AS LASTNAME,
                    url_intranet AS ULR_INTRANET,
                    CONCAT(CAST(uas.secret AS CHAR),
                    UPPER(uas.username)) AS PAGE_ID_STU,
                    CONCAT(url_internet, '/profile/',CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE_URL
              FROM uac_mail um JOIN mdl_user mu ON mu.id = um.user_id
                                JOIN uac_showuser uas ON mu.username = uas.username
              WHERE um.status = 'INP' and um.flow_code = inv_flow_code;

              -- End of the flow correctly
              UPDATE uac_mail SET status = 'END', last_update = NOW() WHERE status = 'INP' and flow_code = inv_flow_code;
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


    DECLARE inv_time_stamp	DATETIME;
    DECLARE inv_date	      DATE;
    DECLARE inv_date_m12	  DATE;

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
                      AND urg.title = param_uagroupe;

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
        'X' AS course_status,
        0 AS day_code,
        0 AS hour_starts_at,
        0 AS duration_hour,
        NULL AS raw_course_title,
        NULL AS last_update;

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
                        AND urg.title = param_uagroupe;


      -- Delete old lines
      -- Delete old lines to keep only one for this cohort
      SELECT id INTO inv_old_master_id
              FROM uac_edt_master
              WHERE monday_ofthew = param_monday_date
              AND cohort_id = inv_cohort_id;

      -- **********************************************************
      -- Delete the assiduite
      -- **********************************************************
      DELETE FROM uac_assiduite WHERE edt_id IN (
        SELECT id FROM uac_edt_line WHERE master_id = inv_old_master_id
      );
      DELETE FROM uac_edt_line WHERE master_id = inv_old_master_id;
      DELETE FROM uac_edt_master WHERE id = inv_old_master_id;

      -- Proceed to new lines !

      INSERT INTO uac_edt_master (flow_id, cohort_id, monday_ofthew) VALUES (inv_flow_id, inv_cohort_id, param_monday_date);
      SELECT LAST_INSERT_ID() INTO inv_master_id;

      INSERT INTO uac_edt_line (master_id, label_day, day, day_code, hour_starts_at, duration_hour, raw_course_title, course_status)
            SELECT inv_master_id, label_day, day, day_code, hour_starts_at, duration_hour,
                    -- Remove the A: in the file
                    CASE WHEN (raw_course_title like 'A:%') OR (raw_course_title like 'H:%') OR (raw_course_title like 'O:%')
                      THEN TRIM(SUBSTRING(raw_course_title, 3, length(raw_course_title))) ELSE TRIM(raw_course_title) END,
                    CASE
                          WHEN raw_course_title like 'A:%' THEN 'C'
                          -- H is for Hors Site when it is not Manankambahiny
                          WHEN raw_course_title like 'H:%' THEN 'H'
                          -- O is for Optionnal when course is not required
                          WHEN raw_course_title like 'O:%' THEN 'O'
                          -- A is for Active
                          ELSE 'A' END
            FROM uac_load_edt
            WHERE status = 'INP'
            AND flow_id = inv_flow_id;



      -- Remove duplicate
      UPDATE uac_working_flow uwf SET uwf.status = 'DUP'
      WHERE uwf.flow_code = 'QUEASSI'
      AND uwf.status IN ('NEW', 'QUE')
      AND uwf.working_date IN (
        SELECT DISTINCT ule.day FROM uac_load_edt ule
        WHERE ule.flow_id = inv_flow_id
      );


      -- Recalculate Assiduite If they have been in the past Add recalculation line here !!!
      SELECT CURRENT_DATE INTO inv_date;
      SELECT CURRENT_TIMESTAMP INTO inv_time_stamp;
      SELECT DATE_ADD(inv_date, INTERVAL -12 DAY) INTO inv_date_m12;


      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update)
            SELECT DISTINCT 'QUEASSI', 'NEW', day, 0, filename, inv_time_stamp
            FROM uac_load_edt
            WHERE flow_id = inv_flow_id
            AND status = 'INP'
            AND day < inv_date
            AND inv_date_m12 < day;

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
        uel.raw_course_title AS raw_course_title,
        uel.course_status AS course_status,
        DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
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
              'X' AS course_status,
              NULL AS raw_course_title,
              NULL AS last_update;
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
                  uel.raw_course_title AS raw_course_title,
                  /*
                  CASE WHEN (uel.course_status = 'C') THEN CONCAT('<i class="err"><strong>ANNULÉ</strong>: <i class="ua-line">', uel.raw_course_title, '</i></i>') ELSE uel.raw_course_title END AS html_raw_course_title,
                  CASE WHEN (uel.duration_hour MOD 2 = 1) THEN (uel.duration_hour DIV 2) + 1 ELSE (uel.duration_hour DIV 2) END AS html_start_disp,
                  (uel.duration_hour MOD 2) AS html_odd_even,
                  */
                  uel.course_status AS course_status,
                  DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
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
                   uel.raw_course_title AS raw_course_title,
                   uel.course_status AS course_status,
                   DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
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
                 -- We need another order because we do not display per line here
                 ORDER BY uel.day_code, uel.hour_starts_at ASC;


         END IF;
    END IF;
END$$
-- Remove $$ for OVH



DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_MngEDTp3$$
CREATE PROCEDURE `CLI_GET_MngEDTp3` ()
BEGIN
    DECLARE monday_m_one	DATE;
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

    -- Specific day calulation from Monday zero
    SELECT DATE_ADD(monday_zero, INTERVAL -7 DAY) INTO monday_m_one;

    SELECT * FROM (
        SELECT * FROM (SELECT 'S-1' AS s, 0 AS inv_w, DATE_FORMAT(monday_m_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update,
                            UPPER(CONCAT('S-1', DATE_FORMAT(monday_m_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility = 'V'
                                                          AND uem.monday_ofthew = monday_m_one ORDER BY cohort_id ASC) as a
        UNION ALL
        SELECT * FROM (SELECT 'S0' AS s, 0 AS inv_w, DATE_FORMAT(monday_zero, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update,
                            UPPER(CONCAT('S0', DATE_FORMAT(monday_zero, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility = 'V'
                                                          AND uem.monday_ofthew = monday_zero ORDER BY cohort_id ASC) as b
        UNION ALL
        SELECT * FROM (SELECT 'S1' AS s, 1 AS inv_w, DATE_FORMAT(monday_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update,
                            UPPER(CONCAT('S1', DATE_FORMAT(monday_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility = 'V'
                                                          AND uem.monday_ofthew = monday_one ORDER BY cohort_id ASC) as c
        UNION ALL
        SELECT * FROM (SELECT	'S2' AS s, 2 AS inv_w, DATE_FORMAT(monday_two, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update,
                            UPPER(CONCAT('S2', DATE_FORMAT(monday_two, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility = 'V'
                                                          AND uem.monday_ofthew = monday_two ORDER BY cohort_id ASC) as d
        UNION ALL
        SELECT * FROM (SELECT 'S3' AS s, 3 AS inv_w, DATE_FORMAT(monday_three, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update,
                            UPPER(CONCAT('S3', DATE_FORMAT(monday_three, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility = 'V'
                                                          AND uem.monday_ofthew = monday_three ORDER BY cohort_id ASC) as e
        ) union_all_tab ORDER BY tech_last_update DESC;

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
      uel.raw_course_title AS raw_course_title,
      uel.course_status AS course_status,
      DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
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
DROP PROCEDURE IF EXISTS SRV_CRT_JQEDT$$
CREATE PROCEDURE `SRV_CRT_JQEDT` (IN param_stamp INT, IN param_monday_date DATE, IN param_cohort_id INT, IN param_order CHAR(1))
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;

    DECLARE inv_master_id	BIGINT;
    DECLARE inv_old_master_id	BIGINT;


    DECLARE inv_time_stamp	DATETIME;
    DECLARE inv_date	      DATE;
    DECLARE inv_date_m12	  DATE;
    DECLARE count_que_recal	SMALLINT;

    DECLARE sunday_date	DATE;

    -- CALL SRV_PRG_Scan();
    -- EDTLOAD

    SELECT 'EDTLOAD' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, CONCAT(param_cohort_id, '_', CONVERT(param_stamp, CHAR)), NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    -- Here we update all load lines with the same stamp
    UPDATE uac_load_jqedt SET flow_id = inv_flow_id, status = 'INP' WHERE tag_stamp_for_export = param_stamp AND cohort_id = param_cohort_id AND status = 'NEW';

    -- No error is possible on the cohort ID as we have the correct information

    -- Delete old lines
    -- Delete old lines to keep only one for this cohort
    SELECT id INTO inv_old_master_id
            FROM uac_edt_master
            WHERE monday_ofthew = param_monday_date
            AND cohort_id = param_cohort_id;

    -- **********************************************************
    -- Delete the assiduite
    -- **********************************************************
    DELETE FROM uac_assiduite WHERE edt_id IN (
      SELECT id FROM uac_edt_line WHERE master_id = inv_old_master_id
    );
    DELETE FROM uac_edt_line WHERE master_id = inv_old_master_id;
    DELETE FROM uac_edt_master WHERE id = inv_old_master_id;


    -- Proceed to new lines !
    -- Add the timestamp for Madagascar timezone
    INSERT INTO uac_edt_master (flow_id, cohort_id, monday_ofthew, visibility, jq_edt_type, last_update) VALUES (inv_flow_id, param_cohort_id, param_monday_date, param_order, 'Y', DATE_ADD(UTC_TIMESTAMP(), INTERVAL 3 HOUR));
    SELECT LAST_INSERT_ID() INTO inv_master_id;

    -- uac_edt_line INSERT HERE
    INSERT INTO uac_edt_line (
      master_id,
      label_day,
      course_status,
      day,
      day_code,
      hour_starts_at,
      duration_hour,
      raw_course_title,
      room_id,
      min_starts_at,
      duration_min,
      course_id,
      start_time,
      end_time,
      teacher_id,
      shift_duration)
          SELECT
          inv_master_id,
          label_day,
          course_status,
          tech_date,
          day_code,
          hour_starts_at,
          duration_hour,
          raw_course_title,
          room_id,
          min_starts_at,
          duration_min,
          course_id,
          start_time,
          end_time,
          teacher_id,
          shift_duration
          FROM uac_load_jqedt
          WHERE status = 'INP'
          AND flow_id = inv_flow_id;

    -- Recalculate Assiduite If they have been in the past Add recalculation line here !!!
    SELECT CURRENT_DATE INTO inv_date;
    SELECT CURRENT_TIMESTAMP INTO inv_time_stamp;
    SELECT DATE_ADD(inv_date, INTERVAL -12 DAY) INTO inv_date_m12;


    SELECT DATE_ADD(param_monday_date, INTERVAL 6 DAY) INTO sunday_date;

    -- Remove duplicate
    UPDATE uac_working_flow uwf SET uwf.status = 'DUP'
    WHERE uwf.flow_code = 'QUEASSI'
    AND uwf.status IN ('NEW', 'QUE')
    AND uwf.working_date < inv_date
    AND uwf.working_date < sunday_date
    AND uwf.working_date >= param_monday_date;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update)
          SELECT DISTINCT 'QUEASSI', 'NEW', DATE_ADD(param_monday_date, INTERVAL dq.id DAY), 0, CONCAT(param_cohort_id, '_', CONVERT(param_stamp, CHAR)), inv_time_stamp
            FROM uac_ref_day_queue dq
            WHERE dq.id < 6
            AND DATE_ADD(param_monday_date, INTERVAL dq.id DAY) < CURRENT_DATE
            AND inv_date_m12 < DATE_ADD(param_monday_date, INTERVAL dq.id DAY);


    SELECT 0 INTO count_que_recal;
    SELECT COUNT(1) INTO count_que_recal
      FROM uac_ref_day_queue dq
      WHERE dq.id < 6
      AND DATE_ADD(param_monday_date, INTERVAL dq.id DAY) < CURRENT_DATE
      AND inv_date_m12 < DATE_ADD(param_monday_date, INTERVAL dq.id DAY);


    UPDATE uac_load_jqedt SET status = 'END' WHERE flow_id = inv_flow_id AND status = 'INP';
    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW() WHERE id = inv_flow_id;

    -- Return the result with flow ID and the number of day recalculated
    SELECT
      inv_flow_id AS flow_id,
      count_que_recal AS day_recalc,
      DATE_FORMAT(NOW(), '%d/%m/%Y %H:%i') AS last_update;

END$$
-- Remove $$ for OVH

DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_MngEDTp3$$
CREATE PROCEDURE `CLI_GET_MngEDTp3` (IN param_allow_draft_read CHAR(1))
BEGIN
    DECLARE monday_m_one	DATE;
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;
    DECLARE monday_two	DATE;
    DECLARE monday_three	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_monday_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;
    DECLARE count_result_set	INT;


    DECLARE draft_value_set	CHAR(1);

    IF (param_allow_draft_read = 'Y') THEN
      SELECT 'D' INTO draft_value_set;
    ELSE
      -- 0 is a value we must never use for this
      SELECT '0' INTO draft_value_set;
    END IF;


    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_two;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 21 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_three;

    -- Specific day calulation from Monday zero
    SELECT DATE_ADD(monday_zero, INTERVAL -7 DAY) INTO monday_m_one;

    SELECT * FROM (
        SELECT * FROM (SELECT 'S-1' AS s, -1 AS inv_w, DATE_FORMAT(monday_m_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S-1', DATE_FORMAT(monday_m_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_m_one ORDER BY cohort_id ASC) as a
        UNION ALL
        SELECT * FROM (SELECT 'S0' AS s, 0 AS inv_w, DATE_FORMAT(monday_zero, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S0', DATE_FORMAT(monday_zero, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_zero ORDER BY cohort_id ASC) as b
        UNION ALL
        SELECT * FROM (SELECT 'S1' AS s, 1 AS inv_w, DATE_FORMAT(monday_one, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S1', DATE_FORMAT(monday_one, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_one ORDER BY cohort_id ASC) as c
        UNION ALL
        SELECT * FROM (SELECT	'S2' AS s, 2 AS inv_w, DATE_FORMAT(monday_two, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S2', DATE_FORMAT(monday_two, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_two ORDER BY cohort_id ASC) as d
        UNION ALL
        SELECT * FROM (SELECT 'S3' AS s, 3 AS inv_w, DATE_FORMAT(monday_three, "%d/%m") AS monday_ofthew, uc.id AS cohort_id, urm.title AS mention, uc.niveau AS niveau, urp.title AS parcours, urg.title AS groupe, uem.id AS master_id, uem.visibility AS visibility, uem.monday_ofthew AS inv_monday,
                            DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update, uem.last_update AS tech_last_update, uem.visibility AS uem_visibility, uem.jq_edt_type AS uem_jq_edt_type,
                            UPPER(CONCAT('S3', DATE_FORMAT(monday_three, "%d/%m"), uc.id, urm.title, uc.niveau, urp.title, CASE WHEN uem.id IS NULL THEN 'MANQUANT' ELSE 'CHARGE' END)) AS raw_data
                            FROM uac_cohort uc
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                              LEFT JOIN uac_edt_master uem ON uem.cohort_id = uc.id
                                                          AND uem.visibility IN ('V', draft_value_set)
                                                          AND uem.monday_ofthew = monday_three ORDER BY cohort_id ASC) as e
        ) union_all_tab ORDER BY tech_last_update DESC;

END$$
-- Remove $$ for OVH

-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_SHOWJQEDTForADM$$
CREATE PROCEDURE `CLI_GET_SHOWJQEDTForADM` (IN param_master_id VARCHAR(25), IN param_allow_note_read CHAR(1))
BEGIN
    -- We must now how many line we have because if there is no line because no course we cannot fail
    DECLARE count_edt_line	SMALLINT;

    SELECT COUNT(1) INTO count_edt_line
    FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                          JOIN uac_cohort uc ON uc.id = uem.cohort_id
                          JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                          JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                          JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                          JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                          JOIN uac_ref_room urr ON urr.id = uel.room_id
                          JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
    WHERE uem.id = param_master_id
    AND uem.visibility IN ('V', 'D');

    IF (count_edt_line > 0) THEN

          IF (param_allow_note_read = 'Y') THEN
                SELECT
                  uem.id AS master_id,
                  uem.jq_edt_type AS jq_edt_type,
                  uem.visibility AS visibility,
                  uem.cohort_id AS cohort_id,
                  vcc.short_classe AS short_classe,
                  urm.par_code AS mention_code,
                  urm.title AS mention,
                  uc.niveau AS niveau,
                  urp.title AS parcours,
                  urg.title AS groupe,
                  DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                  DATE_FORMAT(uel.day, "%d/%m") AS nday,
                  DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                  uel.day_code AS day_code,
                  uel.hour_starts_at AS uel_hour_starts_at,
                  uel.duration_hour AS uel_duration_hour,
                  fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                  uel.course_status AS course_status,
                  uel.course_id AS course_id,
                  uel.duration_min AS uel_duration_min,
                  uel.min_starts_at AS uel_min_starts_at,
                  uel.end_time AS uel_end_time,
                  uel.start_time AS uel_start_time,
                  uel.shift_duration AS uel_shift_duration,
                  uel.label_day AS uel_label_day,
                  urr.id AS urr_id,
                  urr.name AS urr_name,
                  urr.capacity AS room_capacity,
                  urt.id AS teacher_id,
                  urt.name AS teacher_name,
                  DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
                FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                      JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                      JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                      JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                      JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                      JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_ref_room urr ON urr.id = uel.room_id
                                      JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                      JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
                WHERE uem.id = param_master_id
                AND uem.visibility IN ('V', 'D')
                ORDER BY uel.hour_starts_at, uel.day_code ASC;
          ELSE
              -- Notes are note allowed for this user
              SELECT
                uem.id AS master_id,
                uem.jq_edt_type AS jq_edt_type,
                uem.visibility AS visibility,
                uem.cohort_id AS cohort_id,
                vcc.short_classe AS short_classe,
                urm.par_code AS mention_code,
                urm.title AS mention,
                uc.niveau AS niveau,
                urp.title AS parcours,
                urg.title AS groupe,
                DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                DATE_FORMAT(uel.day, "%d/%m") AS nday,
                DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                uel.day_code AS day_code,
                uel.hour_starts_at AS uel_hour_starts_at,
                uel.duration_hour AS uel_duration_hour,
                fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                uel.course_status AS course_status,
                uel.course_id AS course_id,
                uel.duration_min AS uel_duration_min,
                uel.min_starts_at AS uel_min_starts_at,
                uel.end_time AS uel_end_time,
                uel.start_time AS uel_start_time,
                uel.shift_duration AS uel_shift_duration,
                uel.label_day AS uel_label_day,
                urr.id AS urr_id,
                urr.name AS urr_name,
                urr.capacity AS room_capacity,
                urt.id AS teacher_id,
                urt.name AS teacher_name,
                DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
              FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                    JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                    JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                    JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                    JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                    JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                    JOIN uac_ref_room urr ON urr.id = uel.room_id
                                    JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                    JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
              WHERE uem.id = param_master_id
              AND uem.visibility IN ('V')
              AND uel.course_status NOT IN ('1', '2')
              ORDER BY uel.hour_starts_at, uel.day_code ASC;
          END IF;

    ELSE
    SELECT
          uem.id AS master_id,
          uem.jq_edt_type AS jq_edt_type,
          uem.visibility AS visibility,
          uem.cohort_id AS cohort_id,
          vcc.short_classe AS short_classe,
          urm.par_code AS mention_code,
          urm.title AS mention,
          uc.niveau AS niveau,
          urp.title AS parcours,
          urg.title AS groupe,
          DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
          DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
          NULL AS nday,
          NULL AS tech_date,
          NULL AS day_code,
          NULL AS hour_starts_at,
          NULL AS duration_hour,
          NULL AS raw_course_title,
          NULL AS course_status,
          NULL AS course_id,
          NULL AS uel_duration_min,
          NULL AS uel_min_starts_at,
          NULL AS uel_end_time,
          NULL AS uel_start_time,
          NULL AS uel_shift_duration,
          NULL AS uel_label_day,
          NULL AS urr_id,
          NULL AS urr_name,
          NULL AS room_capacity,
          0 AS teacher_id,
          NULL AS teacher_name,
          DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
          FROM uac_edt_master uem
          JOIN uac_cohort uc ON uc.id = uem.cohort_id
                            JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                            JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                  WHERE uem.id = param_master_id;
    END IF;

END$$
-- Remove $$ for OVH


-- Read the EDT for a specific username
-- param_bkp is to read the EDT per line if the display does not work
-- Display EDT for specific username
-- Does not see any note 1 or 2
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_FWEDTJQ$$
CREATE PROCEDURE `CLI_GET_FWEDTJQ` (IN param_username VARCHAR(25), IN param_week TINYINT, IN param_bkp CHAR(1))
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
              'N' AS jq_edt_type,
              NULL AS mention,
              NULL AS niveau,
              NULL AS parcours,
              NULL AS groupe,
              NULL AS label_day_fr,
              DATE_FORMAT(inv_monday_date, "%Y-%m-%d") AS inv_tech_monday,
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS monday,
              -- To be removed as duplicate old fashion
              DATE_FORMAT(inv_monday_date, "%d/%m/%Y") AS mondayw,
              DATE_FORMAT(inv_cur_date, "%d/%m") AS nday,
              0 AS day_code,
              0 AS hour_starts_at,
              0 AS duration_hour,
              'X' AS course_status,
              0 AS urr_id,
              'X' AS urr_name,
              'X' AS course_id,
              0 AS duration_min,
              0 AS min_starts_at,
              NULL AS end_time,
              NULL AS start_time,
              0 AS shift_duration,
              NULL AS raw_course_title,
              0 AS teacher_id,
              NULL AS teacher_name,
              NULL AS last_update;
    ELSE
      -- We have result
          IF (param_bkp = 'N') THEN
                -- Return the list for control
                SELECT
                  uem.id AS master_id,
                  uem.jq_edt_type AS jq_edt_type,
                  uem.visibility AS visibility,
                  uem.cohort_id AS cohort_id,
                  vcc.short_classe AS short_classe,
                  urm.title AS mention,
                  uc.niveau AS niveau,
                  urp.title AS parcours,
                  urg.title AS groupe,
                  DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS monday,
                  -- To be removed as duplicate old fashion
                  DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                  DATE_FORMAT(uel.day, "%d/%m") AS nday,
                  DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                  uel.day_code AS day_code,
                  uel.hour_starts_at AS uel_hour_starts_at,
                  -- To be removed as duplicate old fashion
                  uel.hour_starts_at AS hour_starts_at,
                  uel.duration_hour AS uel_duration_hour,
                  -- To be removed as duplicate old fashion
                  uel.duration_hour AS duration_hour,
                  fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                  uel.course_status AS course_status,
                  urr.id AS urr_id,
                  urr.name AS urr_name,
                  urr.capacity AS room_capacity,
                  uel.course_id AS course_id,
                  uel.duration_min AS uel_duration_min,
                  uel.min_starts_at AS uel_min_starts_at,
                  uel.end_time AS uel_end_time,
                  uel.start_time AS uel_start_time,
                  uel.shift_duration AS uel_shift_duration,
                  urt.id AS teacher_id,
                  urt.name AS teacher_name,
                  uel.label_day AS uel_label_day,
                  DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
                FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                      JOIN uac_cohort uc ON uc.id = uem.cohort_id
                            				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                            					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                            					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                            					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_ref_room urr ON urr.id = uel.room_id
                                      JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                      JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                WHERE uem.monday_ofthew = inv_monday_date
                AND uem.visibility = 'V'
                AND uel.course_status NOT IN ('1', '2')
                ORDER BY uel.hour_starts_at, uel.day_code ASC;

         ELSE
                 -- Return the list for control
                 SELECT
                   uem.id AS master_id,
                   uem.jq_edt_type AS jq_edt_type,
                   uem.visibility AS visibility,
                   uem.cohort_id AS cohort_id,
                   vcc.short_classe AS short_classe,
                   urm.title AS mention,
                   uc.niveau AS niveau,
                   urp.title AS parcours,
                   urg.title AS groupe,
                   CASE
                      WHEN uel.day_code = 0 THEN "LUNDI"
                      WHEN uel.day_code = 1 THEN "MARDI"
                      WHEN uel.day_code = 2 THEN "MERCREDI"
                      WHEN uel.day_code = 3 THEN "JEUDI"
                      WHEN uel.day_code = 4 THEN "VENDREDI"
                      ELSE "SAMEDI"
                      END AS label_day_fr,
                   DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                   DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS monday,
                  -- To be removed as duplicate old fashion
                   DATE_FORMAT(uem.monday_ofthew, "%d/%m/%Y") AS mondayw,
                   DATE_FORMAT(uel.day, "%d/%m") AS nday,
                   DATE_FORMAT(uel.day, "%Y-%m-%d") AS tech_date,
                   uel.day_code AS day_code,
                   uel.hour_starts_at AS uel_hour_starts_at,
                  -- To be removed as duplicate old fashion
                   uel.hour_starts_at AS hour_starts_at,
                   uel.duration_hour AS uel_duration_hour,
                  -- To be removed as duplicate old fashion
                  uel.duration_hour AS duration_hour,
                   fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                   uel.course_status AS course_status,
                    urr.id AS urr_id,
                    urr.name AS urr_name,
                    urr.capacity AS room_capacity,
                    uel.course_id AS course_id,
                    uel.duration_min AS uel_duration_min,
                    uel.min_starts_at AS uel_min_starts_at,
                    uel.end_time AS uel_end_time,
                    uel.start_time AS uel_start_time,
                    uel.shift_duration AS uel_shift_duration,
                    urt.id AS teacher_id,
                    urt.name AS teacher_name,
                    uel.label_day AS uel_label_day,
                   DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
                 FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                       JOIN uac_cohort uc ON uc.id = uem.cohort_id
                             				  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                             					JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                             					JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                             					JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                      JOIN uac_ref_room urr ON urr.id = uel.room_id
                                      JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                      JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
                                      JOIN uac_showuser uas ON uas.cohort_id = uem.cohort_id
                                                            AND uas.username = param_username
                 WHERE uem.monday_ofthew = inv_monday_date
                 AND uem.visibility = 'V'
                 AND uel.course_status NOT IN ('1', '2')
                 -- We need another order because we do not display per line here
                 ORDER BY uel.day_code, uel.hour_starts_at ASC;


         END IF;
    END IF;
END$$
-- Remove $$ for OVH


-- The export expect value as CHAR(1) 0, 1 or D and D i for the current day
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_EDTTextExport$$
CREATE PROCEDURE `CLI_GET_EDTTextExport` (IN param_type CHAR(1))
BEGIN
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;

    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    IF (param_type = '0') THEN
                SELECT
                 'S0' AS inv_s,
                 uem.id AS master_id,
                 uem.cohort_id AS cohort_id,
                 vcc.short_classe AS short_classe,
                 CASE
                    WHEN uel.day_code = 0 THEN "LUNDI"
                    WHEN uel.day_code = 1 THEN "MARDI"
                    WHEN uel.day_code = 2 THEN "MERCREDI"
                    WHEN uel.day_code = 3 THEN "JEUDI"
                    WHEN uel.day_code = 4 THEN "VENDREDI"
                    ELSE "SAMEDI"
                    END AS label_day_fr,
                 DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
                 DATE_FORMAT(uel.day, "%d/%m") AS nday,
                 fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
                 uel.course_status AS course_status,
                  urr.id AS urr_id,
                  urr.name AS urr_name,
                  uel.duration_min AS uel_duration_min,
                  uel.min_starts_at AS uel_min_starts_at,
                  uel.end_time AS uel_end_time,
                  uel.start_time AS uel_start_time,
                  urt.id AS teacher_id,
                  urt.name AS teacher_name,
                 DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
               FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                     JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                    JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                    JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                    JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                    JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                    JOIN uac_ref_room urr ON urr.id = uel.room_id
                                    JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                    JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
               WHERE uem.monday_ofthew = monday_zero
               AND uem.visibility = 'V'
               AND uem.jq_edt_type = 'Y'
               AND uel.course_status NOT IN ('1', '2')
               ORDER BY uem.cohort_id, uel.day_code, uel.hour_starts_at ASC;
    ELSEIF (param_type = '1')  THEN
              SELECT
               'S1' AS inv_s,
               uem.id AS master_id,
               uem.cohort_id AS cohort_id,
               vcc.short_classe AS short_classe,
               CASE
                  WHEN uel.day_code = 0 THEN "LUNDI"
                  WHEN uel.day_code = 1 THEN "MARDI"
                  WHEN uel.day_code = 2 THEN "MERCREDI"
                  WHEN uel.day_code = 3 THEN "JEUDI"
                  WHEN uel.day_code = 4 THEN "VENDREDI"
                  ELSE "SAMEDI"
                  END AS label_day_fr,
               DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
               DATE_FORMAT(uel.day, "%d/%m") AS nday,
               fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
               uel.course_status AS course_status,
                urr.id AS urr_id,
                urr.name AS urr_name,
                uel.duration_min AS uel_duration_min,
                uel.min_starts_at AS uel_min_starts_at,
                uel.end_time AS uel_end_time,
                uel.start_time AS uel_start_time,
                urt.id AS teacher_id,
                urt.name AS teacher_name,
               DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
             FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                   JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                  JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                  JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                  JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                  JOIN uac_ref_room urr ON urr.id = uel.room_id
                                  JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                  JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
             WHERE uem.monday_ofthew = monday_one
             AND uem.visibility = 'V'
             AND uem.jq_edt_type = 'Y'
             AND uel.course_status NOT IN ('1', '2')
             ORDER BY uem.cohort_id, uel.day_code, uel.hour_starts_at ASC;
    ELSEIF (param_type = 'D')  THEN
              SELECT
               'D' AS inv_s,
               uem.id AS master_id,
               uem.cohort_id AS cohort_id,
               vcc.short_classe AS short_classe,
               CASE
                  WHEN uel.day_code = 0 THEN "LUNDI"
                  WHEN uel.day_code = 1 THEN "MARDI"
                  WHEN uel.day_code = 2 THEN "MERCREDI"
                  WHEN uel.day_code = 3 THEN "JEUDI"
                  WHEN uel.day_code = 4 THEN "VENDREDI"
                  ELSE "SAMEDI"
                  END AS label_day_fr,
               DATE_FORMAT(uem.monday_ofthew, "%Y-%m-%d") AS inv_tech_monday,
               DATE_FORMAT(uel.day, "%d/%m") AS nday,
               fEscapeLineFeed(fEscapeStr(uel.raw_course_title)) AS raw_course_title,
               uel.course_status AS course_status,
                urr.id AS urr_id,
                urr.name AS urr_name,
                uel.duration_min AS uel_duration_min,
                uel.min_starts_at AS uel_min_starts_at,
                uel.end_time AS uel_end_time,
                uel.start_time AS uel_start_time,
                urt.id AS teacher_id,
                urt.name AS teacher_name,
               DATE_FORMAT(uem.last_update, "%d/%m %H:%i") AS last_update
             FROM uac_edt_line uel JOIN uac_edt_master uem ON uem.id = uel.master_id
                                   JOIN uac_cohort uc ON uc.id = uem.cohort_id
                                  JOIN uac_ref_mention urm ON urm.par_code = uc.mention
                                  JOIN uac_ref_niveau urn ON urn.par_code = uc.niveau
                                  JOIN uac_ref_parcours urp ON urp.id = uc.parcours_id
                                  JOIN uac_ref_groupe urg ON urg.id = uc.groupe_id
                                  JOIN uac_ref_room urr ON urr.id = uel.room_id
                                  JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
                                  JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
             WHERE uem.last_update > CURRENT_DATE
             AND uem.monday_ofthew <= CURRENT_DATE
             AND uem.visibility = 'V'
             AND uem.jq_edt_type = 'Y'
             AND uel.course_status NOT IN ('1', '2')
             ORDER BY uem.cohort_id, uel.day_code, uel.hour_starts_at ASC;
    END IF;
END$$
-- Remove $$ for OVH


-- The export expect value as CHAR(1) 0, 1 or D and D i for the current day
-- We tell here if the EDT is empty or missing
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_GET_EDTTextExportWarningS0S1$$
CREATE PROCEDURE `CLI_GET_EDTTextExportWarningS0S1` ()
BEGIN
    DECLARE monday_zero	DATE;
    DECLARE monday_one	DATE;

    DECLARE inv_cur_date	DATE;
    DECLARE inv_cur_dayw	TINYINT;

    -- Monday Zero
    SELECT DAYOFWEEK(CURRENT_DATE) INTO inv_cur_dayw;
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_zero;

    SELECT DATE_ADD(CURRENT_DATE, INTERVAL 7 DAY) INTO inv_cur_date;
    SELECT DATE_ADD(inv_cur_date, INTERVAL -(inv_cur_dayw - 2) DAY) INTO monday_one;

    SELECT
        'S0' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'M' AS status,
        monday_zero AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id NOT IN (SELECT cohort_id FROM uac_edt_master WHERE monday_ofthew = monday_zero AND visibility = 'V')
    UNION
    SELECT
        'S0' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'E' AS status,
        monday_zero AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id IN (SELECT cohort_id FROM uac_edt_master uem LEFT JOIN uac_edt_line uel
                                                                  ON uel.master_id = uem.id
                                                                  AND uem.visibility = 'V'
                                                                  AND uel.course_status IN ('A', 'H', 'O', 'C')
                                          WHERE uem.monday_ofthew = monday_zero
                                          AND uel.id IS NULL
                                          -- OR uel.id IS NOT NULL AND NOT EXISTS uel.course_status IN (A, H, O, C)
                                          )
    UNION
    SELECT
        'S1' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'M' AS status,
        monday_one AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id NOT IN (SELECT cohort_id FROM uac_edt_master WHERE monday_ofthew = monday_one AND visibility = 'V')
    UNION
    SELECT
        'S1' AS inv_s,
        vcc.id AS vcc_id,
        vcc.short_classe AS vcc_short_classe,
        'E' AS status,
        monday_one AS monday_ofthew
        FROM v_class_cohort vcc
        WHERE vcc.id IN (SELECT cohort_id FROM uac_edt_master uem LEFT JOIN uac_edt_line uel
                                                                  ON uel.master_id = uem.id
                                                                  AND uem.visibility = 'V'
                                                                  AND uel.course_status IN ('A', 'H', 'O', 'C')
                                          WHERE uem.monday_ofthew = monday_one
                                          AND uel.id IS NULL
                                          -- OR uel.id IS NOT NULL AND NOT EXISTS uel.course_status IN (A, H, O, C)
                                          )
    ORDER BY 1, 2, 4 DESC;


END$$
-- Remove $$ for OVH

-- Legacy to be dropped
-- DROP PROCEDURE IF EXISTS CLI_GET_SHOWEDTForADM$$
-- DROP PROCEDURE IF EXISTS CLI_GET_FWEDT$$
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
    DECLARE inv_edt_ends	TINYINT;
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
          AND ue.course_status = 'A'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.duration_hour > 0
          AND CONVERT(
                CONCAT(
                  CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                    THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                    -- we consider the cours which are finished after 25min otherwise they will be consider after
                    -- wait_b_compute ':25:00'
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
              AND ue.course_status = 'A'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.duration_hour > 0
              AND CONVERT(
                    CONCAT(
                      CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                        THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                        -- wait_b_compute ':20:00'
                        wait_b_compute), TIME) < inv_time;

          -- We need to consider only involved cohort_id and with visibility V
          SELECT cohort_id INTO inv_cohort_id FROM uac_edt_master WHERE id IN (SELECT master_id FROM uac_edt_line WHERE ID = inv_edt_id AND VISIBILITY = 'V');

          -- Initialize the hour start at & hour ends
          SELECT hour_starts_at INTO inv_edt_starts FROM uac_edt_line WHERE id = inv_edt_id;
          SELECT (hour_starts_at + duration_hour) INTO inv_edt_ends FROM uac_edt_line WHERE id = inv_edt_id;
          -- Je suis sensé bosser sur les cohorts id !!!


          -- ABS part 1 *** *** *** *** *** *** *** ***
          -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
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
                    -- late_definition is like ':15:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username
          					) t_student_in
          		);

          -- People here are not ABS1
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
                    -- late_definition is like ':15:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username, usa.user_id, usa.scan_date
          					) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
												AND sca.user_id = t_student_in.user_id
												AND sca.scan_date = t_student_in.scan_date
                        -- the student went out before end of begining
												AND sca.in_out = 'O'
          		);

          -- People here are not ABS1 nor ABS2
          -- QUI : Quit when the student is leaving before the end of the course
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_ends) = 1) THEN CONCAT('0', inv_edt_ends) ELSE inv_edt_ends END, ':00:00'), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'O'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'O';

          -- People here are not ABS1 nor ABS2 nor QUI
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

          -- People here are not ABS1 nor ABS2 nor QUI nor LAT
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



DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_ResetAssdFlow$$
CREATE PROCEDURE `SRV_CRT_ResetAssdFlow` (IN param DATE)
BEGIN

    DECLARE inv_flow_code	CHAR(7);
    DECLARE concurrent_flow INT;
    DECLARE inv_flow_id	BIGINT;


    SELECT 'RESASSI' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
      -- A flow is running we input a CAN line
      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'CAN', CURRENT_DATE, 0, NOW());
    ELSE
      -- Previous RUN has finished
      -- We can work !

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        -- If the parameter is null, we consider the day of today !
        IF param IS NULL THEN
            -- statements ;
            -- Do not support empty
            UPDATE uac_working_flow SET status = 'ERR', comment = 'Missing param date', last_update = NOW() WHERE id = inv_flow_id;

       ELSE
            -- statements ;
            -- Do the work
            -- *********************************************
            -- B01: There is an issue here !
            -- Seems that the EDT have been deleted already !!!
            -- *********************************************
            DELETE FROM uac_assiduite WHERE edt_id IN (
              SELECT id FROM uac_edt_line WHERE day = param
            );

            UPDATE uac_edt_line SET compute_late_status = 'NEW' WHERE day = param;

       END IF;
       -- Manage Date NULL
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('Reset Assiduite day: ', param) WHERE id = inv_flow_id;

    END IF;
END$$
-- Remove $$ for OVH

DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_RUN_PastAssiduite$$
CREATE PROCEDURE `SRV_RUN_PastAssiduite` ()
BEGIN
    DECLARE inv_date	DATE;
    DECLARE inv_uwf_id	BIGINT;
    DECLARE count_past_todo INT;
    DECLARE i INT default 0;
    SET i = 0;

    -- We need to loop all past days
    SELECT COUNT(1) INTO count_past_todo
      FROM uac_working_flow uwf WHERE uwf.status = 'QUE';

    WHILE i < count_past_todo DO
      -- INITIALIZATION
      SELECT MAX(id) INTO inv_uwf_id
          FROM uac_working_flow uwf WHERE uwf.status = 'QUE';

      SELECT working_date INTO inv_date
          FROM uac_working_flow uwf WHERE id = inv_uwf_id;

      -- Do the reset actually and recalculation
      -- But be carefull we do it for the full new all day !
      CALL SRV_CRT_ResetAssdFlow(inv_date);
      CALL SRV_CRT_ComptAssdFlow(inv_date);

      UPDATE uac_working_flow SET status = 'END', comment = 'Run by Queue batch', last_update = NOW() WHERE id = inv_uwf_id;

      SET i = i + 1;
    END WHILE;


END$$
-- Remove $$ for OVH


DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_PRG_Ass$$
CREATE PROCEDURE `SRV_PRG_Ass` ()
BEGIN
    DECLARE prg_date	DATE;
    DECLARE prg_history_delta	INT;
    -- CALL SRV_PRG_Scan();

    SELECT par_int INTO prg_history_delta FROM uac_param WHERE key_code = 'ASSIPRG';
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -prg_history_delta DAY) INTO prg_date;

    -- Delete all old dates/ uas SCAN will be purged in ASSIDUITE
    DELETE FROM uac_scan WHERE scan_date < prg_date;
    -- We need to keep the off days for traceability purpose
    -- DELETE FROM uac_assiduite_off WHERE working_date < prg_date;
    DELETE FROM uac_assiduite WHERE edt_id IN (SELECT id FROM uac_edt_line WHERE day < prg_date) AND status IN ('PON');

    DELETE FROM uac_working_flow WHERE flow_code = 'ASSIDUI' AND create_date < prg_date;

END$$
-- Remove $$ for OVH
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHLAT', 'Half late consideration minute LAT', 15, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHVLA', 'Half Very late consideration minute VLA', 59, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('ASSHWAI', 'Half late consideration minute', 25, NULL);

INSERT IGNORE INTO uac_param (key_code, description, par_time, par_code) VALUES ('LSTCRSD', 'Last course time end of the day', '18:00:00', NULL);

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

    DECLARE late_jq_definition INT;
    DECLARE very_late_jq_definition INT;
    DECLARE wait_jq_b_compute INT;

    DECLARE inv_edt_id	BIGINT;
    DECLARE inv_edt_starts	TINYINT;
    DECLARE inv_edt_ends	TINYINT;
    DECLARE count_courses_todo INT;
    DECLARE count_courses_total INT;
    DECLARE inv_cohort_id	BIGINT;
    DECLARE inv_shifduration TINYINT;

    DECLARE inv_edt_starts_in_time	TIME;
    DECLARE inv_edt_ends_in_time	TIME;

    DECLARE all_course_finished_time	TIME;

    DECLARE i INT default 0;
    SET i = 0;
    SET count_courses_total = 0;
    SET inv_shifduration = 0;




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

    -- Last time of course to calculate no exit NEX
    SELECT par_time INTO all_course_finished_time FROM uac_param WHERE key_code = 'LSTCRSD';



    SELECT 'ASSIDUI' INTO inv_flow_code;
    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE status = 'NEW' AND flow_code = inv_flow_code;

    IF concurrent_flow > 0 THEN
      -- A flow is running we input a CAN line
      INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'CAN', inv_date, 0, NOW());
    ELSE
      -- Previous RUN has finished
      -- We can work !

        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (inv_flow_code, 'NEW', inv_date, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        SELECT par_value INTO late_definition FROM uac_param WHERE key_code = 'ASSLATE';
        SELECT par_value INTO wait_b_compute FROM uac_param WHERE key_code = 'ASSWAIT';

        -- PARAMETERS FOR JQ EDT
        SELECT par_int INTO very_late_jq_definition FROM uac_param WHERE key_code = 'ASSHVLA';
        SELECT par_int INTO late_jq_definition FROM uac_param WHERE key_code = 'ASSHLAT';
        SELECT par_int INTO wait_jq_b_compute FROM uac_param WHERE key_code = 'ASSHWAI';

        -- BODY START
        -- Part one of two because we will redo the same for JQ
        -- We need to loop all courses of the day
        SELECT COUNT(1) INTO count_courses_todo
          FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
          AND ue.course_status = 'A'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.duration_hour > 0
          -- We check the JQ here
          -- For old fashion we dont check visibility here so visibility with I can move to END
          AND ue.master_id IN (
            SELECT id FROM uac_edt_master WHERE jq_edt_type = 'N'
          )
          AND CONVERT(
                CONCAT(
                  CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                    THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                    -- we consider the cours which are finished after 25min otherwise they will be consider after
                    -- wait_b_compute ':25:00'
                    wait_b_compute), TIME) < inv_time;

        -- ********************************************
        -- ********************************************
        -- *************** START NOT JQ ***************
        -- ********************************************
        -- ********************************************
        -- Old fashion for NOT JQ
        WHILE i < count_courses_todo DO

          -- INITIALIZATION
          SELECT MAX(id) INTO inv_edt_id
              FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
              AND ue.course_status = 'A'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.duration_hour > 0
              -- We check the JQ here
              -- For old fashion we dont check visibility here so visibility with I can move to END
              AND ue.master_id IN (
                SELECT id FROM uac_edt_master WHERE jq_edt_type = 'N'
              )
              AND CONVERT(
                    CONCAT(
                      CASE WHEN (CHAR_LENGTH(ue.hour_starts_at + ue.duration_hour) = 1)
                        THEN CONCAT('0', ue.hour_starts_at + ue.duration_hour) ELSE ue.hour_starts_at + ue.duration_hour END,
                        -- wait_b_compute ':20:00'
                        wait_b_compute), TIME) < inv_time;

          -- We need to consider only involved cohort_id and with visibility V
          SELECT cohort_id INTO inv_cohort_id FROM uac_edt_master WHERE id IN (SELECT master_id FROM uac_edt_line WHERE ID = inv_edt_id AND VISIBILITY = 'V');

          -- Initialize the hour start at & hour ends
          SELECT hour_starts_at INTO inv_edt_starts FROM uac_edt_line WHERE id = inv_edt_id;
          SELECT (hour_starts_at + duration_hour) INTO inv_edt_ends FROM uac_edt_line WHERE id = inv_edt_id;
          -- Je suis sensé bosser sur les cohorts id !!!

          -- NOT JQ
          -- ABS part 1 *** *** *** *** *** *** *** ***
          -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
          -- Final list of student missing or late over 15min !
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
                    -- late_definition is like ':15:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username
          					) t_student_in
          		);

          -- NOT IN JQ
          -- People here are not ABS1
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
                    -- late_definition is like ':15:00' Saying max 10 min late
          					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, late_definition), TIME)
                    AND usa.scan_date = inv_date
                    group by mu.username, usa.user_id, usa.scan_date
          					) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
												AND sca.user_id = t_student_in.user_id
												AND sca.scan_date = t_student_in.scan_date
                        -- the student went out before end of begining
												AND sca.in_out = 'O'
          		);

          -- People here are not ABS1 nor ABS2
          -- QUI : Quit when the student is leaving before the end of the course
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_starts) = 1) THEN CONCAT('0', inv_edt_starts) ELSE inv_edt_starts END, ':00:00'), TIME)
          AND usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(inv_edt_ends) = 1) THEN CONCAT('0', inv_edt_ends) ELSE inv_edt_ends END, ':00:00'), TIME)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'O'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
          			   JOIN mdl_user mu on mu.username = uas.username
          			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
          			   	  							  AND max_scan.scan_time = scan_in
          			   	  							  AND max_scan.in_out = 'O';

          -- People here are not ABS1 nor ABS2 nor QUI
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

          -- People here are not ABS1 nor ABS2 nor QUI nor LAT
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

          -- End the loop WHILE part one of two
          UPDATE uac_edt_line SET compute_late_status = 'END', last_update = NOW() WHERE id = inv_edt_id;
          SET i = i + 1;
        END WHILE;

        SET count_courses_total = count_courses_total + count_courses_todo;
        -- ********************************************
        -- ********************************************
        -- ************** END PART 1/2 ****************
        -- ********************************************
        -- ********************************************

        -- Part two of two because we will redo the same for JQ
        -- We need to loop all courses of the involved day and we restart the job
        -- We consider shift duration and timing per minute
        SELECT COUNT(1) INTO count_courses_todo
          FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
          AND ue.course_status = 'A'
          AND ue.day = inv_date
          -- We take only not empty courses
          AND ue.shift_duration > 0
          -- We check the JQ here
          -- For old fashion we dont check visibility here so visibility with I can move to END
          -- In new style we consider only V (we dont consider I or D)
          AND ue.master_id IN (
            SELECT id FROM uac_edt_master WHERE jq_edt_type = 'Y' AND visibility = 'V'
          )
          AND DATE_ADD(
            		CONVERT(
            		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
            					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
            					),
                -- wait_jq_b_compute is the minute we wait end of the cours
            		TIME),interval (wait_jq_b_compute + (ue.shift_duration * 30)) minute) < inv_time;

        -- START THE LOOP AGAIN !
        -- ********************************************
        -- ********************************************
        -- ***************** START JQ *****************
        -- ********************************************
        -- ********************************************
        -- New fashion for JQ
        SET i = 0;
        WHILE i < count_courses_todo DO
          -- In the loop
          -- Do something here
          -- INITIALIZATION
          SELECT MAX(id) INTO inv_edt_id
              FROM uac_edt_line ue WHERE ue.compute_late_status = 'NEW'
              AND ue.course_status = 'A'
              AND ue.day = inv_date
              -- We take only not empty courses
              AND ue.shift_duration > 0
              -- We check the JQ here
              -- For old fashion we dont check visibility here so visibility with I can move to END
              -- In new style we consider only V (we dont consider I or D)
              AND ue.master_id IN (
                SELECT id FROM uac_edt_master WHERE jq_edt_type = 'Y' AND visibility = 'V'
              )
              AND DATE_ADD(
                		CONVERT(
                		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
                					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
                					),
                    -- wait_jq_b_compute is the minute we wait end of the cours
                		TIME),interval (wait_jq_b_compute + (ue.shift_duration * 30)) minute) < inv_time;


          -- We need to consider only involved cohort_id and with visibility V and JQ Y
          SELECT cohort_id INTO inv_cohort_id FROM uac_edt_master WHERE id IN (SELECT master_id FROM uac_edt_line WHERE ID = inv_edt_id);

          -- INITIALIZATION OF SHIFT START AND END IN TIME
          -- *******************************************************************************
          -- Initialize shift duration hour start at & hour ends
          -- Shift duration we need to know if the course is longer than 1 hour
          SELECT shift_duration INTO inv_shifduration FROM uac_edt_line WHERE id = inv_edt_id;
          -- Get the start time : inv_edt_starts_in_time
          SELECT CONVERT(
                		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
                					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
                					),
                		TIME) INTO inv_edt_starts_in_time FROM uac_edt_line ue WHERE ue.id = inv_edt_id;
          -- Get the end time : inv_edt_ends_in_time
          SELECT DATE_ADD(
                		CONVERT(
                		CONCAT(CASE WHEN (CHAR_LENGTH(ue.hour_starts_at) = 1) THEN CONCAT('0', ue.hour_starts_at) ELSE ue.hour_starts_at END, ':',
                					CASE WHEN (CHAR_LENGTH(ue.min_starts_at) = 1) THEN CONCAT('0', ue.min_starts_at) ELSE ue.min_starts_at END, ':00'
                					),
                		TIME), interval (ue.shift_duration * 30) minute) INTO inv_edt_ends_in_time FROM uac_edt_line ue WHERE ue.id = inv_edt_id;
          -- *******************************************************************************


          IF (inv_shifduration > 2) THEN
            -- In that case we are longer than one hour

            -- We need to handle the very late
            -- I am JQ
            -- Longer than one hour !
            -- ABS part 1 *** *** *** *** *** *** *** ***
            -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
            -- Final list of student missing or late over 15min !
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
                      -- very late definition is like '59' Saying max 59 min late
            					WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval very_late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username
            					) t_student_in
              );

            -- I AM JQ
            -- Longer than one hour !
            -- People here are not ABS1
            -- ABS part 2 *** *** *** *** *** *** *** ***
            -- On met ceux qui sont sortis juste avant le +59
            -- MISSING LINK with the correct COHORT ID !
            -- Final list of student missing or late over 59min !
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
                      -- very late definition is like '59' Saying max 59 min late
                      WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval very_late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username, usa.user_id, usa.scan_date
                      ) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
                          AND sca.user_id = t_student_in.user_id
                          AND sca.scan_date = t_student_in.scan_date
                          -- the student went out before end of begining
                          AND sca.in_out = 'O'
                );
            -- I AM JQ
            -- Longer than one hour !
            -- People here are not ABS1 nor ABS2
            -- QUI : Quit when the student is leaving before the end of the course
            INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
            SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
            -- List of people who entered between 7:00 and 7:10
            SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
            JOIN mdl_user mu on usa.user_id = mu.id
            WHERE usa.scan_time > inv_edt_starts_in_time
            AND usa.scan_time < inv_edt_ends_in_time
            AND usa.scan_date = inv_date
            GROUP BY mu.username, in_out
            HAVING in_out = 'O'
            ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                                 AND uas.cohort_id = inv_cohort_id
            			   JOIN mdl_user mu on mu.username = uas.username
            			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
            			   	  							  AND max_scan.scan_time = scan_in
            			   	  							  AND max_scan.in_out = 'O';

            -- I AM JQ
            -- Longer than one hour !
            -- People here are not ABS1 nor ABS2 nor QUI
            -- LAT *** *** *** *** *** *** *** ***
            -- MISSING LINK with the correct COHORT ID !
            -- Final list of student late 59min max !
            INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
            SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'VLA' FROM (
            -- List of people who entered between 7:00 and 7:10
            SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
            JOIN mdl_user mu on usa.user_id = mu.id
            WHERE usa.scan_time > DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
            AND usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval very_late_jq_definition minute)
            AND usa.scan_date = inv_date
            GROUP BY mu.username, in_out
            HAVING in_out = 'I'
            ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                                 AND uas.cohort_id = inv_cohort_id
            			   JOIN mdl_user mu on mu.username = uas.username
            			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
            			   	  							  AND max_scan.scan_time = scan_in
            			   	  							  AND max_scan.in_out = 'I';


          -- Now we work for course less than one hour
          ELSE
            -- In that case we are not lesser than one hour
            -- We do not handle the very late
            -- In that case we are longer than one hour

            -- We do not handle the very late
            -- I am JQ
            -- Lesser than one hour !
            -- ABS part 1 *** *** *** *** *** *** *** ***
            -- On met ceux qu'on n'ont NI ENTRÉE NI SORTI
            -- Final list of student missing or late over 15min !
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
                      -- very late definition is like '59' Saying max 59 min late
            					WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username
            					) t_student_in
              );

            -- I AM JQ
            -- Lesser than one hour !
            -- People here are not ABS1
            -- ABS part 2 *** *** *** *** *** *** *** ***
            -- On met ceux qui sont sortis juste avant le +59
            -- MISSING LINK with the correct COHORT ID !
            -- Final list of student missing or late over 59min !
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
                      -- very late definition is like '59' Saying max 59 min late
                      WHERE usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
                      AND usa.scan_date = inv_date
                      group by mu.username, usa.user_id, usa.scan_date
                      ) t_student_in JOIN uac_scan sca ON sca.scan_time = scan_in
                          AND sca.user_id = t_student_in.user_id
                          AND sca.scan_date = t_student_in.scan_date
                          -- the student went out before end of begining
                          AND sca.in_out = 'O'
                );

                -- Note that QUI, LAT and PON are common to longer or lesser than 1 hour
                -- I AM JQ
                -- Lesser than one hour !
                -- People here are not ABS1 nor ABS2
                -- QUI : Quit when the student is leaving before the end of the course
                INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
                SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'QUI' FROM (
                -- List of people who entered between 7:00 and 7:10
                SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
                JOIN mdl_user mu on usa.user_id = mu.id
                WHERE usa.scan_time > inv_edt_starts_in_time
                AND usa.scan_time < inv_edt_ends_in_time
                AND usa.scan_date = inv_date
                GROUP BY mu.username, in_out
                HAVING in_out = 'O'
                ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                                     AND uas.cohort_id = inv_cohort_id
                         JOIN mdl_user mu on mu.username = uas.username
                            JOIN uac_scan max_scan ON max_scan.user_id = mu.id
                                            AND max_scan.scan_time = scan_in
                                            AND max_scan.scan_date = inv_date
                                            AND max_scan.in_out = 'O';
          -- End of the duration > 2
          END IF;

          -- I AM JQ
          -- Common part
          -- People here are not ABS1 nor ABS2 nor QUI not VLA
          -- LAT *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Final list of student late 59min max !
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'LAT' FROM (
          -- List of people who entered between 7:00 and 7:10
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time > inv_edt_starts_in_time
          AND usa.scan_time < DATE_ADD(inv_edt_starts_in_time, interval late_jq_definition minute)
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
                   JOIN mdl_user mu on mu.username = uas.username
                      JOIN uac_scan max_scan ON max_scan.user_id = mu.id
                                      AND max_scan.scan_time = scan_in
                                      AND max_scan.scan_date = inv_date
                                      AND max_scan.in_out = 'I';

          -- I AM JQ
          -- Longer than one hour !
          -- People here are not ABS1 nor ABS2 nor QUI nor LAT
          -- PON *** *** *** *** *** *** *** ***
          -- MISSING LINK with the correct COHORT ID !
          -- Student on time
          INSERT IGNORE INTO uac_assiduite (flow_id, user_id, edt_id, scan_id, status)
          SELECT inv_flow_id, mu.id, inv_edt_id, max_scan.id AS scan_id, 'PON' FROM (
          -- List of people who entered but not exit before 7:00
          SELECT mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE usa.scan_time < inv_edt_starts_in_time
          AND usa.scan_date = inv_date
          GROUP BY mu.username, in_out
          HAVING in_out = 'I'
          ) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
                                               AND uas.cohort_id = inv_cohort_id
                   JOIN mdl_user mu on mu.username = uas.username
                      JOIN uac_scan max_scan ON max_scan.user_id = mu.id
                                      AND max_scan.scan_time = scan_in
                                      AND max_scan.scan_date = inv_date
                                      AND max_scan.in_out = 'I';



          -- End the loop WHILE part two of two
          UPDATE uac_edt_line SET compute_late_status = 'END', last_update = NOW() WHERE id = inv_edt_id;
          SET i = i + 1;

        END WHILE;
        SET count_courses_total = count_courses_total + count_courses_todo;

        -- ********************************************
        -- ********************************************
        -- ****************** SEND ********************
        -- ********************************************
        -- ********************************************

        -- *****************************************************************************
        -- *****************************************************************************
        -- ****************** START : HANDLE THE NO EXIT TO BE ABSENT ******************
        -- *****************************************************************************
        -- *****************************************************************************

        IF (CURRENT_TIME > all_course_finished_time) OR (CURRENT_DATE > inv_date) THEN
          -- DELETE ALL Lines for involved date
          DELETE FROM uac_assiduite_noexit WHERE inv_nex_date = inv_date;

          -- Fill it again
          INSERT IGNORE INTO uac_assiduite_noexit (user_id, max_scan_id, max_edt_id, inv_nex_date)
          -- Do an update with this couple of value
          SELECT max_scan.user_id, max_scan.id, MAX(uel.id), inv_date FROM (
                    -- List of last scan of people
                    SELECT mu.id AS mu_id, usa.scan_date AS nooutscan_date, max(usa.scan_time) AS scan_in from uac_scan usa
                    JOIN mdl_user mu on usa.user_id = mu.id
                    WHERE 1=1
                    -- For these specific dates
                    AND usa.scan_date = inv_date
                    GROUP BY mu.id, usa.scan_date
                    ) t_student_noout JOIN uac_scan max_scan
                                            -- Match the full scan if it is I
                                            ON max_scan.user_id = t_student_noout.mu_id
                                            AND max_scan.scan_time = scan_in
                                            AND max_scan.scan_date = t_student_noout.nooutscan_date
                                            AND max_scan.in_out = 'I'
                                      -- Need to know if he as been PON/LAT etc
                                      JOIN uac_assiduite uaa
                                              ON uaa.user_id = max_scan.user_id
                                             -- AND max_scan.id = uaa.scan_id
                                             AND uaa.status IN ('PON', 'LAT', 'VLA', 'QUI')
                                        JOIN uac_edt_line uel
                                        ON uel.id = uaa.edt_id
                                        AND uel.day = max_scan.scan_date
                                    JOIN v_showuser vsh ON vsh.id = max_scan.user_id
                                    JOIN v_class_cohort vcc ON vcc.id = vsh.cohort_id
                     GROUP BY max_scan.user_id, max_scan.id;

          -- We calculate here the student who has not exit for the end of the day
          UPDATE uac_assiduite
            SET status = 'NEX',
            last_update = CURRENT_TIMESTAMP
            WHERE (user_id, edt_id) IN (
              SELECT user_id, max_edt_id FROM uac_assiduite_noexit WHERE inv_nex_date = inv_date
            );

          -- UPDATE All lines which has been before the last entry no exit to ABS
          UPDATE uac_assiduite
            SET status = 'ABS',
            last_update = CURRENT_TIMESTAMP
            WHERE status NOT IN ('NEX')
            AND (user_id, scan_id) IN (
              SELECT user_id, max_scan_id FROM uac_assiduite_noexit WHERE inv_nex_date = inv_date
            );
          -- ELSE : Nothing to do
        END IF;
        -- *****************************************************************************
        -- *****************************************************************************
        -- ******************  STOP : HANDLE THE NO EXIT TO BE ABSENT  *****************
        -- *****************************************************************************
        -- *****************************************************************************


        -- BODY END
        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('EDT updated: ', count_courses_total) WHERE id = inv_flow_id;

    END IF;
END$$
-- Remove $$ for OVH


-- Legacy  delete these ones
-- both following will be deprecated
-- INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSLATE', 'Late maximum consideration', ':15:00', NULL, NULL);
-- INSERT IGNORE INTO uac_param (key_code, description, par_value, par_int, par_code) VALUES ('ASSWAIT', 'Attente script avant compute', ':25:00', NULL, NULL);



DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_PRG_Ass$$
CREATE PROCEDURE `SRV_PRG_Ass` ()
BEGIN
    DECLARE prg_date	DATE;
    DECLARE prg_history_delta	INT;
    -- CALL SRV_PRG_Scan();

    SELECT par_int INTO prg_history_delta FROM uac_param WHERE key_code = 'ASSIPRG';
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -prg_history_delta DAY) INTO prg_date;

    -- Delete all old dates/ uas SCAN will be purged in ASSIDUITE
    DELETE FROM uac_scan WHERE scan_date < prg_date;
    -- We need to keep the off days for traceability purpose
    -- DELETE FROM uac_assiduite_off WHERE working_date < prg_date;
    DELETE FROM uac_assiduite WHERE edt_id IN (SELECT id FROM uac_edt_line WHERE day < prg_date) AND status IN ('PON');

    DELETE FROM uac_assiduite_noexit WHERE inv_nex_date < prg_date;

    DELETE FROM uac_working_flow WHERE flow_code = 'ASSIDUI' AND create_date < prg_date;

END$$
-- Remove $$ for OVH
-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_CRT_PayFac$$
CREATE PROCEDURE `CLI_CRT_PayFac` (IN param_user_id BIGINT, IN param_ticket_ref CHAR(10), IN param_ticket_type CHAR(1), IN param_red_pc TINYINT)
BEGIN
    DECLARE inv_status	CHAR(1);

    -- END OF DECLARE

    -- Set the correct status value
    IF param_ticket_type = 'L' THEN
        SELECT 'A' INTO inv_status;
    ELSEIF param_ticket_type = 'M' THEN
        SELECT 'A' INTO inv_status;
    ELSE
        SELECT 'I' INTO inv_status;
    END IF;


    INSERT INTO uac_facilite_payment (user_id, ticket_ref, category, red_pc, status) VALUES ( param_user_id, param_ticket_ref, param_ticket_type, param_red_pc, inv_status);

END$$
-- Remove $$ for OVH
/*
TO BE RUN
-- Migrate Administration

INSERT INTO mdl_userx (id, username, firstname, lastname, email, phone1, address, city, matricule, genre, datedenaissance)
SELECT mu.id, mu.username, mu.firstname, mu.lastname, mu.email, '0344950074', 'PRVO 26B', 'Manakambahiny', 'na', 'X', '1970-01-01'
FROM mdl_user mu
WHERE mu.id IN (SELECT ua.id FROM uac_admin ua)

-- Deploy the changes
-- Load the picutes !!!
https://drive.google.com/file/d/1w3e_7l-mzQiULzzcF_-UX-aWUrqryjVe/view?usp=share_link

1w3e_7l-mzQiULzzcF_-UX-aWUrqryjVe

-- DO the migration !!!


-- ATOMIC BOMB
RENAME TABLE mdl_user TO mdl_user_old, mdl_userx TO mdl_user;

+++ Reload ALL Views !!!


*/


DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_LOAD_MDLUser$$
CREATE PROCEDURE `MAN_LOAD_MDLUser` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_PRG_Scan();

    SELECT 'MANLODU' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    UPDATE mdl_load_user SET flow_id = inv_flow_id WHERE status = 'NEW';

    UPDATE mdl_load_user SET lastname = TRIM(UPPER(lastname)), last_update = NOW() WHERE flow_id = inv_flow_id;
    UPDATE mdl_load_user SET firstname = TRIM(CONCAT(UPPER(SUBSTRING(firstname,1,1)),LOWER(SUBSTRING(firstname,2)))), last_update = NOW() WHERE flow_id = inv_flow_id;

    UPDATE mdl_load_user SET phone_mvola = NULL, last_update = NOW() WHERE phone_mvola = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET autre_prenom = NULL, last_update = NOW() WHERE autre_prenom = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET compte_fb = NULL, last_update = NOW() WHERE compte_fb = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET numero_cin = NULL, last_update = NOW() WHERE numero_cin = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET lieu_cin = NULL, last_update = NOW() WHERE lieu_cin = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET nom_pnom_par1 = NULL, last_update = NOW() WHERE nom_pnom_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET email_par1 = NULL, last_update = NOW() WHERE email_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET phone_par1 = NULL, last_update = NOW() WHERE phone_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET profession_par1 = NULL, last_update = NOW() WHERE profession_par1 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET nom_pnom_par2 = NULL, last_update = NOW() WHERE nom_pnom_par2 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET phone_par2 = NULL, last_update = NOW() WHERE phone_par2 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET profession_par2 = NULL, last_update = NOW() WHERE profession_par2 = '' AND flow_id = inv_flow_id;
    UPDATE mdl_load_user SET centres_interets = NULL, last_update = NOW() WHERE centres_interets = '' AND flow_id = inv_flow_id;

    UPDATE mdl_load_user SET core_status_matrimonial = SUBSTRING(situation_matrimoniale, 1, 1), last_update = NOW() WHERE flow_id = inv_flow_id;

    -- ************************************
    -- ************************************
    -- Complexity here is for the set up **
    -- ************************************
    -- ************************************
    UPDATE mdl_load_user INNER JOIN v_class_cohort
                                  ON mdl_load_user.cohorte_short_name = v_class_cohort.short_classe
    -- Here is the magic !
    SET mdl_load_user.core_cohort_id = v_class_cohort.id,
      mdl_load_user.last_update = NOW()
      WHERE mdl_load_user.flow_id = inv_flow_id;

    -- At this step we are NEW for each lines
    UPDATE mdl_load_user SET status = 'QUE', last_update = NOW() WHERE flow_id = inv_flow_id AND status = 'NEW';
    -- cohort id must be in uac_showuser;
    -- We need to check first the gsheet id versus id then do the load

    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Ready for import' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH


-- SELECT * FROM mig_check_id;

-- ************************************************************************
-- Do the changes if necessary ! ******************************************
-- ************************************************************************

-- ALREADY STOPPED the script SRV_UPD_UACShower

DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_CRT_MDLUser$$
CREATE PROCEDURE `MAN_CRT_MDLUser` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_PRG_Scan();

    SELECT 'MANMDLU' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;

    -- Loaded lines are QUEUED
    UPDATE mdl_load_user SET flow_id = inv_flow_id WHERE status = 'QUE';

    -- Do the load
    -- *********************************************************
    -- CHANGE MDL X ! ******************************************
    -- *********************************************************

    -- DO THE LOAD HERE TO WORK ON THE MDL USER

    INSERT INTO mdl_user
    (id, username, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
    SELECT
    gsheet_id, username, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, core_status_matrimonial, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
    FROM mdl_load_user WHERE status = 'QUE' AND flow_id = inv_flow_id;



    -- cohort id must be in uac_showuser;
    -- We need to check first the gsheet id versus id then do the load
    INSERT IGNORE INTO uac_showuser (roleid, username, cohort_id)
    SELECT 5, username, core_cohort_id FROM mdl_load_user WHERE status = 'QUE' AND flow_id = inv_flow_id;

    -- Add secret
    UPDATE uac_showuser SET secret = 3000000000 + FLOOR(RAND()*1000000000), last_update = NOW() WHERE secret IS NULL;


    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = 'Done for import' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH


-- COHORT ID to be udpated !!!
-- 1/ Create user
-- 2/ Add to course !!!

-- From Connection SP
-- 3/ Launch the UACShower
CALL SRV_UPD_UACShower();
-- 4/ update uac_showuser SET cohort_id = <correct cours ID> where cohort_id IS NULL;


-- ONLY FOR Test
/*
UPDATE uac_showuser uas SET uas.cohort_id = ((SELECT id FROM mdl_user mu WHERE mu.username = uas.username) % 48) + 1 WHERE uas.cohort_id IS NULL;
select MAX(cohort_id) from uac_showuser;
select MIN(cohort_id) from uac_showuser;
*/

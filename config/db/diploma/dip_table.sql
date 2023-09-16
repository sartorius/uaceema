DROP TABLE IF EXISTS uac_load_dip;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_dip` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `fullname` VARCHAR(300) NULL,
  `lastname` VARCHAR(150) NULL,
  `firstname` VARCHAR(150) NULL,
  `level` CHAR(1) NULL,
  `load_type` VARCHAR(5) NULL,
  `load_year` SMALLINT UNSIGNED NULL,
  `core_type` SMALLINT UNSIGNED NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- INSERT INTO uac_load_dip (fullname, level, load_type, load_year, lastname, firstname) VALUES ('


-- Keep secret on 3 digit
DROP TABLE IF EXISTS uac_dip;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_dip` (
  `id` BIGINT UNSIGNED NOT NULL,
  `level` CHAR(1) NULL,
  `year` SMALLINT UNSIGNED NULL,
  `lastname` VARCHAR(150) NULL,
  `firstname` VARCHAR(150) NULL,
  `code_name` CHAR(7) NULL,
  `core_type` SMALLINT UNSIGNED NULL,
  `secret` INT UNSIGNED NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

/*
INSERT INTO uac_dip (id, level, year, lastname, firstname, core_type)
  SELECT id, level, load_year, lastname, firstname, core_type FROM uac_load_dip WHERE status = 'INP';
*/

DROP TABLE IF EXISTS uac_ref_dip_type;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_dip_type` (
  `id` SMALLINT NOT NULL,
  `par_code` CHAR(5) NULL,
  `title` VARCHAR(50) NULL,
  `mention_code` CHAR(5) NULL,
  `description` VARCHAR(100) NULL,
PRIMARY KEY (`id`));

-- INSERT INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (

DROP TABLE IF EXISTS uac_ref_dip_year;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_dip_year` (
  `core_year` SMALLINT NOT NULL,
  `long_name` VARCHAR(7) NOT NULL,
  `title` VARCHAR(200) NOT NULL,
  `sponsor_name` VARCHAR(200) NULL,
  `description` VARCHAR(200) NULL,
PRIMARY KEY (`core_year`));

INSERT IGNORE INTO uac_ref_dip_year (core_year, long_name, title) VALUES (2022, '2021-22', 'Tsara Joro');

-- Data for set up
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (1,'PV','DROIT PRIVE', 'DROIT');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (2,'PUB','DROIT PUBLIC', 'DROIT');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (3,'CEP','COMMUNICATION ENTREPRISE ET PUBLICITAIRE', 'COMMU');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (4,'CMJ','COMMUNICATION MULTIMEDIA ET JOURNALISME', 'COMMU');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (5,'ACI','AUDIT ET CONTROLE INTERNE', 'GESTI');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (6,'MCI','MARKETING ET COMMERCE INTERNATIONAL', 'GESTI');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (7,'OPT','OPTICIEN OPTOMETRISTE', 'SIENS');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (8,'AGS','ADMINISTRATION ET GESTION DU SYSTEME DE SANTE', 'SIENS');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (9,'TBI','TECHNIQUES BIOMEDICALES', 'SIENS');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (10,'IMM','IMAGERIE MEDICALE', 'SIENS');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (11,'MBS','MADAGASCAR BUSINESS SCHOOL', 'MBSXX');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (12,'INF','INFORMATIQUE', 'INFOE');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (13,'COM','COMMUNICATION MULTISECTORIELLE', 'COMMU');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (14,'FAC','FINANCE AUDIT ET CONTROLE DE GESTION', 'GESTI');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (15,'MMC','MANAGEMENT MARKETING ET COMMERCE INTERNATIONAL', 'GESTI');
INSERT IGNORE INTO uac_ref_dip_type (id, par_code, title, mention_code) VALUES (16,'ECO','SCIENCES ECONOMIQUES ET ETUDES DU DEVELOPPEMENT', 'ECONO');



DROP VIEW IF EXISTS v_get_dip;
CREATE VIEW v_get_dip AS
SELECT
	ud.id AS UD_ID,
	fEscapeStr(ud.lastname) AS UD_LASTNAME,
	fEscapeStr(ud.firstname) AS UD_FIRSTNAME,
	ud.code_name AS UD_CODENAME,
	CONCAT(ud.secret, LPAD(ud.id, 7, '0')) AS UD_SECRET,
	ud.level AS UD_LEVEL,
	urdt.par_code AS URDT_CODE,
	urdt.mention_code AS URDT_MENTION_CODE,
	fEscapeStr(urdt.title) AS URDT_TYPE,
	urm.title AS URM_TITLE,
	urdy.core_year AS CORE_YEAR,
	urdy.long_name AS FULL_YEAR,
	urdy.title AS TITLE_YEAR,
  fEscapeLineFeed(fEscapeStr(UPPER(CONCAT(
    ud.lastname,
    ud.firstname,
    ud.code_name,
    urdt.mention_code,
    urdt.title,
    urm.title,
    urdy.title
  )))) AS raw_data
FROM uac_dip ud JOIN uac_ref_dip_type urdt ON ud.core_type = urdt.id
				JOIN uac_ref_dip_year urdy ON ud.year = urdy.core_year
					JOIN uac_ref_mention urm ON urdt.mention_code = urm.par_code
					ORDER BY ud.id ASC;

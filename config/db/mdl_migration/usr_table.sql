
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

-- this is to notify if we have data infos for the user;
DROP TABLE IF EXISTS uac_user_info;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_user_info` (
  `id` BIGINT UNSIGNED NOT NULL,
  `living_configuration` CHAR(1) NOT NULL DEFAULT 'F' COMMENT 'C is for Colocation, F is for Family, A is for Alone',
  `assiduite_info` VARCHAR(250) NULL,
  `agent_id` BIGINT UNSIGNED NOT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


/*
diarand072
INSERT INTO uac_user_info (`id`, `living_configuration`, `agent_id`) VALUES (94, 'F', 11);
julitot262
INSERT INTO uac_user_info (`id`, `living_configuration`, `agent_id`) VALUES (284, 'C', 11);
miadbru636
INSERT INTO uac_user_info (`id`, `living_configuration`, `agent_id`) VALUES (658, 'A', 11);

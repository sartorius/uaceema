DROP TABLE IF EXISTS histo_mdl_user;
CREATE TABLE `histo_mdl_user` (
  `id` bigint(20) unsigned NOT NULL,
  `username` char(10) NOT NULL,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone1` varchar(20) NOT NULL,
  `phone_mvola` varchar(20) DEFAULT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `matricule` varchar(45) NOT NULL,
  `autre_prenom` varchar(50) DEFAULT NULL,
  `genre` char(1) NOT NULL,
  `datedenaissance` date NOT NULL,
  `lieu_de_naissance` varchar(50) DEFAULT NULL,
  `situation_matrimoniale` char(1) DEFAULT NULL,
  `compte_fb` varchar(200) DEFAULT NULL,
  `etablissement_origine` varchar(200) DEFAULT NULL,
  `serie_bac` varchar(150) DEFAULT NULL,
  `annee_bac` smallint(6) DEFAULT NULL,
  `numero_cin` varchar(50) DEFAULT NULL,
  `date_cin` date DEFAULT NULL,
  `lieu_cin` varchar(50) DEFAULT NULL,
  `nom_pnom_par1` varchar(250) DEFAULT NULL,
  `email_par1` varchar(50) DEFAULT NULL,
  `phone_par1` varchar(20) DEFAULT NULL,
  `profession_par1` varchar(200) DEFAULT NULL,
  `adresse_par1` varchar(250) DEFAULT NULL,
  `city_par1` varchar(50) DEFAULT NULL,
  `nom_pnom_par2` varchar(250) DEFAULT NULL,
  `phone_par2` varchar(20) DEFAULT NULL,
  `profession_par2` varchar(200) DEFAULT NULL,
  `centres_interets` varchar(500) DEFAULT NULL,
  `school_year` SMALLINT unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE_2023` (`username`),
  UNIQUE KEY `email_UNIQUE_2023` (`email`)
);

INSERT IGNORE INTO histo_mdl_user
(school_year, id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
SELECT 2023, id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
FROM mdl_user mu WHERE mu.username IN (
    select uas.username from uac_showuser uas JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id AND vcc.niveau IN ('L2', 'L3')
);

-- Then delete
/*
DELETE FROM mdl_user WHERE username IN (
    select uas.username from uac_showuser uas JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id AND vcc.niveau = 'L1'
);

*/
DROP TABLE IF EXISTS histo_uac_showuser;
CREATE TABLE `histo_uac_showuser` (
  `username` varchar(30) NOT NULL,
  `roleid` tinyint(3) unsigned NOT NULL,
  `secret` int(10) unsigned DEFAULT NULL,
  `cohort_id` int(11) DEFAULT NULL,
  `school_year` SMALLINT unsigned NOT NULL,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`)
);

INSERT IGNORE INTO histo_uac_showuser (school_year, username, roleid, secret, cohort_id, last_update, create_date)
SELECT 2023, username, roleid, secret, cohort_id, last_update, create_date FROM uac_showuser uas_main WHERE uas_main.username IN (
    select uas.username from uac_showuser uas JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id AND vcc.niveau IN ('L1', 'L3')
);

-- Then delete

/*

DELETE FROM uac_showuser  WHERE username IN (
    SELECT huas.username FROM histo_uac_showuser huas WHERE huas.school_year = 2023
);

*/


DROP TABLE IF EXISTS reinscription_load_mdl_user;
CREATE TABLE `reinscription_load_mdl_user` (
  `id` bigint(20) unsigned NULL,
  `status` CHAR(3) DEFAULT 'NEW',
  `username` char(10) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `matricule` varchar(45) NOT NULL,
  `current_cohorte_short_name` VARCHAR(50) NOT NULL,
  `old_cohort_id` int(11) DEFAULT NULL,
  `current_cohort_id` int(11) DEFAULT NULL,
  `has_debt` char(1) NOT NULL DEFAULT 'N',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
);

-- INSERT INTO reinscription_load_mdl_user (username, email, firstname, lastname, matricule, current_cohorte_short_name, has_debt) VALUES (
-- INSERT INTO reinscription_load_mdl_user (username, email, firstname, lastname, matricule, current_cohorte_short_name, has_debt) VALUES ('DFRAKJN374','ratinahirana@gmail.com','READ','sdfsd','3242/SS/IIèA','L3/SCIEN/OPTIC/na','N');

DROP TABLE IF EXISTS debt_mdl_user;
CREATE TABLE `debt_mdl_user` (
  `user_id` bigint(20) unsigned NOT NULL,
  `old_cohort_id` int(11) NOT NULL,
  `current_cohort_id` int(11) NOT NULL,
  `current_school_year` SMALLINT unsigned NOT NULL,
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`, `current_school_year`)
);

-- INSERT INTO debt_mdl_user (user_id, old_cohort_id, current_cohort_id, current_school_year)
SELECT user_id, old_cohort_id, current_cohort_id, current_school_year FROM reinscription_load_mdl_user


select count(1) from histo_mdl_user;

INSERT IGNORE INTO histo_mdl_user
(school_year, id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
SELECT 2023, id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
FROM mdl_user mu WHERE mu.username IN (
    select uas.username from uac_showuser uas JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id AND vcc.niveau IN ('L2', 'L3')
);



select count(1) from histo_uac_showuser;

INSERT IGNORE INTO histo_uac_showuser (school_year, username, roleid, secret, cohort_id, last_update, create_date)
SELECT 2023, username, roleid, secret, cohort_id, last_update, create_date FROM uac_showuser uas_main WHERE uas_main.username IN (
    select uas.username from uac_showuser uas JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id AND vcc.niveau IN ('L2', 'L3')
);


DELETE FROM mdl_user WHERE username IN (
    select uas.username from uac_showuser uas JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id AND vcc.niveau IN ('L2', 'L3')
);



DELETE FROM uac_showuser  WHERE username IN (
    SELECT huas.username FROM histo_uac_showuser huas WHERE huas.school_year = 2023
);

-- OPTIMIZE TABLE mdl_user
-- OPTIMIZE TABLE uac_showuser



-- -----------------------------------------------------------------------------------------------
-- Count first how many assiduite then delete
select * from uac_assiduite ua where ua.user_id IN(
	select id from histo_mdl_user
);

delete from uac_assiduite ua where ua.user_id IN(
	select id from histo_mdl_user
);

OPTIMIZE TABLE uac_assiduite;

-- *************************************************************************************************************
-- New users

DELETE FROM mdl_load_user;
-- Must return nothing
SELECT mlu.username FROM mdl_load_user mlu WHERE mlu.username IN (SELECT mu.username FROM mdl_user mu);
-- Must return nothing
SELECT mlu.username FROM mdl_load_user mlu WHERE mlu.username IN (SELECT hmu.username FROM histo_mdl_user hmu);

CALL MAN_LOAD_MDLUser();
CALL MAN_CRT_MDLUser();



-- *************************************************************************************************************
-- REDOUBLANTS !!!

INSERT INTO mdl_user
(id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets)
SELECT id, username, last_update, create_date, firstname, lastname, email, phone1, phone_mvola, address, city, matricule, autre_prenom, genre, datedenaissance, lieu_de_naissance, situation_matrimoniale, compte_fb, etablissement_origine, serie_bac, annee_bac, numero_cin, date_cin, lieu_cin, nom_pnom_par1, email_par1, phone_par1, profession_par1, adresse_par1, city_par1, nom_pnom_par2, phone_par2, profession_par2, centres_interets
FROM histo_mdl_user hmu WHERE hmu.username IN ();

INSERT INTO uac_showuser (username, roleid, secret, cohort_id, last_update, create_date)
SELECT username, roleid, secret, cohort_id, last_update, create_date FROM histo_uac_showuser huas_main WHERE huas_main.username IN ();


DELETE FROM histo_mdl_user WHERE username IN ('sebalaz305', 'tokiraz267', 'antsrak314', 'tologau411');
DELETE FROM histo_uac_showuser WHERE username IN ('sebalaz305', 'tokiraz267', 'antsrak314', 'tologau411');

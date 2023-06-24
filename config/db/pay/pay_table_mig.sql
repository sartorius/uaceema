DROP TABLE IF EXISTS uac_load_eco_mig;
CREATE TABLE IF NOT EXISTS uac_load_eco_mig (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `load_niveau` CHAR(2),
  `load_line` VARCHAR(10),
  `load_matricule` VARCHAR(25),
  `load_name` VARCHAR(350),
  `load_t1` VARCHAR(25),
  `load_t2` VARCHAR(25),
  `load_t3` VARCHAR(25),
  `load_c4` VARCHAR(25),
  -- Core working here
  `temp_matricule_nbr` VARCHAR(25),
  `temp_matricule_mention` VARCHAR(10),
  `temp_name_a` VARCHAR(25),
  `temp_name_b` VARCHAR(25),
  `core_user_id` BIGINT UNSIGNED,
  `core_username` CHAR(10),
  `core_t1` INT,
  `core_t2` INT,
  `core_t3` INT,
  `comment` VARCHAR(100) NOT NULL DEFAULT '',
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));



CALL MAN_MIG_PrepareData();
SELECT MIN(id) FROM uac_load_eco_mig WHERE status IN ('AM1', 'AM2', 'AM3');
-- 3
SELECT MAX(id) FROM uac_load_eco_mig WHERE status IN ('AM1', 'AM2', 'AM3');
-- 1211

SELECT COUNT(1) FROM uac_load_eco_mig WHERE status IN ('AM1', 'AM2', 'AM3');
-- 781

CALL MAN_MIG_LoopEcolageFile(100);
-- 100
-- Then +200 per +200


-- INSERT INTO uac_load_eco_mig (load_line, load_matricule, load_name, load_t1, load_t2, load_t3, load_c4,load_niveau, temp_matricule_nbr, temp_matricule_mention) VALUES ();

/*
INSERT INTO uac_load_eco_mig (load_line, load_matricule, load_name, load_t1, load_t2, load_t3, load_c4, load_niveau, temp_matricule_nbr, temp_matricule_mention) VALUES ('1','1813/GE/IèA','RABEMANANTSOA Nomenjanahary Ronaldino','','','','2500000','L1','1813','GE');
select * from uac_load_eco_mig mig
where mig.load_matricule IN (
	select matricule from mdl_user
);
*/

-- Retrieve the inset line in https://docs.google.com/spreadsheets/d/1yefDhp_5Gqk5r11iuHc1U1WL5yf314lk44vKI5ku7fc/edit?usp=sharing
/*
UPDATE uac_load_eco_mig mig JOIN mdl_user mu ON mu.matricule = mig.load_matricule
		SET mig.core_user_id = mu.id,
        mig.core_username =  mu.username,
				mig.status = 'FND'
		WHERE mig.status = 'NEW';


UPDATE uac_load_eco_mig mig JOIN mdl_user mu ON CONCAT(mig.temp_matricule_nbr, '/', mig.temp_matricule_mention) = substring_index(mu.matricule, '/', 2)
		SET mig.core_user_id = mu.id,
        mig.core_username =  mu.username,
				mig.status = 'FND'
		WHERE mig.status = 'NEW';

-- Do the test again for the RID
UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'RI'
  WHERE mig.temp_matricule_mention = 'RID' AND mig.status = 'NEW';


-- Do the test again for the COM
UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'CO'
  WHERE mig.temp_matricule_mention = 'COM' AND mig.status = 'NEW';


-- Do the test again for the COM
UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT'
  WHERE mig.temp_matricule_mention = 'DTIV' AND mig.status = 'NEW';

-- Do the test again for the COM
UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT', mig.temp_matricule_nbr = '1436'
WHERE mig.temp_matricule_nbr = '1436DT' AND mig.status = 'NEW';

-- Do the test again for the COM
UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'GE', mig.temp_matricule_nbr = '2286'
WHERE mig.temp_matricule_nbr = '2286GE' AND mig.status = 'NEW';

-- Do the test again for the COM
UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT'
  WHERE mig.temp_matricule_mention = 'DTV' AND mig.status = 'NEW';

  -- Do the test again for the COM
  UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT'
    WHERE mig.temp_matricule_mention = 'DTD' AND mig.status = 'NEW';


UPDATE uac_load_eco_mig mig JOIN mdl_user mu ON CONCAT(mig.temp_matricule_nbr, '/', mig.temp_matricule_mention) = substring_index(mu.matricule, '/', 2)
		SET mig.core_user_id = mu.id,
        mig.core_username =  mu.username,
				mig.status = 'FND'
		WHERE mig.status = 'NEW';


-- UPDATE `table` SET `col_name` = REPLACE(`col_name`, ' ', '')
-- select field from table where field REGEXP '^-?[0-9]+$';
/*****************************************************************************************************/
/*****************************************************************************************************/
/*****************************************************************************************************/
/*****************************************************************************************************/
/*****************************            READ THE AMOUNT            *********************************/
/*****************************************************************************************************/
/*****************************************************************************************************/
/*****************************************************************************************************/
/*****************************************************************************************************/
/*****************************************************************************************************/

-- RESET
-- UPDATE uac_load_eco_mig mig SET mig.core_t1 = NULL, mig.core_t2 = NULL, mig.core_t3 = NULL, mig.status = 'FND'
-- WHERE mig.status NOT IN ('NEW');


/*
UPDATE uac_load_eco_mig mig SET mig.core_t1 = CAST(REPLACE(mig.load_t1, ' ', '') AS UNSIGNED), mig.status = 'AM1'
WHERE REPLACE(mig.load_t1, ' ', '') REGEXP '^-?[0-9]+$'
AND mig.load_t1 like '%00'
AND mig.status = 'FND';

UPDATE uac_load_eco_mig mig SET mig.core_t2 = CAST(REPLACE(mig.load_t2, ' ', '') AS UNSIGNED), mig.status = 'AM2'
WHERE REPLACE(mig.load_t2, ' ', '') REGEXP '^-?[0-9]+$'
AND mig.load_t2 like '%00'
AND mig.status IN ('AM1');

UPDATE uac_load_eco_mig mig SET mig.core_t3 = CAST(REPLACE(mig.load_t3, ' ', '') AS UNSIGNED), mig.status = 'AM3'
WHERE REPLACE(mig.load_t3, ' ', '') REGEXP '^-?[0-9]+$'
AND mig.load_t3 like '%00'
AND mig.status IN ('AM2');

UPDATE uac_load_eco_mig mig SET mig.status = 'TXT'
WHERE mig.status = 'FND';


-- We want to remove duplicate
UPDATE uac_load_eco_mig mig JOIN (
  SELECT core_user_id FROM uac_load_eco_mig mig
  WHERE core_user_id IS NOT NULL
  GROUP BY core_user_id
  HAVING COUNT(1) > 1
) AS t2 ON mig.core_user_id = t2.core_user_id
  SET mig.comment = CONCAT('Duplicat ', mig.status),
  mig.status = 'DUP'
  WHERE mig.status IN ('AM1', 'AM2', 'AM3');


  SELECT * FROM uac_load_eco_mig mig where mig.status = 'DUP';

CALL MAN_MIG_PrepareData();
SELECT MAX(id) FROM uac_load_eco_mig WHERE status IN ('AM1', 'AM2', 'AM3');
-- CALL MAN_MIG_LoopEcolageFile(XXX)

SELECT * FROM uac_load_eco_mig WHERE status = 'TXT';
SELECT * FROM uac_load_eco_mig WHERE status = 'EN1' AND load_t2 NOT IN ('');
SELECT * FROM uac_load_eco_mig WHERE status = 'EN2' AND load_t3 NOT IN ('');

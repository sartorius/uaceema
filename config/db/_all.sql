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
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('SCANPRG', 'Flow purge scan', 7, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILLI', 'Limit of email per day', 200, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILCT', 'Compteur limit of email per day', 0, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('DMAILBA', 'Batch email per day', 15, NULL);


DROP TABLE IF EXISTS uac_working_flow;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_working_flow` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_code` CHAR(7) NOT NULL,
  `status` CHAR(3) NOT NULL,
  `working_date` DATE NULL,
  `working_part` TINYINT NOT NULL DEFAULT 0,
  `last_update` DATETIME NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

  -- INSERT INTO (flow_code, status) VALUES ('SCANXXX', 'NEW');
DROP TABLE IF EXISTS uac_admin;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_admin` (
  `id` BIGINT NOT NULL,
  `pwd` VARCHAR(255) NOT NULL,
  `last_connection` DATETIME NULL,
  `scale_right` TINYINT(1) NOT NULL DEFAULT 0,
  `role` VARCHAR(60) NOT NULL,
  `accounting_write` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`));

-- /!\ IL FAUT AVOIR CRÉE LES UTILISATEURS AVANT DE CHARGER CES REQUÊTES D'ABORD
/*
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'benrand123'), 'e716e0cf70d3c6dbd840945d890f074d', 'Recteur', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'harrako912'), '78e740abec0d61e6dd52452e6d9c2a32', 'SG', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`, `scale_right`) VALUES ((SELECT id FROM mdl_user WHERE username = 'lalrako381'), '9248153d95104975573f18e2852d6647', 'DAF', NULL, 5);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'ionrako617'), '2df68a85f1932ca876926252bbaa0820', 'CGE', NULL);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mikrama654'), 'c24d593b9266e7b8d0887d0dc7259705', 'Agent', NULL);
INSERT INTO `ACEA`.`uac_admin` (`id`, `pwd`, `role`, `last_connection`) VALUES ((SELECT id FROM mdl_user WHERE username = 'mborako321'), 'd064a894fb8645879312b10d366cd604', 'Agent', NULL);

*/

-- SHOW USERS

DROP TABLE IF EXISTS uac_showuser;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_showuser` (
  `username` VARCHAR(30) NOT NULL,
  `roleid` TINYINT UNSIGNED NOT NULL,
  `secret` INT UNSIGNED NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
DROP TABLE IF EXISTS uac_load_scan;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_scan` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `scan_username` VARCHAR(50) NOT NULL,
  `scan_date` DATE NOT NULL,
  `scan_time` TIME NOT NULL,
  `status` CHAR(3) NOT NULL,
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
  `edt_involved` INT UNSIGNED NOT NULL DEFAULT 0,
  `valid_exc_uid` BIGINT UNSIGNED NOT NULL DEFAULT 0,
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
  `id` BIGINT GENERATED ALWAYS AS (),
  `user_id` BIGINT NOT NULL,
  `status` CHAR(3) NOT NULL,
  `flow_id` BIGINT NULL,
  `filename` VARCHAR(300) NOT NULL,
  `mention` VARCHAR(100) NOT NULL,
  `niveau` CHAR(2) NOT NULL,
  `monday_ofthew` DATE NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `hour_starts_at` VARCHAR(45) NOT NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));
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

   INSERT INTO uac_scan (user_id, agent_id, scan_date, scan_time, status)
      SELECT mu.id, uls.user_id, uls.scan_date, MIN(uls.scan_time), 'NEW'
      FROM uac_load_scan uls JOIN mdl_user mu on UPPER(mu.username) = UPPER(uls.scan_username)
      WHERE uls.scan_date = inv_date
      AND uls.status = 'NEW'
      GROUP BY mu.id, uls.user_id, uls.scan_date;

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
        UPDATE uac_working_flow SET status = 'END' WHERE id = inv_flow_id;


     END IF;

END$$
-- Remove $$ for OVH


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
              UPDATE uac_working_flow SET status = 'END' WHERE id = inv_flow_id;

    END IF;


END$$
-- Remove $$ for OVH

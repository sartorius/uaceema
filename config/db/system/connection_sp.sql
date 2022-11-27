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

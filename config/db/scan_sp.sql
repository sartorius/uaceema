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

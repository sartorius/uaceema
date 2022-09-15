DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_MNG_Scan$$
CREATE PROCEDURE `SRV_MNG_Scan` (IN param DATE)
BEGIN
    DECLARE inv_date	DATE;
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


   SELECT CONCAT('SRV_MNG_Scan - END OK: ', NOW());

END$$
-- Remove $$ for OVH

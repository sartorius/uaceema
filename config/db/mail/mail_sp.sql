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
    SELECT COUNT(1) INTO count_mail FROM mdl_user
    WHERE NOT EXISTS (SELECT 1 FROM uac_mail
                    WHERE (flow_code, user_id) = (flow_code, id));


    -- We do not find any email here
    IF (count_mail > 0) THEN

        -- We run the full process
        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        -- We need to insert missing new user without any email

        INSERT IGNORE INTO uac_mail (flow_id, flow_code, user_id, status)
          SELECT inv_flow_id, flow_code, id, 'NEW' FROM mdl_user;




        -- End of the flow correctly
        UPDATE uac_working_flow SET status = 'END' WHERE id = inv_flow_id;


     END IF;

END$$
-- Remove $$ for OVH

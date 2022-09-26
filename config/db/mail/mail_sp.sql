-- This push account without email to be sent
-- These account will be prepared to be sent in uac_mail
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
        UPDATE uac_working_flow SET status = 'END', last_update = NOW(), comment = CONCAT('Mail created: ', count_mail) WHERE id = inv_flow_id;


     END IF;

END$$
-- Remove $$ for OVH


-- This is getting the list of email according to the limit
-- This is handling the daily limit of email to be sent
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

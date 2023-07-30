INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRALOAD', 'Integration des notes', NULL, NULL);
-- Display EDT for Administration
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_START_GraFlowMaster$$
CREATE PROCEDURE `CLI_START_GraFlowMaster` (IN param_filename VARCHAR(300),
                                          IN param_user_id BIGINT,
                                          IN param_exam_date DATE,
                                          IN param_subject_id INT,
                                          IN param_teacher_id SMALLINT,
                                          IN param_nbr_of_page TINYINT,
                                          IN param_cust_teacher_name VARCHAR(100))
BEGIN
    DECLARE inv_flow_code	CHAR(7);
    DECLARE concurrent_flow TINYINT;

    DECLARE inv_flow_id	BIGINT;
    DECLARE inv_gra_master_id	BIGINT;

    -- Create the flow
    SELECT 'GRALOAD' INTO inv_flow_code;

    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE flow_code = 'GRALOAD' AND status = 'NEW';

    IF concurrent_flow > 0 THEN
        -- That means we have already an integration which has failed
        SELECT 0 AS INV_GRA_MASTER_ID;
    ELSE
        INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, filename, last_update) VALUES (inv_flow_code, 'NEW', CURRENT_DATE, 0, param_filename, NOW());
        SELECT LAST_INSERT_ID() INTO inv_flow_id;

        -- Create the master flow now
        -- The zip filename can be a jpg or jpeg if the nbr of page is 1
        INSERT INTO uac_gra_master (
          flow_id, last_agent_id, exam_date, zip_filename, subject_id, teacher_id, nbr_of_page, cust_teacher_name
        )
        VALUES (inv_flow_id, param_user_id, param_exam_date, param_filename, param_subject_id, param_teacher_id, param_nbr_of_page, param_cust_teacher_name);
        SELECT LAST_INSERT_ID() INTO inv_gra_master_id;

        -- Return the end result here
        -- We need to close the flow at the end
        SELECT inv_gra_master_id AS INV_GRA_MASTER_ID;
    END IF;
END$$
-- Remove $$ for OVH

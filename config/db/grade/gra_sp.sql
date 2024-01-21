INSERT IGNORE INTO uac_param (key_code, description, par_int, par_value) VALUES ('GRACSBK', 'Default cross bookmark', NULL, '1428.61/-771px/-144px/0');
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_code) VALUES ('GRALOAD', 'Integration des notes', NULL, NULL);
INSERT IGNORE INTO uac_param (key_code, description, par_int, par_value) VALUES ('YEARAAA', 'Yearly verbose', NULL, '2023-24');
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
    DECLARE existing_exam_date TINYINT;

    DECLARE inv_flow_id	BIGINT;
    DECLARE inv_gra_master_id	BIGINT;

    -- Create the flow
    SELECT 'GRALOAD' INTO inv_flow_code;

    SELECT COUNT(1) INTO concurrent_flow FROM uac_working_flow WHERE flow_code = 'GRALOAD' AND status = 'NEW';
    SELECT COUNT(1) INTO existing_exam_date FROM uac_gra_master WHERE exam_date = param_exam_date AND subject_id = param_subject_id AND status NOT IN ('CAN');

    IF concurrent_flow > 0 THEN
        -- That means we have already an integration which has failed
        SELECT 0 AS INV_GRA_MASTER_ID;
    ELSEIF existing_exam_date > 0 THEN
        -- Existing exam for this date and this subject
        SELECT -1 AS INV_GRA_MASTER_ID;
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

DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_END_GraFlowMasterGenGraLine$$
CREATE PROCEDURE `CLI_END_GraFlowMasterGenGraLine` (IN param_master_id BIGINT)
BEGIN
    DECLARE inv_flow_id	BIGINT;

    SELECT flow_id INTO inv_flow_id FROM uac_gra_master WHERE id = param_master_id AND status = 'NEW';
    -- Insert Gra Line
    INSERT INTO uac_gra_line (id, master_id, gra_path, gra_filename, page_i)
        SELECT id, master_id, gra_path, gra_filename, page_i FROM uac_load_gra WHERE master_id = param_master_id AND status = 'NEW';


    UPDATE uac_load_gra SET flow_id = inv_flow_id, status = 'END' WHERE master_id = param_master_id AND status = 'NEW';
    UPDATE uac_working_flow SET status = 'END' WHERE flow_code = 'GRALOAD' AND status = 'NEW' AND id = inv_flow_id;
    -- WIN is Waiting for Input
    UPDATE uac_gra_master SET status = 'LOA', last_update = CURRENT_TIMESTAMP WHERE id = param_master_id AND status = 'NEW';

END$$
-- Remove $$ for OVH


-- This end review is todo
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_REV_GraReviewExamEnd$$
CREATE PROCEDURE `CLI_REV_GraReviewExamEnd` (IN param_agent_id BIGINT, IN param_master_id BIGINT, IN param_cross_bookmark VARCHAR(100), IN param_browser VARCHAR(100))
BEGIN
    DECLARE inv_subject_id	BIGINT;

    SELECT subject_id INTO inv_subject_id FROM uac_gra_master WHERE id = param_master_id;
    -- We have to set to 'N' all grade for the same subject id
    -- and lower

    -- Set all grade to N
    UPDATE uac_gra_grade main_gra JOIN (
      SELECT ugg_ref.id AS UGG_REF_ID
      FROM uac_gra_grade ugg_ref
			JOIN uac_gra_master ugm
			ON ugg_ref.master_id = ugm.id
			   AND ugm.subject_id = inv_subject_id) AS t2
                      ON main_gra.id = t2.UGG_REF_ID
            				  SET main_gra.to_be_used = 'N';

    -- Up to the rule we need to identify the max grade :
    -- Maximum up to session
    -- Be carefull if we put the first grade to Max if 2 grades have Max
    -- The last grade ?
    -- TO DO : set to be used for the relevant grade

    -- Update the master
    UPDATE uac_gra_master
      SET status = 'END',
      last_update = CURRENT_TIMESTAMP,
      last_agent_id = param_agent_id,
      cross_bookmark = param_cross_bookmark,
      cross_browser = param_browser,
      avg_grade = (SELECT TRUNCATE(AVG(grade), 2) FROM uac_gra_grade ugg WHERE ugg.master_id = param_master_id and ugg.gra_status = 'P')
      WHERE id = param_master_id ;

END$$
-- Remove $$ for OVH

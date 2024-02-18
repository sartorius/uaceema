-- Display average score according to his/her application time
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_ASS_GetAssStatPerStu$$
CREATE PROCEDURE `CLI_ASS_GetAssStatPerStu` (IN param_user_id BIGINT)
BEGIN
    DECLARE inv_cohort_id	  INT;
    DECLARE inv_create_date	DATETIME;
    -- END OF DECLARE

    SELECT create_date INTO inv_create_date FROM mdl_user WHERE id = param_user_id;
    SELECT COHORT_ID INTO inv_cohort_id FROM v_showuser WHERE ID = param_user_id;

    -- Do the selection here actually here
    SELECT VSH_COHORT_ID, VSH_SHORT_CLASS, ASS_STATUS, ASS_COUNT, CLS_COUNT, TRUNCATE(ASS_COUNT/CLS_COUNT, 3) AS ASS_AVG, STU_COUNT
    FROM (
    	SELECT vsh.cohort_id AS VSH_COHORT_ID, vsh.SHORTCLASS AS VSH_SHORT_CLASS, ass.status AS ASS_STATUS, COUNT(1) AS ASS_COUNT
    	FROM uac_assiduite ass JOIN v_showuser vsh ON ass.user_id = vsh.ID
                             JOIN uac_edt_line uel ON uel.id = ass.edt_id
                                                   AND uel.day NOT IN (select working_date from uac_assiduite_off)
      WHERE ass.create_date > inv_create_date
      AND vsh.COHORT_ID = inv_cohort_id
      AND ass.status NOT IN ('PON')
    	GROUP BY vsh.cohort_id, vsh.SHORTCLASS, ass.status
    ) t_count_ass JOIN (
    	SELECT vsh.cohort_id AS CLS_COHORT_ID, count(1) AS CLS_COUNT
    	FROM v_showuser vsh
      WHERE vsh.COHORT_ID = inv_cohort_id
    	GROUP BY vsh.cohort_id
    ) t_class ON t_count_ass.VSH_COHORT_ID = t_class.CLS_COHORT_ID
    JOIN (
      SELECT vsh.cohort_id AS STU_COHORT_ID, ass.status AS STU_STATUS, COUNT(1) AS STU_COUNT
    	FROM uac_assiduite ass JOIN v_showuser vsh ON ass.user_id = vsh.ID
                                                 AND vsh.ID = param_user_id
                              JOIN uac_edt_line uel ON uel.id = ass.edt_id
                                                    AND uel.day NOT IN (select working_date from uac_assiduite_off)
      WHERE ass.create_date > inv_create_date
      AND vsh.COHORT_ID = inv_cohort_id
    	GROUP BY vsh.cohort_id, vsh.SHORTCLASS, ass.status
    ) t_stu ON t_count_ass.VSH_COHORT_ID = t_stu.STU_COHORT_ID
            AND t_count_ass.ASS_STATUS = t_stu.STU_STATUS;

END$$
-- Remove $$ for OVH

-- Display average score according to his/her application time
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_STU_Modify$$
CREATE PROCEDURE `CLI_STU_Modify` (IN param_agent_id BIGINT,
                                   IN param_user_id BIGINT,
                                   IN param_living_conf CHAR(1),
                                   IN param_cohort_id INT,
                                   IN param_lastname VARCHAR(100),
                                   IN param_firstname VARCHAR(100),
                                   IN param_othfirstname VARCHAR(50),
                                   IN param_matricule VARCHAR(45),
                                   IN param_phone1 VARCHAR(20),
                                   IN param_phone_par1 VARCHAR(20),
                                   IN param_phone_par2 VARCHAR(20),
                                   IN param_ass_info VARCHAR(250))
BEGIN
    DECLARE inv_username	      CHAR(10);
    DECLARE count_uac_user_info	SMALLINT;

    DECLARE inv_phone_par2	VARCHAR(20);
    DECLARE inv_ass_info	VARCHAR(250);
    -- END OF DECLARE

    IF param_phone_par2 = "" THEN
      SET inv_phone_par2 = NULL;
    ELSE
      SET inv_phone_par2 = param_phone_par2;
    END IF;

    IF param_ass_info = "" THEN
      SET inv_ass_info = NULL;
    ELSE
      SET inv_ass_info = param_ass_info;
    END IF;


    -- MDL USER
    UPDATE mdl_user SET
      last_update = CURRENT_TIMESTAMP,
      lastname = UPPER(param_lastname),
      firstname = fCapitalizeStr(param_firstname),
      autre_prenom = fCapitalizeStr(param_othfirstname),
      matricule = param_matricule,
      phone1 = param_phone1,
      phone_par1 = param_phone_par1,
      phone_par2 = inv_phone_par2
    WHERE id = param_user_id;

    -- UAC SHOW USER
    SELECT username INTO inv_username FROM mdl_user WHERE id = param_user_id;
    UPDATE uac_showuser SET
      last_update = CURRENT_TIMESTAMP,
      cohort_id = param_cohort_id
    WHERE username = inv_username;

    -- UAC INFOS
    SELECT COUNT(1) INTO count_uac_user_info FROM uac_user_info WHERE id = param_user_id;
    IF count_uac_user_info > 0 THEN
       -- We need to do an update
       UPDATE uac_user_info SET
         last_update = CURRENT_TIMESTAMP,
         agent_id = param_agent_id,
         assiduite_info = inv_ass_info,
         living_configuration = param_living_conf
       WHERE id = param_user_id;
    ELSE
       -- We need to do an insert
       INSERT INTO uac_user_info (id, living_configuration, assiduite_info, agent_id) VALUES (param_user_id, param_living_conf, inv_ass_info, param_agent_id);
    END IF;
END$$
-- Remove $$ for OVH

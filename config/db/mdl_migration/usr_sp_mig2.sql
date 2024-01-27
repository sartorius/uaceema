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

DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_XXX$$
CREATE PROCEDURE `SRV_CRT_XXX` ()
BEGIN
    DECLARE flow_code	CHAR(7);
    DECLARE inv_flow_id	BIGINT;
    -- CALL SRV_PRG_Scan();

    SELECT 'MLWELCO' INTO flow_code;

    INSERT INTO uac_working_flow (flow_code, status, working_date, working_part, last_update) VALUES (flow_code, 'NEW', CURRENT_DATE, 0, NOW());
    SELECT LAST_INSERT_ID() INTO inv_flow_id;



    -- End of the flow correctly
    UPDATE uac_working_flow SET status = 'END' WHERE id = inv_flow_id;
END$$
-- Remove $$ for OVH











DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_REF_GetTracking$$
CREATE PROCEDURE `CLI_REF_GetTracking` (IN `param_ref` VARCHAR(255))
BEGIN
	DECLARE get_wid	INT;
  DECLARE found	INT DEFAULT 0;
  DECLARE max_step_id	INT DEFAULT 0;

  SELECT COUNT(1) INTO found
	FROM trk_main
		WHERE ref = param_ref;


  IF found > 0 THEN
      -- Case we find it !
      -- Get the Workflow ID
      SELECT wid INTO get_wid
      FROM trk_main
        WHERE ref = param_ref LIMIT 1;

      SELECT MAX(step) INTO max_step_id
        FROM trk_main
          WHERE ref = param_ref;

      DROP TABLE IF EXISTS result_table;
      CREATE TEMPORARY TABLE result_table(
         trw_description VARCHAR(50),
         tm_ope_date VARCHAR(10),
         tm_ref VARCHAR(30),
         trs_description VARCHAR(50),
         tm_comment VARCHAR(500),
         trs_id INT
      );

      INSERT INTO result_table (trw_description, tm_ope_date, tm_ref, trs_description, tm_comment, trs_id)
      SELECT
        IFNULL(trw.description, 'NA'),
        IFNULL(DATE_FORMAT(tm.ope_date, '%d/%m/%Y'), 'NA'),
        IFNULL(tm.ref, 'NA'),
        trs.description,
        IFNULL(tm.comment, 'NA'),
        trs.id
      FROM trk_main tm JOIN trk_ref_workflow trw on trw.id = tm.wid
                       JOIN trk_ref_step_workflow trs on tm.step = trs.id
      WHERE ref = param_ref
      AND trs.wid = get_wid;

      INSERT INTO result_table (trw_description, tm_ope_date, tm_ref, trs_description, tm_comment, trs_id)
      SELECT
        'NA',
        'NA',
        'NA',
        trs.description,
        'NA',
        trs.id
      FROM trk_ref_step_workflow trs
      WHERE 1= 1
      AND trs.id > max_step_id
      AND trs.wid = get_wid;

      SELECT trw_description, tm_ope_date, tm_ref, trs_description, tm_comment
      FROM result_table
      ORDER BY trs_id ASC;

  ELSE
      -- Do the case we do not find it
      SELECT
        'NF' AS trw_description,
        'NF' AS tm_ope_date,
        param_ref AS tm_ref,
        'NF' AS trs_description,
        'NF' AS tm_comment;


  END IF;

END$$
-- Remove $$ for OVH

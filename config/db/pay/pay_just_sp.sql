-- Create JUST
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_CRT_PayAddJust$$
CREATE PROCEDURE `CLI_CRT_PayAddJust` (
  IN param_cat_id INT,
  IN param_just_ref CHAR(10),
  IN param_tech_init_hd VARCHAR(45),
  IN param_input_amount INT,
  IN param_type_of_payment CHAR(1),
  IN param_agent_id BIGINT,
  IN param_comment VARCHAR(150))
BEGIN
    INSERT INTO uac_just (cat_id, just_ref, tech_init_hd, input_amount, type_of_payment, agent_id, comment)
            VALUES (param_cat_id, param_just_ref, param_tech_init_hd, param_input_amount, param_type_of_payment, param_agent_id, param_comment);
    SELECT LAST_INSERT_ID() AS JUST_LAST_ID;
END$$
-- Remove $$ for OVH

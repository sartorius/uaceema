-- Display average score according to his/her application time
DELIMITER $$
DROP PROCEDURE IF EXISTS CLI_TEA_Modify$$
CREATE PROCEDURE `CLI_TEA_Modify` (IN param_mode CHAR(1),
                                   IN param_agent_id BIGINT,
                                   IN param_teacher_id SMALLINT,
                                   IN param_name VARCHAR(100),
                                   IN param_title CHAR(3),
                                   IN param_lastname VARCHAR(100),
                                   IN param_firstname VARCHAR(100),
                                   IN param_othfirstname VARCHAR(100),
                                   IN param_contract CHAR(3),
                                   IN param_phone_main VARCHAR(20),
                                   IN param_phone_alt VARCHAR(20),
                                   IN param_email VARCHAR(200),
                                   IN param_teacher_info VARCHAR(250),
                                   IN param_all_mention VARCHAR(250))
BEGIN
    DECLARE i_loop_mention_code	  CHAR(5);
    DECLARE i_loop_mention	      SMALLINT;
    DECLARE count_all_mention	    SMALLINT;
    DECLARE i_mention_exist	      SMALLINT;


    DECLARE inv_phone_alt	    VARCHAR(20);
    DECLARE inv_othfirstname	VARCHAR(100);
    DECLARE inv_teacher_info	VARCHAR(250);


    DECLARE max_teacher_id    BIGINT;
    -- END OF DECLARE

    IF param_phone_alt = "" THEN
      SET inv_phone_alt = NULL;
    ELSE
      SET inv_phone_alt = param_phone_alt;
    END IF;

    IF param_othfirstname = "" THEN
      SET inv_othfirstname = NULL;
    ELSE
      SET inv_othfirstname = param_othfirstname;
    END IF;

    IF param_teacher_info = "" THEN
      SET inv_teacher_info = NULL;
    ELSE
      SET inv_teacher_info = param_teacher_info;
    END IF;

    -- This is a common part
    -- Error Management
    -- Actually there is no error to manage here because we have done the check on Javascript side
    -- If the mention is used (UEL or UGM) then the user cannot change the set up for this teacher

    -- Loop though all mentions
    SELECT COUNT(1) INTO count_all_mention FROM uac_ref_mention;
    SET i_loop_mention = 0;


    -- We treat Edition first then Creation
    IF param_mode = "E" THEN

                  WHILE i_loop_mention < count_all_mention DO
                      SELECT par_code INTO i_loop_mention_code FROM uac_ref_mention LIMIT 1 OFFSET i_loop_mention;

                            -- i_mention_exist is 0 then it does not exist
                            -- i_mention_exist > 0 then exists
                            SELECT FIND_IN_SET(i_loop_mention_code, param_all_mention) INTO i_mention_exist;
                            IF (i_mention_exist > 0) THEN
                                -- We must add it if it does not exists
                                -- Check constraints
                                INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (param_teacher_id, i_loop_mention_code);
                            ELSE
                                -- We need to remove it
                                -- Check constraints
                                DELETE FROM uac_xref_teacher_mention WHERE teach_id = param_teacher_id AND mention_code = i_loop_mention_code;
                            END IF;

                      SET i_loop_mention = i_loop_mention + 1;
                  END WHILE;

                  -- THEN perform the edition
                  UPDATE uac_ref_teacher SET
                      last_update = CURRENT_TIMESTAMP,
                      agent_id = param_agent_id,
                      name = param_name,
                      title = param_title,
                      lastname = UPPER(param_lastname),
                      firstname = fCapitalizeStr(param_firstname),
                      other_firstname = fCapitalizeStr(param_othfirstname),
                      contract = param_contract,
                      phone_main = param_phone_main,
                      phone_alt = param_phone_alt,
                      email = param_email,
                      teacher_info = param_teacher_info
                  WHERE id = param_teacher_id;

                  SELECT "OK" AS RETURN_VALUE;
    ELSE
      SELECT (MAX(id) + 1) INTO max_teacher_id FROM uac_ref_teacher;
      -- Insert first
      INSERT IGNORE  INTO uac_ref_teacher (
          id,
          agent_id,
          name,
          title,
          lastname,
          firstname,
          other_firstname,
          contract,
          phone_main,
          phone_alt,
          email,
          teacher_info
          )
          VALUES (
            max_teacher_id,
            param_agent_id,
            param_name, param_title,
            UPPER(param_lastname),
            fCapitalizeStr(param_firstname),
            fCapitalizeStr(param_othfirstname),
            param_contract,
            param_phone_main,
            param_phone_alt,
            param_email,
            param_teacher_info
          );

          WHILE i_loop_mention < count_all_mention DO
              SELECT par_code INTO i_loop_mention_code FROM uac_ref_mention LIMIT 1 OFFSET i_loop_mention;

                    -- i_mention_exist is 0 then it does not exist
                    -- i_mention_exist > 0 then exists
                    SELECT FIND_IN_SET(i_loop_mention_code, param_all_mention) INTO i_mention_exist;
                    IF (i_mention_exist > 0) THEN
                        -- We must add it if it does not exists
                        -- Check constraints
                        INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (max_teacher_id, i_loop_mention_code);
                    END IF;

              SET i_loop_mention = i_loop_mention + 1;
          END WHILE;

          SELECT max_teacher_id AS RETURN_VALUE;
    END IF;
END$$
-- Remove $$ for OVH

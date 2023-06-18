-- Use this SP to get the sum up of tranche
-- Run in DEV : 166 sec // 2 min 46 sec
DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_MIG_PrepareData$$
CREATE PROCEDURE `MAN_MIG_PrepareData` ()
BEGIN
      -- INSERT INTO uac_load_eco_mig (load_line, load_matricule, load_name, load_t1, load_t2, load_t3, load_c4,load_niveau, temp_matricule_nbr, temp_matricule_mention) VALUES ();

      /*
      INSERT INTO uac_load_eco_mig (load_line, load_matricule, load_name, load_t1, load_t2, load_t3, load_c4, load_niveau, temp_matricule_nbr, temp_matricule_mention) VALUES ('1','1813/GE/IèA','RABEMANANTSOA Nomenjanahary Ronaldino','','','','2500000','L1','1813','GE');
      select * from uac_load_eco_mig mig
      where mig.load_matricule IN (
      	select matricule from mdl_user
      );
      */

      -- Retrieve the inset line in https://docs.google.com/spreadsheets/d/1yefDhp_5Gqk5r11iuHc1U1WL5yf314lk44vKI5ku7fc/edit?usp=sharing

      UPDATE uac_load_eco_mig mig JOIN mdl_user mu ON mu.matricule = mig.load_matricule
      		SET mig.core_user_id = mu.id,
              mig.core_username =  mu.username,
      				mig.status = 'FND'
      		WHERE mig.status = 'NEW';


      UPDATE uac_load_eco_mig mig JOIN mdl_user mu ON CONCAT(mig.temp_matricule_nbr, '/', mig.temp_matricule_mention) = substring_index(mu.matricule, '/', 2)
      		SET mig.core_user_id = mu.id,
              mig.core_username =  mu.username,
      				mig.status = 'FND'
      		WHERE mig.status = 'NEW';

      -- Do the test again for the RID
      UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'RI'
        WHERE mig.temp_matricule_mention = 'RID' AND mig.status = 'NEW';


      -- Do the test again for the COM
      UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'CO'
        WHERE mig.temp_matricule_mention = 'COM' AND mig.status = 'NEW';


      -- Do the test again for the COM
      UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT'
        WHERE mig.temp_matricule_mention = 'DTIV' AND mig.status = 'NEW';

      -- Do the test again for the COM
      UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT', mig.temp_matricule_nbr = '1436'
      WHERE mig.temp_matricule_nbr = '1436DT' AND mig.status = 'NEW';

      -- Do the test again for the COM
      UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'GE', mig.temp_matricule_nbr = '2286'
      WHERE mig.temp_matricule_nbr = '2286GE' AND mig.status = 'NEW';

      -- Do the test again for the COM
      UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT'
        WHERE mig.temp_matricule_mention = 'DTV' AND mig.status = 'NEW';

        -- Do the test again for the COM
        UPDATE uac_load_eco_mig mig SET mig.temp_matricule_mention = 'DT'
          WHERE mig.temp_matricule_mention = 'DTD' AND mig.status = 'NEW';


      UPDATE uac_load_eco_mig mig JOIN mdl_user mu ON CONCAT(mig.temp_matricule_nbr, '/', mig.temp_matricule_mention) = substring_index(mu.matricule, '/', 2)
      		SET mig.core_user_id = mu.id,
              mig.core_username =  mu.username,
      				mig.status = 'FND'
      		WHERE mig.status = 'NEW';


      -- UPDATE `table` SET `col_name` = REPLACE(`col_name`, ' ', '')
      -- select field from table where field REGEXP '^-?[0-9]+$';
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*****************************            READ THE AMOUNT            *********************************/
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*****************************************************************************************************/
      /*
      -- RESET
      UPDATE uac_load_eco_mig mig SET mig.core_t1 = NULL, mig.core_t2 = NULL, mig.core_t3 = NULL, mig.status = 'FND'
      WHERE mig.status NOT IN ('NEW');

      */


      UPDATE uac_load_eco_mig mig SET mig.core_t1 = CAST(REPLACE(mig.load_t1, ' ', '') AS UNSIGNED), mig.status = 'AM1'
      WHERE REPLACE(mig.load_t1, ' ', '') REGEXP '^-?[0-9]+$'
      AND mig.load_t1 like '%00'
      AND mig.status = 'FND';

      UPDATE uac_load_eco_mig mig SET mig.core_t2 = CAST(REPLACE(mig.load_t2, ' ', '') AS UNSIGNED), mig.status = 'AM2'
      WHERE REPLACE(mig.load_t2, ' ', '') REGEXP '^-?[0-9]+$'
      AND mig.load_t2 like '%00'
      AND mig.status IN ('AM1');

      UPDATE uac_load_eco_mig mig SET mig.core_t3 = CAST(REPLACE(mig.load_t3, ' ', '') AS UNSIGNED), mig.status = 'AM3'
      WHERE REPLACE(mig.load_t3, ' ', '') REGEXP '^-?[0-9]+$'
      AND mig.load_t3 like '%00'
      AND mig.status IN ('AM2');

      UPDATE uac_load_eco_mig mig SET mig.status = 'TXT'
      WHERE mig.status = 'FND';


      -- We want to remove duplicate
      UPDATE uac_load_eco_mig mig JOIN (
        SELECT core_user_id FROM uac_load_eco_mig mig
        WHERE core_user_id IS NOT NULL
        GROUP BY core_user_id
        HAVING COUNT(1) > 1
      ) AS t2 ON mig.core_user_id = t2.core_user_id
        SET mig.comment = CONCAT('Duplicat ', mig.status),
        mig.status = 'DUP'
        WHERE mig.status IN ('AM1', 'AM2', 'AM3');


END$$


-- Use this SP to get the sum up of tranche
DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_MIG_GenPayTranche$$
CREATE PROCEDURE `MAN_MIG_GenPayTranche` (IN param_mig_id BIGINT, IN param_amount_tag CHAR(3), IN param_amount INT)
BEGIN


          DECLARE in_loop_amount      INT;
          -- run the loop now of Frais Fixe and Tranche now
          -- Loop inside the loop
          DECLARE in_loop_user_id     BIGINT;
          DECLARE in_loop_username    VARCHAR(10);
          DECLARE nbr_of_unpaid_t     SMALLINT UNSIGNED;
          DECLARE i_t                 SMALLINT UNSIGNED;
          DECLARE in_loop_t_ref_id    INT UNSIGNED;
          DECLARE in_loop_t_amount    INT;


          SELECT core_user_id INTO in_loop_user_id FROM uac_load_eco_mig WHERE id = param_mig_id;

          -- in_loop_username
          -- nbr_of_unpaid_t
          -- i_t
          -- in_loop_t_ref_id
          -- in_loop_t_amount

          SET in_loop_amount = param_amount;
          -- ****************************************
          -- Perform the loop here for payment T here
          -- ****************************************
          SELECT USERNAME INTO in_loop_username FROM v_showuser WHERE ID = in_loop_user_id;
          SELECT COUNT(1) INTO nbr_of_unpaid_t FROM (
            SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
              FROM v_original_to_pay_for_user vop
                LEFT JOIN uac_payment up
                  ON vop.REF_ID = up.ref_fsc_id
                  AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L'
                  WHERE vop.VSH_USERNAME = in_loop_username
                  AND vop.TRANCHE_CODE NOT IN (
                    SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
                    WHERE tvpu.VSH_USERNAME = in_loop_username)
                    UNION
                    SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                    FROM v_left_to_pay_for_user vpu
                    LEFT JOIN uac_payment up
                    ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L'
                    WHERE VSH_USERNAME = in_loop_username) t WHERE t.REST_TO_PAY > 0;

          SET i_t = 0;
                  WHILE (i_t < nbr_of_unpaid_t)
                        AND (in_loop_amount > 0)
                        DO

                        -- Retrieve the first ref id
                        SELECT MIN(REF_ID) INTO in_loop_t_ref_id FROM (
                          SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                            FROM v_original_to_pay_for_user vop
                              LEFT JOIN uac_payment up
                                ON vop.REF_ID = up.ref_fsc_id
                                AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L'
                                WHERE vop.VSH_USERNAME = in_loop_username
                                AND vop.TRANCHE_CODE NOT IN (
                                  SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
                                  WHERE tvpu.VSH_USERNAME = in_loop_username)
                                  UNION
                                  SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                                  FROM v_left_to_pay_for_user vpu
                                  LEFT JOIN uac_payment up
                                  ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L'
                                  WHERE VSH_USERNAME = in_loop_username) t WHERE t.REST_TO_PAY > 0;

                          -- Retrieve the loop t amount
                          SELECT REST_TO_PAY INTO in_loop_t_amount FROM (
                            SELECT vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                              FROM v_original_to_pay_for_user vop
                                LEFT JOIN uac_payment up
                                  ON vop.REF_ID = up.ref_fsc_id
                                  AND up.user_id = vop.VSH_ID AND up.type_of_payment = 'L'
                                  WHERE vop.VSH_USERNAME = in_loop_username
                                  AND vop.TRANCHE_CODE NOT IN (
                                    SELECT tvpu.TRANCHE_CODE FROM v_left_to_pay_for_user tvpu
                                    WHERE tvpu.VSH_USERNAME = in_loop_username)
                                    UNION
                                    SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
                                    FROM v_left_to_pay_for_user vpu
                                    LEFT JOIN uac_payment up
                                    ON vpu.REF_ID = up.ref_fsc_id AND up.user_id = vpu.VSH_ID AND up.type_of_payment = 'L'
                                    WHERE VSH_USERNAME = in_loop_username) t WHERE t.REST_TO_PAY > 0 AND t.REF_ID = in_loop_t_ref_id;

                              -- Then create the payment
                              INSERT INTO uac_payment (
                                user_id,
                                ref_fsc_id,
                                status,
                                payment_ref,
                                input_amount,
                                type_of_payment,
                                pay_date,
                                comment
                              )
                              VALUES (
                                in_loop_user_id,
                                in_loop_t_ref_id,
                                'P',
                                CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(param_mig_id, 5, '0'), 'P'),
                                CASE WHEN (in_loop_amount > in_loop_t_amount) THEN in_loop_t_amount ELSE in_loop_amount END,
                                'C',
                                CURRENT_TIMESTAMP,
                                CONCAT('Mig. digit ', param_amount_tag)
                              );
                              -- We need to manage the rest of amount
                              IF (in_loop_amount > in_loop_t_amount) THEN
                                  SET in_loop_amount = in_loop_amount - in_loop_t_amount;
                              ELSE
                                  SET in_loop_amount = 0;
                              END IF;

                    SET i_t = i_t + 1;
                  END WHILE;


                  -- HANDLE TOO MUCH AMOUNT OF MONEY !!!
                  -- In this case if we have still too much money from the student then we have to save it somewhere
                  -- It will be saved has solde excedent to not be used
                  IF (in_loop_amount > 0) THEN
                      INSERT INTO uac_payment (
                        user_id,
                        ref_fsc_id,
                        status,
                        payment_ref,
                        input_amount,
                        type_of_payment,
                        pay_date,
                        comment
                      )
                      VALUES (
                        in_loop_user_id,
                        (SELECT MAX(id) FROM uac_ref_frais_scolarite WHERE code = 'UNUSEDM'),
                        'P',
                        CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(param_mig_id, 5, '0'), 'P'),
                        in_loop_amount,
                        'C',
                        CURRENT_TIMESTAMP,
                        CONCAT('Mig. digit excedent', param_amount_tag)
                      );

                      UPDATE uac_load_eco_mig mig
                      SET mig.comment = CONCAT('EXC-', mig.comment)
                      WHERE mig.id = param_mig_id AND status NOT IN ('NEW', 'TXT');

                      -- Make sure the amount has been used fully
                      SET in_loop_amount = 0;
                  END IF;

          -- END the line
          UPDATE uac_load_eco_mig mig
          SET mig.comment = CONCAT(param_amount_tag, '/', mig.comment)
          WHERE mig.id = param_mig_id AND status NOT IN ('NEW', 'TXT');


END$$


-- Use this SP to get the sum up of tranche
-- Run in DEV : 166 sec // 2 min 46 sec
DELIMITER $$
DROP PROCEDURE IF EXISTS MAN_MIG_LoopEcolageFile$$
CREATE PROCEDURE `MAN_MIG_LoopEcolageFile` (IN param_limit INT)
BEGIN


        -- run the loop now of Frais Fixe and Tranche now
        -- Loop inside the loop

        DECLARE nbr_of_line         SMALLINT UNSIGNED;
        DECLARE i_e                 SMALLINT UNSIGNED;
        DECLARE param_mig_id        BIGINT;

        DECLARE in_the_loop_user_id BIGINT;
        DECLARE in_loop_amount_tag  CHAR(3);
        DECLARE in_loop_amount      INT;

        SET i_e = 0;
        SELECT COUNT(1) INTO nbr_of_line FROM uac_load_eco_mig WHERE status IN ('AM1', 'AM2', 'AM3') AND id < param_limit;

        WHILE (i_e < nbr_of_line) DO
          SELECT MIN(id) INTO param_mig_id FROM uac_load_eco_mig WHERE status IN ('AM1', 'AM2', 'AM3') AND id < param_limit;
          -- Do the stuff here !
          -- CALL MAN_MIG_GenPayTranche (261, 'AM1', 1400000);


          /************************************************************************************/
          /************************************************************************************/
          /************************************************************************************/
          /******************************** START FRAIS FIXE **********************************/
          /************************************************************************************/
          /************************************************************************************/
          /************************************************************************************/
          SELECT mig.core_user_id INTO in_the_loop_user_id FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;

          INSERT INTO uac_payment (
            user_id,
            ref_fsc_id,
            status,
            payment_ref,
            input_amount,
            type_of_payment,
            pay_date,
            comment)
          VALUES (
            in_the_loop_user_id,
            1,
            'P',
            CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(param_mig_id, 5, '0'), 'P'),
            50000,
            'C',
            CURRENT_TIMESTAMP,
            CONCAT('Mig. digit FF1'));

          INSERT INTO uac_payment (
            user_id,
            ref_fsc_id,
            status,
            payment_ref,
            input_amount,
            type_of_payment,
            pay_date,
            comment)
          VALUES (
            in_the_loop_user_id,
            2,
            'P',
            CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(param_mig_id, 5, '0'), 'P'),
            150000,
            'C',
            CURRENT_TIMESTAMP,
            CONCAT('Mig. digit FF2'));

          INSERT INTO uac_payment (
            user_id,
            ref_fsc_id,
            status,
            payment_ref,
            input_amount,
            type_of_payment,
            pay_date,
            comment)
          VALUES (
            in_the_loop_user_id,
            3,
            'P',
            CONCAT(SUBSTRING(DATE_FORMAT(CURRENT_TIMESTAMP, "%Y"), 4, 1), DATE_FORMAT(CURRENT_TIMESTAMP, "%j"), LPAD(param_mig_id, 5, '0'), 'P'),
            200000,
            'C',
            CURRENT_TIMESTAMP,
            CONCAT('Mig. digit FF3'));

          /************************************************************************************/
          /************************************************************************************/
          /************************************************************************************/
          /********************************* END FRAIS FIXE ***********************************/
          /************************************************************************************/
          /************************************************************************************/
          /************************************************************************************/


          SELECT
            mig.status
            INTO
            in_loop_amount_tag
          FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;

          IF in_loop_amount_tag = 'AM3' THEN
            -- We are in AM3
            -- Do the work for AM1, AM2 and AM3
            SELECT mig.core_t1 INTO in_loop_amount FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;
            CALL MAN_MIG_GenPayTranche (param_mig_id, 'AM1', in_loop_amount);

            SELECT mig.core_t2 INTO in_loop_amount FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;
            CALL MAN_MIG_GenPayTranche (param_mig_id, 'AM2', in_loop_amount);

            SELECT mig.core_t3 INTO in_loop_amount FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;
            CALL MAN_MIG_GenPayTranche (param_mig_id, 'AM3', in_loop_amount);

            -- Gérer les AM1 to EN1 avec ''
            UPDATE uac_load_eco_mig mig SET mig.status = 'EN3' WHERE mig.id = param_mig_id;

          ELSEIF in_loop_amount_tag = 'AM2' THEN
            -- We are in AM2
            -- Do the work for AM1 and AM2
            SELECT mig.core_t1 INTO in_loop_amount FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;
            CALL MAN_MIG_GenPayTranche (param_mig_id, 'AM1', in_loop_amount);

            SELECT mig.core_t2 INTO in_loop_amount FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;
            CALL MAN_MIG_GenPayTranche (param_mig_id, 'AM2', in_loop_amount);

            -- Gérer les AM1 to EN1 avec ''
            UPDATE uac_load_eco_mig mig SET mig.status = 'EN2' WHERE mig.id = param_mig_id;
          ELSE
            -- We are in AM1
            -- Do the work for AM1
            SELECT mig.core_t1 INTO in_loop_amount FROM uac_load_eco_mig mig WHERE mig.id = param_mig_id;
            CALL MAN_MIG_GenPayTranche (param_mig_id, 'AM1', in_loop_amount);

            -- Gérer les AM1 to EN1 avec ''
            UPDATE uac_load_eco_mig mig SET mig.status = 'EN1' WHERE mig.id = param_mig_id;

          END IF;

          SET i_e = i_e + 1;
        END WHILE;



END$$

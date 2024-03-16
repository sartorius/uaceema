-- To be run only once
/*
ALTER TABLE uac_payment
    ADD COLUMN agent_id BIGINT UNSIGNED NULL AFTER pay_date;
*/
DROP TABLE IF EXISTS uac_ref_frais_scolarite_discount;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_frais_scolarite_discount` (
  `id` INT UNSIGNED NOT NULL,
  `fsc_id` INT UNSIGNED NOT NULL,
  `dis_case` CHAR(1) NULL,
  `code` VARCHAR(7) NOT NULL,
  `title` VARCHAR(50) NOT NULL,
  `description` VARCHAR(250) NULL,
  `amount` INT UNSIGNED NOT NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  UNIQUE KEY `code_UNIQUE` (`code`));

-- A is for Ancien
INSERT IGNORE INTO uac_ref_frais_scolarite_discount (id, dis_case, fsc_id, code, title, description, amount)
VALUES (1, 'A', 1, 'ATSTENT', 'Ancien droit concours entretien', 'Exemption droit concours entretien pour passant et redoublant', 50000);

INSERT IGNORE INTO uac_ref_frais_scolarite_discount (id, dis_case, fsc_id, code, title, description, amount)
VALUES (2, 'A', 2, 'ARTINSC', 'Ancien droit inscription', 'Exemption droit inscription pour passant et redoublant', 50000);

-- T is for Transfert
INSERT IGNORE INTO uac_ref_frais_scolarite_discount (id, dis_case, fsc_id, code, title, description, amount)
VALUES (3, 'T', 1, 'TTSTENT', 'Transfert droit concours entretien', 'Exemption droit concours entretien pour transfert du Groupe ACEEM', 50000);

INSERT IGNORE INTO uac_ref_frais_scolarite_discount (id, dis_case, fsc_id, code, title, description, amount)
VALUES (4, 'T', 2, 'TRTINSC', 'Transfert droit concours entretien', 'Aucune exemption droit concours entretien pour transfert du Groupe ACEEM', 0);

-- ***********************************************************************
-- ***********************************************************************
-- ***********************************************************************
-- ***********************************************************************

DROP VIEW IF EXISTS v_all_pay;
CREATE VIEW v_all_pay AS
SELECT
	  up.id AS UP_ID,
	  up.payment_ref AS UP_PAYMENT_REF,
	  UPPER(vsh.USERNAME) AS VSH_USERNAME,
	  vsh.PAGE AS PAGE,
	  UPPER(vsh.ID) AS VSH_ID,
	  up.input_amount AS UP_INPUT_AMOUNT,
	  DATE_FORMAT(up.pay_date, "%d/%m/%Y %H:%i:%s") AS UP_PAY_DATETIME,
	  DATE_FORMAT(up.pay_date, "%d/%m/%Y") AS UP_PAY_DATE,
	  up.status AS UP_STATUS,
	  up.type_of_payment AS UP_TYPE_OF_PAYMENT,
	  up.comment AS UP_COMMENT,
	  ref.code AS REF_CODE,
	  ref.description AS REF_DESCRIPTION,
	  ref.amount AS REF_AMOUNT,
	  DATE_FORMAT(ref.deadline, "%d/%m/%Y") AS REF_DDL,
	  vsh.SHORTCLASS AS VSH_SHORT_CLASS,
	  vsh.FIRSTNAME AS VSH_FIRSTNAME,
	  vsh.LASTNAME AS VSH_LASTNAME,
	  vsh.MATRICULE AS VSH_MATRICULE,
    IFNULL(UPPER(adm.username), 'Automatique') AS LAST_AGENT_ID,
	  IFNULL(uml.transac_ref, '') AS MVO_TRANSACTION,
	  IFNULL(uml.from_phone, '') AS MVO_FROM_PHONE,
	  IFNULL(uml.details_a, '') AS MVO_DETAILS_A,
	  IFNULL(ufp.ticket_ref, '') AS UFP_TICKET,
	  IFNULL(ufp.red_pc, '0') AS UFP_POURCENTAGE_REDUCTION,
	  IFNULL(ufp.status, '') AS UFP_STATUS,
    CONCAT(
      UPPER(IFNULL(up.payment_ref, '')),
      UPPER(IFNULL(vsh.USERNAME, '')),
      UPPER(IFNULL(up.input_amount, '')),
      UPPER(IFNULL(up.type_of_payment, '')),
      UPPER(IFNULL(ref.code, '')),
      UPPER(IFNULL(vsh.FIRSTNAME, '')),
      UPPER(IFNULL(vsh.LASTNAME, '')),
      UPPER(IFNULL(vsh.SHORTCLASS, '')),
      UPPER(IFNULL(vsh.MATRICULE, ''))
    ) AS raw_data
	FROM uac_payment up
               JOIN v_showuser vsh ON up.user_id = vsh.ID
							 JOIN uac_ref_frais_scolarite ref ON ref.id = up.ref_fsc_id
							 		LEFT JOIN uac_xref_payment_mvola xref ON xref.payment_id = up.id
							 	 	LEFT JOIN uac_mvola_line uml ON uml.id = xref.mvola_id
							 	 	LEFT JOIN uac_facilite_payment ufp ON ufp.id = up.facilite_id
                  LEFT JOIN v_showadmin adm ON up.agent_id = adm.mu_id
							 ORDER BY up.last_update DESC;


DROP VIEW IF EXISTS v_all_display_discount;
CREATE VIEW v_all_display_discount AS
SELECT
	 dis.dis_case AS DIS_CASE,
	 CASE WHEN (dis.dis_case = 'A') THEN 'ANCIEN' ELSE 'TRANSFERT' END AS DIS_DESC,
	 SUM(ref.amount) AS GENUINE_AMOUNT,
	 SUM((ref.amount - dis.amount)) AS FINAL_AMOUNT
	 FROM uac_ref_frais_scolarite ref
				JOIN uac_ref_frais_scolarite_discount dis
								ON ref.id = dis.fsc_id
	  GROUP BY dis.dis_case, CASE WHEN (dis.dis_case = 'A') THEN 'ANCIEN' ELSE 'TRANSFERT' END
	  ORDER BY 1;



DROP VIEW IF EXISTS v_all_detail_discount;
CREATE VIEW v_all_detail_discount AS
SELECT
   dis.id AS DIS_ID,
   ref.id AS FSC_ID,
	 dis.dis_case AS DIS_CASE,
	 ref.code AS REF_CODE,
	 ref.amount AS REF_AMOUNT,
	 dis.amount AS DIS_AMOUNT,
	 ref.title AS REF_TITLE,
	 (ref.amount - dis.amount) AS FINAL_AMOUNT
	 FROM uac_ref_frais_scolarite ref
				JOIN uac_ref_frais_scolarite_discount dis
								ON ref.id = dis.fsc_id
  ORDER BY DIS_ID;

DROP VIEW IF EXISTS v_all_usr_mvola_case_inscription;
CREATE VIEW v_all_usr_mvola_case_inscription AS
SELECT
  vsh.ID AS ID,
  UPPER(vsh.USERNAME) AS USERNAME,
  CONCAT(vsh.FIRSTNAME, ' ', vsh.LASTNAME) AS VSH_NAME,
  vsh.SHORTCLASS AS CLASS,
  IFNULL(t_DTSTENT_CPT, 0) AS c_DTSTENT_CPT,
  IFNULL(t_DRTINSC_CPT, 0) AS c_DRTINSC_CPT,
  IFNULL(t_FRAIGEN_CPT, 0) AS c_FRAIGEN_CPT,
  'N' AS USED_ON_SCREEN
FROM v_showuser vsh LEFT JOIN (
      SELECT user_id, SUM(input_amount) AS t_DTSTENT_CPT
      FROM uac_payment WHERE ref_fsc_id IN (1) AND status = 'P' GROUP BY user_id
  ) t_DTSTENT ON t_DTSTENT.user_id = vsh.ID
 					LEFT JOIN (
      SELECT user_id, SUM(input_amount) AS t_DRTINSC_CPT
      FROM uac_payment WHERE ref_fsc_id IN (2) AND status = 'P' GROUP BY user_id
  ) t_DRTINSC ON t_DRTINSC.user_id = vsh.ID
          LEFT JOIN (
      SELECT user_id, SUM(input_amount) AS t_FRAIGEN_CPT
      FROM uac_payment WHERE ref_fsc_id IN (3) AND status = 'P' GROUP BY user_id
      ) t_FRAIGEN ON t_FRAIGEN.user_id = vsh.ID;

DROP VIEW IF EXISTS v_rep_year_recap;
CREATE VIEW v_rep_year_recap AS
SELECT
  SUM(up.input_amount) AS UP_AMOUNT,
  CASE WHEN up.type_of_payment IN ('R') THEN 'R'
    WHEN up.type_of_payment IN ('E') THEN 'E'
    ELSE 'P' END AS UP_TYPE_OF_PAYMENT
  FROM uac_payment up WHERE up.status = 'P'
GROUP BY
CASE WHEN up.type_of_payment IN ('R') THEN 'R'
  WHEN up.type_of_payment IN ('E') THEN 'E'
  ELSE 'P' END;

DROP VIEW IF EXISTS v_rep_year_det_recap;
CREATE VIEW v_rep_year_det_recap AS
SELECT
  SUM(up.input_amount) AS UP_AMOUNT, urf.type AS URF_TYPE
  FROM uac_payment up JOIN uac_ref_frais_scolarite urf
                      ON up.ref_fsc_id = urf.id
                      AND urf.type IN ('T', 'M', 'F', 'U')
  WHERE up.status = 'P'
  AND type_of_payment NOT IN ('E', 'R')
GROUP BY urf.type;


DROP VIEW IF EXISTS v_rep_month_per_mention;
CREATE VIEW v_rep_month_per_mention AS
SELECT mention AS VCC_MENTION, SUM(up.input_amount) AS UP_AMOUNT FROM uac_payment up
	JOIN mdl_user mu ON up.user_id = mu.id
						AND up.status = 'P'
							 AND up.type_of_payment NOT IN ('R', 'E')
							 AND up.pay_date > DATE_ADD(CURRENT_DATE, INTERVAL -1 MONTH)
	JOIN uac_showuser uas ON uas.username = mu.username
	 JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id
	 GROUP BY mention;

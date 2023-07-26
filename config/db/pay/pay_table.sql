-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- New table dont forget the REORG ------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- TABLE

DROP TABLE IF EXISTS uac_ref_frais_scolarite;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_frais_scolarite` (
  `id` INT UNSIGNED NOT NULL,
  `code` VARCHAR(7) NOT NULL COMMENT 'Codification is for reference',
  `title` VARCHAR(50) NOT NULL,
  `description` VARCHAR(250) NULL COMMENT 'Tranche will be 1 sur x',
  `fs_order` TINYINT NULL,
  `amount` INT UNSIGNED NOT NULL,
  `status` CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'By default A is active and I for inactive',
  `deadline` DATE NOT NULL COMMENT 'Deadline per each school year so to be revised every year during end of the year',
  `type` CHAR(1) NOT NULL DEFAULT 'U' COMMENT 'Can be U for Unique Payment or M for Multiple or T for Tranche',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  UNIQUE KEY `code_UNIQUE` (`code`));


-- DELETE FROM uac_ref_frais_scolarite;

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(1, 'DTSTENT', 'Droit test ou entretien', 'Droit test ou entretien', 1, 50000, 'A', '2022-12-05', 'U');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(2, 'DRTINSC', 'Droit inscription', 'Droit inscription', 2, 150000, 'A', '2022-12-19', 'U');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(3, 'FRAIGEN', 'Frais généraux', 'Frais généraux', 3, 200000, 'A', '2022-12-19', 'U');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(13, 'CERTSCO', 'Certificat Scolarité', 'Certificat Scolarité', 4, 600, 'A', '2023-12-31', 'M');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(4, 'L1T1XXX', 'L1 Tranche 1 sur 3', 'L1 Tranche 1 sur 3', 20, 800000, 'A', '2023-01-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(5, 'L1T2XXX', 'L1 Tranche 2 sur 3', 'L1 Tranche 2 sur 3', 21, 850000, 'A', '2023-04-30', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(6, 'L1T3XXX', 'L1 Tranche 3 sur 3', 'L1 Tranche 3 sur 3', 22, 850000, 'A', '2023-07-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(7, 'L2L3T1X', 'L2/L3 Tranche 1 sur 3', 'L2/L3 Tranche 1 sur 3', 23, 850000, 'A', '2023-01-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(8, 'L2L3T2X', 'L2/L3 Tranche 2 sur 3', 'L2/L3 Tranche 2 sur 3', 24, 850000, 'A', '2023-04-30', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(9, 'L2L3T3X', 'L2/L3 Tranche 3 sur 3', 'L2/L3 Tranche 3 sur 3', 25, 850000, 'A', '2023-07-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(10, 'M1M2T1X', 'M1/M2 Tranche 1 sur 3', 'M1/M2 Tranche 1 sur 3', 26, 950000, 'A', '2023-04-30', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(11, 'M1M2T2X', 'M1/M2 Tranche 2 sur 3', 'M1/M2 Tranche 2 sur 3', 27, 950000, 'A', '2023-07-31', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(12, 'M1M2T3X', 'M1/M2 Tranche 3 sur 3', 'M1/M2 Tranche 3 sur 3', 28, 950000, 'A', '2023-09-30', 'T');


INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(14, 'FRMVOLA', 'Frais additionnel écolage Mvola', 'Frais additionnel écolage Mvola', 90, 9000, 'A', '2023-12-31', 'F');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(1000, 'UNUSEDM', 'Solde excedentaire Mvola', 'Solde excedentaire Mvola', 100, 0, 'A', '2023-12-31', 'F');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(0, 'CANCELX', 'Paiement annulé', 'Paiement annulé', 100, 0, 'A', '2023-12-31', 'F');

--

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(15, 'CERTIFC', 'Certification', 'Certification', 50, 200, 'A', '2023-12-31', 'M');


INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(16, 'CARTEET', 'Carte étudiant', 'Carte étudiant', 50, 1000, 'A', '2023-12-31', 'M');



-- Cross ref table
DROP TABLE IF EXISTS uac_xref_cohort_fsc;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_cohort_fsc` (
  `cohort_id` INT UNSIGNED NOT NULL,
  `fsc_id` INT UNSIGNED NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cohort_id`, `fsc_id`));

-- DELETE FROM uac_xref_cohort_fsc;

-- Insert data for each level
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 1, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 2, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 3, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 13, id FROM v_class_cohort vcc;

-- Insert Tranche for L1
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 4, id FROM v_class_cohort vcc where vcc.niveau = 'L1';

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 5, id FROM v_class_cohort vcc where vcc.niveau = 'L1';

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 6, id FROM v_class_cohort vcc where vcc.niveau = 'L1';

-- Insert Tranche for L2/L3
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 7, id FROM v_class_cohort vcc where vcc.niveau IN ('L2', 'L3');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 8, id FROM v_class_cohort vcc where vcc.niveau IN ('L2', 'L3');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 9, id FROM v_class_cohort vcc where vcc.niveau IN ('L2', 'L3');

-- Insert Tranche for M1/M2
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 10, id FROM v_class_cohort vcc where vcc.niveau IN ('M1', 'M2');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 11, id FROM v_class_cohort vcc where vcc.niveau IN ('M1', 'M2');

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 12, id FROM v_class_cohort vcc where vcc.niveau IN ('M1', 'M2');


INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 15, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 16, id FROM v_class_cohort vcc;

-- REDUCTION FACILITE PAYMENT
DROP TABLE IF EXISTS uac_facilite_payment;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_facilite_payment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `category` CHAR(1) NOT NULL COMMENT 'R for Reduction, M for Mensualite, L for Letter of commitment',
  `ticket_ref` CHAR(10) NOT NULL,
  `red_pc` TINYINT UNSIGNED NULL COMMENT 'Percentage of reduction',
  `status` CHAR(1) NOT NULL DEFAULT 'I' COMMENT 'A is active, I for inactive, D is deleted',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  -- user id and category has been removed because can have several Letter of commitment and deleted reduction
  -- UNIQUE KEY `user_id_category_UNIQUE` (`user_id`, `category`),
  UNIQUE KEY `ticket_ref_UNIQUE` (`ticket_ref`));

-- WORKING TABLE FOR THE PAYMENTS
-- REDUCTION ARE CREATING FULL PAYMENT AS REDUCTION
-- NEED TO BE IN REORG !
DROP TABLE IF EXISTS uac_payment;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_payment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL COMMENT 'Codification is for reference',
  `ref_fsc_id` INT NULL COMMENT 'When not null then related to ref frais de scolarite else it is a manual payment',
  `status` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'N as Not Paid or P as Paid or F as Filled (by manual payment)  or E for Excused (example for payment test or entretien but you are not new comer) or C for Cancelled',
  `payment_ref` CHAR(10) NULL COMMENT 'Reference generated for Payment or reduction reference or empty because not yet paid',
  `facilite_id` BIGINT NULL,
  `input_amount` INT NOT NULL COMMENT 'Can be zero then it is engagement letter or free input then it is full manual',
  `type_of_payment` CHAR(1) NULL COMMENT 'C is for Cash, H for Check, M for Mvola, T for Transfert, R is for reduction, L for Engagement Letter, E for Exemption',
  `pay_date` DATETIME NULL,
  `comment` VARCHAR(45) NULL,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`));



-- VIEW
-- Get the referential per class
DROP VIEW IF EXISTS v_fsc_xref_cc;
CREATE VIEW v_fsc_xref_cc AS
SELECT
  vcc.id AS vcc_id,
  vcc.niveau AS niveau,
  vcc.mention AS mention,
  vcc.parcours AS parcours,
  vcc.groupe AS groupe,
  vcc.short_classe AS short_classe,
  urfs.id AS urfs_id,
  urfs.code AS urfs_code,
  urfs.title AS urfs_title,
  urfs.description AS urfs_description,
  urfs.fs_order AS fs_order,
  urfs.amount AS amount,
  urfs.status AS status,
  urfs.deadline AS deadline,
  urfs.type AS type
  FROM v_class_cohort vcc JOIN uac_xref_cohort_fsc xref
                          ON xref.cohort_id = vcc.id
                          JOIN uac_ref_frais_scolarite urfs
                          ON urfs.id = xref.fsc_id;

-- Get the list of user and reduction they get
DROP VIEW IF EXISTS v_payfoundusrn;
CREATE VIEW v_payfoundusrn AS
SELECT
      vsh.ID AS ID,
      UPPER(vsh.USERNAME) AS USERNAME,
      vsh.MATRICULE AS MATRICULE,
      REPLACE(CONCAT(fCapitalizeStr(vsh.FIRSTNAME), ' ', vsh.LASTNAME), "'", " ") AS NAME,
      vsh.SHORTCLASS AS CLASSE,
      ref.amount AS CERT_SCO_AMOUNT,
      GROUP_CONCAT(category, red_pc) AS EXISTING_FACILITE
      FROM v_showuser vsh JOIN uac_xref_cohort_fsc xref ON xref.cohort_id = vsh.COHORT_ID
                          JOIN uac_ref_frais_scolarite ref ON ref.id = xref.fsc_id
                                                           AND ref.code = 'CERTSCO'
                              LEFT JOIN uac_facilite_payment ufp ON vsh.ID = ufp.user_id
                                                             AND ufp.status IN ('I', 'A')
      GROUP BY ID, USERNAME, NAME, CLASSE, CERT_SCO_AMOUNT;

-- Payment view

-- Without the Mvola frais and excedent
DROP VIEW IF EXISTS v_histopayment_for_user;
CREATE VIEW v_histopayment_for_user AS
    SELECT
    up.id AS UP_ID,
      vsh.ID AS VSH_USER_ID,
      vsh.USERNAME AS VSH_USERNAME,
      IFNULL(up.status, 'N') AS UP_STATUS,
      up.payment_ref AS UP_PAYMENT_REF,
      up.facilite_id AS UP_FACILITE_ID,
      IFNULL(up.input_amount, 0) AS UP_INPUT_AMOUNT,
      up.type_of_payment AS UP_TYPE_OF_PAYMENT,
      up.comment AS UP_COMMENT,
      up.pay_date AS UP_PAY_DATE,
      DATE_FORMAT(up.pay_date, '%d/%m/%Y') AS UP_PAY_DATE_READ,
      up.create_date AS UP_CREATE_DATE,
      up.last_update AS UP_LAST_UPDATE,
      xref.fsc_id AS REF_ID,
      ref.code AS REF_CODE,
      ref.title AS REF_TITLE,
      ref.amount AS REF_AMOUNT,
      ref.deadline AS REF_DEADLINE,
      DATEDIFF(ref.deadline, CURRENT_DATE) AS NEGATIVE_IS_LATE,
      ref.type AS REF_TYPE,
      ref.fs_order AS REF_FS_ORDER,
      vsh.COHORT_ID AS COHORT_ID
    FROM uac_xref_cohort_fsc xref JOIN v_showuser vsh ON vsh.COHORT_ID = xref.cohort_id
                     JOIN uac_ref_frais_scolarite ref ON ref.id = xref.fsc_id
                                                      -- We exclude multiple which has no real deadline
                                                      AND ref.type IN ('T', 'U')
                     LEFT JOIN uac_payment up ON up.user_id = vsh.ID
                                                    AND up.ref_fsc_id = xref.fsc_id;
-- Only the Mvola frais and excedent
DROP VIEW IF EXISTS v_histo_frais_for_user;
CREATE VIEW v_histo_frais_for_user AS
SELECT
    	up2.id AS UP_ID,
      vsh2.ID AS VSH_USER_ID,
      vsh2.USERNAME AS VSH_USERNAME,
      IFNULL(up2.status, 'N') AS UP_STATUS,
      up2.payment_ref AS UP_PAYMENT_REF,
      up2.facilite_id AS UP_FACILITE_ID,
      IFNULL(up2.input_amount, 0) AS UP_INPUT_AMOUNT,
      up2.type_of_payment AS UP_TYPE_OF_PAYMENT,
      up2.comment AS UP_COMMENT,
      up2.pay_date AS UP_PAY_DATE,
      DATE_FORMAT(up2.pay_date, '%d/%m/%Y') AS UP_PAY_DATE_READ,
      up2.create_date AS UP_CREATE_DATE,
      up2.last_update AS UP_LAST_UPDATE,
      ref2.id AS REF_ID,
      ref2.code AS REF_CODE,
      ref2.title AS REF_TITLE,
      CASE WHEN (ref2.code = 'UNUSEDM') THEN up2.input_amount ELSE ref2.amount END AS REF_AMOUNT,
      ref2.deadline AS REF_DEADLINE,
      DATEDIFF(ref2.deadline, CURRENT_DATE) AS NEGATIVE_IS_LATE,
      ref2.type AS REF_TYPE,
      ref2.fs_order AS REF_FS_ORDER,
      vsh2.COHORT_ID AS COHORT_ID
    FROM uac_payment up2 JOIN v_showuser vsh2 ON up2.user_id = vsh2.ID
    						  JOIN uac_ref_frais_scolarite ref2 ON ref2.id = up2.ref_fsc_id
    						  					AND ref2.type IN ('F', 'M') ORDER BY up2.pay_date ASC;



-- left to pay on tranche view
-- To be used in combination with v_original_to_pay_for_user
DROP VIEW IF EXISTS v_left_to_pay_for_user;
CREATE VIEW v_left_to_pay_for_user AS
SELECT SUM(up.input_amount) AS ALREADY_PAID, (urf.amount - SUM(up.input_amount)) AS REST_TO_PAY,
    urf.id AS REF_ID, urf.description AS DESCRIPTION,
	urf.amount AS TRANCHE_AMOUNT, urf.code AS TRANCHE_CODE,
	DATE_FORMAT(urf.deadline, '%d/%m/%Y') AS TRANCHE_DDL,
	DATEDIFF(urf.deadline, CURRENT_DATE) AS NEGATIVE_IS_LATE,
	 vsh.USERNAME AS VSH_USERNAME,
	 vsh.ID AS VSH_ID, urf.fs_order URF_FS_ORDER
			FROM uac_ref_frais_scolarite urf
			JOIN uac_xref_cohort_fsc xref ON xref.fsc_id = urf.id
												AND urf.type = 'T'
			  JOIN uac_payment up ON up.ref_fsc_id = xref.fsc_id
			  JOIN v_showuser vsh ON vsh.COHORT_ID = xref.cohort_id
			  							AND vsh.ID = up.user_id
			  GROUP BY urf.amount, urf.code, urf.description, urf.deadline, urf.id, vsh.USERNAME, vsh.ID ORDER BY urf.fs_order ASC;

-- left to pay on tranche view
-- To be used in combination with v_left_to_pay_for_user
DROP VIEW IF EXISTS v_original_to_pay_for_user;
CREATE VIEW v_original_to_pay_for_user AS
SELECT
	0 AS ALREADY_PAID, urf.amount AS REST_TO_PAY,
    urf.id AS REF_ID, urf.description AS DESCRIPTION,
	urf.amount AS TRANCHE_AMOUNT, urf.code AS TRANCHE_CODE,
	DATE_FORMAT(urf.deadline, '%d/%m/%Y') AS TRANCHE_DDL,
	DATEDIFF(urf.deadline, CURRENT_DATE) AS NEGATIVE_IS_LATE,
	 vsh.USERNAME AS VSH_USERNAME,
	 vsh.ID AS VSH_ID, urf.fs_order URF_FS_ORDER
			FROM uac_ref_frais_scolarite urf
			JOIN uac_xref_cohort_fsc xref ON xref.fsc_id = urf.id
												AND urf.type = 'T'
				JOIN v_showuser vsh ON vsh.COHORT_ID = xref.cohort_id ORDER BY urf.fs_order ASC;

-- ***********************************************************************************
-- ***********************************************************************************
-- ***********************************************************************************
-- MVOLA
-- ***********************************************************************************
-- ***********************************************************************************
-- ***********************************************************************************
DROP TABLE IF EXISTS uac_mvola_master;
CREATE TABLE IF NOT EXISTS uac_mvola_master (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'This unique ID will be use as PK for the core table',
  `flow_id` BIGINT NULL COMMENT 'Codification is for reference',
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `cra_filename` VARCHAR(300) NOT NULL,
  `core_balance_before` INT NULL,
  `core_balance_after` INT NULL,
  `phone_account` VARCHAR(20) NOT NULL,
  `account_name` VARCHAR(100) NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `empty_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `duplicate_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `new_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `not_found_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `invalid_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- INSERT INTO uac_load_mvola (load_cra_date, transac_ref, mvo_initiator, mvo_type, canal, statut, account, load_amount, load_rrp, from_phone, to_phone, load_balance_before, load_before_after, details_a, details_b, validator, notif_ref)
-- VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
DROP TABLE IF EXISTS uac_load_mvola;
CREATE TABLE IF NOT EXISTS uac_load_mvola (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'This unique ID will be use as PK for the core table',
  `master_id` BIGINT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `load_cra_date` VARCHAR(45) NULL,
  `transac_ref` VARCHAR(20) NULL,
  `mvo_initiator` VARCHAR(20) NULL,
  `mvo_type` VARCHAR(100) NULL,
  `canal` VARCHAR(45) NULL,
  `cra_statut` VARCHAR(45) NULL,
  `account` VARCHAR(45) NULL,
  `load_amount` VARCHAR(45) NULL,
  `load_rrp` VARCHAR(45) NULL,
  `from_phone` VARCHAR(45) NULL,
  `to_phone` VARCHAR(45) NULL,
  `load_balance_before` VARCHAR(45) NULL,
  `load_before_after` VARCHAR(45) NULL,
  `details_a` VARCHAR(45) NULL,
  `details_b` VARCHAR(45) NULL,
  `validator` VARCHAR(45) NULL,
  `notif_ref` VARCHAR(45) NULL,
  `core_cra_datetime` DATETIME NULL,
  `core_amount` INT NULL,
  `core_rrp` INT NULL,
  `core_balance_before` INT NULL,
  `core_balance_after` INT NULL,
  `core_username` VARCHAR(20) NULL,
  `core_user_id` BIGINT NULL,
  `reject_reason` VARCHAR(45) NULL,
  `create_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_mvola_line;
CREATE TABLE IF NOT EXISTS uac_mvola_line (
  `id` BIGINT UNSIGNED NOT NULL COMMENT 'This unique ID will be use as PK for the core table',
  `master_id` BIGINT NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `user_id` BIGINT NULL,
  `transac_ref` VARCHAR(20) NOT NULL COMMENT 'Unique manual creation',
  `x_payment_id` BIGINT NULL,
  `mvo_initiator` VARCHAR(20) NULL,
  `mvo_type` VARCHAR(100) NULL,
  `canal` VARCHAR(45) NULL,
  `cra_statut` VARCHAR(45) NULL,
  `account` VARCHAR(45) NULL,
  `from_phone` VARCHAR(45) NULL,
  `to_phone` VARCHAR(45) NULL,
  `details_a` VARCHAR(45) NULL,
  `details_b` VARCHAR(45) NULL,
  `validator` VARCHAR(45) NULL,
  `notif_ref` VARCHAR(45) NULL,
  `core_cra_datetime` DATETIME NULL,
  `core_amount` INT NULL,
  `core_rrp` INT NULL,
  `core_balance_before` INT NULL,
  `core_balance_after` INT NULL,
  `order_direction` CHAR(1) NOT NULL COMMENT 'It can be C for Credit or D for Debit',
  `nbr_of_load_line` TINYINT NULL DEFAULT 1 COMMENT 'For Debit we have 2 for sum of frais',
  `comment` VARCHAR(100) NULL,
  `create_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `update_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transac_ref_UNIQUE` (`transac_ref`));


DROP TABLE IF EXISTS uac_xref_payment_mvola;
CREATE TABLE IF NOT EXISTS uac_xref_payment_mvola (
  `payment_id` BIGINT UNSIGNED NOT NULL,
  `mvola_id` BIGINT UNSIGNED NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`, `mvola_id`));




DROP VIEW IF EXISTS v_mvola_manager;
CREATE VIEW v_mvola_manager AS
SELECT
  ulm.id AS ULM_ID,
  ulm.status AS STATUS_TRANSACTION,
	ulm.transac_ref AS REF_TRANSACTION,
	ulm.load_cra_date AS DATE_HEURE_TRANSACTION,
	ulm.mvo_type AS TYPE_TRANSACTION,
	ulm.load_amount AS MONTANT_TRANSACTION,
	ulm.from_phone AS TELEPHONE_EXPEDITEUR,
	ulm.to_phone AS TELEPHONE_DESTINATAIRE,
	ulm.details_a AS DETAIL_A,
	ulm.details_b AS DETAIL_B,
	ulm.core_username AS USERNAME_LU,
	 DATE_FORMAT(ulm.core_cra_datetime, "%d/%m/%Y %H:%i:%s") AS DATE_HEURE_TRANSACTION_LU,
 	 DATE_FORMAT(ulm.core_cra_datetime, "%d/%m/%Y") AS DATE_TRANSACTION_LU,
	ulm.reject_reason AS RAISON_REJET,
	umm.cra_filename AS NOM_FICHIER,
	 DATE_FORMAT(umm.update_date, "%d/%m/%Y %H:%i:%s") AS DATE_HEURE_INTEGRATION,
	 umm.core_balance_before AS SOLDE_FICHIER_AVANT,
	 umm.core_balance_after AS SOLDE_FICHIER_APRES,
	umm.phone_account AS TELEPHONE_COMPTE,
	umm.account_name AS NOM_COMPTE,
  CONCAT(
    UPPER(IFNULL(ulm.transac_ref, '')),
    UPPER(IFNULL(ulm.load_amount, '')),
    UPPER(IFNULL(ulm.details_a, '')),
    UPPER(IFNULL(ulm.details_b, '')),
    UPPER(IFNULL(ulm.from_phone, '')),
    UPPER(IFNULL(ulm.to_phone, ''))
  ) AS raw_data
FROM uac_mvola_master umm
			JOIN uac_load_mvola ulm ON umm.id = ulm.master_id
			ORDER BY STR_TO_DATE(ulm.load_cra_date,'%d/%m/%Y %H:%i:%s') DESC;

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
	FROM uac_payment up JOIN v_showuser vsh ON up.user_id = vsh.ID
							 JOIN uac_ref_frais_scolarite ref ON ref.id = up.ref_fsc_id
							 		LEFT JOIN uac_xref_payment_mvola xref ON xref.payment_id = up.id
							 	 	LEFT JOIN uac_mvola_line uml ON uml.id = xref.mvola_id
							 	 	LEFT JOIN uac_facilite_payment ufp ON ufp.id = up.facilite_id
							 ORDER BY up.pay_date DESC;


/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/*********************************         DASHBOARD        ***************************************/
/**************************************************************************************************/
/**************************************************************************************************/
/**************************************************************************************************/

DROP VIEW IF EXISTS v_dash_concat_mvola;
CREATE VIEW v_dash_concat_mvola AS
  SELECT SUM(core_amount) AS MVO_AMOUNT, to_phone AS TO_PHONE, order_direction AS ORDER_DIRECTION
  FROM uac_mvola_line
  GROUP BY to_phone, order_direction
  ORDER BY SUM(core_amount) DESC;

DROP VIEW IF EXISTS v_dash_tech_sum_up_tranche;
CREATE VIEW v_dash_tech_sum_up_tranche AS
SELECT * FROM (
    SELECT
      vop.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
      FROM v_original_to_pay_for_user vop
      LEFT JOIN uac_payment up ON vop.REF_ID = up.ref_fsc_id
                              AND up.user_id = vop.VSH_ID
                              AND up.type_of_payment = 'L'
      WHERE CONCAT(vop.TRANCHE_CODE, vop.VSH_ID) NOT IN (
          SELECT CONCAT(tvpu.TRANCHE_CODE, tvpu.VSH_ID) FROM v_left_to_pay_for_user tvpu
          )
          UNION  SELECT vpu.*, IFNULL(up.type_of_payment, 'N') AS COMMITMENT_LETTER
          FROM v_left_to_pay_for_user vpu  LEFT JOIN uac_payment up ON vpu.REF_ID = up.ref_fsc_id
                                                                    AND up.user_id = vpu.VSH_ID
                                                                    AND up.type_of_payment = 'L'
  ) t ORDER BY t.URF_FS_ORDER ASC;

DROP VIEW IF EXISTS v_dash_sum_up_tranche_grid;
CREATE VIEW v_dash_sum_up_tranche_grid AS
SELECT COUNT(1) AS COUNT_PART, SUM(vdt.REST_TO_PAY) AS TOTAL_AMOUNT,
	CASE WHEN vdt.REST_TO_PAY = 0 THEN 'TOUT' WHEN vdt.REST_TO_PAY = vdt.TRANCHE_AMOUNT THEN 'RIEN' ELSE 'UNE PARTIE' END AS CATEGORY,
	CASE WHEN vdt.TRANCHE_CODE IN ('L1T1XXX', 'L2L3T1X', 'M1M2T1X') THEN 'Tranche 1'
			WHEN vdt.TRANCHE_CODE IN ('L1T2XXX', 'L2L3T2X', 'M1M2T2X') THEN 'Tranche 2'
			ELSE 'Tranche 3' END  AS TRANCHE
	FROM v_dash_tech_sum_up_tranche vdt
GROUP BY
	CASE WHEN vdt.REST_TO_PAY = 0 THEN 'TOUT' WHEN vdt.REST_TO_PAY = vdt.TRANCHE_AMOUNT THEN 'RIEN' ELSE 'UNE PARTIE' END,
	CASE WHEN vdt.TRANCHE_CODE IN ('L1T1XXX', 'L2L3T1X', 'M1M2T1X') THEN 'Tranche 1'
			WHEN vdt.TRANCHE_CODE IN ('L1T2XXX', 'L2L3T2X', 'M1M2T2X') THEN 'Tranche 2'
			ELSE 'Tranche 3' END
			ORDER BY TRANCHE, CATEGORY;

DROP VIEW IF EXISTS v_dash_all_reduction;
CREATE VIEW v_dash_all_reduction AS
SELECT up.payment_ref AS UP_PAY_REF,
		UPPER(VSH.USERNAME) AS VSH_USERNAME,
		up.input_amount AS UP_AMOUNT,
		up.type_of_payment AS UP_TYPE_OF_PAYMENT,
		DATE_FORMAT(up.pay_date, "%d/%m/%Y") AS UP_PAY_DATE,
		VSH.FIRSTNAME AS VSH_FIRSTNAME,
		VSH.LASTNAME AS VSH_LASTNAME,
    VSH.MATRICULE AS VSH_MATRICULE,
		VSH.SHORTCLASS AS VSH_SHORTCLASS,
		ufp.ticket_ref AS UFP_TICKET,
		ufp.red_pc AS REDUCTION_PC
		FROM uac_payment up
JOIN v_showuser VSH ON VSH.ID = up.user_id
JOIN uac_facilite_payment ufp ON ufp.id = up.facilite_id
WHERE up.type_of_payment IN ('R', 'L') ORDER BY up.pay_date DESC;

DROP VIEW IF EXISTS v_dash_all_tranche;
CREATE VIEW v_dash_all_tranche AS
SELECT
	VSH.FIRSTNAME AS VSH_FIRSTNAME,
	VSH.LASTNAME AS VSH_LASTNAME,
    VSH.MATRICULE AS VSH_MATRICULE,
	VSH.SHORTCLASS AS VSH_SHORTCLASS,
	 UPPER(VSH.USERNAME) AS VSH_USERNAME,
 	 VSH.PHONE AS VSH_PHONE,
 	 VSH.PARENT_PHONE AS VSH_PARENT_PHONE,
	vts.ALREADY_PAID,
	 vts.REST_TO_PAY,
	 vts.DESCRIPTION,
	 vts.TRANCHE_AMOUNT,
	 vts.TRANCHE_CODE,
	 vts.TRANCHE_DDL,
	 vts.NEGATIVE_IS_LATE
FROM v_dash_tech_sum_up_tranche vts JOIN v_showuser VSH ON VSH.ID = vts.VSH_ID
ORDER BY TRANCHE_DDL ASC;



DROP VIEW IF EXISTS v_recette_journee;
CREATE VIEW v_recette_journee AS
SELECT
	  up.id AS UP_ID,
	  up.payment_ref AS UP_PAYMENT_REF,
	  UPPER(vsh.USERNAME) AS VSH_USERNAME,
	  up.input_amount AS UP_INPUT_AMOUNT,
	  DATE_FORMAT(up.pay_date, "%d/%m/%Y %H:%i:%s") AS UP_PAY_DATETIME,
	  DATE_FORMAT(up.pay_date, "%d/%m/%Y") AS UP_PAY_DATE,
	  up.pay_date AS TECH_DATE,
	  up.status AS UP_STATUS,
	  up.type_of_payment AS UP_TYPE_OF_PAYMENT,
	  up.comment AS UP_COMMENT,
	  ref.code AS REF_CODE,
	  ref.description AS REF_DESCRIPTION,
	  vsh.SHORTCLASS AS VSH_SHORT_CLASS,
	  vsh.FIRSTNAME AS VSH_FIRSTNAME,
	  vsh.LASTNAME AS VSH_LASTNAME,
	  vsh.MATRICULE AS VSH_MATRICULE,
	  vcc.mention_code AS VCC_MENTION_CODE,
	  vcc.mention AS VCC_MENTION
	FROM uac_payment up JOIN v_showuser vsh ON up.user_id = vsh.ID
								   JOIN v_class_cohort vcc ON vcc.id = vsh.COHORT_ID
							 JOIN uac_ref_frais_scolarite ref ON ref.id = up.ref_fsc_id
	WHERE up.type_of_payment NOT IN ('R', 'M', 'E')
	AND up.pay_date > CURRENT_DATE
							 ORDER BY up.pay_date DESC;

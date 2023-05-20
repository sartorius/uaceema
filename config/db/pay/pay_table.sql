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
(13, 'CERTSCO', 'Certificat Scolarité', 'Certificat Scolarité', 4, 5000, 'A', '2023-12-31', 'M');

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


-- REDUCTION FACILITE PAYMENT
DROP TABLE IF EXISTS uac_facilite_payment;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_facilite_payment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `category` CHAR(1) NOT NULL COMMENT 'R for Reduction, M for Mensualite',
  `ticket_ref` CHAR(10) NOT NULL,
  `red_pc` TINYINT UNSIGNED NULL COMMENT 'Percentage of reduction',
  `status` CHAR(1) NOT NULL DEFAULT 'I' COMMENT 'A is active and I for inactive',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  UNIQUE KEY `user_id_category_UNIQUE` (`user_id`, `category`),
  UNIQUE KEY `ticket_ref_UNIQUE` (`ticket_ref`));

-- WORKING TABLE FOR THE PAYMENTS
-- REDUCTION ARE CREATING FULL PAYMENT AS REDUCTION
-- NEED TO BE IN REORG !
DROP TABLE IF EXISTS uac_payment;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_payment` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL COMMENT 'Codification is for reference',
  `ref_fsc_id` INT NULL COMMENT 'When not null then related to ref frais de scolarite else it is a manual payment',
  `status` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'N as Not Paid or P as Paid or F as Filled (by manual payment)  or E for Excused (example for payment test or entretien but you are not new comer) ',
  `payment_ref` CHAR(10) NULL COMMENT 'Reference generated for Payment or reduction reference or empty because not yet paid',
  `facilite_id` BIGINT NULL,
  `manual_amount` INT NULL,
  `type_of_payment` CHAR(1) NULL COMMENT 'C is for Cash, H for Check, M for Mvola, T for Transfert, R is for reduction',
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
        GROUP_CONCAT(category, red_pc) AS EXISTING_FACILITE
        FROM v_showuser vsh LEFT JOIN uac_facilite_payment ufp ON vsh.ID = ufp.user_id
        GROUP BY ID, USERNAME, NAME, CLASSE;

-- Payment view
DROP VIEW IF EXISTS v_payment_for_user;
CREATE VIEW v_payment_for_user AS
    SELECT
      up.id AS UP_ID,
      up.user_id AS UP_USER_ID,
      IFNULL(up.status, 'N') AS UP_STATUS,
      up.payment_ref AS UP_PAYMENT_REF,
      up.facilite_id AS UP_FACILITE_ID,
      up.manual_amount AS UP_MANUAL_AMOUNT,
      up.type_of_payment AS UP_TYPE_OF_PAYMENT,
      up.comment AS UP_COMMENT,
      up.create_date AS UP_CREATE_DATE,
      up.last_update AS UP_LAST_UPDATE,
      ref.id AS REF_ID,
      ref.code AS REF_CODE,
      ref.title AS REF_TITLE,
      ref.amount AS REF_AMOUNT,
      ref.deadline AS REF_DEADLINE,
      DATEDIFF(ref.deadline, CURRENT_DATE) AS NEGATIVE_IS_LATE,
      ref.type AS REF_TYPE,
      ref.fs_order AS REF_FS_ORDER,
      vcc.id AS COHORT_ID
    FROM uac_payment up RIGHT JOIN uac_ref_frais_scolarite ref ON up.ref_fsc_id = ref.id
                            JOIN uac_xref_cohort_fsc xref ON ref.id = xref.fsc_id
                            JOIN v_class_cohort vcc ON vcc.id = xref.cohort_id
    -- We exclude multiple which has no real deadline
    WHERE ref.type IN ('T', 'U');

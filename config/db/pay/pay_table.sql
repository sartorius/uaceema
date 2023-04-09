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
  `type` CHAR(1) NOT NULL DEFAULT 'U' COMMENT 'Can be U for Unique Payment or T for Tranche',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  -- Manual add of the constraint
  UNIQUE KEY `code_UNIQUE` (`code`));

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
(4, 'L1T1XXX', 'L1 Tranche 1/3', 'L1 Tranche 1/3', 4, 800000, 'A', '2023-02-06', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(5, 'L1T2XXX', 'L1 Tranche 2/3', 'L1 Tranche 2/3', 5, 850000, 'A', '2023-04-10', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(6, 'L1T3XXX', 'L1 Tranche 3/3', 'L1 Tranche 3/3', 6, 850000, 'A', '2023-04-10', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(7, 'L2L3T1X', 'L2/L3 Tranche 1/3', 'L2/L3 Tranche 1/3', 7, 850000, 'A', '2023-02-06', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(8, 'L2L3T2X', 'L2/L3 Tranche 2/3', 'L2/L3 Tranche 2/3', 8, 850000, 'A', '2023-04-10', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(9, 'L2L3T3X', 'L2/L3 Tranche 3/3', 'L2/L3 Tranche 3/3', 9, 850000, 'A', '2023-04-10', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(10, 'M1M2T1X', 'M1/M2 Tranche 1/3', 'M1/M2 Tranche 1/3', 10, 950000, 'A', '2023-02-06', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(11, 'M1M2T2X', 'M1/M2 Tranche 2/3', 'M1/M2 Tranche 2/3', 11, 950000, 'A', '2023-04-10', 'T');

INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(12, 'M1M2T3X', 'M1/M2 Tranche 3/3', 'M1/M2 Tranche 3/3', 12, 950000, 'A', '2023-04-10', 'T');


-- Cross ref table
DROP TABLE IF EXISTS uac_xref_cohort_fsc;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_cohort_fsc` (
  `cohort_id` INT UNSIGNED NOT NULL,
  `fsc_id` INT UNSIGNED NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cohort_id`, `fsc_id`));

-- Insert data for each level
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 1, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 2, id FROM v_class_cohort vcc;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 3, id FROM v_class_cohort vcc;

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


-- VIEW
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

DROP VIEW IF EXISTS v_payfoundusrn;
CREATE VIEW v_payfoundusrn AS
SELECT
      vsh.ID AS ID,
      UPPER(vsh.USERNAME) AS USERNAME,
      vsh.MATRICULE AS MATRICULE,
      REPLACE(CONCAT(fCapitalizeStr(vsh.FIRSTNAME), ' ', vsh.LASTNAME), "'", " ") AS NAME,
      vsh.SHORTCLASS AS CLASSE
      FROM v_showuser vsh;

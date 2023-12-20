
INSERT INTO uac_ref_frais_scolarite
(`id`, `code`, `title`, `description`, `fs_order`, `amount`, `status`, `deadline`, `type`) VALUES
(17, 'DRTNOUV', 'Droit nouveau', 'Droit nouveau', 2, 50000, 'A', '2023-12-19', 'U');


INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 17, id FROM v_class_cohort vcc;

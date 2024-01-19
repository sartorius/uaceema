
-- Do the Insert in uac_cohort and replace xx by matching value
INSERT IGNORE INTO uac_cohort (id, mention, niveau, parcours_id, groupe_id)
  VALUES
  (xx, (SELECT par_code FROM uac_ref_mention WHERE title = 'DROIT'), 'L1', (SELECT id FROM uac_ref_parcours WHERE title = 'D4'), (SELECT id FROM uac_ref_groupe WHERE title = 'Groupe 2'));


-- For the check an example of the same level select * from uac_xref_cohort_fsc where cohort_id = 9;
-- Insert data for each level
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 1, 50;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 2, 50;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 3, 50;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 13, 50;

-- LEVEL DEPENDENT START
-- Insert Tranche for L2/L3
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 4, 50;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 5, 50;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 6, 50;

-- LEVEL DEPENDENT END

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 15, 50;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 16, 50;

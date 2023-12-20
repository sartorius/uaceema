


-- Insert data for each level
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 1, 49;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 2, 49;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 3, 49;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 13, 49;

-- LEVEL DEPENDENT START
-- Insert Tranche for L2/L3
INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 7, 49;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 8, 49;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 9, 49;

-- LEVEL DEPENDENT END

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 15, 49;

INSERT INTO uac_xref_cohort_fsc (fsc_id, cohort_id)
SELECT 16, 49;

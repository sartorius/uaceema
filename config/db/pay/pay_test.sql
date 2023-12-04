-- For test usage only
-- Not to be compiled

-- This query need to avoid duplicate
-- Long query for support
INSERT INTO uac_payment (`user_id`, `ref_fsc_id`)
SELECT vs.ID, xr.fsc_id FROM v_showuser vs
                                JOIN uac_xref_cohort_fsc xr
                                  ON vs.COHORT_ID = xr.cohort_id
        WHERE (vs.ID, xr.fsc_id) NOT IN (SELECT user_id, ref_fsc_id FROM uac_payment);

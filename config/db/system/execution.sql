
-- From Connection SP
-- Launch the UACShower
CALL SRV_UPD_UACShower();

-- COHORT ID to be udpated !!!

-- update uac_showuser SET cohort_id = 15;


-- ONLY FOR Test
/*
UPDATE uac_showuser uas SET uas.cohort_id = ((SELECT id FROM mdl_user mu WHERE mu.username = uas.username) % 48) + 1 WHERE uas.cohort_id IS NULL;
select MAX(cohort_id) from uac_showuser;
select MIN(cohort_id) from uac_showuser;
*/

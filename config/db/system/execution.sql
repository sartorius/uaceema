

-- COHORT ID to be udpated !!!
-- 1/ Create user
-- 2/ Add to course !!!

-- From Connection SP
-- 3/ Launch the UACShower
CALL SRV_UPD_UACShower();
-- 4/ update uac_showuser SET cohort_id = <correct cours ID> where cohort_id IS NULL;


-- ONLY FOR Test
/*
UPDATE uac_showuser uas SET uas.cohort_id = ((SELECT id FROM mdl_user mu WHERE mu.username = uas.username) % 48) + 1 WHERE uas.cohort_id IS NULL;
select MAX(cohort_id) from uac_showuser;
select MIN(cohort_id) from uac_showuser;
*/

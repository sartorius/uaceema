
-- From Connection SP
-- Launch the UACShower
CALL SRV_UPD_UACShower();

-- ONLY FOR Test
/*
UPDATE uac_showuser uas SET uas.cohort_id = ((SELECT id FROM mdl_user mu WHERE mu.username = uas.username) % 48) + 1 WHERE uas.cohort_id IS NULL;
select MAX(cohort_id) from uac_showuser;
select MIN(cohort_id) from uac_showuser;
*/

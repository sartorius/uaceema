-- update param TECYEAR
xxx


-- update all frais de scolarité deadline
-- You must have current year and current next year
UPDATE uac_ref_frais_scolarite SET deadline = DATE_ADD(deadline, INTERVAL 1 YEAR);

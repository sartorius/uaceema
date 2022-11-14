USE ACEA;

-- This is run automatically by cron

DELETE FROM uac_working_flow WHERE create_date < DATE_ADD(current_date, INTERVAL -30 DAY);
DELETE FROM uac_load_edt WHERE create_date < DATE_ADD(current_date, INTERVAL -30 DAY);
DELETE FROM uac_load_scan WHERE create_date < DATE_ADD(current_date, INTERVAL -10 DAY);
DELETE FROM uac_scan WHERE create_date < DATE_ADD(current_date, INTERVAL -10 DAY);
DELETE FROM uac_assiduite WHERE status = 'PON' AND create_date < DATE_ADD(current_date, INTERVAL -10 DAY);

PURGE BINARY LOGS BEFORE DATE_ADD(current_date, INTERVAL -10 DAY);

OPTIMIZE TABLE uac_load_edt;
OPTIMIZE TABLE uac_load_scan;
OPTIMIZE TABLE uac_scan;
OPTIMIZE TABLE uac_edt_master;
OPTIMIZE TABLE uac_edt_line;

SELECT NOW() AS END_TIME;

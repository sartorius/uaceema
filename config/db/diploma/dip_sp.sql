DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_CRT_Diploma$$
CREATE PROCEDURE `SRV_CRT_Diploma`(IN param_year SMALLINT)
BEGIN
    DECLARE count_err	SMALLINT;
    DECLARE code_name_size	TINYINT;

    SELECT 0 INTO count_err;
    SELECT 7 INTO code_name_size;

    -- Validate all data
    UPDATE uac_load_dip uld SET status = 'INP' WHERE status = 'NEW';
    UPDATE uac_load_dip uld SET status = 'ERL' WHERE level NOT IN ('L', 'M') AND uld.status = 'INP';
    UPDATE uac_load_dip uld SET status = 'ERY' WHERE load_year NOT IN (param_year) AND uld.status = 'INP';

    UPDATE uac_load_dip uld JOIN uac_ref_dip_type urdt ON uld.load_type = urdt.par_code
      SET uld.core_type = urdt.id WHERE uld.status = 'INP';

    UPDATE uac_load_dip uld SET status = 'ERT' WHERE core_type IS NULL AND uld.status = 'INP';

    SELECT COUNT(1) INTO count_err FROM uac_load_dip WHERE status NOT IN ('INP');

    IF (count_err = 0) THEN
        INSERT INTO uac_dip (id, level, year, lastname, firstname, core_type)
          SELECT id, level, load_year, lastname, firstname, core_type FROM uac_load_dip WHERE status = 'INP';

        UPDATE uac_dip ud SET ud.code_name = RPAD(SUBSTRING(UPPER(REPLACE(REPLACE(lastname, ' ', ''), '-', '')), 1, code_name_size), code_name_size, "X") WHERE secret IS NULL;
        -- Add secret
        UPDATE uac_dip SET secret = 7000 + FLOOR(RAND()*1000), last_update = NOW() WHERE secret IS NULL;
        -- End of the correct process
    ELSE
        SELECT 'ERR SRV_CRT_Diploma uac_load_dip Some error has been found';
    END IF;

END$$
-- Remove $$ for OVH
-- Input all diploma then call CALL SRV_CRT_Diploma(2022);

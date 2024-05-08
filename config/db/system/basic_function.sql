DELIMITER $$
DROP FUNCTION IF EXISTS fEscapeStr$$
CREATE FUNCTION fEscapeStr(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN REPLACE(REPLACE(REPLACE(REPLACE(input, "'", " "), '"', ' '), ',', ' '), ';', '');
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fEscapeLineFeed$$
CREATE FUNCTION fEscapeLineFeed(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN REPLACE(
	    REPLACE(REPLACE(input, "\t", " "), '\r', '\\r'),
	    '\n',
	    '\\n'
	);
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fRemoveLineFeed$$
CREATE FUNCTION fRemoveLineFeed(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN REPLACE(
	    REPLACE(input, '\r', ' - '),
	    '\n',
	    ' - '
	);
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fCapitalizeStr$$
CREATE FUNCTION fCapitalizeStr(
	input VARCHAR(1000)
)
RETURNS VARCHAR(1000)
DETERMINISTIC
BEGIN
	RETURN TRIM(CONCAT(UPPER(SUBSTRING(input,1,1)),LOWER(SUBSTRING(input,2))));
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fGetDailyTokenPayment$$
CREATE FUNCTION fGetDailyTokenPayment()
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
	DECLARE param_exists	TINYINT;
	DECLARE token_value	VARCHAR(500);

	SELECT COUNT(1) INTO param_exists FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKPAYD';

	IF param_exists > 0 THEN
			-- We read the existing daily token
			SELECT par_value INTO token_value FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKPAYD';

	 ELSE
			-- statements ;
			-- SELECT 'NOT EMPTY parameters';
			SELECT MD5(CONCAT('TOKPAYD', CURRENT_DATE)) INTO token_value;
			UPDATE uac_param SET par_date = CURRENT_DATE, par_value = token_value WHERE key_code = 'TOKPAYD';

	 END IF;

	RETURN token_value;
END$$


DELIMITER $$
DROP FUNCTION IF EXISTS fGetDailyTokenEDT$$
CREATE FUNCTION fGetDailyTokenEDT()
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
	DECLARE param_exists	TINYINT;
	DECLARE token_value	VARCHAR(500);

	SELECT COUNT(1) INTO param_exists FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKEDTD';

	IF param_exists > 0 THEN
			-- We read the existing daily token
			SELECT par_value INTO token_value FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKEDTD';

	 ELSE
			-- statements ;
			-- SELECT 'NOT EMPTY parameters';
			SELECT MD5(CONCAT('TOKEDTD', CURRENT_DATE)) INTO token_value;
			UPDATE uac_param SET par_date = CURRENT_DATE, par_value = token_value WHERE key_code = 'TOKEDTD';

	 END IF;

	RETURN token_value;
END$$

DELIMITER $$
DROP FUNCTION IF EXISTS fGetDailyTokenGEN$$
CREATE FUNCTION fGetDailyTokenGEN()
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
	DECLARE param_exists	TINYINT;
	DECLARE token_value	VARCHAR(500);

	SELECT COUNT(1) INTO param_exists FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKEGEN';

	IF param_exists > 0 THEN
			-- We read the existing daily token
			SELECT par_value INTO token_value FROM uac_param WHERE par_date = CURRENT_DATE AND key_code = 'TOKEGEN';

	 ELSE
			-- statements ;
			-- SELECT 'NOT EMPTY parameters';
			SELECT MD5(CONCAT('TOKEGEN', CURRENT_DATE)) INTO token_value;
			UPDATE uac_param SET par_date = CURRENT_DATE, par_value = token_value WHERE key_code = 'TOKEGEN';

	 END IF;

	RETURN token_value;
END$$


-- SELECT fSplitStr('1595/DT/IIIèA', '/', 1) as matricule;
DELIMITER $$
DROP FUNCTION IF EXISTS fSplitStr$$
CREATE FUNCTION fSplitStr(
  x VARCHAR(255),
  delim VARCHAR(12),
  pos INT
)
RETURNS VARCHAR(255)
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
       LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
       delim, '');
$$

-- Return an INT Unsigned for matricule
DELIMITER $$
DROP FUNCTION IF EXISTS fGetMatriculeNum$$
CREATE FUNCTION fGetMatriculeNum(
  x VARCHAR(255)
)
RETURNS INT UNSIGNED
RETURN CAST(fSplitStr(x, '/', 1) AS UNSIGNED);
$$

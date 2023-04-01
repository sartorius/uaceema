-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- New table dont forget the REORG ------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------
-- --------------------------------------------------------------------------

-- VIEW
DROP VIEW IF EXISTS v_payfoundusrn;
CREATE VIEW v_payfoundusrn AS
SELECT
      vsh.ID AS ID,
      UPPER(vsh.USERNAME) AS USERNAME,
      vsh.MATRICULE AS MATRICULE,
      REPLACE(CONCAT(fCapitalizeStr(vsh.FIRSTNAME), ' ', vsh.LASTNAME), "'", " ") AS NAME,
      vsh.SHORTCLASS AS CLASSE
      FROM v_showuser vsh;

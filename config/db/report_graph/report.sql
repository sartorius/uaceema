-- Report are here
-- Obsolete see the one in mig
/*
DROP VIEW IF EXISTS rep_course_dash;
CREATE VIEW rep_course_dash AS
SELECT vcc.short_classe AS CLASSE,
		CASE
        WHEN UPPER(DAYNAME(uel.day)) = 'MONDAY' THEN "Lundi"
        WHEN UPPER(DAYNAME(uel.day)) = 'TUESDAY' THEN "Mardi"
        WHEN UPPER(DAYNAME(uel.day)) = 'WEDNESDAY' THEN "Mercredi"
        WHEN UPPER(DAYNAME(uel.day)) = 'THURSDAY' THEN "Jeudi"
        WHEN UPPER(DAYNAME(uel.day)) = 'FRIDAY' THEN "Vendredi"
        ELSE "Samedi"
        END AS JOUR,
		-- C is for CANCEL the rest are not
    CASE WHEN uel.course_status = "C" THEN "Annulé" ELSE "Présenté" END AS COURSE_STATUS,
    REPLACE(REPLACE(uel.raw_course_title, "\n", " - "), ",", "") AS COURS_DETAILS,
    DATE_FORMAT(uel.day, "%d/%m") AS COURS_DATE,
    CASE
                      WHEN DATE_FORMAT(uel.day, "%m") = '01' THEN "Janvier"
                      WHEN DATE_FORMAT(uel.day, "%m") = '02' THEN "Février"
                      WHEN DATE_FORMAT(uel.day, "%m") = '03' THEN "Mars"
                      WHEN DATE_FORMAT(uel.day, "%m") = '04' THEN "Avril"
                      WHEN DATE_FORMAT(uel.day, "%m") = '05' THEN "Mai"
                      WHEN DATE_FORMAT(uel.day, "%m") = '06' THEN "Juin"
                      WHEN DATE_FORMAT(uel.day, "%m") = '07' THEN "Juillet"
                      WHEN DATE_FORMAT(uel.day, "%m") = '08' THEN "Aout"
                      WHEN DATE_FORMAT(uel.day, "%m") = '09' THEN "Septembre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '10' THEN "Octobre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '11' THEN "Novembre"
                      ELSE "Décembre"
                      END AS MOIS,
    CONCAT(uel.hour_starts_at, 'h', CASE WHEN (CHAR_LENGTH(uel.min_starts_at) = 1) THEN '00' ELSE uel.min_starts_at END) AS DEBUT_COURS,
    CASE WHEN t_abs.abs_cnt IS NULL THEN 0 ELSE t_abs.abs_cnt END AS NBR_ABS,
    CASE WHEN t_qui.qui_cnt IS NULL THEN 0 ELSE t_qui.qui_cnt END AS NBR_QUI, t_cohort_count.cohort_count AS NUMBER_STUD,
    CASE WHEN uao.id IS NULL THEN 'NON' ELSE 'OUI' END AS OFF_DAY, uel.day AS TECH_DAY, uel.hour_starts_at AS TECH_HOUR
	FROM (
		SELECT edt_id AS abs_edt_id, count(1) AS abs_cnt
		FROM uac_assiduite
		WHERE status = 'ABS'
		GROUP BY edt_id
  ) t_abs RIGHT JOIN uac_edt_line uel ON uel.id = t_abs.abs_edt_id
	 LEFT JOIN (
		SELECT edt_id AS qui_edt_id, count(1) AS qui_cnt
		FROM uac_assiduite
		WHERE status = 'QUI'
		GROUP BY edt_id
	 ) t_qui ON uel.id = t_qui.qui_edt_id
	 JOIN uac_edt_master uem ON uel.master_id = uem.id
								AND uem.visibility = 'V'
	JOIN v_class_cohort vcc ON vcc.id = uem.cohort_id
	JOIN (
	SELECT cohort_id AS vshcohort_id, count(1) AS cohort_count
	FROM v_showuser
	GROUP BY cohort_id
	) t_cohort_count ON t_cohort_count.vshcohort_id = uem.cohort_id
	LEFT JOIN uac_assiduite_off uao ON uao.working_date = uel.day
	WHERE (uel.duration_hour + uel.duration_min) > 0
	AND uel.course_status NOT IN ('1', '2')
	AND uel.day <= CURRENT_DATE
	ORDER BY uel.day DESC;
*/

DROP VIEW IF EXISTS rep_no_exit;
CREATE VIEW rep_no_exit AS
SELECT DISTINCT REPLACE(CONCAT(vsh.FIRSTNAME, ' ', vsh.LASTNAME), "'", " ") AS NAME, UPPER(vsh.USERNAME) AS USERNAME, vsh.MATRICULE AS MATRICULE, vcc.short_classe AS CLASSE, DATE_FORMAT(max_scan.scan_date, "%d/%m") AS INVDATE, max_scan.scan_date AS TECH_DATE,
	CASE
                      WHEN DAYOFWEEK(max_scan.scan_date) = 2 THEN "Lundi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 3 THEN "Mardi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 4 THEN "Mercredi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 5 THEN "Jeudi"
                      WHEN DAYOFWEEK(max_scan.scan_date) = 6 THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR, 'Scan sortie manquant' AS REASON  FROM (
          -- List of last scan of people
          SELECT mu.id AS mu_id, usa.scan_date AS nooutscan_date, max(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE 1=1
					-- For these specific dates
          AND usa.scan_date < CURRENT_DATE
					AND usa.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)
          GROUP BY mu.id, usa.scan_date
          ) t_student_noout JOIN uac_scan max_scan
																	-- Match the full scan if it is I
                                  ON max_scan.user_id = t_student_noout.mu_id
                			   	  			AND max_scan.scan_time = scan_in
                			   	  			AND max_scan.scan_date = t_student_noout.nooutscan_date
                			   	  			AND max_scan.in_out = 'I'
														-- Need to know if he as been PON/LAT etc
          			   	  			JOIN uac_assiduite uaa
                                    ON uaa.user_id = max_scan.user_id
          			   	  				     -- AND max_scan.id = uaa.scan_id
          			   	  				     AND uaa.status IN ('PON', 'LAT', 'VLA', 'QUI')
          			   	  				JOIN uac_edt_line uel
          			   	  				ON uel.id = uaa.edt_id
          			   	  				AND uel.day = max_scan.scan_date
          			   	  		JOIN v_showuser vsh ON vsh.id = max_scan.user_id
          			   	  		JOIN v_class_cohort vcc ON vcc.id = vsh.cohort_id
          			   	  			ORDER BY TECH_DATE DESC;

DROP VIEW IF EXISTS rep_no_entry;
CREATE VIEW rep_no_entry AS
SELECT DISTINCT REPLACE(CONCAT(vsh.FIRSTNAME, ' ', vsh.LASTNAME), "'", " ") AS NAME, UPPER(vsh.USERNAME) AS USERNAME, vsh.MATRICULE AS MATRICULE, vcc.short_classe AS CLASSE, DATE_FORMAT(min_scan.scan_date, "%d/%m") AS INVDATE, min_scan.scan_date AS TECH_DATE,
	CASE
                      WHEN DAYOFWEEK(min_scan.scan_date) = 2 THEN "Lundi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 3 THEN "Mardi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 4 THEN "Mercredi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 5 THEN "Jeudi"
                      WHEN DAYOFWEEK(min_scan.scan_date) = 6 THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR, 'Scan entrée manquant' AS REASON  FROM (
          -- List of last scan of people
          SELECT mu.id AS mu_id, usa.scan_date AS nooutscan_date, min(usa.scan_time) AS scan_in from uac_scan usa
          JOIN mdl_user mu on usa.user_id = mu.id
          WHERE 1=1
					-- For these specific dates
          AND usa.scan_date < CURRENT_DATE
					AND usa.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)
          GROUP BY mu.id, usa.scan_date
          ) t_student_noout JOIN uac_scan min_scan
																	-- Match the full scan if it is I
                                  ON min_scan.user_id = t_student_noout.mu_id
                			   	  			AND min_scan.scan_time = scan_in
                			   	  			AND min_scan.scan_date = t_student_noout.nooutscan_date
                			   	  			AND min_scan.in_out = 'O'
												-- Need to know if he as been PON/LAT etc
												JOIN uac_assiduite uaa
																ON uaa.user_id = min_scan.user_id
															 -- AND max_scan.id = uaa.scan_id
															 AND uaa.status IN ('PON', 'LAT', 'VLA', 'QUI')
													JOIN uac_edt_line uel
													ON uel.id = uaa.edt_id
													AND uel.day = min_scan.scan_date
          			   	  		JOIN v_showuser vsh ON vsh.id = min_scan.user_id
          			   	  		JOIN v_class_cohort vcc ON vcc.id = vsh.cohort_id
          			   	  			ORDER BY TECH_DATE DESC;

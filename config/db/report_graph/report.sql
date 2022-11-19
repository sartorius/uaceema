DROP VIEW IF EXISTS rep_course_dash;
CREATE VIEW rep_course_dash AS
SELECT CONCAT(vcc.niveau, '/', vcc.mention, '/', vcc.parcours, '/', vcc.groupe) AS CLASSE,
	CASE
                      WHEN uel.day_code = 1 THEN "Lundi"
                      WHEN uel.day_code = 2 THEN "Mardi"
                      WHEN uel.day_code = 3 THEN "Mercredi"
                      WHEN uel.day_code = 4 THEN "Jeudi"
                      WHEN uel.day_code = 5 THEN "Vendredi"
                      ELSE "Samedi"
                      END AS JOUR,
    CASE WHEN uel.course_status = "A" THEN "Présenté" ELSE "Annulé" END AS COURSE_STATUS,
    REPLACE(REPLACE(uel.raw_course_title, "\n", " - "), ",", "") AS COURS_DETAILS,
    DATE_FORMAT(uel.day, "%d/%m") AS COURS_DATE,
    CASE
                      WHEN DATE_FORMAT(uel.day, "%m") = '1' THEN "Janvier"
                      WHEN DATE_FORMAT(uel.day, "%m") = '2' THEN "Février"
                      WHEN DATE_FORMAT(uel.day, "%m") = '3' THEN "Mars"
                      WHEN DATE_FORMAT(uel.day, "%m") = '4' THEN "Avril"
                      WHEN DATE_FORMAT(uel.day, "%m") = '5' THEN "Mai"
                      WHEN DATE_FORMAT(uel.day, "%m") = '6' THEN "Juin"
                      WHEN DATE_FORMAT(uel.day, "%m") = '7' THEN "Juillet"
                      WHEN DATE_FORMAT(uel.day, "%m") = '8' THEN "Aout"
                      WHEN DATE_FORMAT(uel.day, "%m") = '9' THEN "Septembre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '10' THEN "Octobre"
                      WHEN DATE_FORMAT(uel.day, "%m") = '11' THEN "Novembre"
                      ELSE "Décembre"
                      END AS MOIS,
    CONCAT(uel.hour_starts_at, 'h00') AS DEBUT_COURS,
    CASE WHEN t_abs.abs_cnt IS NULL THEN 0 ELSE t_abs.abs_cnt END AS NBR_ABS,
    CASE WHEN t_qui.qui_cnt IS NULL THEN 0 ELSE t_qui.qui_cnt END AS NBR_QUI, t_cohort_count.cohort_count AS NUMBER_STUD,
    CASE WHEN uao.id IS NULL THEN 'NON' ELSE 'OUI' END AS OFF_DAY
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
	WHERE uel.duration_hour > 0
	ORDER BY uel.day, uel.hour_starts_at DESC;

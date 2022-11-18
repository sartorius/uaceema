DROP VIEW IF EXISTS rep_course_dash;
CREATE VIEW rep_course_dash AS
SELECT CONCAT(vcc.niveau, '/', vcc.mention, '/', vcc.parcours, '/', vcc.groupe) AS CLASSE,
	CASE
                      WHEN uel.day_code = 1 THEN "LUNDI"
                      WHEN uel.day_code = 2 THEN "MARDI"
                      WHEN uel.day_code = 3 THEN "MERCREDI"
                      WHEN uel.day_code = 4 THEN "JEUDI"
                      WHEN uel.day_code = 5 THEN "VENDREDI"
                      ELSE "SAMEDI"
                      END AS JOUR,
    CASE WHEN uel.course_status = "A" THEN "Présenté" ELSE "Annulé" END AS COURSE_STATUS,
    REPLACE(REPLACE(uel.raw_course_title, "\n", " - "), ",", "") AS COURS_DETAILS,
    DATE_FORMAT(uel.day, "%d/%m") AS COURS_DATE, CONCAT(uel.hour_starts_at, 'h00') AS DEBUT_COURS,
    CASE WHEN t_abs.abs_cnt IS NULL THEN 0 ELSE t_abs.abs_cnt END AS NBR_ABS,
    CASE WHEN t_qui.qui_cnt IS NULL THEN 0 ELSE t_qui.qui_cnt END AS NBR_QUI, t_cohort_count.cohort_count AS NUMBER_STUD
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
	WHERE uel.duration_hour > 0
	ORDER BY uel.day, uel.hour_starts_at DESC;

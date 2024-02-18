-- Here are migration necessary for half update
-- Legacy is the new form for next year
DROP TABLE IF EXISTS uac_load_jqedt;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_load_jqedt` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `flow_id` BIGINT NULL,
  `tag_stamp_for_export` SMALLINT UNSIGNED NOT NULL,
  `cohort_id` INT NOT NULL,
  `label_day` VARCHAR(20) NOT NULL,
  `tech_date` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `min_starts_at` TINYINT NULL,
  `duration_hour` TINYINT NULL,
  `duration_min` TINYINT NULL,
  `course_status` CHAR(1) NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `course_id` VARCHAR(10) NULL,
  `monday_ofthew` DATE NOT NULL,
  `room_id` SMALLINT NULL,
  `course_room` VARCHAR(50) NULL,
  `display_date` VARCHAR(15) NULL,
  `shift_duration` TINYINT NULL,
  `end_time` VARCHAR(10) NULL,
  `end_time_hour` VARCHAR(5) NULL,
  `end_time_min` VARCHAR(5) NULL,
  `start_time` VARCHAR(10) NULL,
  `start_time_hour` VARCHAR(5) NULL,
  `start_time_min` VARCHAR(5) NULL,
  `tech_day` VARCHAR(3) NULL COMMENT 'Related to courseId',
  `tech_hour` VARCHAR(3) NULL COMMENT 'Related to courseId',
  `teacher_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


ALTER TABLE uac_edt_master
ADD COLUMN `jq_edt_type` CHAR(1) NOT NULL DEFAULT 'N' AFTER monday_ofthew;

ALTER TABLE uac_edt_line
ADD COLUMN `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half' AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0 AFTER raw_course_title;
ALTER TABLE uac_edt_line
ADD COLUMN `end_time` VARCHAR(5) NULL AFTER course_id;
ALTER TABLE uac_edt_line
ADD COLUMN `start_time` VARCHAR(5) NULL AFTER course_id;
ALTER TABLE uac_edt_line
ADD COLUMN `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number' AFTER end_time;
ALTER TABLE uac_edt_line
ADD COLUMN `teacher_id` SMALLINT NOT NULL DEFAULT 0 AFTER shift_duration;

ALTER TABLE uac_edt_master
ADD COLUMN edt_title VARCHAR(300) NOT NULL DEFAULT 'NA' AFTER monday_ofthew;

DROP TABLE IF EXISTS uac_ref_day_queue;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_day_queue` (
  `id` TINYINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL DEFAULT 'INP',
  PRIMARY KEY (`id`));

INSERT INTO uac_ref_day_queue (id) VALUES (0);
INSERT INTO uac_ref_day_queue (id) VALUES (1);
INSERT INTO uac_ref_day_queue (id) VALUES (2);
INSERT INTO uac_ref_day_queue (id) VALUES (3);
INSERT INTO uac_ref_day_queue (id) VALUES (4);
INSERT INTO uac_ref_day_queue (id) VALUES (5);
INSERT INTO uac_ref_day_queue (id) VALUES (6);
INSERT INTO uac_ref_day_queue (id) VALUES (7);


DROP VIEW IF EXISTS v_edt_used_room;
CREATE VIEW v_edt_used_room AS
SELECT  uem.id AS uem_id,
        uem.monday_ofthew AS uem_monday_ofthew,
        course_id AS course_id,
        uel.shift_duration AS shift_duration,
        room_id AS room_id,
        vcc.short_classe AS short_classe,
        uel.start_time AS start_time,
        uel.end_time AS end_time,
        DATE_FORMAT(uem.monday_ofthew, '%d/%m') AS disp_monday,
        0 AS cell_1_shift,
        0 AS cell_2_day,
        0 AS cell_3_half
FROM uac_edt_master uem JOIN uac_edt_line uel
							          ON uel.master_id = uem.id
								        JOIN v_class_cohort vcc
								        ON vcc.id = uem.cohort_id
WHERE uem.visibility IN ('V', 'D')
AND uel.course_status NOT IN ('C')
-- We dont consider the non specified
AND room_id > 0
AND uel.shift_duration > 0;
-- AND uem.monday_ofthew >= '2023-04-10' AND uem.monday_ofthew <= '2023-05-01';


/************************************ Teacher Referential ************************************/
DROP TABLE IF EXISTS uac_ref_teacher;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_ref_teacher` (
  `id` SMALLINT UNSIGNED NOT NULL,
  `name` VARCHAR(100) NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

DROP TABLE IF EXISTS uac_xref_teacher_mention;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_xref_teacher_mention` (
  `teach_id` SMALLINT UNSIGNED NOT NULL,
  `mention_code` CHAR(5) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`teach_id`, `mention_code`));



/************************************ View ************************************/

DROP VIEW IF EXISTS rep_excel_ass_global;
CREATE VIEW rep_excel_ass_global AS
SELECT
	 vcc.mention AS MENTION,
	 vcc.niveau AS NIVEAU,
	 CASE WHEN vcc.parcours = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.parcours, 1, 18)) END AS PARCOURS,
	 CASE WHEN vcc.groupe = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.groupe, 1, 18)) END AS GROUPE,
	 UPPER(mu.username) AS USERNAME,
	 fGetMatriculeNum(mu.matricule) AS MATRICULE,
   REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), "'", " ") AS FULLNAME,
   IFNULL(uui.living_configuration, 'F') AS LIVING_CONFIG,
   IFNULL(uui.assiduite_info, 'NA') AS ASS_NOTE,
	 CASE WHEN ass.status = 'ABS' THEN 'Absent(e)' WHEN ass.status IN ('LAT', 'VLA') THEN 'Retard' ELSE 'ERR267' END AS STATUS,
	  COUNT(1) AS OCCURENCE
	  FROM uac_assiduite ass JOIN mdl_user mu
                            ON mu.id = ass.user_id
                            JOIN uac_edt_line uel
                            ON uel.id = ass.edt_id
                            JOIN uac_showuser uas
                            ON mu.username = uas.username
                            JOIN v_class_cohort vcc
                            ON vcc.id = uas.cohort_id
                            LEFT JOIN uac_user_info uui
                            ON uui.id = mu.id
	  WHERE ass.status IN ('ABS', 'LAT', 'VLA')
	  AND uel.day NOT IN (SELECT working_date FROM uac_assiduite_off)
	  AND uel.day > DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY)
	  GROUP BY
      vcc.mention,
      vcc.niveau,
      CASE WHEN vcc.parcours = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.parcours, 1, 18)) END,
      CASE WHEN vcc.groupe = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.groupe, 1, 18)) END,
      UPPER(mu.username),
      fGetMatriculeNum(mu.matricule),
      REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), "'", " "),
      IFNULL(uui.living_configuration, 'F'),
      IFNULL(uui.assiduite_info, 'NA'),
      CASE WHEN ass.status = 'ABS' THEN 'Absent(e)' WHEN ass.status IN ('LAT', 'VLA') THEN 'Retard' ELSE 'ERR267' END
	  -- HAVING COUNT(1) > 1
	  ORDER BY vcc.mention, vcc.niveau, PARCOURS, GROUPE, USERNAME, STATUS DESC;

-- This one is for resume page
DROP VIEW IF EXISTS rep_excel_ass_compute_global;
CREATE VIEW rep_excel_ass_compute_global AS
SELECT
  vcc.mention AS MENTION,
  vcc.niveau AS NIVEAU,
  CASE WHEN vcc.parcours = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.parcours, 1, 18)) END AS PARCOURS,
  CASE WHEN vcc.groupe = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.groupe, 1, 18)) END AS GROUPE,
  count(1) AS POPULATION,
  IFNULL(t_late.T_LATE_CPT, 0) AS LATE_OCC,
  IFNULL(t_mis.T_MIS_CPT, 0) AS MIS_OCC
FROM v_class_cohort vcc JOIN uac_showuser uas ON uas.cohort_id = vcc.id
						JOIN mdl_user mu ON mu.username = uas.username
							 LEFT JOIN (
      							 SELECT uas.cohort_id AS T_LATE_COHORT_ID, count(1) AS T_LATE_CPT FROM uac_assiduite ass
        							  JOIN mdl_user mu ON mu.id = ass.user_id AND ass.status IN ('LAT', 'VLA')
        				   			JOIN uac_showuser uas ON uas.username = mu.username
                        JOIN uac_edt_line uel ON uel.id = ass.edt_id AND uel.day > DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY) AND uel.day NOT IN (SELECT working_date FROM uac_assiduite_off)
        							GROUP BY uas.cohort_id
							 ) t_late ON t_late.T_LATE_COHORT_ID = vcc.id
 							 LEFT JOIN (
       							 SELECT uas.cohort_id AS T_MIS_COHORT_ID, count(1) AS T_MIS_CPT FROM uac_assiduite ass
         							  JOIN mdl_user mu ON mu.id = ass.user_id AND ass.status IN ('ABS')
         				   			JOIN uac_showuser uas ON uas.username = mu.username
                        JOIN uac_edt_line uel ON uel.id = ass.edt_id AND uel.day > DATE_ADD(CURRENT_DATE, INTERVAL -30 DAY) AND uel.day NOT IN (SELECT working_date FROM uac_assiduite_off)
         							GROUP BY uas.cohort_id
 							 ) t_mis ON t_mis.T_MIS_COHORT_ID = vcc.id
GROUP BY vcc.mention, vcc.niveau, CASE WHEN vcc.parcours = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.parcours, 1, 18)) END, CASE WHEN vcc.groupe = 'na' THEN '-' ELSE UPPER(SUBSTRING(vcc.groupe, 1, 18)) END, t_late.T_LATE_CPT, t_mis.T_MIS_CPT
HAVING COUNT(1) > 0
ORDER BY 1, 2, 3, 4;


DROP VIEW IF EXISTS rep_global_ass_dash;
CREATE VIEW rep_global_ass_dash AS
SELECT
	 UPPER(mu.username) AS USERNAME,
	 mu.matricule AS MATRICULE,
	 REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), "'", " ") AS NAME,
	 CASE WHEN ass.status = 'ABS' THEN 'Absent(e)' WHEN ass.status = 'LAT' THEN 'Retard' WHEN ass.status = 'VLA' THEN 'Tres en retard' WHEN ass.status = 'QUI' THEN 'Quitte' ELSE 'a l\'heure' END AS STATUS,
   CASE
       WHEN UPPER(DAYNAME(uel.day)) = 'MONDAY' THEN "Lundi"
       WHEN UPPER(DAYNAME(uel.day)) = 'TUESDAY' THEN "Mardi"
       WHEN UPPER(DAYNAME(uel.day)) = 'WEDNESDAY' THEN "Mercredi"
       WHEN UPPER(DAYNAME(uel.day)) = 'THURSDAY' THEN "Jeudi"
       WHEN UPPER(DAYNAME(uel.day)) = 'FRIDAY' THEN "Vendredi"
       ELSE "Samedi"
       END AS JOUR,
	  DATE_FORMAT(uel.day, '%d/%m') AS COURS_DATE,
    CONCAT(uel.hour_starts_at, 'h', CASE WHEN (CHAR_LENGTH(uel.min_starts_at) = 1) THEN CONCAT('0', uel.min_starts_at) ELSE uel.min_starts_at END) AS DEBUT_COURS,
	  CONCAT(vcc.niveau, '/', vcc.mention, '/', vcc.parcours, '/', vcc.groupe) AS CLASSE,
    REPLACE(REPLACE(REPLACE(fEscapeStr(fEscapeLineFeed(uel.raw_course_title)), ' ', ' - '), ',', ''), '\\n', ' - ') AS COURS_DETAILS
	  FROM uac_assiduite ass JOIN mdl_user mu
                            ON mu.id = ass.user_id
                            JOIN uac_edt_line uel
                            ON uel.id = ass.edt_id
                            JOIN uac_showuser uas
                            ON mu.username = uas.username
                            JOIN v_class_cohort vcc
                            ON vcc.id = uas.cohort_id
	  WHERE ass.status IN ('ABS', 'LAT', 'VLA', 'QUI')
	  AND uel.day NOT IN (SELECT working_date FROM uac_assiduite_off)
    -- We take maximum 9 last days
	  AND uel.day > DATE_ADD(CURRENT_DATE, INTERVAL -9 DAY)
	  ORDER BY uel.day DESC;

-- Report are here
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
    CASE WHEN uel.course_status = "A" THEN "Présenté sur site"
         WHEN uel.course_status = "M" THEN "Prof Absent"
         WHEN uel.course_status = "H" THEN "Présenté hors site"
         WHEN uel.course_status = "O" THEN "Présenté optionnel"
    ELSE "Annulé" END AS COURSE_STATUS,
    REPLACE(CONCAT(fEscapeLineFeed(fEscapeStr(uel.raw_course_title)), ' ', urt.name,
                CASE WHEN uel.start_time IS NOT NULL THEN CONCAT(" - Début ", uel.start_time) ELSE "" END,
                CASE WHEN uel.end_time IS NOT NULL THEN CONCAT(" - Fin ", uel.end_time) ELSE "" END), '\\n', ' - ') AS COURS_DETAILS,
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
                JOIN uac_ref_teacher urt ON urt.id = uel.teacher_id
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
	AND uel.day <= CURRENT_DATE
	AND (uel.day > (CURDATE() + interval -(30) day))
	ORDER BY uel.day DESC;

-- Find fill up here : https://docs.google.com/spreadsheets/d/1k0sESkSmMPVc2PPN-cL4oPznnEmClZLn5Qsjq4uDiZ0/edit?usp=sharing
-- INSERT INTO uac_ref_teacher (id, name) VALUES (NULL, NULL);

-- INSERT INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (NULL, NULL);


INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (0, '');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (1, 'M. ANDRIAMAHALY H. Alphonse J.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (2, 'Mme. ANDRIANANTOANINA Rija Fenosoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (3, 'Mme. ANDRIANAVALONA Harimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (4, 'M. ANDRIANIERENANA Clément Luc');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (5, 'M. ANDRIATIANA Mamy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (6, 'Mme. ANDRIMABOAHANGY Domoina Dyana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (7, 'Pr. ETIENNE STEFANO Rahelimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (8, 'M. MAKSIM Lucien Godefroy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (9, 'M. NY ANDRY NANTENAINA RAKOTONANDRASANA Andrianarisaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (10, 'M. RABEHARISON Jeannot');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (11, 'M. RABEMANAHAKA Lala Andrianaivo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (12, 'M. RAKOTONDRATSIMBA Edouard');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (13, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (14, 'Mme. RAKOTONIAINA Ionintsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (15, 'M. RAKOTONIRINA Gérard');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (16, 'M. RAKOTONIRINA Razafy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (17, 'Mme. RALAMBOZAFY Sahondra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (18, 'Mme. RAMAHATRA Hanitra S.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (19, 'Mme. RAMAROSON Mbolamamy Harinoro');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (20, 'M. RAMAROSON Tojonanahary Fetraniaina Romule');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (21, 'Dr. RAMILISON Haingotiana Henitsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (22, 'M. RANAIVOSON Jeannot Fils');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (23, 'Mme. RANDRIANASY Christelle Adriana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (24, 'M. RAVALITERA Jean Rabenalisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (25, 'M. RAVELONJATOVO Tantely Harinjaka');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (26, 'Mme. RAZANABAHINY Victorine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (27, 'M. RAZAFIMANDIMBY Fanomezana Pascal');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (28, 'M. ANDRIANARIJAONA Herizo V.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (29, 'M. RAVALISON Mampionona');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (30, 'M. RAHARIJAONA Lantonirina Joel');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (31, 'M. RAHARINIRINA Zinah');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (32, 'M. ANDRIAMPENITRA Serge');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (33, 'M. ANDRIANANTENAINA Mikaia Valisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (34, 'Pr. RAZAFIMAHEFA Reine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (35, 'M. ANDRIANETRAZAFY Hemerson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (36, 'Mme. ROBIJAOANA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (37, 'M. ANDRIAMAHAZO Jean Claude');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (38, 'M. ANDRIAMAHEFA Zo Nambinina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (39, 'Mme. ANDRIAMISEZA Noromanitra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (40, 'M. ANDRIANALY Jacquelin Solonirina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (41, 'Mme. ANDRIANANDRASANA Joëlle Jeannie');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (42, 'M. ANDRIANASOLO Léon Dolà');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (43, 'M. ANDRIANETRAZAFY Hemerson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (44, 'Mme. HANITRINIAINA Marie Elie');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (45, 'Mme. RAFELAMANILO Voahangy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (46, 'Mme. RAHARISON Aimée');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (47, 'M. RAKOTONANAHARY Herizo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (48, 'M. RAKOTONDRAMASY Franck');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (49, 'Dr. RAKOTOSON Philippe Victorien');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (50, 'Mme. RALAMBOSON Hantsa Iarivelo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (51, 'M. RAMAHANDRY Tsirava Maurice');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (52, 'M. RAMANITRARIVO Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (53, 'Mme. RASAMIMANANA Livasoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (54, 'Mme. RASOANAIVO Diana Hanta');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (55, 'M. RATOLONJANAHARY Odon');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (56, 'Mme. RATSIMBAZAFY Fara');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (57, 'M. RAMORASATA Henintsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (58, 'M. ROBIVELO Marie Michel Raphaël');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (59, 'M. ANDRIAMBOLATIANA Parson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (60, 'M. RAVELOALISON Haja Nirina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (61, 'M. MAKSIM Lucien');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (62, 'M. RAZAFINJATOVO MAHEFASON Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (63, 'Mme. ANDRIAMAMPIANINA Vonjiniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (64, 'M. BONNET Gérard-Louis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (65, 'Mme. ROBIJAONA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (66, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (67, 'M. RANAIVONTSOA Boris');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (68, 'Mme. ANDRIANASY Reine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (69, 'M. ANDRIAMANEHONTOANINA Solo Mihamina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (70, 'Pr. ANDRIAMANOHISOA Hery Zo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (71, 'Mme. ANDRIANARIZAKA Hantatiana Henimpitia');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (72, 'M. ANDRIATSIMIAFIMIRIJA Tojontsoa Clovin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (73, 'M. RABEMANAJARA Russel');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (74, 'M. ANDRIANANDRAINA Andry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (75, 'M. RAKOTOMAHENINA Pierre Benjamin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (76, 'Mme. RAKOTOMALALA Claudia');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (77, 'Mme. RAKOTONDRASOA Seheno');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (78, 'M. ANDRIAMANOHISOA Tahiana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (79, 'M. RAKOTOSALAMA Clément');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (80, 'M. RAKOTOSALAMA Lova');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (81, 'Mme. RANDRIAMAMPIANINA Valimbavaka');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (82, 'Pr. RANDRIANARIMALA Ansèlme');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (83, 'M. RAZAFIMBELO Florent');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (84, 'M. RAZAFINJATOVO MAHEFASON Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (85, 'Mme. RAZANADRAKOTO Jocelyne');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (86, 'M. RAJEMISON RAKOTOMAHARO Guy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (87, 'M. RAZAFIMAMONJY Jean Berger');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (88, 'Mme. RANAIVOSON Nirina Robsely');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (89, 'M. ANDRIANETRAZAFY Hemerson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (90, 'M. BONNET Gérard-Louis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (91, 'Mme. ROBIJAOANA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (92, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (93, 'Mme. ANDRIAMANALINARIVO Njiva');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (94, 'M. RANAIVONTSOA Boris');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (95, 'M. RABIBISOA Francis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (96, 'M. RAKOTOARIVONY Solofoniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (97, 'Dr. ANDRIAMIFALIHARIMANANA Rado');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (98, 'M. ANDRIAMIHARIVOLAMENA RAKOTONIAINA Jacob');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (99, 'Pr. MANDRARA Thosun Eric');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (100, 'M. RAKOTOARIMANANA Tsiriheriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (101, 'Mme. RAMANANTSEHENO Domoina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (102, 'Mme. RANDRIAMANAMPISOA Holimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (103, 'M. RANDRIAMISATA Mahitsison Danie Patrick');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (104, 'M. RANDRIANARIMANANA Andoniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (105, 'Mme. RANDRIANARIVONY Lanto Lancia');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (106, 'Mme. RAVELONTSALAMA Miora Gabrielle');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (107, 'M. RAZAFITRIMO Ny Aina Lazaharijaona');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (108, 'M. SOULEMAN IBRAHIM Andriamandimby');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (109, 'M. RAZAFIZANAKA Giannot Albert');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (110, 'M. RAZAFINDRALAMBO Manohisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (111, 'Mme. RANDRIAMAMPIANINA Andy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (112, 'Mme. RALAMBOZAFY Sahondra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (113, 'M. ANDRIAMANOHISOA Hery Zo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (114, 'M. ANDRIAMANOHISOA Tahiana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (115, 'M. RABEHARISON Jeannot');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (116, 'M. HANCEL Léonce Herbert');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (117, 'M. RAMAHANDRY Tsirava Maurice');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (118, 'M. ROBIVELO Marie Michel Raphaël');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (119, 'Mme. RAZAFIMANDIMBY Rian aina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (120, 'Mme. RAZAFIMANDIMBY Malala Tiana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (121, 'M. RAZAFIMANJATO Jocelyn Yves');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (122, 'M. RAZAFINJATOVO MAHEFASON Heriniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (123, 'M. RAKOTOZAFY Rivo John');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (124, 'Mme. ROBIJAOANA Nomentsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (125, 'M. RAKOTONDRATSIMBA Diary Tahiry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (126, 'M. ANDRIANTSOA Jean Rubis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (127, 'Mme. ANDRIANTSOA Nirifenohanitra Esther');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (128, 'Mme. ANDRIANTSOA RASOAVELONORO Violette');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (129, 'M. RABEZANAHARY Jean Emilien (Assistant Pr Jean Claude)');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (130, 'Mme. HARIJAONA Vololontsoa Vero');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (131, 'Mme. RAHARIMANANTSOA Onja Lalaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (132, 'M. RAJAONA Ranto Andriatsilavina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (133, 'M. RAJAONARISON Ny Ony Narindra Lova Hasina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (134, 'M. RAJAONARIVONY Tianarivelo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (135, 'Mme. RAKOTOARISOA RASAMINDRAKOTROKA Miora Tantely');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (136, 'M. RAKOTOARISOA Rivo Tahiry Rabetafika');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (137, 'Mme. RAMAMONJIARISOA Faramalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (138, 'M. RAMARISON Guy');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (139, 'Mme. RANDRIANARISOA Hoby Lalaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (140, 'Mme. RANIVONTSOARIVONY Martine');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (141, 'Mme. RARIVOHARILALA Esther');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (142, 'M. RASAMINDRAKOTROKA Andry');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (143, 'Mme. RASOANAIVO Nivohanitra');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (144, 'Mme. RATSIMBAZAFIMAHEFA RAHANTALALAO Henriette');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (145, 'Mme. RAVALOSON Ialiseheno');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (146, 'Mme. RAZAFIMAHEFA RAMILISON Reine Dorothée');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (147, 'Mme. ANDRIANANJA Volatiana (Assistante Pr Mamy RANDRIA)');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (148, 'M. RATOVOHERY Andry Nirilalaina (Informatique)');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (149, 'M. ANDRIAMBOLOLOA Falihery');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (150, 'Mme. ANDRIAMAMPIANINA Vonjiniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (151, 'M. ANDRIAMIJORO Mino');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (152, 'M. BONNET Gérard-Louis');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (153, 'M. JAONARY Gérald');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (154, 'M. NARENDRA Mathieu');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (155, 'Mme. RABEZANDRINA Nirina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (156, 'M. RAKOTOARISOA Samimanana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (157, 'M. RAKOTOMAHANINA Mbelo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (158, 'M. RAKOTONINDRAINY Seraphin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (159, 'Mme. RANAIVOSON Nirina Robisely');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (160, 'M. RANDRIAMBOLOLONA Fabien');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (161, 'Mme. RASOLOFONIAINA RAZAKARIVONY Yollande');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (162, 'M. RASOLOFOSON Miarantsoa Fanomezana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (163, 'M. RATIARAIMAVO Solofo N. A.');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (164, 'M. RATSIMBAZAFY Harilala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (165, 'Mme. RAZAFINDRALAMBO Harisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (166, 'M. ROBSON Sata');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (167, 'Mme. RAKOTONANDRASANA Norolalao');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (168, 'M. ANDRIAMANANTSOA Guy Danielson');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (169, 'M. HERINANTENAINA Edmond Fils');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (170, 'M. RABESANDRATANA ANDRIAMIHAJA Mamisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (171, 'M. RAHARISON Christian Jean Noëllin');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (172, 'M. RALAIVAO Michel Ludovic');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (173, 'M. RAMAHANDRISOA Tsirilalaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (174, 'M. RAMAHANDRISOA Fetraharijaona');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (175, 'M. RANDRIAMAROSON Rivo Mahandrisoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (176, 'M. RAJEMIARIMIRAHO Lazaniaina');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (177, 'M. RASTEFANO Elisée');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (178, 'M. RAKOTONINDRINA Benja');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (179, 'M. RATSIRARSON Shen Andriantsoa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (180, 'M. RANDRIAMAHALEO Fanilo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (181, 'M. RANDRIANANTOANDRO Solofo');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (182, 'M. RAZANAMAHERY Zoé');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (183, 'Mme. RALAMBOSON Hantsa');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (184, 'M. BONNET Gérard');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (185, 'Mme. RASOANAIVO Diana');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (186, 'Mme. ANDRIANAVALONA Harimalala');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (187, 'Mme. RABEARIMANANA Lucile');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (188, 'M. RAVALITERA Jean Rabenalisoa');

INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (1, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (2, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (3, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (4, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (5, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (6, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (7, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (8, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (9, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (11, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (12, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (13, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (14, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (15, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (16, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (17, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (18, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (19, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (20, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (21, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (22, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (23, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (24, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (25, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (26, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (27, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (28, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (29, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (30, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (31, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (32, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (33, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (34, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (35, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (36, 'COMMU');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (37, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (38, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (39, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (40, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (41, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (42, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (43, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (44, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (45, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (46, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (47, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (48, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (49, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (50, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (51, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (52, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (53, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (54, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (55, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (56, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (57, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (58, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (59, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (60, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (61, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (62, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (63, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (64, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (65, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (66, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (67, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (68, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (69, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (70, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (71, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (72, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (73, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (74, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (75, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (76, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (77, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (78, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (79, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (80, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (81, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (82, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (83, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (84, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (85, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (86, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (87, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (88, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (89, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (90, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (91, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (92, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (93, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (94, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (95, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (96, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (97, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (98, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (99, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (100, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (101, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (102, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (103, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (104, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (105, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (106, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (107, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (108, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (109, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (110, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (111, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (112, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (113, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (114, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (115, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (116, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (117, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (118, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (119, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (120, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (121, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (122, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (123, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (124, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (125, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (126, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (127, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (128, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (129, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (130, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (131, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (132, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (133, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (134, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (135, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (136, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (137, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (138, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (139, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (140, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (141, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (142, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (143, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (144, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (145, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (146, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (147, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (148, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (149, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (150, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (151, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (152, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (153, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (154, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (155, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (156, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (157, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (158, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (159, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (160, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (161, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (162, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (163, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (164, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (165, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (166, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (167, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (168, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (169, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (170, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (171, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (172, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (173, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (174, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (175, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (176, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (177, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (178, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (179, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (180, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (181, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (182, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (183, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (184, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (185, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (186, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (187, 'RIDXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (188, 'RIDXX');
/*************************************** New Update for Teacher ***************************************/
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (190, 'M. RAMIANDRISOA Andriamampihantona Lalao');
INSERT  IGNORE  INTO uac_ref_teacher (id, name) VALUES (191, 'M. RANDRIA Mamy Jean de Dieu');

INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (190, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (191, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (177, 'SIENS');

DELETE FROM uac_xref_teacher_mention WHERE teach_id = 115;
DELETE FROM uac_ref_teacher WHERE id = 115;
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'DROIT');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'GESTI');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'ECONO');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'SIENS');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'MBSXX');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'INFOE');
INSERT  IGNORE  INTO uac_xref_teacher_mention (teach_id, mention_code) VALUES (10, 'RIDXX');

/*************************************** LEGACY ***************************************/

/*
DROP TABLE IF EXISTS uac_edt_line;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_line` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `master_id` BIGINT UNSIGNED NULL,
  `compute_late_status` CHAR(3) NOT NULL DEFAULT 'NEW',
  `label_day` VARCHAR(20) NOT NULL,
  `day` DATE NOT NULL,
  `day_code` TINYINT UNSIGNED NULL,
  `hour_starts_at` TINYINT NOT NULL,
  `duration_hour` TINYINT UNSIGNED NULL,
  `raw_course_title` VARCHAR(2000) NULL,
  `room_id` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  `min_starts_at` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `duration_min` TINYINT UNSIGNED NOT NULL DEFAULT 0,
  `course_id` VARCHAR(10) NULL COMMENT 'courseId is the position in the EDT and like x-y-z with x the hour, y the day and z is 1 or 2 to be first or second half',
  `start_time` VARCHAR(5) NULL,
  `end_time` VARCHAR(5) NULL,
  `shift_duration` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Halftime number',
  `teacher_id` SMALLINT NOT NULL DEFAULT 0,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))

DROP TABLE IF EXISTS uac_edt_master;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_edt_master` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `cohort_id` BIGINT UNSIGNED NULL,
  `visibility` CHAR(1) NOT NULL DEFAULT 'I',
  `monday_ofthew` DATE NOT NULL,
  `jq_edt_type` CHAR(1) NOT NULL DEFAULT 'N',
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));

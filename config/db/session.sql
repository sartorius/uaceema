symfony local:server:stop
symfony server:start



-- MD5
11:14:32.186 debug	Hash password: lanatureestverte e716e0cf70d3c6dbd840945d890f074d -- benrand123
11:14:32.186 debug	Hash password: lebleuduciel 78e740abec0d61e6dd52452e6d9c2a32 -- harrako912
11:14:32.186 debug	Hash password: lelapinblanc 9248153d95104975573f18e2852d6647 -- lalrako381
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924 -- ionrako617
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924 -- tokrako283
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924 -- tsirako227
11:14:32.186 debug	Hash password: lelapinblanc 9248153d95104975573f18e2852d6647 -- minoraj172
11:14:32.186 debug	Hash password: unnuagedansleciel d064a894fb8645879312b10d366cd604 -- radoand728
-- Agent
11:14:32.186 debug	Hash password: lelemurientoutnoir c24d593b9266e7b8d0887d0dc7259705 -- mikrama654
11:14:32.186 debug	Hash password: unnuagedansleciel d064a894fb8645879312b10d366cd604 -- mborako321
11:14:32.186 debug	Hash password: unesardinedanslamer 9433c9064f0593da5727e2122a193a6e -- mavrako128
11:14:32.186 debug	Hash password: unrequindanslocean 3165cef3bc67568c7d30f5a184f43766 -- menrako232
11:14:32.186 debug	Hash password: leratdesvilles a2d426e5a92f1bbf418a35869ffc7cc2 -- blourat077
11:14:32.186 debug	Hash password: leratdesvilles a2d426e5a92f1bbf418a35869ffc7cc2 -- paulrab367
11:14:32.186 debug	Hash password: unetortuegasy 2df68a85f1932ca876926252bbaa0820 -- manrako092

http://localhost:8888/aceemintranet/pluginfile.php/43/user/icon/boost/f1?rev=119


adellav445 - Andry Rakoto.jpg
agnealc472 - Andry Rakoto.jpg
aimeshi103 - Andry Rakoto.jpg
ainndel546 - Andry Rakoto.jpg
ainnval527 - Andry Rakoto.jpg
akenmat151 - Andry Rakoto.jpg


http://78.118.239.151:8000/profile/3986098495ORJAPED223
http://78.118.239.151:8000/profile/3975277373HELEVOS024
http://78.118.239.151:8000/profile/3914382604JUNNSHI185

SG-min - Andry Rakoto.jpg
download - Herinirina Ratinahirana.jpg


https://drive.google.com/open?id=1TWgy_0CdEZ-Wa8m8pnSNeYZptALLsH0I

SELECT
		mu.id AS ID,
          mu.username AS USERNAME,
           uas.secret AS SECRET,
           CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
           mr.shortname AS ROLE_SHORTNAME,
           UPPER(mu.firstname) AS FIRSTNAME,
           UPPER(mu.lastname) AS LASTNAME,
           mu.email AS EMAIL,
           mu.phone1 AS PHONE,
           mu.address AS ADDRESS,
           mu.city AS CITY,
           mu.phone2 AS PARENT_PHONE,
           mf.contextid AS PIC_CONTEXT_ID,
           mu.picture AS PICTURE_ID,
           SUBSTRING(mf.contenthash, 1, 2) AS D1,
           SUBSTRING(mf.contenthash, 3, 2) AS D2,
           mf.contenthash AS FILENAME
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
           JOIN mdl_role mr ON mr.id = uas.roleid
           LEFT JOIN mdl_files mf ON mu.picture = mf.id;


-- Avoir la date
select mu.username, CAST(FROM_UNIXTIME(mu.timecreated) as date), mu.timecreated from mdl_user mu where LENGTH(mu.username) < 10


/var/www/aceemintranet_data/filedir






let dataTagToJson =JSON.parse('[{"USERNAME":"gaelcox286","USER_ID":467,"STATUS":"LAT","DEBUT":11,"JOUR":"2022-09-26","COURS":"MALAGASY\nSalle: 406\n","SCAN_DATE":"2022-09-26","SCAN_TIME":"11:09:00","LABEL_DAY_FR":"LUNDI"},{"USERNAME":"gaelcox286","USER_ID":467,"STATUS":"PON","DEBUT":13,"JOUR":"2022-09-26","COURS":"ANGLAIS\nSalle: 406\nM","SCAN_DATE":"2022-09-26","SCAN_TIME":"11:09:00","LABEL_DAY_FR":"LUNDI"},{"USERNAME":"gaelcox286","USER_ID":467,"STATUS":"PON","DEBUT":16,"JOUR":"2022-09-26","COURS":"INTRODUCTION RS\nSall","SCAN_DATE":"2022-09-26","SCAN_TIME":"14:19:00","LABEL_DAY_FR":"LUNDI"}]');



-- EDT !!!




SELECT
            mu.id
    FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
             JOIN mdl_role mr ON mr.id = uas.roleid
             LEFT JOIN mdl_files mf ON mu.picture = mf.id;


select * from uac_showuser uas;

select mu.username, usa.* from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
order by scan_time asc;

-- Group by In and Out
select mu.username, in_out, count(1) from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
group by mu.username, in_out
order by count(1) desc;


-- Last value
select mu.username, in_out, max(usa.scan_time) from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':05:00'), TIME)
group by mu.username, in_out
order by max(usa.scan_time) desc;




delete from uac_assiduite;

-- Final list of student on time !
INSERT IGNORE INTO uac_assiduite (user_id, edt_id, scan_id, status)
SELECT mu.id, 0, max_scan.id AS scan_id, 'PON' FROM (
-- List of people who entered but not exit before 7:00
select mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':00:00'), TIME)
group by mu.username, in_out
having in_out = 'I'
) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
			   JOIN mdl_user mu on mu.username = uas.username
			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
			   	  							  AND max_scan.scan_time = scan_in
			   	  							  AND max_scan.in_out = 'I'
			   	  							  -- Day !!!
			   	  							  AND 1=1;



SELECT uas.username, ass.*, sca.* from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id
								JOIN uac_showuser uas ON mu.username = uas.username
									  LEFT JOIN uac_scan sca ON sca.id = ass.scan_id;

select * from uac_assiduite;

select mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':00:00'), TIME)
group by mu.username, in_out
having in_out = 'I'
order by scan_in desc;
-- 82




-- Final list of student late of 10min !
-- SELECT t_student_in.username, t_student_in.scan_in, 'RETARD - MAX 10min' FROM (
INSERT IGNORE INTO uac_assiduite (user_id, edt_id, scan_id, status)
SELECT mu.id, 0, max_scan.id AS scan_id, 'L10' FROM (
-- List of people who entered between 7:00 and 7:10
select mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
WHERE usa.scan_time > CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':00:00'), TIME)
and usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':10:00'), TIME)
group by mu.username, in_out
having in_out = 'I'
) t_student_in JOIN uac_showuser uas ON t_student_in.username = uas.username
			   JOIN mdl_user mu on mu.username = uas.username
			   	  JOIN uac_scan max_scan ON max_scan.user_id = mu.id
			   	  							  AND max_scan.scan_time = scan_in
			   	  							  AND max_scan.in_out = 'I'

			   	  							  AND 1=1;
order by t_student_in.scan_in desc;
-- 16


-- Final list of student missing or late after 10min !
INSERT IGNORE INTO uac_assiduite (user_id, edt_id, scan_id, status)
SELECT mu.id, 0, NULL, 'ABS' FROM mdl_user mu
		 JOIN uac_showuser uas ON mu.username = uas.username
WHERE mu.username NOT IN (
		SELECT t_student_in.username
		FROM(
					-- List of people who entered but not exit before 7:00
					select mu.username, in_out, max(usa.scan_time) AS scan_in from uac_scan usa
					join mdl_user mu on usa.user_id = mu.id
					WHERE usa.scan_time < CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':10:00'), TIME)
					group by mu.username, in_out
					having in_out = 'I'
						-- 94
					) t_student_in
		);

-- 509/603


order by t_student_in.scan_in desc;






SELECT mu.username, usa.* FROM uac_scan usa
		 JOIN mdl_user mu ON usa.user_id = mu.id
		  JOIN uac_showuser uas ON mu.username = uas.username
WHERE mu.username = 'seredem177'
order by scan_time asc;





order by max(usa.scan_time) desc;



SELECT CONVERT(CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':00:00'), TIME) AS TIME;

SELECT CONCAT(CASE WHEN (CHAR_LENGTH(7) = 1) THEN CONCAT('0', 7) ELSE 7 END, ':00:00');


select CHAR_LENGTH(2);

select mu.username, count(1) from uac_scan usa
join mdl_user mu on usa.user_id = mu.id
group by mu.username
order by count(1) desc;



-- Courses of the day
select * from uac_edt ue
where day = '2022-09-26'
and duration_hour > 0 order by hour_starts_at asc;


-- Missing the course
-- inv_course
select * from uac_edt ue
			where ue.id = 279;



-------- SESSION 2



select * from mdl_user order by 1 desc;

select * from mdl_cohort;


select * from mdl_cohort_members;



SELECT
            mu.id
    FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
             JOIN mdl_role mr ON mr.id = uas.roleid
             LEFT JOIN mdl_files mf ON mu.picture = mf.id;

select * from uac_edt;

SELECT
      mu.id AS ID,
            mu.username AS USERNAME,
             uas.secret AS SECRET,
             CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
             mr.shortname AS ROLE_SHORTNAME,
             UPPER(mu.firstname) AS FIRSTNAME,
             UPPER(mu.lastname) AS LASTNAME,
             mu.email AS EMAIL,
             mu.phone1 AS PHONE,
             mu.address AS ADDRESS,
             mu.city AS CITY,
             mu.phone2 AS PARENT_PHONE,
             mf.contextid AS PIC_CONTEXT_ID,
             mu.picture AS PICTURE_ID,
             SUBSTRING(mf.contenthash, 1, 2) AS D1,
             SUBSTRING(mf.contenthash, 3, 2) AS D2,
             mf.contenthash AS FILENAME
    FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
             JOIN mdl_role mr ON mr.id = uas.roleid
             LEFT JOIN mdl_files mf ON mu.picture = mf.id
             WHERE mu.username = 'adeldan281';



https://127.0.0.1:8000/profile/3192876874GAELCOX286/0
https://127.0.0.1:8000/profile/3192876874GAELCOX286/0




SELECT COUNT(1) FROM mdl_user
WHERE NOT EXISTS (SELECT 1 FROM uac_mail
                WHERE (flow_code, user_id) = ('MLWELCO', id))


DROP TABLE IF EXISTS uac_mail;

DROP TABLE IF EXISTS uac_mail;
CREATE TABLE IF NOT EXISTS `ACEA`.`uac_mail` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `flow_id` BIGINT NULL,
  `flow_code` CHAR(7) NULL,
  `user_id` BIGINT UNSIGNED NOT NULL,
  `status` CHAR(3) NOT NULL,
  `create_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `NOTIF` (`flow_code`, `user_id`));


INSERT INTO uac_param (key_code, description, par_int, par_code, par_date) VALUES ('DMAILLI', 'Limit of email per day', 200, NULL, CURDATE());


select * from mdl_user;


select * from mdl_user_info_field;

select * from mdl_user_info_data;


select mu.username, muif.name, muid.data from mdl_user mu
							JOIN mdl_user_info_data muid ON muid.userid = mu.id
						  JOIN mdl_user_info_field muif ON muif.id = muid.fieldid
						  						AND muif.shortname = 'matricule'
						  		WHERE mu.username = 'celeyen013'
						  		ORDER BY muif.categoryid, muif.sortorder;



select * from uac_scan_ferie;
SELECT
		mu.id AS ID,
          mu.username AS USERNAME,
           uas.secret AS SECRET,
           CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE,
           mr.shortname AS ROLE_SHORTNAME,
           UPPER(mu.firstname) AS FIRSTNAME,
           UPPER(mu.lastname) AS LASTNAME,
           mu.email AS EMAIL,
           mu.phone1 AS PHONE,
           mu.address AS ADDRESS,
           mu.city AS CITY,
           mu.phone2 AS PARENT_PHONE,
           mf.contextid AS PIC_CONTEXT_ID,
           mu.picture AS PICTURE_ID,
           SUBSTRING(mf.contenthash, 1, 2) AS D1,
           SUBSTRING(mf.contenthash, 3, 2) AS D2,
           mf.contenthash AS FILENAME
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
           JOIN mdl_role mr ON mr.id = uas.roleid
           LEFT JOIN mdl_files mf ON mu.picture = mf.id
           where mu.id IN (24, 25, 27);


select * from uac_showuser;

select * from uac_param

select * from uac_param;

select CURDATE();






select * from mdl_course_categories;


INSERT INTO uac_param (key_code, description, par_int, par_code, par_date) VALUES ('SCANXXX', 'Flow retard', NULL, NULL, CURDATE());


select * from uac_working_flow;


select * from uac_load_scan;


select * from uac_scan;




select * from mdl_user;



SELECT DATE_ADD(CURRENT_DATE, INTERVAL -10 DAY);

UPDATE uac_load_scan SET status = 'NEW';
DELETE FROM uac_scan;


select * from uac_load_scan;

SELECT * from uac_scan;

select current_date;

CALL SRV_MNG_Scan('2022-09-12');


CALL SRV_MNG_Scan(NULL);


select * from uac_working_flow;


select CONCAT('', '');


SELECT 1, user_id, scan_date, scan_time, 'NEW', 1 FROM uac_load_scan


CALL SRV_PRG_Scan();


DELIMITER $$
DROP PROCEDURE IF EXISTS SRV_PRG_Scan$$
CREATE PROCEDURE `SRV_PRG_Scan` ()
BEGIN
    DECLARE prg_date	DATE;
    DECLARE prg_history_delta	INT;
    -- CALL SRV_PRG_Scan();

    SELECT par_int INTO prg_history_delta FROM uac_param WHERE key_code = 'SCANPRG';
    SELECT DATE_ADD(CURRENT_DATE, INTERVAL -prg_history_delta DAY) INTO prg_date;

    DELETE FROM uac_load_scan WHERE scan_date < prg_date;
    DELETE FROM uac_working_flow WHERE flow_code = 'SCANXXX' AND create_date < prg_date;

END$$
-- Remove $$ for OVH



select * from uac_mail;

call SRV_CRT_MailWelcomeNewUser();

select count(1) from uac_mail;


-- delete from uac_mail;

select * from uac_working_flow order by 1 desc;


UPDATE uac_mail SET status = 'END' WHERE status = 'INP' and flow_code = inv_flow_code;
              UPDATE uac_working_flow SET status = 'END' WHERE id IN (11, 12, 13, 8, 9);

select * from uac_mail;


UPDATE uac_mail SET status = 'BLK';

select * from uac_load_scan order by 1 desc;


select * from uac_scan order by 1 desc;

UPDATE uac_mail SET status = 'END'
WHERE id IN (
    SELECT id FROM (
        SELECT id FROM uac_mail
        ORDER BY id ASC
        LIMIT 0, 30
    ) tmp
)




CALL SRV_GRP_WelcomeEMail();

select count(1) FROM uac_showuser;

UPDATE uac_mail SET status = 'BLK';
UPDATE uac_mail um SET um.status = 'NEW'
WHERE um.user_id IN (
	select id from mdl_user mu where FROM_UNIXTIME(timecreated) > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)
);



select count(1) from uac_mail where status = 'END';
select * from uac_param;

select FROM_UNIXTIME(mu.timecreated) from mdl_user mu


select id from mdl_user mu where FROM_UNIXTIME(mu.timecreated) > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY);


select * from uac_working_flow;

select mdu.username, usa.* from uac_scan usa
join mdl_user mdu on usa.user_id = mdu.id
order by scan_time asc;


select mdu.username, in_out, count(1) from uac_scan usa
join mdl_user mdu on usa.user_id = mdu.id
group by mdu.username, in_out
order by count(1) desc;


select mdu.username, count(1) from uac_scan usa
join mdl_user mdu on usa.user_id = mdu.id
group by mdu.username
order by count(1) desc;






-- delete from uac_scan;



-- update uac_scan set scan_date = '2022-09-26'

select * from uac_scan;

update uac_load_scan SET status = 'NEW';

delete from uac_mail;

SELECT * FROM uac_edt
      WHERE monday_ofthew = '2022-09-26'
      AND mention = 'COMMUNICATION'
      AND niveau = 'L1'
      AND uaoption IS NULL;


delete from uac_load_edt;

select * from uac_load_edt;

select * from uac_edt ue where ue.label_day = 'TUESDAY';

select * from uac_working_flow;

-- delete from uac_edt where monday_ofthew = '2022-09-26'


select * from uac_edt ue order by hour_starts_at, day_code asc;


select * from uac_edt ue order by day_code, hour_starts_at asc;


CALL CLI_GET_FWEDT('test', -4, 'N');


select * from uac_working_flow;


select * from uac_load_edt where monday_ofthew = '2022-09-19' order by day_code, hour_starts_at;


select * from uac_edt ue where day = '2022-09-26' and duration_hour > 0 order by hour_starts_at asc;

select * from uac_param;

select * from uac_admin;


SELECT DAYOFWEEK(CURRENT_DATE);


CALL SRV_MNG_Scan(NULL);




CALL SRV_CRT_ComptAssdFlow('2022-09-27');


SELECT uas.username, ass.*, sca.* from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id
								JOIN uac_showuser uas ON mu.username = uas.username
									  LEFT JOIN uac_scan sca ON sca.id = ass.scan_id
									  WHERE uas.username = 'gaelcox286'


SELECT mu.city AS city, COUNT(1) AS VAL from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id
									JOIN uac_showuser uas ON mu.username = uas.username
											WHERE ass.status = 'ABS'
											GROUP BY mu.city, ass.status


SELECT REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), "'", " ") AS NAME, COUNT(1) AS VAL from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id
									JOIN uac_showuser uas ON mu.username = uas.username
											WHERE ass.status = 'ABS'
											GROUP BY mu.firstname, mu.lastname, ass.status
												ORDER BY COUNT(1) DESC LIMIT 30


select mu.* from mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username

SELECT uas.username, sca.user_id, ass.status, uae.hour_starts_at, uae.day, REPLACE(SUBSTRING(uae.raw_course_title, 1, 20), '\n', 'xxx'), sca.scan_date, sca.scan_time
FROM uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id
								JOIN uac_showuser uas ON mu.username = uas.username
									  JOIN uac_edt uae ON uae.id = ass.edt_id
									  LEFT JOIN uac_scan sca ON sca.id = ass.scan_id
									  WHERE uas.username = 'gaelcox286'




select * from uac_scan uas where uas.user_id = 338 order by scan_time desc;


update uac_edt SET compute_late_status = 'NEW';
delete from uac_assiduite;
delete from uac_working_flow where flow_code = 'ASSIDUI';





select * from uac_working_flow;

SELECT mu.username, uas.* FROM uac_scan uas JOIN mdl_user mu ON mu.id = uas.user_id
WHERE uas.scan_date > DATE_ADD(CURRENT_DATE, INTERVAL -7 DAY)
order by scan_date, scan_time desc;


SELECT *
          FROM uac_edt ue WHERE ue.compute_late_status = 'NEW'
          AND ue.day = '2022-09-26'
          AND duration_hour > 0



select * from uac_load_scan;

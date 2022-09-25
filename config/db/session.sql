symfony local:server:stop
symfony server:start

11:14:32.186 debug	Hash password: lanatureestverte e716e0cf70d3c6dbd840945d890f074d -- benrand123
11:14:32.186 debug	Hash password: lebleuduciel 78e740abec0d61e6dd52452e6d9c2a32 -- harrako912
11:14:32.186 debug	Hash password: lelapinblanc 9248153d95104975573f18e2852d6647 -- lalrako381
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924 -- ionrako617
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924 -- tokrako283
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924 -- tsirako227
-- Agent
11:14:32.186 debug	Hash password: lelemurientoutnoir c24d593b9266e7b8d0887d0dc7259705 -- mikrama654
11:14:32.186 debug	Hash password: unnuagedansleciel d064a894fb8645879312b10d366cd604 -- mborako321
11:14:32.186 debug	Hash password: unesardinedanslamer 9433c9064f0593da5727e2122a193a6e
11:14:32.186 debug	Hash password: unrequindanslocean 3165cef3bc67568c7d30f5a184f43766
11:14:32.186 debug	Hash password: leratdesvilles a2d426e5a92f1bbf418a35869ffc7cc2
11:14:32.186 debug	Hash password: unetortuegasy 2df68a85f1932ca876926252bbaa0820

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

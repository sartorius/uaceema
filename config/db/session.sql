symfony local:server:stop
symfony server:start



-- MD5
11:14:32.186 debug	Hash password: lanatureestverte e716e0cf70d3c6dbd840945d890f074d -- benrand123
11:14:32.186 debug	Hash password: lebleuduciel 78e740abec0d61e6dd52452e6d9c2a32 -- harrako912
11:14:32.186 debug	Hash password: lelapinblanc 9248153d95104975573f18e2852d6647 -- tefyako381
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




select * from uac_load_scan where scan_date = '2022-11-23'


select * from uac_load_scan where scan_date = '2022-11-23' order by 1 desc;

select * from uac_load_scan where scan_date = '2022-11-21'
and CONVERT(scan_time, TIME) > CONVERT('06:59:59', TIME)
and CONVERT(scan_time, TIME) < CONVERT('07:49:59', TIME) order by 1 desc;



select DISTINCT (scan_username) from uac_load_scan where scan_date = '2022-11-21'
and CONVERT(scan_time, TIME) > CONVERT('06:59:59', TIME)
and CONVERT(scan_time, TIME) < CONVERT('07:49:59', TIME) order by 1 desc;


select * from v_connection_log;

select * from uac_admin;


select * from uac_working_flow  where flow_code = 'GRPMLWC' order by 1 desc;


select distinct flow_code from uac_working_flow order by 1 desc;


-- Session PRO

-- 39 to 56








SELECT * FROM uac_assiduite_off;

-- INSERT INTO uac_assiduite_off (working_date, day_code, reason) VALUE ('2022-11-28', 1, 'Début activité');

-- INSERT INTO uac_assiduite_off (working_date, day_code, reason) VALUE ('2022-11-29', 2, 'Début activité');



select * from v_connection_log order by CREATION_DATE desc;


-- UPDATE uac_mail SET last_update = create_date, status = 'NEW'
where last_update > '2022-12-02 11:20:49'
and status = 'END';


select * from uac_mail
where 1=1
-- and last_update < '2022-11-28 01:42:49'
and last_update > '2022-12-02 11:20:49'
and status = 'END';

-- UPDATE uac_mail SET last_update = create_date, status = 'NEW'
where last_update < '2022-11-28 01:42:49'
and last_update > '2022-11-27 11:30:49'
and status = 'END';



select * from mdl_user;

select * from uac_admin  ua JOIN mdl_user mu on mu.id = ua.id;

SELECT * from uac_param;
-- Unlock 14h42

SELECT count(1) from uac_mail where status = 'NEW'


SELECT * from uac_mail where status = 'NEW'


select * from mdl_user mu where mu.lastname = 'IHARIMANANA';


select * from mdl_user mu where mu.firstname = 'Sarah';


SELECT * from uac_mail where user_id = 123


SELECT * from uac_mail where user_id = 227






select * from mdl_user mu where mu.email = 'eodiadeviro@gmail.com'


select * from uac_mail
where last_update < '2022-11-26 18:50:49'
and status = 'END';


select * from uac_mail where create_date > '2022-11-26 01:01:59'
and id > 56 and status = 'END'
order by 1 desc;


SELECT *
        FROM v_showuser where USERNAME = 'megurab387' order by id;




SELECT vcc.short_classe AS CLASSE, REPLACE(CONCAT(mu.firstname, ' ', mu.lastname), "'", " ") AS NAME, COUNT(1) AS VAL from uac_assiduite ass JOIN mdl_user mu ON mu.id = ass.user_id JOIN uac_showuser uas ON mu.username = uas.username JOIN v_class_cohort vcc ON vcc.id = uas.cohort_id WHERE ass.status = 'ABS' GROUP BY mu.firstname, mu.lastname, ass.status, vcc.short_classe ORDER BY COUNT(1) DESC LIMIT 100;




select * from uac_edt_master;


select COUNT(1) AS QUEUED_ASS from uac_working_flow where status = 'QUE';


select * from uac_working_flow where status = 'QUE';



select * from uac_working_flow uwf where flow_code = 'QUEASSI' ORDER BY 1 DESC;



select * from uac_working_flow uwf where flow_code = 'RESASSI' ORDER BY 1 DESC;


select * from uac_working_flow uwf where flow_code = 'ASSIDUI' ORDER BY 1 DESC;


-- CALL SRV_CRT_ComptAssdFlow ('2022-11-25')


-- CALL SRV_CRT_ComptAssdFlow ('2022-11-24')

SELECT COUNT(1) AS QUEUED_ASS FROM uac_edt_line uel JOIN uac_edt_master uem ON uel.master_id = uem.id AND uem.cohort_id = 15
WHERE uel.day < CURRENT_DATE and uel.compute_late_status = 'NEW' AND uel.course_status = 'A' and uel.duration_hour > 0;



SELECT * FROM uac_edt_line uel JOIN uac_edt_master uem ON uel.master_id = uem.id
WHERE uel.day < CURRENT_DATE and uel.compute_late_status = 'NEW' AND uel.course_status = 'A' and uel.duration_hour > 0;


select * from uac_assiduite;


select * from v_class_cohort;





select * from mdl_user mu where mu.email = 'sarahiharimanana@gmail.com'

select distinct(username) from v_studashboard_log;


select * from v_studashboard_log;


select * from v_showuser where cohort_id = 1
and ID IN (

SELECT user_id from uac_mail where status = 'NEW'
);

select * from v_showuser where EMAIL = 'mirimarajoelina@gmail.com'

SELECT STR_TO_DATE('21-05-2013','%d-%m-%Y');

SELECT mu.email AS EMAIL, mu.lastname AS LASTNAME, mu.firstname AS FIRSTNAME, vs.SHORTCLASS AS CLASS, mu.datedenaissance AS DATEDENAISSANCE , CASE WHEN um.status = 'NEW' THEN 'Email carte étudiant en cours' ELSE CONCAT('Email carte étudiant envoyé le ', DATE_FORMAT(um.last_update, '%d/%m/%Y vers %H:%i UTC')) END AS EMAIL_STATUS
FROM v_showuser vs JOIN mdl_user mu ON mu.id = vs.ID
JOIN uac_mail um ON um.user_id = mu.id AND um.flow_code = 'MLWELCO'
where vs.LASTNAME = 'ANAMAHEFA' AND mu.datedenaissance = '2005-11-08'

08-11-2005




-- INSERT INTO uac_assiduite_archive (flow_id, user_id, edt_id, scan_id, status, create_date)
select flow_id, user_id, edt_id, scan_id, status, create_date from uac_assiduite;

select flow_id, user_id, edt_id, scan_id, status, create_date from uac_assiduite_archive;

-- DELETE FROM uac_assiduite;


select * from mdl_user;

DELETE FROM mdl_load_user;
CALL MAN_LOAD_MDLUser();
CALL MAN_CRT_MDLUser();


-- SESSION PROD


select * from v_showuser vsc join mdl_user mu on mu.username = vsc.username
where mu.create_date < '2023-02-02'
order by 1 asc;


select * from uac_showuser us where us.create_date < '2023-01-02' order by us.create_date;

select * from uac_showuser us where us.create_date < '2023-01-02' order by us.create_date;

select * from uac_load_scan uls
where NOT(uls.status = 'END');


select * from uac_load_scan uls
where NOT(uls.status = 'END');


select * from uac_load_scan uls
where uls.scan_username like '%dyla%'
and NOT(uls.status = 'END');



select * from uac_load_scan uls
where uls.status = 'MIS';

select uls.scan_username, count(1)
from uac_load_scan uls
where uls.status = 'MIS'
group by uls.scan_username
order by count(1) desc;


-- ABIEMAM179
-- DYLAREA047
-- AINARAH382



select * from uac_load_scan uls where uls.scan_username = 'ranitoa38';


select * from v_showuser order by 1 desc;


select * from mdl_user order by 1 asc;



DELETE FROM mdl_load_user;
CALL MAN_LOAD_MDLUser();
CALL MAN_CRT_MDLUser();


select * from v_studashboard_log order by creation_date desc;


-- select * from mdl_user mu where mu.email_par1 is not null;

select * from mdl_user mu where mu.username = 'JEANRAS329'

select * from mdl_user mu where mu.lastname = 'RASOLOFOMANANA'


select * from mdl_user mu where mu.email = 'tommysixx22@gmail.com';



select * from uac_showuser us where us.username = 'sixxtom123';


select * from v_showuser where username = 'antsrav051';

select * from v_class_cohort



select * from uac_edt_line;

select distinct(course_status) from uac_edt_line;


select uel.day, uem.last_update, vcc.short_classe, uel.raw_course_title, uem.monday_ofthew from uac_edt_line uel join uac_edt_master uem on uel.master_id = uem.id
								join v_class_cohort vcc on vcc.id = uem.cohort_id
where uel.course_status = 'C' ORDER BY uel.day desc;



select * from v_studashboard_log;

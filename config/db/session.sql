symfony local:server:stop
symfony server:start

11:14:32.186 debug	Hash password: lanatureestverte e716e0cf70d3c6dbd840945d890f074d -- benrand1234
11:14:32.186 debug	Hash password: lebleuduciel 78e740abec0d61e6dd52452e6d9c2a32 -- harrako1912
11:14:32.186 debug	Hash password: lelapinblanc 9248153d95104975573f18e2852d6647 -- lalrako3819
11:14:32.186 debug	Hash password: unetortuegasy 2df68a85f1932ca876926252bbaa0820 -- ionrako6172
11:14:32.186 debug	Hash password: lelemurientoutnoir c24d593b9266e7b8d0887d0dc7259705
11:14:32.186 debug	Hash password: unnuagedansleciel d064a894fb8645879312b10d366cd604
11:14:32.186 debug	Hash password: unesardinedanslamer 9433c9064f0593da5727e2122a193a6e
11:14:32.186 debug	Hash password: lelionestleroi 3182a20c71d20d919cb1f3b3035d5924
11:14:32.186 debug	Hash password: unrequindanslocean 3165cef3bc67568c7d30f5a184f43766
11:14:32.186 debug	Hash password: leratdesvilles a2d426e5a92f1bbf418a35869ffc7cc2

http://localhost:8888/aceemintranet/pluginfile.php/43/user/icon/boost/f1?rev=119


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

-- Insert
  INSERT IGNORE INTO uac_showuser (roleid, username)
  SELECT MAX(roleid), username FROM mdl_role_assignments mra
                                JOIN mdl_role mr ON mr.id = mra.roleid
                                JOIN mdl_user mu ON mu.id = mra.userid
  GROUP BY username;
-- Add secret
  UPDATE uac_showuser SET secret = 3000000000 + FLOOR(RAND()*1000000000), last_update = NOW() WHERE secret IS NULL;

-- Control to save !
  SELECT mu.id, mu.username, uas.secret, CONCAT(CAST(uas.secret AS CHAR), UPPER(uas.username)) AS PAGE, mr.shortname, mu.firstname, mu.lastname, mu.email, mu.phone1, mu.phone2
  FROM mdl_user mu JOIN uac_showuser uas ON mu.username = uas.username
           JOIN mdl_role mr ON mr.id = uas.roleid;

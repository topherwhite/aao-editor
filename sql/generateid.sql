-- Example SQL for a function to generate 5 character alphanumeric IDs

CREATE TABLE photos (uid char(5));

DROP FUNCTION generateid;

delimiter //
CREATE FUNCTION generateid() RETURNS char(5)
BEGIN
   DECLARE newid char(5);
   DECLARE test tinyint;
   DECLARE possiblechars char(36) default 'abcdefghijklmnopqrstuvwxyz0123456789';
   REPEAT
      SET newid = concat( substring(possiblechars,floor(1+rand()*36),1),
         substring(possiblechars,floor(1+rand()*36),1),
         substring(possiblechars,floor(1+rand()*36),1),
         substring(possiblechars,floor(1+rand()*36),1),
         substring(possiblechars,floor(1+rand()*36),1));
      SELECT count(1) INTO test FROM photos WHERE uid = newid;
   UNTIL test = 0
   END REPEAT;
   RETURN newid;
END//
delimiter ;

INSERT INTO photos VALUES (generateid());

SELECT generateid();
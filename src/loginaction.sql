-- delete session cookie for all disabled users
DELETE FROM CoreUserSession WHERE UserId in (SELECT UserId from CoreUser WHERE IsActive = false);

-- password validation
SELECT 'authentication' AS component,
    '/Connexion.sql?error' AS link,
    (SELECT PasswordHash FROM CoreUser WHERE Username = :username and IsActive=true) AS password_hash,
    :password AS password;

-- delete old session token
DELETE FROM CoreUserSession WHERE UserId = (SELECT UserId FROM CoreUser WHERE Username = :username);

-- Generate session token into db and store into a cookie
INSERT INTO CoreUserSession (Session, UserId)
SELECT sqlpage.random_string(32),
       UserId
From CoreUser where Username = :username
RETURNING 'cookie' AS component, 
          'session' AS name, 
          Session AS value;

SELECT 'redirect' AS component, '/home.sql' AS link;
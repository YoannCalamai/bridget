DELETE FROM CoreUserSession WHERE Session = sqlpage.cookie('session');
SELECT 'cookie' AS component, 'session' AS name, TRUE AS remove;

SELECT 'redirect' AS component, '/' AS link;
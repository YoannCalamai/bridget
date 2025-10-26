SELECT 
    'cookie' AS component,
	'lightdarkstatus' AS name,
	CASE COALESCE(sqlpage.cookie('lightdarkstatus'),'')
    WHEN '' THEN 'dark'
    ELSE '' END 
    as value;

SELECT 
    'redirect' AS component,
    './MyProfile.sql' as link;
-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;


SELECT 'hero' AS component,
    'Forbidden access' AS title,
    'Sorry, you need a special authorisation to come here' AS description_md,
    '/images/denied0'|| floor(random() * 4)::int ||'.jpg' AS image,
    '/home.sql' AS link,
    'Go to Home' AS link_text;
-- Check session
select 'dynamic' as component, sqlpage.run_sql('./include/sessioncheck-user.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;


SELECT 'hero' AS component,
    'Page not found' AS title,
    'Oups, there is nothing to see here. You are on the wrong way or you follow a dead link.' AS description_md,
    '/images/404-0'|| floor(random() * 3)::int ||'.jpg' AS image,
    '/home.sql' AS link,
    'Go to Home' AS link_text;
-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-public.sql') as properties;

SELECT 'hero' AS component,
    (Select Value FROM AppSettings where name='IndexTitle') AS title,
    (Select Value FROM AppSettings where name='IndexDescription') AS description_md,
    (Select Value FROM AppSettings where name='IndexImage') AS image,
    'Login.sql' AS link,
    'Log in' AS link_text;
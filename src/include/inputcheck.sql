/* test if 
    - input is null
    - input is an integer
    - input is greater than 0
*/
SELECT 
    'redirect' AS component,
    '/home.sql' AS link,
    $id
WHERE $id is null
OR NOT ($id ~ '^[0-9]+$')
OR (coalesce($id::int,0)<=0);
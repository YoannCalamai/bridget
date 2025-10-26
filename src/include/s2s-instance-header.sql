-- Redirect to Home page if id query parameter is invalid
SELECT 'dynamic' as component, sqlpage.run_sql('include/inputcheck.sql',
                                               json_object('id', $id)) as properties;
SELECT 
    'redirect' AS component,
    '/home.sql' AS link
WHERE $id::int NOT IN (SELECT InstanceId FROM QuestInstance);

-- Redirect to Home page if catid query parameter is invalid
SELECT 'dynamic' as component, sqlpage.run_sql('include/inputcheck.sql',
                                               json_object('id', $catid)) as properties;

SELECT 
    'redirect' AS component,
    '/home.sql' AS link
WHERE $catid::smallint NOT IN (SELECT CategoryId FROM QuestInstanceCategories WHERE IsSelected=true);

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'S2S document' as title,
    '/s2s/S2SInstance.sql' as link,
    TRUE as active;

-----
-- datagrid
SELECT 
    'datagrid' as component
FROM QuestInstance
WHERE InstanceId=$id::int;
-- customer name
SELECT 
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Nom du client' -- French
        WHEN 3 THEN 'Klantnaam' -- Dutch
        ELSE 'Customer Name' END -- English
    as title,
    CustomerName as description
FROM QuestInstance
WHERE InstanceId = $id::int;
-- nb of employees
SELECT 
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Nombre de salarié' -- French
        WHEN 3 THEN 'Aantal werknemers' -- Dutch
        ELSE 'Number of employees' END -- English 
    as title,
    NbEmployee as description
FROM QuestInstance
WHERE InstanceId = $id::int;
-- industry
SELECT 
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Secteur d''activité' -- French
        WHEN 3 THEN 'Industry' -- Dutch
        ELSE 'Industry' END -- English 
    as title,
    il.Name as description
FROM QuestInstance
JOIN SysIndustryLanguage il USING (IndustryId)
WHERE InstanceId = $id::int
AND il.LanguageId = (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'));
-- sales
SELECT 
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Commercial' -- French
        WHEN 3 THEN 'Verkoper' -- Dutch
        ELSE 'Sales Rep' END -- English
    as title,
    SalesRep || '@ukg.com' as description
FROM QuestInstance
WHERE InstanceId = $id::int;
-- presales
SELECT 
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Avant-Vente' -- French
        WHEN 3 THEN 'Voorverkoper' -- Dutch
        ELSE 'PreSales Rep' END -- English 
    as title,
    PreSalesRep || '@ukg.com' as description
FROM QuestInstance
WHERE InstanceId = $id::int;

-----
-- blank line
SELECT
    'html' as component,
    '<br/>&nbsp;<br/>' as html;

-----
-- direct links
SELECT
    'directlink' as component,
    -- label
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Accès direct'   -- French
        WHEN 3 THEN 'Direct link'   -- Dutch
        ELSE 'Direct link'   END -- English
    as label,
    -- name
    'directlink' as name,
    -- options
    json_agg(json_build_object(
        'label', 
        cat.OffsetPosition +1 || ' - ' || cl.Name, 
        'value', 
        CASE WHEN cat.IsForMulticountry = true 
        THEN '/s2s/S2SInstanceMulticountry.sql?id='
        ELSE '/s2s/S2SInstanceCategory.sql?id=' END 
        || qc.InstanceId || '&catid=' || cat.CategoryId 
    ))
    as options
FROM QuestInstanceCategories as qc
JOIN ConfCategoryLanguage as cl USING(CategoryId)
JOIN getCategoryOffset($id::int) as cat USING(CategoryId)
WHERE $id IS NOT NULL
AND qc.InstanceId=$id::int
AND LanguageId=(SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'));

-----
-- Category steps
SELECT 
    'steps' as component;
SELECT
    -- title
    c.OffsetPosition +1 || ' - ' || cl.Name as title,
    -- link
    CASE c.IsForMulticountry
    WHEN true THEN 'S2SInstanceMulticountry.sql'
    ELSE 'S2SInstanceCategory.sql' END
    || '?id=' || $id || '&catid=' || qc.CategoryId 
    as link
FROM QuestInstanceCategories as qc
JOIN ConfCategoryLanguage as cl on qc.CategoryId=cl.CategoryId
JOIN getCategoryOffset($id::int) as c on qc.CategoryId=c.CategoryId
AND LanguageId=(SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
WHERE $id IS NOT NULL
AND qc.InstanceId=$id::int
ORDER BY c.DisplayOrder, cl.Name
LIMIT 3 
OFFSET (SELECT CASE WHEN (getSpecificCategoryOffset($id::int,$catid::smallint))-1 < 0 THEN 0 
               ELSE (getSpecificCategoryOffset($id::int,$catid::smallint))-1 END);

-----
-- Navigation buttons
SELECT 'button' as component,
        'pill' as shape,
        'normal' as size,
        'between' as justify
        ;

-- previous button
SELECT
    -- title
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Précédent'   -- French
        WHEN 3 THEN 'Previous'   -- Dutch
        ELSE 'Previous'   END -- English
    as title,
    -- link
    CASE
    WHEN cat.OffsetPosition = 0 
    THEN 'S2SInstance.sql?id=' || qc.InstanceId
    WHEN prevcat.IsForMulticountry = true 
    THEN 'S2SInstanceMulticountry.sql' || '?id=' || qc.InstanceId || '&catid=' ||  prevcat.CategoryId
    ELSE 'S2SInstanceCategory.sql' || '?id=' || qc.InstanceId || '&catid=' ||  prevcat.CategoryId
    END    
    as link,
    -- color
    'teal' as color,
    -- icon
    'arrow-left' as icon
FROM QuestInstanceCategories as qc
JOIN ConfCategoryLanguage as cl on qc.CategoryId=cl.CategoryId
JOIN getCategoryOffset($id::int) as cat on qc.CategoryId=cat.CategoryId
LEFT JOIN getCategoryOffset($id::int) as prevcat on (cat.OffsetPosition-1)=prevcat.OffsetPosition
WHERE $id IS NOT NULL
AND qc.InstanceId=$id::int
AND cat.CategoryId=$catid::int
AND cl.LanguageId=(SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
ORDER BY cat.DisplayOrder, cl.Name;

-- next button
SELECT
    -- title
    CASE (SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
        WHEN 2 THEN 'Suivant'   -- French
        WHEN 3 THEN 'Next'   -- Dutch
        ELSE 'Next'   END -- English
    as title,
    -- link
    CASE nextcat.IsForMulticountry
    WHEN true THEN 'S2SInstanceMulticountry.sql'
    ELSE 'S2SInstanceCategory.sql' END
    || '?id=' || qc.InstanceId || '&catid=' || nextcat.CategoryId 
    as link,
    -- color
    'teal' as color,
    -- icon
    'arrow-right' as icon_after
FROM QuestInstanceCategories as qc
JOIN ConfCategoryLanguage as cl on qc.CategoryId=cl.CategoryId
JOIN getCategoryOffset($id::int) as cat on qc.CategoryId=cat.CategoryId
JOIN getCategoryOffset($id::int) as nextcat on (cat.OffsetPosition+1)=nextcat.OffsetPosition
WHERE $id IS NOT NULL
AND qc.InstanceId=$id::int
AND cat.CategoryId=$catid::int
AND LanguageId=(SELECT coalesce(LanguageId,1) FROM GetUserFromSession WHERE Session = sqlpage.cookie('session'))
ORDER BY cat.DisplayOrder, cl.Name;
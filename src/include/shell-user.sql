Select 'shell' as component,
        CASE COALESCE(sqlpage.cookie('lightdarkstatus'),'')
        WHEN '' THEN ''
        ELSE 'dark' END 
        as theme,
        '/fonts/Luciole-Regular.css' as css,
        'Luciole' as font,
       (Select a.Value FROM AppSettings a where a.Name='CompanyShortname') AS title,
       'fluid' as layout,
       'fr' as lang,
       'heart-handshake' AS icon,
       '/home.sql' AS link,
        (SELECT json_agg(json_build_object('title', menu.Name, 'link', menu.Link))
        FROM
        (SELECT Name,
        Link,
        DisplayOrder
        FROM MenuSettings
        WHERE IsActive=true AND IsAdmin=false
        ORDER BY DisplayOrder) as menu) as menu_item,
        (SELECT
                (Select Value FROM AppSettings where name='CompanyShortname') || ' | ' ||
                '2025'
        )
     AS footer
;
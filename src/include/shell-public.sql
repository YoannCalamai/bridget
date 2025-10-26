Select 'shell' as component,
       '/fonts/Luciole-Regular.css' as css,
       'Luciole' as font,
        (Select Value FROM AppSettings where name='CompanyShortname') AS title,
        'heart-handshake' AS icon,
        '/' AS link,
        JSON('{"link":"Login.sql","title":"Log in"}') as menu_item,
        'horizontal' as layout,
        'fr' as lang,
        (SELECT
                (Select Value FROM AppSettings where name='CompanyShortname') || ' | ' ||
                '2025'
        )
     AS footer
;
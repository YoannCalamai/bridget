-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Check input
SELECT 'redirect' AS component,
        './NotificationConfig.sql' AS link
WHERE NOT ($id IS NULL OR $id::int in (Select NotificationProviderId FROM NotificationProvider));

-- Upsert
INSERT INTO NotificationProvider (NotificationProviderId, NotificationType, Name, TemplateId) 
VALUES 
(       
        coalesce($id::int,(select coalesce(max(NotificationProviderId),0) from NotificationProvider) + 1),
        coalesce(:NotificationType::int,0),
        :Name, 
        :TemplateId
)
ON CONFLICT (NotificationProviderId) DO 
UPDATE SET NotificationType = excluded.NotificationType,
        Name = excluded.Name,
        TemplateId = excluded.TemplateId
RETURNING
    'redirect' AS component,
    './NotificationProvider.sql?id=' || NotificationProviderId || '&success=true' as link;


-- Gaseton helps ethical and solidarity-based purchasing group to communicate and organize themselve
-- Copyright (C) 2024  Yoann Calamai

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

-- Check session and admin right
select 'dynamic' as component, sqlpage.run_sql('include/sessioncheck-admin.sql') as properties;

-- Page header/footer
select 'dynamic' as component, sqlpage.run_sql('include/shell-user.sql') as properties;

-- Alerts
select 'dynamic' as component, sqlpage.run_sql('include/alert-save-success-error.sql') as properties;

-- Navigation
select 
    'breadcrumb' as component;
select 
    'Home' as title,
    '/home.sql'    as link;
select 
    'Application settings' as title,
    '/appsettings/AppSettingsHome.sql' as link;
select 
    'Notifications Configuration' as title,
    '/appsettings/NotificationConfig.sql' as link,
    TRUE   as active;

select 
    'title'   as component,
    'Notifications Configuration' as contents,
    1 as level;

select 
    'divider' as component;

select 
    'title'   as component,
    'Notification providers' as contents,
    2 as level;

select 
    'divider' as component,
    'Actions'   as contents;

SELECT 'button' as component,
        'sm' as size;
SELECT 'Add a provider' as title,
        './NotificationProvider.sql' AS link,
        'primary' as color,
        'plus' as icon;
SELECT 
    'table' as component,
    'action' as markdown,
    1 as sort,
    1 as search
FROM NotificationProvider
LIMIT 1;
SELECT CASE NotificationType
        WHEN -1 THEN 'Désactivé'
        WHEN 0 THEN 'PDF Generation' 
        ELSE '' END as "Type", 
       Name as "Name", 
       '[Edit](./NotificationProvider.sql?id='||NotificationProviderId||')' as "action"
FROM NotificationProvider
ORDER BY NotificationProviderId;

SELECT
    'title' as component,
    'No provider configured' as contents,
    4 as level
    WHERE (select count(NotificationProviderId) from NotificationProvider)=0;

select 
    'divider' as component;

select 
    'title'   as component,
    'Notifications list' as contents,
    2 as level;

SELECT 
    'table' as component,
    1 as sort,
    1 as search
FROM NotificationCenter
LIMIT 1;
SELECT CASE NotificationType 
        WHEN 0 THEN 'PDF Generation' 
        ELSE '' END as "Type", 
       CreatedAt as "Created at",
       SendAt as "Done at",
       TO_CHAR((EXTRACT(epoch from SendAt - CreatedAt) || 'second')::interval, 'HH24:MI:SS') as "Delta",
       RowId as "RowId",
       "status" as "Status"
FROM NotificationCenter
order by CreatedAt DESC;

SELECT
    'title' as component,
    'No notification' as contents,
    4 as level
    WHERE (select count(NotificationCenterId) from NotificationCenter)=0;
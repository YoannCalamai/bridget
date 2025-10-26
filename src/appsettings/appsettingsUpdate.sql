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

-- Update
UPDATE AppSettings SET Value=:AssociationShortname WHERE appsettingid=1 AND :AssociationShortname IS NOT NULL;
UPDATE AppSettings SET Value=:AssociationLongname WHERE appsettingid=2 AND :AssociationLongname IS NOT NULL;
UPDATE AppSettings SET Value=:IndexTitle WHERE appsettingid=4 AND :IndexTitle IS NOT NULL;
UPDATE AppSettings SET Value=:IndexDescription WHERE appsettingid=5 AND :IndexDescription IS NOT NULL;
UPDATE AppSettings SET Value=:IndexImage WHERE appsettingid=6 AND :IndexImage IS NOT NULL;

INSERT INTO AppSettings (appsettingid, name, Value)
SELECT 8, 'PaymentMethod', :PaymentMethod WHERE :PaymentMethod IS NOT NULL
ON CONFLICT (appsettingid) DO 
UPDATE SET Value = excluded.Value;

UPDATE AppSettings SET Value=CASE WHEN coalesce(:IsSubscriptionActive,'false')='false' THEN '0' else '1' END WHERE appsettingid=3;
UPDATE AppSettings SET Value=CASE WHEN coalesce(:IsPasswordRecoveryActive,'false')='false' THEN '0' else '1' END WHERE appsettingid=7;

SELECT
    'redirect' AS component,
    './AppSettings.sql?success=true' as link;
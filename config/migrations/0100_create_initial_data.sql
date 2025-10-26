-- system settings
TRUNCATE TABLE AppSettings;
INSERT INTO AppSettings (AppSettingId,Name,Value)
VALUES
(1,'CompanyShortname', 'Bridget'),
(2,'CompanyName', 'Bridget'),
(3,'IndexTitle', 'Budget management'),
(4,'IndexDescription', 'Bridget helps your budget 😉'),
(5,'IndexImage', 'https://images.rawpixel.com/image_social_landscape/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTA5L3Jhd3BpeGVsX29mZmljZV8zMV9hX3Bob3Rvc19zcXVpcnJlbF9mYW1pbHlfYmVfaGFwcHlfZjUtNl84a19hcl84MDNkNDkxOC01MGUzLTQwNjgtOGZkYi0xODU0NDdiOTUwNzlfMS5qcGc.jpg'),
(6,'IsPasswordRecoveryActive', '0');

-- menu
TRUNCATE TABLE MenuSettings;
INSERT INTO MenuSettings (Name, Link, DisplayOrder)
VALUES
('Budget', '/budget/BudgetHome.sql', 2),
('Users', '/user/UsersHome.sql', 3),
('System Configuration', '/appsettings/AppSettingsHome.sql', 4),
('My Profile', '/user/MyProfile.sql', 5),
('Logoff', '/logoff.sql', 6);

-- mime type
TRUNCATE TABLE MimeType;
INSERT INTO MimeType (MimeType)
VALUES
-- images
('image/bmp'),
('image/gif'),
('image/jpeg'),
('image/png'),
('image/tiff'),
('image/webp'),
-- archives
('application/zip'),
('application/x-rar-compressed'),
('application/x-tar'),
('application/x-bzip'),
('application/x-bzip2'),
-- sheet
('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
('application/vnd.ms-excel'),
('application/vnd.oasis.opendocument.spreadsheet'),
('text/csv'),
-- visio
('application/vnd.visio'),
-- text
('application/rtf'),
('application/vnd.oasis.opendocument.text'),
('application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
('application/msword'),
-- presentation
('application/vnd.openxmlformats-officedocument.presentationml.presentation'),
('application/vnd.ms-powerpoint'),
('application/vnd.oasis.opendocument.presentation'),
-- pdf
('application/pdf');


-- language
--TRUNCATE TABLE SysLanguage;
INSERT INTO SysLanguage (ShortName, Name)
SELECT  'ENG', 'English'
WHERE NOT EXISTS (SELECT 1 FROM SysLanguage WHERE ShortName='ENG');

INSERT INTO SysLanguage (ShortName, Name)
SELECT  'FRA', 'Français'
WHERE NOT EXISTS (SELECT 1 FROM SysLanguage WHERE ShortName='FRA');

INSERT INTO SysLanguage (ShortName, Name)
SELECT  'NLD', 'Dutch'
WHERE NOT EXISTS (SELECT 1 FROM SysLanguage WHERE ShortName='NLD');

-- notification
INSERT INTO NotificationProvider (NotificationType,Name)
VALUES (0,'pdfgenerator');

-- create default security profile
DELETE FROM CoreSecurityProfile;
ALTER TABLE CoreSecurityProfile DISABLE TRIGGER ALL;

INSERT INTO CoreSecurityProfile (SecurityProfileId,
                               Name,
                               Description,
                               isadmin,
                               CreatedBy,
                               UpdatedBy)
SELECT 0,
       'Super Admin rights',
       '',
       true,
       0,
       0
WHERE NOT EXISTS (SELECT 1 FROM CoreSecurityProfile WHERE SecurityProfileId=0);

ALTER TABLE CoreSecurityProfile ENABLE TRIGGER ALL;

-- create default company group
DELETE FROM CoreGroup;
ALTER TABLE CoreGroup DISABLE TRIGGER ALL;

INSERT INTO CoreGroup (GroupId,
                               Name,
                               ParentGroupId,
                               CreatedBy,
                               UpdatedBy)
SELECT 0,
       'Company',
       0,
       0,
       0
WHERE NOT EXISTS (SELECT 1 FROM CoreGroup WHERE GroupId=0);

ALTER TABLE CoreGroup ENABLE TRIGGER ALL;


-- Create default super administrator with password='admin'
DELETE FROM CoreUser;
INSERT INTO CoreUser (UserId,
                            Username, 
                            PasswordHash, 
                            Firstname,
                            Lastname,
                            Email,
							GroupId,
                            SecurityProfileId,
                            LanguageId,
                            IsActive,
                            CreatedBy,
                            UpdatedBy,
                            PasswordLastUpdateAt)
SELECT
0,
'admin@local.net',
'$argon2id$v=19$m=19456,t=2,p=1$BmHu3bzW9Psb1ByT/cgSdg$GDP9QKxols7j+ijXDBZB7Z1qPhg3iGBzrgBfMfqDEi8',
'Super',
'Administrator',
'admin@local.net',
0,
0,
2,
true,
0,
0,
CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM CoreUser WHERE UserId=0);

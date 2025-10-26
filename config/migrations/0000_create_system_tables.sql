CREATE TABLE IF NOT EXISTS AppSettings (
    AppSettingId SMALLSERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Value VARCHAR(1024) NOT NULL
);

CREATE TABLE IF NOT EXISTS MenuSettings (
    MenuSettingId SMALLSERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Link VARCHAR(255) NOT NULL UNIQUE,
    IsAdmin BOOLEAN NOT NULL DEFAULT false,
    IsActive BOOLEAN NOT NULL DEFAULT true,
    DisplayOrder INTEGER NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Color (
    ColorId SMALLSERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE
);

-- Language
CREATE TABLE IF NOT EXISTS SysLanguage (
    LanguageId SMALLSERIAL PRIMARY KEY,
    Shortname CHAR(3) NOT NULL,
    Name VARCHAR(255) NOT NULL,
    IsEnable BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE IF NOT EXISTS LegalNotices (
    LegalNoticesId SMALLSERIAL PRIMARY KEY,
    StartDate DATE NOT NULL UNIQUE,
    MarkdownValue TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS PrivacyPolicy (
    PrivacyPolicyId SMALLSERIAL PRIMARY KEY,
    StartDate DATE NOT NULL UNIQUE,
    MarkdownValue TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS NotificationProvider (
    NotificationProviderId SMALLSERIAL PRIMARY KEY,
    NotificationType INTEGER NOT NULL, -- 0 = pdfgeneration
    Name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS NotificationCenter (
    NotificationCenterId SERIAL PRIMARY KEY,
    NotificationType INTEGER NOT NULL, -- 0 = pdfgeneration
    RowId INTEGER NOT NULL,
    LanguageId INTEGER NOT NULL,
    "status" VARCHAR(1024) NULL,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    SendAt TIMESTAMPTZ NULL
);

CREATE TABLE sqlpage_files(
  path VARCHAR(255) NOT NULL PRIMARY KEY,
  contents BYTEA,
  last_modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE MimeType(
    MimeTypeId SERIAL PRIMARY KEY,
    MimeType VARCHAR(255)
)
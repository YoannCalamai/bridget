CREATE TABLE IF NOT EXISTS CoreUser (
    UserId SERIAL PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Firstname VARCHAR(255) NOT NULL,
    Lastname VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    SecurityProfileId INTEGER NOT NULL DEFAULT 1,
    GroupId INTEGER NOT NULL DEFAULT 1,
    LanguageId INTEGER NOT NULL DEFAULT 1,
    IsActive BOOLEAN NOT NULL DEFAULT true,
    CreatedBy INTEGER NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    UpdatedBy INTEGER NOT NULL,
    UpdatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    PasswordLastUpdateAt TIMESTAMPTZ,
    FOREIGN KEY (LanguageId) REFERENCES SysLanguage (LanguageId),
    FOREIGN KEY (CreatedBy) REFERENCES CoreUser (UserId),
    FOREIGN KEY (UpdatedBy) REFERENCES CoreUser (UserId)
);

CREATE TABLE IF NOT EXISTS CoreGroup (
    GroupId SMALLSERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    ParentGroupId INTEGER NOT NULL DEFAULT 1,
    IsActive BOOLEAN NOT NULL DEFAULT true,
    CreatedBy INTEGER NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    UpdatedBy INTEGER NOT NULL,
    UpdatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY (ParentGroupId) REFERENCES CoreGroup (GroupId),
    FOREIGN KEY (CreatedBy) REFERENCES CoreUser (UserId),
    FOREIGN KEY (UpdatedBy) REFERENCES CoreUser (UserId)
);

CREATE TABLE IF NOT EXISTS CoreSecurityProfile (
    SecurityProfileId SMALLSERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Description VARCHAR(1024) NULL,
    IsAdmin BOOLEAN NOT NULL DEFAULT false,
    CreatedBy INTEGER NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    UpdatedBy INTEGER NOT NULL,
    UpdatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY (CreatedBy) REFERENCES CoreUser (UserId),
    FOREIGN KEY (UpdatedBy) REFERENCES CoreUser (UserId)
);

CREATE TABLE IF NOT EXISTS CoreSecurityProfileItem (
    SecurityProfileItemId SERIAL PRIMARY KEY,
    SecurityProfileId INTEGER NOT NULL,
    Name VARCHAR(255) NOT NULL,
    SystemName VARCHAR(255) NOT NULL,
    DbItemId INTEGER NOT NULL DEFAULT -1,
    CanRead BOOLEAN NOT NULL DEFAULT false,
    CanWrite BOOLEAN NOT NULL DEFAULT false,
    CanCreate BOOLEAN NOT NULL DEFAULT false,
    CanDelete BOOLEAN NOT NULL DEFAULT false,
    /*CanList BOOLEAN NOT NULL DEFAULT false,
    ForMe BOOLEAN NOT NULL DEFAULT false,
    ForMyTeam BOOLEAN NOT NULL DEFAULT false,
    ForAll BOOLEAN NOT NULL DEFAULT false,*/
    CreatedBy INTEGER NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    UpdatedBy INTEGER NOT NULL,
    UpdatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY (SecurityProfileId) REFERENCES CoreSecurityProfile (SecurityProfileId),
    FOREIGN KEY (CreatedBy) REFERENCES CoreUser (UserId),
    FOREIGN KEY (UpdatedBy) REFERENCES CoreUser (UserId)
);

CREATE TABLE IF NOT EXISTS CoreUserSession (
    UserSessionId SERIAL PRIMARY KEY,
    UserId INTEGER NOT NULL,
    Session TEXT NOT NULL,
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);

CREATE TABLE IF NOT EXISTS ForgotPwdToken (
    ForgotPwdTokenId SERIAL PRIMARY KEY,
    UserId INTEGER UNIQUE NOT NULL,
    Token  CHAR(32) NOT NULL, -- select substr(md5(random()::text), 0, 32);
    CreatedAt TIMESTAMPTZ NOT NULL DEFAULT current_timestamp
);

CREATE OR REPLACE VIEW GetUserFromSession AS
SELECT U.UserId,
        Username,
        Firstname,
        Lastname,
        Email,
        U.SecurityProfileId,
        S.IsAdmin,
        U.IsActive,
        Session,
        PasswordLastUpdateAt,
        LanguageId
FROM CoreUser as U
JOIN CoreUserSession as Us ON U.UserId = Us.UserId
JOIN CoreSecurityProfile as S ON U.SecurityProfileId = S.SecurityProfileId;


CREATE TABLE FileLog(
    FileLogId SERIAL PRIMARY KEY,
    Message VARCHAR(255),
    UserId INTEGER UNIQUE NOT NULL,
    ActionDate TIMESTAMPTZ NOT NULL DEFAULT current_timestamp,
    FOREIGN KEY (UserId) REFERENCES CoreUser (UserId)
)
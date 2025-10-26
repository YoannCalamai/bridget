SELECT 'redirect' AS component,
        '/' AS link
FROM AppSettings
WHERE AppSettingId=7
AND Value='0';

-- delete timed out token
delete from forgotpwdtoken where EXTRACT(EPOCH FROM age(current_timestamp, CreatedAt))>600;

-- insert token for user if not exists
INSERT INTO ForgotPwdToken (UserId, Token)
SELECT UserId,
       substr(md5(random()::text), 0, 32)
FROM "user"
WHERE Email = :email
AND UserId NOT IN (SELECT UserId FROM ForgotPwdToken);

-- insert notification for user if no valid token exists
INSERT INTO NotificationCenter (NotificationType, RowId, CreatedAt)
SELECT 0, 
	ForgotPwdTokenId,
       ForgotPwdToken.CreatedAt
FROM ForgotPwdToken
JOIN "user" on ForgotPwdToken.UserId="user".UserID
WHERE Email = :email
AND NOT EXISTS (SELECT NotificationCenterId 
                FROM NotificationCenter 
                WHERE NotificationCenter.RowId=ForgotPwdToken.ForgotPwdTokenId
                AND NotificationType=0);
       

SELECT 'redirect' AS component, '/ForgotPassword.sql?success' AS link;

IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\BGWEBCLUSTER1$')
CREATE LOGIN [POWERPLAY\BGWEBCLUSTER1$] FROM WINDOWS
GO
CREATE USER [POWERPLAY\BGWEBCLUSTER1$] FOR LOGIN [POWERPLAY\BGWEBCLUSTER1$] WITH DEFAULT_SCHEMA=[POWERPLAY\BGWEBCLUSTER1$]
GO
REVOKE CONNECT TO [POWERPLAY\BGWEBCLUSTER1$]
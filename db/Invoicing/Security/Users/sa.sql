IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\tcvault')
CREATE LOGIN [POWERPLAY\tcvault] FROM WINDOWS
GO
CREATE USER [sa] FOR LOGIN [POWERPLAY\tcvault]
GO

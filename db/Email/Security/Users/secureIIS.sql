IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\secureIIS')
CREATE LOGIN [POWERPLAY\secureIIS] FROM WINDOWS
GO
CREATE USER [secureIIS] FOR LOGIN [POWERPLAY\secureIIS]
GO

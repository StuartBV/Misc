IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\SQLIISAccounts')
CREATE LOGIN [POWERPLAY\SQLIISAccounts] FROM WINDOWS
GO
CREATE USER [SQLIISAccounts] FOR LOGIN [POWERPLAY\SQLIISAccounts]
GO

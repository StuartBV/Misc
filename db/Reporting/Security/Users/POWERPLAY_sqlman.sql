IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\sqlman')
CREATE LOGIN [POWERPLAY\sqlman] FROM WINDOWS
GO
CREATE USER [POWERPLAY\sqlman] FOR LOGIN [POWERPLAY\sqlman]
GO
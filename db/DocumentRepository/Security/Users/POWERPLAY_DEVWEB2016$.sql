IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'POWERPLAY\DEVWEB2016$')
CREATE LOGIN [POWERPLAY\DEVWEB2016$] FROM WINDOWS
GO
CREATE USER [POWERPLAY\DEVWEB2016$] FOR LOGIN [POWERPLAY\DEVWEB2016$]
GO

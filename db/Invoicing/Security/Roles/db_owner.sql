
EXEC sp_addrolemember N'db_owner', N'POWERPLAY\BGWEBCLUSTER1$'

EXEC sp_addrolemember N'db_owner', N'POWERPLAY\BGWEBCLUSTER2$'
EXEC sp_addrolemember N'db_owner', N'IT Development'
GO
EXEC sp_addrolemember N'db_owner', N'powerplay'
GO
EXEC sp_addrolemember N'db_owner', N'powerplay\b001.davis'
GO
EXEC sp_addrolemember N'db_owner', N'POWERPLAY\IT-Dev-Devices'
GO
EXEC sp_addrolemember N'db_owner', N'powerplay\octopus'
GO
EXEC sp_addrolemember N'db_owner', N'secureIIS'
GO

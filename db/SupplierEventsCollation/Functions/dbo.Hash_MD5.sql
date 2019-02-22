SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[Hash_MD5] (@data TEXT) 
returns char(32) as
begin

  declare @hash char(32)
  exec master.dbo.xp_md5 @data, -1, @hash OUTPUT
  return @hash
  
end
GO

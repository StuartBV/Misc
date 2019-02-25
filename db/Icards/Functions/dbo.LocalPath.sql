SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[LocalPath] ()
returns varchar(50)
as 
begin
 return (select code from ppd3.dbo.sysLookup where tablename='localpath' and ExtraCode=ppd3.dbo.ServerName())
end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[NH_Syslookup](@tablename varchar(50))
RETURNS table
as
return (
	select Id, Tablename, Code, Description, Flags, ExtraCode
	from syslookup where tablename like @tablename
	)
GO

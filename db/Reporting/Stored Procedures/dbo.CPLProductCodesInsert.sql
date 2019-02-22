SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[CPLProductCodesInsert]
	@cpltable CPLProductCodesTable readonly
AS
BEGIN
	insert into CPLProductCodesImport 
	select * from @cpltable
end
GO

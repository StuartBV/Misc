SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[ExportCopyPath] ()
returns varchar(50)
as  
begin
 return ppd3.dbo.ExportCopyPath()
end

GO

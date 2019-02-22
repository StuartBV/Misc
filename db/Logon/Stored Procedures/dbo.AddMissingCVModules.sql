SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Paul Young
-- Create date: 24/5/2013
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[AddMissingCVModules] 
	@ClientId int = null,
	@UserId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	insert dbo.syslookup
        ( TableName ,
          Code ,
          Description ,
          Flags ,
          ExtraCode ,
          ExtraDesc ,
          CreateDate ,
          CreatedBy
        )
	SELECT 'CVModulesAccess', CID, c.Name, 0, m.Code, m.Description, getdate(), @UserId 
	FROM dbo.syslookup m 
	cross join dbo.Clients c
	left join dbo.syslookup a on m.Code=a.ExtraCode and a.Code = c.CID and a.TableName='CVModulesAccess'
	where m.TableName='CVModules'
	and a.Code is null
	and c.CID = @ClientId or @ClientId is null
	order by c.CID, m.Code
END
GO

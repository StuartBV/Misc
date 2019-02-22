SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[GetlargeDropDownOptions]
@param VARCHAR(100)
as

SET NOCOUNT ON

SELECT '"'+code+'":"'+left(description,36)	+'"' as [option]
FROM syslookup
WHERE TableName=@param

GO

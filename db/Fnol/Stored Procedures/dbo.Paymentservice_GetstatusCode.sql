SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Paymentservice_GetstatusCode]
@code varchar(10)
as

SET NOCOUNT ON

SELECT flags 
FROM dbo.syslookup 
where TableName = 'fnol - paycode'
and code=@code 


GO

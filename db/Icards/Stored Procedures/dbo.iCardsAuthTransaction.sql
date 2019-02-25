SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[iCardsAuthTransaction]
@transID int=0,
@userid varchar(20)

AS

set nocount on

update dbo.PolicyDetails 
	set authby=@userid, 
	authdate=getdate(),
	status=case when companyID=2 then 1 else status end
where TransactionID=@transID 


GO

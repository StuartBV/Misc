SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[iCardsSetStatus] 
@iCardsID varchar (10),
@status int,
@userid varchar(20)

AS

set nocount on

update p set status=@status, altereddate=getdate(), alteredby=@userid
from policies p
join card_companies cc on cc.ID=.p.companyID
where p.iCardsID = right(@iCardsID,len(@iCardsID)-(len(cc.ClaimNoPrefix)))
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocumentScanInsert]
@iCardsID varchar(20),
@InitialFax tinyint=0,
@OtherInfo tinyint=0,
@userid UserID
as
set nocount on

insert into DocumentScans (iCardsID, InitialFax, OtherInfo, CreateDate, CreatedBy)
select right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1)), @InitialFax, @OtherInfo, getdate(), @userid
from policies p join card_companies cc on cc.ID=p.companyID
where p.iCardsID=right(@iCardsID,len(@iCardsID)-(len(cc.insuranceco)+1))
GO

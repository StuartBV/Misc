SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CPL_ClaimEvents_Create]
@claimID int

as

set nocount on

insert into ppd3.dbo.ClaimEvents (claimID,[Type],actioneddate,actionedby,SupplierID,CreatedBy,data)
select distinct
p.IValRef ClaimID,665 [Type],getdate(),'sys',6500 SupplierID, 'iCards_SendInvoices' CreatedBy,	-- Type: Event 665, making use of non-validated supplier event, Options Cards is a special case
cast(t.[id] as varchar)--cast(p.ivalref as varchar)+'/10000101/OC' + cast(t.[id] as varchar)
from policies p
join cards c on c.customerID=p.customerID
join transactions t on t.cardID=c.[ID]
where p.iValRef=@claimID
GO

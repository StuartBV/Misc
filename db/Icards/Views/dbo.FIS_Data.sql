SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[FIS_Data]
AS
select  t.[Type],
		cd.Pan,
		P.ICardsID,
		cast(cd.SupplierCardId as varchar(40)) CardId,
		cast(t.CardValue * case when t.CardValue<0 then -1 else 1 end as varchar(20)) Amount,
		case when CardValue>0 then '1' else '0' end as AmountType,
		cast(t.ID as varchar) as RecId,
		case when t.CardValue<0 then 'Debit' else 'Credit' end 
		+ ' ' + cast(t.CardValue * case when t.CardValue<0 then -1 else 1 end as varchar(20))
		+ ' GBP to card' as TranDesc,
		sl.ExtraCode as [Action],
		cast(cu.ID as varchar) as ParticipantId,
		'FIS'+cast(cu.ID as varchar) as AccountNo,
		dbo.XML_Escape(cu.Title) as Title,
		dbo.XML_Escape(cu.LastName)  as LastName,
		dbo.XML_Escape(cu.FirstName) as FirstName,
		dbo.XML_Escape(cu.Address1) as Address1,
		dbo.XML_Escape(cu.Town) as City,
		dbo.XML_Escape(cu.Postcode) as Postcode,
		dbo.XML_Escape(cu.Phone) as Tel,
		dbo.XML_Escape(cd.NameOnCard) as CardName,
		isnull(CU.DateOfBirth,'') as DateOfBirth,
		t.ID TransActionId,
		t.InvoiceBatchNo,
		p.InsurancePolicyNo,
		cd.carriercode
from Transactions t
join cards cd on cd.id = t.CardID
join customers cu on cu.id= cd.CustomerId
join policies p on p.iCardsID=cu.iCardsID
join syslookup sl on sl.TableName='FISActionCodeMapping' and sl.code=t.[Type]
where p.CompanyID=2 
and t.[Status]=1
and (t.AuthRequirement=0 or (t.authrequirement>0 and authdate is not null))
and (
	t.[Type] ='M'
	or (t.[type] in ('C','R','Z') )
	or (t.[Type]='B' and (t.CardValue>0 or t.CardValue<0)) 
	)
and (
	(t.InvoicedDate is null and t.BatchFileUploaded is null)
	or 
	(t.CreatedBy='sys.reissue')
	)

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Fis_ListUploadExceptions] as
set dateformat dmy

select p.iCardsID,p.NameOnCard,p.CardValue,convert(varchar(12),p.batchfileuploaded,113) dateUploaded,
fe.ErrorMessage,p.policy_AlteredBy [alteredby],coalesce (e.FName + ' ' + e.SName, 'Administrator') as empname,
convert(char(8), p.policy_AlteredDate, 8) as [time], p.policy_status [Status]
from dbo.PolicyDetails p join dbo.FisExceptions fe on p.CardID = fe.CardID and fe.RECID=p.TransactionID and fe.Actioned=0
left outer join PPD3.dbo.Logon as l on p.policy_AlteredBy = l.UserID 
left outer join PPD3.dbo.employees as e on e.Id = l.UserFK
where p.companyID=2

GO

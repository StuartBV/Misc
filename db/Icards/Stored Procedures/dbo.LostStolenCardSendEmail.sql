SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LostStolenCardSendEmail] 
@cardID int
as
set transaction isolation level read uncommitted
declare @cr char(1), @linesep varchar(60), @subject varchar(100), @body varchar(8000)

select 
@cr=char(13), @linesep='------------------------------------------------------------',
@subject='Options Card ' + cc.ClaimNoPrefix + cast(p.ICardsID as varchar) + ' Reported ' + 
case when l.type=1 then 'Lost' else case when l.type=2 then 'Stolen' else '' end end + ' : '+ cast(convert(char(10),getdate(),103) as varchar),
@body='
Options Ref: ' + cc.ClaimNoPrefix + cast(p.ICardsID as varchar) + '
iVal Ref: ' + isnull(cast(p.iValRef as varchar),'') + '	
Account Ref: ' + isnull(p.SePSCode,'') + '
Insurance Company: ' + isnull(i.name,'') + '
Originating Office: ' + isnull(p.origoffice,'') + '
Claim Number: ' + isnull(p.InsuranceClaimNO,'') + '
Policy Number: ' + isnull(p.InsurancePolicyNo,'') + @cr + @cr + @linesep + '

Type: ' + case when l.type=1 then 'LOST' else case when l.type=2 then 'STOLEN' else '' end end + '
Date Lost/Stolen: ' + cast(convert(char(10),l.[date],103) as varchar) + '
Crime Reference Number: ' + isnull(case when l.crimeref='' then 'Not Supplied' else l.crimeref end,'Not Supplied') + '
Last Transaction Date: ' + cast(convert(char(10),l.LastTranDate,103) as varchar) + ' ' + convert(char(5),l.LastTranDate,14) +'
Retailer of last transaction: ' + isnull(l.LastTranRetailer,'') + '
TSYS ID of last transaction: ' + isnull(cast(l.TSYSID as varchar),'') + '
Card used after last transaction: ' + case when l.UsedAfterLastTran=1 then 'YES' else 'NO' end + '
Additional Information: ' + isnull(l.AdditionalInfo,'')
from LostStolenCards l
left join cards cd on cd.[ID]=l.cardID
left join customers cu on cu.[ID]=cd.customerID
left join policies p on p.customerID=cu.[ID]
left join card_companies cc on cc.[ID] = p.CompanyID
left join ppd3.dbo.insurancecos i on i.ID=p.insurancecoID
where l.cardID=@CardID

GO

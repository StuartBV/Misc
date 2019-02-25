SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[DisputeTranSendEmail] 
@CardID int
AS
set transaction isolation level read uncommitted

DECLARE @cr char(1), @linesep varchar(60), @subject varchar(100), @body varchar(8000)

SELECT 
@cr=char(13), @linesep='------------------------------------------------------------',
@subject='Options Card ' + cc.ClaimNoPrefix + CAST(p.ICardsID AS varchar) + ' : Disputed Transaction Reported : '+ cast(convert(char(10),getdate(),103) AS varchar),
@body='
Options Ref: ' + cc.ClaimNoPrefix + CAST(p.ICardsID AS varchar) + '
iVal Ref: ' + isnull(p.iValRef,'') + '	
Account Ref: ' + isnull(p.SePSCode,'') + '
Insurance Company: ' + isnull(i.name,'') + '
Originating Office: ' + isnull(p.origoffice,'') + '
Claim Number: ' + isnull(p.InsuranceClaimNO,'') + '
Policy Number: ' + isnull(p.InsurancePolicyNo,'') + @cr + @cr + @linesep + '

TSYS TRANSACTION ID: ' + isnull(cast(d.TSYSid as varchar),'') + '
Date of Transaction: ' + cast(convert(char(10),d.trandate,103) as varchar) + ' ' + convert(char(5),d.trandate,14) + '
Retailer: ' + isnull(d.TranRetailer,'') + '
Reason for Dispute: ' + isnull(sys.description,'') + '
Is the card in the possession of the card holder: ' + case when d.possession=1 then 'YES' else 'NO' end + '
Does anyone else have access to the card: ' + case when d.access=1 then 'YES
Who also has access to the card: ' + isnull(d.AlsoAccess,'') else 'NO' end + '
Additional Information: ' + isnull(d.AdditionalInfo,'')
FROM DisputedTransactions d
left join cards cd on cd.[ID]=d.cardID
left join customers cu on cu.[ID]=cd.customerID
left join policies p on p.customerID=cu.[ID]
left join card_companies cc on cc.[ID] = p.CompanyID
left join ppd3.dbo.insurancecos i on i.ID=p.insurancecoID
left join syslookup sys on sys.code=d.reason and sys.tablename='DisputeReason'
where d.cardID=@CardID
/*
exec ppd3.dbo.SendMail 'howard.holmes@aviva.com','options@ival.co.uk','iVal Options',
@subject, 
@body, -- BODY
'', -- ATTACH
'disputedtransactions@ival.co.uk' -- BCC
*/
set transaction isolation level read committed

GO

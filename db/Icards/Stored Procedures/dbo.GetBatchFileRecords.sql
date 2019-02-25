SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetBatchFileRecords] 
@cardtype int
as
/*
!!!!!! iVal Jewellery card type in syslookup must be code 4 !!!!!!!!
<SP>
	<Name>GetBatchFileRecords</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060508</CreateDate>
	<Referenced>
		<asp>Page name</asp>
	</Referenced>
	<Overview>Used to create output rows that form basis of TSYS batch file</Overview>
	<Changes>
		<Change>
			<User>Stu</User>
			<Date>20060517</Date>
			<Comment>renamed @cr to @tab as more meaningful</Comment>
		</Change>
		<Change>
			<User>Derek</User>
			<Date>20060518</Date>
			<Comment>amended cardtype to int and removed join to syslookup</Comment>
		</Change>
		<Change>
			<User>Derek</User>
			<Date>20060608</Date>
			<Comment>added extra recordset to display if errors occur when uploaded so that individual lines can be updated with error</Comment>
		</Change>
	</Changes>
</SP>
*/
declare @tab char(1)

set nocount on

set @tab=char(9)

update t set t.status=1
from transactions t
join Cards c on c.id=t.cardid
JOIN policies p ON p.customerid=c.customerid
where c.cardtype=@cardtype AND p.wizardstage=4
and t.status=0 AND (t.authrequirement=0 or (t.authrequirement>0 and t.authdate is not null))


-- this select statement gets records for inclusion in the batch file
select 
isnull(t.type,'')+@tab+
cc.claimnoprefix+cast(p.icardsid as varchar)+@tab+
''+@tab+
cast(t.cardvalue as varchar)+@tab+
isnull('Load  - '+s.description,'')+@tab+
case when @cardtype=5 then 'FALSE' else 'TRUE' END +@tab+
isnull(cu.title,'')+@tab+
isnull(cu.firstname,'')+@tab+
''+@tab+
isnull(cu.lastname,'')+@tab+
isnull(cu.address1,'')+@tab+
isnull(cu.address2,'')+@tab+
isnull(cu.town,'')+@tab+
case when cu.county ='' then ',' else isnull(cu.county,',') end+@tab+
isnull(cu.postcode,'')+@tab+
'United Kingdom'+@tab+
''+@tab+
''+@tab+
''+@tab+
'Policy Id'+@tab+
cast(p.insurancepolicyno as varchar)+@tab+
--cc.claimnoprefix+cast(p.icardsid as varchar)+@tab+
''+@tab+
isnull(cu.phone,'')+@tab+
''+@tab+ -- MailerText
cd.nameoncard+@tab+ -- Card Name
case when @cardtype = 4 then 'JEWELLERY' 
	else case when ops.code is null then '' else ops.ExtraCode end
end+@tab+ -- Card Name 2
case when t.type in ('A','M') then 'TRUE' else 'FALSE' end as 'carddata'
from card_companies cc left join policies p on cc.[id] = p.companyid
left join customers cu on cu.icardsid = p.icardsid
left join cards cd on cd.customerid = cu.[id]
left join transactions t on t.cardid = cd.[id]
left join syslookup s on s.code = t.type and s.tablename = 'cardactiontype'
left join transactionsuppliers ts on ts.transactionid=t.id
left join syslookup ops on ops.code = ts.supplierid and ops.tablename = 'OptionsCardRestrictedSupplier'
where t.status=1 AND p.cancelreason IS NULL AND p.wizardstage=4
and cd.cardtype = @cardtype AND (t.authrequirement=0 or (t.authrequirement>0 and t.authdate is not null))
order by t.id


-- this select statement gets records for on screen list for displaying when the batch file errors
select 
cv.id transid,
isnull(cv.type,'') type,
cc.claimnoprefix+cast(p.icardsid as varchar) iCardsID
from card_companies cc left join policies p on cc.[id] = p.companyid
left join customers cu on cu.icardsid = p.icardsid
left join cards cd on cd.customerid = cu.[id]
left join transactions cv on cv.cardid = cd.[id]
where cv.status=1
and cd.cardtype = @cardtype AND p.cancelreason IS NULL AND p.wizardstage=4
and (cv.authrequirement=0 or (cv.authrequirement>0 and cv.authdate is not null))
order by cv.id
GO

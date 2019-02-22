SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetClaimDetails]
@claimID int
as
--UTC--
set nocount on
set transaction isolation level read uncommitted
declare @tier smallint, @application varchar(50), @dt datetime=getdate()

select @tier=currenttier,@application=originatingsys from fraud where claimid=@claimID

select f.fin,f.claimid,f.currenttier,f.bookingid,f.[status],isnull(s.[description],'tba') risk, s2.[description] frauddesc,c.claimno,@application [application]
from fraud f  join claims c  on f.claimid=c.claimid
left join syslookup s  on f.risk=s.code and s.tablename='risk'
join syslookup s2  on f.[status]=s2.code and s2.tablename='fraudstatus'
where f.claimid=@claimID

--get customer details
select cu.[ID], cu.Title, cu.Fname, cu.Lname, cu.Address1, cu.Address2, cu.Town,
cu.County,cu.Postcode,cu.Country,cu.Hphone,cu.Wphone,cu.Mphone,cu.Fax,case when cu.Email='NOTKNOWN' then '' else cu.email end Email,
cu.Otherinfo, 
coalesce(case when isnull(cu.hphone,'')='' then null else cu.hphone end, case when isnull(cu.mphone,'')='' then null else cu.mphone end, case when isnull(cu.wphone,'')='' then null else cu.wphone end,'') FirstContact,
businessname, cu.secondname,cu.secondphone,
c.commercial, c.channel
from Claims c  
left join Customers cu  on c.custid=cu.[id]
where c.claimID=@claimID

--get claim details
select 	C.custid,c.Channel,C.[status],C.CreatedBy as ccb,c.sepscode,
	convert(char(12), C.CreateDate, 13)+', '+convert(char(5),C.CreateDate,14) as ccd,
	coalesce (E.FName + ' ' + E.SName, 'Administrator') EmpName,
	coalesce (E2.FName + ' '+ E2.SName,'Administrator') EmpAlteredBy,
	convert(char(12),
	C.OrderConfirmedDate, 13)+', '+convert(char(5),C.OrderConfirmedDate,14) as OrderConfirmedDate,
	(
		select e.fname+' '+e.sname 
		from ppd3.dbo.employees e 
		join ppd3.dbo.logon l  on l.userFK=e.[id] 
		join claims C  on l.userID=C.OrderConfirmedBy where c.claimID=@claimID
	)ConfirmedBy,
	C.InsuranceCoID,C.InsurancePolicyNo,C.InsuranceClaimNo,C.AccountRef,C.LossAdjusterID,C.LossAdjusterRef,
	C.LAOffice,IC.[Name] InsCoName,IC.RRPVoucher,LA.[Name] LossAdjName,C.OriginatingOffice,'N/A' as Cas,
	C.Inspector,C.InspectorEmail,C.QuoteFaxNum,
	C.Delegated,case when C.ContactByPhone=1 then 'by Phone' else 'by Letter' end contactmethod,c.CauseOfClaim,
	convert(char(12),C.FirstContactDate,13) + ', '+convert(char(5),C.FirstContactDate,8) FirstContactDate,
	convert(char(12),C.QuoteCreatedDate,13) QCD,
	convert(char(12),C.OrderCreatedDate,13)+', '+convert(char(5),C.OrderCreatedDate,14) OCD,
	convert(char(12),c.CompletedDate,13)+', '+convert(char(5),C.CompletedDate,14)CompletedDate,
		isnull(C.Excess,0) Excess,coalesce(IC.DelegatedValue,LA.DelegatedValue,0) DelegatedValue,
	convert(char(12),C.DateListReceived,13)+', '+convert(char(5),C.DateListReceived,14) DateListReceived,
	C.ExcessToCollect,C.Pending,
	convert(char(12),o.lastphoneattempt,13)lpa,convert(char(12),
	ConsignmentReadyLetter,13)crl,case when O.ReActivationDateUTC is null then
        	case when convert(char(8),cast(O.ActivationDateUTC as datetime)+O.FirstBSD,3)=convert(char(8),@dt,3) then
          		'Today'
        	else
          		convert(char(8),cast(O.ActivationDateUTC as datetime)+O.FirstBSD,3)
        	end
	else
		case when convert(char(8),cast(O.ReActivationDateUTC as datetime)+O.FinalBSD,3)=convert(char(8),@dt,3) then
          		'Today'
        	else
          		convert(char(8),cast(O.ReActivationDateUTC as datetime)+O.FinalBSD,3)
        	end
	end BSD,
	case when O.ReActivationDateUTC is null then
 		datediff(d,@dt,cast(O.ActivationDateUTC as datetime)+O.FirstBSD)
	else
  		datediff(d,@dt,cast(O.ReActivationDateUTC as datetime)+O.FinalBSD)
	end DaysLeft,
	isnull(convert(char(12),o.ActivationDateUTC,13)+', '+convert(char(5),o.ActivationDateUTC,14),'Not Activated') ad,
	convert(char(12),o.reActivationDateUTC,13)+', '+convert(char(5),o.reActivationDateUTC,14)rad,
	o.CRLetterCount,o.[status] orderstatus, 
	isnull(convert(varchar(12),IncidentDate,13),
		case when c.createdate <'20060426' then 'Property not available' else 'Not entered' end) IncidentDate,
	isnull(convert(varchar(12),ClaimReceivedDate,13) + ' ' + convert(varchar(5),ClaimReceiveddate,14),
		case when c.createdate <'20060426' then 'Property not available' else 'Not entered' end) ClaimReceivedDate,
	ppd3.dbo.currencysymbol(@claimID) CurrencySymbol, c.claimtype
	,isnull(cp.amount_claimed,0) amount_claimed,isnull(cp.initial_reserve,0) initial_reserve,isnull(cp.sum_insured,0) sum_insured,
	isnull(cp.limits,'') limits,isnull(cp.saving,0) saving,
	case when isnull(cp.lastclaimed_months,0)=0 then 'Never' else cast(cp.lastclaimed_months as varchar)+' (months)' end lastclaimed_months,
	case when cp.policyinceptiondate is null then 'Not Entered' else convert(varchar(12),cp.policyinceptiondate,13) end policyinceptiondate,
	case when previousclaim=1 then 'Yes' else 'No' end as previousclaim,
	case when previousrepair=1 then 'Yes' else 'No' end as previousrepair,
	case when f.[status]=9 then '' else '&nbsp;&nbsp;&nbsp;(<a href="javascript:ClaimDetailsUpdate();">Edit</a>)' end lbledit, f.[status] as fraudstatus,
	cp.policestation,cp.policephone,cp.crimerefno,convert(varchar(12),cp.datereported,13) datereported, cp.fraudindicator
from
	claims c join fraud f on f.claimid=c.claimid
	left join claimproperties cp on cp.claimid=c.claimid
	left join ppd3.dbo.Logon L on L.UserID = C.CreatedBy
	left join ppd3.dbo.Employees E on E.[Id] = L.UserFK
	left join ppd3.dbo.Logon L2 on L2.UserID = C.AlteredBy
	left join ppd3.dbo.Employees E2 on E2.[Id] = L2.UserFK
	left join ppd3.dbo.InsuranceCos_Eastbourne IC  on C.InsuranceCoID=IC.[ID]
	left join ppd3.dbo.LossAdjusters LA on C.LossAdjusterID=LA.[ID]
	left join ppd3.dbo.orders o on o.claimID=C.ClaimID
where c.ClaimID=@claimID

--get claim items information
--joined onto fraud table to achieve dummy row in the event that there are no items
select f.claimid,isnull(c.catid,'') catid, isnull(c.make,'') make, isnull(c.model,'') model, isnull(c.[description],'') [description], isnull(c.age,0) age,
isnull(c.value,0) value, isnull(c.Instruction,'') instruction, isnull(c.limit,0) limit, isnull(c.specificvalue,0) specificvalue, isnull(c.createdby,'') createdby,
isnull(c.createdate,'') createddate, isnull(c.alteredby,'') alteredby, isnull(c.altereddate,'') altereddate, isnull(c.deleted,0) deleted
from ClaimProducts c right join fraud f on c.claimid=f.claimid
where f.ClaimID=@claimID

--get claim notes information
exec GetClaimNotes @claimID=@ClaimID,@application=@application

--get list of reasons for not being able to contact customer to be used during screening process
exec List_Syslookup 'reason',3

--get list of decisions to be used at end of screening process
select 1 seq,'All' code,'Select:' [description],0 flags
union all
select 2 seq,code,[description],flags
from syslookup
where tablename='decision'
and (@tier=extracode or @tier=extradescription)
order by seq,flags

--get list of reasons for closing a claim - to be used at end of screening process
select 1 seq,'All' code,'Select:' [description],0 flags
union all
select 2 seq,code,[description],flags
from syslookup
where tablename='closereason'
order by seq,flags


GO

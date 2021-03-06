SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GetDiaryEvents]
@start varchar(50),
@end varchar(50),
@UserID UserID='',
@team varchar(50)='',
@bookingID int=null
as
set nocount on
set transaction isolation level read uncommitted

select @start=cast(@start as datetime) + '00:00', @end=cast(@end as datetime) + '23:59:59'

select b.BookingID,f.ClaimID,b.startdate,b.enddate,left(e.FName,1)+left(e.SName,1) NAME,
	case when b.contactmade is null then
	'Interview booked for: '+b.bookedfor+'<br>'+
	'FIN: '+f.FIN+'<br>Claim: '+cl.ClaimNo+'<br>'+
	'Contact is: '+b.Contactname+'<br>on phone no: '+b.Contactno+' at '+b.Contactplace+
	'<br>Cause of Claim: '+coalesce(s5.[description],cl.CauseofClaim,'') 
	when b.contactmade=0 then
	cast(b.contactattempts as varchar)+' attempt(s) made<br>to contact Customer'
	when f.dateclosed is not null then
	'FIN: '+f.FIN+'<br>Claim: '+cl.ClaimNo+'<br>'+
	'Interview conducted on: '+isnull(convert(varchar(12),coalesce(f.Tier3InterviewStarted,f.Tier2InterviewStarted),13),'')+'<br>'+
	'Outcome was: '+isnull(s2.[description],'')+
	'<br>Cause of Claim: '+coalesce(s5.[description],cl.CauseofClaim,'')
	when f.dateclosed is null and b.ContactMade=1 and f.[status]=3 then
	'FIN: '+f.FIN+'<br>Claim: '+cl.ClaimNo+'<br>'+
	'<br>Cause of Claim: '+coalesce(s5.[description],cl.CauseofClaim)+'<br>'+
	'Interview conducted on: '+isnull(convert(varchar(12),coalesce(f.Tier3InterviewStarted,f.Tier2InterviewStarted),13),'')+'<br>'+
	'!!Interview was not completed!!'
	when f.dateclosed is null and b.ContactMade=1 and f.[status]=1 then
	'FIN: '+f.FIN+'<br>Claim: '+cl.ClaimNo+'<br>'+
	'Interview conducted on: '+isnull(convert(varchar(12),coalesce(f.Tier3InterviewStarted,f.Tier2InterviewStarted),13),'')+
	'<br>Cause of Claim: '+coalesce(s5.[description],cl.CauseofClaim,'')
	else
	'FIN: '+f.FIN+'<br>Claim: '+cl.ClaimNo+
	'<br>Cause of Claim: '+coalesce(s5.[description],cl.CauseofClaim,'')
	end eventtext,
	case when b.contactmade is null then 0 
	when b.contactmade=0 then 1
	else 2 end [status],
	l.userid as [resource], s3.code statuscode, s3.[description] statusdesc
from Bookings b
left join Fraud f on b.fin=f.fin	 
left join claims cl on f.claimid=cl.claimid
left join ppd3.dbo.logon l on l.userid=b.bookedfor
left join ppd3.dbo.employees e on e.id=l.userfk
left join sysLookup s on s.code=b.nocontactreason and s.tablename='Reason'
left join sysLookup s2 on s2.code=f.reasonclosed and s2.tablename='Decision'
left join sysLookup s3 on s3.code=b.[type] and s3.tablename='eventtype'
left join users r on r.UserID=b.BookedFor
left join syslookup s4 on s4.code=r.team and s4.tablename='team'
left join ppd3.dbo.sysLookup s5 on s5.code=cl.CauseofClaim and s5.tablename='fnol - cause'
where b.startdate between @start and @end and b.deleteddate is null
and b.bookedfor=case when @UserID='' then b.bookedfor else @UserID end
and b.BookingID=case when @bookingID is null then b.BookingID else @bookingID end
and s4.[description]=case when @team='' then s4.[description] else @team end
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[AddScreeningNotesToClaim]
@claimid int,
@userid UserID
as
declare @cr varchar(1)=char(10),@screenedby varchar(100),@screeningtext varchar(max)

select @screenedby=e.FName+' '+e.SName
from ppd3.dbo.logon l join ppd3.dbo.employees e on l.UserFK=e.Id
where l.userid=@userid

select @screeningtext=
'SCREENING PROCESS'
+@cr
+'--------------------------' 
+@cr+@cr
+'Interview conducted by: '+@screenedby
+@cr+
+'Review started at: '+convert(varchar(12),coalesce(f.Tier3ReviewStarted,f.Tier2ReviewStarted),108)
+@cr+
+'Review finished at: '+convert(varchar(12),coalesce(f.Tier3ReviewEnded,f.Tier2ReviewEnded),108)
+@cr
+case	when coalesce(f.Tier3InterviewStarted,f.Tier2InterviewStarted) is not null then 'Interview started at: '+convert(varchar(12),coalesce(f.Tier3InterviewStarted,f.Tier2InterviewStarted),108)+@cr+'Interview finished at: '+convert(varchar(12),coalesce(f.Tier3InterviewEnded,f.Tier2InterviewEnded),108)
		else 'Interview could not take place because '+s.[Description]
		end
from fraud.dbo.fraud f join fraud.dbo.claims c on f.ClaimID=c.ClaimID
join fraud.dbo.bookings b on f.BookingID=b.BookingID
left join fraud.dbo.sysLookup s on s.code=b.NoContactReason and s.TableName='reason'
where f.ClaimID=@claimid


exec fraud.dbo.AddNoteToClaim @ClaimID=@claimid, @note=@screeningtext, @userid=@userid, @notetype=100, @notereason=0 


GO

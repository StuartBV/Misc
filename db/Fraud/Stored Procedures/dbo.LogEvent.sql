SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LogEvent]
@FIN varchar(10),
@UserID varchar(50),
@BookingID int=null,
@Tier smallint,
@Status smallint,
@Action smallint
as

set nocount on

declare
@sql varchar(8000),
@fld varchar(50),
@claimID int,
@notetxt varchar(8000),
@cmsclaimid int

select	@sql='',@fld='',@claimID=f.claimid,@cmsclaimid=case when f.OriginatingSys='PPD3' then c.OriginClaimID else 0 end
from fraud f 
join claims c on c.ClaimID=f.ClaimID
where fin=@FIN

if (@Action<>99)
 begin
	insert into FraudLog (FIN,TransDate,UserId,BookingID,TierStage,[Status],ActionTaken) 
	values (@FIN,getdate(),@UserID,@BookingID,@Tier,@Status,@Action)
 end

set @sql='update Fraud set AlteredDate=getdate(),AlteredBy='''+@UserID+''''

if (@Action=4 or @Action=5 or @Action=6 or @Action=7 or @Action=8 or @Action=9 or @Action=0)
begin
	if (@Action=0)
	begin
		set @sql=@sql+',status='+cast(@Status as varchar)
	end
	if (@Action=4 or @Action=5 or @Action=6 or @Action=8 or @Action=9)
	begin
		set @sql=@sql+',CurrentTier='+cast(@Tier as varchar)
	end
	
	if (@Action=4)
	begin
		set @fld='ReviewStarted '
	end
	
	if (@Action=5)
	begin
		set @fld='ReviewEnded '
	end
	
	if (@Action=6)
	begin
		set @fld='InterviewStarted '
	end
	
	if (@Action=7)
	begin
		set @fld='InterviewEnded '
	end
	
	if (@Action=4 or @Action=5 or @Action=6 or @Action=7)
	begin
		set @sql=@sql+',Tier'+cast(@Tier as varchar)+@fld+'=GetDate() '
	end

	if (@Action=7 or @Action=8 or @Action=9)
	begin
		set @sql=@sql+',InUse=0 '
	end

end

else if (@Action=98)
	begin
		set @sql=@sql+',InUse=1 '
	end

else if (@Action=99)
	begin
		set @sql=@sql+',InUse=0 '
	end

set @sql=@sql+' where FIN='''+@FIN+''''

--print @sql
exec(@sql)

-- Add Screening details to the notes table for the claim when interview is complete
if (@Action=7)
begin
	exec AddScreeningNotesToClaim @claimid=@claimID, @userid=@UserID
end

-- Add CMS Tiered Fraud Fee onto CMS Q List based on stage.
if(@action=4)
begin
	exec ppd3.dbo.Fees_Fraud_Add @claimid=@cmsclaimid, @price=70.00 -- The CMS ClaimID, not the TS Claim ID!
end


GO

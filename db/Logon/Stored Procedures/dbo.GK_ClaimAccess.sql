SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_ClaimAccess] 
@claimid int,
@hash varchar(36)=''
as
set nocount on
declare @channels varchar(250)

-- This SP checks to see whether the user trying to access the claim has authorisation to do so. MH 16/4/07
-- This should be written as one select
select @channels=channel 
from userdata ud join clients c on ud.clientid=c.cid
where @hash=[hash] and ud.[enabled]=1

select case when exists (select * from PPD3.[dbo].claims c where claimid=@claimid and charindex(c.channel,@channels,0)>0)
	then 0 else 1 end Result

/*
begin
	select 0 as result  -- User authorised
end
else
begin
	select 1 as result-- User not authorised
end
*/
GO

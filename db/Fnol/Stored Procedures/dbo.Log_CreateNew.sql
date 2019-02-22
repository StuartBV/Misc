SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[Log_CreateNew]
@claimid int,
@event varchar(1000),
@userid varchar(50)

as

insert into Log ( ClaimID, Event, CreatedDate, CreatedBy )
values  (@claimid,@event,getdate(),@userid)


GO

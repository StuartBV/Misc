SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BulkBooking]
@start varchar(20),
@end varchar(20),
@handler varchar(50),
@type varchar(5),
@userid UserID
as
set nocount on

declare @days smallint=datediff(d,@start,@end)+1

insert into Bookings (FIN,[type],BookedFor,StartDate,EndDate,ContactPlace,ContactNo,ContactName,contactmade,CreateDate,CreatedBy) 
select '',@type,@handler,dateadd(d,d.digit-1,@start),dateadd(d,-(@days-d.digit),@end),'','','',null,getdate(),@userid
from ppd3.dbo.digits d
where d.digit<=@days

GO

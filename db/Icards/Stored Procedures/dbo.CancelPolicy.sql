SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[CancelPolicy]
@iCardsID varchar(50),
@reason int,
@userid varchar(50),
@duplicates varchar(500)
as

declare 
@logtext varchar(1000)

set nocount on
set transaction isolation level read uncommitted

update policies set
status=0,
--wizardstage = 0, -- Leave wizard stage the same for viewing at a later date by handlers
cancelreason=@reason,
alteredby=@userid,
altereddate=getdate()
where icardsid = right(@iCardsID,6)

-- Creates a log entry
IF @duplicates='0'
	select @logtext = 'Policy cancelled for the following reason: ' + sys.description
	from policies p
	JOIN syslookup sys ON sys.tablename='CancelReason' AND p.cancelreason=sys.code
	WHERE p.icardsid = right(@iCardsID,6)
ELSE
	set @logtext = 'Policy cancelled because the following duplicate policies were found: '+@duplicates


exec LogEntry @iCardsid=@iCardsID, @userid=@userid, @type=50, @text=@logtext

set transaction isolation level read committed


GO

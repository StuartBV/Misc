SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

CREATE procedure [dbo].[Reverse_CancelPolicy]
@iCardsID varchar(50),
@userid varchar(50)

as

set nocount on

update policies set
status=0,
cancelreason=NULL,
alteredby=@userid,
altereddate=getdate()
where icardsid = right(@iCardsID,6)

-- Creates a log entry
exec LogEntry @iCardsid=@iCardsID, @userid=@userid, @type=51, @text='Policy reverese cancellation processed'
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[BatchFileErrorUpdate] 
@transid int,
@errcode int,
@userid varchar(50)
as
declare
@logtext varchar(500),
@err varchar(200),
@icardsid varchar(50)
/*
<SP>
	<Name>BatchFileErrorUpdate</Name>
	<CreatedBy>DerekF</CreatedBy>
	<CreateDate>20060612</CreateDate>
	<Referenced>
		<asp>BatchFileErrorUpdate.asp</asp>
	</Referenced>
	<Overview>Used to update rows in the transactions table which fail to upload in the TSYS batch file process</Overview>
	<Changes>
		<Change>
			<User></User>
			<Date></Date>
			<Comment></Comment>
		</Change>
	</Changes>
</SP>
*/
set nocount on

select @icardsid=icardsid from policydetails where cardvalueid = @transid
select @err=[description] from syslookup where tablename = 'BatchfileErrors' and code = @errcode
set @logtext='This transaction errored in the batch file upload, reason: ' + @err

update transactions set uploaderror = @errcode, status=0 where id = @transid

exec LogEntry @iCardsid=@icardsid, @userid=@userid, @type=30, @text=@logtext
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[LastRefUpdate]
@userid varchar(50),
@lastref varchar(50),
@lastframe varchar(250)=''
as
/*
<SP>
	<Name>LastRefUpdate</Name>
	<CreatedBy>Derekf</CreatedBy>
	<CreateDate>20060613</CreateDate>
	<Referenced>
		<asp>various</asp>
	</Referenced>
	<Overview>Called whenever a claim is accessed to record the last claim looked at by an operator</Overview>
	<Changes>
		<Change>
			<User>Derekf</User>
			<Date>20060620</Date>
			<Comment>modified to record the last menu visited</Comment>
		</Change>
	</Changes>
</SP>
*/
BEGIN TRAN

if exists ( select 1 from lastref where userid = @userid )
  begin
	if(@lastref<>'')
	  begin
		update lastref set lastref=@lastref where userid=@userid
	  end
	if(@lastframe<>'')
	  begin
		update lastref set lastframe=@lastframe where userid=@userid
	  end
  end
else
  begin
	insert into lastref(userid,lastref,lastframe) values (@userid,@lastref,@lastframe)
  end

COMMIT TRAN
GO

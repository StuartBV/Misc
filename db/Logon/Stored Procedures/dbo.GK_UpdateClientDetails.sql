SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_UpdateClientDetails] 
	@userid varchar(30),
	@hash varchar(36), 
	@cid int=0,
	@channel varchar(250),
	@name varchar(100),
	@contact varchar(200),
	@text varchar(3000),
	@image varchar(200),
	@code varchar(4)='',
	@supplierid int=0 ,
	@superfmt varchar(300)='',
	@delsfmt char(1)='',
	@parent int=null,
	@inscoid int=null
AS SET nocount on
set transaction isolation level read uncommitted

 --ensure user allowed to update clients.
if exists (select * from [UserData] u (nolock) where [UserName] = @userid and  [Hash] = @hash AND clientid=1 and isAdmin =2 AND u.Enabled=1) 
BEGIN

	BEGIN TRAN 
	
	UPDATE Clients 
		SET channel=@channel, [Name]=@name,  Contact=@contact, [Text]=@text, [Image]=@image, 
			code=case @code WHEN '' THEN '' 
					        WHEN 'NULL' THEN '' ELSE @code end,
			alteredby=@userid, altereddate=getdate(),
			supplierid=case when @supplierid>0 then @supplierid else supplierid end,
			superfmt=case when @delsfmt in ('Y','') or @superfmt='' then '' -- If we need to blank commodity then do so.
					else  case when @superfmt !='' then @superfmt else superfmt 
					end 
				end,
			parent=@parent,insurancecoid=@inscoid
		WHERE cid=@cid
	COMMIT TRAN 
	-- Log update.
	EXEC GK_LogEntry @userid,'','',13,'Client Details updated successfully.',null,0
END

ELSE
	raiserror('User not authorised to update client details ',1,1)
GO

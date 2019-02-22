SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocumentScanInsert]
@claimid int,
@sheets smallint,
@userid varchar(20),
@logmsg varchar(500)='',
@qins tinyint,
@replins tinyint,
@itemlist tinyint,
@toins tinyint,
@fromins tinyint,
@tola tinyint,
@fromla tinyint,
@toinsured tinyint,
@frominsured tinyint,
@toother tinyint,
@fromother tinyint
AS
set nocount on

-- Insert into DocumentScans
if exists (select * from documentscans where printed=0 and claimid=@claimid and userid=@userid)
begin
	update documentscans set sheets=@sheets, QuoteInstruction=@qins, ReplaceInstruction=@replins,
	ItemList=@itemlist, ToInsCo=@toins, FromInsCo=@fromins, ToLa=@tola, fromla=@fromla, toinsured=@toinsured,
	frominsured=@frominsured, toother=@toother, fromother=@fromother
	where claimid=@claimid and userid=@userid and printed=0
end
else
begin
	insert into DocumentScans (Claimid, Sheets, Userid, QuoteInstruction, ReplaceInstruction, ItemList,ToInsCo, FromInsCo, ToLa, fromla, toinsured, frominsured, toother, fromother)
	select @claimid, @sheets, @userid, @qins, @replins, @itemlist, @toins, @fromins, @tola, @fromla, @toinsured, @frominsured, @toother, @fromother
end
GO

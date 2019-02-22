SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DF_WS_XmlLog_Insert]
@did int,
@claimid int,
@guid varchar(36),
@dir tinyint,
@msgtype tinyint=0,
@SupplierID int=null,
@xml text,
@ordersystem varchar(50)='CMS'
AS
SET NOCOUNT ON

if @claimid=0 and @ordersystem='CMS'
Begin
	select @claimid=claimid,@guid=isnull([guid],'') from ppd3.dbo.SupplierDelivery with(nolock) where did=@did
end

Insert into DF_WS_XMLLog (DID, Claimid, [GUID], Direction, [XML], MsgType, SupplierID, SourceSystem )
select @did, @claimid, @guid, @dir,@xml,@msgtype, @SupplierID, @ordersystem
GO

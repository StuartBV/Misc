SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[eCodeMappings_Ranked](@messageid int, @OverridesupplierID int)
returns table
as
return
	select top 1 m.SupplierID, m.Channel, m.eCode, m.SupplierName, m.SupplierNameForXml,	ds.MessageID
	from Data_Standing ds
	join eCodeMappings m on m.supplierid=isnull(@OverridesupplierID,ds.supplierid) and (ds.Channel=m.channel or m.Channel='*')
	where ds.messageid=@messageid
	order by [rank] desc
GO

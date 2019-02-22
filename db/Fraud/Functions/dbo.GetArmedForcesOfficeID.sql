SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[GetArmedForcesOfficeID]()
returns int
as
begin
	return (
		select top 1 max([id])
		from ppd3.dbo.officedetails od 
		where od.channel='af' and od.AccountRef='af'
	)
end

GO

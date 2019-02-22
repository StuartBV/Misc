SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocScan_ComunicationsList]
as
set nocount on

select x.[description] name1,x.flags value1,y.[description] name2,y.flags value2 
from (
	select replace(replace([description],'(T)',''),'(F)','') [description],flags 
	from ppd3.dbo.syslookup 
	where tablename='DocScanType'
	and ExtraCode<>'ss'
	and [description] like '%(F)'
	and Extradescription='Communication'
) x join (
	select replace(replace([description],'(T)',''),'(F)','') [description],flags 
	from ppd3.dbo.syslookup 
	where tablename='DocScanType'
	and ExtraCode<>'ss'
	and Extradescription='Communication'
	and [description] like '%(T)'
)y on x.[description] = y.[description]
GO

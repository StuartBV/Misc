SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[DocScan_DocumentsList]
as
set nocount on

select [Description] name,flags value 
from ppd3.dbo.syslookup 
where tablename='DocScanType'
and ExtraCode<>'ss' and ExtraDescription='Documents Included'
order by flags
GO

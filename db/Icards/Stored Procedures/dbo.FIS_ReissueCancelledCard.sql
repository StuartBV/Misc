SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[FIS_ReissueCancelledCard]
@cardid int
as


update PolicyDetails 
set pan='',SupplierCardId=0 
where CardID=@cardid
and Type='m'


update PolicyDetails 
set batchfileuploaded=null,InvoiceBatchNo='reissue',InvoicedDate=null,Status=1
where CardID=@cardid
and Type='m'
GO

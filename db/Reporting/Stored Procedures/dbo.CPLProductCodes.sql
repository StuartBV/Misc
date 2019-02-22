SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[CPLProductCodes]
as

select distinct cpl.InvoiceNumber, ds.InsuranceClaimNo,ItemTypeCode,di.CatNum as SupplierItemRef,di.Description
from CPLProductCodesImport cpl
left join SupplierEventsCollation.dbo.Data_Standing ds on cpl.InvoiceNumber = ds.InvoiceNumber and cpl.ClaimReference=ds.InsuranceClaimNo
left join SupplierEventsCollation.dbo.Data_Item di on di.MessageID=ds.MessageID
order by 2,1 desc
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SupplierInvoices_ForMatching] as

select supplierID,
case when charindex('/',poref)>1 and charindex ('D',poref)=0  then  cast(left(poref,charindex('/',poref)-1) as int) else 0 end ClaimID,
case when charindex ('D',poref)=1 then cast(  replace(left(poref,charindex('/',poref)-1),'D','') as int) else  left(substring(poref,charindex('/',poref)+1,10),8) end Did,
PORef, OrderRef,InvoiceNo,InvoiceDate,invoicevalue,NetAmount,VatAmount,InvoiceType,CheckId,[id]
from SN_PPD3_SupplierInvoices
where
len(poref)>=10  -- Remove refs too short to match with supplierdelivery
-- Below removed by SD see Atom 62788. Not sure of the impact this might have.
--len(poref)-1=len( replace(poref,'/','')) -- Ensure only one slash
and charindex('/',poref) between 1 and 8 -- Not more than 7 digits in front of first slash
and ((patindex('%[ -.,a-z,:-?]%',poref)=0) or (poref like 'D%'   ) ) -- Filter out all the all the sheeet 

GO

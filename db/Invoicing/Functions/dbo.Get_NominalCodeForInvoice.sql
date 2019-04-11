SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[Get_NominalCodeForInvoice](@CategoryId Int, @SupplierId int)
returns Table
as
return 

select top 1 m.NominalCode
from InvoiceExport_NominalCodes_Map m
left join SN_Distributors d on d.ID=@CategoryId
where ((m.CategoryId=@CategoryId and m.SupplierId=0) or (m.CategoryId=0 and m.SupplierId=@CategoryId and @CategoryId>0)) --and (d.IsJewellery=m.IsJewellery)
order by m.SupplierId desc
GO

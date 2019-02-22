SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[SupplierName] as
select id,name
from ppd3.dbo.Distributor
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[MaintenancePolicy]
as
truncate table supplierinvoicematch
truncate table SupplierInvoicingAggregates
GO

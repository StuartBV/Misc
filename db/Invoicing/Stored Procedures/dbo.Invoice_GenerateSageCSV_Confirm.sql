SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Invoice_GenerateSageCSV_Confirm]
@channel varchar(50),
@accountRef varchar(50)=null
as

set nocount on

update Invoicing_Invoices
set SagesentDate=getdate()
where SageSentdate is null and Channel=@channel and AccountRef=isnull(@accountRef,AccountRef)
GO

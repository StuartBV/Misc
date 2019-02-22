SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Bordereau_GenerateCSV_File_Confirm]
@NextBordereauNo int,
@channel varchar(20),
@accountRef varchar(50)=null,
@from varchar(10),
@to varchar(10)
as

declare @fd datetime,@td datetime
select @fd=cast(@from as datetime), @td=dateadd(mi,-1,dateadd(d,1,@to))

update INVOICING_Invoices set BordereauSentDate=getdate(),BordereauNo=@NextBordereauNo
where BordereauSentDate is null 
and SageSentDate between @fd and @td
and Channel=@channel 
and AccountRef=isnull(@accountRef,AccountRef)

return @@error
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_GenerateSageCSV]
@confirm tinyint=0, 
@Channel varchar(50), 
@accountRef varchar(50)=null
as
set nocount on
set ansi_warnings off

declare @error int, @errormsg varchar(100), @ExportId bigint=Cast(dbo.NumbersOnly(Cast(Cast(SysDateTime() as time) as varchar)) as bigint)

select @accountRef=
	case @Channel
		when 'RSA' then 'RSAV4'
		when 'RSAProfin' then 'RSAProfinV4'
	else null end,
	@Channel=case when @Channel like 'RSA%' then 'RSA' else @Channel end

insert into InvoicesToExport (Id, OrderId)
select @ExportId,	o.Id
from Invoicing_Orders o
where
o.Channel=@Channel
and o.SourceType not in (2,4,6)
and o.SageSentDate is null

begin try
	exec @error=Invoice_GenerateSageCSV_File @Channel=@Channel, @AccountRef=@accountRef, @ExportId=@ExportId
	if @error=0 and @confirm=1
	begin
		-- No errors so confirm invoices
		begin tran
			exec Invoice_GenerateSageCSV_Confirm2 @ExportId=@ExportId
			exec Invoice_GenerateSageCSV_LogConfirmed
		commit tran
	end
	else
	begin
		if @error < -1
		begin
			set @errormsg='Invoice_GenerateSageCSV_File returned ' + Cast(@error as varchar);
			throw 50000, @errormsg, 1;
		end
	end
end try

begin catch
	set @errormsg=dbo.ErrorMessage()
	--raiserror(@errormsg, 15, 1)
	select dbo.ErrorMessage()
	if @@TranCount>0 rollback
end catch

delete from InvoicesToExport where Id=@ExportId

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_GenerateSageCSV_OLD]
@confirm tinyint=0,
@Channel varchar(50),
@accountRef varchar(50)=null
AS
set nocount on
set ansi_warnings off

declare @errors int

if @Channel='RSA'
begin
 select @accountRef='RSAV4'
end

if @Channel='RSAProfin'
begin
 select @Channel = 'RSA', @accountRef='RSAProfinV4'
end

exec @errors = Invoice_GenerateSageCSV_File_OLD @channel=@channel, @accountRef=@accountRef

if @errors=0 and @confirm=1
begin
	-- No errors so confirm invoices
	begin tran
		exec Invoice_GenerateSageCSV_Confirm @channel=@channel, @accountRef=@accountRef
		if @@error=0
		begin
			insert into Invoicing_ExportLog (invoicenumber,total,vat)
			select invoicenumber,amount+vat,vat
			from Worktable_InvoiceExport_Sage 
			commit tran
		end
		else
		begin
			rollback tran
		end
end

GO

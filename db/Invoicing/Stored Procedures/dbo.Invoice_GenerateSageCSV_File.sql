SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_GenerateSageCSV_File]
@Channel varchar(50), 
@AccountRef varchar(50)=null,
@ExportId bigint
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @errors int=0, @bcp varchar(500), @path varchar(100),
	@date varchar(20)= Replace(Replace( (Convert(char(8), GetDate(), 3) + '-' + Convert(char(8), GetDate(), 114)), ':', ''), '/', '')

truncate table Worktable_InvoiceExport_Sage2 
truncate table Worktable_InvoiceExport_Sage2Aggregated

select @path=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'invoiceExports\V2\' else '\\tau\InvoiceExports\V2\' end,
	@Channel=IsNull(Upper(@Channel),'')


if exists (select * from SageInvoices_Version2 where dbo.DeQuote(AccountRef)=IsNull(@AccountRef, dbo.DeQuote(AccountRef)))
begin
	begin try
		-- Aggregated file
		insert into Worktable_InvoiceExport_Sage2Aggregated (TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat)
		select TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat
		from SageInvoices_Version2_Aggregated
		where ExportId=@ExportId and dbo.DeQuote(AccountRef)=IsNull(@AccountRef, dbo.DeQuote(AccountRef))

		set @bcp='bcp Invoicing.dbo.Worktable_InvoiceExport_Sage2Aggregated out "' + @path + 'INV2_' + @Channel + '_' + @date +'_Aggregated.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output

		-- Lineitem file
		insert into Worktable_InvoiceExport_Sage2 (TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat)
		select TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, Vatcode, Vat
		from SageInvoices_Version2
		where
		ExportId=@ExportId and dbo.DeQuote(AccountRef)=IsNull(@AccountRef, dbo.DeQuote(AccountRef))

		set @bcp= 'bcp Invoicing.dbo.Worktable_InvoiceExport_Sage2 out "' + @path + 'INV2_' + @Channel + '_' + @date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output

		if dbo.ServerType()='LIVE' -- Copy to FilesExportedCopy 
		begin
			set @bcp='bcp Invoicing.dbo.Worktable_InvoiceExport_Sage2Aggregated out "' + dbo.ExportCopyPath() + '\INV2_' + @Channel + '_' + @date +'_Aggregated.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
			exec master.dbo.xp_cmdshell @bcp, no_output

			set @bcp= 'bcp Invoicing.dbo.Worktable_InvoiceExport_Sage2 out "' + dbo.ExportCopyPath() + '\INV2_' + @Channel + '_' + @date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
			exec master.dbo.xp_cmdshell @bcp, no_output
		end

	end try
	begin catch
		throw
	end catch
end
else
begin
	begin try
		set @bcp= 'bcp Invoicing.dbo.Worktable_InvoiceExport_Sage out "' + @path + 'INV2_' + @Channel + '_' + @date +'_NODATA.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output
		return -1
	end try
	begin catch
	return -2
	end catch
end

GO

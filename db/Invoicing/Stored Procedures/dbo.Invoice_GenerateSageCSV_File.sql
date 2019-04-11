SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_GenerateSageCSV_File]
@Channel varchar(50), 
@AccountRef varchar(50)=null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @errors int=0, @bcp varchar(500), @path varchar(100),
	@date varchar(20)= Replace(Replace( (Convert(char(8), GetDate(), 3) + '-' + Convert(char(8), GetDate(), 114)), ':', ''), '/', '')

truncate table Worktable_InvoiceExport_Sage
truncate table Worktable_InvoiceExport_SageAggregated

select @path=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'invoiceExports\V2\' else '\\tau\InvoiceExports\V2\' end,
	@Channel=IsNull(Upper(@Channel),'')

if exists (select * from SageInvoices_Version2 where Channel=@Channel and dbo.DeQuote(AccountRef)=IsNull(@AccountRef, dbo.DeQuote(AccountRef)))
begin
	begin try
		-- Aggregated file
		insert into Worktable_InvoiceExport_SageAggregated (TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat)
		select TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat
		from SageInvoices_Version2_Aggregated
		where Channel=@Channel and dbo.DeQuote(AccountRef)=IsNull(@AccountRef, dbo.DeQuote(AccountRef))

		set @bcp='bcp Invoicing.dbo.Worktable_InvoiceExport_SageAggregated out "' + @path + 'INV2_' + @Channel + '_' + @date +'_Aggregated.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output

		-- Lineitem file
		insert into Worktable_InvoiceExport_Sage (TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, VatCode, Vat)
		select TransType, AccountRef, NominalCode, Department, InvoiceDate, InvoiceNumber, Reference, Amount, Vatcode, Vat
		from SageInvoices_Version2
		where Channel=@Channel and dbo.DeQuote(AccountRef)=IsNull(@AccountRef, dbo.DeQuote(AccountRef))

		set @bcp= 'bcp Invoicing.dbo.Worktable_InvoiceExport_Sage out "' + @path + 'INV2_' + @Channel + '_' + @date +'.csv" -c -t, -S' + Cast(ServerProperty('servername') as varchar) +  ' -T'
		exec master.dbo.xp_cmdshell @bcp, no_output
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

--exec Invoice_GenerateSageCSV_File_OLD @Channel=@channel, @AccountRef=@AccountRef	-- Enable to run old version as well

GO

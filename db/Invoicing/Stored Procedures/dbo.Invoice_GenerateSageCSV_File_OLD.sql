SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_GenerateSageCSV_File_OLD]
@channel varchar(50),
@accountRef varchar(50)=null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @date varchar(20), @errors int=0, @I0rows int, @bcp varchar(500), @path varchar(100)	

set @date= Replace(Replace( (Convert(char(8),GetDate(),3) + '-' + Convert(char(8),GetDate(),114)),':',''),'/','')

select @path=case dbo.ServerType() when 'dev' then PPD3.dbo.LocalPath() + 'invoiceExports\V2\' else '\\tau\InvoiceExports\V2\' end

truncate table Worktable_InvoiceExport_Sage
		insert into Worktable_InvoiceExport_Sage (TransType,AccountRef,SalesCode,Department,InvoiceDate,InvoiceNumber,Reference,Amount,VatCode,Vat)
		select TransType,'"'+AccountRef+'"',SalesCode,Department,InvoiceDate,InvoiceNumber,Reference,Amount,VatCode,Vat
		from Sage_Invoices
		where Channel=@channel and AccountRef=IsNull(@accountRef,AccountRef)

set @I0rows=@@RowCount

if @I0rows>0
begin
	set @bcp= PPD3.dbo.BcpCommand() + 'Invoicing.dbo.Worktable_InvoiceExport_Sage out "' + @path + 'INV_' + @date +'.csv" -c -t, -S' +Cast(ServerProperty('servername') as varchar)+  ' -T'
	exec master.dbo.xp_cmdshell @bcp,no_output
	set @errors=@@Error
end

GO

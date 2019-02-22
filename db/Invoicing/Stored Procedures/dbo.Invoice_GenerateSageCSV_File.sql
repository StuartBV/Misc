SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Invoice_GenerateSageCSV_File]
@channel varchar(50),
@accountRef varchar(50)=null
as
set nocount on
set ansi_warnings off
set xact_abort on
set dateformat dmy

declare @date varchar(20), @errors int=0, @I0rows int, @bcp varchar(500), @path varchar(100)	

set @date= replace(replace( (convert(char(8),getdate(),3) + '-' + convert(char(8),getdate(),114)),':',''),'/','')

select @path=case dbo.servertype() when 'dev' then ppd3.dbo.LocalPath() + 'InvoiceExports\V2\' else '\\tau\InvoiceExports\V2\' end

truncate table Worktable_InvoiceExport_Sage
		insert into Worktable_InvoiceExport_Sage (Transtype,AccountRef,SalesCode,Department,InvoiceDate,InvoiceNumber,Reference,Amount,VatCode,Vat)
		select TransType,'"'+AccountRef+'"',SalesCode,Department,InvoiceDate,InvoiceNumber,Reference,Amount,VatCode,Vat
		from Sage_Invoices
		where Channel=@channel and AccountRef=isnull(@accountRef,AccountRef)

set @I0rows=@@rowcount

if @I0rows>0
begin
	set @bcp= ppd3.dbo.BcpCommand() + 'Invoicing.dbo.Worktable_InvoiceExport_Sage out "' + @path + 'INV_' + @date +'.csv" -c -t, -S' +cast(serverproperty('servername') as varchar)+  ' -T'
	exec master.dbo.xp_cmdshell @bcp--,no_output
	set @errors=@@error
end
GO

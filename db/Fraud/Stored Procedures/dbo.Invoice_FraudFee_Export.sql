SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Invoice_FraudFee_Export] 
@channel varchar(50),
@confirm tinyint=0
as
set nocount on

declare @feetype tinyint, @now datetime

declare @command varchar(1000),@path varchar(100),@fname varchar(100), @result int,  @server varchar(20),
	@count smallint, @msg varchar(200), @qty varchar(5)
	
-- Get Fee Type from Syslookup
select @feetype=sys.flags, @now=getdate()
from sysLookup sys
where sys.tablename='FeeTypes' and sys.code='FraudScreening'

select @qty=cast(count(*) as varchar(5)) from fees where channel=@channel and feetype=@feetype and invoicesent is null
if @qty<>'0'
begin

	select @server=@@servername
	select @count=flags from fraud.dbo.syslookup where tablename='FraudFeeBordereauCount' and code=@channel

	select @fname='FraudScreeningFeeBordereau_'+@channel+'_'  + cast(@count as varchar) + '_' + convert(char(8),@now,112) + '.xls'
	set @path='\\' + @server + '\FraudFee_Bordereau\' + @fname

	set @command=ppd3.dbo.BcpCommand() + '"fraud.dbo.FraudSceeningFeesBordereauExport_"'+@channel+' out "' +@path + '" -r\n -c -S ' + @server + ' -T'

	exec @result=master.dbo.xp_cmdshell @command, no_output

	if @result=0
	begin
		if   @confirm=1
		begin
			begin tran
				update Fees set
					invoicesent=@now,
					BordereauNo=@count -- MH added to update the bordereau number. 
				where invoicesent is null and channel=@channel
				update syslookup set flags=flags+1 where tablename='FraudFeeBordereauCount' and code=@channel
			commit tran
			set @msg='File exported and fees confirmed, ' + @qty + ' fees included.'
			raiserror (@msg,15,1)
		end
		else
		begin
			set @msg='File exported only, ' + @qty + ' fees included.'
			raiserror (@msg,15,1)
		end
	end
	else
	begin
		set @msg='Fraud Screening Fee Export BCP Failed.\n\nPlease check the file < ' + @fname +' > does not already exist or is open.'
		raiserror (@msg,18,1) with log
	end
end
else
begin
	raiserror ('No fees to export',15,1)
end
GO

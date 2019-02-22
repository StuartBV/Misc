SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[GK_WVRep_NumberValidations] 
@from varchar(20) ,
@to varchar(20), 
@cid int=0
as
set dateformat dmy
set nocount on

declare @fd datetime,@td datetime,@where varchar(1000),@sql varchar(1000)
select @fd=cast(@from as datetime),@td=cast(@to as datetime)

if @fd = '' or  @td = '' 
begin
	set @td = getdate()
	set @fd = @td - 1
end

set @sql = 	"select 	convert(char(10),v.CreateDate,103)+' '+convert(char(5),v.CreateDate,14) CreateDate,
	isnull(InsuranceClaimNo,'&nbsp;') ClaimRef, u.fname + ' ' + u.sname CreatedBy, 'Number of Validations' as repname
	from Validator2.dbo.WV_validations v join userdata u on u.username=v.createdby
	where v.WVstatus = 3 and v.CreateDate between '" + convert(varchar(10),@fd,112) + "' and '" + convert(varchar(10),@td,112) + "'"

set @sql = @sql + " order by v.CreateDate"
exec(@sql)
GO

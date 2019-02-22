SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[reports_generate] 
@reportID int,
@channel varchar(50)='',
@team varchar(50)='',
@handler varchar(50)='',
@from varchar(50)='',
@to varchar(50)=''
as

set nocount on
set dateformat dmy
set transaction isolation level read uncommitted

declare @sql varchar(8000), @params varchar(8000)

set @params=''

select @sql="exec "+Code from reports where id=@reportID

if @channel<>''
 begin  
	if @params<>'' 
		set @params=@params+","

	set @params=@params+" @channel='"+@channel+"'"
 end	

if @team<>''
 begin  
	if @params<>'' 
		set @params=@params+","

	set @params=@params+" @team="+@team

 end

 if @handler<>''
 begin  
	if @params<>'' 
		set @params=@params+","

	set @params=@params+" @handler='"+@handler+"'"

 end

 if @from<>''
 begin  
	if @params<>'' 
		set @params=@params+","

	set @params=@params+" @from='"+@from+"'"
 end

 if @to<>''
 begin  
	if @params<>'' 
		set @params=@params+","

	set @params=@params+" @to='"+@to+"'"
 end


--PRINT @sql+@params
exec(@sql+@params)

GO

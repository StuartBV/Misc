SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [dbo].[Split](@String nvarchar(4000), @Delimiter char(1)) 
returns @Results TABLE (Items nvarchar(4000)) 
as 
begin 
declare @index int 
declare @slice nvarchar(4000) 

select @index = 1 
if @String is null return 

while @index != 0 

begin 
select @index = charindex(@Delimiter,@String) 
if @index !=0 
select @slice = left(@String,@index - 1) 
else 
select @slice = @String 

insert into @Results(Items) values(@slice) 
select @String = right(@String,len(@String) - @index) 
if len(@String) = 0 break 
end return 
end 
GO

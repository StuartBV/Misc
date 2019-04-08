SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[NumbersOnly](@str varchar(100))  
returns varchar(100)
as  
begin
declare @len Smallint,@i Smallint, @result Varchar(100)
select @len=Len(@str), @i=0, @result=''

while @i <=@len
begin
	if Ascii(Substring(@str,@i,1)) between 48 and 57
		set @result=@result + Substring(@str,@i,1) 
	set @i=@i+1
end

return @result

end
GO

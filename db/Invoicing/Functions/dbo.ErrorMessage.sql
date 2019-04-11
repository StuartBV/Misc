SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[ErrorMessage]() returns varchar(200) as
begin
	declare @msg varchar(200)
		select @Msg=
		IsNull(Error_Procedure(),'No') + ': error' 
		+ IsNull( ' on line ' + Cast(Error_Line() as varchar) ,'')
		+ ', ' + IsNull(Error_Message() ,'everything OK')

	return @msg
end

GO

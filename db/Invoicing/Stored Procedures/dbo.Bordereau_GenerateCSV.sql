SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Bordereau_GenerateCSV]
@confirm tinyint=0,
@path varchar(100),
@channel varchar(20),
@from varchar(20), 
@to varchar(20),
@accountRef varchar(50)=null
as
set nocount on
set ansi_warnings off

declare @errors int, @NextBordereauNo int

select @NextBordereauNo=isnull(max(BordereauNo),0)+1 from Invoicing_Orders

if @channel='LV'
begin
	-- custom LV version of export file, Atom 61200
	exec @errors=Bordereau_LVCustom_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @from=@from, @to=@to, @accountRef=@accountRef
end
else if @channel='end'
begin
--Custom for Endsleigh, Atom 63931
	exec @errors=Bordereau_ENDCustom_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @channel=@channel, @from=@from, @to=@to, @accountRef=@accountRef	
end
else if @channel = 'trov'
begin
--Custom for pushing in Trov AccountRef, Atom 64377
exec @errors=Bordereau_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @channel='PP', @from=@from, @to=@to, @accountRef='1TROV'
end
else if @channel = 'rsac'
begin
	-- custom for RSAC - VATDeduction
	exec @errors=Bordereau_Commercial_Custom_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @channel='rsac', @from=@from, @to=@to, @accountRef=@accountRef
end
else if @channel = 'rsa'
begin
	-- custom for RSA
	exec @errors=Bordereau_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @channel='rsa', @from=@from, @to=@to, @accountRef='RSAV4'
end
else if @channel = 'rsaprofin'
begin
	-- custom for RSAProfin
	exec @errors=Bordereau_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @channel='rsa', @from=@from, @to=@to, @accountRef='RSAProfinV4'
end
else
begin
	exec @errors=Bordereau_GenerateCSV_File @path=@path, @NextBordereauNo=@NextBordereauNo, @channel=@channel, @from=@from, @to=@to, @accountRef=@accountRef
end

if @errors=0 and @confirm=1
begin
	-- No errors so confirm bordereau exported
	begin tran
		exec @errors=Bordereau_GenerateCSV_File_Confirm @NextBordereauNo=@NextBordereauNo, @channel=@channel, @accountRef=@accountRef, @from=@from, @to=@to
		if @errors=0
		begin
			commit tran
		end
		else
		begin
			rollback tran
		end
end


GO

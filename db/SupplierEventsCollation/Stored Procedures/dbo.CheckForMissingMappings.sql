SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[CheckForMissingMappings]
as
set nocount on

declare @msg varchar(max)=''
select @msg=@msg + code from (
select distinct seid.category + ' (' + seid.CategoryType + ')' + char(13) code
	from  Ordering.dbo.SupplierEvents_ItemData seid
	left join Ordering_CPL_ItemTypeCodes tc on tc.Category=seid.Category and tc.method=seid.CategoryType
	where tc.CPLCode is null 
)x

if @msg !=''
begin
	set @msg='The following categories in the Ordering_Delivery table (category type in brackets) require mappings in SupplierEventsCollation.Ordering_CPL_ItemTypeCodes' + char(13) + char(13)
	+ @msg
	print @msg
	
	exec ppd3.dbo.SendMail @Recipient='itsupport@bevalued.co.uk', @SenderEmail='ITSupport@bevalued.co.uk', @SenderName='Sys', @Subject='Missing Category Mappings!', @Body=@msg, @Bcc='stuart@bevalued.co.uk'
	
end
GO

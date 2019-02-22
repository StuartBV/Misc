SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- author:		<derek francis>
-- create date: <14 aug 2008>
-- description:	<procedure used to return initial search results>
-- =============================================
CREATE procedure [dbo].[PolicySearch]
	@fld varchar(50),
	@value varchar(100)	
as
set quoted_identifier off
set nocount on
set transaction isolation level read uncommitted

declare @sql nvarchar(1000)

if @fld='serviceno' begin set @fld='coalesce(c.serviceno,p.serviceno)' end
if @fld='sname' begin set @fld='coalesce(c.sname,cu.lname)' end
if @fld='postcode' begin set @fld='coalesce(c.postcode,cu.postcode)' end

set @sql="
select distinct * from (
	select top 1000 
	p.id id,
	p.policyno,
	convert(varchar(12),p.inceptiondate,103) inceptiondate,
	convert(varchar(12),p.cancellationdate,103) cancellationdate,
	coalesce(c.title+' '+c.fname+' '+c.sname, cu.title+' '+cu.fname+' '+cu.lname) customer,
	cu.postcode,
	p.serviceno
	from fnol_policy p 
	join fnol_customers cu on p.customerid=cu.id 
	left join fnol_claims c on c.policyid=p.id
	where " + @fld + " like '" + @value + "%' 
	order by p.policyno asc, inceptiondate desc
) x" 

exec (@sql)
	
GO

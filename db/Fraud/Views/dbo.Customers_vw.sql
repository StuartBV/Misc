SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[Customers_vw] as

select 'PPD3' [system], cl.ClaimID,Title,Fname,Lname,BusinessName,VATregistered,Address1,Address2,Address3,Town,County,Postcode,Country,
Hphone,Wphone,Mphone,Fax,email,otherinfo,cu.CreateDate,cu.CreatedBy,cu.AlteredDate,cu.AlteredBy,SecondName,SecondPhone
from ppd3.dbo.Customers cu join ppd3.dbo.claims cl on cl.CustID=cu.ID
union all
select 'FNOL' [system], cl.ClaimID,Title,Fname,sname lname,null BusinessName,null VATregistered,Address1,Address2,null Address3,city town,County,Postcode,Country,
Hphone,Wphone,Mphone,null fax,email,null otherinfo,CreatedDate createdate,CreatedBy,AlteredDate,AlteredBy,null SecondName,null SecondPhone
from fnol.dbo.fnol_claims cl
GO

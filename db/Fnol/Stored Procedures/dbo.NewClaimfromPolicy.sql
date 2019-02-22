SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NewClaimfromPolicy]
@id INT,
@userid VARCHAR(50)
AS
SET NOCOUNT ON
SET DATEFORMAT dmy
set transaction isolation level read uncommitted

INSERT INTO FNOL_Claims (PolicyID,CompanyID,ClaimHandler,Title,Fname,Sname,Address1,Address2,City,County,Postcode,Country,
Hphone,Wphone,Mphone,Email,ServiceNo,MaritalStatus,Rank,Regiment,DOB,CoverType,CreatedBy,CreatedDate) 
SELECT @id,p.CompanyId,@userid,c.Title,c.Fname,c.Lname,c.Address1,c.Address2,c.Town,c.County,c.Postcode,c.Country,c.Hphone,
c.Wphone,c.Mphone,c.Email,p.ServiceNo,p.MaritalStatus,p.Rank,p.Regiment,p.DOB,p.CoverType,@userid,GETDATE()
FROM fnol_policy p 
JOIN fnol_customers c ON p.customerid=c.id
WHERE p.id=@id
select scope_identity()
GO

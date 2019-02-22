SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DataMig_Customers] as

SET DATEFORMAT dmy

BEGIN tran

INSERT INTO FNOL_Customers (Title,Fname,Lname,Address1,Address2,Town,County,Postcode,Country,Hphone,Mphone,email,otherinfo,CreateDate,CreatedBy) 
SELECT Title,giv,Surname,[Address Line 1],[Address Line 2],City,County,dm.[Post Code],Country,
std+' '+[Ph.],[Mobile no],Email,dm.[Service No],GETDATE(),'SysMig'
FROM FNOL_DataMig dm JOIN (
	SELECT [Service No],MAX([Claim No]) [Claim No]
	FROM FNOL_DataMig
	GROUP BY [service no]
) x ON dm.[claim no]=x.[claim no]
WHERE surname IS NOT null

commit
GO

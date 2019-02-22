SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DataMig_Policies] as

SET DATEFORMAT dmy
set transaction isolation level read uncommitted
BEGIN tran

INSERT INTO FNOL_Policy (Client,[Scheme],CompanyId,Underwriter,PolicyNo,CustomerID,DOB,ServiceNo,MaritalStatus,Rank,Regiment,
CoverType,InceptionDate,ChangeDate,CancellationDate,CreatedBy,CreatedDate)
SELECT NULL,NULL,1,NULL,[Policy Number],null,NULL,[Service No],maritalstatus.code,rank.code,regiment.Code,covertype.Code,
NULL,NULL,NULL,'SysMig',GETDATE()
FROM FNOL_DataMig p
left join syslookup rank  on p.rank=rank.description and rank.tablename='fnol - militaryrank'
left join syslookup regiment  on p.regt=regiment.description and regiment.tablename='fnol - militaryregiment'
left join syslookup maritalstatus  on p.marital=maritalstatus.description and maritalstatus.tablename='fnol - maritalstatus'
left join syslookup covertype  on p.cover=covertype.description and covertype.tablename='fnol - covertype' 

commit

set transaction isolation level read committed
GO

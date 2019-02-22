SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DataMig_PolicyLimits] as

SET DATEFORMAT dmy

BEGIN TRAN

INSERT INTO FNOL_PolicyLimits (PolicyID,[Type],SumInsured,Excess,CreatedBy,CreatedDate) 

SELECT ID,code,CAST(Insured AS MONEY),CAST(Excess AS MONEY),'SysMig',GETDATE() FROM (
SELECT 
p.ID,'CL' AS code,[Cont Lens Si] AS Insured,[Lense XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'CT' AS code,[Contents SI] AS Insured,[Contents XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'CY' AS code,[Cycles SI] AS Insured,[Cycles XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'LT' AS code,[Laptop B SI] AS Insured,[Laptop B XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'LT' AS code,[Laptop P SI] AS Insured,[Laptop P XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'MK' AS code,[Milirary Kit SI] AS Insured,[Kit XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'PC' AS code,[Desktop PC SI] AS Insured,[Desktop XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'PP' AS code,[Per Poss SI] AS Insured,[Pers Poss XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'SP' AS code,[Spectacle SI] AS Insured,[Spectacles XS] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
UNION
select
p.ID,'TL' AS code,[Tenants L XS] AS Insured,[Tenants Liab SI] AS Excess
FROM FNOL_DataMig dm JOIN FNOL_Policy p ON dm.[Policy Number]=p.PolicyNo
)x WHERE Insured<>'0' AND Excess<>'0'


COMMIT
--rollback


GO

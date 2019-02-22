SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[AutoFNOL_GetOriginalAddress]
@messageid int
as

set nocount on

SELECT 
ad.Address1,
ad.Address2,
ad.Address3,
ad.Town,
ad.County,
ad.Postcode,
ad.Country 
FROM AUTOFNOL_Claims c with (nolock)
join AUTOFNOL_Customers cu with (nolock) on c.CustID = cu.CustID
join AUTOFNOL_Addresses ad with (nolock) on cu.CustID = ad.CustID
where c.MessageLogID=@messageid
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[ClaimOffices] as
select OfficeID,Channel,GroupID,ClientID
from PPD3.dbo.ClaimOffices
GO

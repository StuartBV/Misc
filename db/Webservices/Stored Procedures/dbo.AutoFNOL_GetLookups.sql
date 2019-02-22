SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[AutoFNOL_GetLookups]
as

set nocount on

select Insco,InscoCode,CMSCode,type [nodetype]
from AutoFNOL_Lookup afl
GO

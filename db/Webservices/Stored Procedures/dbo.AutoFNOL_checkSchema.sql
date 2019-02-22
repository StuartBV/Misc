SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[AutoFNOL_checkSchema]
@schema varchar(200)
as

set nocount on

select cfg.InsCo,cfg.SchemaFile
from AutoFNOL_config cfg (nolock)
where cfg.SchemaUri=@schema
GO

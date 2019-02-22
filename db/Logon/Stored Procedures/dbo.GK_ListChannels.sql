SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[GK_ListChannels] as
set nocount on

exec ppd3.dbo.List_Syslookup 'channel', 1
GO

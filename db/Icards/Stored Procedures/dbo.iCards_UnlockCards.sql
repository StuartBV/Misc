SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[iCards_UnlockCards] as

update Policies set [Status]=0 where [Status] != 0
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create  function [dbo].[DateOnly](@DateTime DateTime)
-- Returns @DateTime at midnight; i.e., it removes the time portion of a DateTime value.
returns datetime
as
    begin
    return dateadd(dd,0, datediff(dd,0,@DateTime))
    end
GO

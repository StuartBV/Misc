SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_FailCode] @fc int, @ip varchar (20)

AS set nocount on

Select 

-- print messages to the user when authorisation is denied

case when @fc = 1 then 'The details you have supplied are incorrect' else
case when @fc = 2 then 'Your account has been disabled. Please see your administrator' else
case when @fc = 3 then  'The details you have supplied are incorrect' else
case when @fc = 4 then  'Your account has been disabled. Please see your administrator' else -- account marked as 'deleted'
case when @fc = 5 then  'An unknown error has occurred' else
case when @fc = 6 then 'Your account has no access to any system' else
case when @fc = 7 then 'You are not permitted to login.' else
case when @fc = 9 then 'You have successfully logged out' else
case when @fc = 100 then  'Either you have not logged in or your current session has expired. Please login again.'  end end end end end end end end end
as failMsg
GO

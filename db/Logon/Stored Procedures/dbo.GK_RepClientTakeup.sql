SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[GK_RepClientTakeup]
@from varchar(20)='' ,
@to varchar(20)='',
@cid varchar (5)=''
AS
set nocount on

SELECT c.Name, sum(case when changedpw is null then 1 else 0 end) as [Not Changed], 
sum(case when changedpw is not null then 1 else 0 end) as ChangedPW, 'Client TakeUp' as repname
from UserData u (nolock)
Join [Clients] c (nolock) on c.cid=u.clientid
group by c.Name
GO

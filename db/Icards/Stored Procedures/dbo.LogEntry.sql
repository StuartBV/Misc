SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LogEntry]
@iCardsID varchar(50),
@UserID varchar(20),
@Type varchar(3),
@Data int = NULL,
@Text varchar(500) = NULL,
@Status smallint = NULL,
@WizardStatus smallint = NULL,
@SupervisorID varchar(20)=NULL,
@prodid int=null
 AS
set nocount on
insert into [Log] (iCardsID,UserID,SupervisorID,Type,Data,[Text],createdate)
values
(@iCardsID,@UserID,@SupervisorID,@Type,@Data,@Text,getdate())
GO

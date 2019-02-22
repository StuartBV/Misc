SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SaveLog] 
@Thread varchar(255)='',
@level varchar(50),
@logger varchar(255),
@message varchar(4000)='',
@exception varchar(2000)='',
@Portal varchar(255)=''
as
set nocount on

insert into log4net(Thread, [level], logger, [message], exception, Portal)
values (@Thread, @level, @logger, @message, @exception, @Portal)

select scope_identity()

GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ELMAH_LogError]
@ErrorId uniqueidentifier,
@Application nvarchar(60),
@Host nvarchar(30),
@Type nvarchar(100),
@Source nvarchar(60),
@Message nvarchar(500),
@User nvarchar(50),
@AllXml ntext,
@StatusCode int,
@TimeUtc datetime
as

set nocount on

insert into ELMAH_Error (ErrorId, [Application], Host, [Type], Source, [Message], [User], AllXml, StatusCode, TimeUtc)
values(@ErrorId, @Application, @Host, @Type, @Source, @Message, @User, @AllXml, @StatusCode, @TimeUtc)

GO

CREATE TABLE [dbo].[MI_NU_InsuranceCos]
(
[InsCoID] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MI_NU_InsuranceCos] ADD CONSTRAINT [PK_MI_NU_InsuranceCos] PRIMARY KEY CLUSTERED  ([InsCoID]) ON [PRIMARY]
GO

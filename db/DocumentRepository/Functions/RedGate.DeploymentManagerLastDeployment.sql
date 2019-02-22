SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

			CREATE FUNCTION [RedGate].[DeploymentManagerLastDeployment] ()
			RETURNS @ret TABLE (PackageName NVARCHAR(MAX), PackageVersion NVARCHAR(MAX))
			AS
			BEGIN
				INSERT @ret VALUES (N'DocumentRepository', N'1.0.0');
				RETURN;
			END
GO

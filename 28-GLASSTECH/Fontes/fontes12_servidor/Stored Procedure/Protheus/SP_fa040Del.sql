USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[fa040Del]    Script Date: 19/08/2019 14:11:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('fa040Del') > 0
BEGIN
	DROP PROC dbo.fa040Del
END

GO

CREATE PROCEDURE [dbo].[fa040Del] ( @cTipo char(1), @cFilial char(4), @IdAdtoOrig int, @cOrigBD Char(1), @cHst varchar(100) output )
AS

  If @cTipo = 'A'
     
     EXEC [TESTE].[dbo].[ExcAdtGstq] @cFilial, @IdAdtoOrig, @cOrigBD, @cHst output;

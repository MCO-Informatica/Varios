USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[f300SE5Adt]    Script Date: 19/08/2019 14:03:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('f300SE5Adt') > 0
BEGIN
	DROP PROC dbo.f300SE5Adt
END

GO

CREATE PROCEDURE [dbo].[f300SE5Adt] ( @idConta int, @idCliente int, @dMovto char(10), @nValor float, @cHst varchar(60), @cLogin varchar(20), @cDocto varchar(20), @cDecCrd Char(1), @cFilial char(4), @cTpBx char(1), @nIdAdtoOrig int, @IdVctTit int, @cOrigBD char(1), @idMovto int output, @idAdto int output, @cHstPre varchar(100) output )
AS
    EXEC [TESTE].[dbo].[IncAdtGstq] @idConta, @idCliente, @dMovto, @nValor , @cHst, @cLogin, @cDocto, @cDecCrd, @cFilial, @cTpBx, @nIdAdtoOrig, @IdVctTit, @cOrigBD, @idMovto output, @idAdto output, @cHstPre output

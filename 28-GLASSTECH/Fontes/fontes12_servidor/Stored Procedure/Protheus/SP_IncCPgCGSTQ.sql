USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[IncCPgCGSTQ]    Script Date: 19/08/2019 13:14:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('IncCPgCGSTQ') > 0
BEGIN
	DROP PROC dbo.IncCPgCGSTQ
END

GO

CREATE procedure [dbo].[IncCPgCGSTQ] ( @cNumero Char(9), @cParcela Char(1), @cTipo Char(3), @cFornec Char(6), @cEmissao char(8) , @nEmpresa int, @idTipo int, @idTitulo int out, @Error varchar(256) out ) as
begin

   exec [TESTE].[dbo].[IncCPgCGSTQ] @cNumero, @cParcela, @cTipo, @cFornec, @cEmissao, @nEmpresa, @idTipo, @idTitulo out, @Error out
    
end;
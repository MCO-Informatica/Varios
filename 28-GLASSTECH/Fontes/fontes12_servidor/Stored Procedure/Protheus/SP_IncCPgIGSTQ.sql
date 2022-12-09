USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[IncCPgIGSTQ]    Script Date: 19/08/2019 13:16:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('IncCPgIGSTQ') > 0
BEGIN
	DROP PROC dbo.IncCPgIGSTQ
END

GO

CREATE procedure [dbo].[IncCPgIGSTQ] ( @idTitulo int, @nRecNo Int, @cNumero Char(9), @cParcela Char(1), @cTipo Char(3), @cFornec Char(6), @cNaturez VarChar( 10 ), @cCodRet varchar(4), @idVct int out, @Error varchar(256) out, @Fetch int out ) as
begin

   EXEC [TESTE].[dbo].[IncCPgIGSTQ] @idTitulo, @nRecNo, @cNumero, @cParcela, @cTipo, @cFornec, @cNaturez, @cCodRet, @idVct out, @Error out, @Fetch out
    
end;
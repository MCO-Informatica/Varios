USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[IncFornec]    Script Date: 19/08/2019 13:23:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('IncFornec') > 0
BEGIN
	DROP PROC dbo.IncFornec
END

GO

CREATE procedure [dbo].[IncFornec] ( @cNome varchar(50), @cIE varchar(20), @cCEP varchar(8), @cMun varchar(40), @cPais varchar(5), @cFone varchar(15), @cNro varchar(10), @cUf varchar(2), @cBairro varchar(20), @cLgr varchar(50), @cCNPJ varchar(20), @idCliente int out ) as
begin

	exec [TESTE].[dbo].[IncFornec] @cNome, @cIE, @cCEP, @cMun, @cPais, @cFone, @cNro, @cUf, @cBairro, @cLgr, @cCNPJ, @idCliente out
	
	if @@ERROR <> 0 select @idCliente = 0;
	select @idCliente = isnull( @idCliente, -1 )

end;

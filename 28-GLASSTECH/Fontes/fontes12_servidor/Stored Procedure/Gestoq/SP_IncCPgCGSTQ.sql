USE [TESTE]
GO

IF OBJECT_ID('IncCPgCGSTQ') > 0
BEGIN
	DROP PROC dbo.IncCPgCGSTQ
END

GO

CREATE procedure [dbo].[IncCPgCGSTQ] ( @cNumero Char(9), @cParcela Char(1), @cTipo Char(3), @cFornec Char(6), @cEmissao char(8) , @nEmpresa int, @idTipo int, @idTitulo int out, @Error varchar(256) out ) as
begin

    declare @idTit int
    	
    begin transaction	

-- inicio inclusão dos titulos
	select @idTit = max( ID_TITULO ) + 1 from TITULO

	select @cFornec = case @cTipo when 'IRF' then 5361 else @cFornec end

	insert into TITULO
		(ID_TITULO, DOC, ID_CLIENTE, TIPOTITULO, ID_DEPTO, REFERENCIA, DATA, ID_EMPRESA, TP_LANC, ID_CONDPAG, [LOGIN])
	values
	(@idTit, cast( cast( @cNumero as int) as varchar(10) ), cast( @cFornec as int), @idTipo, 1,cast( cast(@cNumero as int) as varchar(10) )+@cTipo,cast( @cEmissao as datetime) , @nEmpresa , 1 ,null, 'TOTVS')
	   
    commit
 
   select @Error = @@ERROR
   select @idTitulo = @idTit
    
end;
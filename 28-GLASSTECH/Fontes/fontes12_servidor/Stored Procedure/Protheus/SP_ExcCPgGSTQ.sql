USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[ExcCPgGSTQ]    Script Date: 19/08/2019 11:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO

IF OBJECT_ID('ExcCPgGSTQ') > 0
BEGIN
	DROP PROC dbo.ExcCPgGSTQ
END

GO

CREATE procedure [dbo].[ExcCPgGSTQ] ( @idVctTit int, @cOrigBD char(1), @Error varchar(256) out, @Fetch int out ) as
begin

	/* OBS. ***UNIFICACAO*** - PARA COLOCAR EM PRODUÇÃO - SUBSTITUIR O DATABASE "TESTE" POR "TPCP"*/

   declare @idTitulo int
   declare @nRec int

   If @cOrigBD <> 'B'
   Begin
      begin transaction

      select @idTitulo = ID_TITULO from TESTE.dbo.VENCTITULO where (ID_VENCTITULO = @idVctTit) AND (PAGO <> 'S');
      select @idTitulo = ISNULL(@idTitulo,0);
   
      if @idTitulo <> 0 
         begin
            delete TESTE.dbo.HISTORICO_DUPL     where (ID_VENCTITULO = @idVctTit)
            delete TESTE.dbo.VENCTITULO         where (ID_VENCTITULO = @idVctTit)
            delete TESTE.dbo.RATEIO		        where (ID_TITULO = @idTitulo)
            delete TESTE.dbo.RATEIO_OPERACIONAL where (ID_TITULO = @idTitulo)      
         end;

      select @nRec = count( ID_TITULO ) from TESTE.dbo.VENCTITULO where (ID_TITULO = @idTitulo);
      select @nRec = isnull( @nRec, 0);

      if (@nRec = 0) delete TESTE.dbo.TITULO where (ID_TITULO = @idTitulo);

      if @@ERROR = 0 commit else rollback;
   End;

   select @Error = @@ERROR;
   select @Fetch = @@FETCH_STATUS;
    
end;
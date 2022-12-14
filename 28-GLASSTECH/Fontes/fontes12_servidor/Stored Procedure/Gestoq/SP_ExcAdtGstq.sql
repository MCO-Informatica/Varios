USE [TESTE]
GO

IF OBJECT_ID('ExcAdtGstq') > 0
BEGIN
	DROP PROC dbo.ExcAdtGstq
END

GO

CREATE PROCEDURE [dbo].[ExcAdtGstq] ( @cFilial char(4), @IdAdtoOrig int, @cOrigBD VarChar(1), @cHst varchar(100) output )
AS

    set nocount on
    declare @cSaldo char(1);
    declare @idMovto int;
    
    begin transaction

    If @cOrigBD = 'B' /*@cFilial = '9001'*/ 
    
       EXEC [192.168.0.7].[BVTESTE].[dbo].[ExcAdtGstq] @cFilial, @IdAdtoOrig, @cHst output

	Else
	   
	   begin

   	      select @cSaldo = case when SALDO = VALOR then 'S' else 'N' end, @idMovto = ID_MOV_CONTA from ADIANTAMENTO where ID_ADIANTAMENTO = @IdAdtoOrig
   	      
   	      If @cSaldo = 'S'

   	         begin
   	      
   	            delete TESTE.dbo.MOV_CONTA where ID_MOV_CONTA = @idMovto
   	            delete TESTE.dbo.ADIANTAMENTO where ID_ADIANTAMENTO = @IdAdtoOrig
   	            select @cHst = ' '
   	         
   	         end;
   	      
   	      Else
   	      
   	          select @cHst = 'Adiantamento não excluído, existe compensações'

   	   end;

	commit;
USE [TESTE]
GO

IF OBJECT_ID('f04_50Alt') > 0
BEGIN
	DROP PROC dbo.f04_50Alt
END

GO

CREATE Procedure [dbo].[f04_50Alt]( @idVctTit int, @nValor float, @cVencto char(8), @nDescto float, @nAcresc float, @cOrigBD varchar(1), @cRet varchar(100) Out) As
Begin

    If @cOrigBD = 'B' /*@idVctTit > 300000*/

       begin

         UPDATE [192.168.0.7].[BVTESTE].[dbo].[VENCTITULO] SET VALOR = @nValor, VENCIMENTO = CAST( @cVencto AS DATETIME ), DESCONTO = @nDescto, OUTRAS_DESP = @nAcresc WHERE ID_VENCTITULO = @idVctTit;
       
       End;

    Else

       begin

			begin transaction 
            UPDATE [TESTE].[dbo].[VENCTITULO] SET VALOR = @nValor, VENCIMENTO = CAST( @cVencto AS DATETIME ), DESCONTO = @nDescto, OUTRAS_DESP = @nAcresc WHERE ID_VENCTITULO = @idVctTit;       
            commit
       
       End;

       select @cRet = ERROR_MESSAGE()

End;

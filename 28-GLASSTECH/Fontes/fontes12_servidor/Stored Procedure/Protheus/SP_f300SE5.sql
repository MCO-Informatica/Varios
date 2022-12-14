USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[f300SE5]    Script Date: 19/08/2019 13:54:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('f300SE5') > 0
BEGIN
	DROP PROC dbo.f300SE5
END

GO

CREATE Procedure [dbo].[f300SE5]( 
	@idVctTit int, 
	@idBanco int, 
	@cData char(10), 
	@nCheque int, 
	@cHist char(50), 
	@nJuros float, 
	@nValor float, 
	--@nDesconto float,
	@cMvt char(10), 
	@cRecPag Char(1), 
	@cArqCNAB VarChar(50), 
	@cOrigBD Varchar(1),
	@idBaixa int Out) 
As
Begin

   set xAct_Abort on
   
   select @idBaixa = isnull( @idBaixa, 0 )
    
   exec [TESTE].[dbo].[f300SE5] @idVctTit, @idBanco, @cData, @nCheque, @cHist, @nJuros, @nValor/*, @nDesconto*/, @cMvt, @cRecPag, @cArqCNAB, @cOrigBD, @idBaixa Out
               
   set  @idBaixa = isnull( @idBaixa, 0 )
   
End;

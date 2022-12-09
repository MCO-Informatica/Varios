USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[f04_50Alt]    Script Date: 19/08/2019 13:44:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('f04_50Alt') > 0
BEGIN
	DROP PROC dbo.f04_50Alt
END

GO

CREATE Procedure [dbo].[f04_50Alt]( @idVctTit int, @nValor float, @cVencto char(8), @nDescto float, @nAcrec float, @cOrigBD varchar(1), @cRet varchar(100) Out) As
Begin

   set nocount on
   set xAct_Abort on
   
   exec [TESTE].[dbo].[f04_50Alt] @idVctTit, @nValor, @cVencto, @nDescto, @nAcrec, @cOrigBD, @cRet Out
   
   select @cRet = ISNULL( @cRet, ' ' )
                  
End;

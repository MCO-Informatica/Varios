USE [RHR17_UNIFICACAO]
GO

IF OBJECT_ID('f080pcan') > 0
BEGIN
	DROP PROC dbo.f080pcan
END

GO

CREATE Procedure [dbo].[f080pcan]( @idVctTit int, @cRecPag char(1), @cEmpresa char(4), @cOrigBD char(1) ,@idBaixa int Out) As
Begin
	
	declare @idBaixaBV Int;
	select @idBaixaBV = 0;
	
	If @cOrigBD = 'B'     /*If (@idBaixa = 0) and (@cRecPag = 'R') and (@cEmpresa = '9001')*/
       Begin
          SELECT @idBaixa = isnull( ID_BAIXA_PARCIAL, 0 ) FROM [192.168.0.7].[BVTESTE].[dbo].[BAIXA_PARCIAL] BXA WHERE ID_BAIXA_PARCIAL = @idVctTit;
          select @idBaixaBV = ISNULL( @idBaixaBV, 0 );
	      If (@idBaixaBV <> 0) delete [192.168.0.7].[BVTESTE].[dbo].[BAIXA_PARCIAL] where ID_BAIXA_PARCIAL = @idBaixaBV;
          select @idBaixa = @idBaixaBV;
       End
    Else /*if (@cEmpresa <> '9001') Or ((@cEmpresa = '9001') and (@cRecPag <> 'R')) -- Baixas Contas a Pagar*/
       Begin	
	      SELECT @idBaixa = isnull( ID_BAIXA_PARCIAL, 0 ) FROM [TESTE].[dbo].[BAIXA_PARCIAL] BXA WHERE ID_BAIXA_PARCIAL = @idVctTit;
	      select @idBaixa = isnull( @idBaixa, 0 );
	      If (@idBaixa <> 0) delete [TESTE].[dbo].[BAIXA_PARCIAL] where ID_BAIXA_PARCIAL = @idBaixa;
	   End;
	   
End;

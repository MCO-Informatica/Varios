USE [TESTE]
GO

IF OBJECT_ID('PRC_G_F290BAIXA') > 0
BEGIN
	DROP PROC dbo.PRC_G_F290BAIXA
END

GO

CREATE procedure [dbo].[PRC_G_F290BAIXA]
	@pID_VENCTITULO int,
	@pOBS varchar(127) = ''
as
begin

declare @BASE varchar(50) = 'TESTE'

	update parcela
	set 
		parcela.DESCONTO = (parcela.VALOR - parcela.VALOR_PAGO), 
		parcela.PAGO = 'S', 
		parcela.OBS = @pOBS
	from VENCTITULO as parcela
	where parcela.ID_VENCTITULO = @pID_VENCTITULO And parcela.PAGO <> 'S' And (parcela.ID_TITULO = -1) --remover
		
End

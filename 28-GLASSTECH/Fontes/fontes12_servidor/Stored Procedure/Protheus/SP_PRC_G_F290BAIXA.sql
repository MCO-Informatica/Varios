USE [RHR17_UNIFICACAO]
GO
/****** Object:  StoredProcedure [dbo].[PRC_G_F290BAIXA]    Script Date: 19/08/2019 13:29:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	exec [TESTE].[dbo].[PRC_G_F290BAIXA] @pID_VENCTITULO, @pOBS
end
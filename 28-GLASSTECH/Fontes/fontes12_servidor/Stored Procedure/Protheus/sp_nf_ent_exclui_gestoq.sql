/*
	declare @id_nf as int

	exec sp_nf_ent_exclui_gestoq '0101', '000000000', 'A  ', '023313', '01', '48254858000109', 0

	select @id_nf
*/
alter Procedure [dbo].[sp_nf_ent_exclui_gestoq]( 
	@F1_FILIAL		char(4), 
	@F1_DOC			char(9), 
	@F1_SERIE		char(3),  
	@F1_FORNECE		char(6),
	@F1_LOJA		char(2),
	@CGC_EMP		char(20),
	@AMBPRD			smallint
)
As
Begin
Declare @ID_EMPRESA as int

If @AMBPRD = 1
begin
	--PEGA O ID DA EMPRESA
	select @ID_EMPRESA = ID_EMPRESA 
	from TPCP..EMPRESA
	WHERE REPLACE(REPLACE(REPLACE(REPLACE(CGC, '.', ''), '/', ''), '/', ''), '-', '')  = @CGC_EMP
	AND   ID_EMPRESA <> 999

	print 'ID_EMPRESA GESTOQ '+Convert(varchar(100), @ID_EMPRESA)

	print 'Apaga os itens da NF se existir'
	
	PRINT 'APAGA PILHA'
	
	DELETE C
	FROM TPCP.DBO.NOTA_COMPRA A
			INNER JOIN TPCP.DBO.ITEM_NOTA_COMPRA B
				ON(    A.ID_NOTA_COMPRA = B.ID_NOTA_COMPRA)
			INNER JOIN TPCP.dbo.PILHA C
				ON(    B.ID_ITEM_NOTA_COMPRA = C.ID_ITEM_NOTA_COMPRA )
	where NRO_NF     = CONVERT(INT, @F1_DOC)
	and   SERIE      = @F1_SERIE
	AND   ID_CLIENTE = CONVERT(INT, @F1_FORNECE)

	DELETE B
	FROM TPCP.DBO.NOTA_COMPRA A
			INNER JOIN TPCP.DBO.ITEM_NOTA_COMPRA B
				ON(    A.ID_NOTA_COMPRA = B.ID_NOTA_COMPRA)
	where NRO_NF     = CONVERT(INT, @F1_DOC)
	and   SERIE      = @F1_SERIE
	AND   ID_CLIENTE = CONVERT(INT, @F1_FORNECE)

	print 'Apaga cabe�alho da NF se existir'
	DELETE A
	FROM TPCP.DBO.NOTA_COMPRA A
	where NRO_NF     = CONVERT(INT, @F1_DOC)
	and   SERIE      = @F1_SERIE
	AND   ID_CLIENTE = CONVERT(INT, @F1_FORNECE)
END
ELSE
BEGIN
	--PEGA O ID DA EMPRESA
	select @ID_EMPRESA = ID_EMPRESA 
	from TESTE..EMPRESA
	WHERE REPLACE(REPLACE(REPLACE(REPLACE(CGC, '.', ''), '/', ''), '/', ''), '-', '')  = @CGC_EMP
	AND   ID_EMPRESA <> 999

	print 'ID_EMPRESA GESTOQ '+Convert(varchar(100), @ID_EMPRESA)

	PRINT 'APAGA PILHA'
	
	DELETE C
	FROM TESTE.DBO.NOTA_COMPRA A
			INNER JOIN TESTE.DBO.ITEM_NOTA_COMPRA B
				ON(    A.ID_NOTA_COMPRA = B.ID_NOTA_COMPRA)
			INNER JOIN TESTE.dbo.PILHA C
				ON(    B.ID_ITEM_NOTA_COMPRA = C.ID_ITEM_NOTA_COMPRA )
	where NRO_NF     = CONVERT(INT, @F1_DOC)
	and   SERIE      = @F1_SERIE
	AND   ID_CLIENTE = CONVERT(INT, @F1_FORNECE)

	print 'Apaga os itens da NF se existir'
	
	DELETE B
	FROM TESTE.DBO.NOTA_COMPRA A
			INNER JOIN TESTE.DBO.ITEM_NOTA_COMPRA B
				ON(    A.ID_NOTA_COMPRA = B.ID_NOTA_COMPRA)
	where NRO_NF     = CONVERT(INT, @F1_DOC)
	and   SERIE      = @F1_SERIE
	AND   ID_CLIENTE = CONVERT(INT, @F1_FORNECE)

	print 'Apaga cabe�alho da NF se existir'
	DELETE A
	FROM TESTE.DBO.NOTA_COMPRA A
	where NRO_NF     = CONVERT(INT, @F1_DOC)
	and   SERIE      = @F1_SERIE
	AND   ID_CLIENTE = CONVERT(INT, @F1_FORNECE)
END

end
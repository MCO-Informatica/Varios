

/****** Object:  StoredProcedure [dbo].[sp_nf_ent_item_gestoq]    Script Date: 15/02/2021 16:48:11 

select * 
FROM SF1010
WHERE F1_DOC     = '000286730'
AND   F1_FILIAL  = '0101'
AND   F1_SERIE   = '2  '
AND   F1_FORNECE = '018483'
AND   F1_LOJA	 = '01'
AND   D_E_L_E_T_ = ''

select * from sigamat 

declare @id_nf as int
begin tran
exec sp_nf_ent_item_gestoq 302447, 0, 58315, @id_nf out
rollback
select @id_nf

select * from TESTE..NOTA_COMPRA
WHERE ID_CLIENTE = 23313
and   NRO_NF     = 

ID_NOTA_COMPRA =  117692


select * from TESTE..ITEM_NOTA_COMPRA
WHERE ID_ITEM_NOTA_COMPRA =  117694



select R_E_C_N_O_, * from SF1010 WHERE F1_DOC = '000286730' AND D_E_L_e_T_ = ''

******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter Procedure [dbo].[sp_nf_ent_item_gestoq]( 
ALTER Procedure [dbo].[sp_nf_ent_item_gestoq]( 
	@RECNO					INT,
	@AMBPRD					smallint,
	@ID_NOTA_COMPRA			int,
	@ID_ITEM_NOTA_COMPRA	INT OUTPUT
)
As
begin
DECLARE @ID_EMPRESA	AS INT
DECLARE @ID_PILHA int
DECLARE @QTD                 float
DECLARE @LOTE                varchar(20)
DECLARE @PILHA               int

	BEGIN TRAN

		--DIRECIONA PARA AS BASES DE PROD OU TESTE - POR ESSE MOTIVO O QUE FOR ALTERADO PARA A PROD, DEVE SER REPLICADO PARA A TESTE
		--TPCP	= AMBIENTE DE PRODUÇÃO
		--TESTE	= TESTE
		IF @AMBPRD = 1
		BEGIN
			--PEGA O ID DA NF
			SET	@ID_ITEM_NOTA_COMPRA	= (select max(ID_ITEM_NOTA_COMPRA)+1 from TPCP..ITEM_NOTA_COMPRA)


			INSERT INTO [TPCP].[dbo].[ITEM_NOTA_COMPRA]
					   ([ID_ITEM_NOTA_COMPRA]		--ID ITEM NOTA PK
					   ,[ITEM]						--NUMERO DO ITEM DA NF
					   ,[ID_NOTA_COMPRA]			--ID FK DA NOTA COMPRA
					   ,[ID_MATERIAL]				--ID FK DO MATEIRAL
					   ,[QTD_PEDIDA]				--QUANTIDADE PEDIDA			*NULO
					   ,[QTD_ENTREGUE]				--QUANTIDADE ENTREGUE		*NULO
					   ,[CODIGO_FORNECEDOR]			--CÓDIGO DO FORNECEODR		*NULO
					   ,[CATALOGO]					--CÓDIGO DO MATERIAL
					   ,[ID_PEDIDO]					--ID FK DO PEDIDO
					   ,[NRO_PED_COMPRA]			--NUMERO DE PEDIDO COMPRA	*NULO
					   ,[DESCRICAO]					--DESCRIÇÃO DO ITEM
					   ,[CF]						--CLASSIFICAÇÃO FISCAL		*NULO
					   ,[PEDIDO_ITEM]				--NUMERO DO ITEM NO PEDIDO
					   ,[CLASSIFICACAO]				--NCM						*NULO
					   ,[CST]						--(ORIGEM + CST ICMS)		*NULO
					   ,[UN]						--UNIDADE MEDIDA
					   ,[PESO_UNI]					--PESO UNITARIO				*NULO
					   ,[IPI]						--ALIQ. IPI EX. 15.00
					   ,[ICM]						--ALIQ. ICMS EX. 18.00
					   ,[ID_CFO]					--ID FK CFOP
					   ,[DESC_CFO]					--DESCRIÇÃO CFOP			*NULO
					   ,[ID_ITEM_SC]				--ID FK ITEM SOLICITAÇÃO DE COMPRA
					   ,[LOTE]						--LOTE						*NULO
					   ,[QTD]						--QUANTIDADE DA NF
					   ,[VLR_UNT_X]					--VALOR UNITARIO			*NULO
					   ,[VLR_UNT_Y]					--VALOR UNITARIO			*NULO
					   ,[VLR_UNT]					--VALOR UNITARIO ITEM NF			
					   ,[TOTAL_ITEM]				--VALOR TOTAL ITEM NF (QTD * VLR_UNT)
					   ,[VLR_UNT_ICM_SUB]			--VALOR DA ST
					   ,[VLR_BASE_ICM_SUB]			--VALOR DA BASE DA ST
					   ,[VLR_FRETE]					--VALOR FRETE
					   ,[BSE_ICMS]					--VALOR DA BASE ICMS
					   ,[VLR_ICMS]					--VALOR DO ICMS
					   ,[VLRIPI]					--VALOR DO IPI
					   ,[ALIQ_PIS]					--ALIQ. PIS
					   ,[VLR_PIS]					--VALOR PIS
					   ,[ALIQ_COFINS]				--ALIQ. COFINS
					   ,[VLR_COFINS]				--VALOR COFINS
					   ,[ORIGEM]					--ORIGEM DA MERCADORIA
					   ,[CST_ICMS]					--CST ICMS
					   ,[CST_IPI]					--CST IPI
					   ,[CST_PIS]					--CST PIS
					   ,[CST_COFINS]				--CST COFINS
					   ,[Desconto]					--DESCONTO ITEM NF
					   ,[AliqRetPis]				--ALIQ. RETENÇÃO PIS
					   ,[ValorRetPis]				--VALOR RETENÇÃO PIS
					   ,[AliqRetCofins]				--ALIQ. RETENÇÃO COFINS
					   ,[ValorRetCofins]			--VALOR RETENÇÃO COFINS
					   ,[FCI]						--FCI						*NULO
					   ,[MotDesIcms]				--MOTIVO DESONERAÇÃO DO ICMS
					   ,[DesonVlrIcms]				--VALOR DESONERAÇÃO DO ICMS
					   ,[BseSubTrib]				--BASE SUBSTITUIÇÃO
					   ,[AliqSubTrib]				--ALIQ. SUBSTITUIÇÃO
					   ,[VlrSubTrib]				--VALOR SUBSTITUIÇÃO
					   ,[AliqIVA]					--ALIQ. IVA
					   ,[AliqIRRF]					--ALIQ. IRRF
					   ,[VlrRetIRRF]				--VALOR RETENÇÃO DO IRRF
					   ,[AliqISS]					--ALIQ. ISS
					   ,[VlrRetISS]					--VALOR RETENÇÃO DO ISS
					   ,[AliqINSS]					--ALIQ. INSS
					   ,[VlrRetINSS]				--VALOR RETENÇÃO DO INSS
					   ,[AliqCSLL]					--ALIQ. CSLL
					   ,[VlrRetCSLL]				--VALOR RETENÇÃO DO CSLL
					   ,[NotaOrigDev]				--NOTA ORIGEM DEVOLUÇÃO		*NULO
					   ,[NotaSerDev]				--NOTA SERVIÇO DEVOLUÇÃO	*NULO
					   ,[NotaIteDev]				--NOTA ITEM DEVOLUÇÃO		*NULO
					   ,[NotaQdeDev]				--NOTA QUANTIDADE DEVOLVIDA	*NULO
					   ,[NotaVlrDev]				--NOTA VALOR DEVOLVIDO		*NULO
					   ,[CustoMerc]					--CUSTO DA MERCADORIA		*NULO
					   ,[ChvDev]					--CHAVE DA NF DEVOLVIDA		*NULO
					   ,[idCFO]						--ID FK CFOP NOTA ORIGEM    *NULO
					   ,[IsServico])				--SE FOR SERVIÇO "TRUE" / CASO MERCADORIA "FALSE"
			SELECT	@ID_ITEM_NOTA_COMPRA	AS ID_ITEM_NOTA_COMPRA,		--ID ITEM NOTA PK
					CONVERT(INT, D1_ITEM)	AS ITEM,					--NUMERO DO ITEM DA NF
					@ID_NOTA_COMPRA			AS ID_NOTA_COMPRA,			--ID FK DA NOTA COMPRA
					ID_MATERIAL,				--ID FK DO MATEIRAL
					NULL					AS QTD_PEDIDA,				--QUANTIDADE PEDIDA			*NULO
					NULL					AS QTD_ENTREGUE,			--QUANTIDADE ENTREGUE		*NULO
					D1_FORNECE				AS CODIGO_FORNECEDOR,		--CÓDIGO DO FORNECEODR		*NULO
					B.CODIGO				AS CATALOGO,				--CÓDIGO DO MATERIAL
					-1						AS ID_PEDIDO,				--ID FK DO PEDIDO (solicitado pelo Fernando colocar valor fixo -1)
					NULL					AS NRO_PED_COMPRA,			--NUMERO DE PEDIDO COMPRA	*NULO
					B.DESCRICAO,											--DESCRIÇÃO DO ITEM
					NULL					AS CF,						--CLASSIFICAÇÃO FISCAL		*NULO
					1						AS PEDIDO_ITEM,				--NUMERO DO ITEM NO PEDIDO
					NULL					AS CLASSIFICACAO,			--NCM						*NULO
					NULL					AS CST,						--(ORIGEM + CST ICMS)		*NULO
					UN,													--UNIDADE MEDIDA
					NULL					AS PESO_UNI,				--PESO UNITARIO				*NULO
					D1_IPI					AS IPI,						--ALIQ. IPI EX. 15.00
					D1_PICM					AS ICM,						--ALIQ. ICMS EX. 18.00
					NULL					AS ID_CFO,					--ID FK CFOP
					NULL					AS DESC_CFO,				--DESCRIÇÃO CFOP			*NULO
					NULL					AS ID_ITEM_SC,				--ID FK ITEM SOLICITAÇÃO DE COMPRA
					NULL					AS LOTE,					--LOTE						*NULO
					D1_QUANT				AS QTD,						--QUANTIDADE DA NF
					NULL					AS VLR_UNT_X,				--VALOR UNITARIO			*NULO
					NULL					AS VLR_UNT_Y,				--VALOR UNITARIO			*NULO
					D1_VUNIT				AS VLR_UNT,					--VALOR UNITARIO ITEM NF			
					D1_TOTAL				AS TOTAL_ITEM,				--VALOR TOTAL ITEM NF (QTD * VLR_UNT)
					NULL					AS VLR_UNT_ICM_SUB,			--VALOR DA ST
					NULL					AS VLR_BASE_ICM_SUB,		--VALOR DA BASE DA ST
					D1_VALFRE				AS VLR_FRETE,				--VALOR FRETE
					D1_BASEICM				AS BSE_ICMS,				--VALOR DA BASE ICMS
					D1_VALICM				AS VLR_ICMS,				--VALOR DO ICMS
					D1_VALIPI				AS VLRIPI,					--VALOR DO IPI
					D1_ALQPIS				AS ALIQ_PIS,				--ALIQ. PIS
					D1_VALPIS				AS VLR_PIS,					--VALOR PIS
					D1_ALQCOF				AS ALIQ_COFINS,				--ALIQ. COFINS
					D1_VALCOF				AS VLR_COFINS,				--VALOR COFINS
					0						AS ORIGEM,					--ORIGEM DA MERCADORIA
					D1_CSTICM				AS CST_ICMS,				--CST ICMS
					D1_CSTIPI				AS CST_IPI,					--CST IPI
					D1_CSTPIS				AS CST_PIS,					--CST PIS
					D1_CSTCOF				AS CST_COFINS,				--CST COFINS
					D1_DESC					AS Desconto,				--DESCONTO ITEM NF
					NULL					AS AliqRetPis,				--ALIQ. RETENÇÃO PIS
					NULL					AS ValorRetPis,				--VALOR RETENÇÃO PIS
					NULL					AS AliqRetCofins,			--ALIQ. RETENÇÃO COFINS
					NULL					AS ValorRetCofins,			--VALOR RETENÇÃO COFINS
					NULL					AS FCI,						--FCI						*NULO
					NULL					AS MotDesIcms,				--MOTIVO DESONERAÇÃO DO ICMS
					NULL					AS DesonVlrIcms,			--VALOR DESONERAÇÃO DO ICMS
					NULL					AS BseSubTrib,				--BASE SUBSTITUIÇÃO
					NULL					AS AliqSubTrib,				--ALIQ. SUBSTITUIÇÃO
					NULL					AS VlrSubTrib,				--VALOR SUBSTITUIÇÃO
					NULL					AS AliqIVA,					--ALIQ. IVA
					D1_ALIQIRR				AS AliqIRRF,				--ALIQ. IRRF
					NULL					AS VlrRetIRRF,				--VALOR RETENÇÃO DO IRRF
					D1_ALIQISS				AS AliqISS,					--ALIQ. ISS
					NULL					AS VlrRetISS,				--VALOR RETENÇÃO DO ISS
					D1_ALIQINS				AS AliqINSS,					--ALIQ. INSS
					NULL					AS VlrRetINSS,				--VALOR RETENÇÃO DO INSS
					NULL					AS AliqCSLL,				--ALIQ. CSLL
           			NULL					AS VlrRetCSLL,				--VALOR RETENÇÃO DO CSLL
           			NULL					AS NotaOrigDev,				--NOTA ORIGEM DEVOLUÇÃO		*NULO
           			NULL					AS NotaSerDev,				--NOTA SERVIÇO DEVOLUÇÃO	*NULO
           			NULL					AS NotaIteDev,				--NOTA ITEM DEVOLUÇÃO		*NULO
           			NULL					AS NotaQdeDev,				--NOTA QUANTIDADE DEVOLVIDA	*NULO
           			NULL					AS NotaVlrDev,				--NOTA VALOR DEVOLVIDO		*NULO
           			NULL					AS CustoMerc,				--CUSTO DA MERCADORIA		*NULO
           			NULL					AS ChvDev,					--CHAVE DA NF DEVOLVIDA		*NULO
           			NULL					AS idCFO,					--ID FK CFOP NOTA ORIGEM    *NULO
           			NULL					AS IsServico				--SE FOR SERVIÇO "TRUE" / CASO MERCADORIA "FALSE"*/
			FROM SD1010 A
					INNER JOIN TPCP..MATERIAL B
						ON(    D1_COD  = CODIGO COLLATE Latin1_General_CI_AS
							AND A.D_E_L_E_T_ = '')
					INNER JOIN TPCP..UN_MEDIDA C
						ON(    B.ID_UN_MEDIDA = C.ID_UN_MEDIDA)
			WHERE A.R_E_C_N_O_ = @RECNO
			order by D1_ITEM

			--PEGA O ID DA NF
			SET	@ID_PILHA = (select max(ID_PILHA)+1 from TPCP..PILHA)
			
			--Insere Pilha
			INSERT INTO TPCP.dbo.PILHA
            ( [ID_PILHA]			--ID PK
             ,[ID_ITEM_NOTA_COMPRA]	--ID FK ITEM NOTA
             ,[ID_NOTA_COMPRA]		--ID FK NOTA COMPRA *NÃO OBRIGATORIO
             ,[QTD]					--QUANTIDADE PARCIAL
             ,[LOTE]				--LOTE
             ,[PILHA])				--PILHA É O LOTE APAGANDO AS LETRAS DEIXA OS 6 ULTIMO NUMERO
			select @ID_PILHA,
			       @ID_ITEM_NOTA_COMPRA,
                   @ID_NOTA_COMPRA,
				   D1_QUANT,     --QTD
				   Upper(D1_LOTEFOR),   --LOTE
				   convert(int, dbo.GetNumber(D1_LOTEFOR)) -- PILHA               int
			FROM SD1010 A
					INNER JOIN TPCP..MATERIAL B
						ON(    D1_COD  = CODIGO COLLATE Latin1_General_CI_AS
							AND A.D_E_L_E_T_ = '')
					INNER JOIN TPCP..UN_MEDIDA C
						ON(    B.ID_UN_MEDIDA = C.ID_UN_MEDIDA)
			WHERE A.R_E_C_N_O_ = @RECNO
			and   D1_LOTEFOR <> ''
			order by D1_ITEM

			PRINT CONVERT (VARCHAR(100), @@ROWCOUNT)+' REGISTROS DE PILHA'

		END
		ELSE
		BEGIN
			--PEGA O ID DA NF
			SET	@ID_ITEM_NOTA_COMPRA = (select max(ID_ITEM_NOTA_COMPRA)+1 from TESTE..ITEM_NOTA_COMPRA)

			INSERT INTO [TESTE].[dbo].[ITEM_NOTA_COMPRA]
					   ([ID_ITEM_NOTA_COMPRA]		--ID ITEM NOTA PK
					   ,[ITEM]						--NUMERO DO ITEM DA NF
					   ,[ID_NOTA_COMPRA]			--ID FK DA NOTA COMPRA
					   ,[ID_MATERIAL]				--ID FK DO MATEIRAL
					   ,[QTD_PEDIDA]				--QUANTIDADE PEDIDA			*NULO
					   ,[QTD_ENTREGUE]				--QUANTIDADE ENTREGUE		*NULO
					   ,[CODIGO_FORNECEDOR]			--CÓDIGO DO FORNECEODR		*NULO
					   ,[CATALOGO]					--CÓDIGO DO MATERIAL
					   ,[ID_PEDIDO]					--ID FK DO PEDIDO
					   ,[NRO_PED_COMPRA]			--NUMERO DE PEDIDO COMPRA	*NULO
					   ,[DESCRICAO]					--DESCRIÇÃO DO ITEM
					   ,[CF]						--CLASSIFICAÇÃO FISCAL		*NULO
					   ,[PEDIDO_ITEM]				--NUMERO DO ITEM NO PEDIDO
					   ,[CLASSIFICACAO]				--NCM						*NULO
					   ,[CST]						--(ORIGEM + CST ICMS)		*NULO
					   ,[UN]						--UNIDADE MEDIDA
					   ,[PESO_UNI]					--PESO UNITARIO				*NULO
					   ,[IPI]						--ALIQ. IPI EX. 15.00
					   ,[ICM]						--ALIQ. ICMS EX. 18.00
					   ,[ID_CFO]					--ID FK CFOP
					   ,[DESC_CFO]					--DESCRIÇÃO CFOP			*NULO
					   ,[ID_ITEM_SC]				--ID FK ITEM SOLICITAÇÃO DE COMPRA
					   ,[LOTE]						--LOTE						*NULO
					   ,[QTD]						--QUANTIDADE DA NF
					   ,[VLR_UNT_X]					--VALOR UNITARIO			*NULO
					   ,[VLR_UNT_Y]					--VALOR UNITARIO			*NULO
					   ,[VLR_UNT]					--VALOR UNITARIO ITEM NF			
					   ,[TOTAL_ITEM]				--VALOR TOTAL ITEM NF (QTD * VLR_UNT)
					   ,[VLR_UNT_ICM_SUB]			--VALOR DA ST
					   ,[VLR_BASE_ICM_SUB]			--VALOR DA BASE DA ST
					   ,[VLR_FRETE]					--VALOR FRETE
					   ,[BSE_ICMS]					--VALOR DA BASE ICMS
					   ,[VLR_ICMS]					--VALOR DO ICMS
					   ,[VLRIPI]					--VALOR DO IPI
					   ,[ALIQ_PIS]					--ALIQ. PIS
					   ,[VLR_PIS]					--VALOR PIS
					   ,[ALIQ_COFINS]				--ALIQ. COFINS
					   ,[VLR_COFINS]				--VALOR COFINS
					   ,[ORIGEM]					--ORIGEM DA MERCADORIA
					   ,[CST_ICMS]					--CST ICMS
					   ,[CST_IPI]					--CST IPI
					   ,[CST_PIS]					--CST PIS
					   ,[CST_COFINS]				--CST COFINS
					   ,[Desconto]					--DESCONTO ITEM NF
					   ,[AliqRetPis]				--ALIQ. RETENÇÃO PIS
					   ,[ValorRetPis]				--VALOR RETENÇÃO PIS
					   ,[AliqRetCofins]				--ALIQ. RETENÇÃO COFINS
					   ,[ValorRetCofins]			--VALOR RETENÇÃO COFINS
					   ,[FCI]						--FCI						*NULO
					   ,[MotDesIcms]				--MOTIVO DESONERAÇÃO DO ICMS
					   ,[DesonVlrIcms]				--VALOR DESONERAÇÃO DO ICMS
					   ,[BseSubTrib]				--BASE SUBSTITUIÇÃO
					   ,[AliqSubTrib]				--ALIQ. SUBSTITUIÇÃO
					   ,[VlrSubTrib]				--VALOR SUBSTITUIÇÃO
					   ,[AliqIVA]					--ALIQ. IVA
					   ,[AliqIRRF]					--ALIQ. IRRF
					   ,[VlrRetIRRF]				--VALOR RETENÇÃO DO IRRF
					   ,[AliqISS]					--ALIQ. ISS
					   ,[VlrRetISS]					--VALOR RETENÇÃO DO ISS
					   ,[AliqINSS]					--ALIQ. INSS
					   ,[VlrRetINSS]				--VALOR RETENÇÃO DO INSS
					   ,[AliqCSLL]					--ALIQ. CSLL
					   ,[VlrRetCSLL]				--VALOR RETENÇÃO DO CSLL
					   ,[NotaOrigDev]				--NOTA ORIGEM DEVOLUÇÃO		*NULO
					   ,[NotaSerDev]				--NOTA SERVIÇO DEVOLUÇÃO	*NULO
					   ,[NotaIteDev]				--NOTA ITEM DEVOLUÇÃO		*NULO
					   ,[NotaQdeDev]				--NOTA QUANTIDADE DEVOLVIDA	*NULO
					   ,[NotaVlrDev]				--NOTA VALOR DEVOLVIDO		*NULO
					   ,[CustoMerc]					--CUSTO DA MERCADORIA		*NULO
					   ,[ChvDev]					--CHAVE DA NF DEVOLVIDA		*NULO
					   ,[idCFO]						--ID FK CFOP NOTA ORIGEM    *NULO
					   ,[IsServico])				--SE FOR SERVIÇO "TRUE" / CASO MERCADORIA "FALSE"
			SELECT	@ID_ITEM_NOTA_COMPRA	AS ID_ITEM_NOTA_COMPRA,		--ID ITEM NOTA PK
					CONVERT(INT, D1_ITEM)	AS ITEM,					--NUMERO DO ITEM DA NF
					@ID_NOTA_COMPRA			AS ID_NOTA_COMPRA,			--ID FK DA NOTA COMPRA
					ID_MATERIAL,				--ID FK DO MATEIRAL
					NULL					AS QTD_PEDIDA,				--QUANTIDADE PEDIDA			*NULO
					NULL					AS QTD_ENTREGUE,			--QUANTIDADE ENTREGUE		*NULO
					D1_FORNECE				AS CODIGO_FORNECEDOR,		--CÓDIGO DO FORNECEODR		*NULO
					B.CODIGO				AS CATALOGO,				--CÓDIGO DO MATERIAL
					-1						AS ID_PEDIDO,				--ID FK DO PEDIDO (solicitado pelo Fernando colocar valor fixo -1)
					NULL					AS NRO_PED_COMPRA,			--NUMERO DE PEDIDO COMPRA	*NULO
					B.DESCRICAO,											--DESCRIÇÃO DO ITEM
					NULL					AS CF,						--CLASSIFICAÇÃO FISCAL		*NULO
					1						AS PEDIDO_ITEM,				--NUMERO DO ITEM NO PEDIDO
					NULL					AS CLASSIFICACAO,			--NCM						*NULO
					NULL					AS CST,						--(ORIGEM + CST ICMS)		*NULO
					UN,													--UNIDADE MEDIDA
					NULL					AS PESO_UNI,				--PESO UNITARIO				*NULO
					D1_IPI					AS IPI,						--ALIQ. IPI EX. 15.00
					D1_PICM					AS ICM,						--ALIQ. ICMS EX. 18.00
					NULL					AS ID_CFO,					--ID FK CFOP
					NULL					AS DESC_CFO,				--DESCRIÇÃO CFOP			*NULO
					NULL					AS ID_ITEM_SC,				--ID FK ITEM SOLICITAÇÃO DE COMPRA
					NULL					AS LOTE,					--LOTE						*NULO
					D1_QUANT				AS QTD,						--QUANTIDADE DA NF
					NULL					AS VLR_UNT_X,				--VALOR UNITARIO			*NULO
					NULL					AS VLR_UNT_Y,				--VALOR UNITARIO			*NULO
					D1_VUNIT				AS VLR_UNT,					--VALOR UNITARIO ITEM NF			
					D1_TOTAL				AS TOTAL_ITEM,				--VALOR TOTAL ITEM NF (QTD * VLR_UNT)
					NULL					AS VLR_UNT_ICM_SUB,			--VALOR DA ST
					NULL					AS VLR_BASE_ICM_SUB,		--VALOR DA BASE DA ST
					D1_VALFRE				AS VLR_FRETE,				--VALOR FRETE
					D1_BASEICM				AS BSE_ICMS,				--VALOR DA BASE ICMS
					D1_VALICM				AS VLR_ICMS,				--VALOR DO ICMS
					D1_VALIPI				AS VLRIPI,					--VALOR DO IPI
					D1_ALQPIS				AS ALIQ_PIS,				--ALIQ. PIS
					D1_VALPIS				AS VLR_PIS,					--VALOR PIS
					D1_ALQCOF				AS ALIQ_COFINS,				--ALIQ. COFINS
					D1_VALCOF				AS VLR_COFINS,				--VALOR COFINS
					0						AS ORIGEM,					--ORIGEM DA MERCADORIA
					D1_CSTICM				AS CST_ICMS,				--CST ICMS
					D1_CSTIPI				AS CST_IPI,					--CST IPI
					D1_CSTPIS				AS CST_PIS,					--CST PIS
					D1_CSTCOF				AS CST_COFINS,				--CST COFINS
					D1_DESC					AS Desconto,				--DESCONTO ITEM NF
					NULL					AS AliqRetPis,				--ALIQ. RETENÇÃO PIS
					NULL					AS ValorRetPis,				--VALOR RETENÇÃO PIS
					NULL					AS AliqRetCofins,			--ALIQ. RETENÇÃO COFINS
					NULL					AS ValorRetCofins,			--VALOR RETENÇÃO COFINS
					NULL					AS FCI,						--FCI						*NULO
					NULL					AS MotDesIcms,				--MOTIVO DESONERAÇÃO DO ICMS
					NULL					AS DesonVlrIcms,			--VALOR DESONERAÇÃO DO ICMS
					NULL					AS BseSubTrib,				--BASE SUBSTITUIÇÃO
					NULL					AS AliqSubTrib,				--ALIQ. SUBSTITUIÇÃO
					NULL					AS VlrSubTrib,				--VALOR SUBSTITUIÇÃO
					NULL					AS AliqIVA,					--ALIQ. IVA
					D1_ALIQIRR				AS AliqIRRF,				--ALIQ. IRRF
					NULL					AS VlrRetIRRF,				--VALOR RETENÇÃO DO IRRF
					D1_ALIQISS				AS AliqISS,					--ALIQ. ISS
					NULL					AS VlrRetISS,				--VALOR RETENÇÃO DO ISS
					D1_ALIQINS				AS AliqINSS,					--ALIQ. INSS
					NULL					AS VlrRetINSS,				--VALOR RETENÇÃO DO INSS
					NULL					AS AliqCSLL,				--ALIQ. CSLL
           			NULL					AS VlrRetCSLL,				--VALOR RETENÇÃO DO CSLL
           			NULL					AS NotaOrigDev,				--NOTA ORIGEM DEVOLUÇÃO		*NULO
           			NULL					AS NotaSerDev,				--NOTA SERVIÇO DEVOLUÇÃO	*NULO
           			NULL					AS NotaIteDev,				--NOTA ITEM DEVOLUÇÃO		*NULO
           			NULL					AS NotaQdeDev,				--NOTA QUANTIDADE DEVOLVIDA	*NULO
           			NULL					AS NotaVlrDev,				--NOTA VALOR DEVOLVIDO		*NULO
           			NULL					AS CustoMerc,				--CUSTO DA MERCADORIA		*NULO
           			NULL					AS ChvDev,					--CHAVE DA NF DEVOLVIDA		*NULO
           			NULL					AS idCFO,					--ID FK CFOP NOTA ORIGEM    *NULO
           			NULL					AS IsServico				--SE FOR SERVIÇO "TRUE" / CASO MERCADORIA "FALSE"*/
			FROM SD1010 A
					INNER JOIN TESTE..MATERIAL B
						ON(    D1_COD  = CODIGO COLLATE Latin1_General_CI_AS
							AND A.D_E_L_E_T_ = '')
					INNER JOIN TESTE..UN_MEDIDA C
						ON(    B.ID_UN_MEDIDA = C.ID_UN_MEDIDA)
			WHERE A.R_E_C_N_O_ = @RECNO
			order by D1_ITEM

			--PEGA O ID DA NF
			SET	@ID_PILHA = (select max(ID_PILHA)+1 from TESTE..PILHA)
			
			--Insere Pilha
			INSERT INTO TESTE.dbo.PILHA
            ( [ID_PILHA]				--ID PK
             ,[ID_ITEM_NOTA_COMPRA]	--ID FK ITEM NOTA
             ,[ID_NOTA_COMPRA]		--ID FK NOTA COMPRA *NÃO OBRIGATORIO
             ,[QTD]					--QUANTIDADE PARCIAL
             ,[LOTE]				--LOTE
             ,[PILHA])				--PILHA É O LOTE APAGANDO AS LETRAS DEIXA OS 6 ULTIMO NUMERO
			select @ID_PILHA,
			       @ID_ITEM_NOTA_COMPRA,
                   @ID_NOTA_COMPRA,
				   D1_QUANT,     --QTD
				   Upper(D1_LOTEFOR),   --LOTE
				   convert(int, dbo.GetNumber(D1_LOTEFOR)) -- PILHA               int
			FROM SD1010 A
					INNER JOIN TESTE..MATERIAL B
						ON(    D1_COD  = CODIGO COLLATE Latin1_General_CI_AS
							AND A.D_E_L_E_T_ = '')
					INNER JOIN TESTE..UN_MEDIDA C
						ON(    B.ID_UN_MEDIDA = C.ID_UN_MEDIDA)
			WHERE A.R_E_C_N_O_ = @RECNO
			and   D1_LOTEFOR <> ''
			order by D1_ITEM

			PRINT CONVERT (VARCHAR(100), @@ROWCOUNT)+' REGISTROS DE PILHA'


		END

	commit
	-- INSERÇÃO DOS ITENS
	SET NOCOUNT ON;  

End
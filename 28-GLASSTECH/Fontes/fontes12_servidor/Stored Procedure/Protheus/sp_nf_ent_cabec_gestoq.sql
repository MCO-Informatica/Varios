GO
/****** Object:  StoredProcedure [dbo].[sp_mov_gestoq]    Script Date: 15/02/2021 16:48:11 

select * 
FROM SF1010
WHERE F1_DOC     = '000286730'
AND   F1_FILIAL  = '0101'
AND   F1_SERIE   = '2  '
AND   F1_FORNECE = '018483'
AND   F1_LOJA	 = '01'
AND   D_E_L_E_T_ = ''

select * from sigamat 

begin tran
	declare @id_nf as int

	exec sp_nf_ent_cabec_gestoq '0101', '000004321', 'A  ', '023313', '01', '48254858000109', 0, @id_nf out

	select @id_nf

	select * from teste..NOTA_COMPRA
	WHERE ID_NOTA_COMPRA =  @id_nf
rollback

	select * from teste..NOTA_COMPRA
	WHERE ID_NOTA_COMPRA =  58314

	302445

INSERT INTO TESTE..CLIENTE
select * from TPCP..CLIENTE
WHERE ID_CLIENTE = 023534


select CPFCGC, * from tpcp..CLIENTE
WHERE ID_CLIENTE = 023534

select  * from teste..CLIENTE
WHERE ID_CLIENTE = 023313

select * from SC7010
WHERE C7_NUM = '073188'

UPDATE SC7010
SET c7_fornece = '023313'
WHERE C7_NUM = '073188'

select A.ID_NOTA_COMPRA, *
FROM TESTE.DBO.NOTA_COMPRA A
		INNER JOIN TESTE.DBO.ITEM_NOTA_COMPRA B
			ON(    A.ID_NOTA_COMPRA = B.ID_NOTA_COMPRA)
where NRO_NF     = 1234
and   SERIE      = 'A'
AND   ID_CLIENTE = 023313
******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter Procedure [dbo].[sp_nf_ent_cabec_gestoq]( 
	@F1_FILIAL		char(4), 
	@F1_DOC			char(9), 
	@F1_SERIE		char(3),  
	@F1_FORNECE		char(6),
	@F1_LOJA		char(2),
	@CGC_EMP		char(20),
	@AMBPRD			smallint,
	@ID_NOTA_COMPRA	int out
)
As
Begin

	--CABEÇALHO DA NF
	DECLARE @POS				AS varchar(1)
	DECLARE @ID_CLIENTE			AS int
	DECLARE @E_S				AS char(1)
	DECLARE @ID_CONDPAG			AS int
	DECLARE @DESC_CONDPAG		AS varchar(60)
	DECLARE @NRO_NF				AS int
	DECLARE @ID_TITULO			AS int
	DECLARE @SERIE				AS varchar(12)
	DECLARE @EMISSAO			AS datetime
	DECLARE @SAIDA				AS datetime
	DECLARE @PLACA				AS varchar(10)
	DECLARE @UF_PLACA			AS varchar(5)
	DECLARE @FRETE				AS int
	DECLARE @CFO				AS varchar(35)
	DECLARE @ALIQ_ICM			AS numeric(5,2)
	DECLARE @REDUCAO_ICM		AS numeric(10,2)
	DECLARE @BASE_CALC_SUB_ICM	AS numeric(10,2)
	DECLARE @VLR_ICM_SUB		AS numeric(10,2)
	DECLARE @VLR_FRETE			AS numeric(10,2)
	DECLARE @VLR_SEGURO			AS numeric(10,2)
	DECLARE @OUTRAS_DESP		AS numeric(10,2)
	DECLARE @VLR_IPI			AS numeric(10,2)
	DECLARE @VLR_TOT_NOTA		AS numeric(10,2)
	DECLARE @VLR_TOT_SERV		AS numeric(10,2)
	DECLARE @ALIQ_ISS			AS numeric(5,2)
	DECLARE @VLR_ISS			AS numeric(10,2)
	DECLARE @PESO_BRUTO			AS float
	DECLARE @DESC_CORPO_PROD	AS float
	DECLARE @DESC_CORPO_SERV	AS float
	DECLARE @RAZAO_SOCIAL		AS varchar(50)
	DECLARE @INSC_MUNICIPAL		AS varchar(35)
	DECLARE @CNPJ				AS varchar(35)
	DECLARE @INSC_EST			AS varchar(35)
	DECLARE @ENDERECO			AS varchar(50)
	DECLARE @BAIRRO				AS varchar(50)
	DECLARE @CEP				AS varchar(13)
	DECLARE @TRANSPORTADOR		AS varchar(50)
	DECLARE @MUNICIPIO			AS varchar(50)
	DECLARE @FONE				AS varchar(35)
	DECLARE @END_TRANSP			AS varchar(50)
	DECLARE @UF					AS varchar(2)
	DECLARE @CID_TRANSP			AS varchar(50)
	DECLARE @UF_TRANSP			AS varchar(2)
	DECLARE @INSC_TRANSP		AS varchar(35)
	DECLARE @CNPJ_TRANSP		AS varchar(35)
	DECLARE @CID_ENTREGA		AS varchar(50)
	DECLARE @END_ENTREGA		AS varchar(50)
	DECLARE @BAIRRO_ENTREGA		AS varchar(50)
	DECLARE @CEP_ENTREGA		AS varchar(13)
	DECLARE @UF_ENTREGA			AS varchar(2)
	DECLARE @ID_EMPRESA			AS int
	DECLARE @MOV_EST			AS char(1)
	DECLARE @GERA_RECEITA		AS char(1)
	DECLARE @PED_NOSSO			AS varchar(35)
	DECLARE @COD_CFO			AS varchar(10)
	DECLARE @ENTRADA			AS datetime
	DECLARE @ID_CFO				AS int
	DECLARE @ID_MOTIVO			AS int
	DECLARE @BASE_ICM_X			AS numeric(12,2)
	DECLARE @BASE_ICM			AS numeric(12,2)
	DECLARE @VLR_ICM_X			AS numeric(12,2)
	DECLARE @VLR_ICM			AS numeric(12,2)
	DECLARE @VLR_TOT_PROD_X		AS numeric(12,2)
	DECLARE @VLR_TOT_PROD		AS numeric(12,2)
	DECLARE @NRO_NOTA_COMPRA	AS int
	DECLARE @LOGIN				AS char(12)
	DECLARE @peso_liq_x			AS numeric(15,4)
	DECLARE @peso_liq			AS numeric(15,4)
	DECLARE @CONSIGNADO			AS char(1)
	DECLARE @CHAVE_NFE			AS varchar(44)
	DECLARE @AprovacaoGuiaRosa	AS bit
	DECLARE @Desconto			AS numeric(12,2)
	DECLARE @BseIcms			AS numeric(12,2)
	DECLARE @VlrIcms			AS numeric(12,2)
	DECLARE @VlrIpi				AS numeric(12,2)
	DECLARE @ValorRetPis		AS numeric(12,2)
	DECLARE @ValorRetCofins		AS numeric(12,2)
	DECLARE @BseSubTrib			AS numeric(12,2)
	DECLARE @VlrSubTrib			AS numeric(12,2)
	DECLARE @DesonVlrIcms		AS numeric(12,2)
	DECLARE @VlrIrrf			AS numeric(12,2)
	DECLARE @AliqIRRF			AS numeric(5,2)
	DECLARE @VlrINSS			AS numeric(12,2)
	DECLARE @VlrISS				AS numeric(12,2)
	DECLARE @AliqISS			AS numeric(5,2)
	DECLARE @VlrCSLL			AS numeric(12,2)
	DECLARE @AliqCSLL			AS numeric(5,2)
	DECLARE @VlrPis				AS numeric(12,2)
	DECLARE @AliqPis			AS numeric(5,2)
	DECLARE @VlrCofins			AS numeric(12,2)
	DECLARE @AliqCofins			AS numeric(5,2)
	DECLARE @DATA_CANCEL		AS datetime
	DECLARE @CANCELADO_POR		AS varchar(40)
	DECLARE @RECNO				AS INT

	BEGIN TRAN

		exec sp_nf_ent_exclui_gestoq @F1_FILIAL, @F1_DOC, @F1_SERIE, @F1_FORNECE, @F1_LOJA, @CGC_EMP, @AMBPRD

		-- ARMAZENA OS DADOS - FOI FEITO DESSA FORMA PARA FACILITAR EVENTUAIS NOVOS CAMPOS
		SELECT	@POS				= 'G',
				@ID_CLIENTE			= CONVERT(INT, F1_FORNECE),
				@E_S				= 'E',
				@ID_CONDPAG			= 0,
				@DESC_CONDPAG		= NULL,
				@NRO_NF				= CONVERT(INT, F1_DOC),
				@ID_TITULO			= NULL,
				@SERIE				= F1_SERIE,
				@EMISSAO			= CONVERT(DATETIME, F1_EMISSAO),
				@SAIDA				= CONVERT(DATETIME, F1_EMISSAO),
				@PLACA				= NULL,
				@UF_PLACA			= NULL,
				@FRETE				= NULL,
				@CFO				= NULL,
				@ALIQ_ICM			= F1_ICMS,
				@REDUCAO_ICM		= F1_ICMSRET,
				@BASE_CALC_SUB_ICM	= NULL,
				@VLR_ICM_SUB		= NULL,
				@VLR_FRETE			= F1_FRETE,
				@VLR_SEGURO			= F1_SEGURO,
				@OUTRAS_DESP		= NULL,
				@VLR_IPI			= F1_IPI,
				@VLR_TOT_NOTA		= F1_VALBRUT,
				@VLR_TOT_SERV		= NULL,
				@ALIQ_ISS			= F1_ISS,
				@VLR_ISS			= NULL,
				@PESO_BRUTO			= F1_PBRUTO,
				@DESC_CORPO_PROD	= NULL,
				@DESC_CORPO_SERV	= NULL,
				@RAZAO_SOCIAL		= NULL,
				@INSC_MUNICIPAL		= NULL,
				@CNPJ				= NULL,
				@INSC_EST			= NULL,
				@ENDERECO			= NULL,
				@BAIRRO				= NULL,
				@CEP				= NULL,
				@TRANSPORTADOR		= NULL,
				@MUNICIPIO			= NULL,
				@FONE				= NULL,
				@END_TRANSP			= NULL,
				@UF					= NULL,
				@CID_TRANSP			= NULL,
				@UF_TRANSP			= NULL,
				@INSC_TRANSP		= NULL,
				@CNPJ_TRANSP		= NULL,
				@CID_ENTREGA		= NULL,
				@END_ENTREGA		= NULL,
				@BAIRRO_ENTREGA		= NULL,
				@CEP_ENTREGA		= NULL,
				@UF_ENTREGA			= NULL,
				@MOV_EST			= 'N',
				@GERA_RECEITA		= 'N',
				@PED_NOSSO			= 'N',
				@COD_CFO			= 'N',
				@ENTRADA			= CONVERT(DATETIME, F1_DTDIGIT),
				@ID_CFO				= NULL,
				@ID_MOTIVO			= NULL,
				@BASE_ICM_X			= F1_BASEICM,
				@BASE_ICM			= F1_BASEICM,
				@VLR_ICM_X			= F1_VALICM,
				@VLR_ICM			= F1_VALICM,
				@VLR_TOT_PROD_X		= F1_VALMERC,
				@VLR_TOT_PROD		= F1_VALMERC,
				@NRO_NOTA_COMPRA	= NULL,
				@LOGIN				= NULL,
				@peso_liq_x			= F1_PLIQUI,
				@peso_liq			= F1_PLIQUI,
				@CONSIGNADO			= 'N',
				@CHAVE_NFE			= NULL,
				@AprovacaoGuiaRosa	= 0,
				@Desconto			= F1_DESCONT,
				@BseIcms			= F1_BASEICM,
				@VlrIcms			= F1_VALICM,
				@VlrIpi				= F1_IPI,
				@ValorRetPis		= NULL,
				@ValorRetCofins		= NULL,
				@BseSubTrib			= NULL,
				@VlrSubTrib			= NULL,
				@DesonVlrIcms		= NULL,
				@VlrIrrf			= F1_IRRF,
				@AliqIRRF			= NULL,
				@VlrINSS			= F1_INSS,
				@VlrISS				= F1_ISS,
				@AliqISS			= NULL,
				@VlrCSLL			= F1_VALCSLL,
				@AliqCSLL			= NULL,
				@VlrPis				= F1_VALPIS,
				@AliqPis			= 0 ,
				@VlrCofins			= F1_VALCOFI,
				@AliqCofins			= NULL,
				@DATA_CANCEL		= NULL,
				@CANCELADO_POR		= NULL,
				@RECNO				= R_E_C_N_O_
		FROM SF1010
		WHERE F1_DOC     = @F1_DOC
		AND   F1_FILIAL  = @F1_FILIAL
		AND   F1_SERIE   = @F1_SERIE
		AND   F1_FORNECE = @F1_FORNECE
		AND   F1_LOJA	 = @F1_LOJA
		AND   D_E_L_E_T_ = ''

		--DIRECIONA PARA AS BASES DE PROD OU TESTE - POR ESSE MOTIVO O QUE FOR ALTERADO PARA A PROD, DEVE SER REPLICADO PARA A TESTE
		--TPCP	= AMBIENTE DE PRODUÇÃO
		--TESTE	= TESTE
		IF @AMBPRD = 1
		BEGIN

			--PEGA O ID DA EMPRESA
			select @ID_EMPRESA = ID_EMPRESA 
			from TPCP..EMPRESA
			WHERE REPLACE(REPLACE(REPLACE(REPLACE(CGC, '.', ''), '/', ''), '/', ''), '-', '')  = @CGC_EMP
			AND   ID_EMPRESA <> 999

			print 'ID_EMPRESA GESTOQ'+Convert(varchar(100), @ID_EMPRESA)

			--PEGA O ID DA NF
			SET	@ID_NOTA_COMPRA	= (select max(ID_NOTA_COMPRA)+1 from TPCP..NOTA_COMPRA)

			print '@ID_NOTA_COMPRA GESTOQ'+Convert(varchar(100), @ID_NOTA_COMPRA)

			--INSERT NOTA_COMPRA
			INSERT INTO [TPCP].[dbo].[NOTA_COMPRA]
					   ([ID_NOTA_COMPRA]				--ID PK NOTA COMPRA
					   ,[POS]							--G [G-GERADA|C-CANCELADA|D-DEVOLVIDA]
					   ,[ID_CLIENTE]					--ID FK CLIENTE/FORNECEDOR
					   ,[E_S]							--E [E-ENTRADA|S-SAIDA]
					   ,[ID_CONDPAG]					--ID FK CONDIÇÃO DE PAGAMENTO
					   ,[DESC_CONDPAG]					--DESCRIÇÃO DE CONDIÇÃO DE PAGAMENTO *NULO
					   ,[NRO_NF]						--NUMERO DA NFE
					   ,[ID_TITULO]						--ID FK TITULO						 *NULO
					   ,[SERIE]							--SERIE
					   ,[EMISSAO]						--EMISSÃO DATA
					   ,[SAIDA]							--SAIDA DATA
					   ,[PLACA]							--PLACA								 *NULO
					   ,[UF_PLACA]						--UF PLACA							 *NULO
					   ,[FRETE]							--FRETE								 *NULO
					   ,[CFO]							-- CFOP DESCRIÇÃO
					   ,[ALIQ_ICM]						--ALIQ. ICMS
					   ,[REDUCAO_ICM]					--ALIQ. REDUÇÃO ICMS
					   ,[BASE_CALC_SUB_ICM]				--BASE SUB. TRIB.
					   ,[VLR_ICM_SUB]					--VALOR SUB. TRIB.
					   ,[VLR_FRETE]						-- VALOR FRETE
					   ,[VLR_SEGURO]					-- VALOR SEGURO
					   ,[OUTRAS_DESP]					-- OUTRAS DESPESAS
					   ,[VLR_IPI]						-- VALOR IPI
					   ,[VLR_TOT_NOTA]					-- VALOR TOTAL NOTA
					   ,[VLR_TOT_SERV]					-- VALOR TOTAL SERVIÇO
					   ,[ALIQ_ISS]						-- ALIQ. ISS
					   ,[VLR_ISS]						-- VALOR ISS
					   ,[PESO_BRUTO]					-- PESO BRUTO
					   ,[DESC_CORPO_PROD]				-- DESCONTO CORPO PRODUTO
					   ,[DESC_CORPO_SERV]				-- DESCONTO CORPO SERVIÇO
					   ,[RAZAO_SOCIAL]					-- DESTINATARIO
					   ,[INSC_MUNICIPAL]				-- DESTINATARIO
					   ,[CNPJ]							-- DESTINATARIO
					   ,[INSC_EST]						-- DESTINATARIO
					   ,[ENDERECO]						-- DESTINATARIO
					   ,[BAIRRO]						-- DESTINATARIO
					   ,[CEP]							-- DESTINATARIO
					   ,[TRANSPORTADOR]					-- TRANSPORTADOR
					   ,[MUNICIPIO]						-- DESTINATARIO
					   ,[FONE]							-- DESTINATARIO
					   ,[END_TRANSP]					-- TRANSPORTADOR
					   ,[UF]							-- DESTINATARIO
					   ,[CID_TRANSP]					-- TRANSPORTADOR
					   ,[UF_TRANSP]						-- TRANSPORTADOR
					   ,[INSC_TRANSP]					-- TRANSPORTADOR
					   ,[CNPJ_TRANSP]					-- TRANSPORTADOR
					   ,[CID_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[END_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[BAIRRO_ENTREGA]				-- ENDEREÇO ENTREGA
					   ,[CEP_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[UF_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[ID_EMPRESA]					-- ID FK EMPRESA
					   ,[MOV_EST]						-- MOVIMENTA ESTOQUE [S/N]
					   ,[GERA_RECEITA]					-- GERA FINANCEIRO [S/N]
					   ,[PED_NOSSO]						-- NUMERO DO NOSSO PEDIDO		*NULO				
					   ,[COD_CFO]						-- CODIGO CFOP					*NULO
					   ,[ENTRADA]						-- DATA DA ENTRADA
					   ,[ID_CFO]						-- ID FK CFOP					*NULO
					   ,[ID_MOTIVO]						-- MOTIVO CANCELAMENTO			*NULO
					   ,[BASE_ICM_X]					-- BASE ICMS X					*NULO
					   ,[BASE_ICM]						-- BASE ICMS					
					   ,[VLR_ICM_X]						-- VALOR ICMS X					*NULO
					   ,[VLR_ICM]						-- VALOR ICMS
					   ,[VLR_TOT_PROD_X]				-- VALOR TOTAL PRODUTO			*NULO
					   ,[VLR_TOT_PROD]					-- VALOR TOTAL PRODUTO
					   ,[NRO_NOTA_COMPRA]				-- NRO DA GR(GUIA RECEBIMENTO)
					   ,[LOGIN]							-- USUARIO DO SISTEMA
					   ,[peso_liq_x]					-- PESO LIQUIDO X				*NULO
					   ,[peso_liq]						-- PESO LIQUIDO
					   ,[CONSIGNADO]					-- CONSIGNADO					*'N'
					   ,[CHAVE_NFE]						-- CHAVE NFE
					   ,[AprovacaoGuiaRosa]				-- APROVAÇÃO GUIA ROSA			*0
					   ,[Desconto]						-- DESCONTO
					   ,[BseIcms]						-- BASE ICMS
					   ,[VlrIcms]						-- VALOR ICMS
					   ,[VlrIpi]						-- VALOR IPI
					   ,[ValorRetPis]					-- VALOR RETENÇÃO PIS
					   ,[ValorRetCofins]				-- VALOR RETENÇÃO COFINS
					   ,[BseSubTrib]					-- BASE SUB. TRIM.
					   ,[VlrSubTrib]					-- VALOR SUB. TRIB.
					   ,[DesonVlrIcms]					-- VALOR DESONERAÇÃO ICMS
					   ,[VlrIrrf]						-- VALOR IRRF
					   ,[AliqIRRF]						-- ALIQ. IRRF
					   ,[VlrINSS]						-- VAOR INSS
					   ,[VlrISS]						-- VALOR ISS
					   ,[AliqISS]						-- ALIQ. ISS
					   ,[VlrCSLL]						-- VALOR CSLL
					   ,[AliqCSLL]						-- ALIQ. CSLL
					   ,[VlrPis]						-- VALOR PIS
					   ,[AliqPis]						-- ALIQ. PIS
					   ,[VlrCofins]						-- VALOR COFINS
					   ,[AliqCofins]					-- ALIQ. COFINS
					   ,[DATA_CANCEL]					-- DATA CANCELAMENTO				  *NULO
					   ,[CANCELADO_POR])				-- USUARIO QUE EFETUOU O CANCELAMENTO *NULO
				 VALUES
					   (@ID_NOTA_COMPRA 	,
						@POS				,
						@ID_CLIENTE			,
						@E_S				,
						@ID_CONDPAG			,
						@DESC_CONDPAG		,
						@NRO_NF				,
						@ID_TITULO			,
						@SERIE				,
						@EMISSAO			,
						@SAIDA				,
						@PLACA				,
						@UF_PLACA			,
						@FRETE				,
						@CFO				,
						@ALIQ_ICM			,
						@REDUCAO_ICM		,
						@BASE_CALC_SUB_ICM	,
						@VLR_ICM_SUB		,
						@VLR_FRETE			,
						@VLR_SEGURO			,
						@OUTRAS_DESP		,
						@VLR_IPI			,
						@VLR_TOT_NOTA		,
						@VLR_TOT_SERV		,
						@ALIQ_ISS			,
						@VLR_ISS			,
						@PESO_BRUTO			,
						@DESC_CORPO_PROD	,
						@DESC_CORPO_SERV	,
						@RAZAO_SOCIAL		,
						@INSC_MUNICIPAL		,
						@CNPJ				,
						@INSC_EST			,
						@ENDERECO			,
						@BAIRRO				,
						@CEP				,
						@TRANSPORTADOR		,
						@MUNICIPIO			,
						@FONE				,
						@END_TRANSP			,
						@UF					,
						@CID_TRANSP			,
						@UF_TRANSP			,
						@INSC_TRANSP		,
						@CNPJ_TRANSP		,
						@CID_ENTREGA		,
						@END_ENTREGA		,
						@BAIRRO_ENTREGA		,
						@CEP_ENTREGA		,
						@UF_ENTREGA			,
						@ID_EMPRESA			,
						@MOV_EST			,
						@GERA_RECEITA		,
						@PED_NOSSO			,
						@COD_CFO			,
						@ENTRADA			,
						@ID_CFO				,
						@ID_MOTIVO			,
						@BASE_ICM_X			,
						@BASE_ICM			,
						@VLR_ICM_X			,
						@VLR_ICM			,
						@VLR_TOT_PROD_X		,
						@VLR_TOT_PROD		,
						@NRO_NOTA_COMPRA	,
						@LOGIN				,
						@peso_liq_x			,
						@peso_liq			,
						@CONSIGNADO			,
						@CHAVE_NFE			,
						@AprovacaoGuiaRosa	,
						@Desconto			,
						@BseIcms			,
						@VlrIcms			,
						@VlrIpi				,
						@ValorRetPis		,
						@ValorRetCofins		,
						@BseSubTrib			,
						@VlrSubTrib			,
						@DesonVlrIcms		,
						@VlrIrrf			,
						@AliqIRRF			,
						@VlrINSS			,
						@VlrISS				,
						@AliqISS			,
						@VlrCSLL			,
						@AliqCSLL			,
						@VlrPis				,
						@AliqPis			,
						@VlrCofins			,
						@AliqCofins			,
						@DATA_CANCEL		,
						@CANCELADO_POR	)
		END
		ELSE
		BEGIN

			--PEGA O ID DA EMPRESA
			select @ID_EMPRESA = ID_EMPRESA 
			from TESTE..EMPRESA
			WHERE REPLACE(REPLACE(REPLACE(REPLACE(CGC, '.', ''), '/', ''), '/', ''), '-', '')  = @CGC_EMP
			AND   ID_EMPRESA <> 999

			print 'ID_EMPRESA GESTOQ'+Convert(varchar(100), @ID_EMPRESA)

			--PEGA O ID DA NF
			SET	@ID_NOTA_COMPRA	= (select max(ID_NOTA_COMPRA)+1 from TESTE..NOTA_COMPRA)

			print '@ID_NOTA_COMPRA GESTOQ'+Convert(varchar(100), @ID_NOTA_COMPRA)

			--INSERT NOTA_COMPRA
			INSERT INTO [TESTE].[dbo].[NOTA_COMPRA]
					   ([ID_NOTA_COMPRA]				--ID PK NOTA COMPRA
					   ,[POS]							--G [G-GERADA|C-CANCELADA|D-DEVOLVIDA]
					   ,[ID_CLIENTE]					--ID FK CLIENTE/FORNECEDOR
					   ,[E_S]							--E [E-ENTRADA|S-SAIDA]
					   ,[ID_CONDPAG]					--ID FK CONDIÇÃO DE PAGAMENTO
					   ,[DESC_CONDPAG]					--DESCRIÇÃO DE CONDIÇÃO DE PAGAMENTO *NULO
					   ,[NRO_NF]						--NUMERO DA NFE
					   ,[ID_TITULO]						--ID FK TITULO						 *NULO
					   ,[SERIE]							--SERIE
					   ,[EMISSAO]						--EMISSÃO DATA
					   ,[SAIDA]							--SAIDA DATA
					   ,[PLACA]							--PLACA								 *NULO
					   ,[UF_PLACA]						--UF PLACA							 *NULO
					   ,[FRETE]							--FRETE								 *NULO
					   ,[CFO]							-- CFOP DESCRIÇÃO
					   ,[ALIQ_ICM]						--ALIQ. ICMS
					   ,[REDUCAO_ICM]					--ALIQ. REDUÇÃO ICMS
					   ,[BASE_CALC_SUB_ICM]				--BASE SUB. TRIB.
					   ,[VLR_ICM_SUB]					--VALOR SUB. TRIB.
					   ,[VLR_FRETE]						-- VALOR FRETE
					   ,[VLR_SEGURO]					-- VALOR SEGURO
					   ,[OUTRAS_DESP]					-- OUTRAS DESPESAS
					   ,[VLR_IPI]						-- VALOR IPI
					   ,[VLR_TOT_NOTA]					-- VALOR TOTAL NOTA
					   ,[VLR_TOT_SERV]					-- VALOR TOTAL SERVIÇO
					   ,[ALIQ_ISS]						-- ALIQ. ISS
					   ,[VLR_ISS]						-- VALOR ISS
					   ,[PESO_BRUTO]					-- PESO BRUTO
					   ,[DESC_CORPO_PROD]				-- DESCONTO CORPO PRODUTO
					   ,[DESC_CORPO_SERV]				-- DESCONTO CORPO SERVIÇO
					   ,[RAZAO_SOCIAL]					-- DESTINATARIO
					   ,[INSC_MUNICIPAL]				-- DESTINATARIO
					   ,[CNPJ]							-- DESTINATARIO
					   ,[INSC_EST]						-- DESTINATARIO
					   ,[ENDERECO]						-- DESTINATARIO
					   ,[BAIRRO]						-- DESTINATARIO
					   ,[CEP]							-- DESTINATARIO
					   ,[TRANSPORTADOR]					-- TRANSPORTADOR
					   ,[MUNICIPIO]						-- DESTINATARIO
					   ,[FONE]							-- DESTINATARIO
					   ,[END_TRANSP]					-- TRANSPORTADOR
					   ,[UF]							-- DESTINATARIO
					   ,[CID_TRANSP]					-- TRANSPORTADOR
					   ,[UF_TRANSP]						-- TRANSPORTADOR
					   ,[INSC_TRANSP]					-- TRANSPORTADOR
					   ,[CNPJ_TRANSP]					-- TRANSPORTADOR
					   ,[CID_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[END_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[BAIRRO_ENTREGA]				-- ENDEREÇO ENTREGA
					   ,[CEP_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[UF_ENTREGA]					-- ENDEREÇO ENTREGA
					   ,[ID_EMPRESA]					-- ID FK EMPRESA
					   ,[MOV_EST]						-- MOVIMENTA ESTOQUE [S/N]
					   ,[GERA_RECEITA]					-- GERA FINANCEIRO [S/N]
					   ,[PED_NOSSO]						-- NUMERO DO NOSSO PEDIDO		*NULO				
					   ,[COD_CFO]						-- CODIGO CFOP					*NULO
					   ,[ENTRADA]						-- DATA DA ENTRADA
					   ,[ID_CFO]						-- ID FK CFOP					*NULO
					   ,[ID_MOTIVO]						-- MOTIVO CANCELAMENTO			*NULO
					   ,[BASE_ICM_X]					-- BASE ICMS X					*NULO
					   ,[BASE_ICM]						-- BASE ICMS					
					   ,[VLR_ICM_X]						-- VALOR ICMS X					*NULO
					   ,[VLR_ICM]						-- VALOR ICMS
					   ,[VLR_TOT_PROD_X]				-- VALOR TOTAL PRODUTO			*NULO
					   ,[VLR_TOT_PROD]					-- VALOR TOTAL PRODUTO
					   ,[NRO_NOTA_COMPRA]				-- NRO DA GR(GUIA RECEBIMENTO)
					   ,[LOGIN]							-- USUARIO DO SISTEMA
					   ,[peso_liq_x]					-- PESO LIQUIDO X				*NULO
					   ,[peso_liq]						-- PESO LIQUIDO
					   ,[CONSIGNADO]					-- CONSIGNADO					*'N'
					   ,[CHAVE_NFE]						-- CHAVE NFE
					   ,[AprovacaoGuiaRosa]				-- APROVAÇÃO GUIA ROSA			*0
					   ,[Desconto]						-- DESCONTO
					   ,[BseIcms]						-- BASE ICMS
					   ,[VlrIcms]						-- VALOR ICMS
					   ,[VlrIpi]						-- VALOR IPI
					   ,[ValorRetPis]					-- VALOR RETENÇÃO PIS
					   ,[ValorRetCofins]				-- VALOR RETENÇÃO COFINS
					   ,[BseSubTrib]					-- BASE SUB. TRIM.
					   ,[VlrSubTrib]					-- VALOR SUB. TRIB.
					   ,[DesonVlrIcms]					-- VALOR DESONERAÇÃO ICMS
					   ,[VlrIrrf]						-- VALOR IRRF
					   ,[AliqIRRF]						-- ALIQ. IRRF
					   ,[VlrINSS]						-- VAOR INSS
					   ,[VlrISS]						-- VALOR ISS
					   ,[AliqISS]						-- ALIQ. ISS
					   ,[VlrCSLL]						-- VALOR CSLL
					   ,[AliqCSLL]						-- ALIQ. CSLL
					   ,[VlrPis]						-- VALOR PIS
					   ,[AliqPis]						-- ALIQ. PIS
					   ,[VlrCofins]						-- VALOR COFINS
					   ,[AliqCofins]					-- ALIQ. COFINS
					   ,[DATA_CANCEL]					-- DATA CANCELAMENTO				  *NULO
					   ,[CANCELADO_POR])				-- USUARIO QUE EFETUOU O CANCELAMENTO *NULO
				 VALUES
					   (@ID_NOTA_COMPRA 	,
						@POS				,
						@ID_CLIENTE			,
						@E_S				,
						@ID_CONDPAG			,
						@DESC_CONDPAG		,
						@NRO_NF				,
						@ID_TITULO			,
						@SERIE				,
						@EMISSAO			,
						@SAIDA				,
						@PLACA				,
						@UF_PLACA			,
						@FRETE				,
						@CFO				,
						@ALIQ_ICM			,
						@REDUCAO_ICM		,
						@BASE_CALC_SUB_ICM	,
						@VLR_ICM_SUB		,
						@VLR_FRETE			,
						@VLR_SEGURO			,
						@OUTRAS_DESP		,
						@VLR_IPI			,
						@VLR_TOT_NOTA		,
						@VLR_TOT_SERV		,
						@ALIQ_ISS			,
						@VLR_ISS			,
						@PESO_BRUTO			,
						@DESC_CORPO_PROD	,
						@DESC_CORPO_SERV	,
						@RAZAO_SOCIAL		,
						@INSC_MUNICIPAL		,
						@CNPJ				,
						@INSC_EST			,
						@ENDERECO			,
						@BAIRRO				,
						@CEP				,
						@TRANSPORTADOR		,
						@MUNICIPIO			,
						@FONE				,
						@END_TRANSP			,
						@UF					,
						@CID_TRANSP			,
						@UF_TRANSP			,
						@INSC_TRANSP		,
						@CNPJ_TRANSP		,
						@CID_ENTREGA		,
						@END_ENTREGA		,
						@BAIRRO_ENTREGA		,
						@CEP_ENTREGA		,
						@UF_ENTREGA			,
						@ID_EMPRESA			,
						@MOV_EST			,
						@GERA_RECEITA		,
						@PED_NOSSO			,
						@COD_CFO			,
						@ENTRADA			,
						@ID_CFO				,
						@ID_MOTIVO			,
						@BASE_ICM_X			,
						@BASE_ICM			,
						@VLR_ICM_X			,
						@VLR_ICM			,
						@VLR_TOT_PROD_X		,
						@VLR_TOT_PROD		,
						@NRO_NOTA_COMPRA	,
						@LOGIN				,
						@peso_liq_x			,
						@peso_liq			,
						@CONSIGNADO			,
						@CHAVE_NFE			,
						@AprovacaoGuiaRosa	,
						@Desconto			,
						@BseIcms			,
						@VlrIcms			,
						@VlrIpi				,
						@ValorRetPis		,
						@ValorRetCofins		,
						@BseSubTrib			,
						@VlrSubTrib			,
						@DesonVlrIcms		,
						@VlrIrrf			,
						@AliqIRRF			,
						@VlrINSS			,
						@VlrISS				,
						@AliqISS			,
						@VlrCSLL			,
						@AliqCSLL			,
						@VlrPis				,
						@AliqPis			,
						@VlrCofins			,
						@AliqCofins			,
						@DATA_CANCEL		,
						@CANCELADO_POR	)
		END

	COMMIT
	-- INSERÇÃO DOS ITENS
	SET NOCOUNT ON;  

End
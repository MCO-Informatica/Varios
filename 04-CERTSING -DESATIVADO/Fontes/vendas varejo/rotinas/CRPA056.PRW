#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CRPA056  º Autor ³ Renato Ruy Bernardo 	º Data ³ 17/07/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta dados do pedido									    º±±
±±º          ³ Dados de calculo do Posto									    º±±
±±º          ³ Federação														    º±±
±±º          ³ Campanha														    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Certisign                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function CRPA056 (cPedido)

Local aRetorno := {}

Default cPedido := " "

RpcSetType(3)
RpcSetEnv("01","02")

//Retonar um array sem dados
If Empty(cPedido)
	ConOut("O pedido não foi informado!")
	Return aRetorno
Endif

Beginsql Alias "TMPPED"

	Column DATVAL		As Date
	Column DATVER		As Date
	Column DATEMIS	As Date
	Column DATA_PEDIDO	As Date
	Column Z6_DTPEDI	As Date

	%NoParser%
	
	//Valor da Federação
	WITH QFED AS
		(SELECT Z6_PEDGAR PEDIDO_FED,
	            SUM(Z6_VALCOM) VALOR_FED
	     FROM %TABLE:SZ6% Z6 
	     JOIN %TABLE:SZ3% Z3
	     ON Z3_FILIAL = %XFILIAL:SZ3% AND
			 Z3_CODENT = Z6.Z6_CODFED AND 
	     Z3_RETPOS != 'N' AND 
	     Z6.%NOTDEL%
	     WHERE 
	     Z6_FILIAL = %XFILIAL:SZ6% AND
	     Z6_PEDGAR = %Exp:cPedido% AND
	     Z6_TPENTID = '8' AND
	     Z6.%NOTDEL%
	     GROUP BY Z6_PEDGAR),
	//VALOR DA CAMPANHA
	QCAM AS
	     (SELECT  Z6_PEDGAR PEDIDO_CAMP,
	              Z6_CODVEND CODIGO_VENDEDOR,
	              Z6_NOMVEND NOME_VENDEDOR,
	              SUM(Z6_VLRPROD) BRUTO_CAMP,
	              SUM(Z6_BASECOM) FAT_CAMP,
	              SUM(Z6_VALCOM) COMIS_CAMPANHA,
	              Z6_DESREDE LINK_CAMPANHA,
	              CASE WHEN  SUM(Z6_VLRPROD) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CAMP
	     FROM %TABLE:SZ6% Z6 
	     WHERE 
	     Z6_FILIAL = %XFILIAL:SZ6% AND
	     Z6_PEDGAR = %Exp:cPedido% AND
	     Z6_TPENTID IN ('7','10') AND
	     Z6.%NOTDEL%
	     GROUP BY Z6_PEDGAR,Z6_CODVEND,Z6_NOMVEND,Z6_DESREDE,Z6_TIPO),
	     QANT AS
	     (SELECT Z6_PEDGAR PEDIDO_ANT, ZF_PEDIDO PEDORI, Z5_DATEMIS DATA_PEDIDO FROM %TABLE:SZ6% SZ6
	      JOIN %TABLE:SZF% SZF ON ZF_FILIAL = %XFILIAL:SZF% AND ZF_COD = Z6_CODVOU AND ZF_PEDIDO > ' ' AND SZF.%NOTDEL%
	      JOIN %TABLE:SZ5% SZ5 ON Z5_FILIAL = %XFILIAL:SZ5% AND Z5_PEDGAR = ZF_PEDIDO AND SZ5.%NOTDEL%
	      WHERE
	      Z6_FILIAL = %XFILIAL:SZ6% AND
	      Z6_PEDGAR = %Exp:cPedido% AND
	      SZ6.%NOTDEL%
	      GROUP BY Z6_PEDGAR, ZF_PEDIDO, Z5_DATEMIS
	      UNION ALL
	      SELECT SZ5.Z5_PEDGAR PEDIDO_ANT, SZ5.Z5_PEDGANT PEDORI, SZ51.Z5_DATEMIS DATA_PEDIDO FROM %TABLE:SZ5% SZ5
	      JOIN %TABLE:SZ5% SZ51 ON SZ51.Z5_FILIAL = %XFILIAL:SZ5% AND SZ51.Z5_PEDGAR = SZ5.Z5_PEDGAR AND SZ51.%NOTDEL%
	      where
	      SZ5.Z5_FILIAL = %XFILIAL:SZ5% and 
	      SZ5.Z5_PEDGAR = %Exp:cPedido% and
	      SZ5.Z5_PEDGANT > ' ' AND
	      SZ5.%NOTDEL%
	      GROUP BY SZ5.Z5_PEDGAR, SZ5.Z5_PEDGANT, SZ51.Z5_DATEMIS)
	
	//DADOS DE VERIFICACAO
	SELECT  DECODE(Z6_TIPO,    	'RECANT','RECEBIDO ANTERIORMENTE',
	                            'REEMBO', 'REEMBOLSO',
	                            'NAOPAG', 'VOUCHER ORIGEM NAO REMUNERADO',
	                            'RETIFI', 'RETIFICACAO',
	                            'RENOVA', 'RENOVACAO',
	                            'ENTHAR', 'HARDWARE AVULSO',
	                            'SERVER', 'PRODUTO SERVIDOR',
	                            'PAGANT', 'PAGO ANTERIORMENTE',
	                            'VERIFI', 'VERIFICACAO') STATPED,
	        CASE WHEN  (SUM(Z6_VLRPROD) = 0 AND SUM(Z6_VALCOM) = 0) OR Z6_TIPO IN ('RETIFI','PAGANT','EXTRA') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CER,
	        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '1' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT') THEN 0 WHEN Z6_TIPO = 'REEMBO' THEN -1  ELSE 1 END CONT_CERHW,
	        CASE WHEN SUM(CASE WHEN Z6_CATPROD = '2' THEN Z6_VLRPROD ELSE 0 END) = 0 OR Z6_TIPO IN ('RETIFI','PAGANT','ENTHAR') THEN 0  WHEN Z6_TIPO = 'REEMBO' THEN -1 ELSE 1 END CONT_CERSW,
	        Z6_CODENT CODIGO_POSTO,
	        Z6_DESENT DESCRICAO_POSTO,
	        Z6_CODPOS CODIGO_POSTO_GAR,
	        Z6_PRODUTO PRODUTO,
	        SUM(DECODE(Z6_CATPROD,'1',Z6_VLRPROD,0)) VALOR_HARDWARE,
	        SUM(DECODE(Z6_CATPROD,'1',Z6_BASECOM,0)) BASE_HARDWARE,
	        SUM(DECODE(Z6_CATPROD,'1',Z6_VALCOM ,0)) COMHAR,
	        SUM(DECODE(Z6_CATPROD,'2',Z6_VLRPROD,0)) VALOR_SOFTWARE,
	        SUM(DECODE(Z6_CATPROD,'2',Z6_BASECOM,0)) BASE_SOFTWARE,
	        SUM(DECODE(Z6_CATPROD,'2',Z6_VALCOM ,0)) COMSOF,
	        SUM(Z6_VLRABT) VLR_ABATIMENTO,
	        SUM(Z6_VLRPROD) VALOR_PRODUTO,
	        SUM(Z6_BASECOM) BASE_COMISSAO,
	        SUM(Z6_VALCOM) VALOR_COMISSAO,
	        Z6_VALIDA DATVAL,				
	        Z6_VERIFIC	DATVER,
	        Z6_DTEMISS	DATEMIS,
	        ZH_DESCRI TIPO_VOUCHER,
	        Z6_NOMEAGE AGENTE_VALIDACAO,
	        Z6_NOAGVER AGENTE_VERIFICACAO,
	        VALOR_FED,
	        SUM(Z6_VALCOM)+NVL(VALOR_FED,0) VLR_FED_COMISS,
	        CODIGO_VENDEDOR,
	        NOME_VENDEDOR,
	        BRUTO_CAMP,
	        FAT_CAMP,
	        COMIS_CAMPANHA,
	        LINK_CAMPANHA,
	        CONT_CAMP,
	        PEDORI,
	        DATA_PEDIDO
	FROM %TABLE:SZ6% SZ6
	LEFT JOIN %TABLE:SZH% SZH ON ZH_FILIAL = %XFILIAL:SZH% AND ZH_TIPO = Z6_TIPVOU AND SZH.%NOTDEL%
	LEFT JOIN QFED ON PEDIDO_FED = Z6_PEDGAR
	LEFT JOIN QCAM ON PEDIDO_CAMP = Z6_PEDGAR
	LEFT JOIN QANT ON PEDIDO_ANT = Z6_PEDGAR
	WHERE
	Z6_FILIAL = %XFILIAL:SZ6% AND
	Z6_PEDGAR = %Exp:cPedido% AND
	Z6_TPENTID = '4' AND
	SZ6.%NOTDEL%
	GROUP BY  Z6_TIPO,
	          Z6_CODENT,
	          Z6_DESENT,
	          Z6_CODPOS,
	          Z6_PRODUTO,
	          Z6_VALIDA,
	          Z6_VERIFIC,
	          Z6_DTEMISS,
	          ZH_DESCRI,
	          Z6_NOMEAGE,
	          Z6_NOAGVER,
	          VALOR_FED,
	          CODIGO_VENDEDOR,
	          NOME_VENDEDOR,
	          BRUTO_CAMP,
	          FAT_CAMP,
	          COMIS_CAMPANHA,
	          LINK_CAMPANHA,
	          CONT_CAMP,
			   PEDORI,
			   DATA_PEDIDO

Endsql

//Retonar um array sem dados
If TMPPED->(EOF())
	ConOut("O sistema não encontrou lançamentos para o pedido!")
	Return aRetorno
Endif

AADD(aRetorno,{"dataValidacao"						, TMPPED->DATVAL})
AADD(aRetorno,{"nomeAgenteValidacao"				, RTrim(TMPPED->AGENTE_VALIDACAO)})
AADD(aRetorno,{"dataVerificacaoEmissao"			, TMPPED->DATVER})
AADD(aRetorno,{"nomeAgenteVerificaçãoEmissao"		, RTrim(TMPPED->AGENTE_VERIFICACAO)})
AADD(aRetorno,{"dataEmissaoRenovacao"				, TMPPED->DATEMIS})
AADD(aRetorno,{"statusPedido"						, RTrim(TMPPED->STATPED)})
AADD(aRetorno,{"valorTotalBase"						, TMPPED->BASE_COMISSAO})
AADD(aRetorno,{"valorBaseSoftware"					, TMPPED->BASE_SOFTWARE})
AADD(aRetorno,{"valorBaseHardware"					, TMPPED->BASE_HARDWARE})
AADD(aRetorno,{"tipoVoucher"						, RTrim(TMPPED->TIPO_VOUCHER)})
AADD(aRetorno,{"pedidoAnterior"						, RTrim(TMPPED->PEDORI)})
AADD(aRetorno,{"dataPedidoAnterior"				, TMPPED->DATA_PEDIDO})
AADD(aRetorno,{"valorAbatimento"					, TMPPED->VLR_ABATIMENTO})
AADD(aRetorno,{"valorBrutoSoftware"				, TMPPED->VALOR_SOFTWARE})
AADD(aRetorno,{"valorBrutoHardware"				, TMPPED->VALOR_HARDWARE})
AADD(aRetorno,{"valorBrutoTotal"					, TMPPED->VALOR_PRODUTO})
AADD(aRetorno,{"valorComissaoSoftware"				, TMPPED->COMSOF})
AADD(aRetorno,{"valorComissaoHardware"				, TMPPED->COMHAR})
AADD(aRetorno,{"valorComissaoTotal"				, TMPPED->VALOR_COMISSAO})
AADD(aRetorno,{"valorComissaoFederacao"			, TMPPED->VALOR_FED})
AADD(aRetorno,{"valorTotalComissaoSomaFederacao"	, TMPPED->VLR_FED_COMISS})
AADD(aRetorno,{"contagemGeral"						, TMPPED->CONT_CER})
AADD(aRetorno,{"contagemSoftware"					, TMPPED->CONT_CERSW})
AADD(aRetorno,{"contagemHardware"					, TMPPED->CONT_CERHW})
AADD(aRetorno,{"codigoProduto"						, RTrim(TMPPED->PRODUTO)})
AADD(aRetorno,{"codigoPosto"						, RTrim(TMPPED->CODIGO_POSTO_GAR)})
AADD(aRetorno,{"codigoVendedor"						, RTrim(TMPPED->CODIGO_VENDEDOR)})
AADD(aRetorno,{"nomeVendedor"						, RTrim(TMPPED->NOME_VENDEDOR)})
AADD(aRetorno,{"linkCampanha"						, RTrim(TMPPED->LINK_CAMPANHA)})
AADD(aRetorno,{"valorBruto"							, TMPPED->BRUTO_CAMP})
AADD(aRetorno,{"valorFaturamento"					, TMPPED->FAT_CAMP})
AADD(aRetorno,{"valorTotalComissao"				, TMPPED->COMIS_CAMPANHA})
AADD(aRetorno,{"contagemCampanha"					, TMPPED->CONT_CAMP})


Return aRetorno

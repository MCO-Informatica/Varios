// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : GERAASN1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 01/02/13 | Fernando Sancho Biba   | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"
#include "TOPCONN.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Permite a geração de um arquivo formato texto usando a uma tabela como fonte de dados.

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     1/02/2013
/*/
//------------------------------------------------------------------------------------------
user function GeraAsn1()
	local oDlgGeraTxt
	local cNota := "000000"

//--< montagem da tela de processamento >---------------------------------------------------
	@ 200,  1 to 380, 380 dialog oDlgGeraTxt title "Geração de Arquivo ASN"
	@ 02, 10 to 65, 180

//Coloque um pequeno descritivo com o objetivo deste processamento
	@ 10, 18 say "Este programa gera um arquivo asn."
	//@ 18, 18 say "definidos pelo desenvolvedor ou usuário."
	//@ 18, 18 say "definidos pelo desenvolvedor ou usuário."
	@ 34, 18 say "Fonte de dados:"
	@ 34, 80 say "SF1 - Nota, SD1 - Itens da nota"
	@ 18, 18 say "Número da nota:" 
	@ 18, 60 get cNota Picture "@R 999999999"
	@ 68, 128 bmpButton type 01 action eval({ || doIt(cNota), close(oDlgGeraTxt) })
	@ 68, 158 bmpButton type 02 action close(oDlgGeraTxt)
	activate dialog oDlgGeraTxt centered


	return

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doIt
Gerencia a execução do processo de exportação.

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     1/02/2013
/*/
//------------------------------------------------------------------------------------------
static function doIt(cNota)
	local nHdl
	local cArqTxt := 'G:\tpcp\ASN\' + cNota + '.xml'
	//local cArqTxt := '\\Pdcth\unidg\tpcp\ASN\' + cNota + '.xml'

//--< cria o arquivo de saida >-------------------------------------------------------------
	nHdl := fCreate(cArqTxt, 1)
	if nHdl == -1
		msgAlert("Não foi possível criar o arquivo de saída."+chr(13)+"Favor verificar parâmetros.", "Atenção.")
	else
//--< inicializa a regua de processamento >-------------------------------------------------
		Processa({|| doProcess(nHdl, cNota) }, "Processando...")
	endif
//--< encerramento >------------------------------------------------------------------------
	fClose(nHdl)
	nDhl := nil
	
	MsgInfo("Processo finalizado")

	return


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} doProcess
Processo de exportação.

@author    TOTVS Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     1/02/2013
/*/
//------------------------------------------------------------------------------------------
//--< procedimentos >-----------------------------------------------------------------------
static function doProcess(nHdl, cNota)

	//Variï¿½veis
	//local cLin, cCpo
	//local nRecLote, nLenLote
	local cEOL := chr(13) + chr(10)
	Local cQuery := ""
	local cBuffer := ""
	
	cQuery += "SELECT "
	cQuery += "   CASE WHEN F2_CLIENTE = '000135' THEN '240' WHEN F2_CLIENTE = '000009' THEN '135' ELSE '120' END COD_SAP,"
	cQuery += "	RTRIM(RTRIM(D2.D2_DOC) + '-' + RTRIM(D2.D2_SERIE)) AS NUMERO_NF, "
	cQuery += "	CAST(DATEADD(Day, 1, CAST(D2.D2_EMISSAO As Date)) AS VARCHAR(10)) AS DATA_ENTREGA, "
	cQuery += "	CAST(CAST(D2.D2_EMISSAO AS DATE) AS VARCHAR(10)) AS DATA_DOCUMENTO, "
	cQuery += "	RTRIM(CAST(CAST(F2.F2_VALBRUT AS NUMERIC(12, 2)) AS VARCHAR(20))) AS VALOR_TOTAL_NF, "
	cQuery += "	'0.00' AS VALOR_TOT_PEDIDO, "
	cQuery += "	RTRIM(ISNULL(LEFT(RTRIM(C6.C6_PEDCLI), CHARINDEX('-', RTRIM(C6.C6_PEDCLI)) - 1), ' ')) AS NUMERO_PEDIDO, "
	cQuery += "	RTRIM(ISNULL(RIGHT('00000' + RIGHT(RTRIM(C6.C6_PEDCLI), LEN(C6.C6_PEDCLI) - CHARINDEX('-', RTRIM(C6.C6_PEDCLI))), 5), ' ')) AS NUMERO_ITEM_PEDIDO, "
	cQuery += "	RTRIM(D2.D2_COD) AS CODIGO_MATERIAL, "
	cQuery += "	RTRIM(B1.B1_DESC) AS DESCRICAO_MATERIAL, "
	cQuery += "	RTRIM(CAST(CAST(SUM(D2.D2_QUANT) AS NUMERIC(12, 3)) AS VARCHAR(20))) AS QUANTIDADE, "
	cQuery += "	RTRIM(CAST(CAST(SUM(D2.D2_TOTAL) AS NUMERIC(12, 2)) AS VARCHAR(20))) AS VALOR, "
	cQuery += "	B1.B1_UM AS UNIDADE_MEDIDA, "
	cQuery += "	'0.000' AS P_UNIT_PED, "
	cQuery += "	RTRIM(CAST(CAST(D2.D2_PRCVEN AS NUMERIC(10, 5)) AS VARCHAR(20))) AS PRECO_UNITARIO "
	cQuery += "FROM SD2010 D2 WITH (NOLOCK) "
	cQuery += "INNER JOIN SF2010 F2 WITH (NOLOCK) ON F2.F2_DOC = D2.D2_DOC AND F2.F2_FILIAL = D2.D2_FILIAL AND F2.D_E_L_E_T_ = '' "
	cQuery += "INNER JOIN SB1010 B1 WITH (NOLOCK) ON B1.B1_COD = D2.D2_COD AND B1.D_E_L_E_T_ = '' "
	cQuery += "LEFT JOIN SC6010 C6 WITH (NOLOCK) ON C6.C6_NUM = D2.D2_PEDIDO AND C6.C6_PRODUTO = D2.D2_COD "
	cQuery += "	AND C6.C6_FILIAL = D2.D2_FILIAL AND C6.D_E_L_E_T_ = '' AND C6.C6_NOTA = F2.F2_DOC "
	cQuery += "WHERE "
	cQuery += "	F2.F2_DOC = '" + cNota + "' "
	cQuery += "	AND D2.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY "
	cQuery += "	F2_CLIENTE, "
	cQuery += "	RTRIM(RTRIM(D2.D2_DOC) + '-' + RTRIM(D2.D2_SERIE)), "
	cQuery += "	CAST(DATEADD(Day, 1, CAST(D2.D2_EMISSAO As Date)) AS VARCHAR(10)), "
	cQuery += "	CAST(CAST(D2.D2_EMISSAO AS DATE) AS VARCHAR(10)), "
	cQuery += "	RTRIM(CAST(CAST(F2.F2_VALBRUT AS NUMERIC(12, 2)) AS VARCHAR(20))), "
	cQuery += "	RTRIM(ISNULL(LEFT(RTRIM(C6.C6_PEDCLI), CHARINDEX('-', RTRIM(C6.C6_PEDCLI)) - 1), ' ')), "
	cQuery += "	RTRIM(ISNULL(RIGHT('00000' + RIGHT(RTRIM(C6.C6_PEDCLI), LEN(C6.C6_PEDCLI) - CHARINDEX('-', RTRIM(C6.C6_PEDCLI))), 5), ' ')), "
	cQuery += "	RTRIM(D2.D2_COD), "
	cQuery += "	RTRIM(B1.B1_DESC), "
	cQuery += "	B1.B1_UM, "
	cQuery += "	RTRIM(CAST(CAST(D2.D2_PRCVEN AS NUMERIC(10, 5)) AS VARCHAR(20)))"
	
	TCQuery cQuery Alias ASN_DADOS New
	
	cBuffer += '<?xml version="1.0" encoding="ISO-8859-1" ?>' + cEOL
	cBuffer += '<ASN>' + cEOL
	cBuffer += '<HEADER>' + cEOL
	cBuffer += '<NUMERO_NF>' + AllTrim(ASN_DADOS->NUMERO_NF) + '</NUMERO_NF>' + cEOL
	cBuffer += '<DATA_ENTREGA>' + AllTrim(ASN_DADOS->DATA_ENTREGA) + '</DATA_ENTREGA>' + cEOL
	cBuffer += '<DATA_DOCUMENTO>' + AllTrim(ASN_DADOS->DATA_DOCUMENTO) + '</DATA_DOCUMENTO>' + cEOL
	cBuffer += '<VALOR_TOTAL_NF>' + AllTrim(ASN_DADOS->VALOR_TOTAL_NF) + '</VALOR_TOTAL_NF>' + cEOL
	cBuffer += '<VALOR_TOTAL_PEDIDO>' + AllTrim(ASN_DADOS->VALOR_TOT_PEDIDO) + '</VALOR_TOTAL_PEDIDO>' + cEOL
	cBuffer += '<NUMERO_VOLUMES></NUMERO_VOLUMES>' + cEOL
	cBuffer += '<FORNECEDOR>' + cEOL
	cBuffer += '	<CODIGO_FORNECEDOR>0001001885</CODIGO_FORNECEDOR>' + cEOL
	cBuffer += '	<NOME_FORNECEDOR>THERMOGLASS VIDROS LTDA</NOME_FORNECEDOR>' + cEOL
	cBuffer += '</FORNECEDOR>' + cEOL
	cBuffer += '<UNIDADE>' + cEOL
	cBuffer += '	<CODIGO_UNIDADE>' + AllTrim(ASN_DADOS->COD_SAP) + '</CODIGO_UNIDADE>' + cEOL
	cBuffer += '	<NOME_UNIDADE>WHIRLPOOL SA</NOME_UNIDADE>' + cEOL
	cBuffer += '</UNIDADE>' + cEOL
	cBuffer += '</HEADER>' + cEOL
	
	cBuffer += '<ITENS>' + cEOL
	While !ASN_DADOS->(Eof())
		cBuffer += '	<ITEM>' + cEOL
		cBuffer += '		<NUMERO_PEDIDO>' + AllTrim(ASN_DADOS->NUMERO_PEDIDO) + '</NUMERO_PEDIDO>' + cEOL
		cBuffer += '		<NUMERO_ITEM_PEDIDO>' + AllTrim(ASN_DADOS->NUMERO_ITEM_PEDIDO) + '</NUMERO_ITEM_PEDIDO>' + cEOL
		cBuffer += '		<CODIGO_MATERIAL>' + AllTrim(ASN_DADOS->CODIGO_MATERIAL) + '</CODIGO_MATERIAL>' + cEOL
		cBuffer += '		<DESCRICAO_MATERIAL>' + AllTrim(ASN_DADOS->DESCRICAO_MATERIAL) + '</DESCRICAO_MATERIAL>' + cEOL
		cBuffer += '		<QUANTIDADE>' + AllTrim(ASN_DADOS->QUANTIDADE) + '</QUANTIDADE>' + cEOL
		cBuffer += '		<VALOR>' + AllTrim(ASN_DADOS->VALOR) + '</VALOR>' + cEOL
		cBuffer += '		<UNIDADE_MEDIDA>' + ASN_DADOS->UNIDADE_MEDIDA + '</UNIDADE_MEDIDA>' + cEOL
		cBuffer += '		<PRECO_UNITARIO_PEDIDO>' + AllTrim(ASN_DADOS->P_UNIT_PED) + '</PRECO_UNITARIO_PEDIDO>' + cEOL
		cBuffer += '		<PRECO_UNITARIO>' + AllTrim(ASN_DADOS->PRECO_UNITARIO) + '</PRECO_UNITARIO>' + cEOL
		cBuffer += '	</ITEM>' + cEOL
		ASN_DADOS->(dbSkip())
	End
	cBuffer += '</ITENS>' + cEOL
	
	cBuffer += '</ASN>'	
	
	ASN_DADOS->(dbclosearea())

	//Recomenda-se o uso de procRegua usando 100 (representando 100%)
	/*nLenLote := recCount()
	if nLenLote > 100
		procRegua(100)
		nLenLote := int(nLenLote * 0.05)
	else
		procRegua(nLenLote)
	endif
	*/
	//nRecLote := 0
	
	// Fornecedor
	
	//Para melhor performance, recomenda-se o uso de incProc em lotes de registro
	/*if (nRecLote > nLenLote)
		incProc()
		nRecLote := 0
	endif*/
	//prepara buffer para receber os dados
	//cLin := space(2)
	//cCpo := padR((cAlias)->A1_COD, 6)
	//cLin := stuff(cLin, 1, 6, cCpo)

	//grava o buffer no arquivo de saida
	//cLin := cLin + cEOL
	if fWrite(nHdl, cBuffer, len(cBuffer)) != len(cBuffer)
		msgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atenção.")
	endif

	//nRecLote++
	//dbSkip()

	return
//--< fim de arquivo >----------------------------------------------------------------------

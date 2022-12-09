
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} User Function RCOM005
	(long_description)
	@type  Function
	@author Arnon D. / Weskley Silva
	@since 03/12/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User function RCOM005()

	local oReport as object
	Local cPerg := 'RCOM005'   // setando o pergunte.

	pergunte(cPerg,.F.)        // Chamando e desativando a chamada das opcoes.

	if TRepInUse()			   // Verificando se o Relatorio não esta em uso.
		oReport := ReportDef(cPerg)
		If oReport == Nil
			Return( Nil )
		EndIf

		oReport:PrintDialog()  // Criando o relatorio.
	EndIf
Return( Nil )

/*/{Protheus.doc} nomeStaticFunction ReportDef
	(long_description)
	@type  Static Function
	@author Arnon D. / Weskley Silva
	@since 03/12/2019
	@version version
	@param cPerg
	@return oReport
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function ReportDef(cPerg)

	Local oReport
	Local oSection1
	local cHelp as char

	cHelp := "Relatorio de compras."
	cHelp += " Para selecionar os filtros desejados, va em 'Outras Ações' e logo em seguida 'Parametros'."
	cHelp += " Do lado esquerdo, escolha o tipo de relatorio que deseja."

// criando o rlatorio pela funcao TReport
//  								Nome do relatório.    Título do relatório   Perguntas  Bloco de codigo              Descricao do relatorio  help
	oReport := TReport():New("RCOM005",'Relatorio de Compras',cPerg,{|oReport| ReportPrint( oReport ),'Relatorio de Compras'},cHelp)

	oSection1 := TRSection():New( oReport, 'Relatorio de compras IMCD', {'EXP','SC7','SD1','SB1','SW6'})

// Colunas do relatori -    Nome da coluna  Tabela	 Nome do retrono BD  Char	Tamanho do campo
	TRCell():New( oSection1, 'C7_FILIAL'			   ,'EXP',	'FILIAL'				,					,02)
	TRCell():New( oSection1, 'EMISSAO'	   			   ,'EXP', 	'EMISSAO'				,					,12)
	TRCell():New( oSection1, 'PEDIDO'      			   ,'EXP', 	'PEDIDO'				, "@!"				,08)
	TRCell():New( oSection1, 'PRODUTO'     			   ,'EXP', 	'PRODUTO'				, "@!"				,30)
	TRCell():New( oSection1, 'DESCRICAO'               ,'EXP', 	'DESCRICAO'				, "@!"       		,50)
	TRCell():New( oSection1, 'QTD PEDIDO'              ,'EXP', 	'QTD_PEDIDO'			, PesqPict("SC7","C7_QUANT"),20)
	TRCell():New( oSection1, 'QTD ENTREGUE'            ,'EXP', 	'QTD_ENTREGUE'			, PesqPict("SC7","C7_QUANT"),20)
	TRCell():New( oSection1, 'SALDO' 	   			   ,'EXP', 	'SALDO' 				, PesqPict("SC7","C7_QUANT"),20)
	TRCell():New( oSection1, 'NUM_PRINCIPAL'   		   ,'EXP', 	'NUM_PRINCIPAL'			, "@!"       		,10)
	TRCell():New( oSection1, 'DESC_PRINCIPAL'   	   ,'EXP', 	'DESC_PRINCIPAL'		, "@!"       		,25)
	TRCell():New( oSection1, 'MOEDA'   	               ,'EXP', 	'MOEDA'		            , "@!"       		,10)
	TRCell():New( oSection1, 'NET UNIT'	    		   ,'EXP', 	'NET_UNIT' 				, PesqPict("SC7","C7_TOTAL"),20)
	TRCell():New( oSection1, 'NET TOTAL'    		   ,'EXP', 	'NET_TOTAL' 			, PesqPict("SC7","C7_TOTAL"),20)
	TRCell():New( oSection1, 'VALOR COM IMPOSTOS' 	   ,'EXP', 	'VALOR_COM_IMPOSTOS'	, PesqPict("SC7","C7_TOTAL"),20)
	TRCell():New( oSection1, 'PREVISAO DE ENTREGA'	   ,'EXP', 	'PREVISAO_DE_ENTREGA' 	, "@!"       		,12)
	TRCell():New( oSection1, 'DATA DE ENTREGA'		   ,'EXP', 	'DATA_DE_ENTREGA' 		, 					,12)
	TRCell():New( oSection1, 'STATUS'      			   ,'EXP', 	'STATUS'				, "@!"				,08)
	TRCell():New( oSection1, 'B1_GRUPO'      			   ,'EXP', 	'GRUPO'				, "@!"				,08)
Return( oReport )

/*/{Protheus.doc} nomeStaticFunction ReportPrint
	(long_description)
	@type  Static Function
	@author Arnon D. / Weskley Silva
	@since 03/12/2019
	@version version
	@param oReport
	@return
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function ReportPrint( oReport )

	Local oSection1 := oReport:Section(1)
	Local cQuery := ""
	local nRetmvpar as numeric
	local cMoeda as character
	local nQtdEnt as numeric
	local nQtdSaldo as numeric
	local lWhere as logical


	oSection1:Init()    // Inicializa as configurações e define a primeira página do relatório.
	oSection1:SetHeaderSection(.T.)

	IF Select("EXP") > 0
		EXP->(dbCloseArea())    // Se a tabela ja estiver aberta previamente, a fecha.
	Endif

	nRetmvpar := MV_PAR07

// Inicio da Query

	cQuery := " SELECT T.C7_FILIAL, T.EMISSAO, T.PEDIDO,T.C7_ITEM,T.PRODUTO,T.QTD_PEDIDO,T.QTD_ENTREGUE,T.SALDO, T.MOEDA, "
	cQuery += " T.NUM_PRINCIPAL,T.DESC_PRINCIPAL,T.NET_UNIT,T.DESCRICAO,T.VALOR_COM_IMPOSTOS,T.PREVISAO_DE_ENTREGA,T.DATA_DE_ENTREGA, "
	cQuery += " T.B1_GRUPO,  T.C7_QTDACLA, T.C7_QUJE, T.C7_RESIDUO, T.C7_CONAPRO ,T.C7_ACCPROC, T.W6_HAWB, T.W2_PO_NUM, T.D1_QUANT FROM ( "
	cQuery += " SELECT C7_FILIAL, "
// tratando retorno vazio
	cQuery += " CASE WHEN TRIM(C7_EMISSAO) IS NULL THEN ' ' ELSE C7_EMISSAO  END   AS EMISSAO, "
	cQuery += "	C7_NUM AS PEDIDO,"
	cQuery += "	C7_ITEM,  "
	cQuery += " C7_PRODUTO AS PRODUTO, "
	cQuery += " C7_QUANT AS QTD_PEDIDO, "
	cQuery += " C7_QUJE AS QTD_ENTREGUE, "
	cQuery += " C7_MOEDA AS MOEDA, "
	cQuery += " (C7_QUANT - C7_QUJE) AS SALDO, "
	cQuery += " TRIM(ZA0_NAME) AS DESC_PRINCIPAL, "
	cQuery += "	ZA0_CODPRI AS NUM_PRINCIPAL, "
	cQuery += " C7_XVALNET AS NET_UNIT, "
	cQuery += " RTRIM(B1_DESC) AS DESCRICAO,"
	cQuery += " (C7_TOTAL+(C7_VALICM + C7_VALISS + C7_VALIR + C7_VALIPI)) AS VALOR_COM_IMPOSTOS, "
// tratando retorno vazio
	cQuery += " CASE WHEN TRIM(W6_PRVENTR) IS NULL THEN SC7.C7_DATPRF ELSE W6_PRVENTR  END  AS PREVISAO_DE_ENTREGA, "
// tratando retorno vazio
	cQuery += " CASE WHEN TRIM(D1_DTDIGIT) IS NULL THEN ' ' ELSE D1_DTDIGIT  END AS DATA_DE_ENTREGA,  "
	cQuery += " B1_GRUPO,  C7_QTDACLA, C7_QUJE, C7_RESIDUO, C7_CONAPRO ,C7_ACCPROC, SW6.W6_HAWB, SW2.W2_PO_NUM, SUM(D1_QUANT) AS D1_QUANT  "
//join's
	cQuery += " FROM "+RetSQLName('SC7')+" SC7 "

	cQuery += " INNER JOIN "+RetSQLName('SB1')+" SB1 "
	cQuery += " ON B1_COD = C7_PRODUTO "
	cQuery += " AND SB1.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN "+RetSQLName('ZA0')+" ZA0 "
	cQuery += " ON  ZA0_CODPRI = B1_X_PRINC AND ZA0.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN "+RetSqlName('SW2')+" SW2 "
	cQuery += " ON C7_NUM = W2_PO_SIGA  AND C7_FILIAL = W2_FILIAL  AND SW2.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN "+RetSqlName('SW3')+" SW3 "
	cQuery += " ON  W3_FORN|| W3_FORLOJ = W2_FORN|| W2_FORLOJ  "
	cQuery += " AND  W3_PO_NUM  = W2_PO_NUM "
	cQuery += " AND W3_FILIAL = W2_FILIAL "
	cQuery += " AND SW3.D_E_L_E_T_ = ' ' "
	cQuery += " AND W3_COD_I = SC7.C7_PRODUTO  "
	cQuery += " AND W3_PGI_NUM <> '' "
	cQuery += " AND W3_SEQ = ( SELECT MAX(SW3M.W3_SEQ) FROM "+retSqlName("SW3")+" SW3M 
    cQuery += "                WHERE SW3M.W3_FORN || SW3M.W3_FORLOJ = SW3.W3_FORN || SW3.W3_FORLOJ 
    cQuery += "                  AND SW3M.W3_PO_NUM = SW3.W3_PO_NUM
    cQuery += "                  AND SW3M.W3_FILIAL =SW3.W3_FILIAL 
    cQuery += "                  AND SW3M.D_E_L_E_T_ = ' ' 
    cQuery += "                  AND SW3M.W3_COD_I = SW3.W3_COD_I)                                    
	cQuery += " LEFT JOIN "+RetSQLName('SW7')+" SW7 "
	cQuery += " ON W7_FILIAL = W3_FILIAL "
	cQuery += " AND W7_COD_I  = W3_COD_I "
	cQuery += " AND W7_PO_NUM = W3_PO_NUM  "
	cQuery += " AND W7_PGI_NUM = W3_PGI_NUM "
	cQuery += " AND W7_FORN || W7_FORLOJ = W3_FORN|| W3_FORLOJ "
	cQuery += " AND SW7.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN "+RetSQLName('SW6')+" SW6 "
	cQuery += " ON W6_HAWB = W7_HAWB  "
	cQuery += " AND W6_FILIAL = W7_FILIAL "
	cQuery += " AND SW6.D_E_L_E_T_ = ' ' "

	cQuery += " LEFT JOIN " +retSqlName("SF1")+ " SF1 "
    cQuery += " ON SF1.F1_FILIAL = SC7.C7_FILIAL "  
    cQuery += " AND SF1.F1_HAWB = SW6.W6_HAWB "
    cQuery += " AND SF1.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN "+RetSQLName ('SD1')+" SD1 "
	cQuery += " ON C7_NUM = D1_PEDIDO "
	cQuery += " AND C7_ITEM = D1_ITEMPC "
	cQuery += " AND C7_FILIAL = D1_FILIAL"
	cQuery += " AND C7_PRODUTO = D1_COD "
	cQuery += " AND CASE WHEN SF1.F1_DOC IS NOT NULL  THEN  SF1.F1_DOC ELSE SD1.D1_DOC END = SD1.D1_DOC "
	If nRetmvpar = 3
		cQuery += " AND D1_TES <> ' ' "
	endif
	cQuery += " AND  SD1.D_E_L_E_T_ <> '*' "
	cQuery += " WHERE SC7.D_E_L_E_T_ <> '*' "

	cQuery += " AND B1_TIPO BETWEEN '"+MV_PAR08+"' AND '"+MV_PAR09+"' "

// if's
	If !Empty(mv_par01) .or. !Empty(mv_par02)
		cQuery += " AND B1_X_PRINC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	EndIf

	if !Empty(mv_par03) .or. !Empty(mv_par04)
		cQuery += " AND C7_EMISSAO BETWEEN '"+(dTos(mv_par03))+"' AND '"+(dTos(mv_par04))+"' "
	EndIf

    cQuery += " AND ( CASE WHEN SW6.W6_HAWB IS NOT NULL AND C7_QUJE > 0 AND D1_DTDIGIT IS NOT NULL THEN 1 "
    cQuery += "            WHEN SW2.W2_PO_NUM IS NULL THEN 1 "
	cQuery += "            WHEN SW6.W6_HAWB IS NOT NULL AND C7_QUJE = 0  THEN 1 "
	cQuery += "            WHEN SW2.W2_PO_NUM IS NOT NULL AND SW7.W7_HAWB IS NULL AND (C7_QUJE = 0 OR C7_STATME = 'X')  THEN 1 "
    cQuery += "            ELSE 0 END) = 1 "
// ComboBox

	If nRetmvpar = 1   // - aberto ( QTD ENTREGA ) Em pré-nota
		cQuery += " AND C7_QTDACLA > 0 AND C7_QUJE = 0 AND C7_RESIDUO = ' ' "
	EndIf
	If nRetmvpar = 2   // - pendente ( QTD PEDIDA - QTD ENTREGA )
		cQuery += " AND C7_QUJE = 0 AND C7_QTDACLA = 0 AND C7_RESIDUO = ' ' "
	EndIf
	If nRetmvpar = 3   // - entrega parcial ( C7_QUJE<> 0 AND C7_QUJE < C7_QUANT )
		cQuery += " AND C7_QUJE<> 0 AND C7_QUJE < C7_QUANT AND C7_RESIDUO = ' ' AND C7_CONAPRO NOT IN('B','R') "
	EndIf
// 4 - Todos

	cQuery += " GROUP BY C7_FILIAL, C7_EMISSAO,  C7_NUM,   C7_ITEM , C7_PRODUTO, ZA0_CODPRI, ZA0_NAME, C7_QUANT,W7_QTDE, C7_QUJE, B1_X_PRINC, "
	cQuery += " C7_XVALNET, B1_DESC, C7_MOEDA, C7_TOTAL, W6_PRVENTR, D1_DTDIGIT, C7_VALICM, C7_VALISS, "
	cQuery += " C7_VALIR, C7_VALIPI, B1_GRUPO, C7_RESIDUO, C7_QTDACLA, C7_QUJE, C7_CONAPRO, C7_ACCPROC,C7_DATPRF, W6_HAWB, W2_PO_NUM "

	cQuery += " ORDER BY 1,2,3,4,16 "
	cQuery += " ) T  "
	

	if !Empty(mv_par06)
		cQuery += " WHERE (T.DATA_DE_ENTREGA BETWEEN '"+(dTos(mv_par05))+ "' AND '"+(dTos(mv_par06))+"') "
	elseif  !Empty(mv_par05)
		cQuery += " WHERE T.DATA_DE_ENTREGA >= '"+(dTos(mv_par05))+ "' "
	EndIf	

	lWhere := !(empty(mv_par05) .or. empty(mv_par06))

	if !Empty(mv_par11)
		cQuery += iif(!lWhere, " WHERE ", " OR ") +" (T.PREVISAO_DE_ENTREGA BETWEEN '"+(dTos(mv_par10))+ "' AND '"+(dTos(mv_par11))+"') "
	elseif  !Empty(mv_par10)
		cQuery += iif(!lWhere, " WHERE ", " OR ") +" T.PREVISAO_DE_ENTREGA >= '"+(dTos(mv_par10))+ "' "
	endif

	cQuery := ChangeQuery(cQuery)
// Fim Query

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"EXP",.T.,.T.)

	TcSetField("EXP",'EMISSAO','D',8,0)
	TcSetField("EXP",'PREVISAO_DE_ENTREGA','D',8,0)
	TcSetField("EXP",'DATA_DE_ENTREGA','D',8,0)


	While (EXP->(!EOF())) // Enquanta a tabela não não retornar EOF (End Of File)
		nQtdEnt    := 0
		nQtdSaldo  := 0
		IF oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

		if !empty(EXP->DATA_DE_ENTREGA)
			nQtdEnt := getQtdEnt (EXP->PEDIDO, EXP->C7_ITEM, EXP->DATA_DE_ENTREGA)
			nQtdNf  := EXP->D1_QUANT
			nQtdSaldo := EXP->QTD_PEDIDO  - nQtdEnt
		else
			nQtdEnt   := nQtdNf:= EXP->QTD_ENTREGUE
			nQtdSaldo := EXP->SALDO
		endif


		cStatus := " "
		if EXP->C7_RESIDUO <> ' '
			cStatus := "Eliminado por Residuo"
		endif
		if EXP->QTD_ENTREGUE = 0 .AND. EXP->C7_QTDACLA = 0 .AND. EXP->C7_RESIDUO = ' '
			cStatus := "Pendente "
		endif
		if  EXP->QTD_ENTREGUE <> 0 .AND. EXP->QTD_ENTREGUE < EXP->QTD_PEDIDO .AND. EXP->C7_RESIDUO = ' ' .AND. ! ( EXP->C7_CONAPRO $ ('B|R') )
			cStatus := "Entrega Parcial"
		endif
		if EXP->QTD_ENTREGUE >= EXP->QTD_PEDIDO
			cStatus := "Pedido Atendido"
		endif
		if 	EXP->C7_QTDACLA > 0 .AND. EXP->QTD_ENTREGUE = 0 .AND. EXP->C7_RESIDUO = ' '
			cStatus := "Em pré-nota"
		endif
		if EXP->C7_ACCPROC <> "1" .And.  EXP->C7_CONAPRO $ ('B|R') .And. EXP->QTD_ENTREGUE < EXP->QTD_PEDIDO
			cStatus := "Bloqueado"
		ENDIF
		
// Prenchendo os Valores no relatorio 
		oSection1:cell("C7_FILIAL"):setValue(EXP->C7_FILIAL)

		oSection1:cell("EMISSAO"):setValue(EXP->EMISSAO)
		oSection1:Cell("EMISSAO"):SetAlign("CENTER")

		oSection1:cell("PEDIDO"):setValue(EXP->PEDIDO)
		oSection1:Cell("PEDIDO"):SetAlign("LEFT")

		oSection1:cell("PRODUTO"):setValue(EXP->PRODUTO)
		oSection1:Cell("PRODUTO"):SetAlign("LEFT")

		oSection1:cell("DESCRICAO"):setValue(EXP->DESCRICAO)
		oSection1:Cell("DESCRICAO"):SetAlign("LEFT")

		oSection1:cell("QTD_PEDIDO"):setValue(EXP->QTD_PEDIDO)
		//oSection1:Cell("QTD_PEDIDO"):SetAlign("LEFT")

		oSection1:cell("QTD_ENTREGUE"):setValue(nQtdNf)
		//oSection1:Cell("QTD_ENTREGUE"):SetAlign("LEFT")


		oSection1:cell("SALDO"):setValue(nQtdSaldo)
		//oSection1:Cell("SALDO"):SetAlign("LEFT")

		oSection1:cell("NUM_PRINCIPAL"):setValue(EXP->NUM_PRINCIPAL)
		oSection1:Cell("NUM_PRINCIPAL"):SetAlign("LEFT")


		oSection1:cell("DESC_PRINCIPAL"):setValue(EXP->DESC_PRINCIPAL)
		oSection1:Cell("DESC_PRINCIPAL"):SetAlign("LEFT")

		if !empty(EXP->MOEDA)
			if !empty(cMoeda := superGetMv("MV_SIMB"+strZero(EXP->MOEDA,1), .F., ""))
				oSection1:cell("MOEDA"):setValue(cMoeda)
				oSection1:Cell("MOEDA"):SetAlign("LEFT")
			endif
		endif

		oSection1:cell("NET_UNIT"):setValue(EXP->NET_UNIT)
		//oSection1:Cell("VALOR NET"):SetAlign("LEFT")

		oSection1:cell("NET_TOTAL"):setValue(nQtdSaldo * EXP->NET_UNIT )

		oSection1:cell("VALOR_COM_IMPOSTOS"):setValue(EXP->VALOR_COM_IMPOSTOS)
		//oSection1:Cell("VALOR_COM_IMPOSTOS"):SetAlign("LEFT")

		oSection1:cell("PREVISAO_DE_ENTREGA"):setValue(EXP->PREVISAO_DE_ENTREGA)
		oSection1:Cell("PREVISAO_DE_ENTREGA"):SetAlign("CENTER")

		oSection1:cell("DATA_DE_ENTREGA"):setValue(EXP->DATA_DE_ENTREGA)
		oSection1:Cell("DATA_DE_ENTREGA"):SetAlign("CENTER")

		oSection1:cell("B1_GRUPO"):setValue(EXP->B1_GRUPO)
		oSection1:Cell("B1_GRUPO"):SetAlign("LEFT")

		oSection1:cell("STATUS"):setValue(cStatus)
		oSection1:Cell("STATUS"):SetAlign("LEFT")


		oSection1:PrintLine()

		EXP->(DBSKIP()) // pulando para o proximo registro na tabela
	ENDDO

	EXP->(DBCLOSEAREA())  // Fechando a tabela

Return( Nil )

/*/{Protheus.doc} getQtdEnt
Resgata a quantidade entregue de acordo com
a data.
@type function
@version 1.0
@author marcio.katsumata
@since 07/07/2020
@param cPedido, character, codigo do pedido de compra
@param dDataEnt, date, data de entrega
@return numeric, quantidade entregue
/*/
static function getQtdEnt (cPedido, cItemPed,dDataEnt, lQtdNF)
	local nRet as numeric
	local cAliasTrb as character
	local cWhere as character

	default lQtdNF := .F.
	

	cWhere    := "% "+iif (lQtdNF, " SD1.D1_DTDIGIT = '"+dtos(dDataEnt)+"' AND ", "")+" SD1.D_E_L_E_T_ = ' ' "+" %"
	cAliasTrb := getNextAlias()
	nRet      := 0

		beginSql alias cAliasTrb

			SELECT SD1.D1_QUANT, SD1.D1_DTDIGIT FROM %table:SD1% SD1
			WHERE  SD1.D1_PEDIDO = %exp:cPedido% AND
				   SD1.D1_ITEMPC = %exp:cItemPed% AND
			       %exp:cWhere%
			ORDER BY SD1.D1_DTDIGIT
		endSql


	while (cAliasTrb)->(!eof()) .and. stod((cAliasTrb)->D1_DTDIGIT) <= dDataEnt
		nRet += (cAliasTrb)->D1_QUANT
		(cAliasTrb)->(dbSkip())
	enddo

	(cAliasTrb)->(dbCloseArea())

return nRet

#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

// Programa.: sf1100e
// Autor....: Alexandre Dalpiaz
// Data.....: 11/02/2011
// Descrição: cadastro de plataformas
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SF1100E()
///////////////////////

Local aArea		:= GetArea()
Local _nReg		:= 0
Local aRegSE1	:= {}
Local aRegSE2	:= {}
Local aRegSD2	:= {}
Local _aCabPv	:= {}
Local _aItemTemp:= {}
Local _aItemPv	:= {}

If 	ExistBlock('PE_ImpXmlNFe')
	ExecBlock('PE_ImpXmlNFe',.F.,.F.,{'SF1100E'})
EndIf

RestArea(aArea)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////   ROTINA PARA ESTORNO DE RESERVA E DEVOLUÇÃO DAS REVISTAS IMPORTADAS PARA O ESTOQUE DO SAC - FILIAL 20 QUANDO HOUVER RESERVA DE ASSINATURAS
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
U_SZRReser('EXCLUI')
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Private lMsErroAuto := .F.

_cDoc		:= SF1->F1_NFCONSI
_cSerie		:= SF1->F1_SRCONSI
_cFornece	:= SF1->F1_FORNECE
_cLoja		:= SF1->F1_LOJA
_cTipo		:= "B"

If !Empty(_cDoc) .And. !Empty(_cSerie)
	
	cAliasSF2 := "ASFA"
	
	cQuery := "SELECT SF2.*,R_E_C_N_O_ SF2RECNO "
	cQuery += "FROM "+RetSqlName("SF2")+" SF2 (NOLOCK)"
	cQuery += "WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' AND "
	cQuery += "F2_DOC = '"+_cDoc+"' AND "
	cQuery += "F2_SERIE = '"+_cSerie+"' AND "
	cQuery += "F2_CLIENTE = '"+_cFornece+"' AND "
	cQuery += "F2_LOJA = '"+_cLoja+"' AND "
	cQuery += "F2_TIPO = '"+_cTipo+"' AND "
	cQuery += "SF2.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY "+SqlOrder(SF2->(IndexKey()))
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSF2,.T.,.T.)
	
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	If DbSeek(xFilial("SD2")+(cAliasSF2)->F2_DOC+(cAliasSF2)->F2_SERIE+(cAliasSF2)->F2_CLIENTE+(cAliasSF2)->F2_LOJA)
		cNumPed := SD2->D2_PEDIDO
	EndIf
	
	DbSelectArea("SF2")
	MsGoto((cAliasSF2)->SF2RECNO)
	
	MaCanDelF2("SF2",SF2->(RecNo()),@aRegSD2,@aRegSE1,@aRegSE2)
	
	MaDelNFS(aRegSD2,aRegSE1,aRegSE2,.F.,.F.,.F.,.F.)
	
	DbSelectArea("ASFA")
	DbCloseArea()
	
	DbSelectArea("SC9")
	DbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
	If DbSeek(xFilial("SC9")+cNumPed)
		While SC9->(!Eof()) .and. SC9->C9_PEDIDO==cNumPed
			SC9->(a460Estorna(.T.))
			SC9->(dbskip())
		EndDo
	EndIF
	
	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	If DbSeek(xFilial("SC5")+cNumPed)
		_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
		{"C5_NUM"		,   SC5->C5_NUM					,Nil},;
		{"C5_TIPO"		,   SC5->C5_TIPO				,Nil},;
		{"C5_CLIENTE"	,	SC5->C5_CLIENTE				,Nil},;
		{"C5_LOJACLI"	,	SC5->C5_LOJACLI				,Nil},;
		{"C5_TIPOCLI"	,	SC5->C5_TIPOCLI				,Nil},;
		{"C5_TRANSP"	,	SC5->C5_TRANSP				,Nil},;
		{"C5_TPFRETE"	,	SC5->C5_TPFRETE				,Nil},;
		{"C5_MOEDA"		,	SC5->C5_MOEDA				,Nil},;
		{"C5_CONDPAG"	,	SC5->C5_CONDPAG				,Nil},;
		{"C5_EMISSAO"	,	SC5->C5_EMISSAO				,Nil},;
		{"C5_VEND1"		,	SC5->C5_VEND1				,Nil}}
		
		DbSelectArea("SC6")
		SC6->(DbSetOrder(1))
		DbSeek(xFilial("SC6")+cNumPed)
		While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+cNumPed
			_aItemTemp := {{"C6_NUM"	,	SC6->C6_NUM		,Nil},;
			{"C6_FILIAL"	,	xFilial("SC6")				,Nil},;
			{"C6_ITEM"		,	SC6->C6_ITEM				,Nil},;
			{"C6_PRODUTO"	,	SC6->C6_PRODUTO				,Nil},;
			{"C6_DESCRI"	,	SC6->C6_DESCRI				,Nil},;
			{"C6_UM"		,	SC6->C6_UM					,Nil},;
			{"C6_QTDVEN"	,	SC6->C6_QTDVEN				,Nil},;
			{"C6_QTDEMP"	,	SC6->C6_QTDEMP				,Nil},;
			{"C6_PRUNIT"	,	SC6->C6_PRUNIT				,Nil},;
			{"C6_PRCVEN"	,	SC6->C6_PRCVEN				,Nil},;
			{"C6_VALOR"		,	SC6->C6_VALOR				,Nil},;
			{"C6_TES"		,	SC6->C6_TES					,Nil},;
			{"C6_CF"		,	SC6->C6_CF					,Nil},;
			{"C6_LOCAL"		,	SC6->C6_LOCAL				,Nil},;
			{"C6_CLASFIS"	,	SC6->C6_CLASFIS 			,Nil},;
			{"C6_CLI"		,	SC6->C6_CLI		 			,Nil},;
			{"C6_ENTREG"	,	SC6->C6_ENTREG				,Nil},;
			{"C6_LOJA"		,	SC6->C6_LOJA				,Nil},;
			{"C6_NFORI"		,	SC6->C6_NFORI      			,Nil},;
			{"C6_SERIORI"	,	SC6->C6_SERIORI        		,Nil},;
			{"C6_ITEMORI"	,	SC6->C6_ITEMORI        		,Nil},;
			{"C6_IDENTB6"	,	SC6->C6_IDENTB6			 	,Nil}}
			
			_nReg++
			aAdd(_aItemPv,aClone(_aItemTemp))
			
			SC6->(DbSkip())
		EndDo
		
		If _nReg > 0
			MsExecAuto({|x,y,z| mata410(x,y,z)},_aCabPv,_aItemPv,5)
			
			If lMsErroAuto
				MostraErro()
				If ( __lSX8)
					RollBackSX8()
				EndIf
				DisarmTransaction()
			Else
				If ( __lSX8)
					ConfirmSX8()
				EndIf
			EndIf
		EndIf
	EndIf
	
EndIf

RecLock('SF1',.f.)
SF1->F1_USUACLA :=  '(est) ' + upper(cUserName)
MsUnLock()

RestArea(aArea)

_cQuery := "UPDATE " + RetSqlName('PA6')
_cQuery += _cEnter + "SET PA6_NFE = '', PA6_STATUS = '05', PA6_DESCST = 'Recebimento OK'"
_cQuery += _cEnter + "WHERE PA6_FILDES = '" + xFilial('SF1') + "' AND "
_cQuery += _cEnter + "PA6_FILORI = '" + SF1->F1_LOJA + "' AND "
_cQuery += _cEnter + "PA6_NFE = '" + SF1->F1_DOC + "'"
TcSqlExec(_cQuery)

If SF1->F1_SERIE == 'ZZZ'
	_cQuery := "UPDATE " + RetSqlName('SF3')
	_cQuery += _cEnter + "SET D_E_L_E_T_ = '*'"
	_cQuery += _cEnter + "WHERE F3_FILIAL = '" + SF1->F1_FILIAL + "' AND "
	_cQuery += _cEnter + "F3_NFISCAL = '" + SF1->F1_DOC + "' AND "
	_cQuery += _cEnter + "F3_SERIE = 'ZZZ' AND "
	_cQuery += _cEnter + "F3_CLIEFOR = '" + SF1->F1_FORNECE + "' AND "
	_cQuery += _cEnter + "F3_LOJA = '" + SF1->F1_LOJA + "'"
	TcSqlExec(_cQuery)
	
	_cQuery := "UPDATE " + RetSqlName('SFT')
	_cQuery += _cEnter + "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_"
	_cQuery += _cEnter + "WHERE FT_FILIAL = '" + SF1->F1_FILIAL + "' AND "
	_cQuery += _cEnter + "FT_NFISCAL = '" + SF1->F1_DOC + "' AND "
	_cQuery += _cEnter + "FT_SERIE = 'ZZZ' AND "
	_cQuery += _cEnter + "FT_CLIEFOR = '" + SF1->F1_FORNECE + "' AND "
	_cQuery += _cEnter + "FT_LOJA = '" + SF1->F1_LOJA + "'"
	TcSqlExec(_cQuery)
EndIf

_cQuery := "UPDATE " + RetSqlName('SC7')
_cQuery += _cEnter + " SET C7_NFISCAL = '', C7_ITEM = ''"
_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + " WHERE " + RetSqlName('SC7') + ".D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
_cQuery += _cEnter + " AND C7_FILENT = D1_FILIAL"
_cQuery += _cEnter + " AND C7_NUM = D1_PEDIDO"
_cQuery += _cEnter + " AND C7_ITEM = D1_ITEMPC"
_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
_cQuery += _cEnter + " AND C7_NFISCAL = D1_DOC + D1_SERIE"
_cQuery += _cEnter + " AND C7_ITEMNF = D1_ITEM"
TcSqlExec(_cQuery)

/////////////////////   reservas para assinaturas
U_SZRReser('EXCLUI')

Return



/*
#Include "Protheus.ch"
#Include "rwmake.ch"
*/
// Programa.: sf1100e
// Autor....: Alexandre Dalpiaz
// Data.....: 11/02/2011
// Descrição: cadastro de plataformas
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function SD1100E()

///////////////////////

If  SF1->F1_FORNECE < '000010'
	//ALTERACAO SIDNEY NA LOGICA DO TRANSITO
	
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tatiane de Oliveira 05/02/16            ³
	//³Trocou o campo b2_salpedi por B2_XTRANSI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + " SET B2_XTRANSI = B2_XTRANSI   + "	+ CVALTOCHAR(SD1->D1_QUANT)
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND F4_FILIAL = ''"
	_cQuery += _cEnter + " AND F4_CODIGO = D1_TES"
	_cQuery += _cEnter + " AND F4_ESTOQUE = 'S'"
	_cQuery += _cEnter + " WHERE SD1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D1_FILIAL = '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + " AND D1_FORNECE = '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" + SF1->F1_LOJA + "'"
	_cQuery += _cEnter + " AND D1_TES <> ''"
	_cQuery += _cEnter + " AND D1_ITEM = '" + SD1->D1_ITEM + "'"
	_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND B2_FILIAL = '" + SD1->D1_FILIAL + "'"
	_cQuery += _cEnter + " AND B2_COD = '" + alltrim(SD1->D1_COD) + "'"
	_cQuery += _cEnter + " AND B2_LOCAL = '" + SD1->D1_LOCAL + "'"
	TcSqlExec(_cQuery)
	
EndIf

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NA CONFIRMAÇÃO DA EXCLUSÃO DA NOTA FISCAL DE ENTRADA OU NO ESTORNO DA CLASSIFICAÇÃO.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function A103VLEX()
/////////////////////////
_lRet     := .t.
_cPedidos := ''
For _nI := 1 to len(aCols)
	If !empty(GdFieldGet('D1_PEDIDO',_nI)) .and. !(GdFieldGet('D1_PEDIDO',_nI) $ _cPedidos)
		_cPedidos += GdFieldGet('D1_PEDIDO',_nI) + ','
	EndIf
Next

If !empty(_cPedidos)
	_cPedidos := left(_cPedidos,len(_cPedidos)-1)
	
	_cQuery := "UPDATE " + RetSqlName('SC7') + " SET C7_ITEM = ISNULL(D1_ITEMPC,ITEM) "
	_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery += _cEnter + " INNER JOIN "
	_cQuery += _cEnter + " ("
	_cQuery += _cEnter + " SELECT C7_FILIAL FILIAL, C7_NUM PEDIDO, R_E_C_N_O_ RECNO, RIGHT('0000' + RTRIM(CONVERT(CHAR,MAX(CONVERT(INT,C7_ITEM))+1)),4) ITEM"
	_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " (NOLOCK)"
	_cQuery += _cEnter + " WHERE D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND C7_ITEM = ''"
	_cQuery += _cEnter + " AND C7_NUM IN " + FormatIn(_cPedidos,',')
	_cQuery += _cEnter + " GROUP BY C7_FILIAL, C7_NUM, R_E_C_N_O_"
	_cQuery += _cEnter + " ) A"
	_cQuery += _cEnter + " ON C7_FILIAL = FILIAL"
	_cQuery += _cEnter + " AND C7_NUM = PEDIDO"
	
	_cQuery += _cEnter + " LEFT JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + " ON D1_FILIAL = C7_FILENT"
	_cQuery += _cEnter + " AND D1_PEDIDO = C7_NUM"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D1_COD = C7_PRODUTO"
	
	_cQuery += _cEnter + " WHERE SC7.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND C7_NUM IN " + FormatIn(_cPedidos,',')
	TcSqlExec(_cQuery)
	
EndIf
Return(_lRet)

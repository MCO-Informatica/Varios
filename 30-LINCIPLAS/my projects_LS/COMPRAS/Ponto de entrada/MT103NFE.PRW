#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE _cEnter CHR(13)+CHR(10)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa: mt103nfe()                                                                                                                                               //
// Autor...: Alexandre Dalpiaz                                                                                                                                        //
// Data....: 20/09/10                                                                                                                                                 //
// Funcao..: Na entrada para altera??o/classifica??o da nota fiscal de entrada.                                                                                       //
// 			 Pesquisa de existe pedidos vendas/romaneio para esta nota.                                                                                               //
//			 Se existir, n?o permite edi??o de campos atrav?s da fun??o VL_ROMANEIO no X3_WHEN dos campos 	D1_QUANT, D1_VUNIT, D1_TOTAL                              //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 28/09/2012 - alexandre - n?o executa para filiais/lojas C0/01
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function mt103nfe()
////////////////////////
Local _lRet		:= .t.
Local _cPedido	:= ''
Local _cNFE		:= ''
Local cTipoEmp	:= ""
Local _lPedCo	:= .f.
Local _cTes

Public __dDtRecebe := iif(inclui,ctod(''),SF1->F1_RECBMTO)
Public __aColsSE2 := {}

U_A140ALT('INNER') // CORRIGE OS ITENS DOS PEDIDOS DE COMPRA SE ESTIVEREM EM BRANCO, N?O CAUSANDO MAIS ERRO DE EXECU??O.

If !l103Auto .and. (inclui .or. altera) .and. empty(__dDtRecebe)
	U_DlgDtRec()
EndIf

U_LS_F1VLCOND(4,dDemissao,cCondicao,cEspecie)

If cEmpAnt <> '01'
	Return(.t.)
EndIf

If AllTrim(SM0->M0_CODFIL) $ "01/55"
	cTipoEmp := "M"
ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
	cTipoEmp := "F"
Else
	cTipoEmp := "C"
EndIf

If cFormul == 'N' .and. altera .and. ca100for < '000009' .and. !empty(ca100for) .and. !l103Auto
	_cPedido := Posicione('SD2',3, cLoja + cNFiscal + cSerie,'D2_PEDIDO')
	_cNFE    := Posicione('PA6',1, xFilial('PA6') + _cPedido + cLoja, 'PA6_NFS')
	
	If l103Class .and. SF1->F1_FILIAL == cFilAnt .and. SF1->F1_DOC == cNFiscal .and. SF1->F1_SERIE == cSerie .and. SF1->F1_FORNECE == cA100For .and. SF1->F1_LOJA == cLoja .and. empty(SF1->F1_STATUS)
		_cQuery := "UPDATE " + RetSqlName('SD1')
		_cQuery += _cEnter + "SET D1_TES = '', D1_CF = ''"
		_cQuery += _cEnter + "WHERE D1_FILIAL 				= '" + SF1->F1_FILIAL + "'"
		_cQuery += _cEnter + "AND D1_DOC 					= '" + SF1->F1_DOC + "'"
		_cQuery += _cEnter + "AND D1_SERIE 					= '" + SF1->F1_SERIE + "'"
		_cQuery += _cEnter + "AND D1_FORNECE 				= '" + SF1->F1_FORNECE + "'"
		_cQuery += _cEnter + "AND D1_LOJA 					= '" + SF1->F1_LOJA + "'"
		_cQuery += _cEnter + "AND D_E_L_E_T_ 				= ''"
		TcSqlExec(_cQuery)
		
	EndIf
	
EndIf

//If l103Class .and. empty(SF1->F1_STATUS) .and. !_lPedCo
If l103Class .and. empty(SF1->F1_STATUS) .and. SF1->F1_FILIAL + SF1->F1_LOJA <> 'C0/01'
	If !(SF1->F1_TIPO $ 'DB')
		cFornec := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
		cEstado := Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_EST")
	Else
		cFornec := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_CGC")
		cEstado := Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_EST")
	EndIf
	
	DbSelectArea("SD1")
	SD1->( DbSetOrder(1) )
	If SD1->( DbSeek( SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA ) )
		If !Empty(SD1->D1_PEDIDO)
			DbSelectArea("SC7")
			SC7->( DbSetOrder(4) ) //C7_FILIAL+C7_PRODUTO+C7_NUM+C7_ITEM+C7_SEQUEN
			If SC7->( DbSeek( SD1->D1_FILIAL+SD1->D1_COD+SD1->D1_PEDIDO+SD1->D1_ITEMPC ) )
				_cTes := SC7->C7_TES
			EndIf
		EndIf
	EndIf
	
	If Empty(_cTes)
		If Substr(cFornec,1,8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(cFornec,8)
			_cTes := 'BZ_TE'
		ElseIf Substr(cFornec,1,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp = "M"
			_cTes := 'BZ_TEC'
		Else
			_cTes := 'BZ_TE_FORN'
		EndIf
	EndIf
	
	_cCf := iif(cEstado == 'EX','3',iif(SM0->M0_ESTENT <> cEstado,'2','1'))
	
	_cQuery := "UPDATE SD1"
	_cQuery += _cEnter + "SET D1_TES = " + _cTes + ", D1_CF = '" + _cCf + "' + SUBSTRING(F4_CF,2,3)"
	_cQuery += _cEnter + "FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SBZ') + " SBZ (NOLOCK)"
	_cQuery += _cEnter + "ON BZ_COD 						= D1_COD"
	_cQuery += _cEnter + "AND SBZ.D_E_L_E_T_ 				= ''"
	_cQuery += _cEnter + "AND BZ_FILIAL 					= D1_FILIAL"
	
	_cQuery += _cEnter + "INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
	_cQuery += _cEnter + "ON F4_CODIGO 						= " + _cTes
	_cQuery += _cEnter + "AND SF4.D_E_L_E_T_ 				= ''"
	
	_cQuery += _cEnter + "WHERE D1_FILIAL 					= '" + SF1->F1_FILIAL + "'"
	_cQuery += _cEnter + "AND D1_DOC 						= '" + SF1->F1_DOC + "'"
	_cQuery += _cEnter + "AND D1_SERIE	 					= '" + SF1->F1_SERIE + "'"
	_cQuery += _cEnter + "AND D1_FORNECE 					= '" + SF1->F1_FORNECE + "'"
	_cQuery += _cEnter + "AND D1_LOJA 						= '" + SF1->F1_LOJA + "'"
	_cQuery += _cEnter + "AND SD1.D_E_L_E_T_ 				= ''"
	
	TcSqlExec(_cQuery)
	
EndIf

Return(_lret)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor...: Alexandre Dalpiaz
// Data....: 20/09/10
// Funcao..: utilizada com o PE mt103nfe (acima)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function VL_ROMANEIO()
///////////////////////////
Local _lret := .t.
If cFormul == 'N' .and. cNFiscal + cSerie == PA6->PA6_NFE + PA6->PA6_SERIE .and. !l103Auto
	_lRet := .f.
	MsgBox('Nota fiscal gerada atrav?s do Romaneio n?mero ' + PA6->PA6_NUMROM + _cEnter + 'Campo n?o pode ser alterado.','ATEN??O!!!','ALERT')
EndIf
Return(_lret)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor...: Alexandre Dalpiaz
// Data....: 20/09/10
// Fun??o..: Na digit??o dos campos FORNECEDOR e LOJA, valida se a nota fiscal ? de romaneio e n?o permite a inclus?o
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function VL_F1FORNE()
//////////////////////////
Local _lRet    := .t.
Local _cPedido := .t.
Local _cNFE    := .t.

If cFormul == 'N' .and. ca100for < '000009' .and. !empty(ca100for) .and. !l103Auto
	_cPedido := Posicione('SD2',3, cLoja + cNFiscal + cSerie,'D2_PEDIDO')
	_cNFE    := Posicione('PA6',1, xFilial('PA6') + _cPedido + cLoja, 'PA6_NFS')
	If !empty(_cNFE) .and. PA6->PA6_FILDES == cFilAnt
		_lRet := .f.
		If empty(PA6->PA6_NFE)
			MsgBox('Nota Fiscal deve ser inclu?da pela rotina de DISTRIBUI??O no m?dulo de FATURAMENTO, para encerramento do ROMANEIO n?mero ' + PA6->PA6_NUMROM,'ATEN??O!!!','ALERT')
		Else
			MsgBox('Nota Fiscal j? foi inclu?da. Recebimento do ROMANEIO n?mero ' + PA6->PA6_NUMROM,'ATEN??O!!!','ALERT')
		EndIf
	EndIf
EndIf

Return(_lret)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Autor...: Alexandre Dalpiaz
// Data....: 20/09/10
// Fun??o..: Valida??o dos campos F1_DOC e F1_SERIE, quando inclus?o manual: se altera o nro do documento, limpa a s?rie e fornecedor e loja.
//			  													             se altera a s?rie do documento, limpa somente fornecedor e loja
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User function VL_F1DOC()
//////////////////////////
Local _lRet    := .t.

If cFormul == 'N' .and. !l103Auto
	If ReadVar() == 'CNFISCAL'
		//If empty(left(cNfiscal,1))
		If len(alltrim(cNfiscal)) <> 9
			MsgBox('N?mero da nota fiscal deve ter 9 d?gitos','ATEN??O!!!','ALERT')
			cNfiscal := strzero(val(alltrim(cNfiscal)),9)
		EndIf
		For _nI := 1 to 9
			If !IsDigit(substr(cNfiscal,_nI,1))
				MsgBox('N?mero da nota fiscal est? incorreto. Verifique!!','ATEN??O!!!','ALERT')
				_lRet := .f.
				Exit
			EndIf
		Next
		cSerie = '   '
	EndIf
	
	ca100For := '      '
	cLoja    := '  '
EndIf

Return(_lret)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponto de entrada para validar a altera??o da pr?-nota
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function a140alt(_cJoin)
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
DEFAULT _cJoin := 'INNER'

_cQuery := "UPDATE SC7"
_cQuery += _cEnter + " SET C7_ITEM = ISNULL(D1_ITEMPC,ITEM)"
_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
_cQuery += _cEnter + " INNER JOIN "
_cQuery += _cEnter + " ("
_cQuery += _cEnter + " SELECT C7_FILIAL FILIAL, C7_NUM PEDIDO, SC7.R_E_C_N_O_ RECNO, RIGHT('0000' + (SELECT RTRIM(CONVERT(CHAR,MAX(CONVERT(INT,C7_ITEM))+1)) FROM " + RetSqlName('SC7') + " A (NOLOCK) WHERE A.C7_NUM = SC7.C7_NUM),4) ITEM"
//_cQuery += _cEnter + " SELECT C7_FILIAL FILIAL, C7_NUM PEDIDO, R_E_C_N_O_ RECNO, RIGHT('0000' + RTRIM(CONVERT(CHAR,MAX(CONVERT(INT,C7_ITEM))+1)),4) ITEM"
_cQuery += _cEnter + " FROM " + RetSqlName('SC7') + " SC7 (NOLOCK)"
_cQuery += _cEnter + " WHERE D_E_L_E_T_ 					= ''"
_cQuery += _cEnter + " AND C7_ITEM 							= ''"
_cQuery += _cEnter + " AND C7_FILENT 						= '" + xFilial('SF1') + "'"
_cQuery += _cEnter + " AND C7_FORNECE 						= '" + cA100For + "'"
_cQuery += _cEnter + " AND C7_LOJA 							= '" + cLoja + "'"
_cQuery += _cEnter + " AND C7_ITEM 							= ''"
_cQuery += _cEnter + " GROUP BY C7_FILIAL, C7_NUM, R_E_C_N_O_"
_cQuery += _cEnter + " ) A"
_cQuery += _cEnter + " ON C7_FILIAL 						= FILIAL"
_cQuery += _cEnter + " AND C7_NUM 							= PEDIDO"

_cQuery += _cEnter + _cJoin + " JOIN " + RetSqlName('SD1') + " SD1 (NOLOCK)"
_cQuery += _cEnter + " ON D1_FILIAL 						= C7_FILENT"
_cQuery += _cEnter + " AND D1_PEDIDO 						= C7_NUM"
_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ 					= ''"
_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ 					= ''"
_cQuery += _cEnter + " AND D1_COD 							= C7_PRODUTO"
_cQuery += _cEnter + " AND D1_DOC 							= '" + cNFiscal + "'"
_cQuery += _cEnter + " AND D1_SERIE 						= '" + cSerie + "'"
_cQuery += _cEnter + " AND D1_FILIAL 						= '" + xFilial('SF1') + "'"

_cQuery += _cEnter + " WHERE SC7.D_E_L_E_T_ 				= ''"
_cQuery += _cEnter + " AND C7_ITEM 							= ''"

TcSqlExec(_cQuery)

Return(.t.)

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponto de entrada para validar a altera??o da pr?-nota
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT103QPC()
u_a140alt('LEFT')
Return(paramixb[1])
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

User Function mt100cla()
If cFormul == 'N' .and. altera .and. ca100for < '000009' .and. !empty(ca100for) .and. !l103Auto
	_cPedido := Posicione('SD2',3, cLoja + cNFiscal + cSerie,'D2_PEDIDO')
	_cNFE    := Posicione('PA6',1, xFilial('PA6') + _cPedido + cLoja, 'PA6_NFS')
	
	If l103Class .and. SF1->F1_FILIAL == cFilAnt .and. SF1->F1_DOC == cNFiscal .and. SF1->F1_SERIE == cSerie .and. SF1->F1_FORNECE == cA100For .and. SF1->F1_LOJA == cLoja .and. empty(SF1->F1_STATUS)
		_cQuery := "UPDATE " + RetSqlName('SD1')
		_cQuery += _cEnter + "SET D1_TES = '', D1_CF = ''"
		_cQuery += _cEnter + "WHERE D1_FILIAL 				= '" + SF1->F1_FILIAL + "'"
		_cQuery += _cEnter + "AND D1_DOC 					= '" + SF1->F1_DOC + "'"
		_cQuery += _cEnter + "AND D1_SERIE 					= '" + SF1->F1_SERIE + "'"
		_cQuery += _cEnter + "AND D1_FORNECE 				= '" + SF1->F1_FORNECE + "'"
		_cQuery += _cEnter + "AND D1_LOJA 					= '" + SF1->F1_LOJA + "'"
		_cQuery += _cEnter + "AND D_E_L_E_T_ 				= ''"
		TcSqlExec(_cQuery)
		
		_cPedCom := Posicione('SC5',5,SF1->F1_LOJA+SF1->F1_DOC + SF1->F1_SERIE,'C5_COTACAO')

		_cQuery := "UPDATE " + RetSqlName('SB2')   

//??????????????????????????????????????????
//?Tatiane de Oliveira 05/02/16            ?
//?Trocou o campo b2_salpedi por B2_XTRANSI?
//??????????????????????????????????????????
			
			_cQuery += _cEnter + " SET B2_XTRANSI 			= CASE WHEN B2_XTRANSI < 0 THEN 0 ELSE B2_XTRANSI END  - D1_QUANT"
			
			_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
			
			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
			_cQuery += _cEnter + " ON SD2.D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND D2_FILIAL 			= D1_LOJA"
			_cQuery += _cEnter + " AND D2_LOJA			 	= D1_FILIAL"
			_cQuery += _cEnter + " AND D2_DOC 				= D1_DOC"
			_cQuery += _cEnter + " AND D2_SERIE 			= D1_SERIE"
			_cQuery += _cEnter + " AND D2_COD 				= D1_COD"
			_cQuery += _cEnter + " AND CONVERT(INT,D2_ITEM) = CONVERT(INT,D1_ITEM)"
			
			_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
			_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 		= ''"
			_cQuery += _cEnter + " AND F4_FILIAL 			= ''"
			_cQuery += _cEnter + " AND F4_CODIGO 			= D2_TES"
			_cQuery += _cEnter + " AND F4_ESTOQUE 			= 'S'"
			
			_cQuery += _cEnter + " WHERE SD1.D_E_L_E_T_ 	= ''"
			_cQuery += _cEnter + " AND D1_FILIAL 			= '" + SF1->F1_FILIAL + "'"
			_cQuery += _cEnter + " AND D1_DOC 				= '" + SF1->F1_DOC + "'"
			_cQuery += _cEnter + " AND D1_SERIE 			= '" + SF1->F1_SERIE + "'"
			_cQuery += _cEnter + " AND D1_FORNECE 			= '" + SF1->F1_FORNECE + "'"
			_cQuery += _cEnter + " AND D1_LOJA 				= '" + SF1->F1_LOJA + "'"
			_cQuery += _cEnter + " AND D1_TES 				<> ''"
			_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 	= ''"
			_cQuery += _cEnter + " AND B2_FILIAL 			= D1_FILIAL"
			_cQuery += _cEnter + " AND B2_COD 				= D1_COD"
			_cQuery += _cEnter + " AND B2_LOCAL 			= D1_LOCAL"
			TcSqlExec(_cQuery)
		EndIf
		
		
	EndIf

Return()
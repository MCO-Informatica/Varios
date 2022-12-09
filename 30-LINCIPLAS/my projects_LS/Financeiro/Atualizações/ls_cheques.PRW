#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	LS_CHEQUES
// Autor 		Alexandre Dalpiaz
// Data 		09/03/11
// Descricao  	Alteração / Cancelamento de cheques
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CHEQUES()
//////////////////////////

U_LS_MATRIZ()
cPerg := 'LSCHEQUE' + cFilAnt

ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf

Processa({|| RunProc()},'Atualizando Cheques')

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

//----------------------------------------------------------------------------------------------------------------------------------
_cWhereSE5 := _cEnter + "WHERE E5_BANCO = '" + mv_par02 + "'"
_cWhereSE5 += _cEnter + "AND E5_AGENCIA = '" + mv_par03 + "'"
_cWhereSE5 += _cEnter + "AND E5_CONTA  = '" + mv_par04 + "'"
_cWhereSE5 += _cEnter + "AND E5_NUMCHEQ = '" + mv_par05 + "'"
_cWhereSE5 += _cEnter + "AND E5_FILIAL = '" +xFilial('SE5') + "'"
_cWhereSE5 += _cEnter + "AND " + RetSqlName('SE5') + ".D_E_L_E_T_ = ''"
_cWhereSE5 += _cEnter + "AND E5_TIPODOC = 'BA'"
If mv_par01 == 3
	_cWhereSE5 += _cEnter + "AND E5_PREFIXO = '" + mv_par10 + "'"
	_cWhereSE5 += _cEnter + "AND E5_NUMERO = '" + mv_par11 + "'"
	_cWhereSE5 += _cEnter + "AND E5_PARCELA = '" + mv_par12 + "'"
EndIf
//----------------------------------------------------------------------------------------------------------------------------------
_cWhereSE2 := _cEnter + "WHERE E2_NUMBCO = '" + mv_par05 + "'"
_cWhereSE2 += _cEnter + "AND " + RetSqlName('SE2') + ".D_E_L_E_T_ = ''"
If mv_par01 == 3
	_cWhereSE2 += _cEnter + "AND E2_PREFIXO = '" + mv_par10 + "'"
	_cWhereSE2 += _cEnter + "AND E2_NUM = '" + mv_par11 + "'"
	_cWhereSE2 += _cEnter + "AND E2_PARCELA = '" + mv_par12 + "'"
EndIf
_cWhereSE2 += _cEnter + "AND E2_MATRIZ = '" + xFilial('SE5') + "'"
_cWhereSE2 += _cEnter + "AND E2_BCOPAG = '" + mv_par02 + "'"

//----------------------------------------------------------------------------------------------------------------------------------
_cWhereSEF := _cEnter + "WHERE EF_BANCO = '" + mv_par02 + "'"
_cWhereSEF += _cEnter + "AND EF_AGENCIA = '" + mv_par03 + "'"
_cWhereSEF += _cEnter + "AND EF_CONTA  = '" + mv_par04 + "'"
_cWhereSEF += _cEnter + "AND EF_NUM = '" + mv_par05 + "'"
_cWhereSEF += _cEnter + "AND EF_FILIAL = '" +xFilial('SE5') + "'"
_cWhereSEF += _cEnter + "AND " + RetSqlName('SEf') + ".D_E_L_E_T_ = ''"
If mv_par01 == 3
	_cWhereSEF += _cEnter + "AND ((EF_PREFIXO = '" + mv_par10 + "'"
	_cWhereSEF += _cEnter + "AND EF_TITULO = '" + mv_par11 + "'"
	_cWhereSEF += _cEnter + "AND EF_PARCELA = '" + mv_par12 + "')"
	_cWhereSEF += _cEnter + "OR EF_TITULO = '')"
EndIf                   

//----------------------------------------------------------------------------------------------------------------------------------

_cQuery := "SELECT COUNT(*) QUANTSE5, SUM(E5_VALOR) E5_VALOR"
_cQuery += _cEnter + "FROM " + RetSqLName('SE5') + " (NOLOCK)"
_cQuery += _cWhereSE5
U_GravaQuery('LS_CHEQUES_SE5.SQL',_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
_nQuantSE5 := TRB->QUANTSE5
_nValor    := TRB->E5_VALOR 
DbCloseArea()

If _nQuantSE5 == 0
	MsgBox('Nenhum movimento de pagamento encontrado para este banco/conta/agência/cheque (SE5). Verifique os parâmetros','ATENÇÃO!!!','ALERT')
	Return()
EndIf
//----------------------------------------------------------------------------------------------------------------------------------

_cQuery := "SELECT COUNT(*) QUANTSE2"
_cQuery += _cEnter + "FROM " + RetSqLName('SE2') + " (NOLOCK)"
_cQuery += _cWhereSE2
U_GravaQuery('LS_CHEQUES_SE2.SQL',_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
_nQuantSE2 := TRB->QUANTSE2
DbCloseArea()

If _nQuantSE2 == 0
	MsgBox('Nenhum título pago com o banco/conta/agência/cheque informados (SE2). Verifique os parâmetros','ATENÇÃO!!!','ALERT')
	Return()
EndIf

If _nQuantSE2 <> _nQuantSE5
	MsgBox('Quantidade de títulos pagos com o banco/conta/agência/cheque informados divergente em relação aos movimento (SE2 x SE5). Verifique os parâmetros','ATENÇÃO!!!','ALERT')
	Return()
EndIf
//----------------------------------------------------------------------------------------------------------------------------------

_cQuery := "SELECT COUNT(*) QUANTSEF"
_cQuery += _cEnter + "FROM " + RetSqLName('SEF') + " (NOLOCK)"
_cQuery += _cWhereSEF
U_GravaQuery('LS_CHEQUES_SEF.SQL',_cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TRB', .F., .T.)
_nQuantSEF := TRB->QUANTSEF
DbCloseArea()

If _nQuantSEF == 0
	MsgBox('Nenhum título pago com o banco/conta/agência/cheque informados (SEF). Verifique os parâmetros','ATENÇÃO!!!','ALERT')
	Return()
EndIf

If _nQuantSEF <> _nQuantSE2 + 1
	MsgBox('Quantidade de títulos pagos com o banco/conta/agência/cheque informados divergente em relação aos movimento (SEF x SE2 x SE5). Verifique os parâmetros','ATENÇÃO!!!','ALERT')
	Return()
EndIf
//----------------------------------------------------------------------------------------------------------------------------------
_cQuery := "UPDATE " + RetSqLName('SE2')
If mv_par01 == 1  // altera bco/ag/conta/cheque
	_cQuery += _cEnter + "SET E2_NUMBCO = '" + mv_par09 + "'"
Else
	_cQuery += _cEnter + "SET E2_NUMBCO = '', E2_SALDO = E2_SALDO + E5_VALOR, E2_BAIXA = '', E2_VALLIQ = E2_VALLIQ - E5_VALOR, E2_MOVIMEN = ''"
	_cQuery += _cEnter + "FROM " + RetSqlName ("SE5") + " SE5 (NOLOCK)"
EndIf
_cQuery += _cWhereSE2
If mv_par01 <> 1
	_cQuery += _cEnter + "AND E5_PREFIXO = E2_PREFIXO"
	_cQuery += _cEnter + "AND E5_NUMERO = E2_NUM"
	_cQuery += _cEnter + "AND E5_PARCELA = E2_PARCELA"
	_cQuery += _cEnter + "AND E5_NUMCHEQ = E2_NUMBCO"
	_cQuery += _cEnter + "AND E5_TIPODOC = 'BA'"
	_cQuery += _cEnter + "AND SE5.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + "AND E5_FORNECE = E2_FORNECE"
	_cQuery += _cEnter + "AND E5_LOJA = E2_LOJA"
EndIf
_cQuery += _cEnter + "AND E5_FILIAL = E2_MATRIZ"
_cQuery += _cEnter + "AND E5_FILIAL = '" + xFilial('SE5') + "'"

TcSqlExec(_cQuery)
//----------------------------------------------------------------------------------------------------------------------------------
_cQuery := "UPDATE " + RetSqLName('SEF')
If mv_par01 == 1  // altera bco/ag/conta/cheque
	_cQuery += _cEnter + "SET EF_BANCO = '" + mv_par06 + "', EF_AGENCIA = '" + mv_par07 + "', EF_CONTA = '" + mv_par08 + "', EF_NUM = '" + mv_par09 + "',"
	_cQuery += _cEnter + "    EF_IMPRESS = CASE WHEN EF_TITULO = '' THEN '' ELSE EF_IMPRESS"
ElseIf mv_par01 == 2
	_cQuery += _cEnter + "SET D_E_L_E_T_ = '*'"
ElseIf mv_par01 == 3
	_cQuery += _cEnter + "SET D_E_L_E_T_ = CASE WHEN EF_TITULO = '' THEN '' ELSE '*' END,"
	_cQuery += _cEnter + "    EF_VALOR   = EF_VALOR - CASE WHEN EF_TITULO = '' THEN " + str(_nValor,12,2) + " ELSE 0 END,"
	_cQuery += _cEnter + "    EF_IMPRESS = CASE WHEN EF_TITULO = '' THEN '' ELSE EF_IMPRESS"
EndIf
_cQuery += _cWhereSEF
TcSqlExec(_cQuery)                       
//----------------------------------------------------------------------------------------------------------------------------------

_cQuery := "UPDATE " + RetSqLName('SE5')
If mv_par01 == 1  // altera bco/ag/conta/cheque
	_cQuery += _cEnter + "SET E5_BANCO = '" + mv_par06 + "', E5_AGENCIA = '" + mv_par07 + "', E5_CONTA = '" + mv_par08 + "', E5_NUMCHEQ = '" + mv_par09 + "'"
Else
	_cQuery += _cEnter + "SET D_E_L_E_T_ = '*'"
EndIf
_cQuery += _cWhereSE5
TcSqlExec(_cQuery)


MsgBox('Cheque alterado/cancelado com êxito','Alteração/Cancelamento de Cheques','INFO')

Return()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////
_aAlias := GetArea()
aPerg   := {}
//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Operação                      ?","","", "mv_ch1", "N",  1 , 0, 0, "C", "", "mv_par01", "Altera Bco/Ag/Conta/Ch", "", "", "", "", "Cancela Cheque", "", "", "", "", "Exclui Título", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "02", "Banco Origem                  ?","","", "mv_ch2", "C",  3 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA6", "", "",""})
aAdd( aPerg , { cPerg, "03", "Agência Origem                ?","","", "mv_ch3", "C",  5 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "04", "Conta Origem                  ?","","", "mv_ch4", "C", 10 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "05", "Cheque Origem                 ?","","", "mv_ch5", "C", 15 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "06", "Banco Destino                 ?","","", "mv_ch6", "C",  3 , 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA6", "", "",""})
aAdd( aPerg , { cPerg, "07", "Agência Destino               ?","","", "mv_ch7", "C",  5 , 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "08", "Conta Destino                 ?","","", "mv_ch8", "C", 10 , 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "09", "Cheque Destino                ?","","", "mv_ch9", "C", 15 , 0, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "10", "Prefixo - Cancelar            ?","","", "mv_cha", "C",  3 , 0, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "11", "Título - Cancelar             ?","","", "mv_chb", "C",  9 , 0, 0, "G", "", "mv_par11", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})
aAdd( aPerg , { cPerg, "12", "Parcela - Cancelar            ?","","", "mv_chc", "C",  3 , 0, 0, "G", "", "mv_par12", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next

RestArea(_aAlias)

Return
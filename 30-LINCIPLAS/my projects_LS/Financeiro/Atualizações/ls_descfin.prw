#include "rwmake.ch"

// Autor.: Alexandre Dalpiaz
// Data..: 08/02/2012
// Funcao: descontabilização do financeiro

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_DESCFIN()
//////////////////////////

Private _nSE1 := _nSE2 := _nSE5 := _nCT2 := 0
cPerg := 'DESFIN    '
ValidPerg()
If !Pergunte(cPerg,.t.)
	Return()
EndIf

If !MsgBox('Confirma descontabilização do financeiro do período ' + dtoc(mv_par01) + ' a '  + dtoc(mv_par02) + ' da Empresa ' + alltrim(Posicione('SM0',1,'01' + mv_par03,'M0_NOME')) +'?', 'Atenção!!!','YESNO')
	Return()
EndIf

MsAguarde({|| RunProc1()})
Processa({|| RunProc2()})

_SE1->(DbCloseArea())
_SE2->(DbCloseArea())
_SE5->(DbCloseArea())
_CT2->(DbCloseArea())

MsgBox('Descontabilização efetuada com sucesso','OK','INFO')

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc1()
/////////////////////////

_cQuery := "SELECT R_E_C_N_O_ RECNO"
_cQuery += " FROM " + RetSqlName('SE5') + " (NOLOCK) "
_cQuery += " WHERE E5_DTDISPO BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += " AND E5_FILIAL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += " AND D_E_L_E_T_ = ''"
_cQuery += " AND E5_MOTBX NOT IN ('CEC')"
If !empty(MV_PAR05)
	_cQuery += " AND E5_BANCO = '" + MV_PAR05 + "'"
	If !empty(MV_PAR06)
		_cQuery += " AND E5_AGENCIA = '" + MV_PAR06 + "'"
		If !empty(MV_PAR07)
			_cQuery += " AND E5_CONTA = '" + MV_PAR07 + "'"
		EndIf	
	EndIf	
EndIf	
MsProcTxt(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SE5', .F., .T.),'Selecionando Movimentações')
count to _nSE5
DbGoTop()
                                                   
_cQuery := "SELECT R_E_C_N_O_ RECNO"
_cQuery += " FROM " + RetSqlName('SE1') + " (NOLOCK) "
_cQuery += " WHERE E1_EMIS1 BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += " AND E1_MATRIZ BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += " AND D_E_L_E_T_ = ''"
_cQuery += " AND LEFT(E1_ORIGEM,3) = 'FIN'"
If !empty(MV_PAR05)
	_cQuery += " AND E1_PORTADO = '" + MV_PAR05 + "'"
	If !empty(MV_PAR06)
		_cQuery += " AND E1_AGEDEP = '" + MV_PAR06 + "'"
		If !empty(MV_PAR07)
			_cQuery += " AND E1_ = '" + MV_PAR07 + "'"
		EndIf	
	EndIf	
EndIf	
MsProcTxt(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SE1', .F., .T.),'Selecionando Contas a Receber')
count to _nSE1
DbGoTop()
                                                   
_cQuery := "SELECT R_E_C_N_O_ RECNO"
_cQuery += " FROM " + RetSqlName('SE2') + " (NOLOCK) "
_cQuery += " WHERE E2_EMIS1 BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += " AND E2_MATRIZ BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += " AND D_E_L_E_T_ = ''"
_cQuery += " AND LEFT(E2_ORIGEM,3) = 'FIN'"
MsProcTxt(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SE2', .F., .T.),'Selecionando Contas a Pagar')
count to _nSE2
DbGoTop()

_cQuery := " SELECT R_E_C_N_O_ RECNO"
_cQuery += " FROM " + RetSqlName('CT2') + " (NOLOCK) "
_cQuery += " WHERE CT2_LOTE = '008850'"
_cQuery += " AND CT2_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += " AND CT2_FILIAL BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
_cQuery += " AND D_E_L_E_T_ = ''"
_cQuery += " AND CT2_LP NOT IN ('594','535')"
MsProcTxt(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_CT2', .F., .T.),'Selecionando Contabilizações')
count to _nCT2
DbGoTop()

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc2()
/////////////////////////

ProcRegua(_nSE1 + _nSE2 +_nSE5 + _nCT2)
DbSelectArea('_SE1')
Do While !eof()
	_cQuery := "UPDATE " + RetSqlName('SE1')
	_cQuery += " SET E1_LA = ''"
	_cQuery += " WHERE R_E_C_N_O_ = " + alltrim(str(_SE1->RECNO))
	IncProc('Desmarcando títulos a receber')
	TcSqlExec(_cQuery)
	DbSkip()
EndDo

DbSelectArea('_SE2')
Do While !eof()
	_cQuery := "UPDATE " + RetSqlName('SE2')
	_cQuery += " SET E2_LA = ''"
	_cQuery += " WHERE R_E_C_N_O_ = " + alltrim(str(_SE2->RECNO))
	IncProc('Desmarcando títulos a pagar')
	TcSqlExec(_cQuery)
	DbSkip()
EndDo

DbSelectArea('_SE5')
Do While !eof()
	_cQuery := "UPDATE " + RetSqlName('SE5')
	_cQuery += " SET E5_LA = ''"
	_cQuery += " WHERE R_E_C_N_O_ = " + alltrim(str(_SE5->RECNO))
	IncProc('Desmarcando movimentações financeiras')
	TcSqlExec(_cQuery)
	DbSkip()
EndDo

DbSelectArea('_CT2')
Do While !eof()
	_cQuery := "DELETE FROM " + RetSqlName('CT2')
	_cQuery += " WHERE R_E_C_N_O_ = " + alltrim(str(_CT2->RECNO))
	IncProc('Excluindo Contabilizações')
	TcSqlExec(_cQuery)
	DbSkip()
EndDo

Return()

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////

cAlias := Alias()
aPerg  := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd( aPerg , {cPerg, "01", "Data de               ", "","", "mv_ch1", "D",  8 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})
aAdd( aPerg , {cPerg, "02", "Data até              ", "","", "mv_ch2", "D",  8 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "",""})
aAdd( aPerg , {cPerg, "03", "Filial de             ", "","", "mv_ch3", "C",  2 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "SM0",""})
aAdd( aPerg , {cPerg, "04", "Filial até            ", "","", "mv_ch4", "C",  2 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "SM0",""})
aAdd( aPerg , {cPerg, "05", "Banco                 ", "","", "mv_ch5", "C",  3 , 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "SA6",""})
aAdd( aPerg , {cPerg, "06", "Agência               ", "","", "mv_ch6", "C",  5 , 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "SA6",""})
aAdd( aPerg , {cPerg, "07", "Conta                 ", "","", "mv_ch7", "C", 10 , 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","", "", "", "SA6",""})


DbSelectArea("SX1")
DbSetOrder(1)
For i:=1 to Len(aPerg)
	RecLock("SX1",!DbSeek(cPerg+aPerg[i,2]))
	For j:=1 to FCount()
		If j <= Len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j,aPerg[i,j])
		EndIf
	Next
	MsUnlock()
Next

DbSelectArea(cAlias)
Return


/*

SE5->(IIF((!E5_TIPO$FORMULA("F50").AND.!Substr(E5_NATUREZ,1,4)$FORMULA("F57")).AND.(ALLTRIM(E5_MOTBX)$"DEB/CRED/NOR/BA") .OR.E5_NATUREZ$FORMULA("F49"),E5_VALOR+E5_VLDESCO-E5_VLJUROS,0))

SE5->(IIF((!E5_TIPO$FORMULA("F50").AND. !ALLTRIM(SUBSTR(E5_NATUREZ,1,4))$FORMULA("F03")) .AND. (ALLTRIM(SE5->E5_MOTBX)$"CH/DEB/CRED/NOR"),E5_VALOR,0))

00194.52101 00049.059728 90000.000662 3 00000000000000
1963 REAIS
*/

User function deb513001()
_aAlias := GetArea()  
DbSelectArea('SE5')
DbSetOrder(7)
_lAchou := DbSeek(SE2->E2_MATRIZ + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA)
_cRet := Posicione('SE5',7,SE2->E2_MATRIZ + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA,'E5_BANCO')
_cRet := Posicione('SA6',1,xFilial('SA6') + _cRet + SE5->E5_AGENCIA + SE5->E5_CONTA,'A6_CONTA')
RestArea(_aAlias)

Return(_cRet)     



E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+E5_RECPAG
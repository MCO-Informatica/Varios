#include "rwmake.ch"

// Funcao       LS_cmpdesc
// Autor 		Alexandre Dalpiaz
// Data 		13/07/2007
// Descricao    descontabilizacao de compras
// Uso          Especifico para laselva
//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_CmpDesc(_nPar)
///////////////////////////////

_nPar := iif(_nPar <> NIL, _nPar,0)

cPerg := 'CMPDES    '
ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf

_cQuery := "SELECT 'UPDATE " + RetSqlName('SF1') + " SET F1_DTLANC = '''' WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) OPERACAO "
_cQuery += " FROM " + RetSqlName('SF1') + " (NOLOCK)"
_cQuery += _cEnter + " WHERE F1_DTLANC <> ''"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"
_cQuery += _cEnter + " AND F1_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND F1_DTDIGIT BETWEEN '"  + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"

MsAguarde({|| DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SF1', .F., .T.)},'Selecionando notas de entrada')

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('CT2') + " WHERE R_E_C_N_O_ = ' +  CONVERT(CHAR,R_E_C_N_O_) OPERACAO"
_cQuery += _cEnter + " FROM " + RetSqlName('CT2') + " CT2 (NOLOCK)"
_cQuery += _cEnter + " WHERE CT2_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND  CT2_DATA BETWEEN '"	+ dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
_cQuery += _cEnter + " AND CT2_LOTE = '008810'"

MsAguarde(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_CT2', .F., .T.),'Selecionando Lancamentos Contábeis (Aglutinados) ')

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('CTK') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) OPERACAO"
_cQuery += _cEnter + " FROM " + RetSqlName('CTK') + " CTK (NOLOCK)"
_cQuery += _cEnter + " WHERE CTK_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND CTK_TABORI = 'SF1'"
_cQuery += _cEnter + " AND CTK_DATA BETWEEN '"	+ dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
_cQuery += _cEnter + " AND CTK_LOTE = '8810'"

 MsAguarde(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_CTK', .F., .T.),'Selecionando Lancamentos Contábeis (Detalhes) ')

Processa({|| RunProc()})

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

_aAlias := {'_SF1','_CT2','_CTK'}
_aTexto := {'Descmarcando NFs','Excluindo Lançamento Contábil','Excluindo Lançamento Contábil'}
_nLastRec := 0
For _nI := 1 to 3
	DbSelectArea(_aAlias[_nI])
	Count to _n
	_nLastRec += _n
	DbGoTop()
Next

ProcRegua(_nLastRec)

For _nI := 1 to 3
	DbSelectArea(_aAlias[_nI])
	Do While !eof()
		IncProc(_aTexto[_nI])
		TcSqlExec(OPERACAO)
		DbSkip()
	EndDo
	DbCloseArea()
Next

Return(.t.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////

_aAlias := GetArea()
aPerg   := {}

//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Filial de                    ?","","", "mv_ch1", "C",  2 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", ""})
aAdd( aPerg , { cPerg, "02", "Filial até                   ?","","", "mv_ch2", "C",  2 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", ""})
aAdd( aPerg , { cPerg, "03", "Data Digitação de            ?","","", "mv_ch3", "D",  8 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd( aPerg , { cPerg, "04", "Data Digitação até           ?","","", "mv_ch4", "D",  8 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

DbSelectArea("SX1")
DbSetOrder(1)

For i:=1 to len(aPerg)
	RecLock("SX1",!DbSeek(cPerg + aPerg[i, 2]))
	For j := 1 to (FCount())
		If j <= len(aPerg[i]) .and. !(left(alltrim(FieldName(j)),6) $ 'X1_PRE/X1_CNT')
			FieldPut(j, aPerg[i, j])
		Endif
	Next
	MsUnlock()
Next
RestArea(_aAlias)

Return

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
user Function LS_SqlExec(_cQuery)
//////////////////////////////////
_nErro := TcSqlExec(_cQuery)
Return(_nErro)

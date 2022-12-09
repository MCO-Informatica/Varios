#include "rwmake.ch"

// Autor.: Alexandre Dalpiaz
// Data..: 05/05/09
// Funcao: descontabilização da folha de pagamento

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_DCFOL()
//////////////////////////

cPerg := 'DESFOL    '
ValidPerg()
If !Pergunte(cPerg,.t.)
	Return()
EndIf

If !MsgBox('Confirma descontabilização da Folha de Pagamento do período ' + dtoc(mv_par01) + ' a '  + dtoc(mv_par02) + ' da Empresa ' + alltrim(Posicione('SM0',1,'01' + mv_par03,'M0_NOME')) +'?', 'Atenção!!!','YESNO')
	Return()
EndIf     

_nCt2 := 0
MsAguarde({|| RunProc1()})
Processa({|| RunProc2()})

_CT2->(DbCloseArea())

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc1()
/////////////////////////

_cQuery := " SELECT 'DELETE FROM " + RetSqlName('CT2') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) LINHA"
_cQuery += " FROM " + RetSqlName('CT2') + " (NOLOCK) "
_cQuery += " WHERE CT2_LOTE = '008890'"
_cQuery += " AND CT2_DATA BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
_cQuery += " AND CT2_FILIAL BETWEEN '" + mv_par03 + "' AND '"  + mv_par04 + "'"
_cQuery += " AND D_E_L_E_T_ = ''"
MsProcTxt(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_CT2', .F., .T.),'Selecionando Contabilizações')
count to _nCT2
DbGoTop()

Return()

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc2()
/////////////////////////

ProcRegua(_nCT2)

DbSelectArea('_CT2')
Do While !eof()
	IncProc('Excluindo Contabilizações')
	TcSqlExec(_CT2->LINHA)
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

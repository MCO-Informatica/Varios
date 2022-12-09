#include "rwmake.ch"

// Funcao      	ls_fatdesc
// Autor 		Alexandre Dalpiaz
// Data 		13/07/2007
// Descricao   	descontabilizacao do faturamento
// Uso         	Especifico para Laselva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_FatDesc(_nPar)
//////////////////////////

_nPar := iif(_nPar <> NIL, _nPar,0)

cPerg := 'FATDES    '
ValidPerg()

If !Pergunte(cPerg,.t.)
	Return()
EndIf
_aAlias := {'_SF2','_CT2','_CTK'}
_aTexto := {'Descmarcando NFs','Excluindo Lançamento Contábil','Excluindo Lançamento Contábil'}

_cQuery := "SELECT 'UPDATE " + RetSqlName('SF2') + " SET F2_DTLANC = '''' WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_)  OPERACAO"
_cQuery += _cEnter + " FROM " + RetSqlName('SF2') + " SF2 (NOLOCK)"

_cQuery += _cEnter + " WHERE F2_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND F2_EMISSAO BETWEEN '"  + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
If mv_par05 == 1
	_cQuery += _cEnter + " AND F2_PDV = ''"
ElseIf mv_par05 == 2
	_cQuery += _cEnter + " AND F2_PDV <> ''"
EndIf                                   
_cQuery += _cEnter + " AND F2_DTLANC <> ''"
_cQuery += _cEnter + " AND D_E_L_E_T_ = ''"

MsAguarde(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SF2', .F., .T.),'Selecionando Documentos de Saida')

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('CT2') + " WHERE R_E_C_N_O_ = ' +  CONVERT(CHAR,R_E_C_N_O_) OPERACAO"
_cQuery += _cEnter + " FROM " + RetSqlName('CT2') + " CT2 (NOLOCK)"
_cQuery += _cEnter + " WHERE CT2_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND  CT2_DATA BETWEEN '"	+ dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
If mv_par05 == 1
	_cQuery += _cEnter + " AND CT2_LOTE = '008820'"
ElseIf mv_par05 == 2
	_cQuery += _cEnter + " AND CT2_LOTE = '008830'"
Else	
	_cQuery += _cEnter + " AND CT2_LOTE IN ('008820','008830')"
EndIf                                   

MsAguarde(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_CT2', .F., .T.),'Selecionando Lancamentos Contábeis (Aglutinados) ')

_cQuery := "SELECT 'DELETE FROM " + RetSqlName('CTK') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) OPERACAO"
_cQuery += _cEnter + " FROM " + RetSqlName('CTK') + " CTK (NOLOCK)"
_cQuery += _cEnter + " WHERE CTK_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
_cQuery += _cEnter + " AND CTK_TABORI = 'SF2'"
_cQuery += _cEnter + " AND CTK_DATA BETWEEN '"	+ dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
If mv_par05 == 1
	_cQuery += _cEnter + " AND CTK_LOTE = '008820'"
ElseIf mv_par05 == 2
	_cQuery += _cEnter + " AND CTK_LOTE = '008830'"
Else	
	_cQuery += _cEnter + " AND CTK_LOTE IN ('008820','008830')"
EndIf                                   

MsAguarde(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_CTK', .F., .T.),'Selecionando Lancamentos Contábeis (Detalhes) ')

If mv_par05 <> 2

	aAdd(_aAlias,'_SL5')
	aAdd(_aTexto,"Descmarcando PDV's")
	_cQuery := "SELECT 'UPDATE " + RetSqlName('SL5') + " WHERE R_E_C_N_O_ = ' + CONVERT(CHAR,R_E_C_N_O_) OPERACAO"
	_cQuery += _cEnter + " FROM " + RetSqlName('SL5') + " SL5 (NOLOCK)"
	_cQuery += _cEnter + " WHERE L5_FILIAL BETWEEN '"  + mv_par01 + "' AND '" + mv_par02 + "'"
	_cQuery += _cEnter + " AND L5_DATA BETWEEN '"	+ dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'"
	_cQuery += _cEnter + " AND L5_LA = 'S'"
	
	MsAguarde(DbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), '_SL5', .F., .T.),"Selecionando Resume PDV's")
	
EndIf                                                                                        
Processa({|| RunProc()})

Return(.t.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function RunProc()
/////////////////////////

_nLastRec := 0
For _nI := 1 to len(_aAlias)
	DbSelectArea(_aAlias[_nI])
     	Count to _n
	_nLastRec += _n
	DbGoTop()
Next	

ProcRegua(_nLastRec)

For _nI := 1 to len(_aAlias)                         
	DbSelectArea(_aAlias[_nI])
	Do While !eof()
		IncProc(_aTexto[_nI])
		TcSqlExec(OPERACAO)
		DbSkip()
	EndDo                  
	DbCloseArea()
Next	         

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function ValidPerg()
///////////////////////////

_aAlias := GetArea()
aPerg   := {}

//..             Grupo    Ordem    Perguntas                 Variavel  Tipo Tam Dec  Variavel  GSC   F3    Def01 Def02 Def03 Def04 Def05
aAdd( aPerg , { cPerg, "01", "Filial de                    ?","","", "mv_ch1", "C",  2 , 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", ""})
aAdd( aPerg , { cPerg, "02", "Filial até                   ?","","", "mv_ch2", "C",  2 , 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SM0", "", ""})
aAdd( aPerg , { cPerg, "03", "Data de                      ?","","", "mv_ch3", "D",  8 , 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd( aPerg , { cPerg, "04", "Data até                     ?","","", "mv_ch4", "D",  8 , 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd( aPerg , { cPerg, "05", "Descontabilizar:              ","","", "mv_ch5", "N",  1 , 0, 0, "C", "", "mv_par05", "Faturamento", "", "", "", "", "PDV", "", "", "", "", "Ambos", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
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

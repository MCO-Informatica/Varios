#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Programa   	a260loc
// Autor 		Alexandre Dalpiaz
// Data 		19/10/11
// Descricao  	ponto de entrada na rotina de movimentos internos modelo I (MATA240),  modelo II (MATA241), transf modelo I (MATA260) e transf modelo II (MATA261)
//				Cria o armazem, caso n?o exista.
// Uso         	LaSelva
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ExistBlock('LS_LOCAL') .and. U_LS_LOCAL(M->D1_LOCAL)                                                                            
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function A260LOC()
///////////////////////

If upper(ReadVar()) == 'CLOCORIG'
	_cLoc := cLocOrig
	_cCod := cCodOrig
ElseIf upper(ReadVar()) == 'CLOCDEST'
	_cLoc := cLocDest
	_cCod := cCodDest
ElseIf upper(ReadVar()) == 'M->D3_LOCAL'
	_cLoc := paramixb[2]
	_cCod := paramixb[1]        
Else
	If !empty(alltrim(ReadVar()))
		MsgBox('Problemas no Ponto de Entrada A260LOC (' + ReadVar() + ').' + _cEnter + 'Contate o administrador do sistema.','ATEN??O!!!!','ALERT')	
	EndIf
	Return()
EndIf	             

If !SB2->(dbSeek(xFilial('SB2') + _cCod + _cLoc,.f.))
	_cTexto := 'Armaz?m ' + _cLoc + ' ainda n?o existente para o produto ' + _cCod + ' na filial ' + xFilial('SB2') + '.' + _cEnter
	_cTexto += 'Deseja criar o armaz?m?'
	If MsgBox(_cTexto,'ATEN??O!!!','YESNO')
		RecLock('SB2',.t.)
		SB2->B2_FILIAL := xFilial('SB2')
		SB2->B2_COD    := _cCod
		SB2->B2_LOCAL  := _cLoc
		MsUnLock()
	EndIf
EndIf

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function A261LOC()
///////////////////////
        
U_A260LOC()

Return()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// valida??o dos campos C7_LOCAL, D1_LOCAL
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_Local(_cLocal)
///////////////////////////////////
Local _lRet := (_cLocal $ GetMv('LS_ALMOXVL'))
If !_lRet
	MsgBox('Armaz?m inv?lido para filial selecionada','ATEN??O!!!','ALERT')
EndIf

Return(_lRet)


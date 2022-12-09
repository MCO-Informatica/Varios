#Include 'Protheus.ch'

// Utilizar somente em SBM
User Function MATCP009()

	Static _RetCp009 := ''
	Static _RetTipo := ''
	
	If ((_RetCp009 == '' .and. _RetTipo == '') .Or. (_RetTipo <> M->B1_TIPO))
		FillVar()
	EndIf
	
	If (AllTrim(_RetCp009) == '')
		Return .T.
	EndIf
	
	DbSelectArea('SBM')
	
	If (SBM->BM_GRUPO $ _RetCp009)
		Return .T.
	EndIf

Return .F.

Static Function FillVar()
	
	_RetCp009 := ''
	_RetTipo := ''
	
	DbSelectArea('ZZJ')
	dbgotop()
	dbsetorder(2)
	
	_RetTipo := M->B1_TIPO
	
	If !(dbseek(xFilial('SB1') + M->B1_TIPO))
		Return
	EndIf
	
	While !eof() .And. (M->B1_TIPO == ZZJ->ZZJ_TIPO)
		_RetCp009 += AllTrim(ZZJ->ZZJ_GRUPO) + ' '
		dbskip()
	EndDo
	
Return
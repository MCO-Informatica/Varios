#Include 'Protheus.ch'

User Function A415TDOK()
	Local lRet    := .T.
	Local cPrdAnt := ''

	DbSelectArea('TMP1')
	TMP1->(dbgotop())

	While !TMP1->( Eof() )
		If !TMP1->CK_FLAG
			If Alltrim(TMP1->CK_PRODUTO) == Alltrim(cPrdAnt)
				Aviso('Duplicidade Produto','Não é permitido incluir Orçamento com produtos iguais em itens distintos!',{'OK'})
				Return  .F.
			Else
				cPrdAnt := TMP1->CK_PRODUTO
			EndIf
		EndIF
		TMP1->( DbSkip() )
	EndDo

	Return lRet


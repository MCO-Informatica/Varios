#Include "Protheus.CH"

User Function MT103FIM()

	Local _aArea	:= GetArea()

	If INCLUI	
		dbSelectArea("SB8")
		SB8->(DbSetOrder(2))
		If SB8->(DBSEEK(SD1->D1_FILIAL + SD1->D1_LOTECTL + SD1->D1_COD + SD1->D1_LOCAL))
			While SD1->D1_FILIAL == SB8->B8_FILIAL .And. SD1->D1_LOTECTL == SB8->B8_LOTECTL .And. SD1->D1_COD == SB8->B8_PRODUTO .And. SD1->D1_LOCAL == SB8->B8_LOCAL
				If SB8->B8_DOC .AND. SB8->B8_SERIE .AND. SB8->B8_CLIFOR .AND. SB8->B8_LOJA
					If Reclock("SB8",.F.)
						SB8->B8_FCICOD	:= SD1->D1_FCICOD
						SB8->(MsUnLock())
					EndIf
				EndIf
			EndDo
		EndIf
	EndIf	
	

	RestArea(_aArea)

Return()

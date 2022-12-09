#INCLUDE "PROTHEUS.CH"

USER FUNCTION FSNOMCLI()
Local cDesc := ""

	DbSelectArea("SE1")
	DbSetOrder(1)
	
	SE1->(DBGotop())
	
	Do While !SE1->(Eof())
		If Empty(SE1->E1_ZNOMCLI)
			cDesc := Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME")
			If !Empty(cDesc)
				RecLock("SE1", .F.)	
				replace E1_ZNOMCLI with cDesc
				SE1->(MsUnLock())
			Endif
		Endif	
		SE1->(DBSkip())
	EndDo


Return

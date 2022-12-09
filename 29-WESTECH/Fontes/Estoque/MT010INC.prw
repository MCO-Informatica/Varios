#Include 'Protheus.ch'
#Include 'Rwmake.ch'

User Function MT010INC()
	
	Local aArea:=GETAREA()
	Local cProduto := SB1->B1_COD
	
	//If MsgBox("Confirma a gera��o do compl?", "Complemento de produtos","YESNO")
	
		DbSelectArea("SB5")
		If ! SB5->(dbSeek(xFilial("SB5")+cProduto))
			If Reclock("SB5",.T.)
			
				SB5->B5_FILIAL	:=	SB1->B1_FILIAL
				SB5->B5_COD		:=	SB1->B1_COD
				SB5->B5_CEME	:=	SB1->B1_DESC
			Else
				msgAlert("N�o foi poss�vel gravar o registro")
			End if
		
			msUnlock("SB5")
		END IF
		
	//End if
	
	RestArea(aArea)
	
Return


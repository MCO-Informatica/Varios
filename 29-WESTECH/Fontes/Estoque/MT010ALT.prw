#Include 'Protheus.ch'

User Function MT010ALT()
	Local aArea:=GETAREA()
	Local cProduto := ALLTRIM(M->B1_COD)
	
	//If MsgBox("Confirma a gera��o do compl?", "Complemento de produtos","YESNO")
	
		//DbSelectArea("SB5")
		//If ! SB5->(dbSeek(xFilial("SB5")+cProduto))
			//If Reclock("SB5",.F.)
			
				//SB5->B5_FILIAL	:=	SB1->B1_FILIAL
				//SB5->B5_COD		:=	SB1->B1_COD
				M->B5_CEME	:=	M->B1_DESC
			//Else
				//msgAlert("N�o foi poss�vel gravar o registro")
			//End if
		
			//msUnlock("SB5")
		//END IF
		
	//End if
	
	//RestArea(aArea)
	
Return NIL


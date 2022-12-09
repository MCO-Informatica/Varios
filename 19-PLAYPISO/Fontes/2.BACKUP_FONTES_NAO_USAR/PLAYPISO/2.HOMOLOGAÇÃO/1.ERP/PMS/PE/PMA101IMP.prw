/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PMA101IMP ºAutor  ³Alexandre Sousa     º Data ³  09/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE. durante a importacao de composicoes para o orcamento.   º±±
±±º          ³utilizado para atualizar a moeda (correcao de erro).        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico LISONDA.	                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function PMA101IMP()
      
	DbSelectArea('AF3')
	DbSetOrder(1) //AF3_FILIAL, AF3_ORCAME, AF3_TAREFA, AF3_ITEM, R_E_C_N_O_, D_E_L_E_T_
	
	If DbSeek(xFilial('AF3')+AF1->AF1_ORCAME)
		While AF3->(!EOF()) .and. AF3->AF3_ORCAME = AF1->AF1_ORCAME
			If AF3->AF3_MOEDA = 0
				If !Empty(AF3->AF3_PRODUT)
					DbSelectArea('SB1')
					DbSetOrder(1)
					DbSeek(xFilial('SB1')+AF3->AF3_PRODUT)
					RecLock('AF3', .F.)
					AF3->AF3_MOEDA := 1
					AF3->AF3_CUSTD := RetFldProd(SB1->B1_COD,"B1_CUSTD")
					MsUnLock()
				ElseIf !Empty(AF3->AF3_RECURS)
					DbSelectArea('AE8')
					DbSetOrder(1) //AE8_FILIAL, AE8_RECURS, AE8_DESCRI, R_E_C_N_O_, D_E_L_E_T_
					DbSeek(xFilial('AE8')+AF3->AF3_RECURS)
					RecLock('AF3', .F.)
					AF3->AF3_MOEDA := 1
					AF3->AF3_CUSTD := AE8->AE8_VALOR //RetFldProd(SB1->B1_COD,"B1_CUSTD")
					MsUnLock()
				EndIf
			EndIf
			AF3->(DbSkip())
		EndDo
	EndIf
	
//	U_LIS100ReCalc()

Return
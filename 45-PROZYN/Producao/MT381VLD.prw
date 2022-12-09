#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ MT381VLD   ³ Autor ³ Denis Varella     ³ Data ³ 12/08/2019 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que atualiza o lote de produtos ainda     º±±
±±ºDesc.     ³ não separados.                                             º±±
±±ºDesc.     ³                                                            º±±
±±ºDesc.     ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT381VLD
Local aArea := GetArea()
Local aOrdSep := {}
Local lRet	:= .T.

/*
If Altera
	//Faço um loop nos produtos da OP
	For nA := 1 to len(aCols)
		//Posiciono na SD4 do produto
		SD4->(DbGoTo(aCols[nA][len(aHeader)]))
		
		//Busco as ordens de separação amarradas a esta OP
		DbSelectArea("SZT")
		SZT->(DbSetOrder(3))
		SZT->(DbGoTop())
		If SZT->(DbSeek(xFilial("SZT")+cOP))
			aAdd(aOrdSep,SZT->ZT_ORDSEP)  //Separação Inteira
			aAdd(aOrdSep,SZT->ZT_ORDSEP2) //Separação Fracionada
			aAdd(aOrdSep,SZT->ZT_ORDSEP3) //Aglutinação de Fracionada
			aAdd(aOrdSep,SZT->ZT_ORDSEP4) 
			
			//Faço a alteração na SZT caso encontre o mesmo produto, com o mesmo lote anterior porém novo lote diferente
			While SZT->(!EOF()) .and. SZT->ZT_OP == cOP
				If SZT->ZT_PROD == SD4->D4_COD .AND. SZT->ZT_LOTECTL == SD4->D4_LOTECTL; 
					.and. ((SD4->D4_LOTECTL != aCols[nA][GDFieldPos("D4_LOTECTL")]) .Or. (SD4->D4_QTDEORI != aCols[nA][GDFieldPos("D4_QTDEORI")])) 
					SZT->(RecLock("SZT",.F.))
					SZT->ZT_LOTECTL := aCols[nA][GDFieldPos("D4_LOTECTL")]
					SZT->ZT_QTDMUL	:= aCols[nA][GDFieldPos("D4_QTDEORI")] 
					SZT->ZT_QTDORI	:= aCols[nA][GDFieldPos("D4_QTDEORI")] 
					SZT->(MsUnlock())
				EndIF
				SZT->(DbSkip())
			EndDo
		EndIf
		
		For nOS := 1 to len(aOrdSep)
			CB8->(DbSetOrder(1))
			CB8->(DbGoTop())
			If CB8->(DbSeek(xFilial("CB8")+aOrdSep[nOS]))
				//Encontro todas as ordens de separação desta OP
				While CB8->(!EOF()) .AND. CB8->CB8_ORDSEP == aOrdSep[nOS] .AND. CB8->CB8_FILIAL == xFilial("CB8")
					
					//Faço a alteração na CB8 caso encontre o mesmo produto, com o mesmo lote anterior porém novo lote diferente
					If CB8->CB8_PROD == SD4->D4_COD .AND. CB8->CB8_LOTECTL == SD4->D4_LOTECTL; 
					.and. ((SD4->D4_LOTECTL != aCols[nA][GDFieldPos("D4_LOTECTL")]) .Or. (SD4->D4_QTDEORI != aCols[nA][GDFieldPos("D4_QTDEORI")]))
					
						CB8->(RecLock("CB8",.F.))
						CB8->CB8_LOTECT := aCols[nA][GDFieldPos("D4_LOTECTL")]
						CB8->CB8_QTDORI := aCols[nA][GDFieldPos("D4_QTDEORI")]
						CB8->CB8_SALDOS := aCols[nA][GDFieldPos("D4_QTDEORI")]
						CB8->(MsUnlock())
					EndIf
					CB8->(DbSkip())
				EndDo
			EndIf
			
			
		Next nOS
		
	Next nA
EndIf
*/
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACD100ET  ºAutor  ³NBC                 º Data ³  17/05/2019 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de entrada do estorno da Ordem de Separacao         º±±
±±º          ³  Utilizada para estornar a quantidade fracionada           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ACD100ET()
Local aArea       := getArea()
Local aAreaCB7    := CB7->(getArea())
Local aAreaCB8    := CB8->(getArea())
Local aAreaSZT    := SZT->(getArea())
Local aColsAuxET  := {}
Local cOrdSep     := ""
//Buscar SZT correspondente, excluir e estornar a ordem de separação vinculada caso exista
cOrdSc7:= CB7->CB7_ORDSEP  
cTipSep:= CB7->CB7_TIPSEP 

IF cTipSep == "3" 
		
				DbSelectArea("SZT")
				DbSetOrder(2) //ZT_FILIAL+ZT_ORDSEP2+ZT_ITEM 
				SZT->(DbSeek(xFilial("SZT")+cOrdSc7)) 
				
				cOrdSepd:= SZT->ZT_ORDSEP  
	
	
	IF !CB7->(Dbseek(xFilial("CB7")+cOrdSepd))

				DbSelectArea("SZT")
				DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP

					If SZT->(DbSeek(xFilial("SZT")+cOrdSepd))	
			
						//Excluir todoso os registros da Ord Sep na SZT
						While !SZT->(Eof()) .AND. SZT->(ZT_FILIAL+ZT_ORDSEP) == xFilial("SZT")+cOrdSepd
			
						RecLock("SZT", .F.)
						SZT->(DbDelete())
						SZT->(MsUnlock())
					
						SZT->(DbSkip())
					
						Enddo
				
					EndIf
	Endif
		
Else 

			DbSelectArea("SZT")
			DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL   

			If SZT->(DbSeek(xFilial("SZT")+CB7->CB7_ORDSEP))	
			
			cOrdSep := SZT->ZT_ORDSEP2
			
			//Excluir todoso os registros da Ord Sep na SZT
			While !SZT->(Eof()) .AND. SZT->(ZT_FILIAL+ZT_ORDSEP) == xFilial("SZT")+CB7->CB7_ORDSEP
		
				RecLock("SZT", .F.)
				SZT->(DbDelete())
				SZT->(MsUnlock())
				
				SZT->(DbSkip())
				
			Enddo
			
				//Estornar a Ord Sep vinculada
				DbSelectArea("CB7")
				DbSetOrder(1) //CB7_FILIAL+CB7_ORDSEP
				If CB7->(DbSeek(xFilial("CB7")+cOrdSep)) //Ordem de separacao vinculada
					aRecnoAux := aClone(aRecno)
					ACDA100Et("CB7",CB7->(RecNo()),5)
					aRecno := aClone(aRecnoAux)
				EndIf
			
			EndIf
		
endif
	

RestArea(aArea)
RestArea(aAreaCB7)
RestArea(aAreaSZT)
RestArea(aAreaCB8)

Return

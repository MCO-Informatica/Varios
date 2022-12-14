/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?ACD100VE  ?Autor  ?NBC                 ? Data ?  17/05/2019 ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?  Ponto de entrada do estorno da Ordem de Separacao         ???
???          ?  Utilizada para validar o estorno da Ord Sep               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP                                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/
User Function ACD100VE()
Local lRet     := .T.   
Local lRet2     := .F.
Local aArea    := getArea()
Local aAreaSZT := SZT->(getArea())

//Se a Ord Sep constar como uma OrdSep 2 e fracionada e nao poder? ser estornada, dever? estornar a principal
If !IsInCallStack("U_ACD100ET") //Se foi chamado a partir do P.E de estorno siginifica que pode estornar   

    cTipSep:= CB7->CB7_TIPSEP
    cOrdSc7:= CB7->CB7_ORDSEP 
    
    
				DbSelectArea("SZT")
				DbSetOrder(2) //ZT_FILIAL+ZT_ORDSEP2+ZT_ITEM 
				SZT->(DbSeek(xFilial("SZT")+cOrdSc7)) 
				
				cOrdSepd:= SZT->ZT_ORDSEP  
				

	If cTipSep == "1" // Inteiro

				DbSelectArea("SZT")
				DbSetOrder(2) //ZT_FILIAL+ZT_ORDSEP2+ZT_ITEM 
				SZT->(DbSeek(xFilial("SZT")+cOrdSc7)) 
				
				cOrdSepd:= SZT->ZT_ORDSEP 
				  
				lRet:= .T.
				 
				If lRet 
					DbSelectArea("SZT")
					DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL
					If SZT->(DbSeek(xFilial("SZT")+cOrdSepd))
						lRet := Aviso(ProcName()+"-Ord Sep Principal!!!", "Estornando esta Ordem de Separa??o,  estornar? tambem a Ord Sep fracionada: "+SZT->ZT_ORDSEP2+". Confirma?",{"Sim","N?o"}) == 1
					EndIf 
					
				EndIf 
		 
		ElseIf cTipSep == '3' .and. CB7->(Dbseek(xFilial("CB7")+cOrdSepd))  // Fracionada - Sala de separa??o - com a inteiro referenciada  
		    
			  	IF SZT->(DbSeek(xFilial("SZT")+cOrdSc7))
		
			   		MsgStop("Ordem de Separa??o fracionada vinculada a Ord Sep: "+cOrdSepd+". N?o pode ser estornada. Estorne a Ord Sep principal", ProcName()+"-Aten?ao!!!")
					lRet := .F.     
					
	  			EndIf
		
		ElseIf cTipSep == '3' .and. !CB7->(Dbseek(xFilial("CB7")+cOrdSepd)) // Fracionada - Sala de separa??o - sem a inteiro referenciada   
		
		        lRet2:= .T.
		
				If lRet2 
					DbSelectArea("SZT")
					DbSetOrder(1) //ZT_FILIAL+ZT_ORDSEP+ZT_ITEM+ZT_PROD+ZT_LOCAL+ZT_LOTECTL
					If SZT->(DbSeek(xFilial("SZT")+cOrdSepd))
						lRet := Aviso(ProcName()+"-Ord Sep Fracionada!!!", " Confirma?",{"Sim","N?o"}) == 1
					EndIf
				EndIf
		
	   //	elseif cTipSep == '2' // Aglutinada de Fracionados - Sem referencia com nenhuma OS
	
	EndIf 

EndIF

RestArea(aArea)
RestArea(aAreaSZT)

Return lRet
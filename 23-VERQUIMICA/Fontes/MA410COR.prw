User Function MA410COR()  

Local aArea  := GetArea()
Local aCores := {}      
                                                                                        
Aadd(aCores,  	{"Empty(SC5->C5_LIBEROK).And. Empty(SC5->C5_NOTA) .AND. Empty(SC5->C5_BLQ)" ,"ENABLE"    })                  //Pedido em Aberto

If (AllTrim(FunName()) <> "MATA440")
Aadd(aCores,	{"SC5->C5_BLQ == '1'", "BR_PINK"})        						//Pedido Bloqueado por Regra      
Aadd(aCores,	{"Empty(SC5->C5_BLQ) .AND. U_DBVPCRD()"	, "BR_LARANJA"	})	//Pedido bloqueado por Credito
Aadd(aCores,	{"Empty(SC5->C5_BLQ) .AND. U_DBVPATE()"	, "BR_AMARELO"	}) 	//Bloqueado por Estoque
Aadd(aCores,	{"!Empty(SC5->C5_NOTA) .Or. SC5->C5_LIBEROK=='E'"   ,"DISABLE"   }) //Pedido Encerrado     
	
EndIf

Aadd(aCores,  	{"!Empty(SC5->C5_LIBEROK).And. Empty(SC5->C5_NOTA) .AND. !(U_DBVPCRD()) .AND. !(U_DBVPATE())","BR_MARROM"})                   //Pedido Liberado
		
RestArea(aArea)
	
Return(aCores)    


User Function DBVPCRD()   
Local lRet := .F.

DbSelectArea("SC9"); DbSetOrder(1)
If SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
     While !EoF() .AND. SC9->C9_PEDIDO = SC5->C5_NUM
     		If AllTrim(SC9->C9_BLCRED) $ '01/02/04/05/06/09'
     			lRet := .T.
     		EndIf
     	DbSkip()
     EndDo
EndIf


Return lRet


User Function DBVPATE()
Local lRet := .F.
         
DbSelectArea("SC9"); DbSetOrder(1)
If SC9->(DbSeek(xFilial("SC9")+SC5->C5_NUM))
     While !EoF() .AND. SC9->C9_PEDIDO = SC5->C5_NUM
     		If AllTrim(SC9->C9_BLEST) $ '02/03'
     			lRet := .T.
     		EndIf
     	DbSkip()
     EndDo
EndIf

Return lRet 



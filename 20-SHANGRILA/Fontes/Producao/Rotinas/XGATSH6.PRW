User FuncTion xGatSH6(n_Tp)
Local x_Ret := 0  
Local c_Recurso := M->H6_RECURSO

DbSelectArea("SG2")
DbSetOrder(3) // G2_FILIAL+G2_PRODUTO+G2_OPERAC
If DbSeek(xFilial("SG2") + M->H6_PRODUTO + M->H6_OPERAC)
	While ! SG2->(Eof()) .And. SG2->(G2_FILIAL + G2_PRODUTO + G2_OPERAC ) == xFilial("SG2") + M->H6_PRODUTO + M->H6_OPERAC
	    If c_Recurso == SG2->G2_RECURSO
	    	If n_Tp == 1
		    	x_Ret := SG2->G2_LOTEPAD  
		    	Exit
	    	Else
		    	x_Ret := SG2->G2_TEMPAD
		    	Exit
	    	EndIf
	    EndIf
		SG2->(DbSkip())
	EndDo
EndIf		
Return(x_Ret)

User FuncTion xVldRec()
Local l_Ret := .T.  
Local x_Ret := 0 
Local c_Recurso := M->H6_RECURSO

DbSelectArea("SG2")
DbSetOrder(3) // G2_FILIAL+G2_PRODUTO+G2_OPERAC
If DbSeek(xFilial("SG2") + M->H6_PRODUTO + M->H6_OPERAC)
	While ! SG2->(Eof()) .And. SG2->(G2_FILIAL + G2_PRODUTO + G2_OPERAC ) == xFilial("SG2") + M->H6_PRODUTO + M->H6_OPERAC
	    If c_Recurso == SG2->G2_RECURSO
	    	x_Ret := SG2->G2_LOTEPAD  
	    EndIf
		SG2->(DbSkip())
	EndDo
EndIf		

If x_Ret == 0
	Alert("Cadastrar roteiro e operação para este produto...")
 	l_Ret := .F.
EndIf
Return(l_Ret)



User FuncTion xVldLocal()
Local l_Ret := .T.  

If Left(M->B1_LOCPAD,1) <> "P" .And. Left(M->B1_COD,1) == "Z"

	Alert("Local Não permitido para este produto...")
 	l_Ret := .F.

EndIf 

If Left(M->B1_LOCPAD,1) = "P" .And. Left(M->B1_COD,1) <> "Z"

	Alert("Local Não permitido para este produto...")
 	l_Ret := .F.

EndIf 

Return(l_Ret)
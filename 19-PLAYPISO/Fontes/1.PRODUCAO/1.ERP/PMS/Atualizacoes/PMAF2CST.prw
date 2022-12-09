





User Function PMAF2CST()

	Local l_prim := .T.
	
	DbSelectArea('AF2')
//	DbSetOrder(1) //AF2_FILIAL, AF2_ORCAME, AF2_TAREFA, AF2_ORDEM, R_E_C_N_O_, D_E_L_E_T_
	DbSeek(xFilial('AF2')+AF1->AF1_ORCAME)
	
	While AF2->(!EOF()) .and. AF2->AF2_FILIAL = xFilial('AF2') .and. AF1->AF1_ORCAME = AF2->AF2_ORCAME
		AF2->(RecLock("AF2",.F.))
		//AF2->AF2_VALBDI:= AF2->AF2_CUSTO*iif(AF2->AF2_BDI<>0,AF2->AF2_BDI,PmsGetBDIPad('AF5',AF2->AF2_ORCAME,,AF2->AF2_EDTPAI, AF2->AF2_UTIBDI ))/100
		//substituida a linha acima pela abaixo [Mauro Nagata, Actual Trend, 11/07/2012]
		AF2->AF2_VALBDI:= AF2->AF2_CUSTO*iif(AF2->AF2_BDI<>0,AF2->AF2_BDI,PmsGetBDIPad('AF5',AF2->AF2_ORCAME,,AF2->AF2_EDTPAI, AF2->AF2_UTIBDI ))/100 + If(l_Prim,AF1->AF1_VALBDI,0)
		AF2->AF2_TOTAL := AF2->AF2_CUSTO+AF2->AF2_VALBDI
		AF2->(MsUnLock())
		
		//incluida a linha abaixo [Mauro Nagata, Actual Trend, 11/07/2012]
		l_prim := .F.
		
		/*
		//excluido o bloco abaixo [Mauro Nagata, Actual Trend, 11/07/2012]
		AF2->(DbSkip())		
		If l_prim
			AF2->(RecLock("AF2",.F.))
			AF2->AF2_VALBDI:= AF2->AF2_CUSTO*iif(AF2->AF2_BDI<>0,AF2->AF2_BDI,PmsGetBDIPad('AF5',AF2->AF2_ORCAME,,AF2->AF2_EDTPAI, AF2->AF2_UTIBDI ))/100 + AF1->AF1_VALBDI
			AF2->AF2_TOTAL := AF2->AF2_CUSTO+AF2->AF2_VALBDI
			AF2->(MsUnLock())
			AF2->(DbSkip())		
			l_prim := .F.
		EndIf
		//fim bloco [Mauro Nagata, Actual Trend, 11/07/2012]		
		*/

	EndDo

Return


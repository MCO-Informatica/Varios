#Include "Protheus.ch"

/*
+=========================================================+
|Programa: FATG004 |Autor: Antonio Carlos |Data: 13/10/10 |
|Alteracoes        |Autor: Vanilson       |Data: 09/12/10 |
+=========================================================+
|Descrição: Gatilho responsavel pelo preenchimento do TES |
|a ser utilizado na operação de pedido de vendas entre    |
|empresas Laselva (laselva, coligadas e fornecedores).    |
|Utilizado no campo C6_PRODUTO. atualiza TES e CFOP       |
+=========================================================+
|Uso: Especifico: Laselva                                 |
+=========================================================+
28/09/2012 - alexandre - não executa quando for devolução (a410procdv)
*/

User Function FATG004()

Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPosCf	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
Local cTipoEmp 	:= ""
Local cTesFora	:= ""

If AllTrim(SM0->M0_CODFIL) $ "01/55"
	cTipoEmp := "M"
ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ")
	cTipoEmp := "F"
Else
	cTipoEmp := "C"
EndIf

cEstado := SA1->A1_EST

If empty(M->C5_TES)
	If !IsInCallStack('A410PROCDV') .and. M->C5_TIPO $ "N/C/I/P"
		
		If cTipoEmp == "C"
			
			If Substr(SA1->A1_CGC,1,8) $ GetMv("MV_LSVCNPJ")
				
				cTes	:= Posicione("SBZ",1,SA1->A1_LOJA+aCols[n,nPosCod],"BZ_TSC")
				cCf		:=Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")

				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF    
			ElseIf Substr(SA1->A1_CGC,1,8) $ GetMv("MV_CNPJLSV")
				
				cTes	:= Posicione("SBZ",1,SA1->A1_LOJA+aCols[n,nPosCod],"BZ_TS")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")

				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			Else
				
				cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TS_FORN")
				cCf	:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")

				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			EndIf
			
		Else
			
			If (Substr(SA1->A1_CGC,1,8) $ GetMv("MV_LSVCNPJ")) .OR. (Substr(SA1->A1_CGC,1,8) $ GetMv("MV_CNPJLSV"))
				
				cTes	:= Posicione("SBZ",1,SA1->A1_LOJA+aCols[n,nPosCod],"BZ_TS")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			Else
				
				cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TS_FORN")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			EndIf
			
		EndIf
		
	Else  //If M->C5_TIPO $ "B/D"
		
		cEstado := SA2->A2_EST
		
		If cTipoEmp = "C"
			
			If Substr(SA2->A2_CGC,1,8) $ GetMv("MV_LSVCNPJ")
				
				cTes	:= Posicione("SBZ",1,+aCols[n,nPosCod],"BZ_TSC")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			ElseIf Substr(SA2->A2_CGC,1,8) $ GetMv("MV_CNPJLSV" )
				
				cTes	:= Posicione("SBZ",1,SA2->A2_LOJA+aCols[n,nPosCod],"BZ_TS")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			Else
				cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TS_FORN")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			EndIf
			
		Else
			
			If (Substr(SA2->A2_CGC,1,8) $ GetMv("MV_LSVCNPJ")) .OR. (Substr(SA2->A2_CGC,1,8) $ GetMv("MV_CNPJLSV"))
				
				cTes	:= Posicione("SBZ",1,SA2->A2_LOJA+aCols[n,nPosCod],"BZ_TS")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			Else
				
				cTes	:= Posicione("SBZ",1,SM0->M0_CODFIL+aCols[n,nPosCod],"BZ_TS_FORN")
				cCf		:= Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF				
			EndIf
			
		EndIf
		
	EndIf
	
Else
	
	cTes	:= M->C5_TES
	cCf		:= Posicione("SF4",1,xFilial("SF4") + cTes, "F4_CF")
				if cEstado ="EX"				
				 cCf	:= '7' +SUBSTR(cCf,2,3) 
				 ELSE
				 		If SM0->M0_ESTENT == cEstado
				 			cCf	:= '5' +SUBSTR(cCf,2,3) 
				        ELSE
				         cCf	:= '6' +SUBSTR(cCf,2,3) 
			         ENDIF
			     ENDIF	
EndIf

/*If SM0->M0_ESTENT <> cEstado .AND. !Empty(cTes)
	
	cTesFora := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_CF_FORA")
	
	If !empty(cTesFora)
		
		cCf := cTesFora
		
	ElseIf !Empty(cCf)
		
		cCf := "6"+Substr(cCf,2,3)
		
	EndIf
	
EndIf
*/
If !Empty(cTes)
	aCols[n,nPosTes] := cTes
	aCols[n,nPosCf]	 := cCf
	EndIf

Return(aCols[n,nPosTes])

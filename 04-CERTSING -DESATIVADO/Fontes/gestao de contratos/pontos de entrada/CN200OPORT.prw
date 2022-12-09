#Include "Totvs.ch"            

//------------------------------------------------------------------
// Rotina | CN200BUT 	| Autor | Renato Ruy 	  | Data | 25/10/13
//------------------------------------------------------------------
// Descr. | Ponto de Entrada para adicionar botão na manutenção
//        | da tela de planilha.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------

User Function CN200Oport()

Local nPProduto := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_PRODUT"})
Local nPDescri  := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_DESCRI"})
Local nPProdKIT := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_PROGAR"})
Local nPDescKIT := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_DESGAR"})
Local nPQtdVen  := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_QUANT"})
Local nPValUnt  := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_VLUNIT"})
Local nPValTot  := AScan(aHeader,{|x| RTrim(x[2]) == "CNB_VLTOT"}) 
Local nPTes		:= AScan(aHeader,{|x| RTrim(x[2]) == "CNB_TS"})
Local nPItem	:= AScan(aHeader,{|x| RTrim(x[2]) == "CNB_ITEM"}) 
Local nPUm		:= AScan(aHeader,{|x| RTrim(x[2]) == "CNB_UM"}) 
	
Local nX := 0
Local nY := 0
Local cItem := ""

If Empty(M->CNA_UOPORT)
	Alert("O campo oportunidade não foi preenchido, a rotina não pode prosseguir.") 
	Return(.F.)
EndIf

DbSelectArea("ADJ")
DbSetOrder(1)
If DbSeek( xFilial("ADJ") + M->CNA_UOPORT)
	
	While ADJ->ADJ_NROPOR == M->CNA_UOPORT
	
		If Empty( aCols[len(aCols)][nPItem],aCols[len(aCols)][nPItem] )
			cItem := "001"
		Else
			cItem := aCols[len(aCols)][nPItem]
			cItem := Soma1( cItem )
			AAdd(aCOLS,Array(Len(aHeader)+1))
		EndIf
	
		For nY := 1 To Len(aHeader)
			If ( AllTrim(aHeader[nY][2]) == "CNB_ITEM" )
				aCOLS[Len(aCOLS)][nY] := cItem
			Else
				If (aHeader[nY,2] <> "CNB_REC_WT") .And. (aHeader[nY,2] <> "CNB_ALI_WT")				
					aCOLS[Len(aCOLS)][nY] := CriaVar(aHeader[nY][2])
				Endif
			Endif
		Next nY
	    
		aCOLS[Len(aCOLS),nPProduto] 	   	:= ADJ->ADJ_PROD
		aCOLS[Len(aCOLS),nPDescri]			:= Posicione("SB1",1,xFilial("SB1")+ADJ->ADJ_PROD,"B1_DESC")
		aCOLS[Len(aCOLS),nPQtdVen]  		:= ADJ->ADJ_QUANT
		aCOLS[Len(aCOLS),nPValUnt]   		:= ADJ->ADJ_PRUNIT
		aCOLS[Len(aCOLS),nPValTot]   		:= ADJ->ADJ_VALOR
		aCOLS[Len(aCOLS),nPTes] 	  		:= Posicione("SB1",1,xFilial("SB1") + ADJ->ADJ_PROD,"B1_TS")
		aCOLS[Len(aCOLS),nPUm] 	  	  		:= Posicione("SB1",1,xFilial("SB1") + ADJ->ADJ_PROD,"B1_UM")          
		aCOLS[Len(aCOLS),Len(aHeader)+1]	:= .F.
		
	    DbSelectArea("ADJ")
	    DbSkip()
	EndDo
	
	If ValType(oGetDados) <> NIL               
		oGetDados:aCols := AClone( aCols )
		oGetDados:Refresh()
	Endif

Else
	Alert("Não foi possível encontrar cadastro de produtos na oportunidade.") 
	Return(.F.)
EndIf

Return 
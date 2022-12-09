#Include "Totvs.ch"

//------------------------------------------------------------------
// Rotina | CN200Param 	| Autor | Renato Ruy | 		Data | 27/11/13
//------------------------------------------------------------------
// Descr. | Gera tela para selecionar produto GAR e inserir a quant.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------

User Function CN200Param()
	Local aPar := {}
	Local aRet := {}
	Local aButton := {}
	Local cBkp := ''
	
	//If SUB->(FieldPos('CNB_PROGAR'))>0
		cBkp := cCadastro 
		cCadastro := 'Informe os dados'
		
		AAdd(aPar,{1,'Código GAR',Space(Len(PA8->PA8_CODBPG)),'@!',"ExistCpo('PA8')",'PA8','',80,.T.})
		AAdd(aPar,{1,'Quantidade',0.00,'@E 9,999.99','mv_par02>0','','',50,.T.})
		//AAdd(aPar,{1,'TES'		 ,Space(Len(SF4->F4_CODIGO)),'@!',"ExistCpo('SF4')",'SF4','',30,.T.})
		
		If ParamBox(aPar,'Código/Quantidade do kit',@aRet,,,,,,,,.F.,.F.)
			MsgRun("Descarregando os dados, aguarde...","",{|| CN200Strut(aRet) })
		Endif
		cCadastro := cBkp
	//Else
	//	MsgInfo('Estrutura da tabela Itens da Planilha (CNB) incompatível, verifique o campo CNB_PROGAR.')
	//Endif
Return

//------------------------------------------------------------------
// Rotina | CN200Strut | Autor | Renato Ruy | Data | 25/10/13
//------------------------------------------------------------------ 
// Descr. | Rotina com o mecanismo de buscar o código dos componentes
//        | e gera o aCols com as informações.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
Static Function CN200Strut(aRet)
	Local aArea     := GetArea()
	Local aBOM      := {}

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
	
	PA8->(dbSetOrder(1))
	If PA8->(dbSeek(xFilial('PA8')+aRet[1]))
		SG1->(dbSetOrder(1))
		If SG1->(dbSeek(xFilial('SG1')+PA8->PA8_CODMP8))
			While !SG1->(EOF()) .And. xFilial("SG1") == SG1->G1_FILIAL .And. SG1->G1_COD == PA8->PA8_CODMP8
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1")+SG1->G1_COMP))
				If SB1->B1_FANTASM<>"S"
					AAdd(aBOM,{SG1->G1_COMP,ExplEstr(aRet[2],dDataBase,"",SB1->B1_REVATU),PA8->PA8_DESBPG,SB1->B1_PRV1,SB1->B1_DESC,SB1->B1_UM})
				Endif					
				SG1->(dbSkip())
			End
		Else
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek( xFilial("SB1") + PA8->PA8_CODMP8 )
			AAdd(aBOM,{PA8->PA8_CODMP8,1,PA8->PA8_DESBPG,SB1->B1_PRV1,SB1->B1_DESC,SB1->B1_UM})
		Endif
		If Len(aBOM)>0

			For nX := 1 To Len(aBOM)
                                           
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
				
				RegToMemory("CNB")
				
				M->CNB_PRODUT := aBom[nX][1]
				M->CNB_DESCRI := aBom[nX][5]
				M->CNB_QUANT  := aRet[2]
				M->CNB_VLUNIT := aBom[nX][4]
				M->CNB_VLTOT  := aRet[2] * aBom[nX][4]
				M->CNB_PROGAR := aRet[1]
				M->CNB_DESGAR := aBom[nX][3]
				M->CNB_TS	  := "   "
				

				aCOLS[Len(aCOLS),nPProduto] 	   	:= aBom[nX][1]
				aCOLS[Len(aCOLS),nPDescri]			:= aBom[nX][5]
				aCOLS[Len(aCOLS),nPQtdVen]  		:= aRet[2]
				aCOLS[Len(aCOLS),nPValUnt]   		:= aBom[nX][4]
				aCOLS[Len(aCOLS),nPValTot]   		:= aRet[2] * aBom[nX][4]
				aCOLS[Len(aCOLS),nPProdKIT] 		:= aRet[1]
				aCOLS[Len(aCOLS),nPDescKIT]			:= aBom[nX][3]
//				aCOLS[Len(aCOLS),nPTes] 	  		:= aRet[3]
				aCOLS[Len(aCOLS),nPTes] 	  		:= Posicione("SB1",1,xFilial("SB1") + aBom[nX][1],"B1_TS")
				aCOLS[Len(aCOLS),nPUm] 	  	  		:= aBom[nX][6] //Alterado para buscar do produto.          
				aCOLS[Len(aCOLS),Len(aHeader)+1]	:= .F.
			
			Next nX
			
			If ValType(oGetDados) <> NIL               
				N := 1
				oGetDados:aCols := AClone( aCols )
				oGetDados:Refresh()
			Endif

		Else
			MsgInfo('Não foi possível carregar componentes.')
		Endif
	Else
		MsgInfo('Código informado não localizado.')
	Endif
Return 
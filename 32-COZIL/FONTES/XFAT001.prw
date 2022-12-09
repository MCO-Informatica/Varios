#INCLUDE "PROTHEUS.CH"

User Function XFAT001()                 

	Local aArea   := GetArea()
	Local aSay    := {}
	Local aButton := {}
	Local nOpc    := 0
	Local cTitulo := "Atualização dos custos dos produtos - SB1"
	Local cDesc1  := "Esta rotina tem como objetivo atualizar o campo B1_XCUSTO"
	Local cDesc2  := ""
	Local cDesc3  := ""
	
	Private cPerg	  := "XFAT001"
	
	Pergunte(cPerg,.F.)
	
	// Criando array com descricao do programa para adicionar no FormBatch.
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	
	// Criando array com botoes do FormBatch.                              
	aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T.)     }} )
	aAdd( aButton, { 1, .T., {|| FechaBatch()            }} )
	aAdd( aButton, { 2, .T., {|| nOpc := 2, FechaBatch() }} )
	
	// Funcao que ativa o FormBatch.                                       
	FormBatch( cTitulo, aSay, aButton )
	
	If nOpc == 2 // cancelou a rotina
		RestArea( aArea )
		Return
	Endif
	
	//XFAT001_01()     
	
	Processa( {|lEnd| XFAT001_01(@lEnd)}, "Aguarde...", "Executando rotina.", .T.)  // Barra de processamento
	
	RestArea( aArea )	
Return()
	
	
Static Function XFAT001_01(lEnd)	
	
	Local nCnt	:= 0	//Variavel para barra de processamento                                            
	
	Local aEstrutura		:= {}                                
	Local nValor	:= 0
	Local nValorMod	:= 0
	
	Local cProdIni	:= AllTrim(MV_PAR01)
	Local cProdFim	:= AllTrim(MV_PAR02)
	
	Local i := 1      
	
	Local iRegSB1 := 0

	dbSelectArea("SB1")
	dbSetOrder(2)            
	
	SB1->(MsSeek(xFilial("SB1") + "PA" + cProdIni))
	          
	ProcRegua(nCnt) // Barra de progresso
	
	While !SB1->(EOF()) .And. SB1->B1_TIPO == "PA" .And. (SB1->B1_COD < cProdFim .Or. AllTrim(SB1->B1_COD) == AllTrim(cProdFim)) // O operador <= estava com problema. passando do ponto desejado.. :(
		
		IncProc("Processando produto: " + SB1->B1_COD)
		If lEnd
			MsgInfo(cCancela, "Rotina cancelada.")
			Exit
		EndIf
				    
		//Posiciona SB1 no registro corrente.
		iRegSB1 := SB1->(Recno())
		
		aEstrutura	:= {}
		nValor := 0                     
		nValorMod := 0
		i	:= 1        

		dbSelectArea("SG1")
		dbSetOrder(1)	   
		
		Aadd(aEstrutura, {SB1->B1_COD, SB1->B1_COD, 1, 1, 1,0}) // aEstrutura{PAI, COMP, QTD PAI, QTD, QTD PAI * QTD, PERDA}

		While Len(aEstrutura) >= i 
			SG1->(MsSeek(xFilial("SG1") + aEstrutura[i][2]))
			If SG1->(EOF())                    
				SB1->(dbSetOrder(1))
				SB1->(MsSeek(xFilial("SB1") + aEstrutura[i][2]))
				If !SB1->(EOF())
					If AllTrim(Substr(SB1->B1_COD, 1, 3)) == "MOD"
						nValorMod += (aEstrutura[i][5] / (100 - aEstrutura[i][6]) * 100) * SB1->B1_UPRC
					Else      
						nValor += (aEstrutura[i][5] / (100 - aEstrutura[i][6]) * 100) * SB1->B1_UPRC
					EndIf
				EndIf
				//nValor += (aEstrutura[i][5] / (100 - aEstrutura[i][6]) * 100) * Posicione("SB1",1,xFilial("SB1")+aEstrutura[i][2],"B1_UPRC")
			EndIf					
			While SG1->(!EOF()) .And. AllTrim(SG1->G1_COD) == AllTrim(aEstrutura[i][2])
				Aadd(aEstrutura, {SG1->G1_COD, SG1->G1_COMP, aEstrutura[i][5], SG1->G1_QUANT,  aEstrutura[i][5] * SG1->G1_QUANT, SG1->G1_PERDA} )
				
	    		SG1->(dbSkip())                            
			EndDo                                                  		
			i++
		EndDo		
		
		//Acerta o posicionamento do SB1
		SB1->(dbSetOrder(2))		                                         
		SB1->(dbGoTo(iRegSB1))   
		    
		//Faz a gravacao do banco de dados
		Reclock("SB1",.F.)
			SB1->B1_XCUSTO 	:= nValor  
			SB1->B1_XCMOD		:= nValorMod
		MsUnlock()
		
		SB1->(dbSkip())
		
	EndDo                      
Return
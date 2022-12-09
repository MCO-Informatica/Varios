#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

user function MT120GRV()
		
		Local aMatriz2 		:= {}
		Local aMatriz		:= {}
		Local nI 			:= 0
		Local nI2 			:= 0
		Local nI3 			:= 0
		Local nI5 			:= 0
		Local cItemConta 	:= ""
		Local cMensagem2 	:= ""
		Local cMensagem 	:= ""
		Local cCTRVB		:= ""
		Local cFornece		:= ""
		
		Local cXNotas 		:= ""
		
		Local cNum			:= CA120NUM
		
		Local nTPIC			:= ""
		
		Local nTotalOCA		:= 0
		Local nTotalOCP		:= 0
		
		Local nXMATPRP	

		local nTotACPR		:= 0
		local nTotCUPR		:= 0
		
		local cMensMPR 		:= ""
		local cMensCom		:= "" 
		local cMensFab		:= ""
		local cMensSRV		:= ""
		local cMensFRT		:= ""
		local cMensESL		:= ""
		
		Local cItemCTA		:= ""
		local cFornece		:= ""
		local cDFornece		:= ""
		local dDTIso		:= ""

		local nI1,nI2,nI3,nI4,nI5,nI6, nI7

		Private nTotal		:= 0
		Private lRet		:= .T.
		Private nTotalOLD	:= 0
		
		// Validação ISO
		/*dbSelectArea("SC7")
		SC7->( dbSetOrder(1))
		if SC7->( dbSeek(xFilial("SC7")+cNum) ) // == .F. .OR. Empty(cNum)
			cFornece := SC7->C7_FORNECE
			cDFornece := Posicione("SA2",1,xFilial("SA2") + cFornece, "A2_NOME")
			dDTIso		:= Posicione("SA2",1,xFilial("SA2") + cFornece, "A2_XDTISO")
			if !empty(dDTIso) .AND. dDTIso <= dDataBase
				msginfo("Fornecedor " + cDFornece + " está com data do ISO vencida (" + dtoc(dDTIso) + "). Pedido de Compra não pode ser cadastrado, atualize o ISO.")
				return .F. 
			endif
		endif*/
		
		
		//Private l120Deleta := paramixb[4] // Flag de Exclusï¿½o
		// Controle de Verba
		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
	
		for nI=1 to Len( aCOLS )
			AAdd( aMatriz,  ALLTRIM(aCols[nI][3]),nI )
			if ascan(aMatriz2,aMatriz[nI]) = 0 
				aadd(aMatriz2,aMatriz[nI]) 
			endif
			//cNum := ALLTRIM(aCols[nI][1])
			cCTRVB	:=  ALLTRIM(aCols[nI][95])  
		next      
		

		for nI=1 to len(aMatriz2) 
			//alert(aMatriz2[nI]+"aaa")
			cMensagem += aMatriz[nI] + chr(13) + chr(10)
		next  
			
		for nI3 = 1 to Len(aMatriz2)
			
			//nTotal := 0
			cItemICM := alltrim(aMatriz2[nI3])
			
			if  cItemICM $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES/ESTOQUE")
				nTPIC := "2"
			else
				nTPIC := "1"
			endif
			
			/***************** Pedido armazenado**************/
			dbSelectArea("SC7")
			SC7->( dbSetOrder(1))
			SC7->(dbgotop())

			
			If SC7->( dbSeek(xFilial("SC7")+cNum) ) // == .F. .OR. Empty(cNum)

				While SC7->(!eof())
					
					if cNum == alltrim(SC7->C7_NUM)
						
						nTotalOLD 	+=  round(SC7->C7_TOTAL *(1-((SC7->C7_IPI/100)+((SC7->C7_PICM/100))+((SC7->C7_XPPIS/100)))),2) //SC7->C7_TOTAL 
		
					endif
					SC7->(dbskip())
				enddo
			endif
			
			/**************** fim pedido armazenando*********/
			// Soma de valores do Item Conta
			for nI2=1 to Len( aCOLS )
				if ALLTRIM(aCols[nI2][3]) == cItemICM //.AND. ! ALLTRIM(aCols[nI2][2]) $ ("ADMINISTRACAO'/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES")	
					nValCof			:= 0.076
					nValPIS 		:= 0.0165 
					nTotal +=  round(aCols[nI2][9]*(1-((aCols[nI2][16]/100)+((aCols[nI2][17]/100))+((aCols[nI2][18]/100)))),2) //round(aCols[nI2][10],2)
					//SC7->C7_XTOTSI 	:= aCols[nI2][10]*(1-((aCols[nI2][16]/100)+(nValPIS/100)+(nValCof/100)))
				endif
			next
			
			//msginfo ( "Total ANTERIOR: " + cValToChar(nTotalOLD) )
			//msginfo ( "Total ATUAL:" + cValToChar(nTotal) )
			
			if round(nTotal,2) > round(nTotalOLD,2) .OR. !SC7->( dbSeek(xFilial("SC7")+cNum) )
		
				for nI5=1 to Len( aCOLS )
				
					//MSGINFO( "96: " + aCols[nI5][96] +  "95: " + aCols[nI5][95] + "94: " + aCols[nI5][94] + "93: " + aCols[nI5][93] + "92: " + aCols[nI5][92] )
					
					//RecLock("SC7",.F.)
					
					if  aCols[nI5][3] $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES/ESTOQUE")
						aCols[nI5][96] := "3" //aCols[nI5][96] := "3"
						aCols[nI5][95] := ""
						aCols[nI5][94] := ""
										
					elseif  nTotal < 5000 .AND. ! aCols[nI5][3] $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES/ESTOQUE") //nTPIC = "1"
						aCols[nI5][96] := "2"
						aCols[nI5][95] := ""
						aCols[nI5][94] := ""
					elseif  nTotal >= 5000 .AND. ! aCols[nI5][3] $ ("ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/OPERACOES/ESTOQUE") //nTPIC = "1"
						aCols[nI5][96] := "1"
						aCols[nI5][95] := ""
						aCols[nI5][94] := ""
					endif
					//MsUnlock() 		
				next
		   endif
			
			If  SC7->( dbSeek(xFilial("SC7")+cNum) ) 
				
				//msginfo("pedido localizado")
				//if _aParam[1] == 3  //if cCTRVB <> "1"
				//if nTotalReal > nTotal
				//	nTotal := 0
				//endif
				
				if round(nTotal,2) > round(nTotalOLD,2) /*****************/
			
			
					if ! ALLTRIM(cItemICM) $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHA/OPERACOES/ESTOQUE" 
						
						if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
						
							 nTotACPR := round(CTD->CTD_XACPR + (nTotal - nTotalOLD),2)
							 nTotCUPR := round(CTD->CTD_XCUPRR,2)
							 
													 
							 //((nMPR+nCOM+nFAB+nSRV+nFRT+nESL)-(nMPRA+nCOMA+nFABA+nSRVA+nFRTA+nESLA))
	
								 if  round(nTotACPR,2) > round(nTotCUPR,2)
								 /* round((nVBMATPA +(nMPR-nMPRA)),2) > round(nVBMATPR,2) .AND. nMPR > 0 .OR. ;
								 	round((nVBCOMEA +(nCOM-nCOMA)),2) > round(nVBCOMEA,2) .AND. nCOM > 0 .OR. ;
								 	round((nVBFABRA +(nFAB-nFABA)),2) > round(nVBCOMEA,2) .AND. nFAB > 0.OR. ;
								 	round((nVBSERVA +(nSRV-nSRVA)),2) > round(nVBCOMEA,2) .AND. nSRV > 0 .OR. ;
								 	round((nVBFRETA +(nFRT-nFRTA)),2) > round(nVBCOMEA,2) .AND. nFRT > 0 .OR. ;
								 	round((nVBENGSA +(nESL-nESLA)),2) > round(nVBCOMEA,2) .AND. nESL > 0.OR. ;*/
								 	
								 	
								 	alert("Ordem de Compra " + cNum + " supera verba do Contrato. Solicite verba adicional a Diretoria. " + CRLF + CRLF + ;
								 	"Contrato: " + cItemICM + CRLF + CRLF +;
								 	"Verba s/ Tributos " + cValToChar(Transform(nTotCUPR,"@E 999,999,999.99")) + CRLF +;
								 	"Verba adicional s/ Tributos " + cValToChar(Transform(CTD->CTD_XVBAD,"@E 999,999,999.99")) + CRLF + CRLF +;
								 	"Total Verba" + cValToChar(Transform(CTD->CTD_XVBAD+nTotCUPR,"@E 999,999,999.99")) + CRLF + CRLF +;
								 	"Custo Atual s/ Tributos: " + cValToChar(Transform(CTD->CTD_XACPR,"@E 999,999,999.99")) + CRLF + CRLF +  ;
								 	"Alteracao da OC esta adicionando o valor de: " + cValToChar(Transform(nTotal-nTotalOLD,"@E 999,999,999.99")) +  CRLF + CRLF + "Ordem de Compra nï¿½o pode ser salva. " )
								 	
								 	lRet		:= .F.
								 	
								 endif
							
						endif
				
					endif

				endif
			
			else
					
					
				//if round(nTotal,2) > round(nTotalOCA,2)
					//**
					if ! ALLTRIM(cItemICM) $ "ADMINISTRACAO/PROPOSTA/QUALIDADE/ATIVO/ENGENHARIA/ZZZZZZZZZZZZZ/XXXXXX/ENGENHARIA/ESTOQUE/OPERACOES" 
						
						if CTD->( dbSeek( xFilial("CTD")+cItemICM) )
						
							 nTotACPR := CTD->CTD_XACPR + nTotal 
							 nTotCUPR := CTD->CTD_XCUPRR 
						 
							 //if round(nTotal,2) > round(nTotalOCA,2)
							 
								 if  round(nTotACPR,2) > round(nTotCUPR,2)
																 	
								 	alert("Ordem de Compra " + cNum + " supera verba do Contrato. Solicite verba adicional a Diretoria. " + CRLF + CRLF + ;
								 	"Contrato: " + cItemICM + CRLF + CRLF +;
								 	"Verba s/ Tributos " + cValToChar(Transform(nTotCUPR,"@E 999,999,999.99")) + CRLF +;
								 	"Verba adicional s/ Tributos " + cValToChar(Transform(CTD->CTD_XVBAD,"@E 999,999,999.99")) + CRLF + CRLF +;
								 	"Total Verba" + cValToChar(Transform(CTD->CTD_XVBAD+nTotCUPR,"@E 999,999,999.99")) + CRLF + CRLF +;
								 	"Custo Atual s/ Tributos: " + cValToChar(Transform(CTD->CTD_XACPR,"@E 999,999,999.99")) + CRLF + CRLF +  ;
								 	"Alteraï¿½ï¿½o da OC estï¿½ adicionando o valor de: " + cValToChar(Transform(nTotal-nTotalOLD,"@E 999,999,999.99")) +  CRLF + CRLF + "Ordem de Compra nï¿½o pode ser salva. " )
								 	
								 	lRet		:= .F.
			
								 endif
							 
							 	//msginfo("total anterior: " + cValtoChar(nTotalOCA))
							 	//msginfo("total posterior: " + cValtoChar(nTotal))
							 	
							 //endif
							
						endif
						
					endif
	
			endif
			
			nTotACPR		:= 0
			nTotCUPR		:= 0
			
			
		next
		
		//msginfo("Total: " + cValToChar(Transform(nTotal,"@E 999,999,999.99")) +   " Total Real: " + cValToChar(Transform(nTotalReal,"@E 999,999,999.99")))
		
		for nI6=1 to Len( aCOLS )
			if !Empty(aCols[nI6][30])
				cXNotas := aCols[nI6][30]
				nI6 := Len( aCOLS )+1 
			endif 
		next
		
		for nI7=1 to Len( aCOLS )
			 aCols[nI7][30] := cXNotas 
		next
	
SC7->(dbclosearea())
CTD->(dbclosearea())
		
return lRet


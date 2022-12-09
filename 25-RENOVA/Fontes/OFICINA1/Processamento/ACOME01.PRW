/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACOME01    ºAutor  ³Felipi Marques     º Data ³  03/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que realiza a gravação na tabela Z01 (CHAVES NFE).   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/            

User Function ACOME01( cChave, cRotina, cNSU, cUltNSU, cSchema, cStatEvento, cStatDown, cRetWS,dDhRecbto,oDFe )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aZ01area := Z01->(GetArea())
Local lRet	   := .F.  
Local cError   := ""
Local cWarning := ""

oDFe	    := XmlParser( cRetWS, "_", @cError, @cWarning)
	
Z01->(DbSetOrder(1)) //FILIAL+CHAVE
If !Empty(cChave)
	If Z01->(!DbSeek(xFilial("Z01")+cChave)) 
	
		If cSchema $ SuperGetMv("ES_SCHCHV",.F.,"resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
	
			Begin Transaction
		
				RecLock("Z01",.T.)
					Z01_FILIAL 	:= xFilial("Z01")
				    Z01_CHVNFE 	:= cChave
				    Z01_NSU		:= cNSU  
				    Z01_NUMNFE	:= Substr(cChave,26,9)
				    Z01_SERNFE	:= Substr(cChave,23,3)
				    Z01_STAXML 	:= cStatEvento
				    Z01_STADOW 	:= cStatDown
				    Z01_SCHEMA  := cSchema
				    Z01_ROTINA	:= cRotina
				    Z01_RETWS	:= cRetWs
				    Z01_DTEMIS	:= dDhRecbto
					Z01_HORA  	:= Substr(StrTran(AllTrim(oDFe:_RESNFE:_DHEMI:TEXT),"-",""),10,5)
				    Z01_CGC     := oDFe:_RESNFE:_CNPJ:TEXT
				    Z01_NOME    := oDFe:_RESNFE:_XNOME:TEXT
				    Z01_INSCR   := oDFe:_RESNFE:_IE:TEXT
				    Z01_TOTAL   := Val(oDFe:_RESNFE:_VNF:TEXT)
				    Z01_PROT    := oDFe:_RESNFE:_NPROT:TEXT
				MsUnlock()
			
				lRet := .T.
			                    
			End Transaction
		Else
			Conout("ACOME01 58 -> SCHEMA: "+cSchema+" ES_SCHCHV: "+SuperGetMv("ES_SCHCHV",.F.,"resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd"))
		EndIf
		
	Else                                  
	
		If cSchema $ SuperGetMv("ES_SCHCHV",.F.,"resNFe_v1.00.xsd|procEventoNFe_v1.00.xsd")
		
			Begin Transaction
				
				If AllTrim(Z01->Z01_SCHEMA) != AllTrim(cSchema)
			
					RecLock("Z01", .T.)
						Z01_FILIAL 	:= xFilial("Z01")
					    Z01_CHVNFE 	:= cChave
					    Z01_NSU		:= cNSU  
					    Z01_NUMNFE	:= Substr(cChave,26,9)
					    Z01_SERNFE	:= Substr(cChave,23,3)
					    Z01_STAXML 	:= cStatEvento
					    Z01_STADOW 	:= cStatDown
					    Z01_SCHEMA  := cSchema
					    Z01_ROTINA	:= cRotina
					    Z01_RETWS	:= cRetWs
					    Z01_DTEMIS	:= dDhRecbto
						Z01_HORA  	:= Substr(StrTran(AllTrim(oDFe:_RESNFE:_DHEMI:TEXT),"-",""),10,5)
					    Z01_CGC     := oDFe:_RESNFE:_CNPJ:TEXT
					    Z01_NOME    := oDFe:_RESNFE:_XNOME:TEXT
					    Z01_INSCR   := oDFe:_RESNFE:_IE:TEXT
					    Z01_TOTAL   := Val(oDFe:_RESNFE:_VNF:TEXT)
					    Z01_PROT    := oDFe:_RESNFE:_NPROT:TEXT
					MsUnlock()
						
				Else 
				
					RecLock("Z01", .F.)
						Z01_FILIAL 	:= xFilial("Z01")
					    Z01_CHVNFE 	:= cChave
					    Z01_NSU		:= cNSU  
					    Z01_NUMNFE	:= Substr(cChave,26,9)
					    Z01_SERNFE	:= Substr(cChave,23,3)
					    Z01_STAXML 	:= cStatEvento
					    Z01_STADOW 	:= cStatDown
					    Z01_SCHEMA  := cSchema
					    Z01_ROTINA	:= cRotina
					    Z01_RETWS	:= cRetWs
					    Z01_DTEMIS	:= dDhRecbto
						Z01_HORA  	:= Substr(StrTran(AllTrim(oDFe:_RESNFE:_DHEMI:TEXT),"-",""),10,5)
					    Z01_CGC     := oDFe:_RESNFE:_CNPJ:TEXT
					    Z01_NOME    := oDFe:_RESNFE:_XNOME:TEXT
					    Z01_INSCR   := oDFe:_RESNFE:_IE:TEXT
					    Z01_TOTAL   := Val(oDFe:_RESNFE:_VNF:TEXT)
					    Z01_PROT    := oDFe:_RESNFE:_NPROT:TEXT
					MsUnlock()			
				
				EndIf                         	
				
				lRet := .T.
				
			End Transaction
			
		EndIf
	EndIf
EndIf
	
RestArea(aZ01area)
	
Return lRet
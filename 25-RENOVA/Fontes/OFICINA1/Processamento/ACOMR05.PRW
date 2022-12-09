#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACOMR05   ºAutor  ³Felipi Marques      º Data ³  04/02/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que realiza a chamada do WS responsável por realizar º±±
±±º          ³o Ciencia da NF junto a SEFAZ                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³	                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ACOMR05( cTpAmb, cUfAutor, cCNPJ, nNumImp, cChave,cEvento,cJust )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oWS
Local cBeginReq
Local cEndReq
Local cLote

Local cRequest
Local cTpEvento
Local cSeqEvento
Local cDescEvento
Local cOrgao
Local cJustific
Local cRotina	 := "CIENCIA"
Local cStat := "" // MH 07/01/2019
Local nLimSef := SuperGetMv("ES_LIMSEF",,90) // Limite de dias que o Sefaz disponibiliza notas - MH 07/01/2019 

Private cIdEnt	//:= "001561" // RetIdEnti()
				
DbSelectArea("Z05")
Z05->(DbSetOrder(2))   
IF Z05->(dbSeek(xFilial("Z05")+Alltrim(cCNPJ) )) 
	cIdEnt := Z05-> Z05_CODIGO
Else
	Conout( "| ACOMR05 | Não encontrado o cadastro da endidade" ) 
EndIf

If nNumImp == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Cabeçario do Xml                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oWs 				:= &(SuperGetMv("ES_WSEVENT"	,.F.,"WSRecepcaoEvento():New()"))
	cBeginReq   		:= SuperGetMv("ES_BEVECHV"		,.F.,'<envEvento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">')
	cEndReq				:= SuperGetMv("ES_EEVECHV"		,.F.,'</envEvento>')
	cLote 				:= SuperGetMv("ES_LOTEXML"		,.F.,"000000000000001")
	cSeqEvento			:= SuperGetMv("ES_SEQEVEN"		,.F.,"01")
	cOrgao				:= SuperGetMv("ES_ORGAO"		,.F.,"91")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
	//³210200–Confirmação da Operação       ³
	//³210210–Ciência da Operação           ³
	//³210220–Desconhecimento da Operação   ³
	//³210240–Operação não Realizada        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
	cTpEvento	:= SubStr(cEvento,1,6)
	cDescEvento	:= SubStr(cEvento,8,30)
	
	If     "210200" $ cTpEvento
		cStatus := "1"  //"Confirmada"
	ElseIf "210220" $ cTpEvento
		cStatus := "2"  //"Desconhecida"
	ElseIf "210240" $ cTpEvento
		cStatus := "3"  //"Não realizada"
	ElseIf "210210" $ cTpEvento
		cStatus := "4"  //"Ciência"
	Else
		cStatus := "0"  //"Sem manifestação"
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Informar a justificativa porque a operação não foi realizada, este³
	//³campo deve ser informado somente no evento de Operação não        ³
	//³Realizada.                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cJustific       := cJust
	
	cRequest 			:= '<idLote>'			+	cLote  +	'</idLote>'
	cRequest			+= '<evento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">'
	cRequest			+= '<infEvento Id="ID'	+ cTpEvento+cChave+cSeqEvento	+	'">'
	cRequest			+= '<cOrgao>'			+ cOrgao +'</cOrgao>'
	cRequest			+= '<tpAmb>'			+ cTpAmb   +'</tpAmb>'
	cRequest			+= '<CNPJ>'				+ cCNPJ	   +'</CNPJ>'
	cRequest			+= '<chNFe>'			+ cChave   +'</chNFe>'
	cRequest			+= '<dhEvento>'			+ GetDtEvento( dDataBase, Time(),cCNPJ )+'</dhEvento>'
	cRequest			+= '<tpEvento>'			+cTpEvento	+	'</tpEvento>'
	cRequest			+= '<nSeqEvento>'		+CvalToChar(Val(cSeqEvento))	+	'</nSeqEvento>'
	cRequest			+= '<verEvento>1.00</verEvento>'
	
	cRequest			+= '<detEvento versao="1.00">'
	
	//cDescEvento += " PTH.acomr05"
	
	If  '210240' $ cTpEvento .and. !Empty(cJustific) 
		cRequest			+= '	<descEvento>'	+cDescEvento+	'</descEvento>'
		cRequest			+= '	<xJust>'     	+Alltrim(cJustific)+   	'</xJust>'
	Else
		cRequest			+= '	<descEvento>'	+cDescEvento+	'</descEvento>'
//		cRequest			+= '	<xJust>'     	+ "PRTH.ciencia.acomr05" +	'</xJust>'
	EndIf
	
	cRequest			+= '</detEvento>'
	cRequest			+= '</infEvento>'
	cRequest			+= '</evento>'
	
	cRequest			:= U_XSpedSignXML(encodeUTF8(cBeginReq+cRequest+cEndReq),"infEvento","Id", cIdEnt )
	
	oWS:cCUf			:= cUfAutor
	oWS:cVersaoDados	:= '1.00'
	oWs:oWs				:= cRequest
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ WS Manifesto da NF junto a SEFAZ                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

	If !( oWS:nfeRecepcaoEvento() )
		If !(Empty( GetWSCError(3)))
			Conout( SubStr( GetWSCError(3), At(":", GetWSCError(3) ) + 1 ) )
		Else 
			Conout( GetWSCError(1) )
			Conout( " Problema na Execução do Webservice! " )
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Modifica o status da chave manifestada                                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Se deu erro no Sefaz, não alterar o status do registro
		/* 
		Z01->(DbSetOrder(1))
		If Z01->(DbSeek(xFilial("Z01")+cChave))
			RecLock("Z01",.F.)
			Z01->Z01_STAXML 	:= "4"
			MsUnlock()
		EndIf
		*/ 
		cStat    := "XX"
		cMotivo  := "Web Service Sefaz Indisponivel "+If(.NOT.Empty(GetWSCError(3)),GetWSCError(3),GetWSCError(1))    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravação do log do motivo do erro.                                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		U_ACOME04( cChave, cRotina, "", "", cMotivo, cStat, If(.NOT.Empty(GetWSCError(3)),GetWSCError(3),GetWSCError(1)) )
	Else
		//RESULTADO DO PROCESSAMENTO DA SOLICITAÇÃO
		//128 Lote de Evento Processado
		//135 Evento registrado e vinculado a NF-e
		//136 Evento registrado, mas não vinculado a NF-e
		If oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT $ SuperGetMv("ES_ENVSTAT", .F., "128|135|136")
			cMotivo := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT
			cStat   := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT
			Conout( "ACOMR05 - "+cMotivo + cStatus )
			//VarInfo("OWS",oWS)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Evento de Ciencia de Operação realizado..  ¿
			//³ Parametro: Chave , Ciencia                ¿
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			U_ACOMR04( cChave, .T.,cStatus )

		// Tratar Nfe Cancelada ou Denegada como Status definitivos e não processar mais		
		ElseIf oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT $ "650/653/654"
			cMotivo := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT
			cStat   := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT    

			//³ Modifica o status da chave manifestada                                                                      ³

			Z01->(DbSetOrder(1))
			If Z01->(DbSeek(xFilial("Z01")+cChave)) 
				RecLock("Z01",.F.)
			   		Z01->Z01_STAXML 	:= "6"  
			   		Z01->Z01_STADOW 	:= "2"  
		   		MsUnlock()
		   		Conout( "ERRO ACOMR05 - "+cMotivo + " "+cStatus+" NFE: "+Z01->Z01_NUMNFE+" CHAVE: "+Z01->Z01_CHVNFE )
			EndIf   

			//³Gravação do log do motivo do erro.                                                                           ³
			U_ACOME04( cChave, cRotina, "", "", cMotivo, cStat, "" )		

		// Tratar Nfe não existente no Sefaz por decurso de prazo		
		ElseIf oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT $ "137" 
			cMotivo := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT
			cStat   := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT    

			//³ Modifica o status da chave não localizada                                                                      ³

			Z01->(DbSetOrder(1))
			If Z01->(DbSeek(xFilial("Z01")+cChave)) 
				If (Date() - Z01->Z01_DTEMIS) > nLimSef 
					RecLock("Z01",.F.)
			   		Z01->Z01_STAXML 	:= "7"  
			   		Z01->Z01_STADOW 	:= "3"  
			   		MsUnlock()
		   		EndIf   

		   		//³Gravação do log do motivo do erro.                                                                           ³
	   	   		U_ACOME04( cChave, cRotina, "", "", "Nfe indisponível por decurso de Prazo", cStat, "" )		

		   	Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³POR ALGUM MOTIVO NÃO HOUVE ATENDIMENTO DA SOLICITAÇÃO³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Else
			cMotivo := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_XMOTIVO:TEXT
			cStat   := oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_CSTAT:TEXT    

			// Verifica se a rejeição é por Ciência já realizada e acerta o status - MH 28/12/2018			
			If "DUPLICIDADE DE EVENTO" $ Upper(cMotivo)                                           
				If oWs:oWs:_RETENVEVENTO:_RETEVENTO:_INFEVENTO:_TPEVENTO:TEXT = cTpEvento

					DbSelectArea("Z01")
					Z01->(DbSetOrder(1))
					If Z01->(DbSeek(xFilial("Z01")+cChave))
						If Z01_STAXML $  ('1*5*0') .And. Z01_STADOW == '1'
							RecLock("Z01",.F.)
							Z01->Z01_STAXML	:= "4"
							MsUnlock()
						Endif	
					Endif
				Endif	
			Else		
					 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Modifica o status da chave manifestada                                                                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("Z01")
				Z01->(DbSetOrder(1))
				If Z01->(DbSeek(xFilial("Z01")+cChave))
					RecLock("Z01",.F.)
					Z01->Z01_STAXML 	:= "5"
					MsUnlock()
				EndIf
				Conout( "ERRO ACOMR05 - "+cMotivo + cStatus )
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Gravação do log do motivo do erro.                                                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				U_ACOME04( cChave, cRotina, "", "", cMotivo, cStat, "" )
			EndIf
		Endif	
	EndIf
	
EndIf

Return cStat

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³SpedSign     ³ Autor ³Felipi Marques       ³ Data ³16/03/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de assinatura de um XML no padrao X.509              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1: String                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1: String com o XML que sera assinado                   ³±±
±±³          ³ExpC2: Tag que sera assinada                                ³±±
±±³          ³ExpC3: Tag que contem o ID                                  ³±±
±±³          ³ExpC4: Id da entidade                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function U_XSpedSignXML(cXML,cTag,cAttID,cIdEnt)

Local cXmlToSign  := ""
Local cURI        := ""
Local cDir        := IIf(IsSrvUnix(),"certs/", "certs\")
Local cRootPath   := StrTran(GetSrvProfString("RootPath","")+IIf(!IsSrvUnix(),"\","/"),IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
Local cStartPath  := StrTran(cRootPath+IIf(!IsSrvUnix(),"\","/")+GetSrvProfString("StartPath","")+IIf(!IsSrvUnix(),"\","/"),IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
Local cArqXML     := Lower(CriaTrab(,.F.))
Local cMacro      := ""
Local cError      := ""
Local cWarning    := ""
Local cDigest     := ""
Local cSignature  := ""
Local cSignInfo   := ""
Local cIniXml     := ""
Local cFimXml     := ""
Local cNameSpace  := ""
Local cNewTag     := ""
Local cThreadID	  := GetSrvProfString("SPED_THREADID","0")
Local nAt         := 0
Local nAtVer  	  := 0
Local aConfSSL    := {}

cRootPath  := StrTran(cRootPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))
cStartPath := StrTran(cStartPath,IIf(!IsSrvUnix(),"\\","//"),IIf(!IsSrvUnix(),"\","/"))

//dbSelectArea("SPED001")
//dbSetOrder(1)
//MsSeek(cIdEnt)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtenho a URI                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cUri := NfeIdSPED(cXML,cAttId)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Assina a NFe                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case  FindFunction("EVPPrivSign")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Canoniza o XML                                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cXmlToSign := XmlC14N(cXml, "", @cError, @cWarning)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para troca de caracter referente ao xml da ANFAVEA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cXmlToSign := (StrTran(cXmlToSign,"&lt;/","</"))
		cXmlToSign = (StrTran(cXmlToSign,"/&gt;","/>"))
		cXmlToSign = (StrTran(cXmlToSign,"&lt;","<"))
		cXmlToSign = (StrTran(cXmlToSign,"&gt;",">"))
		cXmlToSign = (StrTran(cXmlToSign,"<![CDATA[[ ","<![CDATA["))
		//		varinfo("cXmlToSign : ",cXmlToSign)
		
		If Empty(cError) .And. Empty(cWarning)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retira a Tag anterior a tag de assinatura                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nAt := At("<"+cTag,cXmlToSign)
			cIniXML    := SubStr(cXmlToSign,1,nAt-1)
			cIniXml := StrTran(cIniXml, '<evento versao="1.00">','<evento xmlns="http://www.portalfiscal.inf.br/nfe" versao="1.00">')
			cXmlToSign := SubStr(cXmlToSign,nAt)
			nAt := At("</"+cTag+">",cXmltoSign)
			cFimXML    := SubStr(cXmltoSign,nAt+Len(cTag)+3)
			cXmlToSign := SubStr(cXmlToSign,1,nAt+Len(cTag)+2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Descobre o namespace complementar da tag de assinatura                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNewTag := AllTrim(cIniXml)
			cNewTag := SubStr(cIniXml,2,At(" ",cIniXml)-2)
			cNameSpace := StrTran(cIniXml,"<"+cNewTag,"")
			cNameSpace := AllTrim(StrTran(cNameSpace,">",""))
			nAtver := At("versao",cNameSpace) // Pode ter um atributo versao Ex. ( xmlns="http://" versao="1.01")
			If nAtver > 0
				cNameSpace := SubStr(cNameSpace, 1, nAtver-1) // -2 por causa do espaco
				cNameSpace := RTrim(cNameSpace)
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o DigestValue da assinatura                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cDigest := StrTran(cXmlToSign,"<"+cTag+" ","<"+cTag +" "+cNameSpace+" ")
			cDigest := XmlC14N(cDigest, "", @cError, @cWarning)
			cMacro  := "EVPDigest"
			cDigest := Encode64(&cMacro.( cDigest , 3 ))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o SignedInfo  da assinatura                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cSignInfo := NfeSignedInfo(cUri,cDigest)
			cSignInfo := XmlC14N(cSignInfo, "", @cError, @cWarning)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Busca Informação sobre certificado                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aConfSSL := U_ACOMR09(cIdEnt, @cError )
			
			If Empty(aConfSSL )
				Conout("Erro Abertura Certificado - U_XSpedSignXML")
				Return()
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Assina o XML                                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SuperGetMv("ES_HSM",.F.,"0")=="0"
				cMacro   := "EVPPrivSign"
				cSignature := &cMacro.( aConfSSL[2] , cSignInfo , 3 , AllTrim(aConfSSL[3]) , @cError)
			Else
				cMacro   := "HSMPrivSign"
				cSignature := &cMacro.("slot_"+SuperGetMv("ES_HSMSLOT",.F.,"000001")+"-label_"+SuperGetMv("ES_HSMLABE",.F.,"000001"), cSignInfo , 3 , @cError, AllTrim(Z05->Z5_SENHA)  )
			EndIf
			cSignature := Encode64(cSignature)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Envelopa a assinatura                                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// cCert := GetCertificate(IIf(IsSrvUnix(),"/", "\")+cDir+"000001"+"_cert.pem"  ,SuperGetMv("ES_HSM",.F.,"000001")=="1"   ,"000001")
			cCert := GetCertificate( IIf(IsSrvUnix(),"/", "\")+cDir+ cIdEnt +"_cert.pem"  , SuperGetMv("ES_HSM",.F.,"000001")=="1"  , cIdEnt )
			If !Empty(cCert)
				cXmlToSign += '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">'
				cXmltoSign += cSignInfo
				cXmlToSign += '<SignatureValue>'+cSignature+'</SignatureValue>'
				cXmltoSign += '<KeyInfo>'
				cXmltoSign += '<X509Data>'
				cXmltoSign += '<X509Certificate>'+cCert+'</X509Certificate>'
				cXmltoSign += '</X509Data>'
				cXmltoSign += '</KeyInfo>'
				cXmltoSign += '</Signature>'
				cXmlToSign := cIniXML+cXmlToSign+cFimXML
			Else
				cXmlToSign:= ""
			EndIf
		Else
			cXmlToSign := cXml
			ConOut(IIF(cThreadID=="1",'ThreadID='+AllTrim(Str(ThreadID(),15)),"")+" - Sign Error thread: "+cError+"/"+cWarning)
		EndIf
	Case FindFunction("NFeSign")
		cMacro := "NFeSign"
		&cMacro.('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE test [<!ATTLIST '+cTag+' Id ID #IMPLIED>]>'+cXML,"#"+cURI,cStartPath+cArqXML+".xml",cRootPath+cDir+"000001"+"_key.pem",Decode64(AllTrim(SPED001->PASSCERT)),cRootPath+cDir+"000001"+"_cert.pem")
		
		cXmlToSign := NfeLoadTXT(cArqXml+".xml")
		FErase(cArqXml+".xml")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Confirma se houve a assinatura                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !"DIGESTVALUE"$Upper(cXmltoSign)
			cXmlToSign := ""
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Retira o AttList da mensagem assinada                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Do Case
				Case (nAt := At("<NFe",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<inutNFe",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<cancNFe",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<CTe",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<inutCTe",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<cancCTe",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<envDPEC",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<EnviarLoteRpsEnvio",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<Rps",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
				Case (nAt := At("<Pedido",cXmlToSign))<>0
					cXmlToSign := SubStr(cXmlToSign,nAt)
			EndCase
		EndIf
EndCase

Return(cXmlToSign)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NfeSignedInfoºAutor  ³Microsiga           º Data ³  04/15/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta a estrutura de assinatura do XML                         º±±
±±º          ³                                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        	 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NfeSignedInfo(cUri,cDigest)

Local cSignedInfo := ""

cSignedInfo += '<SignedInfo xmlns="http://www.w3.org/2000/09/xmldsig#">'
cSignedInfo += '<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
cSignedInfo += '<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1"/>'
cSignedInfo += '<Reference URI="#'+ cUri +'">'
cSignedInfo += '<Transforms>'
cSignedInfo += '<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature"/>'
cSignedInfo += '<Transform Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315"/>'
cSignedInfo += '</Transforms>'
cSignedInfo += '<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/>'
cSignedInfo += '<DigestValue>' + cDigest + '</DigestValue></Reference></SignedInfo>'

Return(cSignedInfo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetCertificateºAutor  ³Microsiga           º Data ³  04/15/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Captura o certificado digital para assinatura do XML            º±±
±±º          ³                                                            	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        	  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetCertificate(cFile,lHSM,cIdEnt)

Local cCertificado := ""
Local nAT          := 0
Local nRAT         := 0
Local nHandle      := 0
Local nBuffer      := 0
Local cNewFunc     := ""
Local lExistCert   := .T.

If lHSM
	cNewFunc := "HSMGETCERTFILE"
	&cNewFunc.("slot_"+SuperGetMv("ES_HSMSLOT",.F.,cIdEnt)+"-label_"+SuperGetMv("ES_HSMLABE",.F.,cIdEnt),cFile)
EndIf
nHandle      := FOpen( cFile, 0 )
nBuffer      := FSEEK(nHandle,0,FS_END)

FSeek( nHandle, 0 )
If nHandle > 0
	FRead( nHandle , cCertificado , nBuffer )
	FClose( nHandle )
Else
	Conout("Certificado nao encontrado no diretorio Certs - Realizar a configuracao do certificado para entidade "+cIdEnt+" !")
	lExistCert := .F.
EndIf
If lExistCert
	nAt := AT("BEGIN CERTIFICATE", cCertificado)
	If (nAt > 0)
		nAt := nAt + 22
		cCertificado := substr(cCertificado, nAt)
	EndIf
	nRat := AT("END CERTIFICATE", cCertificado)
	If (nRAt > 0)
		nRat := nRat - 6
		cCertificado := substr(cCertificado, 1, nRat)
	EndIf
	cCertificado := StrTran(cCertificado, Chr(13),"")
	cCertificado := StrTran(cCertificado, Chr(10),"")
	cCertificado := StrTran(cCertificado, Chr(13)+Chr(10),"")
EndIf
Return(cCertificado)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetDtEvento ºAutor  ³Microsiga           º Data ³  04/15/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna a data no formato TIMESTAMP com o UTC.                º±±
±±º          ³Função necessária em virtude de erro na função FWTIMESTAMP    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GetDtEvento( dData, cHora)

Local oWSCfg := NIL
Local cError
Local cDEvento
Local cUtc
local aCfg		:= {}
Local cCnpj		:= SM0->M0_CGC
Local cData		:= Dtos(Date())
Local cHora		:= Time()
Local cVerEven	:= "1.00"
Local cVerCCe 	:= "1.00"
Local cHrVerao	:= "2"
Local cHorario	:= "2"
Local cUF		:= Upper(Left(LTrim(SM0->M0_ESTENT),2))
Local cURL 		:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local cAmbiente	    := "1"
Local cVerLayout	:= "1.00"
Local cVerLayEven	:= "1.00"
// Verificar se o Servidor está em horário de verão - MH - 04/01/2019
Local lHVeraoSrv  := GetMv("MV_HVERAO")  // Indica se o servidor está fisicamente em UF com horário de verão


// Obtem o ambiente de configuracao
oWSCfg:=WsSpedCfgNfe():New()
oWSCfg:cUSERTOKEN 	  	:= "TOTVS"
oWSCfg:cID_ENT    		:= cIdEnt
oWSCfg:nAMBIENTECCE	:= 0	// Atribuicao de '0', efetua a consulta do metodo
oWSCfg:cVERCCELAYOUT	:= ""
oWSCfg:cVERCCELAYEVEN	:= ""
oWSCfg:cVERCCEEVEN		:= ""
oWSCfg:cVERCCE			:= ""
oWSCfg:cHORAVERAOCCE	:= ""
oWSCfg:cHORARIOCCE		:= ""
oWSCfg:_URL       		:= AllTrim(cURL)+"/SpedCfgNfe.apw"

aCfg := getCfgCCe(@cError, cIdEnt )

cAmbiente	:= Left(aCfg[1],1)
cVerLayout	:= aCfg[8]
cVerLayEven	:= aCfg[7]
cVerEven	:= aCfg[6]
cVerCCe		:= aCfg[5]
cHrVerao 	:= Left(aCfg[3],1)
cHorario 	:= Left(aCfg[2],1)

// Data e Hora do Evento - Formato: 2011-07-27T14:17:00-03:00 (UTC)
If FindFunction("FwTimeUF")
	
	If cHrVerao == "1"			//1-Sim ### 2-Nao
		lHVerao   :=.T.
	else
		lHVerao   :=.F.
	EndIF
	
	If cHorario == "1"		//Fernando de Noronha
		cUF  := "FERNANDO DE NORONHA"
	Endif
	// Ajustado os parâmetros pois não estava trazendo o horário correto - MH 04/01/2019
	aData := FwTimeUF(cUF,,lHVeraoSrv,cData,lHVerao)
	
	cdata		:= aData[1]
	cData		:= Dtos(Date())
	cData		:= Substr(cData,1,4)+"-"+Substr(cData,5,2)+"-"+Substr(cData,7,2)
	
	cHora		:= aData[2]
Else
	cData		:= Substr(cData,1,4)+"-"+Substr(cData,5,2)+"-"+Substr(cData,7,2)
	
	cHora		:= Time()
EndIf

If cHrVerao == "1"			//1-Sim ### 2-Nao
	If cHorario == "1"		//Fernando de Noronha
		cUtc := "01:00"
	ElseIf cHorario == "2"	//Brasilia
		cUtc := "02:00"
	ElseIf	cHorario == "4"	//Acre
		cUtc := "04:00"
	Else
		cUtc := "03:00"		//Manaus
	Endif
Else
	If cHorario == "1"		//Fernando de Noronha
		cUtc := "02:00"
	ElseIf cHorario == "2"	//Brasilia
		cUtc := "03:00"
	ElseIf	cHorario == "4"	//Acre
		cUtc := "05:00"
	Else
		cUtc := "04:00"		//Manaus
	Endif
Endif

cDHEvento 	:=cData
cDHEvento 	+= "T"
cDHEvento 	+= cHora
cDHEvento 	+= "-"
cDHEvento	+= cUtc

Return cDHEvento
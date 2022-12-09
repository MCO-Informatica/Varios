#INCLUDE 'PROTHEUS.CH'

User Function ctsdk12(cCta, cType, cId, cFrom, cTo, cCc, cBcc, cSub, cAtt, cErrTp, cErrDes, cErrSta, lJob, cBase,cEmpJob,cFilJob)
Local nI		:= 0
Local cBodytxt	:= ""
Local bGrvLog	:= {||}
Local cDirMail	:= ""
Local cDirAnex	:= ""

//variaveis referentes ao tratamento de email pin
Local cMails	:= ""
Local cCnpj		:= ""
Local cComNam	:= ""
Local cOrgUni	:= ""
Local cTNome	:= ""
Local cMail		:= ""
Local cFone		:= ""
Local aCont		:= {}
Local lVerisign	:= .F.
Local cCliente	:= ""
Local cLojaCli	:= "" 
Local aDados	:= {}

//Variaveis referente a procura de id no corpo da mensagem
Local nHdl		:= 0
Local lSairLoop	:= .F.
Local aTag		:= {}
Local cString	:= ""
Local aTagValue	:= {}
Local aRetValue	:= {}
Local cGrpMail	:= ""
Local cSdkMail	:= ""
Local lMailOk	:= .T.
Local lPortCont := .F.
Local cCodPCont := ""
Local nPosPCont := 0

//variaveis referente a identificação de regra
Local cRegra	:= ""
Local cGrpSdk	:= ""
Local cAssSdk	:= ""
Local cOcoSdk	:= ""
Local cAcaSdk	:= ""
Local cOcoSdk2	:= ""
Local cAcaSdk2	:= ""

//variaveis referente a criação/alteração de atendimento
Local cMessage	:= ""
Local aRet		:= {} 
Local lCh 		:= .F.
Local cCodSdk 	:= ""
Local nPosCod	:= 0
Local cTimeIni	:= Time()
Local aDadMail	:= {}
Local cPedGar	:= ""
Local aAnexo	:= {}

Default cEmpJob 	:= ""
Default cFilJob     := ""

If !Empty(cEmpJob+cFilJob)
	RpcSetType(3)
	RpcSetEnv(cEmpJob, cFilJob) 
EndIf

bGrvLog	:= {|| u_ctsdkput(cCta, cType, cId, cFrom, cTo, cCc, cBcc, cSub, cAtt, cErrTp, cErrDes, cErrSta, lProc, lInProc ,cCodSDK, cBase) }
cDirMail:= GetNewPar("MV_XDIRSDK","\mailbox")
cMails	:= SuperGetMv("SDK_ENDMAI",,"pin_teste@certisign.com.br")

dbselectarea("SZR")
dbsetorder(2)

If SZR->(DbSeek(xFilial("SZR")+cCta))
	cGrpSdk	:= ALLTRIM(SZR->ZR_GRPSDK)
	cAssSdk	:= ALLTRIM(SZR->ZR_ASSSDK)
	cOcoSdk	:= ALLTRIM(SZR->ZR_OCOSDK)
	cAcaSdk	:= ALLTRIM(SZR->ZR_ACASDK)
	cOcoSdk2:= ALLTRIM(SZR->ZR_OCOSDK2)
	cAcaSdk2:= ALLTRIM(SZR->ZR_ACASDK2)
Else
	cType	:= "E"  
	cErrTp	:= "SDK"
	cErrDes	:= "Conta de email não encontrada para Processamento"
	cCodSDk := ""
	lProc	:= .T.
	lInProc	:= .T.
    
	eval(bGrvLog)
	
	Return()
EndIf

cDirAnex :=  StrTran(cBase,SubString(cBase,1,At(cDirMail,cBase)-1),"")

If File(cDirAnex+'content.txt')
	cBodytxt := memoread(cDirAnex+"content.txt")
ElseIf File(cDirAnex+'scontent.txt')
	cBodytxt := memoread(cDirAnex+"scontent.txt")
EndIf
                   
// Verifica se deve formatar o conteudo resposta
cBodytxt := VldResp( cBodytxt, SZR->ZR_PASTA )

If cTo $ cMails .and. ( 'Enroll Secure' $ cSub .or. 'Enroll GLOBAL' $ cSub  ) 

	aDados := StrTokArr(cBodytxt, "]")
		
	For nI := 1 to Len(aDados)
		If 'Cnpj' $ aDados[nI]
			cCnpj	:= substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		ElseIf 'Common Name' $ aDados[nI]
			cComNam	:= substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		ElseIf 'Org. Unit' $ aDados[nI]
			cOrgUni	:= substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		ElseIf 'Tech_Nome' $ aDados[nI]
			cTNome	:= substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		ElseIf 'Tech_Sobrenome' $ aDados[nI]
			cTNome	+= " " + substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		ElseIf 'Tech_email' $ aDados[nI]
			cMail	:= substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		ElseIf 'Tech_Fone' $ aDados[nI]
			cFone	:= substr(aDados[nI], At("[", aDados[nI]) + 1 , Len(aDados[nI]))
		EndIf
	Next nI
			
	DbSelectArea("SA1")
	DbSetOrder(3)	//A1_FILIAL + A1_CGC
	If DbSeek(xFilial("SA1") + U_CSFMTSA1(cCnpj))
		cCliente := SA1->A1_COD
		cLojaCli := SA1->A1_LOJA

		BeginSql Alias "QRYADE"
			SELECT 
				COUNT(ADE_CODIGO) NCONT
			FROM 
				%Table:ADE%
			WHERE 
				ADE_FILIAL = %xFilial:ADE%
				AND ADE_CHAVE = %Exp:cCliente+cLojaCli%
				AND ADE_DATA = %Exp:DtoS(dDataBase)%
				AND ADE_ORGUNI = %Exp:cOrgUni%
				AND ADE_COMNAM = %Exp:cComNam%
				AND %notdel%					
		EndSql
		
		DbSelectArea("QRYADE")
	 
		If QRYADE->NCONT <= 0
			aCont := {cTNome, "", cMail, "", cFone}
			//Cria o contato no sistema
			aRet := U_CriaCtto("", aCont, .F.)

			If aRet[1]
				//Amarra o contato ao cliente
				U_ConXCli("SA1", cCliente, cLojaCli, cContSite)
			EndIf
					
			lVersign := .T.
						
		EndIf
		QRYADE->(DbCloseArea())
	EndIf
Else
	If File(cDirAnex+'content.html')
		nHdl := Ft_Fuse(cDirAnex+'content.html')
		
		If nHdl > 0
			Ft_Fgotop()
					
			lSairLoop	:= .F.
			aTag		:= {'GRUPO','ATENDIMENTO','DATETIME'}					 
			cString		:= ''					

			While !Ft_Feof() .and. !lSairLoop
				cString += Ft_Freadln()	
		       	Ft_Fskip()
		  	EndDo
			
			aRetValue:= aClone(GetValHTML(aTag,cString))
					
			if !empty(aRetValue)
				aAdd(aTagValue,aRetValue)
			Endif
		Endif
		
		if !empty(aTagValue)
			aSort(aTagValue,,,{|x,y| AllTrim(x[3][2]) < AllTrim(y[3][2])}) //Ordenacao por DATETIME

			//Capturando o GRupo e Atendimento da Útlima interação
			
       		cGrpMail	:= aTagValue[len(aTAGValue)][1][2]
       		cSdkMail	:= aTagValue[len(aTAGValue)][2][2]
	
		Endif
	
	EndIf
EndIf

//
// Realiza cache das informacoes de anexos para posterior gravacao 
// no TKENVWOR, antes do processo de envio de workflow (CTSDK10)
//        
// 1o. Parametro: 1-Armazena informacoes do anexo em memoria;
// 				  2-Realiza a gravacao dos anexos a partir das informacoes armazenadas no array.
//
U_CTSDKSVA( 1,, cAtt, cDirMail, lJob, cDirAnex )

cRegra:= U_APLICA_REGRA(cCta,cFrom,cSub,cBodytxt,@cGrpSdk,@cAssSdk,@cOcoSdk,@cAcaSdk,@cOcoSdk2,@cAcaSdk2) //Regas para caixa de entrada

If	"RESGATE DE COMISSÃO" $ AllTrim( Upper( cSub ) ) .Or. ;
	"RESGATE DE COMISSAO" $ AllTrim( Upper( cSub ) )
	lPortCont := .T.
EndIf	

If !lPortCont .And. !Empty(cGrpMail) .and. !Empty(cSdkMail)
	DbSelectArea("ADE")
	ADE->(DbSetOrder(1))
	lCh := ADE->(DbSeek(xFilial("ADE")+cSdkMail))
	If lCh             
		// Atualiza email de origem do atendimento se necessario
		If AllTrim(Upper(ADE->ADE_EMAIL2)) <> AllTrim(Upper(cFrom))
			AtuMailFrom(cFrom)
		EndIf
		cMessage:= "[RETORNO DE SOLICITAÇÃO]"+CRLF+cBodytxt+CRLF
		aRet 	:= CriaSDK("2",cFrom,cSub,cAssSdk,cOcoSdk2,Iif(lMailOk,cAcaSdk2,""),cMessage,cGrpMail,cTimeIni,cSdkMail,,,,,cRegra,cTo)	
		lCh 	:= aRet[1]
		cCodSdk := aRet[2] 
	EndIf
    
ElseIf !lPortCont .And. "PROTOCOLO DE ATENDIMENTO" $ upper(cSub) //.and. "- CONTATO CLIENTE" $ upper(cAssunto)  

	nPosCod := AT("ATENDIMENTO",UPPER(cSub))
	cCodSdk := SubStr(cSub,nPosCod+12,6)
	DbSelectArea("ADE")
	ADE->(DbSetOrder(1))
	lCh := ADE->(DbSeek(xFilial("ADE")+cCodSdk)) 
	If lCh
		// Atualiza email de origem do atendimento se necessario
		If AllTrim(Upper(ADE->ADE_EMAIL2)) <> AllTrim(Upper(cFrom))
            AtuMailFrom(cFrom)
		EndIf
		cMessage:= "[RETORNO DE SOLICITAÇÃO]"+CRLF+cBodytxt+CRLF
		aRet 	:= CriaSDK("2",cFrom,cSub,cAssSdk,cOcoSdk2,Iif(lMailOk,cAcaSdk2,""),cMessage,cGrpSdk,cTimeIni,cCodSdk,,,,,cRegra,cTo)	
		lCh 	:= aRet[1]
		cCodSdk := aRet[2]
	EndIf
	
Else
	
	cMessage := "[DE]: "+cFrom+CRLF
	cMessage += "[PARA]: "+cTo+CRLF
	cMessage += "[CC]: "+cCc+CRLF
	cMessage += "[BCC]: "+cBcc+CRLF
	cMessage += "[ASSUNTO]: "+cSub+CRLF
	cMessage += "[MENSAGEM]: "+cBodytxt+CRLF
	cMessage += "[ID-MESSAGE]: "+cId+CRLF
	
	If "ABERTURA SDK" $ upper(cSub)
		
		aDadMail 	:= strtokarr(cSub,"|")
		
		If Len(aDadMail) >= 2
			cPedGar		:= ALLTRIM(upper(aDadMail[2]))
		EndIf
		 
	EndIf

	aRet    := CriaSDK("1"  ,cFrom,cSub,cAssSdk,cOcoSdk,cAcaSdk,cMessage,cGrpSdk  ,cTimeIni,"",cCliente+cLojaCli,"",cId,cPedGar,cRegra,cTo)
	
	lCh 	:= aRet[1]            
	cCodSdk := aRet[2] 
	
EndIf

If lCh
	
	If lVerisign .Or. lPortCont

		DbSelectArea("ADE")
		DbSetOrder(1)	//ADE_FILIAL + ADE_CODIGO
		DbSeek(xFilial("ADE") + cCodSdk)
		
		If lVerisign
			RecLock( "ADE", .F. )
			ADE->ADE_CHAVE	:= cCliente + cLojaCli
			ADE->ADE_ORGUNI	:= cOrgUni
			ADE->ADE_COMNAM	:= cComNam
			ADE->( MsUnLock() )
		EndIf
		
		If lPortCont              
			nPosPCont := XPesqPCont( cSub )
			If nPosPCont > 0
				cCodPCont := SubStr( cSub, nPosPCont, Len( ADE->ADE_XPCONT ) )
				RecLock( "ADE", .F. )
				ADE->ADE_XPCONT := cCodPCont
				ADE->( MsUnlock() )         
			EndIf	
		EndIf
			
	EndIf
	
	cType := "P"
	lProc	:= .T.
	lInProc	:= .T.
	
	eval(bGrvLog)	

Else

	cType	:= "E"  
	cErrTp	:= "SDK"
	cErrDes	:= cCodSDk
	cCodSDk := ""
	lProc	:= .T.
	lInProc	:= .T.	
    
	eval(bGrvLog)
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSDK   ºAutor  ³Microsiga           º Data ³  06/16/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CriaSDK(cTipo,cDe,cAss,cAssSdk,cOcoSdk,cAcaSdk,cMsg,cCodGrupo,cTimeIni,cCodSdk,cCodEntid,cCodCtto,cIdMessage,cPedGar,cRegra)
Local aCabec	:= {}  					// Cabecalho da rotina automatica
Local aLinha	:= {}					// Linhas da rotina automatica
Local cField	:= ""					// Temporário para armazenamento de nome de campo
Local aAreaSX3	:= SX3->(GetArea())			// Salva a Area do SX3
Local aAreaADE	:= ADE->(GetArea())			// Salva a Area do ADE
Local aAreaADF	:= ADF->(GetArea())			// Salva a Area do ADF
Local aAreaSUQ	:= SUQ->(GetArea())			// Salva a Area do SUQ
Local codChama	:= ""					// Codigo do chamado criado
Local nCount	:= 1					// Contador temporário
Local aCampos	:= {}					// Campos utilizados na copia de SLA
Local cFilial	:= xFilial("ADE")
Local cCodigo   := ""					// Numero do chamado
LOCAL cEntidade	:= "SA1"                                 // Cadastro de Clientes
LOCAL cEmail 	:= cDe  
LOCAL nEmailIni := AT("<",cEmail)
LOCAL nEmailFim := AT(">",cEmail)
LOCAL cDATA 	:= dDATABASE                                                              
Local chora 	:= TIME()
LOCAL cCritic 	:= SuperGetMv("SDK_CRITIC",,"5")          //Criticidade de assunto
LOCAL cTipoAtend:= SuperGetMv("SDK_ATEND",,"1")        //Tipo de Atendimento (1=Receptivo;2=Ativo)
LOCAL cCodSB1	:= SuperGetMv("SDK_SB1",,"SA070004")     //Cadastro de Produto
LOCAL cIncidente:= cMsg
Local cMemo 	:= "Abertura de atendimento via e-mail" //Observacao da Mensagem
Local cPath 	:= GetNewPar("MV_XDIRSDK","\mailbox")
Local cItem		:= "001"
Local cMsgErr	:= ""
Local aAutoErr	:= {}
Private lMsErroAuto := .F.
Private lAutoErrNoFile	:= .T.	// variavel interna da rotina automatica MSExecAuto()
Private aHeader		:= {}
Private aCols		:= {}

Default cIdMessage	:= ""
Default cPedGar		:= ""

//RAFAEL BEGHINI - 21.03.2019
//cEmail:=Substr(cEmail,nEmailIni+1,nEmailFim-nEmailIni-1)
IF nEmailIni > 0 .And. nEmailFim > 0
	cEmail := Substr( cEmail, nEmailIni+1, nEmailFim-nEmailIni-1 )
EndIF

//caso nao exista contato utiliza do parametro
If Empty(cCodCtto)
	cCodCtto	:= SuperGetMv("SDK_CODCTTO",,"007323")    // Codigo do contato
EndIf

//caso nao exista cliente utiliza do parametro
If Empty(cCodEntid)
	cCodEntid	:= SuperGetMv("SDK_CODENTI",,"00000101") //Codigo da Entidade e codigo da Loja
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta cabeçalho³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cTipo = "1"
	aAdd(aCabec,	{"ADE_CODCON" 	,Alltrim(cCodCtto)								,Nil})
	aAdd(aCabec,	{"ADE_ENTIDA" 	,Alltrim(cEntidade)								,Nil})
	aAdd(aCabec,	{"ADE_CHAVE" 	,AllTrim(cCodEntid)								,Nil})	
	aAdd(aCabec,	{"ADE_INCIDE" 	,cIncidente										,Nil})
	aAdd(aCabec,	{"ADE_STATUS" 	,"1"											,Nil})
	aAdd(aCabec,	{"ADE_OPERAD" 	,""												,Nil})
	aAdd(aCabec,	{"ADE_GRUPO" 	,cCodGrupo										,Nil})
	aAdd(aCabec,	{"ADE_EMAIL2" 	,cEmail 										,Nil})
	aAdd(aCabec,	{"ADE_HORA" 	,TIME()				    						,Nil})
	aAdd(aCabec,	{"ADE_SEVCOD" 	,cCritic     									,Nil})
	aAdd(aCabec,	{"ADE_OPERAC" 	,"1"											,Nil})
	aAdd(aCabec,	{"ADE_ASSUNT" 	,cAssSdk										,Nil})
	aAdd(aCabec,	{"ADE_CODSB1" 	,cCodSB1										,Nil})
	aAdd(aCabec,	{"ADE_SEVCOD" 	,'2'											,Nil})
	aAdd(aCabec,	{"ADE_TIPO" 	,'000002'										,Nil})
	If !Empty(cPedGar)
		aAdd(aCabec,	{"ADE_PEDGAR" 	,cPedGar									,Nil})
	Endif 
	If !Empty(cRegra)
		aAdd(aCabec,	{"ADE_REGRA" 	,cRegra										,Nil})
	Endif 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³	Monta os itens do chamado com a   	|
	//|primeira linha do chamado original   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(alinha,	{"ADF_FILIAL" 	,cFilial										,Nil})
	aAdd(aLinha,	{"ADF_ITEM" 	,cItem											,Nil})
	aAdd(aLinha,	{"ADF_CODSU9" 	,cOcoSdk			        					,Nil})
	aAdd(aLinha,	{"ADF_CODSU0" 	,cCodGrupo			        					,Nil})

	If !empty(cAcaSdk)
		aAdd(aLinha,	{"ADF_CODSUQ" 	,cAcaSdk				        				,Nil})
	EndIF
	aAdd(aLinha,	{"ADF_OBS" 		,cMemo											,Nil})
	aAdd(aLinha,	{"ADF_DATA" 	,Date()											,Nil})
	aAdd(aLinha,	{"ADF_HORA" 	,cTimeIni										,Nil})
	aAdd(aLinha,	{"ADF_HORAF" 	,TIME()											,Nil})
	aAdd(aLinha,	{"ADF_REGRA" 	,cRegra									,Nil})

	Fillgetdados(3,"ADF",nil,nil,nil,nil,nil,nil,nil,nil,nil,.T.)
	
	MSExecAuto({|x,y,z| TMKA503A(x,y,z)},aCabec,{aLinha},3)

	If lMsErroAuto//Exibe erro na execucao do programa
		cMsgErr := "Inconsistência ao Gerar o Atendimento SDK: " + CRLF + CRLF
		aAutoErr := GetAutoGRLog()	
		For nI := 1 To Len(aAutoErr)
			cMsgErr += aAutoErr[nI] + CRLF
		Next nI
		cCodSdk := cMsgErr
		
	Else
		ConfirmSx8()

		cCodSdk := ADE->ADE_CODIGO

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava campo Regra      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		
		If !Empty(ADE->ADE_CODREG) 
			MSMM(ADE->ADE_CODREG,TamSx3("ADE_REGRA")[1],,cRegra,1,,,"ADE","ADE_CODREG")		
		Else
			DbSelectArea("ADE")
			DbSetOrder(1)
			If MsSeek(xFilial("ADE")+ADE->ADE_CODIGO)
				
				BEGIN TRANSACTION
					RecLock("ADE", .F.) 
					MSMM(,TamSx3("ADE_REGRA")[1],,cRegra,1,,,"ADE","ADE_CODREG")	        
					//REPLACE ADE_CODREG WITH INVERTE(ADE->ADE_CODIGO)
					MsUnlock()
				END TRANSACTION	
				
			EndIf 
		EndIf        
		cRegra := ""  
	EndIf
Else

	//
	// Realiza a gravacao dos anexos no atendimento antes de gravar o item do atendimento e enviar workflow
	//            
	// 1o. Parametro: 1-Armazena informacoes do anexo em memoria;
	// 				  2-Realiza a gravacao dos anexos a partir das informacoes armazenadas no array.
	//
	U_CTSDKSVA( 2, cCodSDK )

	TkUpdCall(	/*cFil*/,;
				cAcaSdk/*cCodAction*/,;
				/*cCodReview*/,;	
				cIncidente,;
				/*cTPACAO*/,;	
				TkOperador(),;	
				cCodGrupo,;//Posicione("SU7", 1, xFilial("SU7")+TkOperador(), "U7_POSTO"),;		
				"",;
				/*dPrazo*/,;		
				If(!IsInCallStack("GenRecurrence"), Date(), dDatabase ),;		
				cCodSdk,;
				cOcoSdk)
				
EndIf   

RestArea(aAreaSX3)
RestArea(aAreaADE)
RestArea(aAreaADF)
RestArea(aAreaSUQ)

Return({!lMsErroAuto,cCodSdk})

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} GetValHTML
Função que pesquisa e retorna os valores de tags num documento HTML (string).

@param		Vetor com as tags que devem ser pesquisadas. String sem os delimitadores <>
@param		String contendo o HTML cujas tags serão pesquisadas
@author		Renan Guedes Alexandre
@version   	P10
@since      26/10/2012
/*/
//-------------------------------------------------------------------------------------
Static Function GetValHTML(aTag,cHTML)

Local aValue			:= {}
Local nX				:= 0
Local cUpperHTML		:= ""
Local nPosTagIni		:= 0
Local nPosTagFim		:= 0
Local cTagVal			:= ""
Local cTagIni			:= ""
Local cTagFim			:= ""

Default aTag			:= {}
Default cHTML			:= ""

cHtml := StrTran(cHtml,'&nbsp;',' ')
cHtml := StrTran(cHtml,'&lt;','<')
cHtml := StrTran(cHtml,'&gt;','>')

If ValType(aTag) == "A" .And. ValType(cHTML) == "C"		//Verifica se os parâmetros recebidos são dos tipos especificados
	If !Empty(aTag) .And. !Empty(AllTrim(cHTML))		//Verifica se os parâmetros recebidos possuem conteúdo
		cUpperHTML := Upper(cHTML)
		//Realiza a pesquisa para cada tag informada
		For nX := 1 To Len(aTag)
			If ValType(aTag[nX]) == "C"
				cTagIni := "<"	+ Upper(AllTrim(aTag[nX])) + ">"
				cTagFim := "</" + Upper(AllTrim(aTag[nX])) + ">"
				If (cTagIni $ cUpperHTML) .And. (cTagFim $ cUpperHTML)
					nPosTagIni := RAT(cTagIni,cUpperHTML)		//Verifica a posição da tag de início no HTML
					nPosTagFim := RAT(cTagFim,cUpperHTML)		//Verifica a posição da tag de fechamento no HTML
					If (nPosTagIni > 0) .And. (nPosTagFim > 0) .And. (nPosTagFim > nPosTagIni)
						cTagVal := SubStr(cHTML,(nPosTagIni + Len(cTagIni)),(nPosTagFim - (nPosTagIni + Len(cTagIni))))		//Retorna o valor entre as tags de início e fechamento
						AADD(aValue,{AllTrim(aTag[nX]),cTagVal})		//Adiciona o valor retornado na matriz de retorno da função
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf
EndIf

Return aValue



/*
-------------------------------------------------------------------------------
| Rotina     | AtuMailFrom | Autor | Gustavo Prudente    | Data | 19.03.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Realiza atualizacao do email de origem no atendimento          |
|-----------------------------------------------------------------------------|
| Parametros | EXPC1 - Conta de origem do workflow que gerou o atendimento    |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function AtuMailFrom( cFrom )

Local nEmailIni := 0
Local nEmailFim := 0
            
nEmailIni := AT( "<", cFrom )
nEmailFim := AT( ">", cFrom )
IF nEmailIni > 0 .And. nEmailFim > 0
	cFrom := Substr( cFrom, nEmailIni+1, nEmailFim-nEmailIni-1 )
EndIF

Reclock( "ADE", .F. )
ADE->ADE_EMAIL2 := AllTrim( cFrom )
ADE->( MsUnlock() )

Return Nil



/*
-------------------------------------------------------------------------------
| Rotina     | VldResp     | Autor | Gustavo Prudente    | Data | 26.03.2015  |
|-----------------------------------------------------------------------------|
| Descricao  | Realiza a validacao do corpo da mensagem e retorna o que       |
|            | efetivamente deve ser gravado no atendimento.                  |
|-----------------------------------------------------------------------------|
| Parametros | EXPC1 - Texto do corpo da mensagem a ser tratato.              |
|            | EXPC2 - Codigo da configuracao de e-mail de workflow.          |
|-----------------------------------------------------------------------------|
| Retorno    | EXPC1 - String com o texto para gravacao no item do atendimento|
|            |         montado a partir do corpo da mensagem original.        |
|-----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                            |
-------------------------------------------------------------------------------
*/
Static Function VldResp( cCorpo, cPasta )

Local nX		:= 0				// Contador generico
Local nLinha	:= 0				// Linha do arquivo texto atualmente processada
Local nPosStr	:= 0				// Posicao do texto para corte na mesma linha
Local nTotLin	:= 0				// Quantidade de linhas do corpo da mensagem

Local aListChv  := {}				// Lista de chaves do parametro MV_XCHVRES

Local cLinha	:= ""				// Linha percorrida do arquivo texto
Local cChave	:= ""            	// Chave atualmente processada
Local cConta	:= ""				// Conta de e-mail do workflow
Local cListChv	:= ""				// Conteudo do parametro MV_XCHVRES
Local cRet 		:= cCorpo			// Inicializa novo retorno de corpo da mensagem
Local cFilWF7	:= xFilial("WF7")	// Filial da tabela de configuracao de contas do workflow

// Verifica se a conta de e-mail do workflow utiliza chave de formatacao de conteudo              
WF7->( DbSetOrder( 1 ) )

If WF7->( DbSeek( cFilWF7 + cPasta ) ) 
                     
	// Formata array com possiveis chaves de limite de corpo de mensagem
	cListChv := GetNewPar( "MV_XCHVRES", "CERTISIGN -" )
	aListChv := StrToKArr( cListChv, ";" )

	cConta := WF7->WF7_REMETE

	// Verifica se a conta de workflow possui chave de formatacao de corpo de email       
	For nX := 1 To Len( aListChv )
		cChave := AllTrim( Upper( aListChv[ nX ] ) )
		If cChave $ AllTrim( Upper( cConta ) )
			Exit
		EndIf
	Next nX

	// Se a chave existir, formata o corpo do email ate a primeira ocorrencia da chave
	If ! Empty( cChave )                
		
		cRet 	:= ""						
		cLinha	:= ""
		nLinha	:= 1        
		nTotLin	:= MLCount( cCorpo )	

		// Percorre corpo da mensagem ate encontrar a chave
		Do While nLinha <= nTotLin

			cLinha := AllTrim( MemoLine( cCorpo,, nLinha ) )
			If cChave $ cLinha
				// Se a chave estiver na 1a. linha, trata string ate a chave e retorna
				If nLinha == 1
					nPosStr := At( cChave, cLinha )
					If nPosStr > 0
						cRet := SubStr( cLinha, 1, (nPosStr - 1) )
					EndIf
				EndIf        
				Exit
			Else
				// Monta string para gravacao no item do atendimento
				cRet += cLinha + CRLF
			EndIf

			nLinha ++

		EndDo

	EndIf
	
EndIf

Return( cRet )


           
/*
------------------------------------------------------------------------------
| Rotina     | XPesqPCont  | Autor | Gustavo Prudente    | Data | 06.05.2015 |
|----------------------------------------------------------------------------|
| Descricao  | Retornar a posicao de inicio do numero do protocolo das       |
|            | mensagens com origem no Portal do Contador.                   |
|----------------------------------------------------------------------------|
| Parametros | EXPC1 - String do assunto do e-mail.                          |
|----------------------------------------------------------------------------|
| Uso        | Certisign Certificadora Digital S/A                           |
------------------------------------------------------------------------------
*/
Static Function XPesqPCont( cSub )
           
Local nPos := 0
Local nX   := 0
           
Local aChave := { "COMISSAO-", "COMISSÃO-", "COMISSAO -", "COMISSÃO -" }
           
cSub := AllTrim( cSub )

For nX := 1 To Len( aChave )
	nPos := At( aChave[ nX ], Upper( cSub ) )
	If nPos > 0
		Exit
	EndIf
Next nX     
                
nPos := nPos + Len( aChave[ nX ] )
                            
// Soma um espaco para buscar corretamente o numero se a posicao 
// subsequente estiver em branco
Do While Empty( SubStr( cSub, nPos, 1 ) ) .And. nPos <= Len( cSub )
	nPos ++  
EndDo	

Return nPos
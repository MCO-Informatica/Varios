#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH"

Static __MailServer
Static __MailError
Static __MailFormatText		:= .f.
Static __isConfirmMailRead	:= .f.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออออหอออออออัอออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_CTSDK06A()       บAutor  ณOpvs(Warleson) บ Data ณ  01/05/12   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออสอออออออฯอออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona parametros na tabela SZR (configuracao de Contas)    บฑฑ
ฑฑบ          ณ para abertura de chamados na funcao CTSDK06                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CTSDK06A(_lJob) 

Local cJobEmp		:= GETJOBPROFSTRING ( "JOBEMP" , "01" )   //Empresa que serแ usada para abertura do atendimento
Local cJobFil 		:= GETJOBPROFSTRING ( "JOBFIL" , "02" )   //Filial que serแ usada para abertura do atendimento  
local aParametros	:= ARRAY(12)
local cQuery 		:= ''
Local nThrd			:= 0
Local nThrdAtv 		:= 0
Local nAtvThrd		:= 0
Local nProc			:= 0
Local _cRoot		:= GetSrvProfString("StartPath","")
Local _cDir   		:= ''
Local _cPath      	:= ''
Local _aDados		:= {}
Local nMsgCount		:= 0 // Contador de mensagens
Local nNumber 		:= 0 // Numeros de mensagens na caixa de Entrada
                                              
Local cCtaMail		:= "" // Grupos de atendimento que nใo deve processar

Default _lJob 	  	:= .T. //Executa o acesso ao Servidor

	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp,cJobFil)
//		RpcSetEnv('01','01')
	EndIf
                          
	cCtaMail := GetNewPar("MV_XCTASDK","")
	_cDir	 := SuperGetMv('MV_LOGMAIL',,'CTSDK06')	
	nThrd 	 := GetNewPar("MV_XTHMAIL",10)   

	cQuery:= " SELECT "+CRLF 
	cQuery+= " ZR_GRPSDK,ZR_SERVER,ZR_CTAMAIL,ZR_PASMAIL,ZR_ASSSDK,ZR_OCOSDK,ZR_ACASDK,ZR_OCOSDK2,ZR_ACASDK2"+CRLF 
	cQuery+= " FROM "+Retsqlname('SZR')+CRLF 
	cQuery+= "  WHERE D_E_L_E_T_ = ' '"+CRLF 
	cQuery+= "  AND ZR_FILIAL = '" + xFilial("SZR")+"'"+CRLF 
	cQuery+= "  AND ZR_ATIVO  = 'S'" 
	
	If Select("TRBPARAM") > 0; DbSelectArea("TRBPARAM");TRBPARAM->(DbCloseArea());EndIf // Testa se a area esta em uso - fecha area.
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBPARAM",.F.,.T.)
    
	While !TRBPARAM->(EoF())
		
		aUsers 	:= GetUserInfoArray()
		nThrdAtv:= 0
		aEval(aUsers, {|x| iif("SDKMAIL -" $ x[11],nThrdAtv++ ,nil)  })
		nProc := Ascan( aUsers, { |x| "Processando: "+TRBPARAM->ZR_GRPSDK $ x[11] } )

		_cPath := _cRoot+_cDir+'\'+ALLTRIM(TRBPARAM->ZR_CTAMAIL)+'.LOG'
		
		If !ExistDir(_cDir)
			MakeDir(_cDir)
		Endif
		
		If !File(_cPath)
			memowrite(_cPath,'3;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
		Endif
		
		If nThrdAtv <= nThrd .and. nProc == 0
			
			nAtvThrd := 0
			aEval(aUsers, {|x| iif(ALLTRIM(TRBPARAM->ZR_CTAMAIL) $ x[11],nAtvThrd++ ,nil)  })		    

					
			if !(nAtvThrd>0) // Leia a caixa de entrada da conta atual apenas se nใo tiver outra thread processando a mesma
			
				aParametros[01]:= ALLTRIM(TRBPARAM->ZR_SERVER)  		// Servidor de acesso a conta de e-mail
				aParametros[02]:= ALLTRIM(TRBPARAM->ZR_CTAMAIL) 		// conta de e-mail
				aParametros[03]:= ALLTRIM(pswencript(TRBPARAM->ZR_PASMAIL,1)) // Senha de acesso a conta de e-mail
				aParametros[04]:= cJobEmp  			   					// Empresa que serแ usada para abertura do atendimento
				aParametros[05]:= cJobFil			  					// Filial que serแ usada para abertura do atendimento  
				aParametros[06]:= ALLTRIM(TRBPARAM->ZR_GRPSDK)  		// Grupo de Atendimento que serแ direcionado antendimento  
				aParametros[07]:= ALLTRIM(TRBPARAM->ZR_ASSSDK)  		// C๓digo do Assunto Referente ao Atendimento
		 		aParametros[08]:= ALLTRIM(TRBPARAM->ZR_OCOSDK)  		// C๓digo da Ocorr๊ncia referente ao Atendimento  
				aParametros[09]:= ALLTRIM(TRBPARAM->ZR_ACASDK)  		// A็ใo referente ao atendimento
				aParametros[10]:= ALLTRIM(TRBPARAM->ZR_OCOSDK2) 		// C๓digo da Ocorr๊ncia referente ao Atendimento -retorno  
				aParametros[11]:= ALLTRIM(TRBPARAM->ZR_ACASDK2) 		// A็ใo referente ao atendimento - retorno
				aParametros[12]:= _cPath 					 			// Diretorios de Log Sintetico (Uso pela rotina CTSDK08)
			
//	 			U_CTSDK06(.F.,aParametros)// Usar para debugar ***
				If Empty( cCtaMail ) .Or. ! ( Upper( AllTrim( TRBPARAM->ZR_GRPSDK ) ) $ Upper( Alltrim( cCtaMail ) ) ) 
					StartJob("U_CTSDK06",GetEnvServer(),.F.,_lJob,aParametros) 
				EndIf	
			Endif
			
			TRBPARAM->(dbskip())
		ElseIf nProc > 0
			TRBPARAM->(dbskip())	
		EndIf
	Enddo
                      
	If _lJob
		DelClassIntf()
		RpcClearEnv()
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSDK06   บAutor  ณOpvs (David)        บ Data ณ  16/06/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION CTSDK06(_lJob,aCtaParam)

Local lResulConn	:= .T.
Local lResulPop		:= .T.
Local lResult		:= .T.
Local cError		:= ""
Local cDe 			:= "" //Remetente do envio da mensagem
Local cPara 		:= "" // Destinatแrio
Local cCc 			:= "" // Mensagem com copia
Local cBcc 			:= "" // Mensagem com copia oculta
Local cAssunto 		:= "" //Assunto da mensagem
Local aAnexo 		:= {} // Envio de arquivo com anexo
Local cMsg 			:= "" // Corpo da Mensagem
Local cIdMessage	:= "" //Id da Mensagem recebida
Local cPedGar		:= "" //C๓digo do Pedido GAR
Local cPath 		:= "\MailBox"
Local cTimeIni		:= ""
Local aRet			:= {}
Local lVerisign		:= .F.
Local cComNam		:= ""
Local cOrgUni		:= ""
Local cTNome		:= ""
Local cMail			:= ""
Local cGrpMail		:= ""
Local cSdkMail		:= ""
Local cServer		:= aCtaParam[01] // Servidor de acesso a conta de e-mail
Local cEmail		:= aCtaParam[02] // conta de e-mail
Local cPass			:= aCtaParam[03] // Senha de acesso a conta de e-mail
Local cJobEmp		:= aCtaParam[04] // Empresa que serแ usada para abertura do atendimento
Local cJobFil 		:= aCtaParam[05] // Filial que serแ usada para abertura do atendimento  
Local cGrpSdk 		:= aCtaParam[06] // Grupo de Atendimento que serแ direcionado antendimento  
Local cAssSdk 		:= aCtaParam[07] // C๓digo do Assunto Referente ao Atendimento
Local cAssSdkAux	:= ""
Local cOcoSdk 		:= aCtaParam[08] // C๓digo da Ocorr๊ncia referente ao Atendimento  
Local cOcoSdkAux	:= ""
Local cAcaSdk 		:= aCtaParam[09] // A็ใo referente ao atendimento
Local cOcoSdk2 		:= aCtaParam[10] // C๓digo da Ocorr๊ncia referente ao Atendimento -retorno 
Local cAcaSdk2 		:= aCtaParam[11] // A็ใo referente ao atendimento - retorno

Private nMsgCount		:= 0 // Contador de mensagens
Private nNumber 		:= 0 // Numeros de mensagens na caixa de Entrada
Private _cPath 		:= aCtaParam[12] //Log Sintetico, usado pela rotina CTSDK08
Private cCliente	:= ""
Private	cLojaCli	:= ""
Private	cContSite 	:= ""
Private	aCont		:= {}

Private cLastHtml	:= ""
PRivate cLastAtend	:= ""
Private nREt		:= 0

If _lJob
	RpcSetType(3)
	RpcSetEnv(cJobEmp,cJobFil)
EndIf

PtInternal(1,"SDKMAIL - Processando: "+cGrpSdk+" Conta: "+cEmail)

__MailError := 0

__MailServer := TMailManager():New()
__MailServer:SetUseSSL(.t.)

__MailServer:Init(cServer,"",cEmail,cPass,995)

__MailError:= __MailServer:GetPOPTimeOut()

nret := __MailServer:SetPOPTimeout(120) //2 min

If nRet == 0	
	conout("SetPOPTimeout Sucess")
	memowrite(_cPath,'2;0%'+';0/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log	
Else	
	conout(nret)	
	conout(__MailServer:GetErrorString(nret))
	memowrite(_cPath,'3;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
End

__MailError := __MailServer:PopConnect()

lResulConn := iif(__MailError==0,.T.,.F.)
	
cTimeIni		:= Time()

If !lResulConn // Exibe mensagem de erro de nao houver conexใo
    cError := __MailServer:GetErrorString(__MailError)
	If _lJob
		ConOut(Padc("Falha na conexao "+cError,80))
	Else
		MsgAlert("Falha na conexao "+cError)
	Endif
	memowrite(_cPath,'3;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
Else
	__MailServer:GetNumMsgs(@nMsgCount)
   
	If _lJob
		ConOut("["+Time()+"] Iniciada Verifica็ใo de Caixa de Email do Grupo "+cGrpSdk+" - Existem  "+Alltrim(Str(nMsgCount))+" Mensagens na Caixa")
	Else
		MsgAlert("["+Time()+"] Iniciada Verifica็ใo de Caixa de Email do Grupo "+cGrpSdk+" - Existem  "+Alltrim(Str(nMsgCount))+" Mensagens na Caixa")                          
	Endif
		memowrite(_cPath,'2;0%'+';0/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log	
		
	If nMsgCount >0

		//nMsgCount := 271 //***
		
		For nNumber := 1 to nMsgCount  
		
					
			//nNumber := nMsgCount // USado para debugar - Ler ultimo email - apenas para teste***

			cGrpMail 	:= ""
			cSdkMail 	:= ""
			cPedGar	 	:= ""
			cAssSdkAux  := ""
			cOcoSdkAux	:= ""

			__MailError := __MailServer:PopDisconnect()
			_ncount := 0
			While .T.
				_ncount ++
				If __MailError <> 0 .and. _ncount < 1000              
					ConOut("Tentativa PopDisconnect")
					memowrite(_cPath,'3;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
					__MailError := __MailServer:PopDisconnect()
				Else 
					Exit
				EndIf
			EndDo   
			__MailError := __MailServer:PopConnect()
			_ncount := 0
			While .T.               
				_ncount ++
				If __MailError <> 0 .and. _ncount < 1000                
					ConOut("Tentativa PopConnect")
					memowrite(_cPath,'3;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
					__MailError := __MailServer:PopConnect()
				Else
					Exit
				EndIf	
			EndDo
			//ConOut("inicio mailreceive")
			memowrite(_cPath,'2;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log

			
			lResulPop := MailReceive(nNumber , @cIdMessage    , @cDe  , @cPara, @cCc, @cBcc, @cAssunto, @cMsg , @aAnexo , cPath , .T.     , nil         , @lVerisign, @cComNam, @cOrgUni, @cTNome, @cCliente, @cLojaCli, @cMail, @cGrpMail, @cSdkMail,_lJob)

			//ConOut("fim mailreceive")		
			If !lResulPop
			
				cError := __MailServer:GetErrorString(__MailError)// Exibe mensagem de erro se houver falha no recebimento
				If _lJob
					ConOut(Padc("Falha no recebimento do e-mail "+cError,80))
				Else
				   //	MsgAlert("Falha no recebimento do e-mail " + cError)***
				Endif
				memowrite(_cPath,'3;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
				__MailError := 0

				// Ap๓s atualizacao de  build
				// Caso ocorra falha no recebimento, por mais que tente o comando "Message:Receive" nใo volta a funcionar
				// Por isso o servi็o sera reiniciado - Opvs(warleson) 20/09/2012
		
				PtInternal(1,"")		
				StartJob("U_CTSDK06",GetEnvServer(),.F.,_lJob,aCtaParam) 
				Exit

			Else // Salvar mensagem de e-mail
				memowrite(_cPath,'2;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
				ConOut('Aplica Regra - Inicio')
				
				cRegra:=""
		
				Conout('codigo da ocorrencia antes de entrar na regra: '+cOcoSdk)
				
				cRegra:= U_APLICA_REGRA(cEmail,cDe,cAssunto,cMsg,@cGrpSdk,@cAssSdk,@cOcoSdk,@cAcaSdk,@cOcoSdk2,@cAcaSdk2) //Regas para caixa de entrada
				
				Conout('codigo da ocorrencia APOS de entrar na regra: '+cOcoSdk)
				
				ConOut('Aplica Regra - Final')
				
				//ConOut('Regra:-'+cRegra)
					ConouT('Regra:'+cRegra)	

				If !Empty(cGrpMail) .and. !Empty(cSdkMail)
				//ConOut("Retorno de acordo id mensagem ")
					DbSelecArea("ADE")
					ADE->(DbSetOrder(1))
					
					If ADE->(DbSeek(xFilial("ADE")+cSdkMail)) 
						cMessage:= "[RETORNO DE SOLICITAวรO]"+CRLF+cMsg+CRLF
						aRet 	:= CriaSDK("2",cDe,cAssunto,cAssSdk,cOcoSdk2,cAcaSdk2,cMessage,cGrpMail,cTimeIni,cSdkMail,,,,,cRegra,cPara)	
					    //aRet 	:= CriaSDK("2",cDe,cAssunto,"","","",cMessage,cGrpMail,cTimeIni,cSdkMail,,,,,cRegra,cPara)	
						lCh 	:= aRet[1]
						cCodSdk := aRet[2] 
					Else
						lCh := .f.
					EndIf
			    
				ElseIf "PROTOCOLO DE ATENDIMENTO" $ upper(cAssunto) //.and. "- CONTATO CLIENTE" $ upper(cAssunto)  
					//ConOut("Retorno de acordo assunto ")
					nPosCod := AT("ATENDIMENTO",UPPER(cAssunto))
					cCodSdk := SubStr(cAssunto,nPosCod+12,6)
					DbSelecArea("ADE")
					ADE->(DbSetOrder(1))
					If ADE->(DbSeek(xFilial("ADE")+cCodSdk)) 
						cMessage:= "[RETORNO DE SOLICITAวรO]"+CRLF+cMsg+CRLF
						aRet 	:= CriaSDK("2",cDe,cAssunto,cAssSdk,cOcoSdk2,cAcaSdk2,cMessage,cGrpSdk,cTimeIni,cCodSdk,,,,,cRegra,cPara)	
						lCh 	:= aRet[1]
						cCodSdk := aRet[2]
					Else
						lCh := .f.
					EndIf
				Else
					
					//ConOut("Abertura de novo e-mail ")
					cMessage := "[DE]: "+cDe+CRLF
					cMessage += "[PARA]: "+cPara+CRLF
					cMessage += "[CC]: "+cCc+CRLF
					cMessage += "[BCC]: "+cBcc+CRLF
					cMessage += "[ASSUNTO]: "+cAssunto+CRLF
					cMessage += "[MENSAGEM]: "+cMsg+CRLF
					cMessage += "[ID-MESSAGE]: "+cIdMessage+CRLF
					
					If "ABERTURA SDK" $ upper(cAssunto)
						//ConOut("Abertura de atendimento assunto abertura sdk ")
						aDadMail 	:= strtokarr(cAssunto,"|")
						
						If Len(aDadMail) >= 2
							cPedGar		:= ALLTRIM(upper(aDadMail[2]))
						EndIf
						 
					EndIf
					
					memowrite(_cPath,'2;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
					//ConOut("Inicio gravacao atendimento normal ")
					aRet 	:= CriaSDK("1"  ,cDe,cAssunto,cAssSdk,cOcoSdk,cAcaSdk,cMessage,cGrpSdk  ,cTimeIni,"",cCliente+cLojaCli,cContSite,cIdMessage,cPedGar,cRegra,cPara)
					
					//ConOut("Fim Gravacao atendimento ")
					lCh 	:= aRet[1]            
					cCodSdk := aRet[2] 
					
				EndIf

				If lCh
					If lVerisign
						DbSelectArea("ADE")
						DbSetOrder(1)	//ADE_FILIAL + ADE_CODIGO
						DbSeek(xFilial("ADE") + cCodSdk)
						RecLock("ADE", .F.)
							Replace ADE->ADE_CHAVE With cCliente + cLojaCli
							Replace ADE->ADE_ORGUNI With cOrgUni
							Replace ADE->ADE_COMNAM With cComNam
						ADE->(MsUnLock())
					EndIf
										
					cLastHtml	:= "" 
					cLastAtend	:= ""
                    '
					For nI:=1 to Len(aAnexo)
						If ALLTRIM(upper(aAnexo[nI,2])) <> "ATT.DAT"
							SvArqSdk(aAnexo[nI,1], aAnexo[nI,3], cCodSDk,_lJob)
						EndIf
					Next nI
				__MailServer:DeleteMsg(nNumber) //EXCLUIR MENSAGEM ***
				EndIf
			Endif
			// Limpa cache da interface XML
			// Para livrar memoria do Protheus Server
			DelClassIntf()
		Next nNumber
	Else
		conout("Nใo Existem mensagens a serem baixadas ["+DtoC(ddatabase)+"-"+Time()+"] Grupo ["+cGrpSdk+"]") 
		memowrite(_cPath,'2;'+cvaltochar(Round((nNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log	
	EndIf
	__MailServer:PopDisconnect()

	if nNumber==0
		nNumber++
	Endif
	
	If _lJob
		ConOut("["+Time()+"] Finalizada Verifica็ใo de Caixa de Email do Grupo "+cGrpSdk)
//		RpcClearEnv()
	Else
		MsgAlert("["+Time()+"] Finalizada Verifica็ใo de Caixa de Email do Grupo "+cGrpSdk)                          
	Endif
	memowrite(_cPath,'1;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log	
EndIf

RETURN lResulPop

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaSDK   บAutor  ณMicrosiga           บ Data ณ  06/16/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaSDK(cTipo,cDe,cAss,cAssSdk,cOcoSdk,cAcaSdk,cMsg,cCodGrupo,cTimeIni,cCodSdk,cCodEntid,cCodCtto,cIdMessage,cPedGar,cRegra)
Local aCabec	:= {}  					// Cabecalho da rotina automatica
Local aLinha	:= {}					// Linhas da rotina automatica
Local cField	:= ""					// Temporแrio para armazenamento de nome de campo
Local aAreaSX3	:= SX3->(GetArea())			// Salva a Area do SX3
Local aAreaADE	:= ADE->(GetArea())			// Salva a Area do ADE
Local aAreaADF	:= ADF->(GetArea())			// Salva a Area do ADF
Local aAreaSUQ	:= SUQ->(GetArea())			// Salva a Area do SUQ
Local codChama	:= ""					// Codigo do chamado criado
Local nCount	:= 1					// Contador temporแrio
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
Local cPath 	:= "\MailBox"
Local cItem		:= "001"
Private lMsErroAuto := .F.
Private aHeader		:= {}
Private aCols		:= {}

Default cIdMessage	:= ""
Default cPedGar		:= ""

cEmail:=Substr(cEmail,nEmailIni+1,nEmailFim-nEmailIni-1)

//caso nao exista contato utiliza do parametro
If Empty(cCodCtto)
	cCodCtto	:= SuperGetMv("SDK_CODCTTO",,"007323")    // Codigo do contato
    
	/* OPVS(WARLESON) 14/02/12
	dbselectarea('SU5')
	dbsetorder(1) //Filial+Contato
	If  !DbSeek(xFilial("SU5") + cCodCtto) 
		//Cria o contato no sistema
		aRet := U_CriaCtto("", aCont, .F.)
		If aRet[1]
			//Amarra o contato ao cliente
			U_ConXCli("SA1", cCliente, cLojaCli, cContSite)
		EndIf
	Endif
	*/
EndIf

//caso nao exista cliente utiliza do parametro
If Empty(cCodEntid)
	cCodEntid	:= SuperGetMv("SDK_CODENTI",,"00000101") //Codigo da Entidade e codigo da Loja
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta cabe็alhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ	Monta os itens do chamado com a   	|
	//|primeira linha do chamado original   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
	  
//	regtomemory("ZZ1")
//	regtomemory("AGC")
//	regtomemory("ZZ2")
//	regtomemory("CDL")
	
	Fillgetdados(3,"ADF",nil,nil,nil,nil,nil,nil,nil,nil,nil,.T.)
	memowrite(_cPath,'2;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
	MSExecAuto({|x,y,z| TMKA503A(x,y,z)},aCabec,{aLinha},3)

	If lMsErroAuto//Exibe erro na execucao do programa
		
		If !empty(cIdMessage)    
			cPathLog := cPath+"\"+cIdMessage+"\"	
		Else
			cPathLog := "\SYSTEM\"
		EndIf 
		memowrite(_cPath,'3;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log					
		Mostraerro(cPathLog,"SDK_LOG_"+StrTran(Time(),":","")+".TXT")
		
	Else
		ConfirmSx8()
		conout("Chamado gerado com sucesso "+ADE->ADE_CODIGO )
		memowrite(_cPath,'2;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
		
	  	cCodSdk := ADE->ADE_CODIGO

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grava campo Regra      |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		

		conout('ira gravar a regra')
		
		conout('codreg NAO esta vazio?')		
		
		If !Empty(ADE->ADE_CODREG) 
			conout('sim - entao autualiza o camo com msmm')					
			
			MSMM(ADE->ADE_CODREG,TamSx3("ADE_REGRA")[1],,cRegra,1,,,"ADE","ADE_CODREG")		
		Else
			conout('nao - entao  da seek')					
			DbSelectArea("ADE")
			DbSetOrder(1)
			If MsSeek(xFilial("ADE")+ADE->ADE_CODIGO)
				conout('dentro do seek')					
				BEGIN TRANSACTION
					RecLock("ADE", .F.) 
					MSMM(,TamSx3("ADE_REGRA")[1],,cRegra,1,,,"ADE","ADE_CODREG")	        
					//REPLACE ADE_CODREG WITH INVERTE(ADE->ADE_CODIGO)
					MsUnlock()
				END TRANSACTION	
				conout('acabou de gravar a regra')
				conout(cRegra)
			EndIf 
		EndIf        .
		cRegra := ""  
	EndIf
Else
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMailReceiveบAutor  ณOpvs (David)        บ Data ณ  04/07/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para baixa de e-mails de caixa especificada via para-บฑฑ
ฑฑบ          ณmetros                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function MailReceive(anMsgNumber, cIdMsg , acFrom, acTo  , acCc, acBcc, acSubject, acBody, aaFiles , acPath, alDelete, alUseTLSMail, lVerisign, cComNam  , cOrgUni , cTNome, cCliente  , cLojaCli , cMail, cGrpMail, cSdkMail,_lJob)

	Local oMessage
	Local nInd
	Local lRunTbi	:= .F.
	Local nCount
	Local cFilename
	local cLastFilename
	Local aAttInfo
	Local cRoot		:= GetSrvProfString("RootPath","")
	Local aDados	:= {}
	Local cCnpj		:= ""
	Local cFone		:= ""
	local cChave	:= ""
	Local aRet		:= {}
	Local aArea		:= GetArea()
	Local cMails	:= SuperGetMv("SDK_ENDMAI",,"pin_teste@certisign.com.br")     //Enderecos de email
	Local bDecode	:= {|a,b,c|	a := StrTran(a,"?Q?",""),;
								a := StrTran(a,"?=",""),;        
								a := StrTran(a,"=?",""),;
								a := iif(!Empty(c) .and. SubStr(c,1,9) == "text/html",a,StrTran(a,"ISO-8859-1","") ) ,;
								a := iif(!Empty(c) .and. SubStr(c,1,9) == "text/html",a,StrTran(a,"iso-8859-1","") ) ,;
				   				a := iif(!Empty(c) .and. SubStr(c,1,9) == "text/html",a,StrTran(a,"UTF-8","") ) ,;
								a := iif(!Empty(c) .and. SubStr(c,1,9) == "text/html",a,StrTran(a,"utf-8","") ) ,;
								a := iif(b=="1",u_DecodeIso(a),a),;
								a := iif(b=="2",DecodeUtf8(a),a),;
								a := OeMtoAnsi(a)} // Decode de Texto Iso-8859-1 e UTF-8 
	
	Local	cCaracEsp		:= '.&/-_"!@#$%จ&*(){}[]?/;:><|\ภ,~^ด`+='
	Local  	aTag			:= {'GRUPO','ATENDIMENTO','DATETIME'}					 
	Local 	aTagValue		:= {}
	Local 	aRetValue		:= {}
	Local	lSairLoop		:= .F.
	Local 	cString			:= ''
				
	default acFrom			:= ""
	default acTo			:= ""
	default acCc			:= ""
	default acBcc			:= ""
	default acSubject		:= ""
	default acBody			:= ""
	default acPath			:= ""
	default alDelete		:= .f.
	default aaFiles			:= { }
	default alUseTLSMail	:= .f.
	default lVerisign		:= .F.
		
	if __MailError > 0
		return(.F.)
	endif

	oMessage := TMailMessage():New()
	oMessage:Clear() 
		
	__MailError := oMessage:Receive(__MailServer, anMsgNumber)
	_ncount := 0 
		
	if __MailError == 0

		acFrom		:= oMessage:cFrom
		acTo		:= oMessage:cTo
		acCc		:= oMessage:cCc
		acBcc		:= oMessage:cBcc
		acSubject	:= oMessage:cSubject
		cIdMsg		:= oMessage:cMessageId
		memowrite(_cPath,'2;'+cvaltochar(Round((anMsgNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(anMsgNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log

		for i:= 1 to len(cCaracEsp) 
			cIdMsg:=STRTRAN(cIdMsg,substring(cCaracEsp,i,1),'') 
		Next

		cIdMsg := Alltrim(cIdMsg)
		
		//Decodifica De
		If "ISO-8859-1" $ UPPER(acFrom)
			Eval(bDecode,@acFrom,"1","")
		EndIf

		If "UTF-8" $ UPPER(acFrom) 
			Eval(bDecode,@acFrom,"2","")
		EndIf

		//Decodifica Assunto
		If "ISO-8859-1" $ UPPER(acSubject)
			Eval(bDecode,@acSubject,"1","")
		EndIf
		
		If "UTF-8" $ UPPER(acSubject) 
			Eval(bDecode,@acSubject,"2","")
		EndIf
		
		acBody 		:= OemToAnsi(oMessage:cBody)
		aaFiles		:= {}

		If acTo $ cMails
			If (!('Enroll Secure' $ acSubject) .And. !('Enroll GLOBAL' $ acSubject))	//'log-billing@certintra.com.br'
				return( __MailError == 666 )
			Else
				aDados := StrTokArr(acBody, "]")
			
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

					cQryADE := "SELECT COUNT(ADE_CODIGO) NCONT"
					cQryADE += "FROM " + RetSqlName("ADE") + " "
					cQryADE += "WHERE ADE_FILIAL = '" + xFilial("ADE") + "' "
					cQryADE += "  AND ADE_CHAVE = '" + cCliente + cLojaCli + "' "
					cQryADE += "  AND ADE_DATA = '" + DtoS(dDataBase) + "' "
					cQryADE += "  AND ADE_ORGUNI = '" + cOrgUni + "' "
					cQryADE += "  AND ADE_COMNAM = '" + cComNam + "' "
					cQryADE += "  AND D_E_L_E_T_ = ' ' "					
					
					cQryADE := ChangeQuery(cQryADE)
			
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryADE),"QRYADE",.F.,.T.)
					DbSelectArea("QRYADE")
		 
					If QRYADE->NCONT > 0
						DbSelectArea("QRYADE")
						QRYADE->(DbCloseArea())
						return( __MailError == 666 )
					Else
						aCont := {cTNome, "", cMail, "", cFone}

						//Cria o contato no sistema
						aRet := U_CriaCtto("", aCont, .F.)

						If aRet[1]
							//Amarra o contato ao cliente
							U_ConXCli("SA1", cCliente, cLojaCli, cContSite)
						EndIf
						DbSelectArea("QRYADE")
						QRYADE->(DbCloseArea())
						lVersign := .T.
					EndIf
				Else
					return( __MailError == 666 )
				EndIf
				
			EndIf
		EndIf

		nCount := 0
		aString:={}
		
		If !ExistDir(acPath+"\"+cIdMsg)
			MakedIR(acPath+"\"+cIdMsg)
		EndIf
		
		acPath := acPath+"\"+cIdMsg
		
		oMessage:Save(acPath+"\corpo_email_"+Dtos(ddatabase)+".msg")
		//oMessage:clear()
		//oMessage:load(acPath+"\corpo_email_"+Dtos(ddatabase)+".msg")
		memowrite(_cPath,'2;'+cvaltochar(Round((anMsgNumber*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(anMsgNumber))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log	
		
		for nInd := 1 to oMessage:getAttachCount()  
			conout("carregando anexo "+Alltrim(Str(nInd))+" da mensagem "+Alltrim(Str(anMsgNumber)) )
			aAttInfo := oMessage:getAttachInfo(nInd)
			
			//varinfo("aAttInfo->> ",aAttInfo) 

			If !empty(aAttInfo[1]) .or. aAttInfo[2] == 'text/html'
				conout("Salvando Anexo Normalmente")

			  
				If "ISO-8859-1" $ UPPER(aAttInfo[1])
					aAttInfo[1] := Eval(bDecode,aAttInfo[1],"1","")
				EndIf
		
				If "UTF-8" $ UPPER(aAttInfo[1]) 
					aAttInfo[1] := Eval(bDecode,aAttInfo[1],"2","")
				EndIf
			
				SaveAnexo("1",nInd,oMessage,aAttInfo,cRoot,acPath,@aaFiles)
					
			EndIf
			
			If aAttInfo[2] == 'multipart/mixed'

				cFileMult := "MultPart_"+StrTran(Time(),":","")+".txt"
				
				oMessage:SaveAttach(nInd,cRoot+acPath + "\"+ cFileMult)
				
		      	aTag		:={'GRUPO','ATENDIMENTO','DATETIME'}					 
				cMultPart 	:= ""
				cTip 		:= ""
				cEncod  	:= ""
				cName		:= ""
				cName2		:= ""
				cCharset	:= ""
				cString 	:= ""
				cHtml	 	:= ""
				nHdl2		:= 0
	
				If  _lJob
					nHdl := Ft_Fuse(acPath + "\"+ cFileMult)  
                
	                if nHdl==-1
						conout("Erro ao tentar ler o arquivo: "+acPath + "\"+ cFileMult)
						Return
					ELse
	                	conout('Leitura de arquivo = ok ')				
					Endif
                Else
					nHdl := Ft_Fuse(cRoot+acPath + "\"+ cFileMult)  

	                if nHdl==-1
						conout("Erro ao tentar ler o arquivo: "+cRoot+acPath + "\"+ cFileMult)
						Return
					ELse
	                	conout('Leitura de arquivo = ok ')				
					Endif
				
				EndIf
							
							
				Ft_Fgotop()

				While !Ft_Feof()
					cMultPart := Ft_Freadln()
					
					If 	SubStr(cMultPart,1,8) == "------=_" 
						
						If nHdl2 > 0
						
							If !Empty(cHtml)
								
							  	If "base64" $ cEncod
					    			cHtml := Decode64(cHtml)    	   	
					    		EndIf
				    	
						    	If "iso-8859-1" $ cCharSet 
						    		Eval(bDecode,@cHtml,"1",cTip)
						    	EndIf
					    	
						    	If "utf-8" $ cCharSet 
						    		Eval(bDecode,@cHtml,"2",cTip)
						    	EndIf
															
						    	fWrite(nHdl2,cHtml)
						    	
						 	EndIf
						 	
						    fClose(nHdl2)
													
							SaveAnexo("2",nil,nil,{cName2,cName},cRoot,acPath,@aaFiles,cString)

						EndIf

				      	aTag		:={'GRUPO','ATENDIMENTO','DATETIME'}					 
						cTip 		:= ""
						cEncod  	:= ""
						cName		:= ""
						cName2		:= ""
						cCharset	:= ""
				      	cString 	:= ""
				      	cHtml	 	:= ""
				      	nHdl2		:= 0

				    EndIf
			
					Do Case
						Case "Content-Type:" $ cMultPart .and. Empty(cString)
							cTip 	:= Alltrim(SubStr(cMultPart,14,Len(cMultPart)) )
							
							If SubStr(cTip,1,9) == "text/html"
								cName	:= "corpo_email_"+Dtos(ddatabase)+".htm"
                                cName2  := cName
								If _lJob
									cFilename 	:= acPath + "\"+ cName //Quando Job entao caminho a partir do rootpath
				                Else
									cFilename 	:= cRoot + acPath + "\"+ cName //caminho completo
								EndIf

								while file(cFilename)         

                                cChave := "_" +Dtos(dDataBase)+"_"+StrTran(Time(),":","") 								

									If _lJob
										cFilename := acPath + "\" + substr(cName, 1, at(".", cName) - 1) + ccHAve  +;
									             substr(cName, at(".", cName))
					                Else
										cFilename := cRoot + acPath + "\" + substr(cName, 1, at(".", cName) - 1)+ cChave  +;
									             substr(cName, at(".", cName))
									EndIf
									
									cName2:= substr(cName, 1, at(".", cName) - 1) +cChave +substr(cName, at(".", cName))								
								
								enddo
								
								nHdl2 := fCreate(cFilename)
							   	cLastFilename:=cFilename
							   //conout('criado o arquivo'+cvaltochar(nHdl2)) //limpar
							EndIf
							
						Case "Content-Transfer-Encoding:" $ cMultPart .and. Empty(cString)
							cEncod 	:= Alltrim(SubStr(cMultPart,27,Len(cMultPart)) ) 		
							
						Case "name=" $ cMultPart .and. Empty(cString) .and. empty(cName)
							nPos	:= RAT("name=",cMultPart)
							cName	:= Alltrim(SubStr(cMultPart,nPos+5,Len(cMultPart))) 			 
							cName	:= StrTran(cName,'"','')
							cName2  := cName
								
							If "ISO-8859-1" $ UPPER(cName)
								Eval(bDecode,@cName,"1",cTip)
								Eval(bDecode,@cName2,"1",cTip)
							EndIf
		
							If "UTF-8" $ UPPER(cName) 
								Eval(bDecode,@cName,"2",cTip)
								Eval(bDecode,@cName2,"1",cTip)								
							EndIf
							
							If _lJob
								cFilename 	:= acPath + "\"+ cName //Quando Job entao caminho a partir do rootpath
			                Else
								cFilename 	:= cRoot + acPath + "\"+ cName //caminho completo
							EndIf							

							while file(cFilename)         

								cChave := "_" +Dtos(dDataBase)+"_"+StrTran(Time(),":","") 								
								
								If _lJob
									cFilename := acPath + "\" + substr(cName, 1, at(".", cName) - 1) +cChave +;
								           substr(cName, at(".", cName))
					            Else
									cFilename := cRoot + acPath + "\" + substr(cName, 1, at(".", cName) - 1) +cChave+;
								             substr(cName, at(".", cName))
								EndIf
                                 cName2:= substr(cName, 1, at(".", cName) - 1) +cChave +substr(cName, at(".", cName))
							enddo

							cFilename:= NoAcento(AnsiToOem(cFilename))							

							nHdl2	:= fCreate(cFilename)
															
						Case "charset=" $ cMultPart .and. Empty(cString)
							nPos	:= RAT("charset=",cMultPart)
							cCharSet:= Alltrim( SubStr(cMultPart,nPos+8,Len(cMultPart)) ) 			 
							cCharSet:= StrTran(cCharSet,'"','')

						Case !(	"Content-Disposition:" $ cMultPart .or.;
						 		"filename=" $ cMultPart .or.;
						 		"------=_" $ cMultPart .or.;
						 		("charset=" $ cMultPart .and. Empty(cCharSet)) .or.;
						 		"boundary=" $ cMultPart ) .and.;
						 		nHdl2 > 0
					    	
					       	cString := cMultPart+CRLF		

				    		If SubStr(cTip,1,9) == "text/html"
				                //Inicio - tratamentro na quebra do multpart.txt -  warleson 19/04
								If substring(cString,len(cString)-2,1)=="=" 
									cString	:= substring(cString,1,len(cString)-3)
									cString := StrTran(cString,CRLF,"")
									cHtml += cString  
								Else
									cHtml += cString
								Endif 
								// Final - tratamentro na quebra do multpart.txt -  warleson 19/04					
				    		ElseIf !("Content-ID:"$cString) .and. !(cstring==CHR(13)+CHR(10)) //Tramento para pular Enter e linhas de Id ao gravar o arquivo base64
				    			If "base64" $ cEncod
					    			cString := Decode64(cString)    	   	
					    		EndIf
				    	
						    	If "iso-8859-1" $ cCharSet 
						    		Eval(bDecode,@cString,"1",cTip)
						    	EndIf
					    	
						    	If "utf-8" $ cCharSet 
						    		Eval(bDecode,@cString,"2",cTip)
						    	EndIf
					    	
				    			fWrite(nHdl2,cString)

			                Elseif ("Content-ID:"$cString)
			                
			                	nPosIni	:= RAT("<",cString)+1
				                nPosFin	:= nPosFin	:= AT(">",cString) - nPosIni
			                
				                cId		:= "cid:"+SUBSTRING(cString,nPosIni,nPosFin)

			                  	carrega_imagem(cLastFilename,cId,lower(cNAme2))
			                   	//	cLastFilename :ultimo arquivo html Salvo
			                   	//	cId		: Id original
			                   	//	cNAme2	: nome da imagem em anexo
			                
			                EndIf
					EndCase
						
				    Ft_Fskip()
//					conout(CVALTOCHAR(FlastRec())+''+cvaltochar(FT_RECNO()))//Limpar				
				EndDo

				If nHdl > 0 
					fClose(nHdl)
				EndIf
				
				If nHdl2 > 0
					fClose(nHdl2)
				EndIf

				DelClassIntf()
				
			EndIf

		next nInd
		
		conout("finalizando anexos")
		conout("Procurando Id Mensagem no corpo")

		aTagValue:= {}
		aRetValue:= {}		
		
		for nInd := 1 to len(aaFiles)
			conout("Procurando Id Mensagem no corpo NO ANEXO "+Alltrim(Str(nInd)))
			//Verifica sorpo contem retorno de atendimento para complementa็ใo do mesmo
			If "corpo_email" $ aaFiles[nInd,2] .and. ".htm" $ aaFiles[nInd,2]
				nHdl := Ft_Fuse(aaFiles[nInd,3])				
				
				//varinfo("afilesanexos-->",aaFiles)
				
				 If nHdl > 0
					memowrite(_cPath,'2;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
					conout("Mensagem encontrada")
					Ft_Fgotop()
					
					lSairLoop	:= .F.
					aTag		:= {'GRUPO','ATENDIMENTO','DATETIME'}					 
					cString		:= ''					

					While !Ft_Feof() .and. !lSairLoop
						cString += Ft_Freadln()	
				       	Ft_Fskip()
				  	EndDo
					aRetValue:= aClone(U_GetValHTML(aTag,cString))
					
					if !empty(aRetValue)
						aAdd(aTagValue,aRetValue)
					Endif
				 Else
					memowrite(_cPath,'3;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
				 	conout("Mensagem nใo encontrada codigo de erro "+Alltrim(Str(nHdl)))
				 Endif
		    EndIf 
		Next			       	
		
		if !empty(aTagValue)
			aSort(aTagValue,,,{|x,y| AllTrim(x[3][2]) < AllTrim(y[3][2])}) //Ordenacao por DATETIME

			//Capturando o GRupo e Atendimento da ฺtlima intera็ใo
			
       		cGrpMail	:= aTagValue[len(aTAGValue)][1][2]
       		cSdkMail	:= aTagValue[len(aTAGValue)][2][2]
		Else
	   		cGrpMail := ''
   			cSdkMail := ''
		Endif

 		memowrite(_cPath,'2;'+cvaltochar(Round(((nNumber-1)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
		conout("Finalizada Procura do Id Mensagem no corpo")
		alDelete := .f.
		
		if alDelete
			__MailServer:DeleteMsg(anMsgNumber)
		endif
	Else
		ConOut("Tentativa oMessage:Receive")	
		memowrite(_cPath,'3;'+cvaltochar(Round(((nNumber)*100)/nMsgCount,2))+'%'+';'+Alltrim(Str(nNumber-1))+'/'+Alltrim(Str(nMsgCount))+';'+DToC(Date())+'-'+Time()) //Grava Log
		ConOut(time() + " Nao foi possivel Receber a mensagem")
	Endif
	
	if ( lRunTbi )
		MailPopOff()
	EndIf
	
	RestArea(aArea)                
	
return( __MailError == 0 )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSaveAnexo บAutor  ณOpvs David          บ Data ณ  12/03/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para salvar anexo com no e pasta especํfica          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
Gฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SaveAnexo(cTip,nInd,oMessage,aAttInfo,cRoot,acPath,aaFiles,cString)

Local nCount		:= 0      

Local cCaracEsp		:= '\/:*?"<>|'

Local bNameArq		:= {|a|	iif(	Empty(a),;
								"corpo_email_"+Dtos(ddatabase)+".htm",;
								a	) }
			
cAnexo				:= NoAcento(AnsiToOem(Eval(bNameArq,aAttInfo[1])))

if cAnexo=='untitled-1'
	cAnexo:= "\corpo_email_"+Dtos(ddatabase)+".htm"
Endif

for i:= 1 to len(cCaracEsp) 
	cAnexo:=STRTRAN(cAnexo,substring(cCaracEsp,i,1),'') 
Next

cFilename 	:= cRoot + acPath + "\" + cAnexo
cFilename2 	:= acPath + "\" + cAnexo
cChvFile	:= cAnexo

if cTip== "1"
	while file(cFilename)         
		nCount++
		cChvFile	:= substr(cAnexo, 1, at(".", cAnexo) - 1) +"_" +Dtos(dDataBase)+"_"+StrTran(Time(),":","") +substr(cAnexo, at(".", cAnexo))
		cFilename 	:= cRoot + acPath + "\" + cChvFile
		cFilename2 	:= acPath + "\" +cChvFile
	enddo

	cAnexo := cChvFile
Endif

Do Case
	Case cTip == "1" //email mime ou smime sem anexo
		 
		If Empty(aAttInfo[1])
			cConteudo := oMessage:GetAttach(nInd)

			cFilename:= NoAcento(AnsiToOem(cFilename))

			nHdlArq := fCreate(cFilename2)

			fwrite(nHdlArq,cConteudo )
			fclose(nHdlArq)
			//conout("conteudo do html "+cConteudo)
			//conout("Grava conteudo do html no arquivo "+cFilename)
		Else

			oMessage:SaveAttach(nInd,cFilename)
		
		EndIf
	Case cTip =="2"                                                                  
	
		cFilename 	:= cRoot + acPath + "\" + cAnexo
		cFilename2 	:= acPath + "\" + cAnexo
EndCase	
		                
aAdd(aaFiles, { cFilename, cAnexo, cFilename2 })

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSvArqSdk  บAutor  ณMicrosiga           บ Data ณ  07/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSalva Arquivos em anexo ao e-mail                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SvArqSdk(cAnexo, cFileName, cCodSDk,_lJob) 

Local aArea		:= GetArea()
Local nPos 		:= RAt(If(IsSrvUnix(), "/", "\"), cFileName)
Local nPos2		:= 0
Local cDirDoc	:= MsDocPath()
Local cArqOrig	:= Upper(SubStr( cFileName , nPos+1 ))
Local cAnexoGrv	:= cArqOrig
Local nCount	:= 1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca por um nome de arquivo nao utilizado, incrementando o arquivo        ณ
//ณcom um sequencial ao final do nome, exemplo: arquivo(1).txt, arquivo(2).txtณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("ACB")
DbSetOrder(2) //ACB_FILIAL+ACB_OBJETO

nPos2		:= Rat(".",cAnexoGrv)
cAnexoGrv	:= SubStr(cAnexoGrv,1,nPos2-1)+"("+cCodSDk+")"+SubStr(cAnexoGrv,nPos2,Len(cAnexoGrv))

//While DbSeek(xFilial("ACB") + AllTrim(SubStr( cAnexoGrv ,nPos+1 )))
While DbSeek(xFilial("ACB") + AllTrim(cAnexoGrv))
	nPos 		:= RAt(If(IsSrvUnix(), "/", "\"), cFileName)
	nPos2		:= Rat(".",cAnexoGrv)
	cAnexoGrv	:= SubStr(cAnexoGrv,1,nPos2-1)+"("+cCodSDk+cValToChar(nCount)+")"+SubStr(cAnexoGrv,nPos2,Len(cAnexoGrv))
	nCount++
End

//If ACB->(FieldPos("ACB_PATH"))<=0
//	__CopyFile(StrTran(cAnexo,GetSrvProfString("RootPath",""),""),cDirDoc + "\" + cAnexoGrv ) // Opvs(Warleson) 12/04/2012
//EndIf

	__CopyFile(StrTran(cAnexo,GetSrvProfString("RootPath",""),""),cDirDoc + "\" + cAnexoGrv ) 

	if UPPER(SubStr(cAnexo,Rat(".",cAnexo),Len(cAnexo))) == '.HTM'

		If _lJob
			cLastHtml	:= cDirDoc + "\" + cAnexoGrv
		Else
			cLastHtml	:= GetSrvProfString("RootPath","")+cDirDoc + "\" + cAnexoGrv
		EndIf
		cLastAtend	:= cCodSDk
	Else
		If !empty(cLastHtml)
			Carrega_imagem(cLastHtml,lower('src="'+cArqOrig+'"'),lower('src="'+cAnexoGrv+'"'))  	
		Endif                         
	Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclui registro no banco de conhecimentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RecLock("ACB",.T.)
ACB->ACB_FILIAL := xFilial("ACB")
ACB->ACB_CODOBJ := GetSxeNum("ACB","ACB_CODOBJ")
ACB->ACB_OBJETO	:= Upper(cAnexoGrv)
ACB->ACB_DESCRI	:= "Arquivo Referente Atd "+cCodSdk
  
// Opvs(Warleson) 12/04/2012 - Nao eh possivel abrir via banco de conhecimento aquivos cujo o campo ACB_PATH esteje preenchido.
//If ACB->(FieldPos("ACB_PATH"))>0
//	ACB->ACB_PATH	:= cFileName
//EndIf

MsUnLock()

ConfirmSx8()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclui amarra็ใo entre registro do banco e entidadeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RecLock("AC9",.T.)
AC9->AC9_FILIAL	:= xFilial("AC9")
AC9->AC9_FILENT	:= xFilial("ADE")
AC9->AC9_ENTIDA	:= "ADE"
AC9->AC9_CODENT	:= xFilial("ADE")+cCodSdk
AC9->AC9_CODOBJ	:= ACB->ACB_CODOBJ
MsUnLock()

RestArea(aArea)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณdecodeiso  บAutor  ณMicrosiga           บ Data ณ  07/28/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DecodeIso(cTxt)
Local cStr		:= cTxt
Local nPos		:= 0

Local aTbIso8859:= {{"=00",""},;
{"=01",""},;
{"=02",""},;
{"=03",""},;
{"=04",""},;
{"=05",""},;
{"=06",""},;
{"=07",""},;
{"=08",""},;
{"=09",""},;
{"=0A",""},;
{"=0B",""},;
{"=0C",""},;
{"=0D",""},;
{"=0E",""},;
{"=0F",""},;
{"=10",""},;
{"=11",""},;
{"=12",""},;
{"=13",""},;
{"=14",""},;
{"=15",""},;
{"=16",""},;
{"=17",""},;
{"=18",""},;
{"=19",""},;  
{"=1A",""},;
{"=1B",""},;
{"=1C",""},;
{"=1D",""},;
{"=1E",""},;
{"=1F",""},;
{"=20"," "},;
{"=21","!"},;
{"=22",'"'},;  
{"=23","#"},;
{"=24","$"},;
{"=25","%"},;
{"=26","&"},;
{"=27","'"},;
{"=28","("},;
{"=29",")"},;
{"=2A","*"},;
{"=2B","+"},;
{"=2C",","},;
{"=2D","-"},;
{"=2E","."},;
{"=2F","/"},;
{"=30","0"},;
{"=39","9"},;
{"=3A",":"},;
{"=3B",";"},;
{"=3C","<"},;
{"=3D","="},;
{"=3E",">"},;
{"=3F","?"},;
{"=40","@"},;
{"=41","A"},;
{"=5A","Z"},;
{"=5B","["},;
{"=5C","\"},;
{"=5D","]"},;
{"=5E","^"},;
{"=5F","_"},;
{"=60","`"},;
{"=61","a"},;
{"=7A","z"},;
{"=7B","{"},;
{"=7C","|"},;
{"=7D","}"},;
{"=7E","~"},;
{"=7F",""},;
{"=80",""},;
{"=81",""},;
{"=82",""},;
{"=83",""},;
{"=84",""},;
{"=85",""},;
{"=86",""},;
{"=87",""},;
{"=88",""},;
{"=89",""},;
{"=8A",""},;
{"=8B",""},;
{"=8C",""},;
{"=8D",""},;
{"=8E",""},;
{"=8F",""},;
{"=90",""},;
{"=91",""},;
{"=92",""},;
{"=93",""},;
{"=94",""},;
{"=95",""},;
{"=96",""},;
{"=97",""},;
{"=98",""},;
{"=99",""},;
{"=9A",""},;
{"=9B",""},;
{"=9C",""},;
{"=9D",""},;
{"=9E",""},;
{"=9F",""},;
{"=A0",""},;
{"=A1","ก"},;
{"=A2","ข"},;
{"=A3","ฃ"},;
{"=A4","ค"},;
{"=A5","ฅ"},;
{"=A6","ฆ"},;
{"=A7","ง"},;
{"=A8","จ"},;
{"=A9","ฉ"},;
{"=AA","ช"},;
{"=AB","ซ"},;
{"=AC","ฌ"},;
{"=AD","ญ"},;
{"=AE","ฎ"},;
{"=AF","ฏ"},;
{"=B0","ฐ"},;
{"=B1","ฑ"},;
{"=B2","ฒ"},;
{"=B3","ณ"},;
{"=B4","ด"},;
{"=B5","ต"},;
{"=B6","ถ"},;
{"=B7","ท"},;
{"=B8","ธ"},;
{"=B9","น"},;
{"=BA","บ"},;
{"=BB","ป"},;
{"=BC","ผ"},;
{"=BD","ฝ"},;
{"=BE","พ"},;
{"=BF","ฟ"},;
{"=C0","ภ"},;
{"=C1","ม"},;
{"=C2","ย"},;
{"=C3","ร"},;
{"=C4","ฤ"},;
{"=C5","ล"},;
{"=C6","ฦ"},;
{"=C7","ว"},;
{"=C8","ศ"},;
{"=C9","ษ"},;
{"=CA","ส"},;
{"=CB","ห"},;
{"=CC","ฬ"},;
{"=CD","อ"},;
{"=CE","ฮ"},;
{"=CF","ฯ"},;
{"=D0","ะ"},;
{"=D1","ั"},;
{"=D2","า"},;
{"=D3","ำ"},;
{"=D4","ิ"},;
{"=D5","ี"},;
{"=D6","ึ"},;
{"=D7","ื"},;
{"=D8","ุ"},;
{"=D9","ู"},;
{"=DA","ฺ"},;
{"=DB","Û"},;
{"=DC","Ü"},;
{"=DD","Ý"},;
{"=DE","Þ"},;
{"=DF","฿"},;
{"=E0","เ"},;
{"=E1","แ"},;
{"=E2","โ"},;
{"=E3","ใ"},;
{"=E4","ไ"},;
{"=E5","ๅ"},;
{"=E6","ๆ"},;
{"=E7","็"},;
{"=E8","่"},;
{"=E9","้"},;
{"=EA","๊"},;
{"=EB","๋"},;
{"=EC","์"},;
{"=ED","ํ"},;
{"=EE","๎"},;
{"=EF","๏"},;
{"=F0","๐"},;
{"=F1","๑"},;
{"=F2","๒"},;
{"=F3","๓"},;
{"=F4","๔"},;
{"=F5","๕"},;
{"=F6","๖"},;
{"=F7","๗"},;
{"=F8","๘"},;
{"=F9","๙"},;
{"=FA","๚"},;
{"=FB","๛"},;
{"=FC","ü"},;
{"=FD","ý"},;
{"=FE","þ"},;
{"=FF","ÿ"},;
{"_"," "}} 

//Correcao Bug - Warleson - 20/04/2012
// Contador descrecente para evitar ambiguidade na decodigicacao
// Exemplo:
// Para a entrada =3d47 enh esperado a saida =47
// porem a saida era =@

For nI:= Len(aTbIso8859) to 1 step -1 
	cTxt := StrTran(cTxt,aTbIso8859[nI,1],aTbIso8859[nI,2])				
Next

cStr	:= cTxt

Return(cStr)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณcarrega_imagem   บAutor  ณOpvs(warleson)       บ Data ณ  04/19/12  บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Troca o conteudo da Tag SRC do HTML para carregar                 บฑฑ
ฑฑบ          ณ  corretamente as imagens no corpo do e-mail assinado digitalmente บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                                บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

static function Carrega_imagem(cLastFilename,cId,cNAme2)  

local cArq 		:= ""
Local cHtml		:= ""
Local cLinha	:= ""
local nQtdLinha := 0
local nX		:= 0

//	conout(cLastFilename)
	
	cArq		:= memoread(cLastFilename)
	nQtdLinha	:= MLCount(cArq)

	For nX:= 1 to nQtdLinha
		cLinha:= Memoline(cArq,,nX)
		if cId $ cLinha
			cLinha:= StrTran(cLinha,cId,cNAme2)
		Else
		 	cLinha:=cLinha
		EndIf	
		cHtml+=cLinha	    
	Next nX

	memowrite(cLastFilename,cHtml)

Return

//-------------------------------------------------------------------------------------
/*/{Protheus.doc} GetValHTML
Fun็ใo que pesquisa e retorna os valores de tags num documento HTML (string).

@param		Vetor com as tags que devem ser pesquisadas. String sem os delimitadores <>
@param		String contendo o HTML cujas tags serใo pesquisadas
@author		Renan Guedes Alexandre
@version   	P10
@since      26/10/2012
/*/
//-------------------------------------------------------------------------------------
User Function GetValHTML(aTag,cHTML)

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

If ValType(aTag) == "A" .And. ValType(cHTML) == "C"		//Verifica se os parโmetros recebidos sใo dos tipos especificados
	If !Empty(aTag) .And. !Empty(AllTrim(cHTML))		//Verifica se os parโmetros recebidos possuem conte๚do
		cUpperHTML := Upper(cHTML)
		//Realiza a pesquisa para cada tag informada
		For nX := 1 To Len(aTag)
			If ValType(aTag[nX]) == "C"
				cTagIni := "<"	+ Upper(AllTrim(aTag[nX])) + ">"
				cTagFim := "</" + Upper(AllTrim(aTag[nX])) + ">"
				If (cTagIni $ cUpperHTML) .And. (cTagFim $ cUpperHTML)
					nPosTagIni := RAT(cTagIni,cUpperHTML)		//Verifica a posi็ใo da tag de inํcio no HTML
					nPosTagFim := RAT(cTagFim,cUpperHTML)		//Verifica a posi็ใo da tag de fechamento no HTML
					If (nPosTagIni > 0) .And. (nPosTagFim > 0) .And. (nPosTagFim > nPosTagIni)
						cTagVal := SubStr(cHTML,(nPosTagIni + Len(cTagIni)),(nPosTagFim - (nPosTagIni + Len(cTagIni))))		//Retorna o valor entre as tags de inํcio e fechamento
						AADD(aValue,{AllTrim(aTag[nX]),cTagVal})		//Adiciona o valor retornado na matriz de retorno da fun็ใo
					EndIf
				EndIf
			EndIf
		Next nX
	EndIf
EndIf

Return aValue
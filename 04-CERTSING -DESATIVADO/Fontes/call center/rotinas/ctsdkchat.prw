#Include "Totvs.ch"
#Include "TopConn.ch"
#include "ap5mail.ch"
#include "vkey.ch" 

//USer Function
User Function CHAT2PLN(cTip, cLogName, cEmp, cFil, cThread, cCodUser, cGrupo, cPin, nJanAtual,aJanID,cConversa )
	Local aUsers	:= {}
	Local nIndex	:= 0
	Local oChat		:= nil
	Local lAtuAtrib	:= .F.
	Local nI		:= 0
	Local lTimeOut	:= .F.
	Local cTime		:= ""

	Default nJanAtual:= 0
	Default aJanID	 := {}
	Default cConversa:= ""

	RpcSetType(3)
	RpcSetEnv(cEmp,cFil)

	PswOrder(2)
	PswSeek(cLogName,.T.)

	oChat 				:= CtSdkChat():New(.F.)
	oChat:cThread 		:= cThread
	oChat:cCoduser		:= cCodUser
	oChat:cPin			:= cPin
	oChat:Init()
	oChat:_cGrupo		:= cGrupo
	oChat:cUIDChatChave := Alltrim(cThread)

	aUsers 		:= GetUserInfoArray()
	nIndex 		:= Ascan(aUsers,{|x| x[3] == val(cThread) })
	lAtuAtrib	:= .F.

	If nIndex > 0 .AND. AT("CHAT ", aUsers[nIndex,11]) > 0

		oChat:lGlbVarChat	:= .F.
		oChat:cThread		:= cThread
		oChat:cCoduser		:= cCodUser
		oChat:cPin			:= cPin
		oChat:_cGrupo		:= cGrupo

		If cTip == "1"
			oChat:aJanID	:= aClone(aJanID)
			If !Empty(oChat:aJanID[nJanAtual,1]) .and. Empty(oChat:aJanID[nJanAtual,3])
				cTime := Time()
				While  Empty(oChat:aJanID[nJanAtual,3]) .and. !lTimeOut
					lTimeOut := ElapTime( cTime, Time() ) > "00:00:20"
					oChat:CriaAtendimento(nJanAtual,.F.,.F.,.F.)
				EndDo
			EndIf

			oChat:SetTamanhoFila()
		ElseIf cTip == "2"
			oChat:aJanID	:= aClone(aJanID)
			oChat:nJanAtual	:= nJanAtual
			oChat:CriaAtendimento(nJanAtual,.F.,.F.,.T.)
		EndIf

		VarDel( oChat:cUIDChatFim	, Alltrim(str(ThreadId())) )
		VarDel( oChat:cUIDChatFimCli, Alltrim(str(ThreadId())) )
		VarDel( oChat:cUIDChatInicia, Alltrim(str(ThreadId())) )

	Else

		VarDel( oChat:cUIDChatFim	, oChat:cUIDChatChave )
		VarDel( oChat:cUIDChatFimCli, oChat:cUIDChatChave )
		VarDel( oChat:cUIDChatInicia, oChat:cUIDChatChave )

	EndIf

	DelClassIntF()

	FreeObj(oChat)
	oChat := nil
	RpcClearEnv()
Return

CLASS CtSdkChat

	Data lGlbVarChat
	Data aConversa
	Data cIni
	Data cInptOper
	Data cChatOper
	Data cChatFile
	Data _cChatoPC
	Data xRetTran1
	Data xRetTran2
	Data xRetTran3
	Data xRetTran4
	Data lCro1
	Data lCro2
	Data lCro3
	Data lCro4
	Data cTimeEnc1
	Data cTimeEnc2
	Data cTimeEnc3
	Data cTimeEnc4
	Data lStat
	Data oSay
	Data oSayLine
	Data cTimeUltConv1
	Data nTimeSeg1
	Data nTimeMin1
	Data nTimeHor1
	Data cTimeUltConv2
	Data nTimeSeg2
	Data nTimeMin2
	Data nTimeHor2
	Data cTimeUltConv3
	Data nTimeSeg3
	Data nTimeMin3
	Data nTimeHor3
	Data cTimeUltConv4
	Data nTimeSeg4
	Data nTimeMin4
	Data nTimeHor4
	Data cTimeJan1
	Data cTimeJan2
	Data cTimeJan3
	Data cTimeJan4
	Data oTimerCro
	Data cTitulo
	Data _Habfor
	Data cCoduser
	Data _nomeuser
	Data _nomeOper
	Data _cchamg
	Data _ccham
	Data cPin
	Data cIpServer
	Data cPortServer
	Data cThread
	Data aJanID
	Data nInativ
	Data nInativBar
	Data _cGrupo
	Data _nJanOper
	Data nTpRmt
	Data oMeterJan1
	Data nMeterJan1
	Data oMeterJan2
	Data nMeterJan2
	Data oMeterJan3
	Data nMeterJan3
	Data oMeterJan4
	Data nMeterJan4
	Data oTela
	Data oLayer
	Data cFormuld1
	Data cFormuld2
	Data cFormuld3
	Data cFormuld4
	Data cVariav1
	Data cVariav2
	Data cVariav3
	Data cVariav4
	Data oFormuld1
	Data oFormuld2
	Data oFormuld3
	Data oFormuld4
	Data oVariav
	Data oVariav1
	Data oVariav2
	Data oVariav3
	Data oVariav4
	Data nJanAtual
	Data nPausa
	Data cCodPausa
	Data _cEmp
	Data _cFil
	Data cSessionInicio
	Data aSessionFim
	Data aSessionFimCli
	Data cUIDChatFim
	Data cUIDChatFimCli
	Data cUIDChatInicia
	Data cUIDChatChave
	Data lEncerraJanela
	Data cWSServer
	Data cWSPort
	Data cTimeOutIpcGo
	Data cTimeOutJan
	Data oMainDock
	Data ChatFocus
	Data oRpcWs
	Data lConWs
	Data nTimeOutIpcWait

	METHOD New(lCriaGlb)
	METHOD Init()
	METHOD Activate(lTimer,lDisp)
	METHOD AtualizaConversa()
	METHOD AtualizaTempoConversa()
	METHOD AtuChatFim(lForca)
	METHOD AtuChatInicia(lForca)
	METHOD CriaAtendimento(nJanela,lMostraTela)
	METHOD DelSessioFim(cSession)
	METHOD DelSessioInicio(cSession)
	METHOD DistribuiConversa(cXml)
	METHOD EncerraConversa(cSession,cMotivo,cEnviaEmail,cConversa)
	METHOD EncerraJanela(lAlert,lAtuDisp)
	METHOD EnviaMensagem(cConversa,cSession)
	METHOD FimConversa(lForca,lAtuGlb,lEncerra,lForcaEncerra)
	METHOD GetTamanhoFila()
	METHOD Informadisponibilidade(cGrupo,lEnvDisp)
	METHOD IniciaConversa(lForca,lCriaAtd,lAtuGlb)
	METHOD IniciaJanelaChat(cSession,lCriaAtd,lLoad)
	METHOD NotificaConversa(nJan)
	METHOD ProcessaFimConversa(cSession,lEncerra,lForcaEncerra)
	METHOD RemoveGarbage()
	METHOD SetSessioFim(cSession)
	METHOD SetSessioInicio(cSession)
	METHOD SetConversa(cConversa,cTpOper,nJanela,cSession,lEnviaCliente)
	METHOD SetDisp(lDelet)
	METHOD SetGrupoAte()
	METHOD SetJanOper()
	METHOD SetPausa()
	METHOD SetTamanhoFila()
	METHOD SetTrbSZM(cStatus,lSelect)
	METHOD SetTrbSZN(lSelect)
	METHOD SetFila(cXml)
	METHOD GetFila()
	METHOD CapturaConversa()
	METHOD LiberaOperador(cSession,cEnviEmail,cConversa)
	METHOD AlertChat(nType, cMsg)
ENDCLASS

Method New(lCriaGlb) CLASS CtSdkChat

	Default lCriaGlb := .T.

	Self:lGlbVarChat	:= .T.
	Self:cIni			:= iif(IsBlind(),"",GetRemoteIniName())
	Self:cInptOper		:= GetNewPar('MV_XCHATIN',"http://localhost:8080/WebChat/operatorInput.html")
	Self:cChatOper 		:= GetNewPar('MV_XCHATOP',"http://192.168.16.10:9090/WebChat/faces/operator.xhtml")
	Self:cChatFile 		:= GetNewPar('MV_XCHATFI',"http://192.168.16.10:9090/WebChat/download?file=")
	Self:_cChatoPC		:= "0"
	Self:xRetTran1		:= nil
	Self:xRetTran2		:= nil
	Self:xRetTran3		:= nil
	Self:xRetTran4		:= nil
	Self:lCro1			:= .F.
	Self:lCro2			:= .F.
	Self:lCro3			:= .F.
	Self:lCro4			:= .F.
	Self:cTimeEnc1		:= ""
	Self:cTimeEnc2		:= ""
	Self:cTimeEnc3		:= ""
	Self:cTimeEnc4		:= ""
	Self:cTimeUltConv1	:= ""
	Self:cTimeUltConv2	:= ""
	Self:cTimeUltConv3	:= ""
	Self:cTimeUltConv4	:= ""
	Self:lStat			:= .T.
	Self:oSay			:= nil
	Self:oSayLine		:= nil
	Self:nTimeSeg1		:= 0
	Self:nTimeMin1		:= 0
	Self:nTimeHor1		:= 0
	Self:nTimeSeg2		:= 0
	Self:nTimeMin2		:= 0
	Self:nTimeHor2		:= 0
	Self:nTimeSeg3		:= 0
	Self:nTimeMin3		:= 0
	Self:nTimeHor3		:= 0
	Self:nTimeSeg4		:= 0
	Self:nTimeMin4		:= 0
	Self:nTimeHor4		:= 0
	Self:cTimeJan1		:= ""
	Self:cTimeJan2		:= ""
	Self:cTimeJan3		:= ""
	Self:cTimeJan4		:= ""
	Self:oTimerCro		:= NIL
	Self:cTitulo		:= "Manutenção de Chat"
	Self:_Habfor		:= .T.
	Self:cCoduser		:= alltrim(TkOperador())
	Self:_nomeuser		:= "" //nome reduzido do operador
	Self:_nomeOper		:= Alltrim(UsrRetName(RetCOdUsr()))
	Self:_cchamg	    := ""
	Self:_ccham      	:= ""
	Self:cPin 			:= Alltrim(Iif(len(dtoc(date()))>8,substr(dtoc(date()),1,6)+substr(dtoc(date()),9,2),dtoc(date()))+time())
	Self:cIpServer 		:= Alltrim(GetServerIP())
	Self:cPortServer 	:= Alltrim(Str(GetServerPort()))
	Self:cThread 		:= Alltrim(str(ThreadId()))
	Self:aJanID 		:= {}
	Self:nInativ 		:= val(GetNewPar ('MV_CHAT001',"360"))  //Parâmetro para o tempo para derrubar a conexao por inatividade, em segundos.
	Self:nInativBar 	:= Self:nInativ
	Self:_cGrupo		:= ""
	Self:_nJanOper   	:= 0
	Self:nTpRmt			:= 0//GetRemoteType()
	Self:oMeterJan1		:= nil
	Self:oMeterJan2		:= nil
	Self:oMeterJan3		:= nil
	Self:oMeterJan4		:= nil
	Self:oTela			:= nil
	Self:oLayer			:= nil
	Self:cFormuld1		:= Space(TamSX3("A1_COD")[1])
	Self:cFormuld2		:= Space(TamSX3("A1_COD")[1])
	Self:cFormuld3		:= Space(TamSX3("A1_COD")[1])
	Self:cFormuld4		:= Space(TamSX3("A1_COD")[1])
	Self:cVariav1		:= ""
	Self:cVariav2		:= ""
	Self:cVariav3		:= ""
	Self:cVariav4		:= ""
	Self:oFormuld1		:= nil
	Self:oFormuld2		:= nil
	Self:oFormuld3		:= nil
	Self:oFormuld4		:= nil
	Self:nJanAtual		:= 1
	Self:nPausa			:= 0
	Self:cCodPausa		:= ""
	Self:_cEmp			:= cEmpAnt
	Self:_cFil			:= cFilAnt
	Self:cSessionInicio	:= {}
	Self:aSessionFim	:= {}
	Self:aSessionFimCli	:= {}
	Self:cUIDChatFim	:= "CTRLCHATFIM"
	Self:cUIDChatFimCli	:= "CTRLCHATFIMCLI"
	Self:cUIDChatInicia	:= "CTRLCHATINIC"
	Self:cUIDChatChave 	:= Self:cThread
	Self:lEncerraJanela	:= .F.
	Self:cWSServer		:= GetNewPar('MV_XCHTWSS','192.168.16.31')
	Self:cWSPort		:= GetNewPar('MV_XCHTWSP','9840')
	Self:cTimeOutIpcGo	:= GetNewPar('MV_XCHTIGO','00:00:05')
	Self:cTimeOutJan	:= GetNewPar('MV_XCHTJAN','00:00:20')
	Self:oMainDock		:= nil
	Self:ChatFocus		:= .F.
	Self:oRpcWs			:= nil
	Self:lConWs			:= .F.
	Self:nTimeOutIpcWait:= GetNewPar('MV_XCHTWAI',100)

	If lCriaGlb
		Self:lGlbVarChat 	:= VarSetUID(Self:cUIDChatInicia, .T.)
		If !Self:lGlbVarChat
			Help(,1,"CHATGLB2",,"Não foi possível criar varíavel global de controle "+Self:cUIDChatInicia,1,0 )
		Else
			Self:lGlbVarChat 	:= VarSetUID(Self:cUIDChatFim, .T.)
			If !Self:lGlbVarChat
				Help(,1,"CHATGLB4",,"Não foi possível criar varíavel global de controle "+Self:cUIDChatFim,1,0 )
			Else
				Self:lGlbVarChat 	:= VarSetUID(Self:cUIDChatFimCli, .T.)
				If !Self:lGlbVarChat
					Help(,1,"CHATGLB4",,"Não foi possível criar varíavel global de controle "+Self:cUIDChatFimCli,1,0 )
				EndIf
			EndIf
		Endif
	Else
		Self:lGlbVarChat := .F.
	EndIf

	Self:RemoveGarbage()

	DelClassIntf()
Return(Self)

Method Init() CLASS CtSdkChat
	Local lRet 					:= .T.
	Local cManip				:= ""
	Local cIntrod 				:= ""
	Local cScript				:= ""
	Local aOpcJC				:= {}
	Local oPanelBot				:= nil
	Local oButt4,oButt5,oButt6	:= nil
	Local oSize 				:= FWDefSize():New( .F.,.T.,600 )
	Local nI					:= 0
	Local bBloco				:= nil
	 
	oSize:AddObject( "CABEC", 100, 100, .T., .T. )
		 
	oSize:lProp 	:= .T.
	oSize:lLateral  := .F. 
	oSize:Process()

	If Self:SetGrupoAte() .and. Self:lGlbVarChat

		Self:oTela	:=	TDialog():New(	oSize:aWindSize[1],;
			oSize:aWindSize[2],;
			oSize:aWindSize[3],;
			oSize:aWindSize[4],;
			"Chat - "+Tk091Titulo(Self:cCoduser),;
			nil,;
			nil,;
			nil,;
			nOr(WS_VISIBLE,WS_POPUP),;
			0,;
			16777215,;
			nil,;
			nil,;
			.T.,;
			nil,;
			nil,;
			nil,;
			nil,;
			nil,;
			.T.)

		Self:oTela:bFocusChange := {|o,lfocus| Self:ChatFocus := lfocus }

		Self:SetJanOper()

		oPanelBot := tPanel():New(0,0,"",Self:oTela,,,,,,00,10)
		oPanelBot:Align := CONTROL_ALIGN_BOTTOM

		oPop1 		:= tMenu():new(0, 0, 0, 0, .T.)
		oPop1Ini	:= tMenuItem():new(oPop1, "Iniciar" , , , , {|| }, , , , , , , , , .T.)
		
		oPop1Can	:= tMenuItem():new(oPop1, "Cancelar", , , , {|| iif( Self:nPausa == 1, (Self:nPausa := 0, Self:SetPausa(.F.)), MsgStop("Não existe pausa iniciada.") ) }, , , , , , , , , .T.)
		
		oPop1:add(oPop1Ini)
		oPop1:add(oPop1Can)
		
		SX5->(DbSetOrder(1))
		
		If SX5->(DbSeek(xFilial("SX5")+"Z0"))
			
			cCountO := 0
			aObj	:= {}
			While !SX5->(EoF()) .and. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"Z0"
				 cCountO ++
				 bBloco := &("{ ||  Self:nPausa := 1, Self:cCodPausa := '"+Alltrim(SX5->X5_CHAVE)+"'}" )
				 &("oSubm"+Alltrim(Str(cCountO))) := tMenuItem():new(oPop1Ini, Alltrim(SX5->X5_DESCRI) , , , , bBloco , , , , , , , , , .T.)
				 
				 oPop1Ini:add(&("oSubm"+Alltrim(Str(cCountO))))
				 
				 SX5->(DbSkip())
			
			EndDo
		Endif

		@ 000,400 BUTTON oButt4 Prompt  "PAUSA"	 		SIZE 40,12 PIXEL OF oPanelBot ACTION	{||   }
		oButt4:Align := CONTROL_ALIGN_RIGHT
		oButt4:setPopupMenu(oPop1)

		@ 000,450 BUTTON oButt5	Prompt  "HISTORICO"	 SIZE 40,12 PIXEL OF oPanelBot ACTION	{|| PGExecProg("u_PesqHist()","Histórico Servicedesk")}
		oButt5:Align := CONTROL_ALIGN_RIGHT

		@ 000,500 BUTTON oButt6 Prompt  "SAIR"	 	SIZE 40,12 PIXEL OF oPanelBot ACTION {||Self:EncerraJanela()}
		oButt6:Align := CONTROL_ALIGN_RIGHT

		If Self:lStat
			Self:oSay	:= tSay():New(0,0,{|| '...Aguarde obtendo Fila...' },oPanelBot,,,.F.,.F.,.F.,.T.,RGB(0,0,0),CLR_WHITE)
			Self:oSay:Align	:= CONTROL_ALIGN_LEFT
		EndIf

		Self:oSayLine	:= tSay():New(0,200,{|| Self:_cGrupo+"-"+Alltrim(Posicione("SU0", 1, xFilial("SU0")+Self:_cGrupo, "U0_NOME")) },oPanelBot,,,.F.,.F.,.F.,.T.,RGB(0,0,0),CLR_WHITE)
		Self:oSayLine:Align	:= CONTROL_ALIGN_LEFT

		If Self:nTpRmt == 5
			Self:lStat := .F.
			oEdit := TSimpleEditor():Create( Self:oTela )
			oEdit:TextFormat(1)

			cScript	:= "<script>"
			cScript	+= "var ifs = document.getElementsByTagName('iframe');"
			cScript	+= "var seqbutt = 0;"
			cScript	+= "if (ifs != 'undefined') {"
			cScript	+= "	for (j=0; j<ifs.length; j++){"
			cScript	+= "  		ifs[j].setAttribute('sandbox', 'allow-scripts allow-same-origin allow-top-navigation allow-forms allow-popups');"
			cScript	+= "			if (ifs[j].src.indexOf('operatorInput') > 0) {"
			cScript	+= "				var butt = ifs[j].parentNode.getElementsByTagName('button');"
			cScript	+= "					if (butt != 'undefined') {"
			cScript	+= "						for (y=0; y<butt.length; y++){"
			cScript	+= "							if (butt[y].innerText == 'ENVIAR' && butt[y].onclick == null){"
			cOperInput :="document.getElementById('"+'"'+"+ifs[j].id+"+'"'+"').contentWindow.document.getElementById('inputOperador').value='';"

			cScript	+= '  								butt[y].setAttribute("onclick", "'+cOperInput+'");'
			cScript	+= "  								butt[y].id = 'button'+seqbutt.toString();"
			cScript	+= "								seqbutt++;"
			cScript	+= "}"
			cScript	+= "}"
			cScript	+= "}"
			cScript	+= "}"
			cScript	+= "}"
			cScript	+= "};"
			cScript	+= "var txta = document.getElementsByTagName('textarea');"
			cScript	+= "if (txta != 'undefined') {"
			cScript	+= "	for (j=0; j<txta.length; j++)"
			cScript	+= "  		txta[j].id = 'textarea'+j.toString();"
			cScript	+= "};"
			cScript	+= "var pop = document.getElementsByClassName('tmenupopupitem');"
			cScript	+= "var seqpop = 0;"
			cScript	+= "if (pop != 'undefined') {"
			cScript	+= "	for (j=0; j<pop.length; j++){"
			cScript	+= "		if (pop[j].tagName.toLowerCase() == 'li') {"
			cScript	+= "  			pop[j].id = 'popitem'+seqpop.toString();"
			cScript	+= "			seqpop++;"
			cScript	+= "}"
			cScript	+= "}"
			cScript	+= "}"

			cScript	+= "</script>"

			oEdit:Load(cScript)
		EndIf
	Else
		lRet := .F.
	EndIf

Return(lRet)

Method Activate(lTimer,lDisp) CLASS CtSdkChat

	Default lTimer := .T.
	Default lDisp  := .T.

	If lTimer
		If Self:nTpRmt == 5
			Self:oTimerCro := TTimer():New(10000, { ||  DelClassIntf() , Self:AtualizaConversa(), DelClassIntf()  }, Self:oTela )
		Else
			Self:oTimerCro := TTimer():New(1000 , { || DelClassIntf() , Self:AtualizaConversa(), DelClassIntf() }, Self:oTela )
		EndIf
		Self:oTimerCro:lLiveAny := .T.
		Self:oTimerCro:Activate()
	EndIf

	If lDisp
		Self:SetDisp()
	EndIf

	//Self:oRpcWs :=  TRPC():New(GetEnvServer())

	//Self:lConWs := Self:oRpcWs:Connect(Self:cWSServer,val(Self:cWSPort),1)

	Self:oTela:Activate(	nil,;
		nil,;
		nil,;
		.T.,;
		{||.T.},;
		nil,;
		{||DelClassIntf()}	)

	Self:oRpcWs:Disconnect()
	FreeObj(Self:oRpcWs)
	Self:oRpcWs := nil

	VarDel( Self:cUIDChatFim	, Self:cUIDChatChave )
	VarDel( Self:cUIDChatFimCli, Self:cUIDChatChave )
	VarDel( Self:cUIDChatInicia, Self:cUIDChatChave )

Return

Method SetJanOper()  CLASS CtSdkChat
	Local oPanelAll					:= nil
	Local oPanelBot					:= nil
	Local nPerJan					:= (100 / Self:_nJanOper)
	Local oFontn					:= TFont():New('Calibri',,-19,,.T.)
	Local oJan1,oJan2				:= nil
	Local oJan3,oJan4				:= nil
	Local oPanChat1,oPanChat2		:= nil
	Local oPanChat3,oPanChat4		:= nil
	Local oPan1Sup,oPan1Inf			:= nil
	Local oPan2Sup,oPan2Inf			:= nil
	Local oPan3Sup,oPan3Inf			:= nil
	Local oPan4Sup,oPan4Inf			:= nil
	Local oPan1InfBot,oPan2InfBot	:= nil
	Local oPan3InfBot,oPan4InfBot	:= nil
	Local oPop1,oPop2,oPop3,oPop4	:= nil
	Local oPop1Enc1,oPop1Enc2		:= nil
	Local oPop1Enc3,oPop1Enc4		:= nil
	Local oPop1Sal1,oPop1Sal2		:= nil
	Local oPop1Sal3,oPop1Sal4		:= nil
	Local oButtPop1,oButtPop2		:= nil
	Local oButtPop3,oButtPop4		:= nil

	oPanelAll := tPanel():New(0,0,"",Self:oTela,,,,,,00,00)
	oPanelAll:Align := CONTROL_ALIGN_ALLCLIENT

	Self:oLayer := FWLayer():New()
	Self:oLayer:Init(oPanelAll,.F.,.T.)

	Self:oLayer:addLine("LINHA1", 100, .F.)

	If Self:_nJanOper >= 1

		Self:oLayer:AddCollumn("Jan1",nPerJan,.T.,"LINHA1")
		Self:oLayer:AddWindow("Jan1","oJan1","Conversa 1 - JANELA LIVRE",100,.f.,.f.,{|| },"LINHA1",{|| })

		oJan1 := Self:oLayer:GetWinPanel("Jan1","oJan1","LINHA1")

		oPanChat1 := tPanel():New(0,0,"",oJan1,,,,,,00,0)
		oPanChat1:Align := CONTROL_ALIGN_ALLCLIENT

		oPan1Sup := tPanel():New(0,0,"",oPanChat1,,,,,,00,0)
		oPan1Sup:Align := CONTROL_ALIGN_ALLCLIENT

		oPan1Inf := tPanel():New(0,0,"",oPanChat1,,,,,,00,50)
		oPan1Inf:Align := CONTROL_ALIGN_BOTTOM

		Self:oMeterJan1 := TMeter():New(00,00,{|u|if(Pcount()>0,Self:nMeterJan1:=u,Self:nMeterJan1)},100,oPan1Sup,100,5,,.f.,,,.F.,RGB(255,165,0))
		Self:oMeterJan1:SetTotal(Self:nInativBar)
		Self:oMeterJan1:Align	:= CONTROL_ALIGN_TOP

		Self:oFormuld1 := TIBrowser():New(0,0,0,0, "about:blank",oPan1Sup )
    	Self:oFormuld1:Align	:= CONTROL_ALIGN_ALLCLIENT

		Self:oVariav1 := tMultiGet():New(0,0,{|u| iif(Pcount()>0,Self:cVariav1:=u,Self:cVariav1)},oPan1Inf,0,0,oFontn)
		Self:oVariav1:Align	:= CONTROL_ALIGN_ALLCLIENT
		Self:oVariav1:bGotFocus	:= {|| Self:nJanAtual := 1 }

		oPan1InfBot := tPanel():New(0,0,"",oPan1Inf,,,,,,25,10)
		oPan1InfBot:Align := CONTROL_ALIGN_RIGHT

		oButtEnv1:= TButton():Create( oPan1InfBot,000,000,"ENVIAR",{||Self:SetConversa(Self:cVariav1,"01",1), Self:oVariav1:SetFocus()},25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtEnv1:Align := CONTROL_ALIGN_ALLCLIENT

		oPop1 		:= tMenu():new(0, 0, 0, 0, .T.)
		oPop1Enc1	:= tMenuItem():new(oPop1, "Encerrar Conversa", , , , {||Self:SetConversa(Self:cVariav1,"05",1), Self:oVariav1:SetFocus()}, , , , , , , , , .T.)
		oPop1Sal1	:= tMenuItem():new(oPop1, "Salvar Conversa", , , , {||Iif(!Empty(Self:aJanID[1][1]),Self:CriaAtendimento(1,.T.,.F.),MsgStop("Janela sem Conversação , Operação Interrompida","Aviso")), Self:oVariav1:SetFocus()}, , , , , , , , , .T.)
		oPop1:add(oPop1Enc1)
		oPop1:add(oPop1Sal1)

		oButtPop1:= TButton():Create( oPan1InfBot,000,000,"...",{|| },25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtPop1:Align := CONTROL_ALIGN_BOTTOM
		oButtPop1:setPopupMenu(oPop1)

		If Self:nTpRmt == 5
			oVariav1H := TIBrowser():New(0,0,0,0, "",oPan1Inf )
			oVariav1H:Navigate(Self:cInptOper+"?textarea0,button0,popitem0,popitem1")
			oVariav1H:Align	:= CONTROL_ALIGN_ALLCLIENT
			oPan1InfBot:lVisibleControl := .F.
			oButtEnv1:lVisibleControl := .F.
			oPop1:lVisibleControl := .F.
			oButtPop1:lVisibleControl := .F.
		EndIf

	Endif

	If Self:_nJanOper >= 2

		Self:oLayer:AddCollumn("Jan2",nPerJan,.T.,"LINHA1")
		Self:oLayer:AddWindow("Jan2","oJan2","Conversa 2 - JANELA LIVRE",100,.F.,.F.,{ || },"LINHA1",{|| })
		oJan2 := Self:oLayer:GetWinPanel("Jan2","oJan2","LINHA1")

		oPanChat2 := tPanel():New(0,0,"",oJan2,,,,,,00,0)
		oPanChat2:Align := CONTROL_ALIGN_ALLCLIENT

		oPan2Sup := tPanel():New(0,0,"",oPanChat2,,,,,,00,0)
		oPan2Sup:Align := CONTROL_ALIGN_ALLCLIENT

		oPan2Inf := tPanel():New(0,0,"",oPanChat2,,,,,,00,50)
		oPan2Inf:Align := CONTROL_ALIGN_BOTTOM

		Self:oMeterJan2 := TMeter():New(00,00,{|u|if(Pcount()>0,Self:nMeterJan2:=u,Self:nMeterJan2)},100,oPan2Sup,100,5,,.f.,,,.F.,RGB(255,165,0))
		Self:oMeterJan2:SetTotal(Self:nInativBar)
		Self:oMeterJan2:Align	:= CONTROL_ALIGN_TOP

		Self:oFormuld2 := TIBrowser():New(0,0,0,0, "about:blank",oPan2Sup )
		Self:oFormuld2:Align	:= CONTROL_ALIGN_ALLCLIENT

		Self:oVariav2 := tMultiGet():New(0,0,{|u| iif(Pcount()>0,Self:cVariav2:=u,Self:cVariav2) },oPan2Inf,0,0,oFontn)
		Self:oVariav2:Align	:= CONTROL_ALIGN_ALLCLIENT
		Self:oVariav2:bGotFocus	:= {|| Self:nJanAtual := 2 }

		oPan2InfBot := tPanel():New(0,0,"",oPan2Inf,,,,,,25,10)
		oPan2InfBot:Align := CONTROL_ALIGN_RIGHT

		oButtEnv2:= TButton():Create( oPan2InfBot,000,000,"ENVIAR",{|| Self:SetConversa(Self:cVariav2,"01",2), Self:oVariav2:SetFocus()},25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtEnv2:Align := CONTROL_ALIGN_RIGHT

		oPop2 		:= tMenu():new(0, 0, 0, 0, .T.)
		oPop2Enc1	:= tMenuItem():new(oPop2, "Encerrar Conversa", , , , {||Self:SetConversa(Self:cVariav2,"05",2), Self:oVariav2:SetFocus()}, , , , , , , , , .T.)
		oPop2Sal1	:= tMenuItem():new(oPop2, "Salvar Conversa", , , , {||Iif(!Empty(Self:aJanID[2][1]),Self:CriaAtendimento(2,.T.,.F.),MsgStop("Janela sem Conversação , Operação Interrompida","Aviso")), Self:oVariav2:SetFocus()}, , , , , , , , , .T.)
		oPop2:add(oPop2Enc1)
		oPop2:add(oPop2Sal1)

		oButtPop2:= TButton():Create( oPan2InfBot,000,000,"...",{|| },25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtPop2:Align := CONTROL_ALIGN_BOTTOM
		oButtPop2:setPopupMenu(oPop2)

		If Self:nTpRmt == 5
			oVariav2H := TIBrowser():New(0,0,0,0, "",oPan2Inf )
			oVariav2H:Navigate(Self:cInptOper+"?textarea1,button1,popitem2,popitem3")
			oVariav2H:Align	:= CONTROL_ALIGN_ALLCLIENT
			oPan2InfBot:lVisibleControl := .F.
			oButtEnv2:lVisibleControl := .F.
			oPop2:lVisibleControl := .F.
			oButtPop2:lVisibleControl := .F.
		EndIf

	EndIf

	If Self:_nJanOper >= 3

		Self:oLayer:AddCollumn("Jan3",nPerJan,.T.,"LINHA1")
		Self:oLayer:AddWindow("Jan3","oJan3","Conversa 3 - JANELA LIVRE",100,.F.,.F.,{ || },"LINHA1",{|| })
		oJan3 := Self:oLayer:GetWinPanel("Jan3","oJan3","LINHA1")

		oPanChat3 := tPanel():New(0,0,"",oJan3,,,,,,00,0)
		oPanChat3:Align := CONTROL_ALIGN_ALLCLIENT

		oPan3Sup := tPanel():New(0,0,"",oPanChat3,,,,,,00,0)
		oPan3Sup:Align := CONTROL_ALIGN_ALLCLIENT

		oPan3Inf := tPanel():New(0,0,"",oPanChat3,,,,,,00,50)
		oPan3Inf:Align := CONTROL_ALIGN_BOTTOM

		Self:oMeterJan3 := TMeter():New(00,00,{|u|if(Pcount()>0,Self:nMeterJan3:=u,Self:nMeterJan3)},100,oPan3Sup,100,5,,.f.,,,.F.,RGB(255,165,0))
		Self:oMeterJan3:SetTotal(Self:nInativBar)
		Self:oMeterJan3:Align	:= CONTROL_ALIGN_TOP

		Self:oFormuld3 := TIBrowser():New(0,0,0,0, "about:blank",oPan3Sup )
		Self:oFormuld3:Align	:= CONTROL_ALIGN_ALLCLIENT

		Self:oVariav3 := tMultiGet():New(0,0,{|u| iif(Pcount()>0,Self:cVariav3:=u,Self:cVariav3)},oPan3Inf,0,0,oFontn)
		Self:oVariav3:Align	:= CONTROL_ALIGN_ALLCLIENT
		Self:oVariav3:bGotFocus	:= {|| Self:nJanAtual := 3 }

		oPan3InfBot := tPanel():New(0,0,"",oPan3Inf,,,,,,25,10)
		oPan3InfBot:Align := CONTROL_ALIGN_RIGHT

		oButtEnv3:= TButton():Create( oPan3InfBot,000,000,"ENVIAR",{|| Self:SetConversa(Self:cVariav3,"01",3), Self:oVariav3:SetFocus()},25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtEnv3:Align := CONTROL_ALIGN_RIGHT

		oPop3 		:= tMenu():new(0, 0, 0, 0, .T.)
		oPop3Enc1	:= tMenuItem():new(oPop3, "Encerrar Conversa", , , , {||Self:SetConversa(Self:cVariav3,"05",3), Self:oVariav3:SetFocus()}, , , , , , , , , .T.)
		oPop3Sal1	:= tMenuItem():new(oPop3, "Salvar Conversa", , , , {||Iif(!Empty(Self:aJanID[3][1]),Self:CriaAtendimento(3,.T.,.F.),MsgStop("Janela sem Conversação , Operação Interrompida","Aviso")), Self:oVariav3:SetFocus()}, , , , , , , , , .T.)
		oPop3:add(oPop3Enc1)
		oPop3:add(oPop3Sal1)

		oButtPop3:= TButton():Create( oPan3InfBot,000,000,"...",{|| },25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtPop3:Align := CONTROL_ALIGN_BOTTOM
		oButtPop3:setPopupMenu(oPop3)

		If Self:nTpRmt == 5
			oVariav3H := TIBrowser():New(0,0,0,0, "",oPan3Inf )
			oVariav3H:Navigate(Self:cInptOper+"?textarea2,button2,popitem4,popitem5")
			oVariav3H:Align	:= CONTROL_ALIGN_ALLCLIENT
			oPan3InfBot:lVisibleControl := .F.
			oButtEnv3:lVisibleControl := .F.
			oPop3:lVisibleControl := .F.
			oButtPop3:lVisibleControl := .F.
		EndIf

	EndIf

	If Self:_nJanOper >= 4

		Self:oLayer:AddCollumn("Jan4",nPerJan,.T.,"LINHA1")
		Self:oLayer:AddWindow("Jan4","oJan4","Conversa 4 - JANELA LIVRE",100,.F.,.F.,{ || },"LINHA1",{|| })
		oJan4 := Self:oLayer:GetWinPanel("Jan4","oJan4","LINHA1")

		oPanChat4 := tPanel():New(0,0,"",oJan4,,,,,,00,0)
		oPanChat4:Align := CONTROL_ALIGN_ALLCLIENT

		oPan4Sup := tPanel():New(0,0,"",oPanChat4,,,,,,00,0)
		oPan4Sup:Align := CONTROL_ALIGN_ALLCLIENT

		oPan4Inf := tPanel():New(0,0,"",oPanChat4,,,,,,00,50)
		oPan4Inf:Align := CONTROL_ALIGN_BOTTOM

		Self:oMeterJan4 := TMeter():New(00,00,{|u|if(Pcount()>0,Self:nMeterJan4:=u,Self:nMeterJan4)},100,oPan4Sup,100,5,,.f.,,,.F.,RGB(255,165,0))
		Self:oMeterJan4:SetTotal(Self:nInativBar)
		Self:oMeterJan4:Align	:= CONTROL_ALIGN_TOP

		Self:oFormuld4 := TIBrowser():New(0,0,0,0, "about:blank",oPan4Sup )
		Self:oFormuld4:Align	:= CONTROL_ALIGN_ALLCLIENT

		Self:oVariav4 := tMultiGet():New(0,0,{|u| iif(Pcount()>0,Self:cVariav4:=u,Self:cVariav4)},oPan4Inf,0,0,oFontn)
		Self:oVariav4:Align	:= CONTROL_ALIGN_ALLCLIENT
		Self:oVariav4:bGotFocus	:= {|| Self:nJanAtual := 4 }

		oPan4InfBot := tPanel():New(0,0,"",oPan4Inf,,,,,,25,10)
		oPan4InfBot:Align := CONTROL_ALIGN_RIGHT

		oButtEnv4:= TButton():Create( oPan4InfBot,000,000,"ENVIAR",{|| Self:SetConversa(Self:cVariav4,"01",4), Self:oVariav4:SetFocus()},25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtEnv4:Align := CONTROL_ALIGN_RIGHT

		oPop4 		:= tMenu():new(0, 0, 0, 0, .T.)
		oPop4Enc1	:= tMenuItem():new(oPop4, "Encerrar Conversa", , , , {||Self:SetConversa(Self:cVariav4,"05",4), Self:oVariav4:SetFocus()}, , , , , , , , , .T.)
		oPop4Sal1	:= tMenuItem():new(oPop4, "Salvar Conversa", , , , {||Iif(!Empty(Self:aJanID[4][1]),Self:CriaAtendimento(4,.T.,.F.),MsgStop("Janela sem Conversação , Operação Interrompida","Aviso")), Self:oVariav4:SetFocus()}, , , , , , , , , .T.)
		oPop4:add(oPop4Enc1)
		oPop4:add(oPop4Sal1)

		oButtPop4:= TButton():Create( oPan4InfBot,000,000,"...",{|| },25,10,,,,.T.,,,,{|| Self:_Habfor },,)
		oButtPop4:Align := CONTROL_ALIGN_BOTTOM
		oButtPop4:setPopupMenu(oPop4)

		If Self:nTpRmt == 5
			oVariav4H := TIBrowser():New(0,0,0,0, "",oPan4Inf )
			oVariav4H:Navigate(Self:cInptOper+"?textarea3,button3,popitem6,popitem7")
			oVariav4H:Align	:= CONTROL_ALIGN_ALLCLIENT
			oPan4InfBot:lVisibleControl := .F.
			oButtEnv4:lVisibleControl := .F.
			oPop4:lVisibleControl := .F.
			oButtPop4:lVisibleControl := .F.
		EndIf

	EndIf

Return

Method SetGrupoAte() CLASS CtSdkChat
	Local lRet 	:= .T.
	Local nI	:= 0

	dbSelectArea("SU7")
	SU7->(dbSetOrder(1))
	SU7->(DbSeek(xFilial("SU7")+Self:cCoduser))

	Self:_nomeuser	:=  Alltrim(SU7->U7_NOME)
	Self:_nJanOper	:= val(SU7->U7_XJCHAT)

	If SU7->(FieldPos("U7_XOPCHAT")) > 0 .and. SU7->U7_XOPCHAT == "1"
		Self:_cChatoPC	:= "1"
	Endif

	If	SU7->(FieldPos("U7_XSELGRP")) > 0 .and.;
			SU7->U7_XSELGRP == "1" .and.;
			!Isblind()
		Self:_cGrupo	:= U_CTSDK021()
	Else
		Self:_cGrupo	:= SU7->U7_POSTO
	EndIf

	If Empty(Self:_cGrupo)
		Help(,1,"CHATGRP",,"Não foi selecionado nenhum grupo para atendimento.",1,0 )
		lRet := .F.
	Else
		If Self:_nJanOper <= 0
			Help(,1,"CHATJAN",,"Operador sem Acesso a Janelas de Chat!",1,0 )
			lRet := .F.
		Else
			If GetPvProfString("config","BrowserEnabled","0",Self:cIni) == "0"
				If !WritePProString("config","BrowserEnabled","1",Self:cIni)
					Help(,1,"CHATINI1",,"Não foi possível preparar smarclient para acessar rotina de Chat."+CRLF+" Por favor, notifique área de Sistemas Coporativos",1,0 )
				Else
					Help(,1,"CHATINI2",,"SmartClient não preparado para acessar rotina de Chat."+CRLF+" Por favor, saia do sistema e acesse novamente.",1,0 )
				EndIf

				lRet := .F.
			Else
				For nI:=1 to Self:_nJanOper
					AADD(Self:aJanID,{"",seconds(),"",""})
				Next
			EndIF
		EndIf
	EndIf

Return(lRet)

Method SetTrbSZN(lSelect) CLASS CtSdkChat
	Local cAliasRet	:= "SZN"+Alltrim(Str(Seconds(),6))

	Default lSelect	:= .T.

	While Select(cAliasRet) > 0
		Sleep(500)
		cAliasRet	:= "SZN"+Alltrim( Str( Seconds() , 6 ) )
	EndDo

	If lSelect
		BeginSql Alias cAliasRet
			%noparser%
			SELECT
			SZN.R_E_C_N_O_ SZNREC
			FROM
			%Table:SZN%	SZN
			WHERE
			SZN.ZN_FILIAL = %XFilial:SZN%	AND
			SZN.ZN_THREAD = %Exp:Self:cThread%	AND
			SZN.ZN_PIN = %Exp:Self:cPin%	AND
			SZN.ZN_SERVER = %Exp:Self:cIpServer%	AND
			SZN.ZN_PORTA = %Exp:Self:cPortServer%	AND
			SZN.%NotDel%
		EndSql
	EndIf
Return(cAliasRet)

Method SetTrbSZM(cStatus,lSelect) CLASS CtSdkChat
	Local cAliasRet	:= "SZM"+Alltrim(Str(Seconds(),6))

	Default cStatus	:= 'OPEN'
	Default lSelect	:= .T.

	While Select(cAliasRet) > 0
		Sleep(500)
		cAliasRet	:= "SZM"+Alltrim( Str( Seconds() , 6 ) )
	EndDo

	If lSelect
		BeginSql Alias cAliasRet
			%noparser%
			SELECT
			SZM.R_E_C_N_O_ SZMREC
			FROM
			%Table:SZM%	SZM
			WHERE
			SZM.ZM_FILIAL = %xFilial:SZM%	AND
			SZM.ZM_STATUS = %Exp:cStatus% AND
			SZM.ZM_THREAD = %Exp:Self:cThread%	AND
			SZM.ZM_PIN = %Exp:Self:cPin%	AND
			SZM.ZM_SERVER = %Exp:Self:cIpServer%	AND
			SZM.ZM_PORTA = %Exp:Self:cPortServer%	AND
			SZM.ZM_GRUPO = %Exp:Self:_cGrupo% AND
			SZM.ZM_CODOP = %Exp:Self:cCoduser% AND
			SZM.%NotDel%
		EndSql
	Endif
Return(cAliasRet)

Method SetDisp(lDelet) CLASS CtSdkChat
	Local cAliasSZN := Self:SetTrbSZN()
	Local nQtdConv 	:= 0
	Local cAliasSZM := Self:SetTrbSZM()
	Local cOperado	:= ""

	Default lDelet := .T.

	(cAliasSZM)->( DbEval( {|| nQtdConv++ } ) )

	(cAliasSZM)->(DbCloseArea())

	If (cAliasSZN)->(!Eof())

		While (cAliasSZN)->(!Eof())
			DbSelectArea("SZN")
			SZN->(DbGoto((cAliasSZN)->SZNREC))
			
			cOperado := SZN->ZN_CODOP
		
			SZN->(Reclock("SZN"))
			If lDelet
				SZN->ZN_LOGOUT := Alltrim(dtoc(date())+time())
				SZN->(DBDELETE())
			Else
				SZN->ZN_DISP 	:= Self:_nJanOper - nQtdConv
				SZN->ZN_PAUSA 	:= Alltrim(Str(Self:nPausa))
			Endif
			SZN->(MsUnlock())

			(cAliasSZN)->(Dbskip())
		Enddo
		
		If !Empty(cOperado)
			cUpdZK := "UPDATE "+RetSqlName("SZK") 
			cUpdZK += " SET ZK_STATUS = '2', " 
			cUpdZK += " ZK_DTFIM = ZK_DTINI, "
			cUpdZK += " ZK_HRFIM = '"+SubStr(Time(),1,5)+"' " 
			cUpdZK += "WHERE "
			cUpdZK += " ZK_FILIAL =  '"+xFilial("SZK")+"' AND " 
			cUpdZK += " ZK_OPERADO = '"+cOperado+"' AND "
			cUpdZK += " ZK_DTINI = '"+DtoS(Date())+"' AND "
			cUpdZK += " ZK_HRFIM = ' ' AND "
			cUpdZK += " ZK_DTFIM = ' ' AND "
			cUpdZK += " D_E_L_E_T_ = ' ' "
			
			TcSqlExec(cUpdZK)
		Endif

	Endif
	(cAliasSZN)->(DbCloseArea())

	If lDelet
		RecLock("SZN",.T.)
		SZN->ZN_THREAD	:= Self:cThread
		SZN->ZN_PIN	 	:= Self:cPIN
		SZN->ZN_SERVER 	:= Self:cIpServer
		SZN->ZN_PORTA 	:= Self:cPortServer
		SZN->ZN_PAUSA 	:= Alltrim(Str(Self:nPausa))
		SZN->ZN_GRUPO 	:= Self:_cGrupo
		SZN->ZN_DISP 	:= Self:_nJanOper
		SZN->ZN_CODOP 	:= Self:cCodUser
		SZN->(MsUnlock())
	Endif
Return

Method SetPausa(lMsg) CLASS CtSdkChat
	Local cAliasSZN := ""
	Local cAliasSZM := ""
	Local nQtdConv	:= 0

	Default lMsg	:= .T.

	Self:oTimerCro:DeActivate()

	If Self:nPausa == 1

		cAliasSZN := Self:SetTrbSZN()

		If (cAliasSZN)->(!Eof())

			nQtdConv := 0

			cAliasSZM := Self:SetTrbSZM()

			(cAliasSZM)->( DbEval( {|| nQtdConv++ } ) )

			(cAliasSZM)->(DbCloseArea())
			
			If nQtdConv == 0
			
				Self:SetDisp(.F.)

				U_CTSDK04(Self:_cGrupo,Self:cCodPausa)

				Self:nPausa 	:= 0

				Self:SetDisp(.F.)

			EndIf

		Endif

		(cAliasSZN)->(DbCloseArea())
	EndIf

	If Self:nPausa == 1 .and. Alltrim(Self:oTela:cTitle) <> Alltrim(Self:oTela:cTitle+"*** EM PAUSA ***")
		Self:oTela:cTitle  	:= Self:oTela:cTitle+"*** EM PAUSA ***"
		Self:oSayLine:cCaption := "*** OPERADOR EM PAUSA ****"

		Self:oSayLine:Refresh()
		Self:oTela:Refresh()
		Self:SetDisp(.F.)

	ElseIf Self:nPausa <> 1 .and. Alltrim(Self:oSayLine:cCaption) <> Alltrim(Self:_cGrupo+"-"+Alltrim(Posicione("SU0", 1, xFilial("SU0")+Self:_cGrupo, "U0_NOME")))
		Self:oTela:cTitle  	:= strtran(strtran(Self:oTela:cTitle,"EM PAUSA",""),"*","")
		Self:oSayLine:cCaption := Self:_cGrupo+"-"+Alltrim(Posicione("SU0", 1, xFilial("SU0")+Self:_cGrupo, "U0_NOME"))
		
		Self:oSayLine:Refresh()
		Self:oTela:Refresh()
		Self:SetDisp(.F.)

	Endif

	Self:oTimerCro:Activate()
Return

Method IniciaJanelaChat(cSession,lCriaAtd,lLoad) CLASS CtSdkChat
	Local nJan 			:= 0
	Local cChatOper 	:= ""
	Local lRet			:= .T.

	Default cSession	:= ""
	Default lCriaAtd	:= .T.
	Default lLoad		:= .F.

	If !Empty(cSession)
		If !lLoad
			nJan	:= Ascan(Self:aJanID,{|x| Empty(x[1])})
		Else
			nJan	:= Ascan(Self:aJanID,{|x| !Empty(x[1]) .and. x[1] == cSession .and. Empty(x[3])  })
		EndIf

		If nJan > 0
			Self:aJanID[nJan][1] := cSession
			Self:aJanID[nJan][2] := seconds()
			Self:aJanID[nJan][3] := ''

			cChatOper 		:= Self:cChatOper+"?id="+cSession

			If Self:lGlbVarChat
				If nJan == 1
					Self:cTimeJan1 := Time()
					Self:oFormuld1:Navigate(cChatOper)
					Self:lCro1 := .T.
					Self:cTimeUltConv1	 := Time()
				ElseIf nJan == 2
					Self:cTimeJan2 := Time()
					Self:oFormuld2:Navigate(cChatOper)
					Self:lCro2 := .T.
					Self:cTimeUltConv2	 := Time()
				ElseIf nJan == 3
					Self:cTimeJan3 := Time()
					Self:oFormuld3:Navigate(cChatOper)
					Self:lCro3 := .T.
					Self:cTimeUltConv3	 := Time()
				ElseIf nJan == 4
					Self:cTimeJan4 := Time()
					Self:oFormuld4:Navigate(cChatOper)
					Self:lCro4 := .T.
					Self:cTimeUltConv4	 := Time()
				Endif
			Endif

			If lCriaAtd
				Self:CriaAtendimento(nJan,.F.,.F.)
			Else
				StartJob("U_CHAT2PLN",GetEnvServer(),.f.,'1',LogUserName(),Self:_cEmp,Self:_cFil,Self:cThread,Self:cCoduser,Self:_cGrupo,Self:cPin,nJan,Self:aJanID)
			EndIf

			If !Self:ChatFocus .or. Self:oTela:windowState() == 1 .or. !Self:oTela:hasFocus()
				Self:AlertChat(1, 'Nova conversa na janela '+Alltrim(Str(nJan)) )
				Self:oTela:cTitle := Self:oTela:cTitle+"**"+Alltrim(Str(nJan))
			EndIf
		Else
			Help(,1,"CHATCON2",,"Não foi encontrada janela livre para conversação",1,0 )
			lRet := .F.
		Endif
	Else
		Help(,1,"CHATCON1",,"Não foi informada sessão para inicio de conversa",1,0 )
		lRet := .F.
	Endif
Return(lRet)

Method CriaAtendimento(nJanela,lMostraTela,lAvisaOper,lForcaSZM) CLASS CtSdkChat

	Local cAliasSZN		:= ""
	Local cAliasSZM		:= ""
	Local _ccham		:= ""
	Local nOPChamado	:= 0
	Local _ctexto		:= ""
	Local _cTexto		:= ""
	Local cMenTxt		:= ""
	Local nRecZM		:= 0
	Local lTimeOut		:= .F.
	Local cTime			:= ""
	Local lEofSZM		:= .T.

	Private aRotina 	:= {{"Pesquisar","AxPesqui",0,1} 	,;
		{"Visualizar","AxVisual",0,2} 	,;
		{"Incluir","AxInclui",0,3} 		,;
		{"Alterar","AxAltera",0,4} 		,;
		{"Excluir","AxDeleta",0,5}}

	Default nJanela		:= 0
	Default lMostraTela	:= .F.
	Default lForcaSZM	:= .F.

	If nJanela > 0

		If lAvisaOper
			cMenTxt := "Seu atendimento terá seguimento com "+Alltrim(Self:_nomeuser)+" e seu protocolo de acompanhamento esta sendo preparado."
			Self:SetConversa(cMenTxt,"01",nJanela)
		Endif

		_ctexto := StrTran(_ctexto,"<div id ='oJan"+Alltrim(Str(nJanela))+"' contentEditable='false'><iframe src='http://192.168.16.10:9090/WebChat/faces/index.xhtml?grupo=27'>","")
		_ctexto := StrTran(_ctexto,"</iframe></div><script type='text/javascript'>document.getElementById('oJan"+Alltrim(Str(nJanela))+"').scrollIntoView(false);</script>","")
		_ctexto := StrTran(_ctexto,"<br>",CRLF)

		If lForcaSZM
			cTime := Time()

			While lEofSZM .and. !lTimeOut
				lTimeOut := ElapTime( cTime, Time() ) > "00:00:20"

				cAliasSZM := Self:SetTrbSZM(nil,.F.)

				BeginSql Alias cAliasSZM
					%noparser%
					SELECT
						R_E_C_N_O_ SZMREC
					FROM
						%Table:SZM% SZM
					WHERE
						ZM_FILIAL = %Exp:xFilial("SZM")% AND
						ZM_SESSAO = %Exp:Alltrim(Self:aJanID[nJanela][1])%	AND
						ZM_PIN = %Exp:Alltrim(Self:cPin)% AND
						SZM.%NotDel%
				EndSql

				lEofSZM := (cAliasSZM)->(EoF())

				If lEofSZM
					(cAliasSZM)->(DbCloseArea())
				Else
					SZM->(DbGoTo((cAliasSZM)->(SZMREC)))
					If Empty(SZM->ZM_PROTOCO)
						lEofSZM := .T.
						(cAliasSZM)->(DbCloseArea())
					EndIf
				EndIf

			EndDo

		Else
			cAliasSZM := Self:SetTrbSZM(nil,.F.)

			BeginSql Alias cAliasSZM
				%noparser%
				SELECT
					R_E_C_N_O_ SZMREC
				FROM
					%Table:SZM% SZM
				WHERE
					ZM_FILIAL = %Exp:xFilial("SZM")% AND
					ZM_SESSAO = %Exp:Alltrim(Self:aJanID[nJanela][1])%	AND
					ZM_PIN = %Exp:Alltrim(Self:cPin)% AND
					SZM.%NotDel%
			EndSql

		EndIf

		If Select(cAliasSZM) > 0

			If  !(cAliasSZM)->(EoF())
				SZM->(DbGoTo((cAliasSZM)->(SZMREC)))

				_ccham	:= SZM->ZM_PROTOCO
				_ctexto := SZM->ZM_MEN
				nRecZM	:= SZM->(Recno())
			EndIf

			(cAliasSZM)->(DbCloseArea())

			If Empty(_ccham) .and. !Empty(Self:aJanID[nJanela,3])
				_ccham :=  Self:aJanID[nJanela,3]
			Endif

			nOPChamado := iif(Empty(_ccham),3,4)

			U_CHATATEND(Self:_cGrupo,Self:cCoduser,_ctexto,_ccham,@nOPChamado,@Self:_cchamg,lMostraTela)

			cMenTxt := "O protocolo para acompanhamento é ["+Self:_cchamg+"]. Por favor, anote-o para consultas futuras."

			If nRecZM > 0 .and. !Empty(Self:_cchamg)
				DbSelectArea("SZM")
				SZM->(DbGoTo(nRecZM))

				RecLock("SZM",.F.)
					SZM->ZM_PROTOCO := Alltrim(Self:_cchamg)
				SZM->(MsUnlock())

				SZM->(DbCommit())

			Endif

			dbSelectArea("ADE")
			ADE->(dbSetOrder(1))
			If lMostraTela .and. ADE->(MsSeek(xFilial("ADE")+Self:_cchamg ))
				PGExecProg('u_xTelCham("'+Self:cCoduser+'","'+Self:_cGrupo+'",'+cValToChar(ADE->(Recno()))+' )',"Chamado Jan. "+cValToChar(nJanela)+" Chat")
			EndIf

			If !Empty(Self:_cchamg)
				Self:aJanID[nJanela,3] := Self:_cchamg
				If nOPChamado == 3
					Self:SetConversa(cMenTxt,"01",nJanela)
				EndIf
			EndIf
		EndIf
	Else
		Help(,1,"CHATATE",,"Não foi informada a janela para criação de chamado",1,0 )
	EndIf

Return

Method SetConversa(cConversa,cTpOper,nJanela,cSession,lEnviaCliente) CLASS CtSdkChat
	Local nJanAux			:= Self:nJanAtual
	Local cAliasSZM			:= ""
	Local lEnviaMen			:= .T.
	Local cRet				:= "1"
	Local cMsgHelp			:= ""
	Local cEnvServer		:= GetEnvServer()
	Local cNomeCli			:= ""
	Local nEspAt			:= 0
	Local cNomeAux			:= ""
	Local lConRPC			:= .F.
	Local nTotRPC			:= 0
	Local cServer			:= ""
	Local cEnvPorta			:= ""
	Local cEnvThread		:= ""
	Local oRpcSrv			:= nil
	Local aUsers			:= nil
	Local nTotUI			:= 0
	Local nIndex			:= 0
	Local aRet				:= {}
	Local nWhile			:= 0
	Local cMenEnc			:= ""
	Local nPosConv1			:= 0
	Local nPosConv2			:= 0
	Local cArqAnex			:= ""

	Default cConversa 		:= ""
	Default nJanela 		:= 1
	Default lEnviaCliente	:= .T.

	If nJanela > 0
		Self:nJanAtual := nJanela
	EndIf

	If nJanela <> 0 .and. Empty(Self:aJanID[Self:nJanAtual,1])
		MsgInfo("Nao possui nenhuma conversa ativa com a janela "+Alltrim(str(Self:nJanAtual)))

		If Self:nJanAtual == 1
			Self:oFormuld1:Navigate("about:blank")
			Self:oLayer:setWinTitle( "Jan1", "oJan1", "Conversa 1 - JANELA LIVRE" , "LINHA1" )
		ElseIf Self:nJanAtual == 2
			Self:oFormuld2:Navigate("about:blank")
			Self:oLayer:setWinTitle( "Jan2", "oJan2", "Conversa 2 - JANELA LIVRE" , "LINHA1" )
		ElseIf Self:nJanAtual == 3
			Self:oFormuld3:Navigate("about:blank")
			Self:oLayer:setWinTitle( "Jan3", "oJan3", "Conversa 3 - JANELA LIVRE" , "LINHA1" )
		ElseIf Self:nJanAtual == 4
			Self:oFormuld4:Navigate("about:blank")
			Self:oLayer:setWinTitle( "Jan4", "oJan4", "Conversa 4 - JANELA LIVRE" , "LINHA1" )
		EndIf

	Else
		If cTpOper == "01" .and. !Empty(cConversa)
			cAliasSZM	:= Self:SetTrbSZM()

			While (cAliasSZM)->(!Eof())
				SZM->(DbGoto((cAliasSZM)->SZMREC))
				If Alltrim(Self:aJanID[Self:nJanAtual,1]) == Alltrim(SZM->ZM_SESSAO)
					If !"****ENCERRAMENTO****" $ SZM->ZM_MEN
						If lEnviaCliente
							lEnviaMen := Self:EnviaMensagem(cConversa,Alltrim(Self:aJanID[Self:nJanAtual,1]))
						Else
							lEnviaMen := .T.
						EndIf

						IF lEnviaMen
							Self:aJanID[Self:nJanAtual][2] := seconds()

							cConversa := CRLF+Upper(Self:_nomeOper)+ " [" + Time() + "] " + Alltrim(cConversa)+CRLF

							SZM->(Reclock("SZM"))
							SZM->ZM_MEN :=  SZM->ZM_MEN + Alltrim (cConversa)
							SZM->(MsUnlock())

							If Self:lGlbVarChat
								Do case

								case Self:nJanAtual == 1

									Self:nTimeSeg1 := 0
									Self:nTimeMin1 := 0
									Self:nTimeHor1 := 0

									Self:cTimeUltConv1 := Time()

									Self:lCro1 := .T.

									Self:oMeterJan1:SetTotal(Self:nInativBar)
									Self:nMeterJan1 := 0
									Self:oMeterJan1:Set(Self:nMeterJan1)
									Self:oMeterJan1:Refresh()

									Self:oVariav1:Refresh()
									Self:cVariav1 := ""
									Self:oVariav1:Refresh()

								case Self:nJanAtual == 2

									Self:nTimeSeg2 := 0
									Self:nTimeMin2 := 0
									Self:nTimeHor2 := 0

									Self:cTimeUltConv2 := Time()

									Self:lCro2 := .T.

									Self:oMeterJan2:SetTotal(Self:nInativBar)
									Self:nMeterJan2 := 0
									Self:oMeterJan2:Set(Self:nMeterJan2)
									Self:oMeterJan2:Refresh()

									Self:oVariav2:Refresh()
									Self:cVariav2 := ""
									Self:oVariav2:refresh()

								case Self:nJanAtual == 3

									Self:nTimeSeg3 := 0
									Self:nTimeMin3 := 0
									Self:nTimeHor3 := 0

									Self:cTimeUltConv3 := Time()

									Self:lCro3 := .T.

									Self:oMeterJan3:SetTotal(Self:nInativBar)
									Self:nMeterJan3 := 0
									Self:oMeterJan3:Set(Self:nMeterJan3)
									Self:oMeterJan3:Refresh()

									Self:oVariav3:Refresh()
									Self:cVariav3 := ""
									Self:oVariav3:refresh()
								case Self:nJanAtual == 4

									Self:nTimeSeg4 := 0
									Self:nTimeMin4 := 0
									Self:nTimeHor4 := 0

									Self:cTimeUltConv4 := Time()

									Self:lCro4 := .T.

									Self:oMeterJan4:SetTotal(Self:nInativBar)
									Self:nMeterJan4 := 0
									Self:oMeterJan4:Set(Self:nMeterJan4)
									Self:oMeterJan4:Refresh()

									Self:oVariav4:Refresh()
									Self:cVariav4 := ""
									Self:oVariav4:refresh()
								Endcase
							Endif

							StartJob("U_CHAT2PLN",GetEnvServer(),.f.,'2',LogUserName(),Self:_cEmp,Self:_cFil,Self:cThread,Self:cCoduser,Self:_cGrupo,Self:cPin,Self:nJanAtual,Self:aJanID)
						Endif
					Else
						MsgInfo("Conversa "+Alltrim(Str(Self:nJanAtual))+" esta em processo de Encerramento. A mensagem não será enviada.")
					EndIf
				EndIf
				(cAliasSZM)->(DbSkip())
			Enddo
			(cAliasSZM)->(DbCloseArea())
		ElseIf cTpOper == "02" .and. !Empty(cSession)

			cAliasSZM := Self:SetTrbSZM(nil,.F.)

			BeginSql Alias cAliasSZM
				%noparser%
				SELECT
					R_E_C_N_O_ SZMREC
				FROM
					%Table:SZM%	SZM
				WHERE
					SZM.ZM_FILIAL = %XFilial:SZM% AND
					SZM.ZM_SESSAO = %Exp:Alltrim(cSession)% AND
					SZM.ZM_STATUS = 'OPEN' AND
					SZM.%NotDel%
			EndSql

			While (cAliasSZM)->(!Eof())
				SZM->(DbGoto((cAliasSZM)->SZMREC))

				lConRPC				:= .F.
				nTotRPC				:= 0
				cServer				:= Alltrim(SZM->ZM_SERVER)
				cEnvPorta			:= Alltrim(SZM->ZM_PORTA)
				cEnvThread			:= Alltrim(SZM->ZM_THREAD)
				Self:cUIDChatChave	:= cEnvThread

				oRpcSrv := TRpc():New( cEnvServer )

				Do While !lConRPC .And. nTotRPC <= 100
					lConRpc := oRpcSrv:Connect( AllTrim( cServer ), Val( cEnvPorta ), 5 )
					nTotRPC ++
				EndDo

				// Se nao obteve sucesso na conexao, grava log no servidor
				If ! lConRpc
					cRet 	:= "0"
					cMsgHelp:= "[CHAT] Erro de conexão RPC com o server " + cEnvServer + ;
							" server " + cServer + ;
							" porta "  + cEnvPorta  + ;
							" thread " + cEnvThread
					conout("[CTSDKCHAT] "+cMsgHelp)
					Help(,1,"CHATCON1",,cMsgHelp,1,0 )

				Else

					aUsers := oRpcSrv:CallProc( "GetUserInfoArray" )

	    			// Verifica retorno do GetUserInfoArray
	    			If Empty( aUsers )

	    				nTotUI := 0

						// Tenta 100 vezes obter a lista de usuarios no server
						Do While Empty( aUsers ) .And. nTotUI <= 100
							aUsers := oRpcSrv:CallProc('GetUserInfoArray')
							nTotUI ++
						EndDo

						// Se tentou mais de uma vez, grava log no servidor
						If ! Empty( aUsers )
							If nTotUI > 1
								cMsgHelp := "[CHAT] Conexão RPC realizada com " + AllTrim( Str( nTotUI ) ) + ;
														" tentativas no ambiente " + cEnvServer + ;
														" server " + cServer + ;
														" porta "  + cEnvPorta  + ;
														" thread " + cEnvThread
								conout("[CTSDKCHAT] "+cMsgHelp)
								Help(,1,"CHATCON2",,cMsgHelp,1,0 )
							EndIf
						Else
							cRet := "0"
							cMsgHelp := "[CHAT] Erro de conexão RPC com o server " + cEnvServer + ;
									" server " + cServer + ;
									" porta "  + cEnvPorta  + ;
									" thread " + cEnvThread
							conout("[CTSDKCHAT] "+cMsgHelp)
							Help(,1,"CHATCON3",,cMsgHelp,1,0 )
						EndIf

	    			Else

						nIndex := AScan( aUsers, { |x| x[ 3 ] == Val( cEnvThread ) } )

						// Se nao encontrou mais a thread do operador de chat no Protheus, grava informacao no log
						If nIndex < 1
							cRet := "0"
							cMsgHelp := "[CHAT] Não foi encontrada thread ambiente " + cEnvServer + ;
									" server " + cServer + ;
									" porta "  + cEnvPorta  + ;
									" thread " + cEnvThread
							conout("[CTSDKCHAT] "+cMsgHelp)
							Help(,1,"CHATCON4",,cMsgHelp,1,0 )
						ElseIf At( "CHAT ", aUsers[ nIndex, 11 ] ) <= 0
							cRet := "0"
							cMsgHelp := "[CHAT] Não foi encontrada thread de CHAT no ambiente " + cEnvServer + ;
									" server " + cServer + ;
									" porta "  + cEnvPorta  + ;
									" thread " + cEnvThread
							conout("[CTSDKCHAT] "+cMsgHelp)
							Help(,1,"CHATCON5",,cMsgHelp,1,0 )

						EndIf
					EndIf

				EndIf

				If !cRet $ "0,2"
					cNomeAux:= Alltrim(SZM->ZM_NOMECLI)
					For nI := 1 to 2
						nEspAt := At(" ",cNomeAux)
						If nEspAt > 0
							cNomeCli 	+= Alltrim(Left(cNomeAux,nEspAt))+" "
							cNomeAux	:= Alltrim(SubStr(cNomeAux,nEspAt))
							nEspAt := At(" ",cNomeAux)
							If nI =1 .and. Alltrim(Upper(Left(Alltrim(cNomeAux),nEspAt))) $ "DE/DOS/DA/DAS"
								cNomeCli += Alltrim(Left(Alltrim(cNomeAux),nEspAt))+" "
								cNomeAux	:= Alltrim(SubStr(cNomeAux,Len(Alltrim(Left(Alltrim(cNomeAux),3))+" ")))
							EndIf
						Else
							cNomeCli += cNomeAux
							If cNomeCli == cNomeAux
								cNomeAux :=  ""
							EndIf
						EndIf
					Next

					cRet := "1"

					cConversa := CRLF +Alltrim(cNomeCli) + " ["+Time()+"] " + cConversa+CRLF

					DbSelectArea("SZM")
					SZM->(DBGOTO((cAliasSZM)->SZMREC))
					SZM->(Reclock("SZM"))
						SZM->ZM_MEN := SZM->ZM_MEN + Alltrim(cConversa)
					SZM->(MsUnlock())

					If "****ENCERRAMENTO****" $ Alltrim(cConversa)
						aRet 	:= {}
						nWhile	:= 0

						SZM->(DBGOTO((cAliasSZM)->SZMREC))
						SZM->( Reclock( "SZM" ) )
							SZM->ZM_STATUS := "CLOSED"
						SZM->( MsUnlock() )

						If oRpcSrv:CallProc('VarGeta',Self:cUIDChatFimCli,Self:cUIDChatChave,@aRet)
							Self:aSessionFimCli := aClone(aRet)
						Endif

						While Len(Self:aSessionFimCli) > 0 .and. nWhile < 50
							Sleep(1000)
							aRet := {}

							If oRpcSrv:CallProc('VarGeta',Self:cUIDChatFimCli,Self:cUIDChatChave,@aRet)
								Self:aSessionFimCli := aClone(aRet)
							Endif

							nWhile++
							If nWhile == 50 .and. Len(Self:aSessionFimCli) > 0
								Exit
							EndIf
						EndDo

						If Len(Self:aSessionFimCli) = 0
							Self:SetSessioFim(cSession,'2')

							oRpcSrv:CallProc('VarSeta',Self:cUIDChatFimCli,Self:cUIDChatChave,Self:aSessionFimCli)
						EndIf
					EndIf
				EndIf

				oRpcSrv:Disconnect()
				FreeObj(oRpcSrv)
				oRpcSrv := nil
				(cAliasSZM)->(DbSkip())
			EndDo
			(cAliasSZM)->(DbCloseArea())

		ElseIf cTpOper == "05" .and.  MsgYesNo("Deseja realmente encerrar a conexão com a janela "+Alltrim(str(Self:nJanAtual)),"Atenção")
			cMenEnc	:= CRLF+ "[SISTEMA]" + "[" + Time() + "]"+ CRLF +"****ENCERRAMENTO****"+CRLF+" OPERADOR ENCERROU A CONVERSA ATRAVÉS DO SISTEMA "+CRLF

			Self:SetConversa(cMenEnc,"01",Self:nJanAtual)

			Self:aJanID[Self:nJanAtual,4] := "0"

			Self:EncerraConversa(Self:aJanID[Self:nJanAtual,1],Self:aJanID[1,4],"","")

			Self:SetSessioFim(Self:aJanID[Self:nJanAtual,1])

			If Self:nJanAtual = 1
				Self:lCro1 := .F.
			ElseIf Self:nJanAtual = 2
				Self:lCro2 := .F.
			ElseIf Self:nJanAtual = 3
				Self:lCro3 := .F.
			ElseIf Self:nJanAtual = 4
				Self:lCro4 := .F.
			EndIf

		Endif

		Self:nJanAtual := nJanAux

	Endif

Return(cRet)

Method EncerraConversa(cSession,cMotivo,cEnviaEmail,cConversa) CLASS CtSdkChat
	Local cAliasSZM		:= ""
	Local oSvc			:= nil
	Local lOk			:= .F.
	Local cSvcError   	:= nil
	Local cSoapFCode  	:= nil
	Local cSoapFDescr	:= nil
	Local lEncerra		:= .F.

	Default cMotivo		:= "0"
	Default cEnviaEmail	:= ""
	Default cConversa	:= ""
    
    //Renato Ruy - 31/10/2016
    //Não encerrar a conversa em duplicidade.
    If Self:nJanAtual == 1
    	lEncerra := Self:lCro1
    Elseif Self:nJanAtual == 2
    	lEncerra := Self:lCro2
    Elseif Self:nJanAtual == 3
    	lEncerra := Self:lCro3
    Elseif Self:nJanAtual == 4
    	lEncerra := Self:lCro4
    Endif
    
    
	If lEncerra .Or. Self:nMeterJan1 >= Self:nInativ
		oSvc	:= WSChatProviderService():New()
		lOk		:= oSvc:encerraConversa(Alltrim(cSession),Self:_cGrupo,cMotivo)


		If !lOk
			cSvcError   := GetWSCError()		// Resumo do erro
			cSoapFCode  := GetWSCError(2)		// Soap Fault Code
			cSoapFDescr := GetWSCError(3)		// Soap Fault Description
	
			If !empty(cSoapFCode)
				Conout("[CTSDKCHAT] "+cSoapFDescr+CRLF+cSoapFCode)
			Else
				// Caso a ocorrência não tenha o soap_code preenchido
				// Ela está relacionada a uma outra falha ,
				// provavelmente local ou interna.
				conout('[CTSDKCHAT] FALHA INTERNA DE EXECUCAO DO SERVIÇO'+CRLF+cSvcError)
			Endif
		ElseIf "code>0</" $ oSvc:cReturn
			conout('[CTSDKCHAT] Inconsistencia ao realizar encerramento da Conversa'+CRLF+oSvc:cReturn)
		Endif
	
		DelClassIntF()
	
		FreeObj(oSvc)
		oSvc := nil
	Endif
	
Return

Method LiberaOperador(cSession,cEnviaEmail,cConversa) CLASS CtSdkChat

	Local cAliasSZM 	:= Self:SetTrbSZM(nil,.F.)
	Local cCodOP		:= ""
	Local oXml			:= nil
	Local cCorpo		:= ""
	Local cAssunto		:= ""
	Local cDestino		:= ""

	Default cConversa	:= ""

	BeginSql Alias cAliasSZM
		%noparser%
		SELECT
			R_E_C_N_O_ SZMREC
		FROM
			%Table:SZM% SZM
		WHERE
			ZM_FILIAL = %Exp:xFilial("SZM")% AND
			ZM_SESSAO = %Exp:Alltrim(cSession)%	AND
			ZM_PIN = %Exp:Alltrim(Self:cPin)% AND
			SZM.%NotDel%
	EndSql

	If (cAliasSZM)->(!Eof())
		SZM->(DbGoTo((cAliasSZM)->SZMREC))

		Reclock("SZM",.F.)
		SZM->ZM_STATUS := "CLOSED"
		SZM->(MsUnlock())

		If Empty(cEnviaEmail)
			cEnviaEmail := Alltrim(SZM->ZM_ENVMAIL)
		EndIf

		If cEnviaEmail == "1"
			oXml 	:= XmlParser(SZM->ZM_LOGIN,"_",@cAviso,@cErro)
			cCorpo	:= SZM->ZM_MEN
			cAssunto:= "Gravação Atendimento Chat Certisign"
			cDestino:=  Alltrim(oXml:_INICIACONVERSATYPE:_NS2_ITEMQUESTIONARIO[5]:_NS2_RESPOSTA:TEXT)
			MandEmail(cCorpo, cDestino, cAssunto)
			FreeObj(oXml)
			oXml := nil
		Endif

		Self:SetDisp(.F.)
	EndIf
	(cAliasSZM)->(DbCloseArea())

	DelClassIntf()
Return

Method SetSessioFim(cSession,cTip) CLASS CtSdkChat
	Local nPos := 0

	Default cTip := '1'

	If cTip ='1'

		nPos := Ascan(Self:aSessionFim, {|x| x =  cSession } )

		If nPos <= 0
			aadd(Self:aSessionFim,cSession)
		EndIf
	ElseIf cTip ='2'
		nPos := Ascan(Self:aSessionFimCli, {|x| x =  cSession } )

		If nPos <= 0
			aadd(Self:aSessionFimCli,cSession)
		EndIf

	EndIf
Return

Method DelSessioFim(cSession,cTip) CLASS CtSdkChat
	Local nPos := 0

	Default cTip := '1'

	If cTip ='1'
		nPos := Ascan(Self:aSessionFim, {|x| x =  cSession } )

		If nPos > 0
			aDel(Self:aSessionFim,nPos)
			aSize(Self:aSessionFim,Len(Self:aSessionFim)-1)
		EndIf
	ElseIf cTip = '2'
		nPos := Ascan(Self:aSessionFimCli, {|x| x =  cSession } )

		If nPos > 0
			aDel(Self:aSessionFimCli,nPos)
			aSize(Self:aSessionFimCli,Len(Self:aSessionFimCli)-1)
		EndIf
	EndIf
Return

Method AtuChatFim(lForca,cTip) CLASS CtSdkChat
	Local lRet := .F.

	Default lForca	:= .t.
	Default cTip	:= "1"

	If cTip = '1'
		lRet := VarSetA( Self:cUIDChatFim, Self:cUIDChatChave, Self:aSessionFim )
		If lForca .And. !lRet
			While !VarSetA( Self:cUIDChatFim, Self:cUIDChatChave, Self:aSessionFim )
				Sleep(500)
			EndDo
			lRet := .t.
		EndIf
	ElseIf cTip = '2'
		lRet := VarSetA( Self:cUIDChatFimCli, Self:cUIDChatChave, Self:aSessionFimCli )
		If lForca .And. !lRet
			While !VarSetA( Self:cUIDChatFimCli, Self:cUIDChatChave, Self:aSessionFimCli )
				Sleep(500)
			EndDo
			lRet := .t.
		EndIf
	EndIf

Return(lRet)

Method SetSessioInicio(cSession) CLASS CtSdkChat

	Self:cSessionInicio := cSession

Return

Method DelSessioInicio(cSession) CLASS CtSdkChat

	Self:cSessionInicio := ""

Return

Method AtuChatInicia(lForca) CLASS CtSdkChat
	Local lRet := VarSetX( Self:cUIDChatInicia, Self:cUIDChatChave, Self:cSessionInicio )

	Default lForca	:= .t.

	If lForca .And. !lRet
		While !VarSetX( Self:cUIDChatInicia, Self:cUIDChatChave, Self:cSessionInicio )
			Sleep(500)
		EndDo
		lRet := .t.
	EndIf

Return(lRet)

Method IniciaConversa(lForca,lCriaAtd,lAtuGlg) CLASS CtSdkChat
	Local nI	:= 0
	Local cRet	:= ""
	Local lRet	:= .T.
	Local aPos	:= ""
	Local cUser := ""
	Local aLista:= {}
	Local nJan	:= Ascan(Self:aJanID,{|x| Empty(x[1])})

	Default lForca	:= .t.
	Default lCriaAtd:= .t.
	Default lAtuGlg := .t.
	
	//Renato Ruy - 28/10/16
	//Tratamento para distribuir a fila para o usuario com menor número de atendimento.
	
	If Select("TMPFILA") > 0
		DbSelectArea("TMPFILA")
		TMPFILA->(DbCloseArea())
	Endif
	
	Beginsql Alias "TMPFILA"
		Select ZN_CODOP from %Table:SZN% SZN
		Where
		ZN_FILIAL = %xFilial:SZN% AND
		ZN_GRUPO = %Exp:Self:_cGrupo% AND
		ZN_PAUSA = 0 AND
		SZN.%Notdel%            
		Order by ZN_DISP Desc
	Endsql
	
	//Não inicia conversa se nao e o proximo da fila
	If Self:cCodUser == TMPFILA->ZN_CODOP
		lRet := nJan > 0 .and. Self:CapturaConversa()
	Else
		lRet := .F.
	Endif

	If lRet
		If !Empty(Self:cSessionInicio)
			If 	Self:IniciaJanelaChat(Self:cSessionInicio,lCriaAtd)

				Self:cSessionInicio := ""

			EndIf
		Endif
		If lAtuGlg
			Self:AtuChatInicia()
		Endif
	EndIf
Return(lRet)

Method CapturaConversa() CLASS CtSdkChat
	Local lRet := .F.
	Local aRet := {}

	If Self:nPausa == 0
		
		If Self:lConWs
		    
			aRet := Self:oRpcWs:CallProc("u_GetChat",Self:_cGrupo,Self:nTimeOutIpcWait)
			
			If valtype(aRet) == "A" .and. aRet[1] == 1
				lRet := Self:DistribuiConversa(aRet[2])
			Endif
		Else
			conout("[CTSDKCHAT]  Não foi possível conectar ao Ws de distribuição de conversa:"+CRLF+"Server: "+Self:cWSServer+CRLF+"Porta: "+Self:cWSPort+CRLF+"Ambiente: "+GetEnvServer())
		EndIf
	EndIf
Return(lRet)

Method FimConversa(lForca,lAtuGlb,lEncerra,lForcaEncerra) CLASS CtSdkChat
	Local nI				:= 1
	Local nPosFila 			:= 0
	Local aRet				:= {}
	Local lRet				:= .F.

	Default lForca			:= .T.
	Default lAtuGlb			:= .T.
	Default lEncerra		:= .T.
	Default lForcaEncerra	:= .F.

	lRet				:= VarGetA( Self:cUIDChatFim, Self:cUIDChatChave, @aRet )
	If lForca .and. !lRet
		While !VarGetA( Self:cUIDChatFim, Self:cUIDChatChave, @aRet )
			Sleep(500)
		EndDo
		lRet := .T.
	EndIf

	If lRet .and. Len(aRet) > 0
		For nI:=1 to Len(aRet)
			Self:SetSessioFim(aRet[nI])
		Next
Endif

	If Len(Self:aSessionFim) > 0
		nI := 1
		While nI <=  Len(Self:aSessionFim)

			If Empty(Self:aSessionFim[nI]) .or. Self:ProcessaFimConversa(Self:aSessionFim[nI],lEncerra,lForcaEncerra)
				Self:DelSessioFim(Self:aSessionFim[nI])
				nI--
			EndIf

			nI++
		EndDo

		If lAtuGlb
			Self:AtuChatFim()
		EndIf
	Endif

	aRet 	:= {}
	lRet	:= VarGetA( Self:cUIDChatFimCli, Self:cUIDChatChave, @aRet )
	If lForca .and. !lRet
		While !VarGetA( Self:cUIDChatFimCli, Self:cUIDChatChave, @aRet )
			Sleep(500)
		EndDo
		lRet := .T.
	EndIf

	If lRet .and. Len(aRet) > 0
		For nI:=1 to Len(aRet)
			Self:SetSessioFimCli(aRet[nI],'2')
		Next
	Endif

	If Len(Self:aSessionFimCli) > 0
		nI := 1
		While nI <=  Len(Self:aSessionFimCli)

			If Empty(Self:aSessionFimCli[nI]) .or. Self:ProcessaFimConversa(Self:aSessionFimCli[nI],lEncerra,lForcaEncerra,'2')
				Self:DelSessioFim(Self:aSessionFimCli[nI],'2')
				nI--
			EndIf

			nI++
		EndDo

		If lAtuGlb
			Self:AtuChatFim(nil,'2')
		EndIf
	Endif

Return(lRet)

Method ProcessaFimConversa(cSession,lEncerra,lForcaEncerra,cTip)  CLASS CtSdkChat
	Local nPosFila 			:= Ascan(Self:aJanID,{|x| x[1] == cSession })
	Local lRet				:= .F.
	Local lTimeOut			:= .F.

	Default lEncerra		:= .T.
	Default lForcaEncerra	:= .F.
	Default cTip			:= '1'

	If 	!Empty(cSession) .and. nPosFila > 0
		If nPosFila = 1
			Self:lCro1 := .F.

			If Empty(Self:cTimeEnc1)
				Self:cTimeEnc1 := Time()
			EndIf

			lTimeOut := ElapTime( Self:cTimeEnc1, Time() ) > Self:cTimeOutJan

			If (lTimeOut .and. lEncerra) .or. lForcaEncerra
				If Self:aJanID[1,4] <> "0"
					Self:EncerraConversa(Self:aJanID[1,1],Self:aJanID[1,4],"","")
				EndIf
				Self:LiberaOperador(Self:aJanID[1,1],'')

				StartJob("U_CHAT2PLN",GetEnvServer(),.f.,'2',LogUserName(),Self:_cEmp,Self:_cFil,Self:cThread,Self:cCoduser,Self:_cGrupo,Self:cPin,1,Self:aJanID)

				Self:aJanID[1,1]:= ""
				Self:aJanID[1,2]:= 0
				Self:aJanID[1,3]:= ""
				Self:aJanID[1,4]:= ""

				Self:cTimeUltConv1 := ""

				lRet:= .T.
			Endif

			If lTimeOut
				Self:cTimeEnc1 := ""

				If Self:lGlbVarChat
					Self:oLayer:setWinTitle( "Jan1", "oJan1", "Conversa 1 - JANELA LIVRE" , "LINHA1" )
					Self:SetSessioFim(Self:aJanID[1,1],cTip)
					Self:oFormuld1:Navigate("about:blank")
				EndIf

			EndIf
		ElseIf nPosFila = 2
			Self:lCro2 := .F.

			If Empty(Self:cTimeEnc2)
				Self:cTimeEnc2 := Time()
			EndIf

			lTimeOut := ElapTime( Self:cTimeEnc2, Time() ) > Self:cTimeOutJan

			If (lTimeOut .and. lEncerra) .or. lForcaEncerra
				If Self:aJanID[2,4] <> "0"
					Self:EncerraConversa(Self:aJanID[2,1],Self:aJanID[2,4],"","")
				EndIf
				Self:LiberaOperador(Self:aJanID[2,1],'')

				StartJob("U_CHAT2PLN",GetEnvServer(),.f.,'2',LogUserName(),Self:_cEmp,Self:_cFil,Self:cThread,Self:cCoduser,Self:_cGrupo,Self:cPin,2,Self:aJanID)

				Self:aJanID[2,1]:= ""
				Self:aJanID[2,2]:= 0
				Self:aJanID[2,3]:= ""
				Self:aJanID[2,4]:= ""

				Self:cTimeUltConv2 := ""

				lRet:= .T.
			Endif

			If lTimeOut
				Self:cTimeEnc2 := ""

				If Self:lGlbVarChat
					Self:oLayer:setWinTitle( "Jan2", "oJan2", "Conversa 2 - JANELA LIVRE" , "LINHA1" )
					Self:SetSessioFim(Self:aJanID[2,1],cTip)
					Self:oFormuld2:Navigate("about:blank")
				EndIf
			EndIf
		ElseIf nPosFila = 3
			Self:lCro3 := .F.

			If Empty(Self:cTimeEnc3)
				Self:cTimeEnc3 := Time()
			EndIf

			lTimeOut := ElapTime( Self:cTimeEnc3, Time() ) > Self:cTimeOutJan

			If (lTimeOut .and. lEncerra) .or. lForcaEncerra
				If Self:aJanID[3,4] <> "0"
					Self:EncerraConversa(Self:aJanID[3,1],Self:aJanID[3,4],"","")
				EndIf
				Self:LiberaOperador(Self:aJanID[3,1],'')

				StartJob("U_CHAT2PLN",GetEnvServer(),.f.,'2',LogUserName(),Self:_cEmp,Self:_cFil,Self:cThread,Self:cCoduser,Self:_cGrupo,Self:cPin,3,Self:aJanID)

				Self:aJanID[3,1]:= ""
				Self:aJanID[3,2]:= 0
				Self:aJanID[3,3]:= ""
				Self:aJanID[3,4]:= ""

				Self:cTimeUltConv3 := ""

				lRet:= .T.
			Endif

			If lTimeOut
				Self:cTimeEnc3 := ""

				If Self:lGlbVarChat
					Self:oLayer:setWinTitle( "Jan3", "oJan3", "Conversa 3 - JANELA LIVRE" , "LINHA1" )
					Self:SetSessioFim(Self:aJanID[3,1],cTip)
					Self:oFormuld3:Navigate("about:blank")
				EndIf
			EndIf
		ElseIf nPosFila = 4
			Self:lCro4 := .F.

			If Empty(Self:cTimeEnc4)
				Self:cTimeEnc4 := Time()
			EndIf

			lTimeOut := ElapTime( Self:cTimeEnc4, Time() ) > Self:cTimeOutJan

			If (lTimeOut .and. lEncerra) .or. lForcaEncerra
				If Self:aJanID[4,4] <> "0"
					Self:EncerraConversa(Self:aJanID[4,1],Self:aJanID[4,4],"","")
				EndIf
				Self:LiberaOperador(Self:aJanID[4,1],'')

				StartJob("U_CHAT2PLN",GetEnvServer(),.f.,'2',LogUserName(),Self:_cEmp,Self:_cFil,Self:cThread,Self:cCoduser,Self:_cGrupo,Self:cPin,4,Self:aJanID)

				Self:aJanID[4,1]:= ""
				Self:aJanID[4,2]:= 0
				Self:aJanID[4,3]:= ""
				Self:aJanID[4,4]:= ""

				Self:cTimeUltConv4 := ""

				lRet:= .T.
			Endif

			If lTimeOut
				Self:cTimeEnc4 := ""

				If Self:lGlbVarChat
					Self:oLayer:setWinTitle( "Jan4", "oJan4", "Conversa 4 - JANELA LIVRE" , "LINHA1" )
					Self:SetSessioFim(Self:aJanID[4,1],cTip)
					Self:oFormuld4:Navigate("about:blank")
				EndIf
			EndIf
		EndIf

		DelClassIntf()
	Else
		lRet := .F.
	EndIf
Return(lRet)

Method AtualizaConversa() CLASS CtSdkChat
	Local nPos	:= 0
	Local nSec1 := Seconds()
	
	If valtype(Self:oRpcWs) == "U"
		Self:oRpcWs :=  TRPC():New(GetEnvServer())
		Self:lConWs := Self:oRpcWs:Connect(Self:cWSServer,val(Self:cWSPort),1)
	EndIf
	
	Self:oTimerCro:DeActivate()

	If Self:nPausa == 1
		Self:SetPausa(.F.)
	EndIf

	Self:IniciaConversa(.F.,.F.,.T.)

	Self:FimConversa(.F.,.T.,.T.,.F.)

	Self:AtualizaTempoConversa()

	If !Self:lCro1 .and. Len(Self:aJanID) >=1
		Self:oMeterJan1:Set(0)
		Self:oMeterJan1:Refresh()
	Endif

	If !Self:lCro2 .and. Len(Self:aJanID) >=2
		Self:oMeterJan2:Set(0)
		Self:oMeterJan2:Refresh()
	Endif

	If !Self:lCro3 .and. Len(Self:aJanID) >=3
		Self:oMeterJan3:Set(0)
		Self:oMeterJan3:Refresh()
	Endif

	If !Self:lCro4 .and. Len(Self:aJanID) >=4
		Self:oMeterJan4:Set(0)
		Self:oMeterJan4:Refresh()
	Endif

	Self:GetTamanhoFila()

	If Self:lEncerraJanela
		Self:EncerraJanela(.f., .f.)
	Endif

	Self:oTimerCro:Activate()

Return

Method EnviaMensagem(cConversa,cSession) CLASS CtSdkChat
	Local lRet			:= .T. 
	Local nTentativa	:= 0
	Local oSvc			:= WSChatProviderService():New() // ChatProvider
	Local lEncerra		:= .F.
	Local cSvcError		:= ""		// Resumo do erro
	Local cSoapFCode  	:= ""		// Soap Fault Code
	Local cSoapFDescr 	:= ""		// Soap Fault Description
	Local cMenEnc		:= ""
	Local cQuebra		:= ""
	Local nLin			:= 0
	Local i				:= 0
	
	If Len(cConversa) > 66
		//Conta quantidade de linhas
		nLin := mlcount(cConversa,67)
	 	//Cria uma string formatada
	    For i := 1 to nLin
	        cQuebra += memoline(cConversa,66,i)+CRLF
	    Next
	    cConversa := cQuebra
	    
	 EndIf	

	lRet		:= oSvc:enviaMensagem(cSession,Alltrim(Self:_nomeuser),cConversa) // Verifica se a mensagem foi enviada
    
	If !lRet
		cSvcError   := GetWSCError()		// Resumo do erro
		cSoapFCode  := GetWSCError(2)		// Soap Fault Code
		cSoapFDescr := GetWSCError(3)		// Soap Fault Description

		If !empty(cSoapFCode)
	// Caso a ocorrência de erro esteja com o fault_code preenchido ,
	// a mesma teve relação com a chamada do serviço .
			CONOUT("[CTSDKCHAT] "+cSoapFDescr+CRLF+cSoapFCode)
		Else
	// Caso a ocorrência não tenha o soap_code preenchido
	// Ela está relacionada a uma outra falha ,
	// provavelmente local ou interna.
			CONOUT('[CTSDKCHAT] FALHA INTERNA DE EXECUCAO DO SERVIÇO'+CRLF+cSvcError)
		Endif
		lEncerra := .t.
	ElseIf "code>0</" $ oSvc:cReturn
		lEncerra 	:= .T.
		lRet		:= .F.
	Endif

	If lEncerra
		cMenEnc	:= CRLF+ "[SISTEMA]" + "[" + Time() + "]"+CRLF +" ****ENCERRAMENTO****"+CRLF+" A CONVERSA FOI ENCERRADA DEVIDO A QUEDA/FINALIZAÇÃO VOLUNTARIA DA SESSÃO DO CLIENTE NO PORTAL "+CRLF

		Self:SetConversa(cMenEnc, "02", 0, cSession)

		Self:SetSessioFim(cSession)

	EndIf

	FreeObj(oSvc)
	oSvc := nil
Return(lRet)

Method AtualizaTempoConversa() CLASS CtSdkChat
	Local nSeg	:= 0
	Local nMin	:= 0
	Local nHor	:= 0

	If Self:lCro1

		Self:oLayer:setWinTitle( "Jan1", "oJan1", "Conversa 1 - ESPERA: "+ElapTime(Self:cTimeUltConv1,Time())+" TOTAL: "+ElapTime(Self:cTimeJan1,Time()) , "LINHA1" )

		Self:nMeterJan1 := seconds() - Self:aJanID[1][2]
		Self:oMeterJan1:Set(Self:nMeterJan1)
		Self:oMeterJan1:Refresh()
		Self:NotificaConversa("1")

		IF Self:nMeterJan1 >= Self:nInativ
			cMenEnc	:= CRLF+ "[SISTEMA]" + "[" + Time() + "]"+ CRLF +" ****ENCERRAMENTO****"+CRLF+" A CONVERSA FOI ENCERRADA POR INATIVIDADE "+CRLF
			Self:SetConversa(cMenEnc,"01",1)
			Self:aJanID[1,4] 	:= "1"
			Self:SetSessioFim(Self:aJanID[1,1])
			Self:cTimeUltConv1 	:= ""
			Self:aJanID[1,2]	:= 0
		EndIf
	Endif

	If Self:lCro2

		Self:oLayer:setWinTitle( "Jan2", "oJan2", "Conversa 2 - ESPERA: "+ElapTime(Self:cTimeUltConv2,Time())+" TOTAL: "+ElapTime(Self:cTimeJan2,Time()) , "LINHA1" )

		Self:nMeterJan2:= seconds() - Self:aJanID[2][2]
		Self:oMeterJan2:Set(Self:nMeterJan2)
		Self:oMeterJan2:Refresh()
		Self:NotificaConversa("2")

		IF Self:nMeterJan2 >= Self:nInativ
			cMenEnc	:= CRLF+ "[SISTEMA]" + "[" + Time() + "]"+ CRLF +" ****ENCERRAMENTO****"+CRLF+" A CONVERSA FOI ENCERRADA POR INATIVIDADE "+CRLF
			Self:SetConversa(cMenEnc,"01",2)
			Self:aJanID[2,4] := "1"
			Self:SetSessioFim(Self:aJanID[2,1])
			Self:cTimeUltConv2	:= ""
		EndIf
	Endif

	If Self:lCro3

		Self:oLayer:setWinTitle( "Jan3", "oJan3", "Conversa 3 - ESPERA: "+ElapTime(Self:cTimeUltConv3,Time())+" TOTAL: "+ElapTime(Self:cTimeJan3,Time()) , "LINHA1" )

		Self:nMeterJan3:= seconds() - Self:aJanID[3][2]
		Self:oMeterJan3:Set(Self:nMeterJan3)
		Self:oMeterJan3:Refresh()
		Self:NotificaConversa("3")

		IF Self:nMeterJan3 >= Self:nInativ
			cMenEnc	:= CRLF+ "[SISTEMA]" + "[" + Time() + "]"+ CRLF +" ****ENCERRAMENTO****"+CRLF+" A CONVERSA FOI ENCERRADA POR INATIVIDADE "+CRLF
			Self:SetConversa(cMenEnc,"01",3)
			Self:aJanID[3,4] := "1"
			Self:SetSessioFim(Self:aJanID[3,1])
			Self:cTimeUltConv3 := ""
		EndIf
	Endif

	If Self:lCro4

		Self:oLayer:setWinTitle( "Jan4", "oJan4", "Conversa 4 - ESPERA: "+ElapTime(Self:cTimeUltConv4,Time())+" TOTAL: "+ElapTime(Self:cTimeJan4,Time()) , "LINHA1" )

		Self:nMeterJan4:= seconds() - Self:aJanID[4][2]
		Self:oMeterJan4:Set(Self:nMeterJan4)
		Self:oMeterJan4:Refresh()
		Self:NotificaConversa("4")
		
		IF Self:nMeterJan4 >= Self:nInativ
			cMenEnc	:= CRLF+ "[SISTEMA]" + "[" + Time() + "]"+ CRLF +" ****ENCERRAMENTO****"+CRLF+" A CONVERSA FOI ENCERRADA POR INATIVIDADE "+CRLF
			Self:SetConversa(cMenEnc,"01",4)
			Self:aJanID[4,4] := "1"
			Self:SetSessioFim(Self:aJanID[4,1])
			Self:cTimeUltConv4 := ""
		EndIf
	Endif

Return

Method NotificaConversa(nJan) CLASS CtSdkChat
	Local	aArea		:= SZM->(GetArea())
	Local	cConversa	:= ""
	
	Default nJan		:= ""
	
	//Renato Ruy - 10/11/2016
	//Se posiciona para buscar informacao.
	SZM->(DbSetOrder(6)) //Filial + Sessao + Status
	If SZM->(DbSeek(xFilial("SZM")+PadR(Self:AJANID[Val(nJan),1],50," ")+"OPEN"))
	        
		//Armazena informação anterior visualizada pelo atendente.
		If ValType(Self:aConversa) == "U"
			Self:aConversa := Array(4)
			Self:aConversa[1]:= space(20)
			Self:aConversa[2]:= space(20)
			Self:aConversa[3]:= space(20)
			Self:aConversa[4]:= space(20)
		Elseif Self:ChatFocus .Or. Self:oTela:hasFocus()
			Self:aConversa[Val(nJan)] := SZM->ZM_MEN
		Endif
		
		SZM->(Reclock("SZM",.F.))
			SZM->ZM_MEN += ""
		SZM->(MsUnlock())
		
		cConversa := SZM->ZM_MEN	
		
		//Verifica se está ativo, se não esta envia mensagem e marca para não notificar varias vezes.
		If right(cConversa,20) != right(Self:aConversa[Val(nJan)],20) .And. !"**"+nJan $ Self:oTela:cTitle .And.;
		   (!Self:ChatFocus .or. Self:oTela:windowState() == 1 .or. !Self:oTela:hasFocus())
			Self:AlertChat(1, 'Nova mensagem recebida na janela: '+nJan)
			Self:oTela:cTitle := Self:oTela:cTitle+"**"+nJan
		
		//Desmarca o conteudo para caso exista alteracao enviar.
		Elseif Self:ChatFocus .Or. Self:oTela:hasFocus()
			Self:oTela:cTitle := Strtran(Strtran(Strtran(Self:oTela:cTitle,"**1"),"**2"),"**3")
		//Se contem o encerramento no texto, finaliza conversa.
		Elseif "*** CONVERSA ENCERRADA PELO CLIENTE ***" $ SZM->ZM_MEN
			Self:EncerraConversa(Alltrim(SZM->ZM_SESSAO),"0","","")		
		EndIf
	
	Endif
	
	RestArea(aArea)
	
Return

Method GetTamanhoFila() CLASS CtSdkChat

	Local cFila := MemoRead("FILACHAT"+Self:_cGrupo)
	Self:oSay:cCaption := cFila+" Clientes na Fila para Atendimento"
	Self:oSay:Refresh()
	/*  
	//Renato Ruy - 03/10/2016
	//Buscar no webservice o numero correto da fila.
	Local cFila 	:= ""
	Local lOk	 	:= .F.
	Local oConFila
	
	If !Empty(Self:_cGrupo)
		oConFila		:= WSChatProviderService():New() // ChatProvider
		oConFila:cGrupo := Self:_cGrupo
		lOk		:= oConFila:tamanhoFila(Self:_cGrupo) // Verifica se a mensagem foi enviada
	
		If lOk
			cFila := Alltrim(oConFila:cReturn)
		Else
			cFila := "0"
		EndIf
	
		If Alltrim(Self:oSay:cCaption) <> Alltrim(cFila+" Clientes na Fila")
			Self:oSay:cCaption := 	cFila+" Clientes na Fila para Atendimento"
			Self:oSay:Refresh()
		EndIf
	
		FreeObj(oConFila)
	EndIf

	DelClassIntf()
	*/
Return(cFila)

Method SetTamanhoFila() CLASS CtSdkChat

	Local oSvc	:= WSChatProviderService():New() // ChatProvider
	Local cQtd	:= "0"
	Local lOk	:= .F.

	oSvc:cGrupo := Self:_cGrupo
	lOk			:= oSvc:tamanhoFila(Self:_cGrupo) // Verifica se a mensagem foi enviada

	If lOk
		cQtd := Alltrim(oSvc:cReturn)
	Endif

	MemoWrite("FILACHAT"+Self:_cGrupo,cQtd)

	FreeObj(oSvc)
	oSvc := nil
Return(cQtd)

Method DistribuiConversa(cXml) CLASS CtSdkChat
	Local lRet 		:= .T.
	Local cAviso	:= ""
	Local cErro		:= ""
	Local cPergCli	:= ""
	Local nI		:= 0
	Local cEnvServer:= GetEnvServer()
	Local oXml 		:= XmlParser(cXml,"_",@cAviso,@cErro)
	Local cUltOper	:= ""
	Local cRet		:= ""
	Local aRet		:= {}
	Local cXml		:= ""
	Local cPergCli	:= ""
	Local cSession	:= ""

	If !Empty(cAviso)
		Help(,1,"CHATFILA1",,"Aviso distribuição de fila "+cAviso,1,0 )
		lRet := .F.
	EndIf

	If !Empty(cErro)
		Help(,1,"CHATFILA2",,"Erro distribuição de fila "+cErro,1,0 )
		lRet := .F.
	EndIf

	If lRet

		Self:_cGrupo := Alltrim(oXml:_INICIACONVERSATYPE:_NS2_IDGRUPO:TEXT)
		cPergCli := "       Questionário da Conversa"+chr(13)+chr(10)

		For nI:=1 to Len(oXml:_INICIACONVERSATYPE:_NS2_ITEMQUESTIONARIO)
			cPergCli += "["+alltrim(oXml:_INICIACONVERSATYPE:_NS2_ITEMQUESTIONARIO[nI]:_NS2_PERGUNTA:TEXT)+"] - "+Alltrim(oXml:_INICIACONVERSATYPE:_NS2_ITEMQUESTIONARIO[nI]:_NS2_RESPOSTA:TEXT)+chr(13)+chr(10)
		Next

		aRet := {}
		cSession := Alltrim(oXml:_INICIACONVERSATYPE:_NS2_IDCONVERSA:TEXT)

		DbSelectArea("SZN")
		SZN->(DbSetOrder(1))
		If SZN->(DbSeek(xFilial("SZN")+Padr(Self:cThread,TamSX3("ZN_THREAD")[1])+Self:cPin+Padr(Self:cIpServer,TamSX3("ZN_SERVER")[1])+Self:cPortServer))
			Reclock("SZN",.F.)
				SZN->ZN_DISP := SZN->ZN_DISP - 1
			SZN->(MsUnlock())
			SZN->(DbCommit())

			DbSelectArea("SZM")
			RecLock("SZM",.T.)
				SZM->ZM_THREAD	:= Self:cThread
				SZM->ZM_PIN 	:= Self:cPIN
				SZM->ZM_SESSAO	:= cSession
				SZM->ZM_MEN 	:= CRLF+ "[SISTEMA]" + CRLF + cPergCli
				SZM->ZM_LOGIN	:= Alltrim(cXml)
				SZM->ZM_STATUS	:= "OPEN"
				SZM->ZM_CNPJ	:= Alltrim(oXml:_INICIACONVERSATYPE:_NS2_ITEMQUESTIONARIO[2]:_NS2_RESPOSTA:TEXT)
				SZM->ZM_DATA	:= date()
				SZM->ZM_NOMECLI	:= Alltrim(oXml:_INICIACONVERSATYPE:_NS2_NOMECLIENTE:TEXT)
				SZM->ZM_GRUPO	:= Self:_cGrupo
				SZM->ZM_CODOP	:= Self:cCodUser
				SZM->ZM_NOMEOP	:= Self:_nomeuser
				SZM->ZM_SERVER	:= Self:cIpServer
				SZM->ZM_PORTA	:= Self:cPortServer
			SZM->(MsUnlock())
			SZM->(DbCommit())

			Self:SetSessioInicio(cSession)
		Else
			Self:EncerraConversa(Alltrim(cSession),"0","","")

			conout("[CHATFILA3] Conversa não foi encontrada "+xFilial("SZN")+Padr(Self:cThread,TamSX3("ZN_THREAD")[1])+Self:cPin+Padr(Self:cIpServer,TamSX3("ZN_SERVER")[1])+Self:cPortServer)
			lRet := .F.
		EndIf

	EndIf

	FreeObj(oXml)
	oXml := nil
Return(lRet)


Method Informadisponibilidade(cGrupo,lEnvDisp) CLASS CtSdkChat
	Local cAliasSU0	:= Self:SetTrbSZN(.F.)
	Local cAliasSZN	:= Self:SetTrbSZN(.F.)
	Local cAliasSZM	:= ""
	Local cEnvServer:= GetEnvServer()
	Local aGroup	:= {}
	Local _cc		:= 0
	Local nPos		:= 0
	Local cWhere	:= "%%"
	Local nQtdConv	:= 0
	Local oRpcSrv	:= nil
	Local nCount	:= 0
	Local nIndex	:= 0
	Local _cxmlenvio:= ""
	Local oSvc		:= nil
	Local lOk		:= .F.
	Local cUpdZK	:= ""

	Default cGrupo	:= ""
	Default	lEnvDisp:= .T.

	cSqlRet := ""
	cSqlRet += "SELECT "
	cSqlRet += "  SU0.U0_CODIGO "
	cSqlRet += "FROM "
	cSqlRet += "  "+RetSqlName("SU0")+" SU0  "
	cSqlRet += "WHERE "
	cSqlRet += "    U0_FILIAL = '"+xFilial("SU0")+"' AND "
	If !Empty(cGrupo)
		cSqlRet += "    U0_CODIGO = '"+cGrupo+"' AND "
	Endif
	cSqlRet += "    SU0.D_E_L_E_T_ = ' ' "

	TCQUERY cSqlRet NEW ALIAS cAliasSU0

	If cAliasSU0->(!Eof())
		While cAliasSU0->(!Eof())

			aGroup := {}

			AADD(aGroup,{Alltrim(cAliasSU0->U0_CODIGO),0})

			BeginSql Alias cAliasSZN
				%noparser%
				SELECT
				SZN.ZN_GRUPO,
				SZN.ZN_DISP,
				SZN.ZN_THREAD,
				SZN.ZN_PIN,
				SZN.ZN_SERVER,
				SZN.ZN_PORTA ,
				SZN.R_E_C_N_O_ SZNREC
				FROM
				%Table:SZN%	SZN
				WHERE
				SZN.ZN_FILIAL = %XFilial:SZN%	AND
				SZN.ZN_GRUPO = %Exp:Alltrim(cAliasSU0->U0_CODIGO)% AND
				SZN.%NotDel%
				ORDER BY SZN.ZN_DISP DESC
			EndSql

			While (cAliasSZN)->(!Eof())
				SZN->(DbGoTo((cAliasSZN)->SZNREC))

				Self:cThread		:= Alltrim(SZN->ZN_THREAD)
				Self:cPIN			:= Alltrim(SZN->ZN_PIN)
				Self:cIpServer		:= Alltrim(SZN->ZN_SERVER)
				Self:cPortServer	:= Alltrim(SZN->ZN_PORTA)
				Self:nPausa			:= Val(SZN->ZN_PAUSA)
				Self:_cGrupo		:= Alltrim(SZN->ZN_GRUPO)
				Self:cCodUser		:= Alltrim(SZN->ZN_CODOP)
				Self:_nJanOper		:= Val(Posicione("SU7",1,xFilial("SU7")+Self:cCodUser,"U7_XJCHAT"))
				Self:_nomeuser 		:= Alltrim(Posicione("SU7",1,xFilial("SU7")+Self:cCodUser,"U7_NOME"))
				Self:cUIDChatChave	:= Self:cThread

				oRpcSrv := TRpc():New(cEnvServer)
				If ( oRpcSrv:Connect( Self:cIpServer, Val(Self:cPortServer), 5 ) )

					aUsers := oRpcSrv:CallProc('GetUserInfoArray')

					nCount := Ascan(aUsers,{|x| x[3] == val(Self:cThread) })

					If nCount > 0
						nIndex := 1
					Else
						nIndex := 0
					EndIf

		    //thread já caiu, mas continua presa no banco
					IF nIndex < 1
						SZN->(Reclock("SZN"))
							SZN->ZN_LOGOUT := Alltrim(dtoc(date())+time())
							SZN->(DbDelete())
						SZN->(MsUnlock())

						DbSelectArea("SZM")
						SZM->(DbSetOrder(2))
						SZM->(MsSeek(xFilial("SZM")+(cAliasSZN)->ZN_THREAD+(cAliasSZN)->ZN_PIN+(cAliasSZN)->ZN_SERVER+(cAliasSZN)->ZN_PORTA))

						While SZM->(!EOF()) .AND. SZM->ZM_FILIAL == xFilial("SZM") .AND. SZM->ZM_THREAD == (cAliasSZN)->ZN_THREAD;
								.AND. SZM->ZM_PIN == (cAliasSZN)->ZN_PIN;
								.AND. SZM->ZM_SERVER == (cAliasSZN)->ZN_SERVER;
								.AND. SZM->ZM_PORTA == (cAliasSZN)->ZN_PORTA

							Self:EncerraConversa(Alltrim(SZM->ZM_SESSAO),"0","","")

							Self:LiberaOperador(Alltrim(SZM->ZM_SESSAO),'')

							oRpcSrv:CallProc('VarDel',Self:cUIDChatFim		,Self:cUIDChatChave)
							oRpcSrv:CallProc('VarDel',Self:cUIDChatInicia	,Self:cUIDChatChave)

							SZM->(DbSkip())
						Enddo
						
						cUpdZK := "UPDATE "+RetSqlName("SZK") 
						cUpdZK += " SET ZK_STATUS = '2', " 
						cUpdZK += " ZK_DTFIM = ZK_DTINI, "
						cUpdZK += " ZK_HRFIM = '"+SubStr(Time(),1,5)+"' " 
						cUpdZK += "WHERE "
						cUpdZK += " ZK_FILIAL =  '"+xFilial("SZK")+"' AND " 
						cUpdZK += " ZK_OPERADO = '"+Self:cCodUser+"' AND "
						cUpdZK += " ZK_DTINI = '"+DtoS(dDataBase)+"' AND "
						cUpdZK += " ZK_HRFIM = ' ' AND "
						cUpdZK += " ZK_DTFIM = ' ' AND "
						cUpdZK += " D_E_L_E_T_ = ' ' "
						
						TcSqlExec(cUpdZK)
						
			//thread executando, mas nao se encontra mais em chat
					ElseIF AT("CHAT ", aUsers[nCount][11]) < 1

						SZN->(Reclock("SZN"))
							SZN->ZN_LOGOUT := Alltrim(dtoc(date())+time())
							SZN->(DbDelete())
						SZN->(MsUnlock())

						DbSelectArea("SZM")
						SZM->(DbSetOrder(2))
						SZM->(MsSeek(xFilial("SZM")+(cAliasSZN)->ZN_THREAD+(cAliasSZN)->ZN_PIN))

						While SZM->(!EOF()) .AND. SZM->ZM_FILIAL == xFilial("SZM") .AND. SZM->ZM_THREAD == (cAliasSZN)->ZN_THREAD;
								.AND. SZM->ZM_PIN == (cAliasSZN)->ZN_PIN;
								.AND. SZM->ZM_SERVER == (cAliasSZN)->ZN_SERVER;
								.AND. SZM->ZM_PORTA == cAliasSZN->ZN_PORTA

							Self:EncerraConversa(Alltrim(SZM->ZM_SESSAO),"0","","")

							Self:LiberaOperador(Alltrim(SZM->ZM_SESSAO),'')

							oRpcSrv:CallProc('VarDel',Self:cUIDChatFim		,Self:cUIDChatChave)
							oRpcSrv:CallProc('VarDel',Self:cUIDChatInicia	,Self:cUIDChatChave)

							SZM->(DbSkip())
						Enddo
						
						cUpdZK := "UPDATE "+RetSqlName("SZK") 
						cUpdZK += " SET ZK_STATUS = '2', " 
						cUpdZK += " ZK_DTFIM = ZK_DTINI, "
						cUpdZK += " ZK_HRFIM = '"+SubStr(Time(),1,5)+"' " 
						cUpdZK += "WHERE "
						cUpdZK += " ZK_FILIAL =  '"+xFilial("SZK")+"' AND " 
						cUpdZK += " ZK_OPERADO = '"+Self:cCodUser+"' AND "
						cUpdZK += " ZK_DTINI = '"+DtoS(dDataBase)+"' AND "
						cUpdZK += " ZK_HRFIM = ' ' AND "
						cUpdZK += " ZK_DTFIM = ' ' AND "
						cUpdZK += " D_E_L_E_T_ = ' ' "
						
						TcSqlExec(cUpdZK)
						
					Else

						nCount := Ascan(aGroup, {|x| x[1] == Self:_cGrupo })
						If nCount > 0
							nQtdConv := 0

							cAliasSZM := Self:SetTrbSZM()

							(cAliasSZM)->( DbEval( {|| nQtdConv++ } ) )

							(cAliasSZM)->(DbCloseArea())

							aGroup[nCount][2] += Self:_nJanOper - nQtdConv
						EndIf
					EndIf
				Else
					Conout("[CHATDISP] Erro de Conexão com o Servidor RPC "+(cAliasSZN)->ZN_SERVER+":"+(cAliasSZN)->ZN_PORTA+" "+cEnvServer)
				EndIf
				oRpcSrv:Disconnect()
				FreeObj(oRpcSrv)
				oXml := nil
				(cAliasSZN)->(DbSkip())

			Enddo

			(cAliasSZN)->(DbCloseArea())

			If lEnvDisp .and. Len(aGroup) > 0
				_cxmlenvio := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' + Chr(13) + Chr(10)
				_cxmlenvio += '<disponibilidadeOperadorType xmlns:ns2="http://www.example.org/DisponibilidadeOperadorSchema">' + Chr(13) + Chr(10)
				For _cc := 1 To Len(aGroup)
					_cxmlenvio += '    <ns2:operador>' + Chr(13) + Chr(10)
					_cxmlenvio += '        <ns2:idGrupo>' + aGroup[_cc][1] + '</ns2:idGrupo>' + Chr(13) + Chr(10)
					_cxmlenvio += '        <ns2:quantidadeOperador>' + StrZero(aGroup[_cc][2],3) + '</ns2:quantidadeOperador>' + Chr(13) + Chr(10)
					_cxmlenvio += '    </ns2:operador>' + Chr(13) + Chr(10)

					Self:_cGrupo := Alltrim(aGroup[_cc][1])
					Self:SetTamanhoFila()

				Next _cc
				_cxmlenvio += '</disponibilidadeOperadorType>' + Chr(13) + Chr(10)
				oSvc	:= WSChatProviderService():New() // ChatProvider
				lOk		:= oSvc:disponibilidadeOperador(_cxmlenvio)

				If !lOk
					conout("[CTSDKCHAT] erro envio disponibilidade operador")
				Endif

				FreeObj(oSvc)
				oSvc := nil
			EndIf

			cAliasSU0->(DbSkip())

		Enddo
		cAliasSU0->(DbCloseArea())
	Endif

	return(aGroup)

Method RemoveGarbage() CLASS CtSdkChat
	Local aRet	:= {}
	Local nI	:= 0
	Local aUsers:= GetUserInfoArray()
	Local nIndex:= 0

	aRet	:= {}
	If VarGetAA(Self:cUIDChatFim, @aRet)
		For nI:=1 to Len(aRet)
			nIndex:= Ascan(aUsers,{|x| x[3] == val(aRet[nI,1]) })
			If nIndex <= 0 .or. (nIndex > 0 .and. AT("CHAT ", aUsers[nIndex,11]) <= 0)
				VarDel(Self:cUIDChatFim,aRet[nI,1])
			EndIf
		Next
	Endif

	aRet	:= {}
	If VarGetAA(Self:cUIDChatInicia, @aRet)
		For nI:=1 to Len(aRet)
			nIndex:= Ascan(aUsers,{|x| x[3] == val(aRet[nI,1]) })
			If nIndex <= 0 .or. (nIndex > 0 .and. AT("CHAT ", aUsers[nIndex,11]) <= 0)
				VarDel(Self:cUIDChatInicia,aRet[nI,1])
			EndIf
		Next
	Endif

	aRet	:= {}
	If VarGetAA(Self:cUIDChatFimCli, @aRet)
		For nI:=1 to Len(aRet)
			nIndex:= Ascan(aUsers,{|x| x[3] == val(aRet[nI,1]) })
			If nIndex <= 0 .or. (nIndex > 0 .and. AT("CHAT ", aUsers[nIndex,11]) <= 0)
				VarDel(Self:cUIDChatFimCli,aRet[nI,1])
			EndIf
		Next
	Endif

	aRet	:= nil
	nI		:= nil
	aUsers	:= nil
	nIndex	:= nil

Return

Method EncerraJanela(lAlert,lAtuDisp) CLASS CtSdkChat
	Local nPos 		:= Ascan(Self:aJanID,{|x| !Empty(x[1])})
	Local cAliasSZN := ""
	Local cAliasSZM := ""
	Local nQtdConv	:= 0

	Default lAlert	:= .T.
	Default lAtuDisp:= .T.

	If Self:lEncerraJanela .or. MsgYesNo("DESEJA REALENTE SAIR DA ROTINA DE CHAT?","*** ATENÇÃO ***")
		If nPos > 0
			If lAlert
				MsgAlert("Existem conversas ativas. Ao finalizar, a tela será fechada!")
			Endif

			If lAtuDisp
				cAliasSZN := Self:SetTrbSZN()

				If (cAliasSZN)->(!Eof())

					While (cAliasSZN)->(!Eof())
						DbSelectArea("SZN")
						SZN->(DbGoto((cAliasSZN)->SZNREC))
						
						Reclock("SZN",.F.)
							SZN->ZN_DISP 	:= 0
						SZN->(MsUnlock())

						(cAliasSZN)->(Dbskip())
					Enddo

					(cAliasSZN)->(DbCloseArea())
				Endif
			EndIf

			Self:lEncerraJanela := .T.
		Else
			cAliasSZN := Self:SetTrbSZN()

			If (cAliasSZN)->(!Eof())

				While (cAliasSZN)->(!Eof())
					DbSelectArea("SZN")
					SZN->(DbGoto((cAliasSZN)->SZNREC))

					Reclock("SZN",.F.)
						SZN->ZN_LOGOUT := Alltrim(dtoc(date())+time())
						SZN->(dbdelete())
					SZN->(MsUnlock())

					(cAliasSZN)->(Dbskip())
				Enddo

				(cAliasSZN)->(DbCloseArea())
			Endif

			Self:oTela:End()
			Self:RemoveGarbage()
			DelClassIntf()
		Endif
	Endif
Return

Method SetFila(cXml) CLASS CtSdkChat
	Local cAviso	:= ""
	Local cErro		:= ""
	Local lRet		:= .T.
	Local oXml 		:= XmlParser(cXml,"_",@cAviso,@cErro)
	Local aFila		:= {}
	Local aDisp		:= {}
	Local cSession	:= ""
	Local cTime		:= ""
	Local lIpcGo	:= .F.
	Local lTimeOut	:= .F.
	Local cTamFila	:= ""

	If !Empty(cAviso)
		Help(,1,"CHATFILA1",,"Aviso distribuição de fila "+cAviso,1,0 )
		lRet := .F.
	EndIf

	If !Empty(cErro)
		Help(,1,"CHATFILA2",,"Erro distribuição de fila "+cErro,1,0 )
		lRet := .F.
	EndIf

	If lRet
		Self:_cGrupo:= Alltrim(oXml:_INICIACONVERSATYPE:_NS2_IDGRUPO:TEXT)
		cSession	:= Alltrim(oXml:_INICIACONVERSATYPE:_NS2_IDCONVERSA:TEXT)

		cTamFila := Self:SetTamanhoFila()
		ZZ0->(DbSetOrder(2))

		If Val(cTamFila) > 0 .and. !ZZ0->(DbSeek(xFilial("ZZ0")+"01"+"F"+cSession))
		   	Reclock("ZZ0",.T.)
			   	ZZ0->ZZ0_TIPO	:= "01"
			   	ZZ0->ZZ0_GRUPO	:= Self:_cGrupo
			   	ZZ0->ZZ0_MEN	:= cXml
			   	ZZ0->ZZ0_ID		:= cSession
			   	ZZ0->ZZ0_STATUS	:= "F"
			   	ZZ0->ZZ0_DATAE	:= Ddatabase
			   	ZZ0->ZZ0_HORA	:= SubStr(Time(),1,2)+SubStr(Time(),4,2)
		   	ZZ0->(MsUnlock())
			lRet := .F.
		Else
			cAliasSZM := Self:SetTrbSZM(nil,.F.)

			BeginSql Alias cAliasSZM
				%noparser%
				SELECT
					COUNT(*) SZMREG
				FROM
					%Table:SZM% SZM
				WHERE
					ZM_FILIAL = %Exp:xFilial("SZM")% AND
					ZM_SESSAO = %Exp:cSession%	AND
					ZM_DATA = %Exp:DtoS(Date())% AND
					ZM_GRUPO = %Exp:Self:_cGrupo% AND
					SZM.%NotDel%
			EndSql

			lRet := (cAliasSZM)->SZMREG == 0

			(cAliasSZM)->(DbCloseArea())

			If lRet

				cTime := Time()

				While !lIpcGo .and. !lTimeOut
					lTimeOut	:= ElapTime( cTime, Time() ) > Self:cTimeOutIpcGo
					lIpcGo		:= IpcGo("CHAT"+Self:_cGrupo,cXml)
				EndDo

				If lIpcGo
			  		Reclock("ZZ0",.T.)
					   	ZZ0->ZZ0_TIPO	:= "01"
					   	ZZ0->ZZ0_GRUPO	:= Self:_cGrupo
					   	ZZ0->ZZ0_MEN	:= cXml
					   	ZZ0->ZZ0_ID		:= cSession
					   	ZZ0->ZZ0_STATUS	:= "R"
					   	ZZ0->ZZ0_DATAE	:= Ddatabase
					   	ZZ0->ZZ0_HORA	:= SubStr(Time(),1,2)+SubStr(Time(),4,2)
				   	ZZ0->(MsUnlock())
				Else
					Reclock("ZZ0",.T.)
					   	ZZ0->ZZ0_TIPO	:= "01"
					   	ZZ0->ZZ0_GRUPO	:= Self:_cGrupo
					   	ZZ0->ZZ0_MEN	:= cXml
					   	ZZ0->ZZ0_ID		:= cSession
					   	ZZ0->ZZ0_STATUS	:= "D"
					   	ZZ0->ZZ0_DATAE	:= Ddatabase
					   	ZZ0->ZZ0_HORA	:= SubStr(Time(),1,2)+SubStr(Time(),4,2)
				   	ZZ0->(MsUnlock())
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Endif

	FreeObj(oXml)
	oXml := nil

Return(lRet)

Method GetFila() CLASS CtSdkChat
	Local lRet		:= .T.
	Local cAliasZZ0 := Self:SetTrbSZN(.F.)

	BeginSql Alias cAliasZZ0
		%noparser%
		SELECT
			NVL(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZZ0_MEN,2000,1)),'') ZZ0_MEN,
			R_E_C_N_O_ RECZZ0
		FROM
			%Table:ZZ0%	ZZ0
		WHERE
			ZZ0_FILIAL = %xFilial:ZZ0% AND
		  	ZZ0_TIPO = '01' AND
		  	ZZ0_STATUS = 'R' AND
		  	ZZ0.%NotDel%
	EndSql

	If  !(cAliasZZ0)->(EoF())
		While !(cAliasZZ0)->(EoF())
			ZZ0->(DbGoTo((cAliasZZ0)->RECZZ0))
			If Self:DistribuiConversa(Alltrim((cAliasZZ0)->ZZ0_MEN))
				RecLock("ZZ0",.F.)
					ZZ0->ZZ0_STATUS := "P"
				ZZ0->(MsUnlock())
			Else
				RecLock("ZZ0",.F.)
					ZZ0->ZZ0_STATUS := "E"
				ZZ0->(MsUnlock())
				lRet := .F.
			EndIf
			(cAliasZZ0)->(DbSkip())
		EndDo
	Else
		lRet := .F.
	EndIf

	(cAliasZZ0)->(DbCloseArea())

Return(lRet)

Method AlertChat(nType, cMsg) CLASS CtSdkChat
	Local cIniName	:= GetTempPath()
	Local lUnix		:= IsSrvUnix()
	Local nPos 		:= Rat( IIf( lUnix, "/", "\" ), cIniName )
	Local cPathRmt	:= ""
	Local cVbs		:= "msgchat.vbs"
	Local cCmd		:= ""

	Default cMsg	:= ""

	if !( nPos == 0 )
		cPathRmt := SubStr( cIniName, 1, nPos - 1 )+IIf( lUnix, "/", "\" )
	else
		cPathRmt := ""
	endif

	If !Empty(cPathRmt)

		If nType == 1
			cCmd := 'x=msgbox ("'+cMsg+'", 64, "Chat Protheus")'
		EndIf

		If MemoWrite(cPathRmt+cVbs,cCmd)

			If File(cPathRmt+cVbs)
				ShellExecute( "Open", cPathRmt+cVbs, "", "C:\", 11 )
			EndIf

		Endif

	EndIf

Return()

User Function GetChat(cGrupo,nTimeWait)
	Local cRet			:= ""
	Local lReceived		:= ""
	Local nRet			:= 0

	Default nTimeWait	:= 10

	lReceived := IpcWaitEx("CHAT"+cGrupo,nTimeWait,@cRet)

	IF lReceived
		nRet := 1
	ElseIF KillApp()
		nRet := 2
	Endif

Return({nRet,cRet})


User Function xTelCham(cCoduser,_cGrupo,nRecADE )
	Local nRecSU7 	:= 0
	Local cGrpAnt	:= ""

	Private aRotina 	:= {{"Pesquisar","AxPesqui",0,1} 	,;
		{"Visualizar","AxVisual",0,2} 	,;
		{"Incluir","AxInclui",0,3} 		,;
		{"Alterar","AxAltera",0,4} 		,;
		{"Excluir","AxDeleta",0,5}}

		INCLUI := .F.
		ALTERA := .T.

		SU7->(DbSetOrder(1))

		If SU7->(DbSeek(xFilial("SU7")+cCoduser))
			nRecSU7 := SU7->(Recno())
			cGrpAnt	:= SU7->U7_POSTO

			RecLock("SU7",.F.)
				SU7->U7_POSTO := _cGrupo
			SU7->(MsUnlock())

			TK503AOPC("ADE",nRecADE,4)

			SU7->(DbGoTo(nRecSU7))
			RecLock("SU7",.F.)
				SU7->U7_POSTO := cGrpAnt
			SU7->(MsUnlock())
		Else
			MsgStop("Operador código "+cCoduser+" não encontrado")
		EndIf
Return
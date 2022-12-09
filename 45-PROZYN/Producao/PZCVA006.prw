#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCVA006		�Autor  �Microsiga	     � Data �  04/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Aprova��o / Reprova��o do pedido de venda		 			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCVA006()

	Local aArea 	:= GetArea()
	Local oBrowse  
	Local cFiltro	:= ""
	Local cCodUsr	:= Alltrim(RetCodUsr())
	Local cCodUApv	:= U_MyNewSX6("CV_USAPVPV", ""	,"C","Usuarios liberados a utilizar a rotina - Faturamento", "", "", .F. )
	Local cCodUFin  := U_MyNewSX6("CV_USAPVFI", ""	,"C","Usuarios liberados a utilizar a rotina - Financeiro", "", "", .F. )
	Local cCodUMar  := U_MyNewSX6("CV_USAPVMA", ""	,"C","Usuarios liberados a utilizar a rotina - Margem", "", "", .F. )
	Local cCodUPMi  := U_MyNewSX6("CV_USAPVPM", ""	,"C","Usuarios liberados a utilizar a rotina - Pre�o M�nimo", "", "", .F. )
	Private lFat 		:= .F.
	Private lFin 		:= .F.
	Private lMar		:= .F.
	Private lPMi		:= .F.

	Private aRotina	:= {}

	If Alltrim(cCodUsr) $ Alltrim(cCodUApv)
		lFat := .T.
	EndIf
	If Alltrim(cCodUsr) $ Alltrim(cCodUFin)
		lFin := .T.
	EndIf
	If Alltrim(cCodUsr) $ Alltrim(cCodUMar)
		lMar := .T.
	EndIf
	If Alltrim(cCodUsr) $ Alltrim(cCodUPMi)
		lPMi := .T.
	EndIf

	If !lFat .and. !lFin .and. !lMar .and. !lPMi
		Aviso("Aten��o-(CV_USAPVPV | CV_USAPVFI | CV_USAPVMA | CV_USAPVPM)","Usu�rio n�o autorizado a utilizar a rotina de aprova��o. "+CRLF;
		+"Entre em contato com o administrador do sistema. ",{"Ok"},2)
		Return
	EndIf

	DbSelectArea('SC5')

	//Cria o objeto do tipo FWMBrowse
	oBrowse := FWMBrowse():New()     

	//Alias ta tabela a ser utilizada no browse
	oBrowse:SetAlias('SC5') 

	//Defini��o de filtro
	If lFat
		cFiltro += " (C5_BLQ == '9' .AND. Alltrim(C5_YTPBLQ) $ 'ABC') "
	EndIf
	If lFin
		If lFat
			cFiltro += " .OR. Alltrim(C5_XBLQFIN) == 'B' "
		Else
			cFiltro += " Alltrim(C5_XBLQFIN) == 'B' "
		EndIf
	EndIf
	If lMar
		If lFat .or. lFin
			cFiltro += " .OR. Alltrim(C5_XBLQMRG) == 'S' "
		Else
			cFiltro += " Alltrim(C5_XBLQMRG) == 'S' "
		EndIf
	EndIf

	// If lPMi
	// 	If lFat .or. lFin
	// 		cFiltro += " .OR. Alltrim(C5_XBLQMIN) == 'S' "
	// 	Else
	// 		cFiltro += " Alltrim(C5_XBLQMIN) == 'S' "
	// 	EndIf
	// EndIf
	oBrowse:SetFilterDefault(cFiltro)

	//Legenda
	If lFin
		oBrowse:AddLegend( "Alltrim(C5_XBLQFIN) == 'B'"	, "BR_VIOLETA"		, "Blq. Financeiro" )
	EndIf
	If lMar
		oBrowse:AddLegend( "Alltrim(C5_XBLQMRG) == 'S'"	, "BR_PINK"		, "Blq. Margem" )
	EndIf
	// If lPMi
	// 	oBrowse:AddLegend( "Alltrim(C5_XBLQMIN) == 'S'"	, "CLR_HCYAN"		, "Blq. Margem" )
	// EndIf
	If lFat
		// oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'A' "	, "BR_PINK"			, "Blq. Faturamento Minimo" )
		// oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'B' "	, "BR_BRANCO"		, "Blq. Data Ciclo" )
		oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'C' "	, "BR_MARRON"		, "Blq. Credito" )
		// oBrowse:AddLegend( "C5_BLQ == '9' .And. Alltrim(C5_YTPBLQ) == 'AB'"	, "BR_PRETO"		, "Blq. Fat.Min. e Dt.Ciclo" )
	EndIf




	//Descri��o da rotina
	oBrowse:SetDescription("Aprova��o de pedido de venda")

	oBrowse:Activate()

	RestArea(aArea)	
Return

User Function PZCLIANL
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	If ( Pergunte("FIC010",.T.) )
		Fc010Con()
	EndIf
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MenuDef �Autor  �Microsiga 	          � Data � 04/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de defini��o do aRotina							  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MenuDef() 

	Private aRotina	:= {}
	Default lFin := .F.

	ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
	ADD OPTION aRotina Title "Visualizar" 				Action 'U_PZCV6VIS' 		OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title "Aprovar"  				Action 'U_PZCV6APR' 		OPERATION 7 ACCESS 0
	ADD OPTION aRotina Title "Reprovar"  				Action 'U_PZCV6REP'			OPERATION 8 ACCESS 0
	If lFin
		ADD OPTION aRotina Title "An�lise Cliente"  			Action 'U_PZCLIANL'			OPERATION 7 ACCESS 0
	EndIf

Return aRotina 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCV6VIS �Autor  �Microsiga 	          � Data � 04/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de visualiza��o									  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCV6VIS()
	Local aArea	:= GetArea()	

	VISUAL := .T.
	A410Visual("SC5",SC5->(Recno()),2)
	VISUAL := .F.
	RestArea(aArea)	
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCV6APR �Autor  �Microsiga 	          � Data � 04/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao de aprova��o										  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCV6APR()

	Local aArea	:= GetArea()

	If Aviso("Aten��o","Confirma a aprova��o do pedido "+SC5->C5_NUM+" ?",{"Sim","N�o"})==1

		If Alltrim(SC5->C5_BLQ) == "9" .And. Alltrim(SC5->C5_YTPBLQ) == "C" .and. lFat

			//Efetua a libera��o do pedido e envia para analise de credito
			U_PZCVP010(SC5->C5_NUM, 1, .T.)

			RecLock("SC5",.F.)
			SC5->C5_BLQ		:= ""
			SC5->C5_YTPBLQ 	:= "OK"
			SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			SC5->C5_YOBSR	:= ""   
			SC5->(MsUnLock())

		ElseIf Alltrim(SC5->C5_XBLQFIN) == "B" .and. lFin
		
			RecLock("SC5",.F.)
			SC5->C5_XBLQFIN := "L"

			If Empty(Alltrim(SC5->C5_BLQ))
				SC5->C5_YTPBLQ 	:= "OK"
				SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			EndIf

			SC5->(MsUnLock())

		ElseIf AllTrim(SC5->C5_XBLQMRG) == 'S' .and. lMar
			SC5->(RecLock("SC5",.F.))
			SC5->C5_XBLQMRG := "L"
			SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			SC5->(MsUnLock())

		// ElseIf AllTrim(SC5->C5_XBLQMIN) == 'S' .and. lPMi
		// 	SC5->(RecLock("SC5",.F.))
		// 	SC5->C5_XBLQMIN := "L"
		// 	SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
		// 	SC5->(MsUnLock())

		// Else
			//Efetua a libera��o do pedido e verifica se existe boqueio de credito. Se existir bloquei o pedido ficar� bloqueado por credito.
			// If U_PZCVP010(SC5->C5_NUM)
			// 	RecLock("SC5",.F.)
			// 	SC5->C5_BLQ		:= ""
			// 	SC5->C5_YTPBLQ 	:= "OK"
			// 	SC5->C5_LGLIBCO	:= "Aprovado: "+Alltrim(cUserName)+" Data: "+DTOC(Date())+" - "+Time()
			// 	SC5->C5_YOBSR	:= ""   
			// 	SC5->(MsUnLock())

			// EndIf

		EndIf 


	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PZCV6REP �Autor  �Microsiga 	          � Data � 04/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Reprova��o												  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PZCV6REP()

	Local aArea		:= GetArea()
	Local cObs		:= ""
	Local cMailRep	:= U_MyNewSX6("CV_MAILRPV", "",;
	"C","E-mail do destinatario para informa��o de pedido reprovado", "", "", .F. )
	Local cAssunto	:= "Pedido Reprovado - "+SC5->C5_NUM
	Local cMensagem	:= "Segue as observa��es da reprova��o: "+CRLF+CRLF
	Local cMsgErr	:= ""

	If Aviso("Aten��o","Confirma a reprova��o do pedido "+SC5->C5_NUM+" ?",{"Sim","N�o"})==1

		cObs := GetObsRec()

		If !Empty(cObs)
			RecLock("SC5",.F.)
			SC5->C5_YTPBLQ 	:= "R"
			SC5->C5_LGLIBCO	:= "Reprovado: "+Alltrim(cUserName)+" Data: "+DTOC(MsDate())+" - "+Time()
			SC5->C5_YOBSR	:= cObs  
			SC5->(MsUnLock())

			EnvMail(cMailRep,cAssunto,GetHtmMsg(cMensagem+"<br><br>"+cObs),"", "", @cMsgErr) 
		EndIf
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GetObsRec	�Autor  �Microsiga		     � Data �  18/01/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna a observa��o da recusa						      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetObsRec()

	Local aArea := GetArea()
	Local cRet	:= ""
	Local oDlg 
	Local oWin01
	Local oFWLayer 
	Local oButSair
	Local oButOk
	Local oTMulget

	//Montagem da tela
	DEFINE DIALOG oDlg TITLE "Observa��o da recusa" SIZE 400,400 PIXEL STYLE nOr(WS_VISIBLE,WS_OVERLAPPEDWINDOW)

	//Cria instancia do fwlayer
	oFWLayer := FWLayer():New()

	//Inicializa componente passa a Dialog criada,o segundo parametro � para 
	//cria��o de um botao de fechar utilizado para Dlg sem cabe�alho 		  
	oFWLayer:Init( oDlg, .T. )

	// Efetua a montagem das colunas das telas
	oFWLayer:AddCollumn( "Col01", 100, .T. )


	// Cria tela passando, nome da coluna onde sera criada, nome da window			 	
	// titulo da window, a porcentagem da altura da janela, se esta habilitada para click,	
	// se � redimensionada em caso de minimizar outras janelas e a a��o no click do split 	
	oFWLayer:AddWindow( "Col01", "Win01", "Observa��o", 100, .F., .T., ,,) 
	oWin01 := oFWLayer:getWinPanel('Col01','Win01')

	oTMulget := TMultiGet():New( 005,005, {|u| if( Pcount()>0, cRet:= u, cRet) },;
	oWin01,183,oWin01:nClientHeight - (oWin01:nClientHeight * 56.45)/100 ,;
	,.T.,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,.T.)  


	oButOk		:= TButton():New( 153, 125, "Continuar",oWin01,{ || IIf(Empty(cRet),Aviso("Campo obrigat�rio","Campo obrigat�rio n�o preenchido",{"Ok"},1),oDlg:End()) }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	oButSair		:= TButton():New( 153, 160, "Sair",oWin01,{ ||cRet := "", oDlg:End() }, 30,10,,,.F.,.T.,.F.,,.F.,,,.F. )

	ACTIVATE DIALOG oDlg CENTERED

	//Verifica se a justificativa foi preenchida para gravar os dados do usu�rio, data e hora de cancelamento
	If !Empty(cRet)
		cRet := cRet +CRLF+CRLF+"Usu�rio: "+UsrFullName( RetCodUsr())+CRLF+"Data: "+DTOC(MsDate())+CRLF+"Hora: "+Time()
	EndIf

	RestArea(aArea)
Return cRet  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnvMail  �Autor  �Microsiga	          � Data �  25/03/2017���
�������������������������������������������������������������������������͹��
���Desc.     �Envia e-mail                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

	Local aArea 		:= GetArea()
	Local cServer   	:= Alltrim(Separa(GetMV("MV_RELSERV",,""),":")[1])
	Local nPort			:= Val(Separa(GetMV("MV_RELSERV",,""),":")[2])
	Local cAccount		:= Alltrim(GetMV("MV_RELACNT",,""))
	Local cPwd			:= Alltrim(GetMV("MV_RELPSW",,""))
	Local lAutentic		:= GetNewPar("MV_RELAUTH",.F.)
	Local lSSL			:= .T.
	Local lTLS			:= .T.

	Local oServer       := Nil
	Local oMessage		:= Nil 
	Local aAnexos		:= Iif(!Empty(cAnexos), Separa(cAnexos,";"), "")
	Local nX			:= 1
	Local nErro			:= 0

	Default cMsgErr 	:= ""

	//Crio a conex�o com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()

	If lSSL
		oServer:SetUseSSL(lSSL)
	EndIf

	If lTLS
		oServer:SetUseTLS(lTLS)
	EndIf

	oServer:Init( "", cServer, cAccount,cPwd,0,nPort)

	//realizo a conex�o SMTP
	nErro := oServer:SmtpConnect() 
	If nErro != 0  
		cMsgErr := "Falha na conex�o SMTP. "
		Return .F.
	EndIf

	//seto um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		cMsgErr := "Falha ao setar o time out com o servidor. "
		Return .F.
	EndIf

	// Autentica��o
	If lAutentic
		If oServer:SMTPAuth ( cAccount,cPwd ) != 0
			cMsgErr := "Falha ao autenticar. "
			Return .F.
		EndIf
	EndIf

	//Apos a conex�o, crio o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpo o objeto
	oMessage:Clear()

	//Populo com os dados de envio
	oMessage:cFrom		:= 	cAccount
	oMessage:cTo		:=	cEmailTo
	oMessage:cSubject	:= 	cAssunto
	oMessage:cBody		:= 	cMensagem
	oMessage:MsgBodyType( "text/html" )

	For nX := 1 To Len(aAnexos)
		If File(aAnexos[nX])

			//Adiciono um attach
			If oMessage:AttachFile( aAnexos[nX] ) < 0
				cMsgErr := "Erro ao anexar o arquivo. "
				Return .F.
			EndIf
		EndIf     
	Next

	//Envio o e-mail
	If oMessage:Send( oServer ) != 0
		cMsgErr := "Erro ao enviar o e-mail. "
		Return .F.
	EndIf

	//Disconecto do servidor
	If oServer:SmtpDisconnect() != 0
		cMsgErr := "Erro ao disconectar do servidor SMTP. "
		Return .F.
	EndIf

	RestArea(aArea)
Return      


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetHtmMsg �Autor  �Microsiga 	          � Data � 04/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Html da mensagem											  ���
���          �												    		  ���
�������������������������������������������������������������������������͹��
���Uso       �			                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/            
Static Function GetHtmMsg(cMsg)

	Local aArea		:= GetArea()
	Local cRet		:= ""

	Default cMsg	:= ""

	cRet += "<html>"
	cRet += "	<head>"
	cRet += "	</head>"
	cRet += "	<body>"
	cRet += "		"+StrTran(cMsg,CRLF,"<br>")
	cRet += "	</body>"
	cRet += "</html>" 

	RestArea(aArea)
Return cRet          

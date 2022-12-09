#Include "Protheus.CH"
#Include "RwMake.CH"
#Include "TopConn.CH"
#INCLUDE "TCBROWSE.CH"
#INCLUDE "COLORS.CH"
//#INCLUDE 'TMKA260.CH'
#Include 'FWMVCDEF.CH'

User Function HCIDA011()

	Local _cFiltroTop	:= U_HCIDM010("Prosp")
	Local aCores   		:= {	{"SUS->US_STATUS == '1'"	, "BR_MARROM"		,"Classificado" 		},; // Classificado
		   						{"SUS->US_STATUS == '2'"	, "BR_VERMELHO"		,"Desenvolvimento" 		},; // Desenvolvimento
		   						{"SUS->US_STATUS == '3'"	, "BR_AZUL"			,"Gerente"				},; // Gerente
								{"SUS->US_STATUS == '4'"	, "BR_AMARELO"		,"Standy by" 			},; // Standy by
								{"SUS->US_STATUS == '5'"	, "BR_PRETO"		,"Cancelado"			},; // Cancelado
								{"SUS->US_STATUS == '6'"	, "BR_VERDE"		,"Cliente"  			},; // Cliente 
								{"Empty(SUS->US_STATUS)"   	, "BR_BRANCO"		,"Maling (sem status)"   }}  // Maling (sem status)
	
	Private cCadastro	:= "Prospects"
	PRIVATE aRotina 	:= MenuDef()	
	Private lTk260Auto	:= .F.
	
	Static lR7	:= (GetRpoRelease() >= "R7")

	If !Empty(_cFiltroTop)
		_cFiltroTop	:= "US_CGC IN (" + _cFiltroTop + ") OR US_USERLGI = '" + __cUserId+ "'"
	EndIf
	
	DbSelectarea("SUS")
	MBrowse(			,			,			,			,"SUS"	,			,			,			,			,				,aCores		,			,			,			,				,					,			,			,_cFiltroTop)
//	MBrowse ( [ nLin1 ] [ nCol1 ] 	[ nLin2 ] 	[ nCol2 ]	cAlias 	[ aFixe ] 	[ cCpo ] 	[ nPar08 ] 	[ cFun ] 	[ nClickDef ] 	[ aColors ] [ cTopFun ] [ cBotFun ] [ nPar14 ] 	[ bInitBloc ] 	,[ lNoMnuFilter ]	[ lSeeAll ] [ lChgAll ] [ cExprFilTop ] [ nInterval ] [ bTimerAction ] [ uPar22 ] [ uPar23 ] )
	
Return()

Static Function MenuDef()

Local aRotAdic		:= {}						// Retorno do P.E. TK260ROT para entrada automatica
Local aRotina		:= {}	          			// Opcoes do programa
Local aPermissoes	:= {}						// Permissoes de acesso aos itens do menu

aRotina:= {	{ "Pesquisar"	,"AxPesqui"			, 0 , 1 , , .F. },;  //"Pesquisar"
			{ "Visualizar"	,"Tk260Visu"		, 0 , 2 , , .T. },;  //"Visualizar"
        	{ "Incluir"		,"u__fHCID11(3)"	, 0 , 3 , , .T. },;  //"Incluir"
            { "Alterar"		,"u__fHCID11(4)"	, 0 , 4 , , .T. },;  //"Alterar"
            { "Excluir"		,"Tk260Delet"		, 0 , 5 , , .T. },;  //"Excluir"
            { "Ag.Visita"	,"Tka260Vis"		, 0 , 6 , , .T. },;  //"Ag.Visita"
	       	{ "Contatos"	,"FTCONTATO"	, 0	, 4 , , .T. },;  //"Contatos"
			{ "Conhecimento","MsDocument"		, 0	, 4 , , .T. },;  //"Conhecimento"
			{ "Legenda"		,"Tk260Legenda"		, 0 , 2 , , .T. } }  //"Legenda" 	

Return(aRotina)

User Function _fHCID11(_nOpc)

	Local _cHistor	:= ""
	Local _aArea	:= GetArea()
	Local _nOpcA	:= 0
	Local _nRecno

	Do Case
		Case _nOpc == 3
			SUS->(DBGOBOTTOM())
			Tk260Inclui("SUS",SUS->(RECNO()),3)
			SUS->(dbGoTO(SUS->(RECNO())))
		Case _nOpc == 4
			_cHistor	:= SUS->US_XHISTOR
			_nRecno		:= SUS->(RECNO())
			_nOpcA 		:= Tk260Altera("SUS",SUS->(RECNO()),4)
			SUS->(dbGoTo(_nRecno))
			If _nOpcA .And. !Empty(SUS->US_XOBSDIA)
				fTOkSUS(_cHistor)
			EndIf
			SUS->(dbGoTO(SUS->(RECNO())))
			
	End Case

	RestArea(_aArea)
	
Return()

Static Function fTOkSUS(_cHistor)

	Local _cObs		:= ""
	Local _aEmail	:= Separa(GetMV("ES_WFHSTPT",,"000076,000009,000254,000256,000515,000057,000148"),",")
	Local _cMsg		:= ""
	Local _cPara	:= ""
	Local _cAssunto	:= "Aviso de Prospect - Nº " + Alltrim(SUS->US_COD) +'/' + AllTrim(SUS->US_LOJA)
	Local _nI		:= 0
	Local _cCopy	:= "bzechetti@totalitsolutions.com.br"
 	
 	If !Empty(SUS->US_XOBSDIA)
	 	_cObs := "===========================================" +CRLF
		_cObs += "[" + SubStr(DtoS(dDataBase),7,2) + "/" + SubStr(DtoS(dDataBase),5,2) + "/" + SubStr(DtoS(dDataBase),1,4) + " - " + time() + "]"+CRLF
		_cObs += "[ Usuario - " + UsrFullName(__cUserID) + " ]" +CRLF
		_cObs += AllTrim(SUS->US_XOBSDIA)+CRLF
		_cObs += "===========================================" +CRLF
		_cObs += AllTrim(_cHistor)
		
		If RecLock("SUS",.F.)
			SUS->US_XHISTOR	:= _cObs
			SUS->US_XOBSDIA	:= ""
			SUS->(MsUnLock())
		EndIf
		
		For _nI	:= 1 To Len(_aEmail)
		
			_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Prospect</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#CD2626"><B><center>Prospect - ' + Alltrim(SUS->US_COD) +'/' + AllTrim(SUS->US_LOJA)  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Prezado(a) ' + UsrFullName(_aEmail[_nI]) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Foi realizado a atualização do histórico do prospect: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + SUS->US_CODCLI + SUS->US_LOJACLI,"A1_NOME") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + SUS->US_XCONT,"U5_CONTAT") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Histórico: ' + SUS->US_XHISTOR + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= AllTrim(UsrRetMail(_aEmail[_nI]))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		Next _nI
		
		If !Empty(SUS->US_VEND)
		
			_cMsg	:= '<html>'+CRLF
			_cMsg	+= '	<head>'+CRLF
			_cMsg	+= '		<title>Prospect</title>'+CRLF
			_cMsg	+= '	</head> '+CRLF
			_cMsg	+= '	<body> '+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<FONT SIZE = "5" COLOR = "#CD2626"><B><center>Prospect - ' + Alltrim(SUS->US_COD) +'/' + AllTrim(SUS->US_LOJA)  + '</center></B></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Prezado(a) ' + SA3->(GetAdvFVal("SA3","A3_NOME",xFilial("SA3") + SUS->US_VEND,1)) +',</p></FONT>'+CRLF
			_cMsg	+= '		<p>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Foi realizado a atualização do histórico do prospect: </p></FONT>'+CRLF 
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Cliente: ' + POSICIONE("SA1",1,xFilial("SA1") + SUS->US_CODCLI + SUS->US_LOJACLI,"A1_NOME") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Contato: ' + POSICIONE("SU5",1,xFilial("SU5") + SUS->US_XCONT,"U5_CONTAT") + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Histórico: ' + SUS->US_XHISTOR + '.</p></FONT>'+CRLF
			_cMsg	+= '		<FONT COLOR = "#CD2626"><p>Grato(a).</p></FONT>'+CRLF
			_cMsg	+= '		<hr size=2 width=100% align=center>'+CRLF
			_cMsg	+= '	</body>'+CRLF
			_cMsg	+= '</html>'+CRLF
			
			_cPara		:= AllTrim(UsrRetMail(SUS->US_VEND))
			
			MailDSC(_cPara, _cAssunto, _cMsg, _cCopy)
			
		EndIF 
		
	EndIf

Return(.T.)

//-------------------------------------------------------------------
/*/{Protheus.doc} MailDSC
Funcao para envio de email em caso de conta SMTP usar criptografia TLS

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		15/10/2014
@version 	P11
@obs    	Rotina Especifica Descarpack Embalagens
/*/
//-------------------------------------------------------------------
Static Function MailDSC(cPara, cAssunto, cMsg, cCC)

	Local oMail 
	Local oMessage
	Local nErro
	Local lRet 			:= .T.
	Local cSMTPServer	:= Alltrim(GetMV("MV_WFSMTP"))
	Local cSMTPUser		:= Alltrim(GetMV("MV_WFAUTUS"))
	Local cSMTPPass		:= Alltrim(GetMV("MV_WFAUTSE"))
	Local cMailFrom		:= cSMTPUser
	Local nPort	   		:= 587
	Local lUseAuth		:= .T.
	
	conout('Conectando com SMTP ['+cSMTPServer+'] ')
	oMail := TMailManager():New()
//	oMail:SetUseTLS(.t.)
	conout('Inicializando SMTP')
	oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nPort  )
	oMail:SetSmtpTimeOut( 30 )
	conout('Conectando com servidor...')
	nErro := oMail:SmtpConnect()
	
	If lUseAuth
		nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
		If nErro <> 0
			cMAilError := oMail:GetErrorString(nErro)
			DEFAULT cMailError := '***UNKNOW***'
			conout("Erro de Autenticacao "+str(nErro,4)+' ('+cMAilError+')')
			lRet := .F.
		EndIf
	EndIf
	
	If nErro <> 0
		cMAilError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		conout(cMAilError)
		
		conout("Erro de Conexão SMTP "+str(nErro,4))
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
		lRet := .F.
	EndIf 
	
	If lRet
		oMessage := TMailMessage():New()
		oMessage:Clear()
		oMessage:cFrom		:= cMailFrom
		oMessage:cTo		:= cPara
		oMessage:cCC		:= cCC
		oMessage:cSubject	:= cAssunto
		oMessage:cBody		:= cMsg
		
		conout('Enviando Mensagem para ['+cPara+'] ')
		nErro := oMessage:Send( oMail )
		
		If nErro <> 0
			xError := oMail:GetErrorString(nErro)
			conout("Erro de Envio SMTP "+str(nErro,4)+" ("+xError+")")
			lRet := .F.
		Else
			conout("Mensagem enviada com sucesso!")
		EndIf
		
		conout('Desconectando do SMTP')
		oMail:SMTPDisconnect()
	EndIf
Return lRet

User Function _fEmCont(_cEmail,_nOpc)
          
	Local _cQuery		:= ""
	Local _cAliasEU5	:= GetNextAlias()
	Local _nCont		:= U_HCIDA003(_fTotEmC,_cEmail)
	
	_cQuery := "SELECT U5_EMAIL, U5_CODCONT, U5_CONTAT "
	_cQuery += " FROM " + RetSqlName("SU5")
	_cQuery += " WHERE U5_FILIAL = '" + xFilial("SU5") + "'"
	_cQuery += " AND U5_EMAIL = '" + AllTrim(_cEmail) + "'"
	_cQuery += " AND D_E_L_E_T_ = ' ' " 
	TcQuery _cQuery New Alias &(_cAliasEU5)
	
	If (_cAliasEU5)->(!EOF())
		Aviso(OEMTOANSI("Atenção"),"O E-mail informado se encontra cadastrado em Contatos!" ,{"Ok"},2)
		If _nOpc == 2 .And. _nCont == 1
			M->Z0_CONTATO	:= (_cAliasEU5)->U5_CODCONT
			M->Z0_NOMCONT	:= (_cAliasEU5)->U5_CONTAT
		EndIf
	Else
		If _nOpc == 2
			M->Z0_CONTATO	:= Space(TamSX3("Z0_CONTATO")[1])
			M->Z0_NOMCONT	:= Iif(Empty(M->Z0_CONTATO),M->Z0_NOMCONT,Space(TamSX3("Z0_NOMCONT")[1]))
		EndIf
	EndIf
	
	(_cAliasEU5)->(dbCloseArea())

Return(.T.)

User Function _fMnt011(_cAlias, _cRecno, _nOpc)

	Local _alArea		:= GetArea()
	Local _oDlgProsp	:= Nil
	Local _alEncho1		:= {}
	Local _alEncho2		:= {}
	Local _aAlt1		:= {}
	Local _aAlt2		:= {}
	
	SUS->(RegToMemory("SUS",_nOpc == 3))
	
	AADD(_alEncho1,"US_COD")
	AADD(_alEncho1,"US_NOME")
	AADD(_alEncho1,"US_NREDUZ")
	AADD(_alEncho1,"US_TIPO")
	AADD(_alEncho1,"US_EST")
	AADD(_alEncho1,"US_DDI")
	AADD(_alEncho1,"US_DDD")
	AADD(_alEncho1,"US_FAX")
	AADD(_alEncho1,"US_EMAIL")
	AADD(_alEncho1,"US_URL")
	AADD(_alEncho1,"US_CGC")
	AADD(_alEncho1,"US_MIDIA")
	AADD(_alEncho1,"US_XSEG1")
	AADD(_alEncho1,"US_XSEG2")
	AADD(_alEncho2,"US_XHISTOR")
	AADD(_alEncho1,"NOUSER") 
	
	AADD(_alEncho2,"US_XOBRA")
	AADD(_alEncho2,"US_XOBRAD")
	AADD(_alEncho2,"US_XISENF")
	AADD(_alEncho2,"US_XISENFD")
	AADD(_alEncho2,"US_XOBSCN")
	AADD(_alEncho2,"NOUSER") 
	
	DEFINE MSDIALOG _oDlgProsp TITLE OEMTOANSI("Agenda/Tarefa") FROM C(0),C(0) TO C(440),C(1015) OF _oDlgProsp PIXEL
	
		_oTFold		:= TFolder():New(005,005,{"Cadastrais","Projeto"},,_oDlgProsp,,,,.T.,,642,125,,) 
		
		//Folder 1
		Enchoice("SUS",SUS->(Recno()),_nOpc,,,,_alEncho1,{003,003,245,372},,,,,,_oTFold:aDialogs[1],,.T.)
				
		//Folder 2
		Enchoice("SUS",SUS->(Recno()),_nOpc,,,,_alEncho2,{003,003,245,372},,,,,,_oTFold:aDialogs[2],,.T.)
		                                                                                               
	ACTIVATE MSDIALOG _oDlgProsp On Init EnchoiceBar(_oDlgProsp,{|| nOpcA:=1,_oDlgProsp:End()},{||nOpca:=0,_oDlgProsp:End()},,) Centered	
	
	RestArea(_alArea)

Return()

User Function _fHCIDA()

	Local _cRet	:= POSICIONE("SA1",3,xFilial("SA1")+M->US_CGC,"A1_NOME")                                               
	
	alert("teste")

Return(_cRet)

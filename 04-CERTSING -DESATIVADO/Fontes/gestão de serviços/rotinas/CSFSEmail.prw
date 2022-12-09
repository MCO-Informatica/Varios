#INCLUDE "PRTOPDEF.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#include 'parmtype.ch'

User Function CSFSEmail(cOs, cObjeto, cEmailCli, cAssuntoEm, cCase, lErro, cCopiaOculta)

Local lRet := .F.
Local cCodCont := ""   

default lErro 	:= .F. 
default cCopiaOculta := ""

Private cDe      := GetMV("MV_EMCONTA") //certisign_protheus@certisign.com.br
Private cPara    := ALLTRIM(cEmailCli)
Private cCc      := Space(200)
Private cAssunto := cAssuntoEm
Private cAnexo   := IIF(Empty(cObjeto),"",cObjeto)
Private cServer  := GetMV("MV_RELSERV") // smtp.ig.com.br ou 200.181.100.51
Private cEmail   := GetMV("MV_EMCONTA") //GetMV("MV_RELACNT") //certisign_protheus@certisign.com.br
Private cPass    := GetMV("MV_RELPSW")  // 123abc
Private lAuth    := GetMv("MV_RELAUTH") // .T. ou .F.
Private cNomeCli := ""
Private chrAgen	 := ""
Private cEnd	 := ""
Private dtAgen	:= NIL
Private cOrdemSrv := cOs
private cObjLink	:= ""   
private cCopyOcult	:= cCopiaOculta
private oHtml

if GetMV("MV_BOLETRG") == "2" 
	cObjLink := cAnexo  
	// Este tratamento eh para que nao seja enviado email para o cliente
	// e a rotina desenvolvida (legado) realize RollBack.      
	if lErro
		return .F.
	endif
endif

dbSelectArea("PA0")
dbSetOrder(1)
dbSeek(xFilial("PA0")+cOs)

If PA0->(Found())

	cCodCont := PA0->PA0_CONTAT
	chrAgen  := PA0->PA0_HRAGEN
	cEnd     := ALLTRIM(PA0->PA0_END)
	dtAgen	 := PA0->PA0_DTAGEN
	
	dbSelectArea("SU5")
	dbSetOrder(1)
	If dbSeek(xFilial("SU5")+cCodCont)
		cNomeCli := SU5->U5_CONTAT
	EndIf
EndIf
       
       
//-------------------------------------------------------------
// Alteracao para forcar que nao envie email para quando o 
// o campo FATURA estiver igual a NAO, pois o pessoal de 
// Operacoes informa que o Cliente esta recebendo.
// @autor: Douglas Parreja
// @Since: 06/04/2017
//-------------------------------------------------------------                                                                                                                                             
if cCase == "ABERTURA"
	if u_csPodeEnviarEmail( cOrdemSrv )                                                                                                                                              
		lRet := CSFSEnvMail(cCase)
	else
		//-------------------------------------------------------------
		// Estou chumbando como .T. devido ao retorno, pois no Fonte 
		// CSAG0001 entendesse que caso nao conseguiu enviar e-mail 
		// ele exibira mensagem para usuario, e neste caso, este
		// tratamento eh para evitar envio de e-mail quando o esta
		// como FATURA igual a NAO. (Reforco da validacao)
		//-------------------------------------------------------------
		lRet := .T.
	endif
else	
	lRet := CSFSEnvMail(cCase)
endif
	
Return (lRet) 

//-----------------------------------------------------------------------
// Rotina | A320EnvMail | Autor | Rafael Beghini     | Data | 04/05/2015
//-----------------------------------------------------------------------
// Descr. | Rotina para enviar a Proposta por e-mail. 
//-----------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital
//-----------------------------------------------------------------------
Static Function CSFSEnvMail(cTipo)
Local lResulConn := .T.
Local lResulSend := .T.
Local cError := ""
Local lRet := .T.
Local cBody := ''   
local cPath := ""  
local cBCC	:= ""
Local cNumPedido := '__cNumPedido__'

Local cLinkEmail := ''
Local cLine := ''

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
  GET MAIL ERROR cError
  MsgAlert("Falha na conexão "+cError)
  lRet := .F.
  Return lRet
Endif
If lAuth
  lAuth := MailAuth(cEmail,cPass)
  If !lAuth
  ApMsgInfo("Autenticação FALHOU","Protheus")
  lRet := .F.
  Return lRet
  Endif
Endif

Do Case

	Case cTipo == "ABERTURA" .or. cTipo == "REENVIO"
	
		if alltrim(cTipo) $ "ABERTURA|REENVIO" 
			cPath := CurDir()+"agendamento\solicitacao_domicilio_agendamento.html"
		endif
		
		oHtml := TWFHtml():New(cPath) 
		oHtml:ValByName( "pa0.nome", {} ) 
		aadd(oHtml:ValByName("pa0.nome"), cNomeCli )

		if oHtml:existField(1,"link.shopline") 
			oHtml:ValByName( "link.shopline", {} )
			aadd(oHtml:ValByName("link.shopline"), cObjLink ) 
		endif
		
		cLinkEmail := '<a href="mailto:preanalise_agendamento@certisign.com.br">preanalise_agendamento@certisign.com.br</a>'

	Case cTipo == "PAGAMENTO"
	
		if alltrim(cTipo) == "PAGAMENTO"
			cPath := CurDir()+"agendamento\solicitacao_domicilio_pagamento.html"			
		endif 
		
		oHtml := TWFHtml():New(cPath)	
		oHtml:ValByName("pa0.nome"         , {})
		oHtml:ValByName("pa0.data"         , {}) 
		oHtml:ValByName("pa0.horaag"         , {}) 
		oHtml:ValByName("pa0.endereco"         , {})  
	
		aadd(oHtml:ValByName("pa0.nome"     )      , cNomeCli)
		aadd(oHtml:ValByName("pa0.data"     )      , dtAgen)
		aadd(oHtml:ValByName("pa0.horaag"     )      , chrAgen)
		aadd(oHtml:ValByName("pa0.endereco"     )      , cEnd)
		
		dbSelectArea( 'PA1' )
		dbSetOrder( 1 )
		If dbSeek( xFilial( 'PA1' ) + PA0->PA0_OS )
			While PA1->( .NOT. EOF() ) .AND.PA1->PA1_FILIAL == xFilial( 'PA1' ) .AND. PA1->PA1_OS == PA0->PA0_OS
				If .NOT. Empty( PA1->PA1_PEDIDO )
					If cNumPedido == '__cNumPedido__'
						cNumPedido := PA1->PA1_PEDIDO + ', '
					Else
						cNumPedido += PA1->PA1_PEDIDO + ', '
					Endif
				Endif
				PA1->( dbSkip() )
			End
			cNumPedido := RTrim( SubStr( cNumPedido, 1, Len( cNumPedido )-2 ) )
		Endif
		
		aadd(oHtml:ValByName("pa1.pedido"),cNumPedido)
		
		cLinkEmail := '<a href="mailto:cancelamento.externa@certisign.com.br">cancelamento.externa@certisign.com.br</a>'
		
	Case cTipo == "TECNICO"
		
		//-------------------------------------------------------------
		// Alteracao para forcar que nao envie email o cliente, pois  
		// no fonte tinha uma validacao no If caso falhasse, no Else
		// ele mandaria "solicitacao_domicilio_agendamento", e com isso
		// retirei, e refiz a validacao de posicionamento, visto que 
		// poderia falhar,e  agora nao.
		// @autor: Douglas Parreja
		// @Since: 26/04/2017
		//-------------------------------------------------------------   
		dbSelectArea("PA2")
		dbSetOrder(2) //PA2_FILIAL+PA2_NUMOS 
		if PA2->( dbSeek(xFilial("PA2") + cOrdemSrv ))
		
			dbSelectArea("PAX")
			PAX->(dbSetOrder(1)) //PAX_FILIAL+PAX_MAT
			if ( dbSeek(xFilial("PAX") + PA2->PA2_CODTEC ))
	
				if alltrim(cTipo) == "TECNICO"
					cPath := CurDir()+"agendamento\solicitacao_domicilio_tecnico.html"
				endif				
	
				oHtml := TWFHtml():New(cPath) 
		
				oHtml:ValByName("pa0.nome"			, {})
				oHtml:ValByName("pa2.tecnico"		, {}) 
				oHtml:ValByName("pax.cpftec"		, {}) 
				oHtml:ValByName("pa2.data"			, {}) 
				oHtml:ValByName("pa0.horaag"		, {}) 
				oHtml:ValByName("pa0.endereco"		, {})  
		
				aadd(oHtml:ValByName("pa0.nome"		), cNomeCli			)
				aadd(oHtml:ValByName("pa2.tecnico"	), PA2->PA2_NOMTEC	)
				aadd(oHtml:ValByName("pax.cpftec"	), PAX->PAX_CPF		)
				aadd(oHtml:ValByName("pa2.data"		), PA2->PA2_DATA	)
				aadd(oHtml:ValByName("pa0.horaag"	), chrAgen			)
				aadd(oHtml:ValByName("pa0.endereco"	), cEnd				)
				
				cLinkEmail := '<a href="mailto:cancelamento.externa@certisign.com.br">cancelamento.externa@certisign.com.br</a>'
				
			endif
		
		endif			
		
	Case cTipo == "FINALIZA"
	
		if alltrim(cTipo) == "FINALIZA"
			cPath := CurDir()+"agendamento\solicitacao_domicilio_validacao.html"
		endif		
		
		oHtml := TWFHtml():New(cPath) 	
		oHtml:ValByName("pa0.nome"         , {})
		
		aadd(oHtml:ValByName("pa0.nome"     )      , cNomeCli)
		
	Case cTipo == "CANCELA"
	
		if alltrim(cTipo) == "CANCELA"
			cPath := CurDir()+"agendamento\solicitacao_domicilio_cancelamento.html"
		endif		
		
		oHtml := TWFHtml():New(cPath) 	
		oHtml:ValByName("pa0.nome"         , {})
		oHtml:ValByName("pa2.data"         , {}) 
		oHtml:ValByName("pa0.horaag"         , {}) 
		oHtml:ValByName("pa0.endereco"         , {})
		
		aadd(oHtml:ValByName("pa0.nome"     )      , cNomeCli)
		aadd(oHtml:ValByName("pa2.data"     )      , PA2->PA2_DATA)
		aadd(oHtml:ValByName("pa0.horaag"     )      , chrAgen)
		aadd(oHtml:ValByName("pa0.endereco"     )      , cEnd) 
		
End Case

//-------------------------------------------------------------
// Legado: ler o arquivo HTML para formar o corpo do e-mail.
// Realizado ajuste de validacao de type para evitar error.log
// @autor: Douglas Parreja
// @Since: 10/05/2017
//-------------------------------------------------------------   
if type( "oHtml" ) <> "U" 
	if type( "oHtml" ) == "O"
		oHtml:SaveFile(CurDir()+"\agendamento\"+cOrdemSrv+"_"+cTipo+".htm")
	endif
endif

If File( CurDir()+"\agendamento\"+cOrdemSrv+"_"+cTipo+".htm" )
	FT_FUSE( CurDir()+"\agendamento\"+cOrdemSrv+"_"+cTipo+".htm" )
	FT_FGOTOP()
	While .NOT. FT_FEOF()
		cLine := FT_FREADLN()
		
		If At( '__email_retorno__', cLine ) > 0
			cLine := StrTran( cLine, '__email_retorno__', cLinkEmail )
		Endif
		
		If cTipo == 'PAGAMENTO' .AND. cNumPedido == '__cNumPedido__'
			If At( 'Nº Pedido(s):', cLine ) > 0
				cLine := StrTran( cLine, 'Nº Pedido(s):', '' )
			Elseif At( '__cNumPedido__', cLine ) > 0
				cLine := StrTran( cLine, '__cNumPedido__', '' )
			Endif
		Endif
		
		cBody += cLine 
		FT_FSKIP()
	End
	FT_FUSE()
Endif

If File(cAnexo) 
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cBody ATTACHMENT cAnexo RESULT lResulSend
Else
	SEND MAIL FROM cDe TO cPara BCC cCopyOcult SUBJECT cAssunto BODY cBody  ATTACHMENT RESULT lResulSend
EndIf

If !lResulSend
  GET MAIL ERROR cError
  lRet := MSGYESNO( "Não foi possivel enviar o E-Mail de confirmação! Deseja prosseguir assim mesmo?", "Envio de E-mail" )
Else
  lRet := .T.
Endif

DISCONNECT SMTP SERVER
Return lRet
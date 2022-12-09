#Include "Rwmake.ch"
#include "AP5MAIL.ch"

/*
* Manutencao na Data do Limite do Orçamento
* R.Cavalini Informatica
* Ricardo Cavalini --> 17/07/2004 
*/
User Function Arlborc()

// tratamento para a empresa AEM - 
	If SM0->M0_CODIGO == "02"
		U_Arlborca()
		return()
	endif

	Dbselectarea("SC5")
	DbsetOrder(1)

	aRotina:={{"Pesquisar"   ,"AxPesqui"   ,0,1},;
		{"Ajusta Vcto" ,"U_Arsjdt()" ,0,4}}

	mBrowse( 6,1,22,75,"SC5",,,,,,,,)

	Dbselectarea("SC5")
	DbSetOrder(1)

return

/*
Função de ajuste de data limite. 
*/
User Function Arsjdt()
	_cNum         := SC5->C5_NUM
	_cNumCli      := SC5->C5_CLIENTE+"/"+SC5->C5_LOJACLI+" - "+SC5->C5_NOMCLI
	_dEmis        := SC5->C5_EMISSAO
	_clib         := SC5->C5_VRLIB
	_dDtCol       := SC5->C5_VRDTCOL
	_cHrCol       := SC5->C5_VRHRCOL
	_cColet       := SC5->C5_VRCOLET
	_cConh        := SC5->C5_VRCONH
	_cPende       := SC5->C5_X_PENDE

// 2º etapa
	_cBanco       := SC5->C5_BANCO
	_cTransp      := SC5->C5_TRANSP
	_cVolume      := SC5->C5_VOLUME1
	_cEspecie     := SC5->C5_ESPECI1
	_nPLiq        := SC5->C5_PESOL
	_nPBrut       := SC5->C5_PBRUTO
	_cNmTra       := Posicione("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_NOME")

	IF EMPTY(SC5->C5_V_CONT)
		_cMailTr      := Posicione("SA1",1,XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1__EMAILC")
	ELSE
		_cMailTr      := Posicione("SU5",1,XFILIAL("SU5")+SC5->C5_V_CONT,"U5_EMAIL"  )
	ENDIF

	_cCdCont      := Posicione("SUA",8,XFILIAL("SUA")+SC5->C5_NUM,"UA_CODCONT")
	_cNmCont      := Posicione("SUA",8,XFILIAL("SUA")+SC5->C5_NUM,"UA_DESCNT" )
	_cMailTX      := Posicione("SU5",1,XFILIAL("SU5")+_cCdCont   ,"U5_EMAIL"  )
	_cNmDDD       := Posicione("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_DDD")
	_cNmTel       := Posicione("SA4",1,XFILIAL("SA4")+SC5->C5_TRANSP,"A4_TEL")
	_dDtNF        := Posicione("SF2",1,XFILIAL("SF2")+SC5->(C5_NOTA+C5_SERIE),"F2_EMISSAO")
	_cusuar       := substr(cusuario,7,15)
	_cNSENF       := SC5->C5_SERIE+"/"+SC5->C5_NOTA
	_cNmPVC       := SC5->C5_PEDCLI
	_mCombo       := {"A=Assitencia","F=Fatura","P=Pendente","S=Saida"}

// montgem de tela .....
	@ 000,000 To 290,610 Dialog oDlg0 Title "Pedido de Vendas."
	@ 010,005 SAY "Pedido :"
	@ 010,040 Get _cNum SIZE 40,10 When .F.
	@ 010,085 SAY "Cliente :"
	@ 010,125 Get _cNumCli SIZE 150,10 When .F.
	@ 025,005 SAY "Serie/NF:"
	@ 025,040 Get _cNSENF SIZE 40,10 When .F.
	@ 025,085 SAY "Email :"

	IF EMPTY(ALLTRIM(_cMailTX)) .OR. ALLTRIM(_cMailTX) == "."
		_cMailT := _cMailTr + space(35)
	ELSE
		_cMailT := _cMailTX  + space(35)
	ENDIF

	@ 025,125 Get _cMailT              SIZE 150,10
	@ 040,005 Say "Data Emissao"
	@ 040,060 Say "Liberado"
	@ 040,130 Say "Dt Coleta"
	@ 040,210 Say "Hora Coleta"
	@ 050,005 Get _dEmis                             SIZE 40,10 When .F.
	@ 050,055 Combobox _CLIB Items _mCombo           Size 55,10   //@ 050,055 Get _CLIB Picture "@!"                 SIZE 40,10
	@ 050,130 Get _dDtCol                            SIZE 50,10
	@ 050,210 Get _cHrCol Picture "99:99:99"         SIZE 30,10

	@ 065,005 Say "Coleta:"
	@ 065,040 Get _cColet Picture "@!"               SIZE 250,10

	@ 080,005 Say "Pendencia:"
	@ 080,040 Get _cPende Picture "@!"               SIZE 250,10

	@ 095,005 Say "Transp"
	@ 095,040 Get _cTransp f3 'SA4CLT'               				SIZE 030,10
	@ 095,080 Get _cNmTra                            				SIZE 150,10 When .f.
	@ 095,245 Get IIF(EMPTY(_cNmDDD),_cNmTel,_cNmDDD+"-"+_cNmTel)   SIZE 060,10 When .f.

	@ 110,005 Say "P.Liq"
	@ 110,030 Get _nPLiq  Picture "@R 9999.9999"         SIZE 30,10

	@ 110,085 Say "P.Brut"
	@ 110,105 Get _nPBrut Picture "@R 9999.9999"         SIZE 30,10

	@ 110,170 Say "Volume"
	@ 110,195 Get _cVolume Picture "@E 99,999"           SIZE 30,10

	@ 110,245 Say "Especie"
	@ 110,270 Get _cEspecie                              SIZE 30,10

	@ 124,015 BmpButton Type 1 Action _ArsDtOk()
	@ 124,200 BmpButton Type 2 Action _ArsFech()
	Activate Dialog oDlg0 Centered
return

/*
Função de sair da tela de ajuste de data limite.
*/
Static Function _ArsDtOk()
	Private cSepara := ""
	Private cEmbala := ""
	Private cConfer := ""
	Private cDadosI := ""

	If SM0->M0_CODIGO == "01"
		cSepara := SC5->C5_XASEPAR
		cEmbala := SC5->C5_XAEMBAL
		cConfer := SC5->C5_XACONFE
		cDadosI := SC5->C5_XDADOSI //Space(250)
	EndIf

	If _clib == "P" .AND. Empty(alltrim(_cPende))
		MsgAlert("Favor preencher o campo de PENDENCIA...","Campo Pendencia")
		return
	Endif

	@ 000,000 To 290,610 Dialog oDlgX Title "Pedido de Vendas."

	@ 010,005 Say "Separado por:"
	@ 010,045 Get cSepara Picture "@!"               SIZE 250,10 WHEN IIf(Empty(cSepara),.T.,.F.)

	@ 025,005 Say "Embalado por:"
	@ 025,045 Get cEmbala Picture "@!"               SIZE 250,10 WHEN IIf(Empty(cEmbala),.T.,.F.)

	@ 040,005 Say "Conferido por:"
	@ 040,045 Get cConfer Picture "@!"               SIZE 250,10 WHEN IIf(Empty(cConfer),.T.,.F.)

	@ 055,005 Say "Dados Importantes:"
//@ 055,050 Get cDadosI Picture "@!"               SIZE 250,10 
	oTMultiget1 := tMultiget():new( 55, 55, {| u | if( pCount() > 0, cDadosI := u, cDadosI ) }, ;
		oDlgX, 240, 70, , , , , , .T. )

	@ 090,015 BmpButton Type 1 Action TOkDx()
	@ 110,015 BmpButton Type 2 Action oDlgX:End()
	Activate Dialog oDlgX Centered


// Envio de Email
	IF !EMPTY(SC5->C5_NOTA)
		If MSGNOYES("Deseja enviar email para o Cliente?")

			IF EMPTY(_cMailT)
				MSGALERT("Campo de email esta vazio... Mensagem não será enviada !!!")

				// usuario da coleta
				Dbselectarea("SC5")
				Reclock("SC5",.F.)
				SC5->C5_USRCLT   := _cusuar
				MsUnlock("SC5")

				Close(oDlg0)
				Return
			ENDIF

			// funcao de envio de email
			MailClt(_cMailT)

		Endif

		// usuario da coleta
		Dbselectarea("SC5")
		Reclock("SC5",.F.)
		SC5->C5_USRCLT   := _cusuar
		MsUnlock("SC5")
	ENDIF

// envia email de pendencia para os operadores
	If _clib == "P"

		// Acha Operador - no call center
		DbSelectArea("SUA")
		DbSetOrder(8)
		If DbSeek(xFilial("SUA")+SC5->C5_NUM)
			__CDOPEX := SUA->UA_OPERADO

			// Pega Email no cadastro de operador
			DbSelectArea("SU7")
			DbSetOrder(1)
			DBGOTOP()
			if Dbseek("  "+__CDOPEX)
				_cMailX := SU7->U7_X_EMAIL

				if !Empty(alltrim(_cMailX))
					MailPen(_cMailx,_cPende)
				else
					MsgAlert("Nao foi localizado o Vendedor. Favor informar via PSI !!!!")
				endif
			Else
				MsgAlert("Nao foi localizado o Vendedor. Favor informar via PSI !!!!")
			Endif
		Else
			MsgAlert("Nao foi localizado o Pedido de Vendas. Favor informar o vendedor via PSI !!!!")
		Endif
	Endif

	Close(oDlg0)

Return

// botao para fechar a tela
Static function _ArsFech()
	Close(oDlg0)
Return


Static Function TOkDx()

	oDlgX:End()
	//Close(oDlgX)

	Dbselectarea("SC5")
	Reclock("SC5",.F.)
	SC5->C5_VRLIB   := _clib
	SC5->C5_VRDTCOL := _dDtCol
	SC5->C5_VRHRCOL := _cHrCol
	SC5->C5_VRCOLET := _cColet
	SC5->C5_TRANSP  := _cTransp
	SC5->C5_PESOL   := _nPLiq
	SC5->C5_PBRUTO  := _nPBrut
	SC5->C5_VOLUME1 := _cVolume
	SC5->C5_ESPECI1 := _cEspecie
	SC5->C5_X_PENDE := _cPende

	If SM0->M0_CODIGO == "01"
		SC5->C5_XASEPAR := cSepara
		SC5->C5_XAEMBAL := cEmbala
		SC5->C5_XACONFE := cConfer
		SC5->C5_XDADOSI := cDadosI
	EndIf

	MsUnlock("SC5")

Return


// funcao de envio de mensagem ao cliente - coleta
Static Function MailClt(_cMailT)
	nOpcao := 0
	aArea       := GetArea()
	lOk         := .F.		// Variavel que verifica se foi conectado OK
	lAutOk      := .F.
	lSendOk     := .F.		// Variavel que verifica se foi enviado OK
	cMailConta  := AllTrim(GetNewPar("MV_RELACNT"," "))
	cMailServer := AllTrim(GetNewPar("MV_RELSERV"," "))
	cMailSenha  := AllTrim(GetNewPar("MV_RELPSW" ," "))
	lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
	cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cMailConta)) //Usuário para Autenticação no Servidor de Email
	cSenhAut    := Alltrim(GetMv("MV_RELAPSW",,cMailSenha)) //Senha para Autenticação no Servidor de Email
	nTimeOut    := GetMv("MV_RELTIME",,240)                 //Tempo de Espera antes de abortar a Conexão
	cEmailTo    := _cMailT
	cEmailCC    := ""


// Tratamento de envio atraves do correio
	__ctrans := GETMV("MV_CORREIO")
	IF _cTransp == __ctrans

		IF EMPTY(SC5->C5_NOTA)
			cAssunto    := PadR("Coleta - Pedido de vendas "+SC5->C5_NUM,120)
		ELSE
			cAssunto    := PadR("Coleta - Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE,120)
		ENDIF

		cMensagem   := " "
		cAttach     := " "
		lAciTM0     := .f.

		IF VAL(SUBSTR(Time(),1,2)) <=  12
			cMensagem   := "Bom Dia,  "+_cNmCont
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += SC5->C5_NOMCLI
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ELSEIF VAL(SUBSTR(Time(),1,2)) > 12 .OR. VAL(SUBSTR(Time(),1,2)) <= 18
			cMensagem   := "Boa Tarde,  "+_cNmCont
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += SC5->C5_NOMCLI
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ELSEIF VAL(SUBSTR(Time(),1,2)) >=  18
			cMensagem   := "Boa Noite,  "+_cNmCont
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += SC5->C5_NOMCLI
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ENDIF

		IF !EMPTY(_cNmPVC)
			cMensagem   += "Informamos que seu pedido Nr. "+_cNmPVC+" foi postado hoje por sedex."
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += "Para acompanhar clique neste link http://www.correios.com.br/servicos/rastreamento/rastreamento.cfm e "
			cMensagem   += "digite o código "+SUBSTR(_CCOLET,1,AT(" ",_CCOLET))
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ELSE
			cMensagem   += "Informamos que seu do pedido foi postado hoje por sedex."
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += "Para acompanhar clique neste link http://www.correios.com.br/servicos/rastreamento/rastreamento.cfm e "
			cMensagem   += "digite o código "+SUBSTR(_CCOLET,1,AT(" ",_CCOLET))
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ENDIF

		cMensagem   += "Obrigado pela preferência e confiança, nos colocamos a sua disposição para outros esclarecimentos."
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Atenciosamente,"
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SM0->M0_NOMECOM
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SM0->M0_ENDCOB+" - "+SM0->M0_CIDCOB+" - "+SM0->M0_ESTCOB
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "TEL.: "+SUBSTR(SM0->M0_TEL,2,3)+" "+SUBSTR(SM0->M0_TEL,5,8)+" - FAX: "+SUBSTR(SM0->M0_FAX,2,3)+" "+SUBSTR(SM0->M0_FAX,5,8)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMVEN
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_EMAIL")
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " E_mail gerado automaticamente. Favor não responder. "

	ELSE

		IF EMPTY(SC5->C5_NOTA)
			cAssunto    := PadR("Coleta - Pedido de vendas "+SC5->C5_NUM,120)
		ELSE
			cAssunto    := PadR("Coleta - Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE,120)
		ENDIF
		cMensagem   := " "
		cAttach     := " "
		lAciTM0     := .f.

		IF VAL(SUBSTR(Time(),1,2)) <=  12
			cMensagem   := "Bom Dia,  "+_cNmCont
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += SC5->C5_NOMCLI
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ELSEIF VAL(SUBSTR(Time(),1,2)) > 12 .OR. VAL(SUBSTR(Time(),1,2)) <= 18
			cMensagem   := "Boa Tarde,  "+_cNmCont
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += SC5->C5_NOMCLI
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ELSEIF VAL(SUBSTR(Time(),1,2)) >=  18
			cMensagem   := "Boa Noite,  "+_cNmCont
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += SC5->C5_NOMCLI
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ENDIF

		IF !EMPTY(_CNMPVC)
			cMensagem   += "Informamos que seu pedido nr. "+_CNMPVC+"foi coletado em "+dtoc(_dDtCol)+" as "+_cHrCol+", pela Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE+", emitada em "+dtoc(_dDtNF)+"."
		ELSE
			cMensagem   += "Informamos que seu pedido, foi coletado em "+dtoc(_dDtCol)+" as "+_cHrCol+", pela Nota Fiscal de Saida/Serie "+SC5->C5_NOTA+"/"+SC5->C5_SERIE+", emitada em "+dtoc(_dDtNF)+"."
		ENDIF

		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Transportadora :"+_cNmTra+"    Telefone: "+IIF(EMPTY(_cNmDDD),_cNmTel,_cNmDDD+"-"+_cNmTel)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Dados da coleta: "
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Peso Liquido "+Transform(_nPLiq, "@R 9999.9999")
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Peso Bruto "+Transform(_nPBrut, "@R 9999.9999")
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Volume "+Transform(_cVolume, "@R 99,9999")
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Especie "+_cEspecie
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)

		IF !EMPTY(_cColet)
			cMensagem   += "Observação "
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += _cColet
			cMensagem   += " "+chr(13)+chr(10)
			cMensagem   += " "+chr(13)+chr(10)
		ENDIF
		cMensagem   += "Obrigado pela preferência e confiança, nos colocamos a sua disposição para outros esclarecimentos."
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "Atenciosamente, "
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SM0->M0_NOMECOM
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SM0->M0_ENDCOB+" - "+SM0->M0_CIDCOB+" - "+SM0->M0_ESTCOB
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += "TEL.: "+SUBSTR(SM0->M0_TEL,2,3)+" "+SUBSTR(SM0->M0_TEL,5,8)+" - FAX: "+SUBSTR(SM0->M0_FAX,2,3)+" "+SUBSTR(SM0->M0_FAX,5,8)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += SC5->C5_NOMVEN
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_VEND1,"A3_EMAIL")
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " "+chr(13)+chr(10)
		cMensagem   += " E_mail gerado automaticamente. Favor não responder."
	ENDIF


//Verifica se existe o SMTP Server
	If 	Empty(cMailServer)
		Help(" ",1,"ATENCAO",,"O Servidor de SMTP nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELSERV).",4,5)
		RestArea(aArea)
		Return
	EndIf

//Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		Help(" ",1,"ATENCAO",,"A Conta do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELACNT).",4,5)
		RestArea(aArea)
		Return
	EndIf

//Verifica se existe a Senha
	If 	Empty(cMailSenha)
		Help(" ",1,"ATENCAO",,"A Senha do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELPSW).",4,5)
		RestArea(aArea)
		Return
	EndIf

// Envia e-mail com os dados necessarios
	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nTimeOut RESULT lOk
		If !lAutOk
			If lSmtpAuth
				lAutOk := MailAuth(cUserAut,cSenhAut)
				If !lAutOk
					Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autenticação do Usuário no Provedor de E-mail - Arlborc"),{"Ok"})
					RestArea(aArea)
					DISCONNECT SMTP SERVER
					// Return ==> COMENTADO
				Endif
			Else
				lAutOk := .T.
			EndIf
		EndIf
		If lOk .and. lAutOk
			SEND MAIL FROM "vendas@verion.com.br"; //"comercialagricola@verion.com.br"
			TO cEmailTo;
				CC cEmailcc;
				SUBJECT Trim(cAssunto);
				BODY cMensagem;
				RESULT lSendOk
			If !lSendOk
				Help(" ",1,"ATENCAO",,"Erro no envio de Email",4,5)
			EndIf
		Else
			Help(" ",1,"ATENCAO",,"Erro na conexao com o SMTP Server",4,5)
		EndIf
		DISCONNECT SMTP SERVER
	EndIf

	RestArea(aArea)
Return

// ========================= envia email de pendencia =======================
// funcao de envio de mensagem ao cliente - PENDENCIA
Static Function MailPen(_cMailX,_CPendX )
	nOpcao      := 0
	aArea       := GetArea()
	lOk         := .F.		// Variavel que verifica se foi conectado OK
	lAutOk      := .F.
	lSendOk     := .F.		// Variavel que verifica se foi enviado OK
	cMailConta  := AllTrim(GetNewPar("MV_RELACNT"," "))
	cMailServer := AllTrim(GetNewPar("MV_RELSERV"," "))
	cMailSenha  := AllTrim(GetNewPar("MV_RELPSW" ," "))
	lSmtpAuth   := GetMv("MV_RELAUTH",,.F.)
	cUserAut    := Alltrim(GetMv("MV_RELAUSR",,cMailConta)) //Usuário para Autenticação no Servidor de Email
	cSenhAut    := Alltrim(GetMv("MV_RELAPSW",,cMailSenha)) //Senha para Autenticação no Servidor de Email
	nTimeOut    := GetMv("MV_RELTIME",,240)                 //Tempo de Espera antes de abortar a Conexão
	cEmailTo    := _cMailX
	cEmailCC    := ""
	cAssunto    := PadR("Pendencia - Pedido de vendas "+SC5->C5_NUM,120)
	cMensagem   := " "
	cAttach     := " "
	lAciTM0     := .f.

// MESAGEM QUE DEVE SAIR NO EMAIL....
	cMensagem   += "Informamos que seu pedido Nr. "+SC5->C5_NUM+", esta como status de Pendencia, devido: "
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += _cPendX
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += "Atenciosamente,"
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += SM0->M0_NOMECOM
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " "+chr(13)+chr(10)
	cMensagem   += " E_mail gerado automaticamente. Favor não responder. "


//Verifica se existe o SMTP Server
	If 	Empty(cMailServer)
		Help(" ",1,"ATENCAO",,"O Servidor de SMTP nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELSERV).",4,5)
		RestArea(aArea)
		Return
	EndIf

//Verifica se existe a CONTA 
	If 	Empty(cMailConta)
		Help(" ",1,"ATENCAO",,"A Conta do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELACNT).",4,5)
		RestArea(aArea)
		Return
	EndIf

//Verifica se existe a Senha
	If 	Empty(cMailSenha)
		Help(" ",1,"ATENCAO",,"A Senha do email nao foi configurado."+Chr(13)+"Verifique o parametro (MV_RELPSW).",4,5)
		RestArea(aArea)
		Return
	EndIf

// Envia e-mail com os dados necessarios
	If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha)
		CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha TIMEOUT nTimeOut RESULT lOk
		If !lAutOk
			If lSmtpAuth
				lAutOk := MailAuth(cUserAut,cSenhAut)
				If !lAutOk
					Aviso(OemToAnsi("Atencao"),OemToAnsi("Falha na Autenticação do Usuário no Provedor de E-mail - Arlborc"),{"Ok"})
					RestArea(aArea)
					DISCONNECT SMTP SERVER
					// Return ==> COMENTADO
				Endif
			Else
				lAutOk := .T.
			EndIf
		EndIf
		If lOk .and. lAutOk
			SEND MAIL FROM "Almoxarifado"; //"comercialagricola@verion.com.br"
			TO cEmailTo;
				CC cEmailcc;
				SUBJECT Trim(cAssunto);
				BODY cMensagem;
				RESULT lSendOk
			If !lSendOk
				Help(" ",1,"ATENCAO",,"Erro no envio de Email",4,5)
			EndIf
		Else
			Help(" ",1,"ATENCAO",,"Erro na conexao com o SMTP Server",4,5)
		EndIf
		DISCONNECT SMTP SERVER
	EndIf

	RestArea(aArea)
Return

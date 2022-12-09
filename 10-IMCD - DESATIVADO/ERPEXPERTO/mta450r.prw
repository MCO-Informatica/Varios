#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA450R  ºAutor  ³ Junior Carvalho     ºData ³ 04/02/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado no botao Rejeita na analise de  º±±
±±º          ³ credito do pedido para pedir confirmacao do usuario        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA450                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA450R()

	Local _aAreas 	:= {SC5->(getArea()), SC9->(getArea())}
	Local cMsg := ""
	Private _cObs     := " "
	Private _lOk := .F.

	_lOk := DEFMENS(SC9->C9_PEDIDO)
	IF _lOk
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"Credito Rejeitado - MTA450R",ALLTRIM(_cObs),SC9->C9_ITEM)

		SC5->(RecLock("SC5", .F.))
		SC5->C5_LIBCRED := " "
		SC5->( msUnlock() )

		cEmailPa := Alltrim(POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))
		cEmailCC := Alltrim(UsrRetMail(__cUserID))
		lDispMail := .T.

		IF !Empty(cEmailPa) .or. !Empty(cEmailCC)
			cStatus := " Credito Rejeitado "
			cTextoEmail := SC5WF(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_NOMECLI,SC5->C5_LOJACLI, _cObs, cStatus)

			cAssunto := "Pedido de Venda " + ALLTRIM(SC5->C5_NUM) + cStatus

			lEmail := U_ENVMAILIMCD(cEmailPa,cEmailCC," ",cAssunto,cTextoEmail,{},lDispMail)

			cMsg := ""

			If !lEmail
				cMsg := "E-mail não enviado. Falha no envio do email."
				MsgInfo( cMsg,"PE MTA450R")
			else
				cMsg := "E-mail enviado, Para: "+cEmailPa+" e com copia: "+cEmailCC
				MsgInfo( cMsg,"PE MTA450R")
			
			Endif
					
			U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"ENVIO EMAIL-MTA450R",cMsg)

		ENDIF

	ENDIF

	//---------------------------------------------------
	//Realiza o posicionamento no pedido de venda
	//para realizar de reprovação (deixar a legenda pink)
	//----------------------------------------------------
	if SC5->( dbSeek( xFilial("SC5") + SC9->C9_PEDIDO ) )

		if SC5->C5_X_REP != "R"
			U_A440REPR("SC5",SC5->(recno()),1,,.T., .T.,_cObs)
		endif
		
	endif


	aEval(_aAreas, {|aArea|restArea(aArea)})
	aSize(_aAreas,0)

Return(NIL)



/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFunção    ³ DEFMENS  º Autor ³ Paulo - ADV Brasil º Data ³  07/10/09   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Função para digitação de informações após a 1a. liberação  º±±
	±±º          ³ do pedido de venda                                         º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Específico MAKENI                                          º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function DefMens(_cPedVen)

	Local _aArea    := GetArea()
	Local nReg		:= SC5->(Recno())
	Private _oDlg
	Private _lOk      := .F.

	DEFINE MSDIALOG _oDlg TITLE "Pedido de Venda "+_cPedVen+" Rejeitado " FROM 0,0 TO 400,600 PIXEL

	@ 30,10 TO 200,300 LABEL "Observações: (máximo 500)" PIXEL OF _oDlg

	@ 38,16 GET _oObs Var _cObs MEMO Size 280,155 PIXEL OF _oDlg 

	ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg, {|| if( VerObs(_cObs),(_lOk := .T., _oDlg:End()),nil) },;
		{|| if( VerObs(_cObs),(_lOk := .T., _oDlg:End()),nil) },,,,,.F.,.F.,.F.,)

	RestArea(_aArea)

	SC5->(dbGoto(nReg))

Return _lOK

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºFunção    ³ VEROBS   º Autor ³ Paulo - ADV Brasil º Data ³  07/10/09   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Função que verifica o tamanho de caracteres digitados nas  º±±
	±±º          ³ observações do cliente no pedido de venda                  º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ Específico MAKENI                                          º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function VerObs(cObs)
Local lRet := .T.

	If empty(cObs)
		MsgAlert("A observação é obrigatoria!","Atenção")
		lRet := .F.
	Endif
	
	If Len(cObs) > 500
		MsgAlert("O conteúdo da observação deverá conter no máximo 500 caracterers. Você digitou até o momento " + AlltTrim(Str(Len(cObs))) + " caracteres.","Atenção")
		lRet := .F.
	EndIf

Return lRet

Static Function SC5WF(cNum,cCliente,cNome,cLoja,cMotivo, nTipo)

Local cMensagem := ' '
Local cCli := cCliente+" - "+Alltrim(cNome)+" / "+Alltrim(cLoja) 
Local cEmpresa := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )
Local cMsg := IIF(nTipo == 1, " Aprovadado", " Reprovado")

cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
cMensagem += '<html xmlns="http://www.w3.org/1999/xhtml">'
cMensagem += '<head>'
cMensagem += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
cMensagem += '</head>'
cMensagem += '<body>'
cMensagem += '<style>'
cMensagem += 'div.a {'
cMensagem += '	text-align: center;'
cMensagem += '}'
cMensagem += '</style>'
cMensagem += '<div class ="a">'

cMensagem += '	<h1><center>PEDIDO DE VENDA '+Alltrim(cNum)+ cMsg  +' ! </center></h1>'
cMensagem += '</div>'
cMensagem += '<img src="https://www.imcdgroup.com/sites/default/files/IMCD-Logo-2015_Color_rgb_72dpi_250px.jpg"/></br>'
cMensagem += '</br>'
cMensagem += '<p>Pedido :<strong>'+Alltrim(cNum)+'</strong></p>'
cMensagem += '<p>Cliente : <strong>'+Alltrim(cCli)+'</strong></p>'
cMensagem += '<p>Status: <strong>'+cMsg+'</strong></p>'

cMensagem += '<style>'
cMensagem += 'div.b {'
cMensagem += '	text-align: center;'
cMensagem += '}'
cMensagem += '</style>'
cMensagem += '<div class ="b">'
cMensagem += '	<h1><center> Motivo </center></h1>'
cMensagem += '</div>'
cMensagem += '<table border="2">'
cMensagem += '<tbody>'
cMensagem += '<tr>'
cMensagem += '<td style="width: 1500px;">'+cMotivo+'</td>'
cMensagem += '</tr>'

cMensagem += '</tbody>'
cMensagem += '</table>'
cMensagem += '</br>'
cMensagem += '<p>EMPRESA :<strong>'+ cEmpresa + '</strong></p>'
cMensagem += '</body>'
cMensagem += '</html>'

Return(cMensagem)

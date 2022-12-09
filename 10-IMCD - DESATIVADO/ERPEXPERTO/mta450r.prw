#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA450R  �Autor  � Junior Carvalho     �Data � 04/02/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado no botao Rejeita na analise de  ���
���          � credito do pedido para pedir confirmacao do usuario        ���
�������������������������������������������������������������������������͹��
���Uso       � MATA450                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
				cMsg := "E-mail n�o enviado. Falha no envio do email."
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
	//para realizar de reprova��o (deixar a legenda pink)
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
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Fun��o    � DEFMENS  � Autor � Paulo - ADV Brasil � Data �  07/10/09   ���
	�������������������������������������������������������������������������͹��
	���Descricao � Fun��o para digita��o de informa��es ap�s a 1a. libera��o  ���
	���          � do pedido de venda                                         ���
	�������������������������������������������������������������������������͹��
	���Uso       � Espec�fico MAKENI                                          ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
/*/

Static Function DefMens(_cPedVen)

	Local _aArea    := GetArea()
	Local nReg		:= SC5->(Recno())
	Private _oDlg
	Private _lOk      := .F.

	DEFINE MSDIALOG _oDlg TITLE "Pedido de Venda "+_cPedVen+" Rejeitado " FROM 0,0 TO 400,600 PIXEL

	@ 30,10 TO 200,300 LABEL "Observa��es: (m�ximo 500)" PIXEL OF _oDlg

	@ 38,16 GET _oObs Var _cObs MEMO Size 280,155 PIXEL OF _oDlg 

	ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg, {|| if( VerObs(_cObs),(_lOk := .T., _oDlg:End()),nil) },;
		{|| if( VerObs(_cObs),(_lOk := .T., _oDlg:End()),nil) },,,,,.F.,.F.,.F.,)

	RestArea(_aArea)

	SC5->(dbGoto(nReg))

Return _lOK

/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	���Fun��o    � VEROBS   � Autor � Paulo - ADV Brasil � Data �  07/10/09   ���
	�������������������������������������������������������������������������͹��
	���Descricao � Fun��o que verifica o tamanho de caracteres digitados nas  ���
	���          � observa��es do cliente no pedido de venda                  ���
	�������������������������������������������������������������������������͹��
	���Uso       � Espec�fico MAKENI                                          ���
	�������������������������������������������������������������������������ͼ��
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
/*/

Static Function VerObs(cObs)
Local lRet := .T.

	If empty(cObs)
		MsgAlert("A observa��o � obrigatoria!","Aten��o")
		lRet := .F.
	Endif
	
	If Len(cObs) > 500
		MsgAlert("O conte�do da observa��o dever� conter no m�ximo 500 caracterers. Voc� digitou at� o momento " + AlltTrim(Str(Len(cObs))) + " caracteres.","Aten��o")
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

#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function A440MARG(nTipo) // nTipo 1 - libera / 2 Reprova
	Local cCodUser := RetCodUsr()
	Local cTitulo := "Pedido de Venda Gross Margin"
	Local cMsg := ''
	Local aAttach := {}

	Private _cObs     := " "

	if !EMPTY(SC5->C5_X_CANC)
		APMSGINFO("Pedido Cancelado.")
		Return()
	Endif

	if !EMPTY(SC5->C5_X_REP) .or. Alltrim(SC5->C5_CONTRA) == "XX"
		APMSGINFO("Pedido Reprovado.")
		Return()
	Endif

	If !EMPTY(SC5->C5_CONTRA)

		DbSelectArea("DA0")
		DbSetOrder(1)
		DbSeek(xfilial("DA0")+SC5->C5_TABELA)

		iF(nTipo == 3)

			if __CUSERID $ SUPERGETMV("ES_USERMFR", .T., "000390")
				lgrav := .F.

				if Empty(SC5->C5_USUAPR1) .or. Empty(SC5->C5_USUAPR2)
					if SC5->C5_USUAPR1 <> __CUSERID
						cMsg := "Aprovar o Risco de Fraude para o Pedido "+SC5->C5_NUM
						if DefMens(cMsg +" ?","Pedido de Venda - Risco de Fraude",nTipo )
							lgrav := .T.

							reclock("SC5", .F.)
							if Empty(SC5->C5_USUAPR1)
								SC5->C5_USUAPR1 := __CUSERID
							Elseif Empty(SC5->C5_USUAPR2)
								SC5->C5_USUAPR2 := __CUSERID
								SC5->C5_CONTRA := " "
							endif
							SC5->(msUnlock())
						endif

					else
						APMSGINFO("Usuário já Aprovou Risco de Fraude para esse Pedido."+CRLF;
							+"Os aprovadores precisam ser diferentes.")
					endif
				Else
					APMSGINFO("Pedido não está Bloqueado por RISCO")
					lgrav := .F.
				ENDIF

				if lgrav
					U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI, cMsg ,'', ,_cObs)
				endif

			else
				APMSGINFO("Usuário não autorizado para Aprovar Risco de Fraude  do Pedido.")
			endif

		elseIf (DA0->DA0_X_HEAD == cCodUser .or. DA0->DA0_X_MGR == cCodUser .or. ;
				iif(DA0->(fieldPos("DA0_X_CEO")) > 0, DA0->DA0_X_CEO == cCodUser, .F.)) .AND.;
				(Alltrim(SC5->C5_CONTRA) == "X" .OR. ALLTRIM(SC5->C5_CONTRA)== "Y")

			cMsg := IIF(nTipo == 1, "Aprovar", "Reprovar")
			lContinua := DefMens(cMsg + " a Gross Margin negativa para o Pedido "+SC5->C5_NUM+" ?",cTitulo,nTipo ) //  MsgYesNo("Deseja Reprovar o Pedido "+SC5->C5_NUM+" ?")

			If lContinua
				cMsg := IIF(nTipo == 1, "Aprovada GM ", "Reprovada GM ")
				reclock("SC5", .F.)
				IF(nTipo == 1)
					SC5->C5_CONTRA := " "
				ELSE
					SC5->C5_CONTRA := "XX"
					SC5->C5_X_REP  := "R"
				ENDIF

				SC5->(msUnlock())
				cEmail := POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")
				IF !Empty(cEmail)

					cAssunto := "Pedido de venda "+ ALLTRIM(SC5->C5_NUM) +" - "+cMsg
					cTextoEmail := SC5WF(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_NOMECLI,SC5->C5_LOJACLI,_cObs, nTipo)

					lEmail := U_ENVMAILIMCD(cEmail," "," ",,cTextoEmail,aAttach)

					If !lEmail
						MsgInfo("E-mail não enviado referente ao Pedido  "+SC5->C5_NUM+"  ","IMCD")
					Endif
				else
					cLog := "Enviado email para "+CRLF+cEmail+CRLF+DTOS(DATE())+TIME()
					U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI, cMsg ,'', ,_cObs + CRLF + cLog)

				ENDIF

				DesLibEst(SC5->C5_FILIAL,SC5->C5_NUM)
			Endif
		elseiF (nTipo == 4) .and. alltrim(SC5->C5_CONTRA) == 'CONS'
			if 	cCodUser $ GETMV("ES_BLQCONS")
				
				reclock("SC5", .F.)
				SC5->C5_CONTRA := " "
				SC5->(msUnlock())

				APMSGINFO("Pedido liberado!!!")
				cNomeUser := Alltrim(UsrRetName(__CUSERID))
				U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Liberado Consignado","Usuario:= "+cNomeUser,"")
			else
				APMSGINFO("Usuário não autorizado a liberar o Pedido.")
			endif
		Else
			APMSGINFO("Usuário não autorizado para Aprovar/Reprovação do Pedido.")
		Endif

	Endif

Return()


Static Function DefMens( cMotivo,cTitulo,nTipo )

// Variaveis da Funcao de Controle e GertArea/RestArea
	Local _oObs
	Local lRet := .F.
// Variaveis Private da Funcao
	Private oDlg				// Dialog Principal

	default  cTitulo := iif(nTipo == 3 ,"Risco de Fraude","Gross Margin")

	DEFINE MSDIALOG oDlg TITLE cTitulo FROM C(252),C(390) TO C(517),C(981) PIXEL STYLE DS_MODALFRAME

	@ C(005),C(013) Say cMotivo Size C(273),C(008) COLOR CLR_BLACK PIXEL OF oDlg
// Cria as Groups do Sistema
	@ C(020),C(010) TO C(110),C(285) LABEL "Observações: (máximo 500)" PIXEL OF oDlg
	@ C(030),C(016) GET _oObs Var _cObs MEMO Size C(264),C(076) PIXEL OF oDlg
// Cria Componentes Padroes do Sistema
	@ C(115),C(100) Button "Sim" Size C(037),C(012) PIXEL OF oDlg ACTION {|| if( VerObs(_cObs),(lRet := .T., oDlg:End()),nil)}
	@ C(115),C(150) Button "Não" Size C(037),C(012) PIXEL OF oDlg ACTION ( APMSGINFO("Operação cancelada!"),lRet := .F.,oDlg:End())


	ACTIVATE MSDIALOG oDlg CENTERED

Return lRet

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ?  C()   ?Autores ?Norbert/Ernani/Mansano ?Data ?0/05/2005³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ?Funcao responsavel por manter o Layout independente da       ³±?
±±?          ?resolucao horizontal do Monitor do Usuario.                  ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
	Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Tratamento para tema "Flat"?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFunção    ?VEROBS   ?Autor ?Paulo - ADV Brasil ?Data ? 07/10/09   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Função que verifica o tamanho de caracteres digitados nas  º±?
±±?         ?observações do cliente no pedido de venda                  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?Específico MAKENI                                          º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/

Static Function VerObs(cObs)
Local lRet :=  .T.

	If Len(cObs) > 500
	MsgAlert("O conteúdo da observação dever?conter no máximo 500 caracterers. Voc?digitou at?o momento " + AlltTrim(Str(Len(cObs))) + " caracteres.","Atenção")
	lRet :=  .F.
	EndIf

	If empty(cObs)
	MsgAlert("Antes de confirmar, digite a observação!","Atenção")
	lRet :=  .F.
	Endif

RETURN lRet

Static Function SC5WF(cNum,cCliente,cNome,cLoja,cMotivo, nTipo)

Local cMensagem := ' '
//Local nX
//Local nTotal  := 0
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


/*/{Protheus.doc} DesLibEst
Realiza o estorno da liberação.
@type function
@version 1.0
@author marcio.katsumata
@since 02/09/2020
@param cFilPar, character, filial
@param cPedido, character, pedido
@return nil, nil
/*/
Static Function DesLibEst(cFilPar,cPedido)

	Local cAliasQry as character
	Local cFilBkp	as character
	local aAreaSC6  as array

	aAreaSC6  := SC6->(getArea())
	cAliasQry := getNextAlias()
	cFilBkp	:= cFilAnt

	beginSql alias cAliasQry
		SELECT R_E_C_N_O_ REGSC9 
		FROM %table:SC9% SC9
		WHERE SC9.C9_FILIAL= %exp:xFilial("SC9",cFilPar)% AND 
		      SC9.C9_PEDIDO= %exp:cPedido%                AND 
			  SC9.C9_NFISCAL  = ''                        AND
			  SC9.%notDel%
	endSql

	cFilAnt		:= cFilPar
	SC5->(DbSetOrder(1))
	SC5->(DbSeek(cFilPar+cPedido))

	While (cAliasQry)->(!Eof())
		SC9->(DbGoTo((cAliasQry)->REGSC9))
		SC6->(DbSetOrder(1))
		if SC6->(DbSeek(cFilPar+cPedido+SC9->C9_ITEM))
			MaAvalSC6("SC6",4)
		endif
		(cAliasQry)->(DbSkip())
	EndDo

	(cAliasQry)->(dbCloseArea())

	cFilAnt		:= cFilBkp

	restArea(aAreaSC6)
	aSize(aAreaSC6,0)
Return

#INCLUDE "PROTHEUS.CH"
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

#DEFINE ITENSSC6 300

/* **************************************************************************
***Programa  *AFAT021   * Autor * Eneovaldo Roveri Jr.  * Data *20/11/2009***
*****************************************************************************
***Locacao   * Fabr.Tradicional *Contato *                                ***
*****************************************************************************
***Descricao * Reprovação do Pedido de Venda Formalmente                  ***
*****************************************************************************
***Parametros* _lAutomatico - Reprovação sem visualização, para rotinas   ***
***                          automáticas                                  ***
*****************************************************************************
***Retorno   * _lRet - .T. - Reprovado                                    ***
***          *         .F. - Não Reprovado                                ***
*****************************************************************************
***Aplicacao *                                                            ***
*****************************************************************************
***Uso       *                                                            ***
*****************************************************************************
***Analista Resp.*  Data  * Bops * Manutencao Efetuada                    ***
*****************************************************************************
***              *  /  /  *      *                                        ***
***              *  /  /  *      *                                        ***
************************************************************************** */


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Cancelar pedido de venda
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A440REPR(cAlias,nReg,nOpc,menuNil,_lAutomatico)

	Local aArea    := GetArea()
	//Local lValido  := .F.
	Local lContinua:= .T.
	Local _aVal    := {}
	Local _nReg9   := SC9->( recno() )
	Local _nReg6   := SC6->( recno() )
	local aUsersGI := {}
	local nPosUser := 0
	local cCodUsrGI := ""
	local cMailGI  := ""
	Local aAttach := {}
	Local cAssunto := ""	

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "A440REPR" , __cUserID )

	Private _cMotDaRep := space( len( SZ4->Z4_MOTIVO ) )
	Private _aUser := pswret()

	if _lAutomatico == NIL
		_lAutomatico := .f.
	endif

	if SC5->C5_X_CANC == "C"
		if .not. _lAutomatico
			APMSGINFO("Pedido Está Cancelado!")
		endif
		lContinua := .F.
	endif

	if SC5->C5_LIBEROK == "S" .or. SC9->( dbSeek( xFilial( "SC9" ) + SC5->C5_NUM ) )
		if .not. _lAutomatico
			lContinua := MsgYesNo("Pedido Possui Liberações! Continua?")
		else
			lContinua := .f.
		endif
	endif

	if lContinua
		if SC5->C5_X_REP == "R"
			if .not. _lAutomatico
				lContinua := MsgYesNo("Pedido ja está Reprovado! Continua?")
			else
				lContinua := .f.
			endif
		endif
	endif

	If SoftLock(cAlias) .and. lContinua

		//Visualização padrão do protheus
		//Retorno 1 significa que foi clicado em OK
		//Se foi clicado OK Continuar com o cancelamento
		if .not. _lAutomatico
			lContinua := ( a410Visual(cAlias,nReg,nOpc)==1 )
		endif

		if lContinua

			_aVal := U_A440CKPD( SC5->C5_NUM, (.not. _lAutomatico) ) //Numero do Pedido, .F. - para não exibir mensagens

			lContinua := A440RepOk( _aVal, _lAutomatico )

			If lContinua
				RecLock("SC5")
				SC5->C5_X_REP := "R"
				SC5->C5_CONTRA := SPACE(LEN(SC5->C5_CONTRA))
				if .not. empty( SC5->C5_LIBEROK )
					SC5->C5_LIBEROK := " "
				endif
				MsUnLock()	

				//------------------------------------------------
				//Envia e-mail para o vendedor do pedido de venda
				//------------------------------------------------
				cEmail := POSICIONE("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL")
		
				//---------------------------------------------------------------
				//Envia e-mail para o usuário que criou o pedido de venda
				//---------------------------------------------------------------
				aUsersGI := FwsFAllUsers()	
				if (nPosUser := aScan(aUsersGI, {|aUser| alltrim(aUser[3])==FWLeUserlg("C5_USERLGI", 1)})) > 0
					cCodUsrGI := aUsersGI[nPosUser][2]
					if !empty(cMailGI := UsrRetMail (cCodUsrGI)) .and. !(cMailGI $ cEmail)
						cEmail := alltrim(cEmail)
						cEmail += iif (!empty(cEmail),";", "")+cMailGI
					endif
				endif

				IF !Empty(cEmail)
					cStatus := "Reprovado "
					cTextoEmail := U_SC5WF1(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_NOMECLI,SC5->C5_LOJACLI,_cMotDaRep,cStatus)
					cAssunto := "Pedido de venda "+cStatus + ALLTRIM(SC5->C5_NUM)

					lEmail := U_ENVMAILIMCD(cEmail," "," ",cAssunto,cTextoEmail,aAttach)

					If !lEmail
						MsgInfo("E-mail não enviado referente ao Pedido  "+SC5->C5_NUM+"  ","IMCD")						
					Endif
				ENDIF


				SC9->( dbSeek( xFilial( "SC9" ) + SC5->C5_NUM ) )
				Do While .not. SC9->( Eof() ) .and. SC9->C9_FILIAL == xFilial( "SC9" ) .and. SC9->C9_PEDIDO == SC5->C5_NUM
					if empty( SC9->C9_NFISCAL )
						if SC6->( dbSeek( xFilial( "SC6" ) + SC9->C9_PEDIDO + SC9->C9_ITEM ) )
							RecLock( "SC6" )
							SC6->C6_QTDEMP := SC6->C6_QTDEMP - SC9->C9_QTDLIB
							if SC6->C6_QTDEMP < 0
								SC6->C6_QTDEMP := 0
							endif
						endif
						RecLock( "SC9" )
						SC9->( dbDelete() )
					endif
					SC9->( dbSkip() )
				EndDo

				//Gravar o LOG
				U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,"Reprovação",_cMotDaRep)

			EndIf
		EndIf
	EndIf

	SC6->( dbgoto( _nReg6 ) )
	SC9->( dbgoto( _nReg9 ) )
	MsUnLockAll()
	RestArea(aArea)
	aSize(aArea,0)
	aSize(aUsersGI,0)
Return


/********************************************************************************
Tela para digitar o motivo da reprovação e confirmar a reprovação do pedido.*
*********************************************************************************/
Static Function A440RepOk( _aVal, _lAutomatico )
	Local _lRet := .F. 
	Local _i    := 0
	Local _oDlg		// Tela 

	//Declaração de cVariable dos componentes
	Private _cMotivo := ""

	//Declaração de Variaveis Private dos Objetos
	SetPrvt("_oDlg","_oSay1","_oSay2","_oSay3","_oSay4","_oMotivo","_oSBtnOk","_oSBtnCancel")

	For _i := 1 to len( _aVal )

		if .not. _aVal[_i,2]
			_cMotivo += iif(empty(_cMotivo),"",",") + _aVal[_i,1]
			_lRet := .T.
		endif

	Next _i

	if len( SZ4->Z4_MOTIVO ) > len( _cMotivo )
		_cMotivo := _cMotivo + Space( len( SZ4->Z4_MOTIVO ) - len( _cMotivo )  )
	endif

	if .not. _lAutomatico

		//Definicao do Dialog e todos os seus componentes.
		_oDlg      := MSDialog():New( 089,232,374,1033,"Reprovação do Pedido",,,.F.,,,,,,.T.,,,.T. )
		_oSay1     := TSay():New( 032,010,{|| dtoc( dDataBase ) },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,068,008)
		_oSay2     := TSay():New( 032,080,{|| time() },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
		_oSay4     := TSay():New( 056,010,{|| _aUser[1][2] },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
		_oSay3     := TSay():New( 080,010,{||"Motivo da Reprovação:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
		_oMotivo   := TGet():New( 076,090,{|u| If(PCount()>0,_cMotivo:=u,_cMotivo)},_oDlg,310,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cMotivo",,)
		_oSBtnOk   := tButton():New( 104,320,"Ok",_oDlg,{|| iif( _ChkMot(_cMotivo),_lRet:=.T.,_lRet:=.F.), iif(_lRet,_oDlg:End(),_lRet:=.F.) },30,10,,,,.T.)
		_oSBtnCanc := tButton():New( 104,360,"Cancelar",_oDlg,{||_lRet:=.F.,_oDlg:End()},30,10,,,,.T.)

		_oDlg:Activate(,,,.T.)

	endif

	if _lRet
		//Atualizar variavel private declarada na função anterior para gravar o motivo do cancelamento
		//Posteriormente ver uma maneira mais adequada para fazer isto
		_cMotDaRep := _cMotivo
	endif

Return( _lRet )  

/*
Validar se o motivo foi digitado
*/ 
Static Function _ChkMot(_cMotivo)
	if Empty( _cMotivo )
		APMSGINFO( "O motivo do cancelamento deve ser informado!" )
		Return( .F. )
	endif
Return( .T. )


/************************************************
Validações gerais para poder cancelar um pedido *
************************************************/ 
Static Function A410ChkPed()
	Local _lRet     := .T.
	Local lLiber    := .F.
	Local lFaturado := .F.
	Local lContrat  := .F.
	Local _nReg     := SC6->( recno() )

	SC6->( dbSeek( SC5->C5_NUM ) )
	SC6->( dbSetOrder(1) )
	SC6->( MsSeek(xFilial("SC6")+SC5->C5_NUM) )
	Do While ( !SC6->(Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM )

		If ( SC6->C6_QTDEMP > 0 )
			lLiber := .T.
		EndIf

		If ( SC6->C6_QTDENT > 0 ) .Or. ( SC5->C5_TIPO $ "CIP" .And. !Empty(SC6->C6_NOTA) )
			lFaturado :=  .T.
		EndIf

		If !Empty(SC6->C6_CONTRAT) .And. !lContrat
			dbSelectArea("ADB")
			dbSetOrder(1)
			if MsSeek(xFilial("ADB")+SC6->C6_CONTRAT+SC6->C6_ITEMCON)
				If ADB->ADB_QTDEMP > 0 .And. ADB->ADB_PEDCOB == (cArqQry)->C6_NUM
					lContrat := .T.
				EndIf
			EndIf
			dbSelectArea("SC6")
		EndIf

		SC6->( dbSkip() )

	EndDo

	If ( lFaturado )
		MsgAlert( "Pedido de Venda Já Possui Faturamento." )
		_lRet := .F.
	EndIf
	If ( lLiber )
		MsgAlert( "Pedido Possui Itens Liberados." )
		_lRet := .F.
	EndIf
	If ( lContrat )
		Help(" ",1,"A410CTRPAR")
		_lRet := .F.
	EndIf

	SC6->( dbgoto( _nReg ) )
Return( _lRet )


User Function SC5WF1(cNum,cCliente,cNome,cLoja,cMotivo, cStatus)

Local cMensagem := ' '
Local cCli := Alltrim(cCliente)+"-"+Alltrim(cLoja) +": "+Alltrim(cNome)
Local cEmpresa := SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+" - "+ALLTRIM(SM0->M0_NOME)+" - "+ALLTRIM(SM0->M0_FILIAL )
Local cLogo := GETMV("MV_ENDLOGO")
Default cStatus := " "

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

cMensagem += '	<h1><center>PEDIDO DE VENDA '+Alltrim(cNum)+ cStatus  +' ! </center></h1>'
cMensagem += '</div>'

cMensagem += '<img alt="IMCD LOGO" class="img__src img__cover" src="'+cLogo+'" width="658" height="191"><br/><br/>'

cMensagem += '<p>Pedido : <strong>'+Alltrim(cNum)+'</strong></p>'
cMensagem += '<p>Cliente : <strong>'+Alltrim(cCli)+'</strong></p>'
cMensagem += '<p>Status: <strong>'+cStatus+'</strong></p>'

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

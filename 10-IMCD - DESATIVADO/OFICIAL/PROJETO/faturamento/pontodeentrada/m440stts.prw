#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³M440STTS  ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³25/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Depois de Liberar o Pedido de Venda Enviar email            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M440STTS()
	Local aArea 	:= GetArea()
	Local _lRet 	:= .T.
	Local _aVal 	:= {}
	Local nPosC9	:= 0
	Local lMexeu 	:= .F.
	Local nRegC5	:= 0
	Local cFiltro   := ""
	Local _i := 0
	Local nTotalPed := 0
	Local nSaldoLc := 0


	Private _cMotDaLib := space( len( SZ4->Z4_MOTIVO ) )

	If "C5_LIBEROK" $ SC5->(dbFilter())
		nRegC5 := SC5->(Recno())
		SC5->(dbClearFilter())
		lMexeu := .T.
	Endif

	_aVal :=ACLONE( U_A440CKPD( SC5->C5_NUM, .F., .T. ) )
	//parametros da A440CKPD ==> Numero do Pedido, .F. - para não exibir mensagens,
	//.T. indica que precisa retornar o array com os itens abaixo da margem de segurança

	For _i := 1 to len( _aVal[1] )
		if .not. _aVal[1,_i, 2 ]
			_lRet := .F.
		endif
	Next _i

	//abrir a tela de motivo, mesmo que nao tenha nenhum problema de validação,
	//caso deseje digitar um motivo

	//if .NOT. _lRet
	U_MotivoLib( _aVal, .T. )
	//endif

	IF !EMPTY(_cMotDaLib)
		U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Lib. Pedido M440STTS',_cMotDaLib)
	ENDIF

	//apagar itens da ZA4, caso existam de uma liberacao anterior do pedido, pois nesta nova liberacao um item
	//pode nao ter ficado abaixo da margem de seguranca:
	DbSelectArea("ZA4")
	DbSetOrder(1)

	nPosC9 := SC9->(Recno())
	DbSelectArea("SC6")
	DbSetorder(1)
	DbSeek(xfilial("SC6") + SC5->C5_NUM)
	Do While SC6->(!eof()) .and. SC6->C6_FILIAL + SC6->C6_NUM  == xfilial("SC6") + SC5->C5_NUM
		DbSelectArea("ZA4")
		If ZA4->(DbSeek(SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_PRODUTO))
			Reclock("ZA4")
			ZA4->(DbDelete())
			MsUnlock()
		Endif
		dbSelectArea("SC9")
		SC9->(dbSetOrder(1))
		SC9->(dbSeek(SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM))
		do WHile !Eof() .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM
			SC9->( RecLock("SC9",.F.) )
			SC9->C9_ENTREG := SC5->C5_XENTREG
			SC9->( MsUnlock() )
			dbSkip()
		Enddo
		DbSelectArea("SC6")
		SC6->(DbSkip())
	Enddo
	SC9->(dbGoto(nPosC9))

	//caso tenha itens nesta liberacao, abaixo da margem negativa, gravar na tab ZA4 para emitir relatorio de margem:
	If !_lRet
		if len(_aVal[2]) > 0

			DbSelectArea("ZA4")
			DbSetOrder(1)
			For _i := 1 to len(_aVal[2])
				cChave :=  _aVal[2, _i, 1] + _aVal[2, _i, 2] + _aVal[2, _i, 3] +_aVal[2, _i, 4] //fil+ pedido+iteped+produto
				If DbSeek(cChave)
					Reclock("ZA4")
					ZA4->(DbDelete())
					MsUnlock()
				Endif
				Reclock("ZA4",.t.)
				ZA4->ZA4_FILIAL := _aVal[2, _i, 1]
				ZA4->ZA4_PEDIDO := _aVal[2, _i, 2]
				ZA4->ZA4_ITEPED := _aVal[2, _i, 3]
				ZA4->ZA4_PROD   := _aVal[2, _i, 4]
				ZA4->ZA4_DATA   := date()
				ZA4->ZA4_HORA   := time()
				ZA4->ZA4_MSEG   := _aVal[2, _i, 6]
				ZA4->ZA4_VMSEG  := _aVal[2, _i, 7]
				ZA4->ZA4_PRCVEN := _aVal[2, _i, 5]
				ZA4->ZA4_MOTIVO := _cMotDaLib
				ZA4->ZA4_USUARIO := __cUserId
				MsUnlock()
			Next

		endif
	Endif

	//==========================================================================
	// Faz a analise de credito e realiza a liberação de credito automatica
	//==========================================================================

	DbSelectArea("SA1")
	DbSetOrder(1)

	if SA1->(Dbseek(xfilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
		
		xCampo := 'M2_MOEDA' + IIF( SA1->A1_MOEDALC>0,str(SA1->A1_MOEDALC,1),"")
		nSaldoLc := (SA1->A1_LC * SM2->(&xCampo)) - (SA1->A1_SALPEDL+SA1->A1_SALDUP )

		FOR _i := 1 To LEN( aCOLS )
			nTotalPed += aCOLS[_i , GDFieldPos( 'C6_VALOR' , aHeader)]
		NEXT _i

		IF SA1->A1_ATR <= 0 ;
				.AND. !( SC5->C5_CONDPAG $ "000|01 " ) ;
				.AND. (SA1->A1_RISCO == "B") .AND. SA1->A1_LC  > 0;
				.AND. (nSaldoLc - nTotalPed ) > 0

			DbSelectArea("SC6")
			DbSetorder(1)

			IF DbSeek(xfilial("SC6") + SC5->C5_NUM)
				dbSelectArea("SC9")
				SC9->(dbSetOrder(1))
				SC9->(dbSeek(SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM))


				do WHile !Eof() .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM

					SC9->( RecLock("SC9",.F.) )
					SC9->C9_BLCRED := " "
					SC9->( MsUnlock() )
					lGrvLib := .T.

					dbSkip()

				Enddo

				IF lGrvLib

					SC5->(RecLock("SC5", .F.))
					SC5->C5_LIBCRED := "X"
					SC5->( msUnlock() )

					//------------------------------------------------
					//Não permitir gravar a mensagem se já existir NF.
					//------------------------------------------------

					cSaldo := Transform( nSaldoLc ,PesqPict("SA1","A1_LC") )

					cmsg := 'Financeira - Cliente Risco ' +SA1->A1_RISCO+ " - Saldo do Limite de Credito "+ cSaldo

					U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI, "Liberacao Automatica",cMsg)

				ENDIF

				MAILMTA450()
			ENDIF
		ENDIF
	ENDIF

//==========================================================================

	If lMexeu
		cFiltro := "(SC5->C5_X_CANC != 'C' .and. SC5->C5_X_REP != 'R') .and. Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .AND. DTOS(C5_XENTREG) >= '20100301'"
		SC5->(MsFilter(cFiltro))
		SC5->(dbGoto(nRegC5))
	Endif

//----------------------------------------------------------------------------
//Alterado em 16/01/18 por Marcos Andrade
//Retirado o envio de email na liberacao
//----------------------------------------------------------------------------
//_lRet := U_AFAT023( SC5->C5_NUM, .F. ) //Num ped e .F. para acessar o outlook

	RestArea(aArea)
Return( _lRet )


/********************************************************************************
Tela para digitar o motivo da aprovação quando tem problemas de regras.     *
*********************************************************************************/
User Function MotivoLib( _aVal, _lValid )
	Local _lRet := .F.
	Local _i    := 0
	Local _oDlg		// Tela

	//Declaração de cVariable dos componentes
	Private _cMotivo := space( len( SZ4->Z4_MOTIVO ) )
	Private _cRegas  := ""

	//Declaração de Variaveis Private dos Objetos
	SetPrvt("_oDlg","_oSay1","_oSay2","_oSay3","_oSay4","_oMotivo","_oSBtnOk","_oSBtnCancel")

	For _i := 1 to len( _aVal[1] )

		if .not. _aVal[1,_i,2]
			if !(AllTrim(_aVal[1,_i,1]) $ AllTrim(_cRegas))
				_cRegas += iif(empty(_cRegas),"Regras Afetadas: ",",") + _aVal[1,_i,1]
			endif
		endif

	Next _i

	if len( SZ4->Z4_MOTIVO ) > len( _cMotivo )
		_cMotivo := _cMotivo + Space( len( SZ4->Z4_MOTIVO ) - len( _cMotivo )  )
	endif

	//Definicao do Dialog e todos os seus componentes.
	_oDlg      := MSDialog():New( 089,232,374,1033,"Liberação do Pedido "+SC9->C9_PEDIDO,,,.F.,,,,,,.T.,,,.T. )
	_oSay1     := TSay():New( 032,010,{|| _cRegas },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,310,008)
	_oSay4     := TSay():New( 056,010,{|| dDataBase },_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,292,008)
	_oSay3     := TSay():New( 080,010,{||"Observ. da Liberação:"},_oDlg,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,070,008)
	_oMotivo   := TGet():New( 076,090,{|u| If(PCount()>0,_cMotivo:=u,_cMotivo)},_oDlg,310,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","_cMotivo",,)
	_oSBtnOk   := tButton():New( 104,360,"Ok",_oDlg,{|| iif( _ChkMot(_cMotivo, _lValid),_lRet:=.T.,_lRet:=.F.), iif(_lRet,_oDlg:End(),_lRet:=.F.) },30,10,,,,.T.)
	//	_oSBtnCanc := tButton():New( 104,360,"Cancelar",_oDlg,{||_oDlg:End()},30,10,,,,.T.)

	_oDlg:Activate(,,,.T.)

	_cMotDaLib := _cMotivo

Return( _lRet )

/*
Validar se o motivo foi digitado
*/
Static Function _ChkMot(_cMotivo, _lValid)
	if Empty( _cMotivo ) .and. !_lValid
		APMSGINFO( "A Observação da Liberação deve ser informada!" )
		Return( .F. )
	endif
Return( .T. )

Static Function MAILMTA450()
	Local cContEnv  := Alltrim( SuperGetMV("ES_MAILAUD", ," ") )
	Local cCorpo    := ""
	//Local cSql      := ""
	Local cServidor := GetMV("MV_RELSERV")
	Local cConta    := GetMV("MV_RELACNT")
	Local cPassWord := GetMV("MV_RELPSW")
	Local lRet := .T.

	CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cPassWord Result lConectou
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xfilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,.f.)


	cCorpo += "<table width='100%'  border='0' align='center'>"
	cCorpo += "  <tr>"
	cCorpo += "    <td><br><div align='center'><font size='2'><strong><font color='#990000' size='4' face='Verdana, Arial, Helvetica, sans-serif'>"
	cCorpo += "   Pedido de Vendas Liberado Para Logistica"
	cCorpo += "   </font></strong></font></div><br></td>"
	cCorpo += "  </tr>"
	cCorpo += "</table>"
	cCorpo += "<table width='100%'  border='0'>"
	cCorpo += "  <tr bgcolor='#C7C7C7'>"
	//		cCorpo += "    <td width='10%' height='22' bgcolor='#C7C7C7'><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'><strong>ORCAME.</strong></font></div></td>"
	cCorpo += "    <td width='10%' bgcolor='#C7C7C7'><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'><strong>PEDIDO</strong></font></div></td>"
	cCorpo += "    <td width='10%' bgcolor='#C7C7C7'><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'><strong>EMISSAO</strong></font></div></td>"
	cCorpo += "    <td width='50%' bgcolor='#C7C7C7'><strong><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>CLIENTE</font></strong></td>"
	cCorpo += "    <td width='10%' bgcolor='#C7C7C7'><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'><strong>VEND.</strong></font></div></td>"
	//		cCorpo += "    <td width='10%' bgcolor='#C7C7C7'><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'><strong>GER.</strong></font></div></td>"
	cCorpo += "  </tr>"
	cCorpo += "  <tr>"
	//		cCorpo += "    <td height='22'><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"+ SC6->C6_NUMORC +"</font></div></td>"
	cCorpo += "    <td><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"+ SC5->C5_NUM +"</font></div></td>"
	cCorpo += "    <td><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"+ DTOS(SC5->C5_EMISSAO) +"</font></div></td>"
	cCorpo += "    <td><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"+ SA1->A1_COD+"/"+SA1->A1_LOJA+" - "+SA1->A1_NOME +"</font></td>"
	cCorpo += "    <td><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"+ SC5->C5_VEND1 +"</font></div></td>"
	//		cCorpo += "    <td><div align='center'><font size='1' face='Verdana, Arial, Helvetica, sans-serif'>"+ SC5->C5_VEND2 +"</font></div></td>"
	cCorpo += "  </tr>"
	cCorpo += "</table>"
	cCorpo += "</body>"
	cCorpo += "</html> "

	SA1->(dbCloseArea())

	SEND MAIL From "email@mcdbrasil.com.br" To cContEnv ;
		SUBJECT "(PROTHEUS11) - Pedido de Venda Liberado para logistic - Financeiro" ;
		BODY cCorpo RESULT lEnvio

	cCorpo   := ""
	cContEnv := ""

Return(lRet)


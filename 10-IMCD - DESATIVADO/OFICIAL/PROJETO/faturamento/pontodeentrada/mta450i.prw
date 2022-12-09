#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA450I  ºAutor  ³ Junior Carvalho     ºData ³ 04/02/2018  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado no botao Rejeita na analise de  º±±
±±º          ³ credito do pedido para pedir confirmacao do usuario        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA450                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA450I()

	Local _aArea 	:= GetArea()
	Private _cObs     := " "
	Private _lOk := .F.

	_lOk := DEFMENS(SC9->C9_PEDIDO)
	IF _lOk
		
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek(xFilial("SC5")+SC9->C9_PEDIDO)
		SC5->( dbSetOrder(1) ) 
		if SC5->( dbSeek( xFilial("SC5")+SC9->C9_PEDIDO ) )
			RecLock("SC5", .F.)
			SC5->C5_LIBCRED := "X"
			SC5->( msUnlock() )	
		endif

		//------------------------------------------------
		//Não permitir gravar a mensagem se já existir NF.
		//------------------------------------------------
		if empty(SC9->C9_NFISCAL)
			U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"Credito Liberado",ALLTRIM(_cObs),SC9->C9_ITEM)
		endif
		//MAILMTA450()
	ENDIF
	RESTAREA(_aArea)
Return(NIL)

Static Function MAILMTA450()
	Local cContEnv  := Alltrim( SuperGetMV("ES_MAILAUD", ," ") ) 
	Local cCorpo    := ""
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
	Local _oObs
	Local nReg		:= SC5->(Recno())
	Private _oDlg
	Private _lOk      := .F.

	DEFINE MSDIALOG _oDlg TITLE "Pedido de Venda "+_cPedVen+" liberado " FROM 0,0 TO 400,600 PIXEL

	@ 30,10 TO 200,300 LABEL "Observações: (máximo 500)" PIXEL OF _oDlg

	@ 38,16 GET _oObs Var _cObs MEMO Size 280,155 PIXEL OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg, {|| if( VerObs(_cObs),(_lOk := .T., _oDlg:End()),nil) },;
	{|| (_lOk := .F., _oDlg:End())},,,,,.F.,.F.,.F.,)

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
	Local lRet :=  .T.

	If Len(cObs) > 500
		MsgAlert("O conteúdo da observação deverá conter no máximo 500 caracterers. Você digitou até o momento " + AlltTrim(Str(Len(cObs))) + " caracteres.","Atenção")
		lRet :=  .F.
	EndIf

	If empty(cObs)
		MsgAlert("Antes de confirmar a liberação, digite a observação!","Atenção")
		lRet :=  .F.
	Endif

RETURN lRet

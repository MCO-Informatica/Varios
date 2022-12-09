#INCLUDE "AP5MAIL.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA450I  �Autor  � Junior Carvalho     �Data � 04/02/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Executado apos atualizacao da liberacao de pedido.         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MATA450                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA450I()

	Local _aArea 	:= GetArea()
	Private _cObs     := " "
	Private _lOk := .F.

	if EMPTY(SC9->C9_BLCRED) 
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
			//N�o permitir gravar a mensagem se j� existir NF.
			//------------------------------------------------
			if empty(SC9->C9_NFISCAL)
				U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"Credito Liberado",ALLTRIM(_cObs),SC9->C9_ITEM)
			endif
			//MAILMTA450()
		ENDIF
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
	Local _oObs
	Local nReg		:= SC5->(Recno())
	Private _oDlg
	Private _lOk      := .F.

	DEFINE MSDIALOG _oDlg TITLE "Pedido de Venda "+_cPedVen+" liberado " FROM 0,0 TO 400,600 PIXEL

	@ 30,10 TO 200,300 LABEL "Observa��es: (m�ximo 500)" PIXEL OF _oDlg

	@ 38,16 GET _oObs Var _cObs MEMO Size 280,155 PIXEL OF _oDlg

	ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg, {|| if( VerObs(_cObs),(_lOk := .T., _oDlg:End()),nil) },;
		{|| (_lOk := .F., _oDlg:End())},,,,,.F.,.F.,.F.,)

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
	Local lRet :=  .T.

	If Len(cObs) > 500
		MsgAlert("O conte�do da observa��o dever� conter no m�ximo 500 caracterers. Voc� digitou at� o momento " + AlltTrim(Str(Len(cObs))) + " caracteres.","Aten��o")
		lRet :=  .F.
	EndIf

	If empty(cObs)
		MsgAlert("Antes de confirmar a libera��o, digite a observa��o!","Aten��o")
		lRet :=  .F.
	Endif

RETURN lRet

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
	Private _cObs     := " "
	Private _lOk := .F.

	_lOk := DEFMENS(SC9->C9_PEDIDO)
	IF _lOk
		U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"Credito Rejeitado",ALLTRIM(_cObs),SC9->C9_ITEM)

		SC5->(RecLock("SC5", .F.))
			SC5->C5_LIBCRED := " "
		SC5->( msUnlock() )

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
	Local _oObs
	Local nReg		:= SC5->(Recno())
	Private _oDlg
	Private _lOk      := .F.

	DEFINE MSDIALOG _oDlg TITLE "Pedido de Venda "+_cPedVen+" Rejeitado " FROM 0,0 TO 400,600 PIXEL

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

	If Len(cObs) > 500
		MsgAlert("O conte�do da observa��o dever� conter no m�ximo 500 caracterers. Voc� digitou at� o momento " + AlltTrim(Str(Len(cObs))) + " caracteres.","Aten��o")
		Return .f.
	EndIf

	If empty(cObs)
		MsgAlert("Antes de confirmar a libera��o, digite a observa��o!","Aten��o")
		Return .f.
	Endif

Return .t.

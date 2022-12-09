#Include "Protheus.ch"
#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������"��
���Programa  �M460FIM   �Autor  �Microsiga           � Data �  03/27/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada apos a gravacao do SE1 para alteracao de   ���
���          �alguns campos e a geracao do nosso numero.                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M460FIM()

//������������������������������������������������������Ŀ
//� Grava no SE1 se ele deve ou nao ir para o Banco      �
//��������������������������������������������������������

Local _cProduto := POSICIONE("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE, "D2_COD")
Local _cTipo := POSICIONE("SC6",4,XFILIAL("SC6")+SF2->F2_DOC+SF2->F2_SERIE,"C6_CONTRT")

MSGBOX("CHAMOU A FUN��O")

If !SF2->F2_TIPO $ "D/B"
	dbSelectArea("SE1")
	_aAreaSE1  := GetArea("SE1")
	dbSetOrder(1)
	MsSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
	While !eof() .and. SE1->E1_NUM+SE1->E1_PREFIXO+SE1->E1_CLIENTE+SE1->E1_LOJA==SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		dbSelectArea("SB1")
		dbSetOrder(1)
		MsSeek(xFilial("SB1")+_cProduto)
		dbSelectArea("SEE")
		dbSetOrder(1)
		dbSelectArea("SEE")
		//		MsSeek(xFilial("SEE")+SB1->B1_BANCO+SB1->B1_AGENCIA+SB1->B1_NUMCON+SB1->B1_SUBCTA)
//		MsSeek(xFilial("SEE")+"237"+"2501 "+"33175     "+"001") // -> BASE TESTE
		MsSeek(xFilial("SEE")+"237"+"2501 "+"331750    "+"001") // -> BASE OFICIAL
		If SubStr(SE1->E1_TIPO,3,1) == "-"
			SE1->(dbSkip())
			Loop
		Endif
		// NossoNum()
		SUBSTR(nossonum(),4,9)
		If Val(SEE->EE_FAXFIM)-Val(SEE->EE_FAXATU) < 500
			//Aviso("Aten��o!","Gentileza avisar o Alexandre do financeiro da MATRIZ no fone: 11-5185-8761 sobre a FAIXA DE CODIGO DO BANCO!!!",{"Voltar"},2)
			MSGBOX("Aten��o!, a numera��o da FAIXA DE CODIGO DO BANCO est� acabando!")
		Endif
		_cDig := U_CalcDig(Val(SE1->E1_NUMBCO))
		RecLock("SE1",.F.)
		//SE1->E1_NUMBCO  := Alltrim(Str(Val(SE1->E1_NUMBCO)))+_cDig
		//		SE1->E1_FORMCOB := POSICIONE("SA1",1,XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_FORMCOB")
		If Alltrim(_cProduto) == "RET"
			SE1->E1_HIST    := "RETAINER"
		ElseIf _cTipo == Space(15)
			SE1->E1_HIST    := "SERVICOS"
		Else
			SE1->E1_HIST    := "CONTRATOS"
		Endif
		MsUnlock()
		dbSelectArea("SE1")
		dbSkip()
	EndDo
EndIf

RestArea(_aAreaSE1)


RETURN

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CalcDig   �Autor  �Ricardo Nunes       � Data �  27/03/03   ���
�������������������������������������������������������������������������͹��
���Desc.     �Calculo do digito verificador do nosso numero.              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Uso especifico para o BankBoston                           ���
�������������������������������������������������������������������������͹��
���Parametros�01-_cNum - Numero do Titulo (Nosso Numero)                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CalcDig(_cNum)

Local _cPond  := "98765432"  //Poderacao fornecida pelo banco
Local _cNosso := AllTrim(Str(_cNum))
Local _nSoma  := 0
Local _cDigito:=""

For I := 1 To 8
	
	_nSoma += Val(SubStr(_cPond,I,1))*Val(SubStr(_cNosso,I,1))
	
Next I

_nSoma := Mod(_nSoma*10,11)

_cDigito := If(_nSoma==10,0,_nSoma)

Return(Str(_cDigito,1))

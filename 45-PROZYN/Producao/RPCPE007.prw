#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"


/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RPCPR007  �Autor  � Derik Santos      � Data �  18/10/2016  ���
��������������������������������������������������������������������������͹��
���Desc.     � Rotina para calcular a validade do lote com base nos dias   ���
���Desc.     � informados no cadastro do produto                           ���
��������������������������������������������������������������������������͹��
���Uso       � Protheus 12 - Prozyn                                        ���
��������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������͹��
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function RPCPE007()

_cProd	 := RTRIM(M->C2_PRODUTO)
_cRastro := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_RASTRO")
_cDias   := Posicione("SB1",1,xFilial("SB1")+_cProd,"B1_PRVALID")

	If _cRastro == "L"
		_cValid  := DaySum( DDatabase , _cDias )
		Return(_cValid)
	Else
		MsgAlert("Aten��o esse produto n�o est� com controle de lote habilitado!","RPCPE007_01")
	EndIf

Return(Stod(""))
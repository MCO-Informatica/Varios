#INCLUDE "PROTHEUS.CH"
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
���Desc.     � Ponto de entrada executado no botao Rejeita na analise de  ���
���          � credito do pedido para pedir confirmacao do usuario        ���
�������������������������������������������������������������������������͹��
���Uso       � MATA450                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA450I()

	Local _aArea 	:= GetArea()
	Local lRet	    := .F.
	Local nReg		:= SC9->(Recno())
	Private _cObs     := " "

	U_GrvLogPd(SC9->C9_PEDIDO,SC9->C9_CLIENTE,SC9->C9_LOJA,"Credito Liberado",ALLTRIM(_cObs),SC9->C9_ITEM)

	RESTAREA(_aArea)

Return(NIL)
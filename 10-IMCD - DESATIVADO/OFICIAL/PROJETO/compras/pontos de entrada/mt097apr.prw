#include  "rwmake.ch"
#include "protheus.ch"
#INCLUDE "MSOLE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT097APR  �Autor  �Giane               � Data �  24/06/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na liberacao do pedido de compra           ���
���          �passa por cada registro do SC7 para o mesmo pedido          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT097APR()

	////oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MT097APR" , __cUserID )

	If SC7->C7_CONAPRO == "L"  // o pedido foi totalmente liberado,  ap�s todas as aprova��es.
		//marcar o campo abaixo para "aguardando envio email ao fornecedor" usada na rotina ACOM002
		Reclock("SC7",.F.)
			SC7->C7_ENVMAIL := '1'
		MsUnlock()

		if !EMPTY(SC7->C7_PO_EIC) 

			If SW2->(MsSeek(xFilial("SW2")+SC7->C7_PO_EIC)) .AND. SW2->W2_CONAPRO == "L"
				U_IMCDENVPO(SW2->W2_FILIAL,SW2->W2_PO_NUM )
			EndIf

		Endif

	Endif

Return

#Include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MS520DEL  �Autor  � Darcio R. Sporl    � Data �  19/09/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Desenvolvido o ponto de entrada, para controlar o cancelamen���
���          �to de Notas para informar o site.                           ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs x Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MS520DEL()
Local aArea := GetArea()
Local cPedV	:= ""

//Posiciona nos Itens dos Pedidos referente a Nota
SC6->(DbSetOrder(4))
If SC6->(DbSeek(xFilial("SC6")+SF2->(F2_DOC+F2_SERIE)))
	cPedV := SC6->C6_NUM
	//Marca os campos de informa��o de cancelamento
    RecLock("SC6", .F.)
		SC6->C6_XNFCANC := "S"
		SC6->C6_XDTCANC := DdataBase
		SC6->C6_XHRCANC := Time()
	SC6->(MsUnLock())
	
	//Marca o pedido para ser enviado ao hub 
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(xFilial("SC5")+cPedV))
		RecLock("SC5", .F.)
			SC5->C5_XFLAGEN := ""
		SC5->(MsUnLock())
	EndIf	
EndIf	
RestArea(aArea)
Return
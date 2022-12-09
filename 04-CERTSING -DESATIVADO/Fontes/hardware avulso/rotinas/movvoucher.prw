#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MovVoucher� Autor � Darcio R. Sporl    � Data �  14/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Movimentacao de Voucher.                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MovVoucher(cNumPed, cNumVou, nQtdVou, cItem)

DbSelectArea("SZF")
DbSetOrder(1)
If DbSeek(xFilial("SZF") + cNumVou)
	RecLock("SZF", .F.)	//Gravo o numero do pedido e controlo o saldo do voucher
		SZF->ZF_SALDO	:= SZF->ZF_SALDO - nQtdVou
		SZF->ZF_PEDIDO	:= cNumPed
	SZF->(MsUnLock())

	RecLock("SZG", .T.)	//Crio um novo registro com a movimentacao do voucher
		SZG->ZG_FILIAL	:= xFilial("SZG")
		SZG->ZG_NUMPED	:= cNumPed
		SZG->ZG_ITEMPED	:= cItem
		SZG->ZG_NUMVOUC	:= cNumVou
		SZG->ZG_QTDSAI	:= nQtdVou
	SZG->(MsUnLock())
EndIf

Return
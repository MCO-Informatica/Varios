#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadVoucher� Autor � Darcio R. Sporl    � Data �  14/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Movimentacao de Voucher via Hardware Avulso.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MovVouHA(cCondPag, aProdutos)
//���������������������Ŀ
//�Posicoes do aProduto �
//�[1]Item              �
//�[2]Codigo Produto    �
//�[3]Quantidade        �
//�[4]Valor Unitario    �
//�[5]Valor com desconto�
//�[6]Valor Total       �
//�[7]Data da Entrega   �
//�[8]TES               �
//�[9]Numero Voucher    �
//�[10]Saldo Voucher    �
//�����������������������
Local nI	:= 0
Local lRet	:= .T.

For nI := 1 To Len(aProdutos)
	DbSelectArea("SZF")
	DbSetOrder(1)
	DbSeek(xFilial("SZF") + aProdutos[nI, 9])
	If SZF->ZF_SALDO < aProdutos[nI, 3]
		lRet := .F.
	EndIf
Next nI

Return(lRet)
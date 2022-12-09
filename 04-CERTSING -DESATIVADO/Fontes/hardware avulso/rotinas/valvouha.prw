#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadVoucher� Autor � Darcio R. Sporl    � Data �  14/06/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Valida o voucher informado no pedido do Hardware Avulso.   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Opvs / Certisign                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ValVouHA(aProdutos, cNumVou, nQtdVou)
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
Local nI		:= 0
Local lRet		:= .T.
Local cMensagem	:= ""

DbSelectArea("SZF")
DbSetOrder(1)	// ZF_FILIAL + ZF_COD
If !DbSeek(xFilial("SZF") + cNumVou)	// Verifico se o numero do voucher existe
	lRet		:= .F.
	cMensagem	:= "O voucher informado n�o existe."
Else
	If Date() > SZF->ZF_DTVALID			// Verifico se o voucher esta dentro da validade
		lRet 		:= .F.
		cMensagem	:= "O voucher informado est� fora da validade."
	Else
		For nI := 1 To Len(aProdutos)	// Verifico se o voucher tem saldo para ser utilizado
			DbSelectArea("SZF")
			DbSetOrder(1)
			If DbSeek(xFilial("SZF") + aProdutos[nI, 9])
				If SZF->ZF_ATIVO == "N"
					lRet		:= .F.
					cMensagem	:= "O voucher informado n�o est� ativo."
				Else
					If SZF->ZF_PRODUTO == aProdutos[nI, 2]
						If SZF->ZF_SALDO < Val(AllTrim(aProdutos[nI, 3]))
							lRet		:= .F.
							cMensagem	:= "O voucher informado n�o tem saldo para ser utilizado."
						EndIf
					Else
						lRet		:= .F.
						cMensagem	:= "O produto n�o corresponde ao produto cadastrado no voucher."
					EndIf
				EndIf
			Else
				lRet		:= .F.
				cMensagem	:= "O voucher informado n�o foi encontrado."
			EndIf
		Next nI
	EndIf
EndIf

Return({lRet, cMensagem})
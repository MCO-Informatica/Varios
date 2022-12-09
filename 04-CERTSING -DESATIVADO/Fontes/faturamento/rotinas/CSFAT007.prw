#INCLUDE "totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSFAT007  � Autor � Renato Ruy         � Data �  05/09/16   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para valida��o de Pedido de Venda em Poder de Terc. ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CSFAT007

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local lValid := .T.
Local cMsg	 := ""
Local lFound := .F.

SZ8->(DbSetOrder(1))

If Empty(M->C5_PONDIS)
	cMsg := "O campo de ponto de distribui��o n�o foi preenchido, deseja continuar?"
Elseif SZ8->(DbSeek(xFilial("SZ8")+M->C5_PONDIS)) .And. M->C5_CLIENTE !=  SZ8->Z8_FORNEC
	cMsg := "O fornecedor est� diferente do vinculado ao ponto de distribui��o, deseja continuar?"
Endif

If !Empty(cMsg)
	lValid := MsgYesNo(cMsg,"Poder de Terceiros")
EndIf

Return lValid

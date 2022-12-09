#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MT410TOK �Autor  �FONTANELLI          � Data �  26/01/15   ���
�������������������������������������������������������������������������͹��
���Descricao �Ponto de entrada que efetua a VALIDACAO antes de Gravar     ���
���          � o Pedido de Venda                                          ���
�������������������������������������������������������������������������͹��
���Uso       � DAYHOME                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT410TOK()

	LOCAL nPosDel := Len(aHeader) + 1
	LOCAL _nQTDMULT := 0
	LOCAL _nQTDVEN  := 0
	Local I := 0


	For I := 1 to Len(aCols)

		If !aCols[I,nPosDel] // Linha nao Deletada

			if alltrim(M->C5_X_USERS) == 'e-commerce'
				If alltrim(gdFieldGet("C6_TES",I)) <> '995'
					MsgAlert("Pedidos do E-Commerce, precisam estar com a TES 995","Aviso")
					Return(.F.)
				EndIf
			endif
		EndIf

	Next

Return(.T.)

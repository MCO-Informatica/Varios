#Include "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SELEOPC   �Autor  �Eduardo Franco      � Data �  10/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este PE foi criado para atender a necessidade de n�o       ���
���          � abrir a tela de opcionais no pedido de venda e Call center ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada padr�o de PE.                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function SELEOPC()
Local lExibe 	:= .T.// Verifica��o do usu�rio para exibir ou n�o opcionais do produto
Local cNomeRot 	:= GetMV("ZZ_HABOPC")

If Alltrim(FUNNAME()) $ Alltrim(cNomeRot) //"MATA410"
	lExibe := .F.
EndIf

Return (lExibe)

#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA020ALT � Autor � Douglas P. Mello   � Data � 03/11/2009  ���
�������������������������������������������������������������������������͹��
���Descricao �  Cadastro de Fornecedor - Alteracao						  ���
���				Valida se o Fornecedor for extrangeiro nao obriga a       ���
���          � 	Preencher o CNPJ.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function MA020ALT

_lRet := .T.

If M->A2_TIPO <> "X" .AND. EMPTY(M->A2_CGC)
	Aviso("Atencao","O CNPJ nao pode estar vazio.",{"Ok"})
	_lRet := .F.
EndIf

Return(_lRet)


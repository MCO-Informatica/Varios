#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CN100GRC   � Autor � Marcelo Celi Marques � Data � 19/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de Entrada para tratar as integracoes apos a manuten- ��� 
���          �cao do cadastro de Gestao de Contratos.				      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                 
User Function CN100GRC()
	Local nOpc := 0
	
	nOpc := ParamIXB[1]
	
	If nOpc==5 .And. FindFunction("U_CSATVMANU")
		U_CSATVMANU(4,"E")
	EndIf
	
	If FindFunction('U_A250GrvCNPJ')
		U_A290GrvCNPJ( nOpc )
	Endif
Return 
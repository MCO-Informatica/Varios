#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �SCHARMENU  � Autor � Marcelo Celi Marques � Data � 19/10/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Ponto de Entrada para incluir funcionalidades no menu de    ��� 
���          �Hardwares.											      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Certisign                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                 
User Function SCHARMENU
Local aRotina := Paramixb[1] 

If FindFunction("U_CSISO27M1")
	aAdd(aRotina,{ "ISO27001",	"U_CSISO27M1",	0, 4})
EndIf
    
Return aRotina






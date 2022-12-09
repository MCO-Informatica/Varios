#include "protheus.ch"
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CDIMXY    �Autor  �Carlos E. Saturnino � Data �  11/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Utilizado para efetuar a conversao das Dimensoes X e Y      ���
���          �para a primeira Unidade de Medida do Cadastro de Produtos   ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cozil                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function CDIMXY()

Local nResult	:= 0                 
Local nDimY	:= 0
Local nDimX	:= 0
Local nCoef	:= 0

dbSelectArea("SZ2")
dbSetOrder(1)
If M->G1_DIMY <> 0 .Or. M->G1_DIMX <> 0
	If MsSeek( xFilial("SZ2") +  M->G1_COMP )
		nDimX		:= M->G1_DIMX
		nDimY		:= M->G1_DIMY
		nCoef		:= SZ2->Z2_COEFIC
		nQtdUnit		:= M->G1_XQTDUNI
		nResult		:= ((nDimX * nDimY)* nCoef )* nQtdUnit 
	Else
	   MsgInfo("Nao existe Coeficiente cadastrado para este produto")
	Endif
Endif
dbCloseArea("SZ2")
Return(nResult)
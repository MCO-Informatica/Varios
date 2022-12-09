#include 'protheus.ch'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ACDA100I	  �Autor  �Microsiga	      � Data �  17/09/2019���
�������������������������������������������������������������������������͹��
���Desc.     �PE para filtrar itens da ordem de separa��o                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function ACDA100I()

//Atualiza variavel static disponivel no codigo fonte ACD100MNU
AtuVrStcOp()
	
Return .T.


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuVrStcOp  �Autor  �Microsiga	      � Data �  17/09/2019���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza a variavel statica de controle de OP.              ���
���          �Variavel static disponivel no fonte ACD100MNU               ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuVrStcOp()

Local nX	:= 0
Local aOp	:= U_PZACDGT1()//Retorna dados da variavel static do fonte ACD100MNU
Local lExis	:= .F.

For nX := 1 To Len(aOp)
	If Alltrim(aOp[nX]) == Alltrim(SC2->(C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) )
		lExis := .T.
		Exit
	EndIf
Next

//Verifica se a OP existe na variavel static de controle. Sen�o existir, ser� adicionada
If !lExis
	
	//Executa a atualiza��o da variavel
	u_PZACDST1(Alltrim(SC2->(C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)))
EndIf


Return
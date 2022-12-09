#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA261LIN  �Autor  �Henio Brasil        � Data � 17/04/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Pto Entrada no momento da transferencia entre materiais     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function MA261LIN()

Local nPosCod1	:= 1
Local nPosCod2	:= 6
Local lReturn	:= .T.
Local nLin		:= ParamIxb[1]
Local aAreaD3  	:= GetArea()
Local cCampo 	:= ReadVar()
Local cUserLog	:= RetCodUsr() //c�digo do usu�rio Logado.      
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")  
// Local nPosCod	:= aScan(aHeader,	{|x| Trim(x[2])=="D3_COD"})

// MsgAlert("Pto Entrada MA261LIN! ","Permiss�o de Usuario")  
/* 
������������������������������������������������������������������������Ŀ
�Valida se o usuario pode faser transferencia entre materiais diferentes �  
��������������������������������������������������������������������������*/ 
If aCols[nLin][nPosCod1] <> aCols[nLin][nPosCod2] 
	If !(cUserLog $ cUserMov)
		MsgAlert("Caro usu�rio, voc� n�o tem permiss�o de transferir materiais distintos! Contate o Administrador! ","Permiss�o de Usuario")  
		Return(.F.) 
		lReturn	:= .F. 
	Endif
Endif 
// RestArea(aAreaD3)
Return lReturn
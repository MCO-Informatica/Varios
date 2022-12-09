#include "Rwmake.ch"
#include "Protheus.ch"                     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCPVC01   �Autor  �Henio Brasil        � Data � 26/04/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Validacao no item de movimentacao de ajuste de Empenho Mod2 ���
���          �para nao permitir alterar produto.                          ���
���          �                                                            ���
���Utilizado �MATA361 - Ajuste de Empenho Mod II                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function PCPVC01(nType) 

Local lReturn	:= .T.       
Local aEnvD3	:= GetArea()  
Local cUserLog	:= RetCodUsr() //c�digo do usu�rio Logado.      
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")  
Local nPosCod	:= If(FunName()=="MATA381", aScan(aHeader,	{|x| Trim(x[2])=="D4_COD"}), 0) 
Local nPosAlm	:= If(FunName()=="MATA381", aScan(aHeader,	{|x| Trim(x[2])=="D4_LOCAL"}), 0) 
Local lNewLine	:= If(FunName()=="MATA381", Empty(aCols[n][nPosCod]) .And. Empty(aCols[n][nPosAlm]), .F.) 

// MsgAlert("Validacao do codigo do Material - MATA381 ")
/* 
������������������������������������������������������������������������Ŀ
�Tratamento apenas para qdo for Movto Interno Mod I e Mod II             �
��������������������������������������������������������������������������*/                                                                                              
If FunName()<>"MATA381"  
	Return(.T.)   
Endif 
/* 
������������������������������������������������������������������������Ŀ
�Valida transferencia Mod 2 para usuarios especificos                    �
��������������������������������������������������������������������������*/ 
If FunName()=="MATA381" 
	/* 
	������������������������������������������������������������������������Ŀ
	�Valida se o usuario pode faser transferencia entre materiais diferentes �  
	��������������������������������������������������������������������������*/
	If lNewLine
		If !(cUserLog $ cUserMov)
			MsgAlert("Caro usu�rio, voc� n�o tem permiss�o para incluir novos materiais! Contate o Administrador! ","Permiss�o de Usuario")  
			lReturn	:= .F. 		
		Endif
	Endif 	
Endif 	
RestArea(aEnvD3) 
Return(lReturn) 
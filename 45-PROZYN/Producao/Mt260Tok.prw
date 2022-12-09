#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A260INI   �Autor  �Henio Brasil        � Data � 17/04/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Pto Entrada no momento da transferencia para criar local    ���
���          �novo qdo o destino nao existir no SB9.                      ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function MT260TOK() 

Local lReturn	:= .T. 
Local cUserLog	:= RetCodUsr() //c�digo do usu�rio Logado.      
Local lSecond 	:= !Empty(cCodDest) 
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")  

// MsgAlert("Pto Entrada MT260TOK! ","Permiss�o de Usuario")  
// Return(.F.) 
/* 
������������������������������������������������������������������������Ŀ
�Valida se o usuario pode faser transferencia entre materiais diferentes �  
��������������������������������������������������������������������������*/
If lSecond .And. cCodOrig <> cCodDest 
	If !(cUserLog $ cUserMov)
		MsgAlert("Caro usu�rio, voc� n�o tem permiss�o de transferir materiais distintos! Contate o Administrador! ","Permiss�o de Usuario")  
		// Return(.F.) 
		lReturn	:= .F. 
	Endif
Endif 
// RestArea(aAreaMT)
Return lReturn
#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT380EXC  �Autor  �Henio Brasil        � Data � 26/04/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Pto Entrada no momento da exclusao do item para Movto de    ���
���          �Ajuste de Empenho Multiplo                                  ���
�������������������������������������������������������������������������͹��
���Empresa   �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function MT380EXC() 

Local lReturn	:= .T. 
Local cUserLog	:= RetCodUsr() //c�digo do usu�rio Logado.      
Local cUserMov	:= SuperGetMv("NB_USRMTE", .F., "000000")  

/* 
������������������������������������������������������������������������Ŀ
�Valida se o usuario tem permissao para EXCLUIR a linha de empenho       �  
��������������������������������������������������������������������������*/
If !(cUserMov $ cUserLog) 
	MsgAlert("Caro usu�rio, voc� n�o tem permiss�o para incluir novos materiais! Contate o Administrador! ","Permiss�o de Usuario")  
	lReturn	:= .F. 
Endif
Return lReturn
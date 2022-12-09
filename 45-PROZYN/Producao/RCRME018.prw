#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPCPA001  �Autor � DERIK SANTOS           � Data � 14/11/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela para atualizar a sala utilizada na OP                 ���
���Desc.     �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico para Prozyn                                     ���        
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RCRME018()

Local _aSavArea 	:= GetArea()
Local _aSavSZL		:= SZL->(GetArea())
Private _cConteudo	:= SPACE(60)
Private _cRotina	:= "RCRME018"
Static oDlg5

@ 001,001 TO 100,550 DIALOG oDlg5 TITLE "E-mail" 
@ 004,008 Say OemToAnsi("Tela para identifica��o dos e-mails.")
@ 019,008 Say OemToAnsi("")
@ 034,030 Get _cConteudo Size 90,11  
@ 034,150 Button OemToAnsi("_Salvar") Size 25,11 Action U_Envia(_cConteudo)

Activate Dialog oDlg5 Centered
                  
RestArea(_aSavSZL)
RestArea(_aSavArea)

Return(_cConteudo)
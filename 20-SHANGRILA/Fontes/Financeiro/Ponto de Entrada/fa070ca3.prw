#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA070CA3 �Autor  �GENILSON LUCAS	     � Data �  11/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para verificar se usu�rio pode cancelar   ��
���          � t�tulos a receber.    			                          ���
�������������������������������������������������������������������������͹��
���Uso       � Shangri-l�  				                          	      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                                  

User Function FA070CA3()

Local _nomeuser	:= Alltrim(substr(cusuario,7,15)) 
Local _BloqUser	:= GETMV("MV_CANCBAI")

If _nomeuser $ _BloqUser
   	cFiltraSA1 := .F.                      
   	alert("Usu�rio sem permiss�o para executar essa rotina")
Else
	cFiltraSA1 := .T.
Endif

Return(cFiltraSA1)
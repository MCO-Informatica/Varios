#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA080OWN �Autor  �GENILSON LUCAS	     � Data �  11/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para verificar se usu�rio pode cancelar   ��
���          � t�tulos a pagar.    			                          ���
�������������������������������������������������������������������������͹��
���Uso       � Shangri-l�  				                          	      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                                  

User Function FA080OWN()

Local _nomeuser	:= Alltrim(substr(cusuario,7,15)) 
Local _BloqUser	:= GETMV("MV_CANCBAI")

If _nomeuser $ _BloqUser
   	cFiltraSA1 := .F.                      
   	alert("Usu�rio sem permiss�o para executar essa rotina.")
Else
	cFiltraSA1 := .T.
Endif

Return(cFiltraSA1)       

User Function F080BXLT()
          
dBaixa := dDataBase

Return .T.
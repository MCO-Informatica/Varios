#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
���Programa  �MT120LOK  �Autor  �Pedro Augusto       � Data �  18/02/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     �Mascara a ser utilizada no campo E2_XCNPJ                   ���
���Uso       � Exclusivo RENOVA      

CRIAR GATILHO PARA O CAMPO E2_XCNPJC CDOMINIO - E2_XCNPJC   
E CHAMAR A FUN��O U_MaScContri() NA REGRA                                 ���
�����������������������������������������������������������������������������
*/

User Function MaScContri() 


Local _cContri := ALLTRIM(M->E2_XCNPJC)
Local _cMasc:= ""

If Len(_cContri)==14
	
	_cMasc:= Transform((_cContri),"@R 99.999.999/9999-99") 
	
Else

	_cMasc:= Transform((_cContri),"@R 999.999.999-99")
	
   //	 Msgalert("passei aqui")
Endif

RETURN(_cMasc)

#Include "Rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CNABB01   �Autor  �Rodrigo Okamoto     � Data �  03/12/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para grava��o do Endere�o no arquivo de remessa   ���
���          � CNAB contas a pagar 240 - Banco Real                       ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - LINCIPLAS                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


//PARA TRAZER O LOGRADOURO DO ENDERE�O
user function cnabb01()
cRet:= ""
if "," $ SA2->A2_END
	cRet:=SUBS(SA2->A2_END,1,AT(",",SA2->A2_END)-1) 
else
	cRet:=SA2->A2_END 
Endif

Return cRet

//-------------------------------------------------
//PARA TRAZER O NUMERO DO ENDERE�O
user function cnabb02()
cMens:= ""             
cRet:= ""
If "," $ SA2->A2_END
	If SUBS(SA2->A2_END,AT(",",SA2->A2_END)+1,1) == " "
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+2,30)	
		cRet  := subs(cmens,1,AT(" ",cmens)-1)
	Else                                                    
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+1,30)	
		cRet  := subs(cmens,1,AT(" ",cmens)-1)
	EndIf 	
ELSE
	cRet:= ""
EndIf

Return cRet
                                                

//----------------------------------------------------
//PARA TRAZER O COMPLEMENTO DO ENDERE�O 
user function cnabb03()
cMens:= ""             
cRet:= ""
If "," $ SA2->A2_END
	IF SUBS(SA2->A2_END,AT(",",SA2->A2_END)+1,1) == " "
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+2,30)	
		cRet  := subs(cmens,AT(" ",cmens)+1,30)
	else                                                    
		cMens := subs(SA2->A2_END,AT(",",SA2->A2_END)+1,30)	
		cRet  := subs(cmens,AT(" ",cmens)+1,30)
	endif 
ELSE      
	cRet:= ""
EndIf

Return cRet
#include "rwmake.ch"       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DBGETIDT �Autor  �DANILO ALVES DEL BUSSO � Data �  03/15/16 ���
�������������������������������������������������������������������������͹��
���Desc.     � Responsavel por pegar um numero dentro do Range 237900000  ���
���          �                                                            ���    
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function DBGETIDT()	                       

cFaxIni := AllTrim(SEE->EE_FAXINI)
cFaxFim := AllTrim(SEE->EE_FAXFIM)
cFaxAtu := AllTrim(SEE->EE_FAXATU)

If(Empty(cFaxAtu))
	cRetorno := DBGRDIGV(cFaxIni)
	cFaxAtu := cFaxIni	
Else
	cRetorno := DBGRDIGV(cFaxAtu)
EndIf
	cFaxAtu := Val(cFaxAtu) + 1 
	
	RecLock("SEE", .F.)
		SEE->EE_FAXATU := cValToChar(cFaxAtu)
	MsUnlock()

Return(cRetorno) 


Static Function DBGRDIGV(cNumero)   
	cIdentif 	:= cValToChar(cNumero)
	cDigito 	:= 0
	cSoma 		:= 0 
	nJ := 9          
	
	For nI := 1 to Len(cIdentif)
		cSoma += Val(Subs(cIdentif,nI,1)) * nJ	 	
		nJ := nJ - 1
	Next            
	
	If(Mod(cSoma,11)==1)
		cDigito := "0"
	ElseIf(Mod(cSoma,11)==0)
	    cDigito := "1"
	Else
		cDigito := cValtoChar(11 - Mod(cSoma,11))
	End If                
	
	cIdentif += cDigito   
	
Return(cIdentif)
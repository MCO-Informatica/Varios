/ ATRIBIU O CONTE?DO EM MEM?RIA DE A1_DDC1 ? _cDDC1, VERIFICA SE QUATIDADE DE DIGITOS DO N?MERO DIGITADO EM A1_DDD ? MENOR QUE 2.SEIM, EXECUTA O ALERT(), E RETORNA BRANCO PARA _cDDC1, EVITANDO QUE O DDD DIGITADO SEJA COMPOSTO POR MENOS DE 1 DIGITO
//A1_DDC1 ? DOM?NIO E CONTRA DOM?NIO

User Function RFATG16()

_cDDC1 := M->A1_DDC1

IF LEN(ALLTRIM(M->A1_DDC1))<2 
	alert("DDD Inv?lido")
	_cDDC1 :=  ""
EndIf
    
Return(A1_DDC1)


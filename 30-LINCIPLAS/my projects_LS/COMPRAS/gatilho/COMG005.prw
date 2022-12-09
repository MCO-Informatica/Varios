#Include "Protheus.ch"

/*##################################################*\
||                                               	||
||                                               	||
\*##################################################*/

User Function COMG005()

Local _lRet := .T.
    
    //nHandle := 6013//GetFocus()               
    
    dbSelectArea("SF1")
    dbSetOrder(1)
	If MsSeek(xFilial("SF1")+CD5_DOC+CD5_SERIE) 
	
		M->CD5_ESPEC 	:= SF1->F1_ESPECIE
		M->CD5_FORNEC	:= SF1->F1_FORNECE
		M->CD5_LOJA		:= SF1->F1_LOJA	
				
	Else
	                                              
	    MSGAlert("A NF digitada é inválida!" + char(13) + "verifique o numero digitado ou se esta NF já possui 'Complemento de Importação'.")

    	M->CD5_ESPEC 	:= ""
		M->CD5_FORNEC	:= ""
		M->CD5_LOJA		:= ""	

	    _lRet := .F.
	    
	EndIf

Return(_lRet)






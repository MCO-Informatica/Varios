#include "PROTHEUS.CH"

User Function AcertaCasa()

If MsgYesNo("Confirma acerto das casas decimais?") 
	dbSelectArea("SM0")
	dbsetorder(1)    
	dbgotop()
	while !eof()
		_cCodigo:= SM0->M0_CODIGO
	    _cSx3Dbf:= "SX3" + _cCodigo + "0.DBF"
	    _cSx3Cdx:= "SX3" + _cCodigo + "0.CDX"	    
	    dbUseArea(.T.,"DBFCDXADS",_cSx3Dbf,"SX30",.T.,.F.)
	    dbsetindex(_cSx3Cdx)
		//ACERTO DE QUANTIDADE
		ProcQuant()
		//ACERTO DE VALORES
		ProcPreco()
		
		dbSelectArea("SX30")
		dbclosearea()
		
		dbSelectArea("SM0")
		while !eof() .and. _cCodigo == SM0->M0_CODIGO
		    dbskip()
		enddo        

	enddo
	
	MsgAlert("Fim")	      
   
EndIf

Static Function ProcQuant()

cArquivo := "\CASAS\QUANT.DBF"
dbUseArea(.T.,"DBFCDXADS",cArquivo,"TMP",.T.,.F.)

dbSelectArea("TMP")
dbGotop()
While !EOF()  
           
	cCampo := TMP->QUANT
	cCampo := AllTrim(cCampo)  
		
	dbSelectArea("SX30")
	dbSetOrder(2)
	If dbSeek(cCampo)
		RecLock("SX30",.F.)      
		SX30->X3_TAMANHO := 14
		SX30->X3_DECIMAL := 4
		SX30->X3_PICTURE := "@E 999,999,999.9999"                                
		MsUnLock()
	EndIf
	
	cTable:= "dbo." + SX30->X3_ARQUIVO + SM0->M0_CODIGO + "0" 
         
	cQuery := "UPDATE TOP_FIELD "
	cQuery += "SET FIELD_DEC = 4, FIELD_PREC = 14 "
	cQuery += "WHERE FIELD_NAME = '"+cCampo+"' AND FIELD_TABLE = '" + cTable + "' "
	TCSqlExec(cQuery)     

	dbSelectArea("TMP")
	dbSkip()
EndDo       

dbclosearea()
         
Static Function ProcPreco()

cArquivo := "\CASAS\PRECO.DBF"
dbUseArea(.T.,"DBFCDXADS",cArquivo,"TMP",.T.,.F.)

dbSelectArea("TMP")
dbGotop()
While !EOF()  
           
	cCampo := TMP->PRECO
	cCampo := AllTrim(cCampo)  
		
	dbSelectArea("SX30")
	dbSetOrder(2)
	If dbSeek(cCampo)
		RecLock("SX30",.F.)      
		SX30->X3_TAMANHO := 14
		SX30->X3_DECIMAL := 4
		SX30->X3_PICTURE := "@E 999,999,999.9999"                                
		MsUnLock()
	EndIf
	
	cTable:= "dbo." + SX30->X3_ARQUIVO + SM0->M0_CODIGO + "0" 
         
	cQuery := "UPDATE TOP_FIELD "
	cQuery += "SET FIELD_DEC = 4, FIELD_PREC = 14 "
	cQuery += "WHERE FIELD_NAME = '"+cCampo+"' AND FIELD_TABLE = '" + cTable + "' "
	TCSqlExec(cQuery)     

	dbSelectArea("TMP")
	dbSkip()
EndDo        

dbclosearea()
#include "PROTHEUS.CH"

User Function AcertaCasa()

If MsgYesNo("Confirma acerto das casas decimais?")
	//ACERTO DE QUANTIDADE
	ProcQuant()
	//ACERTO DE VALORES
	ProcPreco()
EndIf

Return Nil


Static Function ProcQuant()
                                                                                                  
cArquivo := "\CASAS\QUANT.DBF"
dbUseArea(.T.,"DBFCDXADS",cArquivo,"TMP",.T.,.F.)

dbSelectArea("TMP")
dbGotop()
While !EOF()  
           
	cCampo := TMP->QUANT
	cCampo := AllTrim(cCampo)  
		
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek(cCampo)
		RecLock("SX3",.F.)      
		SX3->X3_TAMANHO := 16
		SX3->X3_DECIMAL := 4
		SX3->X3_PICTURE := "@E 999,999,999.9999"                                
		MsUnLock()
	EndIf
         
	cQuery := "UPDATE TOP_FIELD "
	cQuery += "SET FIELD_DEC = 4, FIELD_PREC = 16 "
	cQuery += "WHERE FIELD_NAME = '"+cCampo+"' "
	TCSqlExec(cQuery)     


	dbSelectArea("TMP")
	dbSkip()
EndDo       

MsgAlert("Fim")
           
return NIL

Static Function ProcPreco()

cArquivo := "\CASAS\PRECO.DBF"
dbUseArea(.T.,"DBFCDXADS",cArquivo,"TMP",.T.,.F.)

dbSelectArea("TMP")
dbGotop()
While !EOF()  
           
	cCampo := TMP->PRECO
	cCampo := AllTrim(cCampo)  
		
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek(cCampo)
		RecLock("SX3",.F.)      
		SX3->X3_TAMANHO := 12
		SX3->X3_DECIMAL := 2
		SX3->X3_PICTURE := "@E 9,999,999.99"                                
		MsUnLock()
	EndIf
         
	cQuery := "UPDATE TOP_FIELD "
	cQuery += "SET FIELD_DEC = 2, FIELD_PREC = 12 "
	cQuery += "WHERE FIELD_NAME = '"+cCampo+"' "
	TCSqlExec(cQuery)     


	dbSelectArea("TMP")
	dbSkip()
EndDo       

MsgAlert("Fim")

return NIL
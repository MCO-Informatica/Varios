#include "Protheus.ch"

User Function FT050LOK()
Local lRet := .T. 
Local cMensag := "Os seguintes campos não foram preenchidos: " + CRLF
Local cSolucao:= CRLF + "Solução: " + CRLF 
Local nIndCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_CLIENTE"})
Local nLojCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_LOJA"})
Local cCodCli := aCols[n,nIndCli]
Local cLojCli := aCols[n,nLojCli]

If Empty(cCodCli) 
	cMensag += "Cliente {CT_CLIENTE}" + CRLF                     	
	cSolucao+= "Preencha a coluna referente ao código do cliente" + CRLF
	lRet := .F.
EndIf

If Empty(cLojCli)
	cMensag += "Loja Cliente {CT_LOJA}" + CRLF
	cSolucao+= "Preencha a coluna referente a Loja do cliente" + CRLF
	lRet := .F.
EndIf            

cMensag += cSolucao                                                    

If !lRet
	MSGINFO(cMensag)
EndIf   

Return lRet
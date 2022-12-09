User function VIEWPRW()

Local aRet
Local nCount
// Para retornar a origem da fun��o: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
Local aType 
// Para retornar o nome do arquivo onde foi declarada a fun��o
Local aFile
// Para retornar o n�mero da linha no arquivo onde foi declarada a fun��o
Local aLine
// Para retornar a data do c�digo fonte compilado
Local aDate
// Para retornar a hora do c�digo fonte compilado
Local aTime
Local nT                                               
// Buscar informa��es de todas as fun��es contidas no APO
// tal que tenham a substring 'test' em algum lugar de seu nome
aRet := GetFuncArray('U_*', aType, aFile, aLine, aDate,aTime)
nT := len(aRet)
If nT > 0
	for nCount := 1 To Len(aRet)
       conout(cValtoChar(nCount) + " -1-Funcao = " + aRet[nCount]+"| -2-Arquivo = " + aFile[nCount]+ "| -3-Linha   =     " + aLine[nCount]  + "| -4-Tipo    =     " + aType[nCount] + "| -5-Data    =     " + DtoC(aDate[nCount]) + "| -6-Hora    =     " + aTime[nCount])
	Next 
    MsgInfo("Fontes encontrados. Verifique log de console.")
else 
    MsgStop("Nenhum fonte encontrado.")
Endif    
Return
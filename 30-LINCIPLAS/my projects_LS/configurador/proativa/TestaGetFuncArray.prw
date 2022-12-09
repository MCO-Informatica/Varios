
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTESTAGETFUNCARRAYบAutorณTATIANE DE OLIVEIRAบ Data ณ02/03/2016บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ FUNวรO QUE PASSA PARA O EXCEL TODAS AS USER FUNCTIONS      บฑฑ
ฑฑบ          ณ  ENCONTRADAS NO RPO                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASELVA                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TestaGetFuncArray()
Local aRet
Local nCount
// Para retornar a origem da fun็ใo: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
Local aType
// Para retornar o nome do arquivo onde foi declarada a fun็ใo
Local aFile
// Para retornar o n๚mero da linha no arquivo onde foi declarada a fun็ใo
Local aLine
// Para retornar a data do c๓digo fonte compilado
Local aDate                                                      
// Para retornar a hora do c๓digo fonte compilado
Local aTime

Local cLinhaCSV:=""                                               
// Buscar informa็๕es de todas as fun็๕es contidas no APO
// tal que tenham a substring 'test' em algum lugar de seu nome
aRet := GetFuncArray('U_*', aType, aFile, aLine, aDate,aTime)
	_cNomFile := "c:\temp\userfunction.XLS"
	nHdl := FCreate(_cNomFile)
	If nHdl <= 0
		MsgAlert("Aten็ใo, nใo foi possํvel criar o arquivo " + _cNomFile +"Verifique suas permiss๕es de escrita na unidade ")
		Return(Nil)
		
	else
	
cLinhaCSV+="Funcao " +";"     
cLinhaCSV+="Arquivo " +";"
cLinhaCSV+="Linha " +";"
cLinhaCSV+="Tipo "+";"    
cLinhaCSV+="Data "+";"
cLinhaCSV+="Hora "+";"

FWrite(nHdl,cLinhaCSV+Chr(13)+Chr(10))

cLinhaCSV:=""

for nCount := 1 To Len(aRet)
                                   
     cLinhaCSV+= aRet[nCount]+";"     
     cLinhaCSV+= aFile[nCount]+";"
	cLinhaCSV+= aLine[nCount]+";"
 	cLinhaCSV+= aType[nCount]+";"    
    cLinhaCSV+=DtoC(aDate[nCount])+";"
 	cLinhaCSV+=aTime[nCount]+";"
	
		FWrite(nHdl,cLinhaCSV+Chr(13)+Chr(10))
	
		cLinhaCSV:=""
Next
endif
	FClose(nHdl)
Return
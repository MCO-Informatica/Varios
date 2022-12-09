
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESTAGETFUNCARRAY�Autor�TATIANE DE OLIVEIRA� Data �02/03/2016���
�������������������������������������������������������������������������͹��
���Desc.     � FUN��O QUE PASSA PARA O EXCEL TODAS AS USER FUNCTIONS      ���
���          �  ENCONTRADAS NO RPO                                        ���
�������������������������������������������������������������������������͹��
���Uso       � LASELVA                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TestaGetFuncArray()
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

Local cLinhaCSV:=""                                               
// Buscar informa��es de todas as fun��es contidas no APO
// tal que tenham a substring 'test' em algum lugar de seu nome
aRet := GetFuncArray('U_*', aType, aFile, aLine, aDate,aTime)
	_cNomFile := "c:\temp\userfunction.XLS"
	nHdl := FCreate(_cNomFile)
	If nHdl <= 0
		MsgAlert("Aten��o, n�o foi poss�vel criar o arquivo " + _cNomFile +"Verifique suas permiss�es de escrita na unidade ")
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
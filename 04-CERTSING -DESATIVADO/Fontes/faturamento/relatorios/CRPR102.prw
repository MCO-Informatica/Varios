#INCLUDE "Totvs.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CRPR102  �Autor  �Renato Ruy	       � Data �  08/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Converter arquivos para XLS                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Certisign                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CRPR102(cCaminho,cFile)

Local nHandle		:= 0
Local cArqVBS		:= ""
Local cScript		:= ""
Local nCount		:= 0
Local cUserPath		:= ""

Default cFile 	:= "modelo"
 
cScript := 'Dim xlApp, xlWkb, SourceFolder,TargetFolder,file '+ CRLF
cScript += 'Set xlApp = CreateObject("excel.application") '+ CRLF
cScript += 'Set fs = CreateObject("Scripting.FileSystemObject")'+ CRLF
cScript += CRLF
cScript += 'Const xlNormal=1'+ CRLF
cScript += CRLF
cScript += 'SourceFolder="'+AllTrim(cCaminho)+cFile+'.htm"'+ CRLF
cScript += 'TargetFolder="'+AllTrim(cCaminho)+'"'+ CRLF
cScript += CRLF
cScript += 'xlApp.Visible = false '+ CRLF
cScript += CRLF
cScript += 'Set xlWkb = xlApp.Workbooks.Open(SourceFolder) '+ CRLF
cScript += 'BaseName= fs.getbasename(SourceFolder) '+ CRLF
cScript += 'FullTargetPath=TargetFolder & BaseName & ".xls" '+ CRLF
cScript += 'xlWkb.SaveAs FullTargetPath, xlNormal '+ CRLF
cScript += 'xlWkb.close '+ CRLF
cScript += CRLF
cScript += 'Set xlWkb = Nothing '+ CRLF
cScript += 'Set xlApp = Nothing '+ CRLF
cScript += 'Set fs = Nothing '+ CRLF

//Cria o Arquivo com Script Visual Basic
cArqVBS := AllTrim(cCaminho)+"Vb"+DtoS(Date())+StrTran(Time(),":","")+".vbs"
nHandle		:= FCREATE(cArqVBS, 0)   
fWrite(nHandle, cScript) 
fClose(nHandle)

//Executa para efetuar a cria��o do arquivo convertido
Sleep(1000)
shellExecute( "Open", cArqVBS, "", "", 0)

//Aguarda enquanto arquivo nao e criado
While !FILE(AllTrim(cCaminho)+cFile+".xls") .And. nCount < 11
	Sleep(5000)
	nCount++	
Enddo

//Caso n�o gera os arquivos, vai tentar salvar no Desktop
If !File(AllTrim(cCaminho)+cFile+".xls")
	cUserPath := "C:\Users\" + substr(getTempPath(),10,at("\",substr(GetTempPath(),11))) + "\Desktop\"
	
	If ExistDir(cUserPath)
		__CopyFile(AllTrim(cCaminho)+cFile+".htm", cUserPath+cFile+".htm")
		__CopyFile(AllTrim(cCaminho)+cArqVBS, cUserPath+cArqVBS)
		Alert("N�o foi poss�vel criar o arquivo Excel. " + CRLF + " Os arquivos necess�rios para cria��o ser�o movidos para seu Desktop")
	Else
		Alert("N�o foi poss�vel criar o arquivo Excel.")
	EndIf
	
EndIf

//Apaga script
FERASE(cArqVBS)
//Apaga Arquivo base
FERASE(AllTrim(cCaminho)+cFile+".htm")

Return
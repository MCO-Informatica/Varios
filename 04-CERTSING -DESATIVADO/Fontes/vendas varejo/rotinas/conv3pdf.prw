#INCLUDE "PROTHEUS.CH"                            

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONV3PDF  �Autor  �Opvs                � Data �  01/01/01   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina Personalizada de Gera��o de PDF                      ���
���          �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Conv3PDF(cPrintFile,cPrintPath,cLocalPath)

Local cPdfFile
Local vServer := GetSrvInfo()[1]

// Chama o batch para conversao usando path local da maquina
If !waitrunsrv(cLocalPath+"GeraPDF.bat "+cPrintFile,.T.,cLocalPath)
	conout("Falha de chamada de conversao PDF ["+cLocalPath+"GeraPDF.bat "+cPrintFile+"]")
	return .f.
Endif

// monta o nome do arquivo PDF 
cPdfFile := left(cPrintFile,len(cPrintFile)-1)+"f"

If !file(cLocalPath+cPdfFile,1)
	// nao achou o arquivo, falhou a conversapo
	conout("Falha de execucao de conversao PDF ["+cLocalPath+"GeraPDF.bat "+cPrintFile+"]")
	return .f.
endif

// Se o PDF foi criado, entao deu certo, apaga o script 
ferase(cLocalPath+cPrintFile,1)

If !__copyfile("\\"+vServer+"\espelhonf$\"+cPdfFile,cPrintPath+cPdfFile)  .or. !file(cPrintPath+cPdfFile)
	// Opa, nao conseguiu copiar ? ... q coisa ...  
	conout("Falha na copia de [\\"+vServer+"\espelhonf$\"+cPdfFile+"] para ["+cPrintPath+cPdfFile+"] com error cod "+alltrim(Str(ferror())))
	return .F.
Endif

// Deu certo a copia, joga fora o PDF local 
ferase(cLocalPath+cPdfFile,1)

Return .T.
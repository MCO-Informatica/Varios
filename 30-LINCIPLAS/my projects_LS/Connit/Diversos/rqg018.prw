#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � rqg018  			 Ricardo Felipelli   � Data �  24/06/09   ���
�������������������������������������������������������������������������͹��
���Descricao � deleta arquivos sc do siga                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Laselva                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function rqg018()
Local _Opcao := .f.

If MsgYesNO("Exclui os arquivos temporarios do MICROSIGA ??  ","executa")
	Processa({|| CorrSC()},"Processando...")
EndIf

Return nil


Static Function CorrSC()
//������������������������������������������Ŀ
//� CRIA / Abre os Arquivos de Trabalho      �
//��������������������������������������������
cDiretorio:= "\system\Integracao\FolhaPag\"

cArquivo  := Directory("\system\sc*.*","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\-*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\1*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\2*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\3*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\4*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\5*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\6*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\7*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\8*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\9*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

cArquivo  := Directory("\system\0*.tmp","D")     
For n:=1 to Len(cArquivo)
	IncProc("Importando... Aguarde...") 
	_cArq := cArquivo[n][1]     
	If File (_cArq)
		Delete File &_cArq
	Endif
next

return nil



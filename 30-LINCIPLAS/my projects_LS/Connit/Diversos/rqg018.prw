#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ rqg018  			 Ricardo Felipelli   บ Data ณ  24/06/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ deleta arquivos sc do siga                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Laselva                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function rqg018()
Local _Opcao := .f.

If MsgYesNO("Exclui os arquivos temporarios do MICROSIGA ??  ","executa")
	Processa({|| CorrSC()},"Processando...")
EndIf

Return nil


Static Function CorrSC()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ CRIA / Abre os Arquivos de Trabalho      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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



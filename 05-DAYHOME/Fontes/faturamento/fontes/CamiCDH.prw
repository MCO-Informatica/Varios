#include "tbiconn.ch"
#include "protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"
#include "msmgadd.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCAMICDH   บAutor  ณTechDo Consultoria  บ Data ณ  08/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณIMPRESSAO DE ETIQUETAS CAMICADO EM LINGAGEM ZPL             บฑฑ
ฑฑบ          ณ CARREGA ARQUIVO CSV CAMICADO E CONVERTE EM ZLP             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ DAYHOME                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤCHD(ฟ
//ณCONTROLE DE VERSรO TECHDO   ณ
//ณV. 1.0                      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤCHD(ู


USER FUNCTION CamiCDH()

Local oButton1
Local oButton2
Local oComboBo1

Local oComboBo2
Local nComboBo2 := 1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Static oDlg
private cFileOpen
private aWBrowse1 := {}
private nComboBo1 := 1
private lCtrPrint := .F.

Private oFont:= TFont():New("Courier New",,-8,.T.)



DEFINE MSDIALOG oDlg TITLE "IMPRESSAO DE ETIQUETAS CAMICADO ** DAYHOME**" FROM 000, 000  TO 300, 700 COLORS 0, 16777215 PIXEL

@ 019, 062 SAY oSay1 PROMPT "SELECIONE A PORTA" SIZE 059, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
//@ 028, 062 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"LPT1","LPT2","LPT3","LPT4"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL  
@ 028, 062 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"IMPRESSORA PADRรO"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 019, 149 SAY oSay2 PROMPT "SELECIONE IMPRESSORA" SIZE 069, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
@ 028, 149 MSCOMBOBOX oComboBo2 VAR nComboBo2 ITEMS {"ZEBRA"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 004, 117 SAY oSay3 PROMPT "IMPRESSรO DE ETIQUETAS TERMICAS CAMICADO" SIZE 135, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
@ 027, 239 BUTTON oButton1 PROMPT "ABRIR ARQUIVO" SIZE 056, 012 OF oDlg ACTION Processa( {|| AbreFile() }) PIXEL
@ 128, 148 BUTTON oButton2 PROMPT "IMPRIMIR ETIQUETAS" SIZE 068, 012 OF oDlg ACTION ImpEtiq() PIXEL
fWBrowse1()
@ 110, 061 SAY oSay4 PROMPT "Obs: Duplo clique no produto para informar a quantidade de etiquetas a serem impressas" SIZE 218, 007 OF oDlg COLORS 255, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------
Static Function fWBrowse1()
//------------------------------------------------
Local oWBrowse1

// Insert items here
Aadd(aWBrowse1,{"","","","","","",""})

@ 048, 002 LISTBOX oWBrowse1 Fields HEADER "QUANTIDADE","DESCRICAO","VALOR","EAN","COD.FORNECEDOR","UN","COD SAP" SIZE 345, 060 OF oDlg PIXEL ColSizes 50,50
oWBrowse1:SetArray(aWBrowse1)
oWBrowse1:bLine := {|| {;
aWBrowse1[oWBrowse1:nAt,1],;
aWBrowse1[oWBrowse1:nAt,2],;
aWBrowse1[oWBrowse1:nAt,3],;
aWBrowse1[oWBrowse1:nAt,4],;
aWBrowse1[oWBrowse1:nAt,5],;
aWBrowse1[oWBrowse1:nAt,6],;
aWBrowse1[oWBrowse1:nAt,7];
}}
// DoubleClick event
/* oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
oWBrowse1:DrawSelect()}   */

oWBrowse1:bLDblClick := {|| AltQuant(oWBrowse1:nAt)}

Return

//************************************************************************ FUNCAO PARA ABRIR ARQUIVO CSV *****************************************************************************
static function AbreFile()

Local cExtens	:= "Arquivo CSV | *.csv"
Local cTitulo1  := "Selecione o arquivo"
local aDados := {}
local aCsv := {}
local nX


cFileOpen := cGetFile(cExtens,cTitulo1,2,,.T.,GETF_LOCALHARD,.T.)

If !File(cFileOpen)
	MsgAlert("Arquivo texto: "+cFileOpen+" nใo localizado")
	Return(.F.)
Endif

FT_FUSE(cFileOpen)  //ABRIR
FT_FGOTOP() //PONTO NO TOPO
ProcRegua(FT_FLASTREC()) //QTOS REGISTROS LER

While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
	IncProc()
	
	// Capturar dados
	cBuffer := FT_FREADLN() //LENDO LINHA
	aCsv := Separa(cBuffer,";",.T.)
	Aadd(aDados,aCsv)
	
	FT_FSKIP()  //proximo registro no arquivo txt
EndDo

// 1 nao utilizado
// 2a descricao
// 3a valor
// 4a ean
// 5a codigo fornecedor
// 6a unidade medida
// 7a quantidade * sempre 0 pois vai ser alterada pelo usuario

for nX :=2 to len(aDados)
	// substitui a 1 linha do array criado em branco para montar a grid
	if vazio(alltrim(aWBrowse1[1][2]))
		aWBrowse1[1][1] := 0
		aWBrowse1[1][2] := aDados[nX][2]
		aWBrowse1[1][3] := aDados[nX][3]
		aWBrowse1[1][4] := aDados[nX][4]
		aWBrowse1[1][5] := aDados[nX][5]
		aWBrowse1[1][6] := aDados[nX][6]
		aWBrowse1[1][7] := aDados[nX][1]
	else
		Aadd(aWBrowse1,{0 ,aDados[nX][2] ,aDados[nX][3] ,aDados[nX][4] ,aDados[nX][5] ,aDados[nX][6],aDados[nX][1]})
	endif
	
next nX
lCtrPrint := .T.
return

static function AltQuant(Pos)
Local oButton1
Local oGet1
Local cGet1 := 0
Local oSay1
Local oSay2
Static oDlg1

if vazio(alltrim(aWBrowse1[1][2]))
	MSGALERT("ARQUIVO CAMICADO NรO CARREDADO")
	RETURN
ENDIF

DEFINE MSDIALOG oDlg1 TITLE "Informar Quantidade" FROM 000, 000  TO 100, 200 COLORS 0, 16777215 PIXEL

@ 013, 008 SAY oSay1 PROMPT "Informe a quantidade" SIZE 053, 007 OF oDlg1 COLORS 0, 16777215 PIXEL
@ 021, 008 MSGET oGet1 VAR cGet1 SIZE 037, 010 OF oDlg1 PICTURE "@E 999" COLORS 0, 16777215 PIXEL
@ 020, 055 BUTTON oButton1 PROMPT "INCLUIR" action Close(oDlg1) SIZE 037, 012 OF oDlg1 PIXEL
@ 003, 008 SAY oSay2 PROMPT aWBrowse1[Pos][2] SIZE 100, 007 OF oDlg1 COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTERED

aWBrowse1[Pos][1] := cGet1


return

//************************************************************************** IMPRIME AS ETIQUETAS ***************************************************************************************

STATIC FUNCTION ImpEtiq()
local nX
local nY
local cEtq
local cTemp := GetTempPath()
local cFileName := GetNextAlias() + ".txt"
local nHandle := FCREATE(cTemp+cFileName) // cria um arquivo texto para gerar etiqueta zpl
local cTrlEtq := 1


// valida se o processo de carga do arquivo foi feito
if lCtrPrint == .F.
	msgalert("ARQUIVO CAMICADO NรO CARREGADO, CARREGUE O ARQUIVO E TENTE NOVAMENTE")
	RETURN
ENDIF

	// cria o cabe็alho da etiqueta com as configura็oes de impressao
	cEtq := 'CT~~CD,~CC^~CT~'
    cEtq += Chr(13) + Chr(10)
	cEtq += Chr(13) + Chr(10)
    cEtq += '^XA~TA000~JSN^LT0^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ'
    cEtq += Chr(13) + Chr(10)		
		
// valida se existe algum produto com quantidade 0 a imprimir, se sim pula para o proximo

for nX :=1 to len (aWBrowse1)
	if aWBrowse1[nX][1] == 0  
	loop
	else 	
		for nY :=1 to aWBrowse1[nX][1]
if cTrlEtq == 1		
cEtq += '^XA'
cEtq += Chr(13) + Chr(10)
cEtq += '^MMT'
cEtq += Chr(13) + Chr(10)
cEtq += '^PW863'
cEtq += Chr(13) + Chr(10)
cEtq += '^LL0168'
cEtq += Chr(13) + Chr(10)
cEtq += '^LS0'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT12,17^A0N,11,12^FH\^FD'+Substr(alltrim(aWBrowse1[nX][2]),1,50)+'^FS' 
cEtq += Chr(13) + Chr(10)
cEtq += '^FT12,17^A0N,11,12^FH\^FD'+substr(alltrim(aWBrowse1[nX][2]),51,50)+'^FS' 
cEtq += Chr(13) + Chr(10)
cEtq += '^FT11,40^A0N,14,14^FH\^FDCNPJ 04.784.779/0001-34^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT171,42^A0N,14,14^FH\^FDSAP'+alltrim(aWBrowse1[nX][7])+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT11,67^A0N,17,16^FH\^FDREF '+alltrim(aWBrowse1[nX][5])+'^FS'
cEtq += Chr(13) + Chr(10)
If alltrim(SUBSTR(alltrim(aWBrowse1[nX][3]), 3 ))$""
	cEtq += '^FT165,101^A0N,28,28^FH\^FD^FS'
else
	cEtq += '^FT165,101^A0N,28,28^FH\^FD^FS'
EndIf
cEtq += Chr(13) + Chr(10)
cEtq += '^FT199,101^A0N,28,28^FH\^FD'+alltrim(SUBSTR(alltrim(aWBrowse1[nX][3]), 3 )) +'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^BY2,2,42^FT57,135^BEN,,Y,N'
cEtq += Chr(13) + Chr(10)
cEtq += '^FD'+alltrim(aWBrowse1[nX][4])+'^FS'
cTrlEtq++
elseif cTrlEtq == 2 
cEtq += Chr(13) + Chr(10) 
cEtq += '^FT292,17^A0N,11,12^FH\^FD'+substr(alltrim(aWBrowse1[nX][2]),1,50)+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT292,17^A0N,11,12^FH\^FD'+substr(alltrim(aWBrowse1[nX][2]),51,50)+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT291,40^A0N,14,14^FH\^FDCNPJ 04.784.779/0001-34^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT451,42^A0N,14,14^FH\^FDSAP'+alltrim(aWBrowse1[nX][7])+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT291,67^A0N,17,16^FH\^FDREF '+alltrim(aWBrowse1[nX][5])+' ^FS'
cEtq += Chr(13) + Chr(10)
If alltrim(SUBSTR(alltrim(aWBrowse1[nX][3]), 3 ))$""
	cEtq += '^FT445,101^A0N,28,28^FH\^FD^FS'
else
	cEtq += '^FT445,101^A0N,28,28^FH\^FD^FS'
EndIf
cEtq += Chr(13) + Chr(10)
cEtq += '^FT479,101^A0N,28,28^FH\^FD'+alltrim(SUBSTR(alltrim(aWBrowse1[nX][3]), 3 )) +'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^BY2,2,42^FT337,135^BEN,,Y,N'
cEtq += Chr(13) + Chr(10)
cEtq += '^FD'+alltrim(aWBrowse1[nX][4])+'^FS' 
cTrlEtq++

elseif cTrlEtq == 3 
cEtq += Chr(13) + Chr(10)
cEtq += '^FT572,17^A0N,11,12^FH\^FD'+substr(alltrim(aWBrowse1[nX][2]),1,50)+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT572,17^A0N,11,12^FH\^FD'+substr(alltrim(aWBrowse1[nX][2]),51,50)+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT571,40^A0N,14,14^FH\^FDCNPJ 04.784.779/0001-34^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT731,42^A0N,14,14^FH\^FDSAP'+alltrim(aWBrowse1[nX][7])+'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^FT571,67^A0N,17,16^FH\^FDREF '+alltrim(aWBrowse1[nX][5])+' ^FS'
cEtq += Chr(13) + Chr(10)
If alltrim(SUBSTR(alltrim(aWBrowse1[nX][3]), 3 ))$""
	cEtq += '^FT725,101^A0N,28,28^FH\^FD^FS'
Else
	cEtq += '^FT725,101^A0N,28,28^FH\^FD^FS'
EndIf
cEtq += Chr(13) + Chr(10)
cEtq += '^FT759,101^A0N,28,28^FH\^FD'+alltrim(SUBSTR(alltrim(aWBrowse1[nX][3]), 3 )) +'^FS'
cEtq += Chr(13) + Chr(10)
cEtq += '^BY2,2,42^FT617,135^BEN,,Y,N'
cEtq += Chr(13) + Chr(10)
cEtq += '^FD'+alltrim(aWBrowse1[nX][4])+'^FS'
cEtq += Chr(13) + Chr(10) 
// FINALIZA COLUNA DE ETIQUETAS
cEtq += '^PQ1,0,1,Y^XZ'
cEtq += Chr(13) + Chr(10)
cTrlEtq := 1
endif
    next nY
	ENDIF
next nX
// FINALIZA COLUNA DE ETIQUETAS 
if cTrlEtq < 3
cEtq += '^PQ1,0,1,Y^XZ'
cEtq += Chr(13) + Chr(10) 
cTrlEtq := 1  
endif

			
			// GRAVA AS INFORMAวOES DA ETIQUETA NO ARQUIVO TEXTO
			FWrite(nHandle,cEtq + CRLF)

// FECHA O ARQUIVO
FClose(nHandle)

// EXECUTA O COMANDO PARA IMPRIMIR A ETIQUETA VIA DOS
shellExecute("Open", "C:\Windows\System32\cmd.exe", "/K print "+cFileName, cTemp , 0 )   // IMPRIME SEMPRE NA IMPRESSORA PADRAO
//shellExecute("Open", "C:\Windows\System32\cmd.exe", "/K print "+cFileName+" > LPT"+alltrim(str(nComboBo1)), cTemp , 0 )

MSGINFO('IMPRESSAO CONCLUIDA')   

//APAGA O ARQUIVO UTILIZADO
FERASE(cTemp+cFileName)
Close(oDlg)

RETURN






/*/
(long_description)
@type  Function
@author Template
@since 14/12/2020
@version 1.0
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
#include "Protheus.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include 'tbiconn.ch'
#include "AP5MAIL.CH"

user Function td_etq04()
	Local oButton1
	Local oButton2
	Local oSay1
	Local oSay3
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "GERADOR ETIQUETAS ZEBRA" FROM 000, 000  TO 140, 450 COLORS 0, 16777215 PIXEL

	@ 006, 074 SAY oSay1 PROMPT "SELECIONE O TIPO DE ETIQUETA" SIZE 091, 009 OF oDlg COLORS 4210816, 16777215 PIXEL
	@ 023, 092 SAY oSay3 PROMPT "ETIQUETA MANUAL" SIZE 057, 007 OF oDlg COLORS 16711680, 16777215 PIXEL

	//@ 041, 036 BUTTON oButton1 PROMPT "EAN | LOTE | VALIDADE" SIZE 069, 012 OF oDlg PIXEL action GetEanLoteValid()
	//@ 041, 130 BUTTON oButton2 PROMPT "LOTE | VALIDADE" SIZE 062, 012 OF oDlg PIXEL action GetLoteValid()

	@ 041, 010 BUTTON oButton1 PROMPT "EAN | LOTE | VALIDADE" SIZE 069, 012 OF oDlg PIXEL action GetEanLoteValid()
	@ 041, 085 BUTTON oButton2 PROMPT "LOTE | VALIDADE" SIZE 062, 012 OF oDlg PIXEL action GetLoteValid()
	@ 041, 150 BUTTON oButton3 PROMPT "ETQ. P/ PRATELEIRAS" SIZE 062, 012 OF oDlg PIXEL action Get3Colunas()

	ACTIVATE MSDIALOG oDlg CENTERED


Return


Static Function GetEanLoteValid()

	Local oButton1
	Local oGet1
	Local cEan13   := SPACE(13)
	Local oGet2
	Local cLote    := SPACE(20)
	Local oGet4
	Local dDtvalid := STOD("")
	Local oGet5
	Local nQtd    := SPACE(15)
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "IMPRESSAO ETIQUETAS 50X20X02" FROM 000, 000  TO 200, 450 COLORS 0, 16777215 PIXEL

	@ 005, 036 SAY oSay1 PROMPT "INFORME OS DADOS PARA IMPRESSÃO DAS ETIQUETAS" SIZE 152, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
	@ 023, 009 SAY oSay2 PROMPT "CODIGO EAN" SIZE 040, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 034, 009 MSGET oGet1 VAR cEan13 SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 023, 084 SAY oSay3 PROMPT "NUM. LOTE" SIZE 050, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 034, 084 MSGET oGet2 VAR cLote SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 023, 158 SAY oSay4 PROMPT "VALIDADE" SIZE 028, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 033, 158 MSGET oGet4  VAR dDtvalid SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 062, 009 SAY oSay5 PROMPT "QUANTIDADE" SIZE 038, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 072, 009 MSGET oGet5 VAR nQtd SIZE 044, 010 OF oDlg COLORS 0, 16777215 PIXEL PICTURE "@E 99999"
	@ 072, 084 BUTTON oButton1 PROMPT "IMPRIMIR" SIZE 037, 012 OF oDlg PIXEL action PrintEanLoteValid(cEan13,dDtvalid,cLote,nQtd)

	ACTIVATE MSDIALOG oDlg CENTERED


Return


Static Function GetLoteValid()
	Local oButton1
	Local oGet1
	Local cLote := SPACE(20)
	Local oGet2
	Local dDtvalid := STOD("")
	Local oGet3
	Local nQtd := SPACE(15)
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Static oDlg

	DEFINE MSDIALOG oDlg TITLE "IMPRESSAO ETIQUETAS 30X18X03" FROM 000, 000  TO 150, 400 COLORS 0, 16777215 PIXEL

	@ 003, 026 SAY oSay1 PROMPT "INFORME OS DADOS PARA IMRESSAO DAS ETIQUETAS" SIZE 146, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
	@ 025, 007 SAY oSay2 PROMPT "NUM. LOTE" SIZE 031, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 035, 007 MSGET oGet1 VAR cLote SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025, 074 SAY oSay3 PROMPT "VALIDADE" SIZE 031, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 035, 074 MSGET oGet2 VAR dDtvalid SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025, 142 SAY oSay4 PROMPT "QUANTIDADE" SIZE 036, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 035, 142 MSGET oGet3 VAR nQtd SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL PICTURE "@E 99999"
	@ 056, 084 BUTTON oButton1 PROMPT "IMPRIMIR" SIZE 037, 012 OF oDlg PIXEL action PrintLoteValid(dDtvalid,cLote,nQtd)

	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function PrintEanLoteValid(cEan13,dDtvalid,cLote,nQtd)

	LOCAL nParImpar := int(val(nQtd) % 2)
	LOCAL cEtiqueta := ''
	local nQtdPrint
	local cDtvalid := SUBSTR(dtoc(dDtvalid), 1, 2)+'/'+ SUBSTR(dtoc(dDtvalid), 4, 2)+'/'+SUBSTR(dtoc(dDtvalid), 9, 2)
	local cTemp := GetTempPath()
	local cFileName := GetNextAlias() + ".txt"
	local nHandle := FCREATE(cTemp+cFileName) // cria um arquivo texto para gerar etiqueta zpl

	if empty(alltrim(cEan13)) .Or. len(alltrim(cEan13)) < 13
		alert('EAN INVALIDO')
		Return
	ENDIF

	if empty(alltrim(cLote))
		alert('LOTE INVALIDO')
		Return
	ENDIF

	if empty(alltrim(DTOS(dDtvalid))) .Or. len(alltrim(DTOS(dDtvalid))) < 8
		alert('VALIDADE INVALIDA')
		Return
	ENDIF

	if empty(alltrim(nQtd)) .Or. len(alltrim(nQtd)) <= 0
		alert('QUANTIDADE INVALIDA')
		Return
	ENDIF

	if nParImpar == 0 .And. int(val(nQtd)) == 2
		nQtdPrint := 1
	else
		nQtdPrint := int(val(nQtd)) / 2
	endif

	if nParImpar == 0
		cEtiqueta := '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW831'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0160'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT8,59^A0N,28,52^FH\^FDEAN^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,2,64^FT114,77^BEN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD'+alltrim(cEan13)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT14,134^A0N,28,28^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,42^FT84,144^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT251,40^A0N,28,28^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,47^FT242,89^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf	
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT448,59^A0N,28,52^FH\^FDEAN^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,2,64^FT554,77^BEN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD'+alltrim(cEan13)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT454,134^A0N,28,28^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,42^FT524,144^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT691,40^A0N,28,28^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,47^FT682,89^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta +='^PQ'+alltrim(STR(nQtdPrint))+',0,1,Y^XZ'
	endif

	if nParImpar == 1 .AND. int(val(nQtd)) == 1
		cEtiqueta := '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW831'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0160'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT8,59^A0N,28,52^FH\^FDEAN^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,2,64^FT114,77^BEN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD'+alltrim(cEan13)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT14,134^A0N,28,28^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,42^FT84,144^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT251,40^A0N,28,28^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,47^FT242,89^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ1,0,1,Y^XZ'
	endif

	if nParImpar == 1 .AND. int(val(nQtd)) > 1
		nQtdPrint = int(val(nQtd)) - 1
	ENDIF

	if nParImpar == 1 .AND. int(val(nQtd)) > 1
		cEtiqueta := '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW831'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0160'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT8,59^A0N,28,52^FH\^FDEAN^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,2,64^FT114,77^BEN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD'+alltrim(cEan13)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT14,134^A0N,28,28^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,42^FT84,144^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT251,40^A0N,28,28^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,47^FT242,89^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT448,59^A0N,28,52^FH\^FDEAN^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,2,64^FT554,77^BEN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD'+alltrim(cEan13)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT454,134^A0N,28,28^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,42^FT524,144^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT691,40^A0N,28,28^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,47^FT682,89^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta +='^PQ'+alltrim(STR(nQtdPrint))+',0,1,Y^XZ'
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW831'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0160'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT8,59^A0N,28,52^FH\^FDEAN^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,2,64^FT114,77^BEN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD'+alltrim(cEan13)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT14,134^A0N,28,28^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,42^FT84,144^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT251,40^A0N,28,28^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,47^FT242,89^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ1,0,1,Y^XZ'
	endif

	// GRAVA AS INFORMAÇOES DA ETIQUETA NO ARQUIVO TEXTO
	FWrite(nHandle,cEtiqueta + CRLF)

// FECHA O ARQUIVO
	FClose(nHandle)

// EXECUTA O COMANDO PARA IMPRIMIR A ETIQUETA VIA DOS
	shellExecute("Open", "C:\Windows\System32\cmd.exe", "/K print "+cFileName, cTemp , 0 )   // IMPRIME SEMPRE NA IMPRESSORA PADRAO

	MSGINFO('IMPRESSAO CONCLUIDA')

//APAGA O ARQUIVO UTILIZADO
	FERASE(cTemp+cFileName)
	Close(oDlg)

Return

/*********************************************************************************************************************/

Static Function PrintLoteValid(dDtvalid,cLote,nQtd)

	LOCAL nParImpar := int(val(nQtd) % 2)
	LOCAL cEtiqueta := ''
	local nQtdPrint
	local cDtvalid := SUBSTR(dtoc(dDtvalid), 1, 2)+'/'+ SUBSTR(dtoc(dDtvalid), 4, 2)+'/'+SUBSTR(dtoc(dDtvalid), 9, 2)
	local cTemp := GetTempPath()
	local cFileName := GetNextAlias() + ".txt"
	local nHandle := FCREATE(cTemp+cFileName) // cria um arquivo texto para gerar etiqueta zpl


	if empty(alltrim(cLote))
		alert('LOTE INVALIDO')
		Return
	ENDIF

	if empty(alltrim(DTOS(dDtvalid))) .Or. len(alltrim(DTOS(dDtvalid))) < 8
		alert('VALIDADE INVALIDA')
		Return
	ENDIF

	if empty(alltrim(nQtd)) .Or. len(alltrim(nQtd)) <= 0
		alert('QUANTIDADE INVALIDA')
		Return
	ENDIF


	if nParImpar == 1 .AND. int(val(nQtd)) == 1
		cEtiqueta := '^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI0^XZ'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW719'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0144'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT32,59^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT75,19^A0N,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT9,115^A0N,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT83,121^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ1,0,1,Y^XZ'
	endif

	if nParImpar == 0 .AND. int(val(nQtd)) == 2
	    cEtiqueta := '^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD20^JUS^LRN^CI0^XZ'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW719'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0144'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT687,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT644,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT710,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT636,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT447,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT404,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT470,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT396,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ1,0,1,Y^XZ'
	endif

	if nParImpar == 0 .And. int(val(nQtd)) > 2
		nQtdPrint := int(val(nQtd)) / 3
	endif

	if nParImpar == 0 .And. int(val(nQtd)) > 2
	    cEtiqueta := '^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD20^JUS^LRN^CI0^XZ'
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW719'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0144'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT687,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT644,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT710,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT636,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT447,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT404,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT470,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT396,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT207,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT164,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT230,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT156,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ'+alltrim(STR(INT(nQtdPrint)))+',0,1,Y^XZ'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW719'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0144'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT687,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT644,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT710,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT636,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT447,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT404,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT470,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT396,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ1,0,1,Y^XZ'
	endif


	if nParImpar == 1 .And. int(val(nQtd)) == 3
		nQtdPrint := 1
	elseif nParImpar == 1 .And. int(val(nQtd)) >= 3
		nQtdPrint := int(val(nQtd)) / 3
	endif

	if nParImpar == 1 .And. int(val(nQtd)) >= 3
	    cEtiqueta := '^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD20^JUS^LRN^CI0^XZ'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW719'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0144'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT687,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT644,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT710,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT636,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT447,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT404,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT470,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT396,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,38^FT207,85^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT164,125^A0I,17,38^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT230,29^A0I,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,41^FT156,23^BCI,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		// If Alltrim(cDtvalid)$"31/12/49"
		// 	cEtiqueta += '^FD>:'+'INDETERMINADO'+'^FS'
		// Else
			cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		// EndIf
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ'+alltrim(STR(nQtdPrint))+',0,1,Y^XZ'
	endif

	// GRAVA AS INFORMAÇOES DA ETIQUETA NO ARQUIVO TEXTO
	FWrite(nHandle,cEtiqueta + CRLF)

// FECHA O ARQUIVO
	FClose(nHandle)

// EXECUTA O COMANDO PARA IMPRIMIR A ETIQUETA VIA DOS
	shellExecute("Open", "C:\Windows\System32\cmd.exe", "/K print "+cFileName, cTemp , 0 )   // IMPRIME SEMPRE NA IMPRESSORA PADRAO

	MSGINFO('IMPRESSAO CONCLUIDA')

//APAGA O ARQUIVO UTILIZADO
	FERASE(cTemp+cFileName)
	Close(oDlg)


Return

Static Function Get3Colunas()

	Local oButton1
	Local oGet1
	Local cEan13   := SPACE(13)
	//Local oGet2
	//Local cLote    := SPACE(20)
	//Local oGet4
	//Local dDtvalid := STOD("")
	//LOCAL cEtiqueta := ''
	Local oGet5
	Local nQtd    := SPACE(15)
	Local oSay1
	Local oSay2
	//Local oSay3
	//Local oSay4
	Local oSay5
	Private nQtdPrint
	Static oDlg


	DEFINE MSDIALOG oDlg TITLE "IMPRESSAO DE ETIQUETAS PARA PRATELEIRAS" FROM 000, 000  TO 200, 450 COLORS 0, 16777215 PIXEL

	@ 005, 036 SAY oSay1 PROMPT "INFORME OS DADOS PARA IMPRESSÃO DAS ETIQUETAS" SIZE 152, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
	@ 023, 009 SAY oSay2 PROMPT "COD. PRODUTO" SIZE 040, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 034, 009 MSGET oGet1 VAR cEan13 SIZE 060, 010 OF oDlg F3 "SB1" COLORS 0, 16777215 PIXEL
	@ 062, 009 SAY oSay5 PROMPT "QUANTIDADE" SIZE 038, 007 OF oDlg COLORS 16512, 16777215 PIXEL
	@ 072, 009 MSGET oGet5 VAR nQtd SIZE 044, 010 OF oDlg COLORS 0, 16777215 PIXEL PICTURE "@E 99999"
	@ 072, 084 BUTTON oButton1 PROMPT "IMPRIMIR" SIZE 037, 012 OF oDlg PIXEL action Print3Colunas(cEan13,nQtd)
	ACTIVATE MSDIALOG oDlg CENTERED
Return

Static Function Print3Colunas(cProduto,nQtd)
	local cTemp := GetTempPath()
	local cFileName := GetNextAlias() + ".txt"
	local nHandle := FCREATE(cTemp+cFileName) // cria um arquivo texto para gerar etiqueta zpl
	nQtdPrint := nQtd
	//Alert(ctemp)
	//Alert(cFileName)
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(XfILIAL("SB1")+CProduto))
	If Empty(AllTrim(SB1->B1_CODBAR))
		alert('Codigo de barras sem preenchimento. Atualize o codigo de barras no cadastro do produto')
		Return
	Endif
	If SubStr(SB1->B1_CODBAR,13,1) = ' '
		alert('EAN Invalido, atualize o codigo de barras no cadastro do produto')
		Return
	Endif
	if Empty(AllTrim(nQtd)) .Or. Len(AllTrim(nQtd)) <= 0
		alert('Quantidade invalida. A quantidade a ser impressa deve ser maior ou igual a 1')
		Return
	Endif
/*
    cEtiqueta := "."
    cEtiqueta += " "
    cEtiqueta += "N"
    cEtiqueta += "D7"
    cEtiqueta += "S2"
    cEtiqueta += "R23,0"
    cEtiqueta += "Q208,24"
    // Descrição Linha 1 Coluna 1
    cEtiqueta += "[A0,10,0,2,1,1,N,]"+SUBSTR(SB1->B1_DESC,1,18)+"[]"
    // Descrição Linha 1 Coluna 2
    cEtiqueta += "[A280,10,0,2,1,1,N,]"+SUBSTR(SB1->B1_DESC,1,18)+"[]"
    // Descrição Linha 1 Coluna 3
    cEtiqueta += "[A560,10,0,2,1,1,N,]"+SUBSTR(SB1->B1_DESC,1,18)+"[]"
    // Descrição Linha 2 Coluna 1
    cEtiqueta += "[A0,30,0,2,1,1,N,]"+SUBSTR(SB1->B1_DESC,19,18)+"[]"
    // Descrição Linha 2 Coluna 2
    cEtiqueta += "[A280,30,0,2,1,1,N,]"+SUBSTR(SB1->B1_DESC,19,18)+"[]"
    // Descrição Linha 2 Coluna 3
    cEtiqueta += "[A560,30,0,2,1,1,N,]"+SUBSTR(SB1->B1_DESC,19,18)+"[]"
    // Codigo Linha 3 Coluna 1
    cEtiqueta += "[A0,50,0,2,1,1,N,]"+"Cod:"+ALLTRIM(SB1->B1_COD)+"[]"
    // Codigo Linha 3 Coluna 2
    cEtiqueta += "[A280,50,0,2,1,1,N,]"+"Cod:"+ALLTRIM(SB1->B1_COD)+"[]"
    // Codigo Linha 3 Coluna 3
    cEtiqueta += "[A560,50,0,2,1,1,N,]"+"Cod:"+ALLTRIM(SB1->B1_COD)+"[]"
    // EAN Linha 4 Coluna 1
    cEtiqueta += "[B0,70,0,E30,2,2,50,B,]"+SUBSTR(SB1->B1_CODBAR,1,15)+"[]"
    // EAN Linha 4 Coluna 2
    cEtiqueta += "[B280,70,0,E30,2,2,50,B,]"+SUBSTR(SB1->B1_CODBAR,1,15)+"[]"
    // EAN Linha 4 Coluna 3
    cEtiqueta += "[B560,70,0,E30,2,2,50,B,]"+SUBSTR(SB1->B1_CODBAR,1,15)+"[]"
    // Abaixo é se desejar colocar peso, ai terá que habilitar a variavel vCVa para confirmar
    //If vCVa = "S"
    //    cEtiqueta += "[A05,135,0,2,2,1,N,"+"Peso ]"+LTrim(Transform(SB1->B1_PESO,"999.999"))+"[]"
    //    cEtiqueta += "[A285,135,0,2,2,1,N,"+"Peso ]"+LTrim(Transform(SB1->B1_PESO,"999.999"))+"[]"
    //    cEtiqueta += "[A565,135,0,2,2,1,N,"+"Peso ]"+LTrim(Transform(SB1->B1_PESO,"999.999"))+"[]"
    //Endif
    cEtiqueta += "P"+AllTrim(nQtd)
    cEtiqueta += "."
    cEtiqueta += " "
*/
// Inicio etiqueta
      /*
      cEtiqueta := " CT~~CD,~CC^~CT~"+Chr(13) + Chr(10)
      cEtiqueta += "^XA"+Chr(13)+Chr(10)
      cEtiqueta += "~TA000"+Chr(13)+Chr(10)
      cEtiqueta += "~JSN"+Chr(13)+Chr(10)
      cEtiqueta += "^LT0"+Chr(13)+Chr(10)
      cEtiqueta += "^MNW"+Chr(13)+Chr(10)
      cEtiqueta += "^MTT"+Chr(13)+Chr(10)
      cEtiqueta += "^PON"+Chr(13)+Chr(10)
      cEtiqueta += "^PMN"+Chr(13)+Chr(10)
      cEtiqueta += "^LH0,0"+Chr(13)+Chr(10)
      cEtiqueta += "^JMA"+Chr(13)+Chr(10)
      cEtiqueta += "^PR6,6"+Chr(13)+Chr(10)
      cEtiqueta += "~SD15"+Chr(13)+Chr(10)
      cEtiqueta += "^JUS"+Chr(13)+Chr(10)
      cEtiqueta += "^LRN"+Chr(13)+Chr(10)
      cEtiqueta += "^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^PA0,1,1,0"+Chr(13)+Chr(10)
      cEtiqueta += "^XZ"+Chr(13)+Chr(10)
      cEtiqueta += "^XA"+Chr(13)+Chr(10)
      cEtiqueta += "^MMT"+Chr(13)+Chr(10)
      cEtiqueta += "^PW1110"+Chr(13)+Chr(10)
      cEtiqueta += "^LL283"+Chr(13)+Chr(10)
      cEtiqueta += "^LS0"+Chr(13)+Chr(10)

      // Posição e conteúdo primeira etiqueta
      cEtiqueta += "^BY3,3,87^FT50,212^BCN,,Y,N"+Chr(13)+Chr(10)
      //cEtiqueta += "^FH\^FD>;123456789012^FS"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+SubStr(cProduto,1,12)+"^FS"+Chr(13)+Chr(10)
      //cEtiqueta += "^FT47,85^A0N,29,28^FH\^CI28^FDPRODUTO^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^FT47,85^A0N,29,28^FH\^CI28^FD"+cProduto+"^FS^CI27"+Chr(13)+Chr(10)      

      // Posição e conteúdo segunda etiqueta
      cEtiqueta += "^BY3,3,87^FT404,212^BCN,,Y,N"+Chr(13)+Chr(10)
      //cEtiqueta += "^FH\^FD>;123456789012^FS"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+SubStr(cProduto,1,12)+"^FS"+Chr(13)+Chr(10)      
      //cEtiqueta += "^FT401,85^A0N,29,28^FH\^CI28^FDPRODUTO^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^FT401,85^A0N,29,28^FH\^CI28^FD"+cProduto+"^FS^CI27"+Chr(13)+Chr(10)

      // Posição e conteúdo terceira etiqueta
      cEtiqueta += "^BY3,3,87^FT758,212^BCN,,Y,N"+Chr(13)+Chr(10)
      //cEtiqueta += "^FH\^FD>;123456789012^FS"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+SubStr(cProduto,1,12)+"^FS"+Chr(13)+Chr(10)      
      //cEtiqueta += "^FT755,85^A0N,29,28^FH\^CI28^FDPRODUTO^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^FT755,85^A0N,29,28^FH\^CI28^FD"+cProduto+"^FS^CI27"+Chr(13)+Chr(10)
      
      //cEtiqueta += "^PQ1,0,1,Y"+Chr(13)+Chr(10) // Quantidade de Etiquetas
      cEtiqueta += "^PQ"+alltrim(STR(nQtdPrint))+",0,1,Y"+Chr(13)+Chr(10)
      cEtiqueta += "^XZ"+Chr(13)+Chr(10)
*/
//DbSelectArea("SB1")
//DbSetOrder(1)
//DbSeek(XfILIAL("SB1")+CProduto)
//SB1->(DbSetOrder(1))
//SB1->(DbSeek(XfILIAL("SB1")+CProduto))
/*
     cEtiqueta := " CT~~CD,~CC^~CT~"+Chr(13) + Chr(10)
      cEtiqueta += "^XA"+Chr(13)+Chr(10)
      cEtiqueta += "~TA000"+Chr(13)+Chr(10)
      cEtiqueta += "~JSN"+Chr(13)+Chr(10)
      cEtiqueta += "^LT0"+Chr(13)+Chr(10)
      cEtiqueta += "^MNW"+Chr(13)+Chr(10)
      cEtiqueta += "^MTT"+Chr(13)+Chr(10)
      cEtiqueta += "^PON"+Chr(13)+Chr(10)
      cEtiqueta += "^PMN"+Chr(13)+Chr(10)
      cEtiqueta += "^LH0,0"+Chr(13)+Chr(10)
      cEtiqueta += "^JMA"+Chr(13)+Chr(10)
      cEtiqueta += "^PR8,8"+Chr(13)+Chr(10)
      cEtiqueta += "~SD30"+Chr(13)+Chr(10)
      cEtiqueta += "^JUS"+Chr(13)+Chr(10)
      cEtiqueta += "^LRN"+Chr(13)+Chr(10)
      cEtiqueta += "^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^PA0,1,1,0"+Chr(13)+Chr(10)
      cEtiqueta += "^XZ"+Chr(13)+Chr(10)
      cEtiqueta += "^XA"+Chr(13)+Chr(10)
      cEtiqueta += "^MMT"+Chr(13)+Chr(10)
      cEtiqueta += "^PW767"+Chr(13)+Chr(10)
      cEtiqueta += "^LL192"+Chr(13)+Chr(10)
      cEtiqueta += "^LS0"+Chr(13)+Chr(10)

      cEtiqueta += "^BY1,3,56^FT64,108^BCN,,Y,N"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+Substr(SB1->B1_CODBAR,1,15)+"^FS"+Chr(13)+Chr(10)+Chr(13)+Chr(10)
      cEtiqueta += "^FT4,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,24)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^FT244,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,25,24)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^BY1,3,56^FT304,108^BCN,,Y,N"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+Substr(SB1->B1_CODBAR,1,15)+"^FS"+Chr(13)+Chr(10)

      cEtiqueta += "^FT244,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,24)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^FT484,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,25,24)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^BY1,3,56^FT544,108^BCN,,Y,N"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+Substr(SB1->B1_CODBAR,1,15)+"^FS"+Chr(13)+Chr(10)

      cEtiqueta += "^FT484,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,24)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^FT724,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,25,24)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^PQ"+alltrim(nQtdPrint)+",0,1,Y"+Chr(13)+Chr(10)
      cEtiqueta += "^XZ"+Chr(13)+Chr(10)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

//este trecho funcionava normalmente, porém foi substituído pelo trecho similiar acima, iniciado na linha 614 à 629 devido a melhorias

//para centralização das informações da etiquete

     /* cEtiqueta += "^FT4,41^A0N,11,18^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,15)+"^FS^CI27"+Chr(13)+Chr(10)
      //cEtiqueta += "^FT74,73^A0N,21,25^FH\^CI28^FD"+Substr(SB1->B1_DESC,16,15)+"^FS^CI27"+Chr(13)+Chr(10)
      cEtiqueta += "^BY1,3,84^FT97,140^BCN,,Y,N"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+Substr(SB1->B1_CODBAR,1,15)+"^FS"+Chr(13)+Chr(10)

      
      cEtiqueta += "^FT270,52^A0N,14,15^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,15)+"^FS^CI27"+Chr(13)+Chr(10)
      //cEtiqueta += "^FT428,73^A0N,21,25^FH\^CI28^FD"+Substr(SB1->B1_DESC,16,15)+"^FS^CI27"+Chr(13)+Chr(10)      
      cEtiqueta += "^BY1,3,84^FT337,140^BCN,,Y,N"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+Substr(SB1->B1_CODBAR,1,15)+"^FS"+Chr(13)+Chr(10)

      cEtiqueta += "^FT510,52^A0N,14,15^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,15)+"^FS^CI27"+Chr(13)+Chr(10)
      //cEtiqueta += "^FT782,73^A0N,21,25^FH\^CI28^FD"+Substr(SB1->B1_DESC,16,15)+"^FS^CI27"+Chr(13)+Chr(10)      
      cEtiqueta += "^BY1,3,84^FT577,140^BCN,,Y,N"+Chr(13)+Chr(10)
      cEtiqueta += "^FH\^FD>;"+Substr(SB1->B1_CODBAR,1,15)+"^FS"+Chr(13)+Chr(10)

      cEtiqueta += "^PQ"+alltrim(nQtdPrint)+",0,1,Y"+Chr(13)+Chr(10)
      cEtiqueta += "^XZ"+Chr(13)+Chr(10)*/

	cEtiqueta := "CT~~CD,~CC^~CT~"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XA"
	cEtiqueta += "~TA000"
	cEtiqueta += "~JSN"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LT0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^MNW"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^MTT"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PON"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PMN"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LH0,0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^JMA"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PR6,6"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "~SD15"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^JUS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LRN"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PA0,1,1,0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XZ"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XA"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^MMT"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PW744"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LL165"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LS0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,35^A0N,21,10^FB247,1,5,C^FH\^CI28^FD"+alltrim(Substr(SB1->B1_DESC,1,35))+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,56^A0N,21,10^FB247,1,5,C^FH\^CI28^FD"+alltrim(Substr(SB1->B1_DESC,36,15))+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^BY2,2,34^FT34,107^BEN,,Y,N"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FH\^FD"+Substr(SB1->B1_CODBAR,1,13)+"^FS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,35^A0N,21,10^FB743,1,5,C^FH\^CI28^FD"+alltrim(Substr(SB1->B1_DESC,1,35))+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,56^A0N,21,10^FB743,1,5,C^FH\^CI28^FD"+alltrim(Substr(SB1->B1_DESC,36,15))+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^BY2,2,34^FT282,107^BEN,,Y,N"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FH\^FD"+Substr(SB1->B1_CODBAR,1,13)+"^FS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT495,35^A0N,21,10^FB249,1,5,C^FH\^CI28^FD"+alltrim(Substr(SB1->B1_DESC,1,35))+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT495,56^A0N,21,10^FB249,1,5,C^FH\^CI28^FD"+alltrim(Substr(SB1->B1_DESC,36,15))+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^BY2,2,34^FT530,107^BEN,,Y,N"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FH\^FD"+Substr(SB1->B1_CODBAR,1,13)+"^FS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PQ1,0,1,Y"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XZ"

/*
	cEtiqueta := "CT~~CD,~CC^~CT~"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XA"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "~TA000"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "~JSN"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LT0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^MNW"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^MTT"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PON"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PMN"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LH0,0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^JMA"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PR6,6"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "~SD15"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^JUS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LRN"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PA0,1,1,0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XZ"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XA"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^MMT"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PW709"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LL165"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^LS0"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,35^A0N,21,10^FB237,1,5,C^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,35)+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,56^A0N,21,10^FB237,1,5,C^FH\^CI28^FD"+Substr(SB1->B1_DESC,36,15)+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^BY2,2,34^FT29,107^BEN,,Y,N"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FH\^FD"+Substr(SB1->B1_CODBAR,1,13)+"^FS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,35^A0N,21,10^FB709,1,5,C^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,35)+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT0,56^A0N,21,10^FB709,1,5,C^FH\^CI28^FD"+Substr(SB1->B1_DESC,36,15)+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^BY2,2,34^FT265,107^BEN,,Y,N"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FH\^FD"+Substr(SB1->B1_CODBAR,1,13)+"^FS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT472,35^A0N,21,10^FB237,1,5,C^FH\^CI28^FD"+Substr(SB1->B1_DESC,1,35)+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FT472,56^A0N,21,10^FB237,1,5,C^FH\^CI28^FD"+Substr(SB1->B1_DESC,36,15)+"^FS^CI27"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^BY2,2,34^FT501,107^BEN,,Y,N"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^FH\^FD"+Substr(SB1->B1_CODBAR,1,13)+"^FS"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^PQ1,0,1,Y"
	cEtiqueta += Chr(13) + Chr(10)
	cEtiqueta += "^XZ"
*/
    // GRAVA AS INFORMAÇOES DA ETIQUETA NO ARQUIVO TEXTO
    FWrite(nHandle,cEtiqueta + CRLF)
    // FECHA O ARQUIVO
    FClose(nHandle)
    // EXECUTA O COMANDO PARA IMPRIMIR A ETIQUETA VIA DOS
    shellExecute("Open", "C:\Windows\System32\cmd.exe", "/K print "+cFileName, cTemp , 0 )   // IMPRIME SEMPRE NA IMPRESSORA PADRAO
    MSGINFO('IMPRESSAO CONCLUIDA')
    //APAGA O ARQUIVO UTILIZADO
    //FERASE(cTemp+cFileName)
    Close(oDlg)

Return



(long_description)
@type  Function
@author TechDo
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

user Function td_etq01()
	Local oButton1
	Local oButton2
	Local oSay1
	Local oSay3
	Static oDlg

  DEFINE MSDIALOG oDlg TITLE "GERADOR ETIQUETAS ZEBRA" FROM 000, 000  TO 140, 450 COLORS 0, 16777215 PIXEL

    @ 006, 074 SAY oSay1 PROMPT "SELECIONE O TIPO DE ETIQUETA" SIZE 091, 009 OF oDlg COLORS 4210816, 16777215 PIXEL
    @ 041, 036 BUTTON oButton1 PROMPT "EAN | LOTE | VALIDADE" SIZE 069, 012 OF oDlg PIXEL action GetEanLoteValid()
    @ 023, 092 SAY oSay3 PROMPT "ETIQUETA MANUAL" SIZE 057, 007 OF oDlg COLORS 16711680, 16777215 PIXEL
    @ 041, 130 BUTTON oButton2 PROMPT "LOTE | VALIDADE" SIZE 062, 012 OF oDlg PIXEL action GetLoteValid()
	

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
	local cDtvalid := SUBSTR(dtoc(dDtvalid), 4, 2)+'/'+ SUBSTR(dtoc(dDtvalid), 0, 2)+'/'+SUBSTR(dtoc(dDtvalid), 7, 2)
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
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
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
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
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
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
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
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
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
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
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
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
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
	local nQtdEtq := val(alltrim(nQtd))
	LOCAL cEtiqueta := ''
	local nX    :=0
	local nCTRL :=1
	local cDtvalid := SUBSTR(dtoc(dDtvalid), 4, 2)+'/'+ SUBSTR(dtoc(dDtvalid), 0, 2)+'/'+SUBSTR(dtoc(dDtvalid), 7, 2)
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
        cEtiqueta := '^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD30^JUS^LRN^CI0^XZ'		
	for nX := 1 to nQtdEtq
	    if nCTRL == 1		
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^XA'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^MMT'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PW823'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LL0168'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^LS0'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^BY1,3,59^FT84,69^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT8,53^A0N,18,31^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT12,130^A0N,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)	
		cEtiqueta += '^BY1,3,53^FT105,147^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)	
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		cEtiqueta += Chr(13) + Chr(10)	
		nCTRL ++	
		elseif nCTRL == 2		
		cEtiqueta += '^BY1,3,59^FT364,69^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT288,53^A0N,18,31^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT292,130^A0N,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)	
		cEtiqueta += '^BY1,3,53^FT385,147^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)	
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'	
		cEtiqueta += Chr(13) + Chr(10)
		nCTRL ++		
		elseif nCTRL == 3		
		cEtiqueta += '^BY1,3,59^FT643,69^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FD>:'+alltrim(cLote)+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT567,53^A0N,18,31^FH\^FDLOTE^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^FT571,130^A0N,20,16^FH\^FDVALIDADE^FS'
		cEtiqueta += Chr(13) + Chr(10)	
		cEtiqueta += '^BY1,3,53^FT664,147^BCN,,Y,N'
		cEtiqueta += Chr(13) + Chr(10)	
		cEtiqueta += '^FD>:'+cDtvalid+'^FS'
		cEtiqueta += Chr(13) + Chr(10)
		cEtiqueta += '^PQ1,0,1,Y^XZ'		
		nCTRL := 1		
		endif		
	next nX
		if nCTRL > 1		
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

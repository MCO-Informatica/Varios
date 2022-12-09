#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "tbiconn.ch"
#INCLUDE "tbicode.ch"
#DEFINE  ENTER CHR(13)+CHR(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ   Geracao Vale Alimenta็ใo Alelo                 23/11/2021บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Geracao Vale Alimenta็ใo Alelo                           บฑฑ
ฑฑบ                                                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  */
User Function GERAVA()

cPerg 	:= Padr("ARQUVRA",10)

Private lMsErroAuto := .F.

ValidPerg()
Pergunte(cPerg,.F.)

cCadastro     := " "
aSays         := {}
aButtons      := {}
_nOpc         := 0

AADD(aSays,"Gera็ใo do arquivo Vale     ")
AADD(aSays,"Alimentacao  - Alelo ")
AADD(aSays,"")
AADD(aButtons,{5,.T.,{|| Pergunte(cPerg,.T.)	}})
AADD(aButtons,{1,.T.,{|| (_nOpc := 1, FechaBatch())	}})
AADD(aButtons,{2,.T.,{|| FechaBatch() 		  	}})

FormBatch(cCadastro, aSays, aButtons)

If _nOpc = 1
	Processa({|| ARQUVRA()},cCadastro)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAVA    บAutor  ณMicrosiga           บ Data ณ  10/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ARQUVRA()						




Local cType := OemToAnsi("Selecione o Diretorio")
Local cPath  := ""
Local cNomeA := DtoC(ddatabase)
Local cArq := "\VA"+'_'+substring (cNomeA, 4,2) +'_'+substring (cNomeA, 7,4)+'.xls'
Local nCnt := 0

// cPath := cGetFile(cType, OemToAnsi("Selecione o Diretorio "), 0,, .F., 128+16)
cPath := TFileDialog( cType,cType, 0, , .f., 128+16)

cFilDe  	:= mv_par01
cFilAte     := mv_par02
cCcDe    	:= mv_par03
cCcAte 	    := mv_par04
cMatDe		:= mv_par05
cMatAte		:= mv_par06
cPerioDe    := mv_Par07
cPerioAte   := mv_Par08


cQuery := " SELECT RA_NOME                    AS NOME, 
cQuery += "       RA_CIC                     AS CPF, 
cQuery += "       SUBSTRING(RA_NASC, 7, 2)+'/'+SUBSTRING(RA_NASC, 5, 2)+'/'+SUBSTRING(RA_NASC, 1, 4) AS NASCIMENTO, 
cQuery += "       RA_SEXO                    AS SEXO, 
cQuery += "       R0_VALCAL                  AS VALOR, 
cQuery += "       'FI'                       AS TPLOCENTRE, 
cQuery += "       SUBSTRING(RGC_CPFCGC,11,4)  	 AS LOCENTRE, 
cQuery += "       R0_MAT                     AS MATRICULA, 
// cQuery += "       RGC_XCONVC                 AS CONTRATO 
cQuery += " '00011610119' as CONTRATO 
cQuery += " FROM   SR0010 SR0 
cQuery += "       INNER JOIN SRA010 SRA 
cQuery += "               ON SRA.D_E_L_E_T_ = ' ' 
cQuery += "                  AND R0_FILIAL = RA_FILIAL 
cQuery += "                  AND R0_MAT = RA_MAT 
cQuery += "                  AND RA_SITFOLH <> 'D' 
cQuery += "        			 AND RA_CC BETWEEN '"+cCcDe+"' AND '"+cCcAte+"' 
cQuery += "       INNER JOIN RGC010 RGC 
cQuery += "               ON RGC.D_E_L_E_T_ = ' ' 
cQuery += "                  AND RGC_FILIAL = '"+XFILIAL("RGC")+"'
//cQuery += "                  AND RGC_KEYLOC = RA_LOCBNF 
// cQuery += "       INNER JOIN RFO010 RFO 
// cQuery += "               ON RFO.D_E_L_E_T_ = ' ' 
// cQuery += "                  AND R0_TPVALE = RFO_TPVALE 
// cQuery += "                  AND R0_CODIGO = RFO_CODIGO 
// cQuery += "                  AND RFO_TPBEN = '03' 
cQuery += " WHERE  SR0.D_E_L_E_T_ = ' ' 
cQuery += "       AND R0_TPVALE = '2'
cQuery += "	      AND R0_VALCAL > 0
cQuery += "       AND R0_PERIOD BETWEEN '"+cPerioDe+"' AND '"+cPerioAte+"' 
cQuery += "       AND R0_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' 
cQuery += "       AND R0_MAT BETWEEN '"+cMatDe+"' AND '"+cMatAte+"' 

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"SQL",.F.,.T.)
DbSelectArea("SQL")
SQL->(DbGoTop())

Count To nCnt
SQL->(DbGoTop())

If !SQL->(Eof())
    CabBook(cPath+cArq, nCnt+3) //+ 3 linhas de cabe็alho

        //Itens do relatorio
        PrintLine(cPath+cArq,;
        "",;
        "CONTRATO")

        //Itens do relatorio
        PrintLine(cPath+cArq,;
        Padr("%",02),;
		Padr(SQL->CONTRATO ,11),;
        Padr("%" ,02))

        //Itens do relatorio
        PrintLine(cPath+cArq,;
        "",;
        "Nome",; 
        "CPF",; 
        "Nascimento",;
        "Sexo",;
        "Valor",;
        "Tipo de Local de Entrega",;
        "Local de Entrega",;
        "Matricula",;
        Padr("%" ,02))
	
	DO While !SQL->(Eof())

			//Itens do relatorio
			PrintLine(cPath+cArq,;
			Padr("%",02),;
			Padr(SQL->NOME ,50),; 
			Padr(SQL->CPF ,20),; 
            Padr(SQL->NASCIMENTO,10),;
            Padr(SQL->SEXO ,02),;
            Padr(SQL->VALOR ,17),;
            Padr(SQL->TPLOCENTRE ,02),;
            Padr(SQL->LOCENTRE ,09),;
            Padr(SQL->MATRICULA ,06),;
            Padr("%" ,02))
		
		SQL->( dbSkip())
		
	EndDo

	//Fecha as tas do relatorio
	CloseBook(cPath+cArq)
	
	
	// cCam  := cGetFile(cType, OemToAnsi("Selecione o Diretorio "), 0,, .F., 128+16)
	// _cArq := U_Tab3Excel("TMP2",,cCam,cNomeArq)
	
	// FCLOSE(cArquivo)
	
	// FERASE(cArquivo)

	// SQL->(DbCloseArea())
	// TMP2->(DbCloseArea())
else
	MSGSTOP("Nใo existe registros, verifique os cadastros.")
Endif
SQL->(DbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabBook	  บAutor  ณMicrosiga         บ Data ณ  19/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabe็alho do arquivo			                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CabBook(cArq, nCont)

	Local cDadosArq	:= ""

	Default nCont	:= 0

	cDadosArq   := '<?xml version="1.0"?>' +CRLF
	cDadosArq   += '<?mso-application progid="Excel.Sheet"?>' +CRLF
	cDadosArq   += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' +CRLF
	cDadosArq   += ' xmlns:o="urn:schemas-microsoft-com:office:office"' +CRLF
	cDadosArq   += ' xmlns:x="urn:schemas-microsoft-com:office:excel"' +CRLF
	cDadosArq   += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' +CRLF
	cDadosArq   += ' xmlns:html="http://www.w3.org/TR/REC-html40">' +CRLF
	cDadosArq   += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' +CRLF
	cDadosArq   += '  <Author>elton_csantana</Author>' +CRLF
	cDadosArq   += '  <LastAuthor>elton_csantana</LastAuthor>' +CRLF
	cDadosArq   += '  <Created>2019-07-10T16:45:23Z</Created>' +CRLF
	cDadosArq   += '  <LastSaved>2019-07-10T16:48:21Z</LastSaved>' +CRLF
	cDadosArq   += '  <Version>14.00</Version>' +CRLF
	cDadosArq   += ' </DocumentProperties>' +CRLF
	cDadosArq   += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' +CRLF
	cDadosArq   += '  <AllowPNG/>' +CRLF
	cDadosArq   += ' </OfficeDocumentSettings>' +CRLF
	cDadosArq   += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '  <WindowHeight>5460</WindowHeight>' +CRLF
	cDadosArq   += '  <WindowWidth>14355</WindowWidth>' +CRLF
	cDadosArq   += '  <WindowTopX>360</WindowTopX>' +CRLF
	cDadosArq   += '  <WindowTopY>45</WindowTopY>' +CRLF
	cDadosArq   += '  <ProtectStructure>False</ProtectStructure>' +CRLF
	cDadosArq   += '  <ProtectWindows>False</ProtectWindows>' +CRLF
	cDadosArq   += ' </ExcelWorkbook>' +CRLF
	cDadosArq   += ' <Styles>' +CRLF
	cDadosArq   += '  <Style ss:ID="Default" ss:Name="Normal">' +CRLF
	cDadosArq   += '   <Alignment ss:Vertical="Bottom"/>' +CRLF
	cDadosArq   += '   <Borders/>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '   <Interior/>' +CRLF
	cDadosArq   += '   <NumberFormat/>' +CRLF
	cDadosArq   += '   <Protection/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s16" ss:Name="Vรญrgula">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s62">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="Short Date"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s63">' +CRLF
	cDadosArq   += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' +CRLF
	cDadosArq   += '    ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s68">' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' +CRLF
	cDadosArq   += '    ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#DDD9C4" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s73">' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' +CRLF
	cDadosArq   += '    ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#DDD9C4" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s74">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s75" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' +CRLF
	cDadosArq   += '    ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#DDD9C4" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s76" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s77" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"' +CRLF
	cDadosArq   += '    ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF

	cDadosArq   += '<Style ss:ID="s88">' +CRLF
	cDadosArq   += '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' +CRLF
	cDadosArq   += '<Borders>' +CRLF
	cDadosArq   += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '</Borders>' +CRLF
	cDadosArq   += '<Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"' +CRLF
	cDadosArq   += 'ss:Bold="1"/>' +CRLF
	cDadosArq   += '<Interior ss:Color="#FFFF00" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '</Style>' +CRLF

	cDadosArq   += ' </Styles>' +CRLF
	cDadosArq   += ' <Worksheet ss:Name="Plan1">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="10" ss:ExpandedRowCount="'+Alltrim(Str(nCont))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:Width="81"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s74" ss:Width="55.5"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="104.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s74" ss:Width="59.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="270.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s74" ss:Width="79.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s74" ss:AutoFitWidth="0" ss:Width="190.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s76" ss:Width="67.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s76" ss:Width="70"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s76" ss:Width="55.75"/>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintLine	  บAutor  ณMicrosiga         บ Data ณ  10/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLinha do arquivo				                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintLine(cArq, cTxt01, cTxt02, cTxt03, cTxt04, cTxt05, cTxt06, cTxt07, cTxt08, cTxt09, cTxt10 )

	Local cDadosArq	:= ""

	Default cTxt01		:= ""
	Default cTxt02		:= ""
	Default cTxt03		:= ""
	Default cTxt04		:= ""
	Default cTxt05		:= ""
	Default cTxt06		:= ""
	Default cTxt07		:= ""
	Default cTxt08		:= ""
	Default cTxt09		:= ""
	Default cTxt10		:= ""

	cDadosArq   := '   <Row>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt01+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt02+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt03+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt04+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt05+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt06+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt07+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt08+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt09+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cTxt10+'</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseBook	  บAutor  ณMicrosiga         บ Data ณ  10/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha o arquivo				                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CloseBook(cArq)

	Local cDadosArq	:= ""

	cDadosArq   := '  </Table>' +CRLF
	cDadosArq   += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '   <PageSetup>' +CRLF
	cDadosArq   += '    <Header x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <Footer x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' +CRLF
	cDadosArq   += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' +CRLF
	cDadosArq   += '   </PageSetup>' +CRLF
	cDadosArq   += '   <Selected/>' +CRLF
	cDadosArq   += '   <Panes>' +CRLF
	cDadosArq   += '    <Pane>' +CRLF
	cDadosArq   += '     <Number>3</Number>' +CRLF
	cDadosArq   += '     <ActiveRow>3</ActiveRow>' +CRLF
	cDadosArq   += '     <ActiveCol>2</ActiveCol>' +CRLF
	cDadosArq   += '    </Pane>' +CRLF
	cDadosArq   += '   </Panes>' +CRLF
	cDadosArq   += '   <ProtectObjects>False</ProtectObjects>' +CRLF
	cDadosArq   += '   <ProtectScenarios>False</ProtectScenarios>' +CRLF
	cDadosArq   += '  </WorksheetOptions>' +CRLF
	cDadosArq   += ' </Worksheet>' +CRLF
	cDadosArq   += '</Workbook>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvTxtArq  บAutor  ณMicrosiga          บ Data ณ  05/01/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava o texto no final do arquivo                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GrvTxtArq( cArq, cTexto )

	Local nHandle := 0

	Default cArq	:= "" 
	Default cTexto	:= ""

	If !Empty(cArq)
		If !File( cArq )
			nHandle := FCreate( cArq )
			FClose( nHandle )
		Endif

		If File( cArq )
			nHandle := FOpen( cArq, 2 )
			FSeek( nHandle, 0, 2 )	// Posiciona no final do arquivo
			FWrite( nHandle, cTexto + Chr(13) + Chr(10), Len(cTexto)+2 )
			FClose( nHandle)
		Endif
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGERAVA    บAutor  ณMicrosiga           บ Data ณ  10/29/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg

Local _sAlias, aRegs, i,j

_sAlias := Alias()
aRegs := {}
I := 0
J := 0

dbSelectArea("SX1")
dbSetOrder(1)

Aadd(aRegs,{cPerg,"01","Filial de?     ", "Filial    ?",		"Filial    ?",		"mv_ch1","C",06,0,0,"G" ,"","mv_par01","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SM0",""})
Aadd(aRegs,{cPerg,"02","Filial Ate?    ", "Filial    ?",		"Filial    ?",		"mv_ch2","C",06,0,0,"G" ,"","mv_par02","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SM0",""})
Aadd(aRegs,{cPerg,"03","C.Custo de?    ", "Custol    ?",		"Custo     ?",		"mv_ch3","C",09,0,0,"G" ,"","mv_par03","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SI3",""})
Aadd(aRegs,{cPerg,"04","C.Custo Ate?   ", "Custol    ?",		"Custo     ?",		"mv_ch4","C",09,0,0,"G" ,"","mv_par04","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SI3",""})
Aadd(aRegs,{cPerg,"05","Matricula de?  ", "Matricula ?",		"Matricula ?",		"mv_ch5","C",06,0,0,"G" ,"","mv_par05","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SRA",""})
Aadd(aRegs,{cPerg,"06","Matricula Ate? ", "Matricula ?",		"Matricula ?",		"mv_ch6","C",06,0,0,"G" ,"","mv_par06","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SRA",""})
Aadd(aRegs,{cPerg,"07","Periodo de?    ", "Periodo   ?",		"Periodo   ?",		"mv_ch7","C",06,0,0,"G" ,"","mv_par07","","","","","","","","","","","","","","","","","","",""	,""	,""	,""	,"","","SR0",""})
Aadd(aRegs,{cPerg,"08","Periodo Ate?   ", "Periodo   ?",		"Periodo   ?",		"mv_ch8","C",06,0,0,"G" ,"","mv_par08","","","","","","","","","","","","","","","","","","","",""	,""	,""	,"","","SR0",""})


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next


dbSelectArea(_sAlias)

Return

#include 'protheus.ch'

Static nHandle := 0

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR009		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio forecast excel									  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
User function PZCVR009()

	Local aArea		:= GetArea()
	Local aParam	:= {}
	Local cArq 		:= "ForeCast_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"

	If PergRel(@aParam)
		Processa( {|| RunRel(Alltrim(aParam[1])+cArq, aParam[2], aParam[3], aParam[4]) },"Aguarde...","" )

		If File(Alltrim(aParam[1])+cArq)
			MsgRun( "Aguarde...",, { || OpenExcel(Alltrim(aParam[1])+cArq) } )
		EndIf		
	EndIf

	RestArea(aArea)	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRunRel		บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a rotina de gera็ใo do relatorio					  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunRel(cArq, cCodSegDe, cCodSegAte, nAno)

	Local aArea		:= GetArea()

	Default cArq		:= "" 
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	ProcRegua(4)
	IncProc("Processando...")
	
	//Cabe็alho do Workbook
	IncProc("Processando (Sintetica)...") 
	CabBook(cArq)

	//Preenchimento dos dados da aba sintetica
	IncProc("Processando (Sintetica)...")
	AbaSintet(cArq, cCodSegDe, cCodSegAte, nAno)

	//Preenchimento dos dados da aba analitica
	IncProc("Processando (Analitica)...")  
	AbaAnalit(cArq, cCodSegDe, cCodSegAte, nAno)

	/* Em Desenvolvimento - Denis Varella 30/06 */
	//Preenchimento dos dados da aba Volume
	// IncProc("Processando (Volumes)...")  
	// AbaVolume(cArq, cCodSegDe, cCodSegAte, nAno)

	//FECHA O WORKBOOK
	CloseBook(cArq)
	
	//Fecha o arquivo
	FClose( nHandle )

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabBook	  บAutor  ณMicrosiga         บ Data ณ  14/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabe็alho do workbook                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function CabBook(cArq)

	Local aArea 		:= GetArea()
	Local cDadosArq   := ""     

	Default cArq 		:= ""

	cDadosArq   := '<?xml version="1.0"?>' +CRLF
	cDadosArq   += '<?mso-application progid="Excel.Sheet"?>' +CRLF
	cDadosArq   += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' +CRLF
	cDadosArq   += ' xmlns:o="urn:schemas-microsoft-com:office:office"' +CRLF
	cDadosArq   += ' xmlns:x="urn:schemas-microsoft-com:office:excel"' +CRLF
	cDadosArq   += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' +CRLF
	cDadosArq   += ' xmlns:html="http://www.w3.org/TR/REC-html40">' +CRLF
	cDadosArq   += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' +CRLF
	cDadosArq   += '  <Author>prozyn</Author>' +CRLF
	cDadosArq   += '  <LastAuthor>prozyn</LastAuthor>' +CRLF
	cDadosArq   += '  <Created>2019-10-14T13:36:54Z</Created>' +CRLF
	cDadosArq   += '  <LastSaved>2019-10-14T13:46:31Z</LastSaved>' +CRLF
	cDadosArq   += '  <Version>14.00</Version>' +CRLF
	cDadosArq   += ' </DocumentProperties>' +CRLF
	cDadosArq   += ' <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">' +CRLF
	cDadosArq   += '  <AllowPNG/>' +CRLF
	cDadosArq   += ' </OfficeDocumentSettings>' +CRLF
	cDadosArq   += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '  <WindowHeight>8010</WindowHeight>' +CRLF
	cDadosArq   += '  <WindowWidth>20115</WindowWidth>' +CRLF
	cDadosArq   += '  <WindowTopX>240</WindowTopX>' +CRLF
	cDadosArq   += '  <WindowTopY>60</WindowTopY>' +CRLF
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
	cDadosArq   += '  <Style ss:ID="s63" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s64">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s65" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s66">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s67">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += ' </Styles>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbaSintet  บAutor  ณMicrosiga     บ Data ณ 	   31/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenchimento da Aba sintetica		                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function AbaSintet(cArq, cCodSegDe, cCodSegAte, nAno)

	Local aArea	:= GetArea()
	Local cArqTmp	:= ""
	Local nCnt		:= 0

	Default cArq		:= "" 
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	//Inicializa a tabela temporaria da aba sintetica
	cArqTmp := U_PZCVP008(1, cCodSegDe, cCodSegAte, nAno)

	//Contagem da quantidade de linhas
	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || (cArqTmp)->(!Eof()) } ) )
	(cArqTmp)->( DbGoTop() )

	//Preenche o cabe็alho do relatorio
	WkBookSt(cArq, nCnt)

	//Preenche as linhas da aba sintetica
	PrtSheetS(cArq, cArqTmp, nCnt)

	//Fecha a tag do worksheet 
	CloseWkSt(cArq)

	//Fecha a tabela temporaria e encerra o processamento
	U_PZCVP008(2)

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWkBookSt  บAutor  ณMicrosiga 	     บ Data ณ  14/10/19		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche o cabe็alho da aba sintetica					      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function WkBookSt(cArq, nCnt)

	Local aArea		:= GetArea()
	Local cDadosArq	:= ""

	Default cArq	:= ""
	Default nCnt	:= 0

	cDadosArq   := ' <Worksheet ss:Name="Sintetico">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="8" ss:ExpandedRowCount="'+Alltrim(Str(nCnt+10))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:AutoFitWidth="0" ss:Width="67.5"/>' +CRLF
	cDadosArq   += '   <Column ss:AutoFitWidth="0" ss:Width="150"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s63" ss:AutoFitWidth="0" ss:Width="108" ss:Span="3"/>' +CRLF
	cDadosArq   += '   <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="108" ss:Span="1"/>' +CRLF
	cDadosArq   += '   <Row ss:AutoFitHeight="0">' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Mรชs</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Unidade de Negรณcio</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">2019</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">2020</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">Forecast</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">Budget</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Real | Forecast 2019</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Real + Pedidos</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrtSheetS  บAutor  ณMicrosiga 	     บ Data ณ  14/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche as linhas do relatorio da aba sintetica		      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function PrtSheetS(cArq, cArqTmp, nCnt)

	Local aArea  		:= GetArea()
	Local cDadosArq   	:= ""

	Default cArq		:= "" 
	Default cArqTmp		:= "" 
	Default nCnt		:= 0

	While (cArqTmp)->(!Eof())

		cDadosArq   := '   <Row ss:AutoFitHeight="0">' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->SIN_DMES+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->SIN_DESCUN+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAANT,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAATU,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_FORECA,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_BUDGET,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAFC,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAPVA,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '   </Row>' +CRLF

		GrvTxtArq( cArq, cDadosArq )

		(cArqTmp)->(DbSkip())
	EndDo

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseWkSt  บAutor  ณMicrosiga      บ Data ณ  14/10/19		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha a tag do Worksheet(Aba) sitetica				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function CloseWkSt(cArq)

	Local aArea			:= GetArea()
	Local cDadosArq   	:= ""

	cDadosArq   := '  </Table>' +CRLF
	cDadosArq   += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '   <PageSetup>' +CRLF
	cDadosArq   += '    <Header x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <Footer x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' +CRLF
	cDadosArq   += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' +CRLF
	cDadosArq   += '   </PageSetup>' +CRLF
	cDadosArq   += '   <Unsynced/>' +CRLF
	cDadosArq   += '   <Print>' +CRLF
	cDadosArq   += '    <ValidPrinterInfo/>' +CRLF
	cDadosArq   += '    <PaperSizeIndex>9</PaperSizeIndex>' +CRLF
	cDadosArq   += '    <HorizontalResolution>600</HorizontalResolution>' +CRLF
	cDadosArq   += '    <VerticalResolution>0</VerticalResolution>' +CRLF
	cDadosArq   += '   </Print>' +CRLF
	cDadosArq   += '   <Selected/>' +CRLF
	cDadosArq   += '   <Panes>' +CRLF
	cDadosArq   += '    <Pane>' +CRLF
	cDadosArq   += '     <Number>3</Number>' +CRLF
	cDadosArq   += '     <ActiveRow>12</ActiveRow>' +CRLF
	cDadosArq   += '     <ActiveCol>2</ActiveCol>' +CRLF
	cDadosArq   += '    </Pane>' +CRLF
	cDadosArq   += '   </Panes>' +CRLF
	cDadosArq   += '   <ProtectObjects>False</ProtectObjects>' +CRLF
	cDadosArq   += '   <ProtectScenarios>False</ProtectScenarios>' +CRLF
	cDadosArq   += '  </WorksheetOptions>' +CRLF
	cDadosArq   += ' </Worksheet>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbaAnalit  บAutor  ณMicrosiga     บ Data ณ 	   31/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenchimento da Aba analitica		                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function AbaAnalit(cArq, cCodSegDe, cCodSegAte, nAno)

	Local aArea	:= GetArea()
	Local cArqTmp	:= ""
	Local nCnt		:= 0

	Default cArq		:= "" 
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	//Inicializa a tabela temporaria da aba sintetica
	cArqTmp := U_PZCVP009(1, cCodSegDe, cCodSegAte, nAno)

	//Contagem da quantidade de linhas
	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || (cArqTmp)->(!Eof()) } ) )
	(cArqTmp)->( DbGoTop() )

	//Preenche o cabe็alho do relatorio
	WkBookAn(cArq, nCnt)

	//Preenche as linhas da aba sintetica
	PrtSheetA(cArq, cArqTmp, nCnt)

	//Fecha a tag do worksheet 
	CloseWkAn(cArq)

	//Fecha a tabela temporaria e encerra o processamento
	U_PZCVP009(2)

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWkBookAn  บAutor  ณMicrosiga     บ Data ณ 	   31/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche o cabe็alho da aba analitica		                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function WkBookAn(cArq, nCnt)

	Local aArea		:= GetArea()
	Local cDadosArq	:= ""

	Default cArq	:= ""
	Default nCnt	:= 0

	cDadosArq   := ' <Worksheet ss:Name="Analitico">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="14" ss:ExpandedRowCount="'+Alltrim(Str(nCnt+10))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:Width="60"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="119.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="89.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="38.25" ss:Span="1"/>' +CRLF
	cDadosArq   += '   <Column ss:Index="6" ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="205.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="93"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="246.75"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="69.75" ss:Span="1"/>' +CRLF
	cDadosArq   += '   <Column ss:Index="11" ss:Width="75"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="69.75"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="99"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="73.5"/>' +CRLF
	cDadosArq   += '   <Row ss:AutoFitHeight="0">' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Mรชs</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Unidade de Negรณcio</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Grupo de Clientes</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Cliente</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Loja</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Nome </Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Cรณdigo de Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Descriรงรฃo de Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">2019</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">2020</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">Forecast</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">Budget</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Real | Forecast 2019</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Real + Pedidos</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrtSheetA  บAutor  ณMicrosiga 	     บ Data ณ  14/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche as linhas do relatorio da aba analitica		      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function PrtSheetA(cArq, cArqTmp, nCnt)

	Local aArea  		:= GetArea()
	Local cDadosArq   	:= ""

	Default cArq		:= "" 
	Default cArqTmp		:= "" 
	Default nCnt		:= 0


	While (cArqTmp)->(!Eof())

		cDadosArq   	:= ""
		
		cDadosArq   := '   <Row ss:AutoFitHeight="0">' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_DMES+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_DESCUN+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_GRPVEN+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_CLIENT+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_LOJA+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_NOME+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_PROD+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->ANL_DESCPR+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->ANL_REAANT,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->ANL_REAATU,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->ANL_FORECA,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->ANL_BUDGET,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->ANL_REAFC,2)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->ANL_REAPVA,2)))+'</Data></Cell>' +CRLF 		
		cDadosArq   += '   </Row>' +CRLF


		/*cDadosArq   := '   <Row ss:AutoFitHeight="0">' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->SIN_DMES+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->SIN_DESCUN+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAANT,0)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAATU,0)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_FORECA,0)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_BUDGET,0)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAFC,0)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell ss:StyleID="s63"><Data ss:Type="Number">'+Alltrim(Str(round((cArqTmp)->SIN_REAPVA,0)))+'</Data></Cell>' +CRLF
		cDadosArq   += '   </Row>' +CRLF*/

		GrvTxtArq( cArq, cDadosArq )

		(cArqTmp)->(DbSkip())
	EndDo

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseWkSt  บAutor  ณMicrosiga      บ Data ณ  14/10/19		  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha a tag do Worksheet(Aba) analitico				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function CloseWkAn(cArq)

	Local aArea			:= GetArea()
	Local cDadosArq   	:= ""

	cDadosArq   := '  </Table>' +CRLF
	cDadosArq   += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '   <PageSetup>' +CRLF
	cDadosArq   += '    <Header x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <Footer x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' +CRLF
	cDadosArq   += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' +CRLF
	cDadosArq   += '   </PageSetup>' +CRLF
	cDadosArq   += '   <Unsynced/>' +CRLF
	cDadosArq   += '   <Print>' +CRLF
	cDadosArq   += '    <ValidPrinterInfo/>' +CRLF
	cDadosArq   += '    <PaperSizeIndex>9</PaperSizeIndex>' +CRLF
	cDadosArq   += '    <HorizontalResolution>600</HorizontalResolution>' +CRLF
	cDadosArq   += '    <VerticalResolution>600</VerticalResolution>' +CRLF
	cDadosArq   += '   </Print>' +CRLF
	cDadosArq   += '   <Panes>' +CRLF
	cDadosArq   += '    <Pane>' +CRLF
	cDadosArq   += '     <Number>3</Number>' +CRLF
	cDadosArq   += '     <ActiveRow>3</ActiveRow>' +CRLF
	cDadosArq   += '     <ActiveCol>7</ActiveCol>' +CRLF
	cDadosArq   += '    </Pane>' +CRLF
	cDadosArq   += '   </Panes>' +CRLF
	cDadosArq   += '   <ProtectObjects>False</ProtectObjects>' +CRLF
	cDadosArq   += '   <ProtectScenarios>False</ProtectScenarios>' +CRLF
	cDadosArq   += '  </WorksheetOptions>' +CRLF
	cDadosArq   += ' </Worksheet>' 

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbaAnalit  บAutor  ณMicrosiga     บ Data ณ 	   31/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenchimento da Aba volume   		                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function AbaVolume(cArq, cCodSegDe, cCodSegAte, nAno)

	Local aArea	:= GetArea()
	Local cArqTmp	:= ""
	Local nCnt		:= 0

	Default cArq		:= "" 
	Default cCodSegDe	:= "" 
	Default cCodSegAte	:= ""
	Default nAno		:= 0

	//Inicializa a tabela temporaria da aba sintetica
	cArqTmp := U_PZCVP011(1, cCodSegDe, cCodSegAte, nAno)

	//Contagem da quantidade de linhas
	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || (cArqTmp)->(!Eof()) } ) )
	(cArqTmp)->( DbGoTop() )

	//Preenche o cabe็alho do relatorio
	WkBookVl(cArq, nCnt)

	//Preenche as linhas da aba sintetica
	PrtSheetA(cArq, cArqTmp, nCnt)

	//Fecha a tag do worksheet 
	CloseWkAn(cArq)

	//Fecha a tabela temporaria e encerra o processamento
	U_PZCVP011(2)

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWkBookAn  บAutor  ณMicrosiga     บ Data ณ 	   31/03/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche o cabe็alho da aba analitica		                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function WkBookVl(cArq, nCnt)

	Local aArea		:= GetArea()
	Local cDadosArq	:= ""

	Default cArq	:= ""
	Default nCnt	:= 0

	cDadosArq   := ' <Worksheet ss:Name="Volumes">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="14" ss:ExpandedRowCount="'+Alltrim(Str(nCnt+10))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:Width="60"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="119.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="89.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="38.25" ss:Span="1"/>' +CRLF
	cDadosArq   += '   <Column ss:Index="6" ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="205.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="93"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="246.75"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="69.75" ss:Span="1"/>' +CRLF
	cDadosArq   += '   <Column ss:Index="11" ss:Width="75"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="69.75"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="99"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="73.5"/>' +CRLF
	cDadosArq   += '   <Row ss:AutoFitHeight="0">' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Mรชs</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Unidade de Negรณcio</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Grupo de Clientes</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Cliente</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Loja</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Nome </Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Cรณdigo de Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s67"><Data ss:Type="String">Descriรงรฃo de Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">2019</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">2020</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">Forecast</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s65"><Data ss:Type="String">Budget</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Real | Forecast 2019</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s64"><Data ss:Type="String">Real + Pedidos</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseWkBook  บAutor  ณMicrosiga        บ Data ณ  21/09/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha o Workbook                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function CloseBook(cArq)

	Local aArea 		:= GetArea()
	Local cDadosArq   	:= ""     
	Default cArq 		:= ""

	cDadosArq   := '</Workbook>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
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

	

	Default cArq	:= "" 
	Default cTexto	:= ""

	If !Empty(cArq)
		If !File( cArq )
			nHandle := FCreate( cArq )
			//FClose( nHandle )
		Endif

		If File( cArq )
			//nHandle := FOpen( cArq, 2 )
			FSeek( nHandle, 0, 2 )	// Posiciona no final do arquivo
			FWrite( nHandle, cTexto + Chr(13) + Chr(10), Len(cTexto)+2 )
		Endif
	EndIf

Return   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPergRel  บAutor  ณMicrosiga	         บ Data ณ  01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPergunta para selecionar o arquivo                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PergRel(aParam)

	Local aArea 		:= GetArea()
	Local aParamBox		:= {} 
	Local lRet			:= .F.
	Local cLoadArq		:= "pzcvr009_"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)		

	AADD(aParamBox,{6,"Endere็o destino do arquivo",Space(1000),"","ExistDir(&(ReadVar()))","",080,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY})
	AADD(aParamBox,{1,"Unid.Negoc. De"	,Space(TamSx3("ADK_COD")[1])	,"","","ADK","",50,.F.})
	AADD(aParamBox,{1,"Unid.Negoc. At้"	,Space(TamSx3("ADK_COD")[1])	,"","","ADK","",50,.T.})
	AADD(aParamBox,{1,"Ano"				,Year(MsDate())					,"@E 9999","","","",50,.T.})

	//Monta a pergunta
	lRet := ParamBox(aParamBox, "Parโmetros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

	RestArea(aArea)
Return lRet  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOpenExcel  บAutor  ณMicrosiga	         บ Data ณ  10/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAbre o arquivo do excel			                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OpenExcel(cArq)

	Local aArea 	:= GetArea()
	Local oExcelApp	:= Nil

	Default cArq 	:= ""

	If File(cArq)
		If !ApOleCliente( "MsExcel" )
			Aviso("Aten็ใo","Microsoft Excel nใo Instalado... Contate o Administrador do Sistema!",{"Ok"},2)
		Else
			oExcelApp:=MsExcel():New()
			oExcelApp:WorkBooks:Open( cArq )
			oExcelApp:SetVisible( .T. )
			oExcelApp:Destroy()
		EndIf
	Else
		Aviso("Aten็ใo","Arquivo nใo encontrado: "+CRLF+cArq,{"Ok"},2)
	EndIf

	RestArea(aArea)
Return

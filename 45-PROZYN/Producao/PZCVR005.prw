#include 'protheus.ch'

#DEFINE DIRETORIO 	1
#DEFINE DTDIGITDE 	2
#DEFINE DTDIGITATE 	3
#DEFINE DOCDE	 	4
#DEFINE DOCATE	 	5
#DEFINE SERIEDE	 	6
#DEFINE SERIEATE 	7
#DEFINE CLIENTEDE 	8
#DEFINE CLIENTEATE 	9
#DEFINE LOJADE 		10
#DEFINE LOJAATE 	11


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVRM05		บAutor  ณMicrosiga	     บ Data ณ  03/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvio do relatorio de produtos devolvidos por e-mail		  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVRM05(dDtDigit, cDoc, cSerie, cCodCli, cLoja )

	Local cMailDest		:= ""
	Local cArq 			:= ""
	Local cAssunto		:= "Relat๓rio produtos devolvidos - NF: "
	Local cMensagem		:= "Mensagem automแtica, favor nใo responder."
	Local cEmailCc		:= ""
	Local cAnexos		:= ""
	Local cMsgErr		:= ""

	Default dDtDigit	:= CTOD('') 
	Default cDoc		:= "" 
	Default cSerie		:= "" 
	Default cCodCli		:= "" 
	Default cLoja		:= "" 

	//Diretorio temporario, para grava็ใo do arquivo
	cDir		:= "\_Relatorios\"

	//Dados para envio do e-mail
	cMailDest	:= U_MyNewSX6("CV_MAILDEV", ""		,"C","E-mail dos destinatแrios que receberใo o relat๓rio de produtos devolvidos", "", "", .F. )
	cMsgErr		:= ""

	//Nome do arquivo
	cArq := ""
	cArq := "relProdutosDevolvidos_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"

	//Diretorio e nome do arquivo a ser utilizado no anexo do e-mail
	cAnexos 	+= cDir+cArq+";" 
	cAssunto	+= Alltrim(cDoc)+"/"+Alltrim(cSerie)
	GerRel(Alltrim(cDir),;			//Diretorio 
	Alltrim(cArq),; 	//Nome do arquivo
	dDtDigit,; 			//Data de digita็ใo de
	dDtDigit,; 			//Data de digita็ใo ate
	Alltrim(cDoc),; 	//Documento de 
	Alltrim(cDoc),; 	//Documento ate
	Alltrim(cSerie),; 	//Serie de 
	Alltrim(cSerie),; 	//Serie ate
	Alltrim(cCodCli),; 	//Cliente de
	Alltrim(cCodCli),; 	//Cliente ate
	Alltrim(cLoja),; 	//Loja de
	Alltrim(cLoja),; 	//Loja ate
	.T.)				//Envia e-mail


	//Verifica se o arquivo foi gerado corretamente
	If File(cDir+cArq)
		//Envio do e-mail
		EnvMail(cMailDest,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

		//Exclui o arquivo ap๓s o envio
		FERASE(cDir+cArq)
	EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR005		บAutor  ณMicrosiga	     บ Data ณ  30/08/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de produtos devolvidos						      บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function PZCVR005()

	Local cArq 		:= "RelProdutosDevolvidos_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls" 
	Local aParam	:= {}

	If PergRel(@aParam)

		GerRel(Alltrim(aParam[DIRETORIO]),;		//Diretorio 
		cArq,; 							//Nome do arquivo
		aParam[DTDIGITDE],; 			//Data de digita็ใo de
		aParam[DTDIGITATE],; 			//Data de digita็ใo ate
		Alltrim(aParam[DOCDE]),; 		//Documento de 
		Alltrim(aParam[DOCATE]),; 		//Documento ate
		Alltrim(aParam[SERIEDE]),; 		//Serie de 
		Alltrim(aParam[SERIEATE]),; 	//Serie ate
		Alltrim(aParam[CLIENTEDE]),; 	//Cliente de
		Alltrim(aParam[CLIENTEATE]),; 	//Cliente ate
		Alltrim(aParam[LOJADE]),; 		//Loja de
		Alltrim(aParam[LOJAATE]),; 		//Loja ate
		.F.)							//Envia e-mail
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGerRel บAutor  ณMicrosiga 	          บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o relatorio											  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GerRel(cDir, cArq, dDtDigDe, dDtDigAte, cDocDe, cDocAte,; 
	cSerieDe, cSerieAte, cCliDe, cClitAte, cLojaDe, cLojaAte, lMail)

	Local aArea		:= GetArea()
	Local cArqTmp 	:= ""
	Local nCnt		:= 0

	Default cDir		:= "" 
	Default cArq		:= "" 
	Default dDtDigDe	:= CTOD('')
	Default dDtDigAte	:= CTOD('')
	Default cDocDe		:= ""
	Default cDocAte		:= ""
	Default cSerieDe	:= ""
	Default cSerieAte	:= ""
	Default cCliDe		:= ""
	Default cClitAte	:= ""
	Default cLojaDe		:= ""
	Default cLojaAte	:= ""
	Default lMail		:= .F.

	//Dados do relatorio
	cArqTmp := GetArqTmp(dDtDigDe, dDtDigAte, cDocDe, cDocAte, cSerieDe, cSerieAte, cCliDe, cClitAte, cLojaDe, cLojaAte)

	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqTmp)->( DbGoTop() )

	If nCnt > 0
		//Cabe็alho do relatorio
		CabBook(cDir+cArq, nCnt)

		//Impressใo dos itens do relatorio
		Processa( {|| PrintSheet(cDir+cArq, nCnt, cArqTmp) },"Aguarde...","" )

		//Fecha as tags do relatorio
		CloseBook(cDir+cArq)

		If !lMail
			//Abre o excel
			MsgRun( "Aguarde...",, { || OpenExcel(cDir+cArq) } )
		EndIf

	EndIf
	
	//Fecha tabela temporaria
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf	

	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabBook บAutor  ณMicrosiga 	          บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabe็aho do Excel											  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CabBook(cArq, nCnt)

	Local aArea	 	:= GetArea()
	Local cDadosArq	:= ""

	Default cArq		:= "" 
	Default nCnt		:= 0

	cDadosArq   += '<?xml version="1.0"?>' +CRLF
	cDadosArq   += '<?mso-application progid="Excel.Sheet"?>' +CRLF
	cDadosArq   += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' +CRLF
	cDadosArq   += ' xmlns:o="urn:schemas-microsoft-com:office:office"' +CRLF
	cDadosArq   += ' xmlns:x="urn:schemas-microsoft-com:office:excel"' +CRLF
	cDadosArq   += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' +CRLF
	cDadosArq   += ' xmlns:html="http://www.w3.org/TR/REC-html40">' +CRLF
	cDadosArq   += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' +CRLF
	cDadosArq   += '  <Author>prozyn</Author>' +CRLF
	cDadosArq   += '  <LastAuthor>prozyn</LastAuthor>' +CRLF
	cDadosArq   += '  <Created>2019-08-30T18:12:02Z</Created>' +CRLF
	cDadosArq   += '  <LastSaved>2019-08-30T18:34:42Z</LastSaved>' +CRLF
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
	cDadosArq   += '  <Style ss:ID="s17">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s18" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s19">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s20" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s66">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="Short Date"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s75">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#538DD5" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += ' </Styles>' +CRLF
	cDadosArq   += ' <Worksheet ss:Name="Plan1">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="17" ss:ExpandedRowCount="'+Alltrim(Str(nCnt+10))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:Width="72"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:Width="59.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="92.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="281.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="57"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="57"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="32.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="216.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s18" ss:Width="60"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s18" ss:Width="60"/>' +CRLF	
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="110.25"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="72"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="72"/>' +CRLF	
	cDadosArq   += '   <Column ss:Width="96"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:Width="80.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s17" ss:AutoFitWidth="0" ss:Width="70.25"/>' +CRLF
		
	cDadosArq   += '   <Row>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Data Digitaรงรฃo</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Documento</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Serie</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Descriรงรฃo</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Tipo</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Cliente</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Loja</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Nome</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s20"><Data ss:Type="String">Quantidade</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s20"><Data ss:Type="String">Valor Total</Data></Cell>' +CRLF	
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Lote</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Dt.Validade</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Dt.Fabricaรงรฃo</Data></Cell>' +CRLF

	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Dt.Emissรฃo Origem</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Doc. de Origem</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s19"><Data ss:Type="String">Serie Origem </Data></Cell>' +CRLF


	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintSheet บAutor  ณMicrosiga 	      บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime linha												  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintSheet(cArq, nCnt, cArqTmp)

	Local aArea 		:= GetArea()
	Local cDadosArq		:= ""
	Local dDtVld		:= CTOD('')
	Local dDtFab		:= CTOD('')
	Local cLocal		:= U_MyNewSX6("CV_ARZFABD", "98","C","Armazem a ser considerado na busca da data de validade e fabrica็ใo", "", "", .F. )
	Default nCnt := 0

	ProcRegua(nCnt)

	While (cArqTmp)->(!Eof())

		IncProc("Processando...")

		If Empty(cLocal)
			cLocal := (cArqTmp)->D1_LOCAL
		EndIf
		//Preenche a data de fabrica็ใo e validade
		dDtVld		:= CTOD('')
		dDtFab		:= CTOD('')
		SetDtVldFab(@dDtVld, @dDtFab, (cArqTmp)->D1_COD, cLocal, (cArqTmp)->D1_LOTECTL, (cArqTmp)->D1_NUMLOTE)
		
		cDadosArq   += '   <Row>' +CRLF
		If !Empty((cArqTmp)->D1_DTDIGIT)
			cDadosArq   += '    <Cell ss:StyleID="s66"><Data ss:Type="DateTime">'+GetDtConv(STOD((cArqTmp)->D1_DTDIGIT))+'T00:00:00.000</Data></Cell>' +CRLF
		Else
			cDadosArq   += '    <Cell ss:StyleID="s66"/>' +CRLF
		EndIf
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->D1_DOC)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->D1_SERIE)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->D1_COD)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+UPPER(NoAcento(Alltrim((cArqTmp)->B1_DESC)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->B1_TIPO)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->A1_COD)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->A1_LOJA)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+UPPER(NoAcento(Alltrim((cArqTmp)->A1_NREDUZ)))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(STR((cArqTmp)->D1_QUANT))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(STR((cArqTmp)->D1_TOTAL))+'</Data></Cell>' +CRLF		
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->D1_LOTECTL)+'</Data></Cell>' +CRLF
		
		
		If !Empty(dDtVld)
			cDadosArq   += '    <Cell ss:StyleID="s66"><Data ss:Type="DateTime">'+GetDtConv(dDtVld)+'T00:00:00.000</Data></Cell>' +CRLF
		Else
			cDadosArq   += '    <Cell ss:StyleID="s66"/>' +CRLF
		EndIf

		If !Empty(dDtFab)
			cDadosArq   += '    <Cell ss:StyleID="s66"><Data ss:Type="DateTime">'+GetDtConv(dDtFab)+'T00:00:00.000</Data></Cell>' +CRLF
		Else
			cDadosArq   += '    <Cell ss:StyleID="s66"/>' +CRLF
		EndIf				
		

		If !Empty((cArqTmp)->F2_EMISSAO)
			cDadosArq   += '    <Cell ss:StyleID="s66"><Data ss:Type="DateTime">'+GetDtConv(STOD((cArqTmp)->F2_EMISSAO))+'T00:00:00.000</Data></Cell>' +CRLF
		Else
			cDadosArq   += '    <Cell ss:StyleID="s66"/>' +CRLF
		EndIf
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->F2_DOC)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->F2_SERIE)+'</Data></Cell>' +CRLF


		cDadosArq   += '   </Row>' +CRLF		

		(cArqTmp)->(DbSkip())
	EndDo

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseBook	 บAutor  ณMicrosiga 	      บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha o arquivo											  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CloseBook(cArq)

	Local aArea 		:= GetArea()
	Local cDadosArq		:= ""

	cDadosArq   += '  </Table>' +CRLF
	cDadosArq   += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '   <PageSetup>' +CRLF
	cDadosArq   += '    <Header x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <Footer x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' +CRLF
	cDadosArq   += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' +CRLF
	cDadosArq   += '   </PageSetup>' +CRLF
	cDadosArq   += '   <Print>' +CRLF
	cDadosArq   += '    <ValidPrinterInfo/>' +CRLF
	cDadosArq   += '    <PaperSizeIndex>9</PaperSizeIndex>' +CRLF
	cDadosArq   += '    <HorizontalResolution>600</HorizontalResolution>' +CRLF
	cDadosArq   += '    <VerticalResolution>600</VerticalResolution>' +CRLF
	cDadosArq   += '   </Print>' +CRLF
	cDadosArq   += '   <Selected/>' +CRLF
	cDadosArq   += '   <Panes>' +CRLF
	cDadosArq   += '    <Pane>' +CRLF
	cDadosArq   += '     <Number>3</Number>' +CRLF
	cDadosArq   += '     <ActiveRow>1</ActiveRow>' +CRLF
	cDadosArq   += '     <ActiveCol>3</ActiveCol>' +CRLF
	cDadosArq   += '    </Pane>' +CRLF
	cDadosArq   += '   </Panes>' +CRLF
	cDadosArq   += '   <ProtectObjects>False</ProtectObjects>' +CRLF
	cDadosArq   += '   <ProtectScenarios>False</ProtectScenarios>' +CRLF
	cDadosArq   += '  </WorksheetOptions>' +CRLF
	cDadosArq   += ' </Worksheet>' +CRLF
	cDadosArq   += ' <Worksheet ss:Name="Plan2">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '  </Table>' +CRLF
	cDadosArq   += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '   <PageSetup>' +CRLF
	cDadosArq   += '    <Header x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <Footer x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' +CRLF
	cDadosArq   += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' +CRLF
	cDadosArq   += '   </PageSetup>' +CRLF
	cDadosArq   += '   <ProtectObjects>False</ProtectObjects>' +CRLF
	cDadosArq   += '   <ProtectScenarios>False</ProtectScenarios>' +CRLF
	cDadosArq   += '  </WorksheetOptions>' +CRLF
	cDadosArq   += ' </Worksheet>' +CRLF
	cDadosArq   += ' <Worksheet ss:Name="Plan3">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="1" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '  </Table>' +CRLF
	cDadosArq   += '  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' +CRLF
	cDadosArq   += '   <PageSetup>' +CRLF
	cDadosArq   += '    <Header x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <Footer x:Margin="0.31496062000000002"/>' +CRLF
	cDadosArq   += '    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"' +CRLF
	cDadosArq   += '     x:Right="0.511811024" x:Top="0.78740157499999996"/>' +CRLF
	cDadosArq   += '   </PageSetup>' +CRLF
	cDadosArq   += '   <ProtectObjects>False</ProtectObjects>' +CRLF
	cDadosArq   += '   <ProtectScenarios>False</ProtectScenarios>' +CRLF
	cDadosArq   += '  </WorksheetOptions>' +CRLF
	cDadosArq   += ' </Worksheet>' +CRLF
	cDadosArq   += '</Workbook>' +CRLF


	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvTxtArq  บAutor  ณMicrosiga          บ Data ณ  01/08/19   บฑฑ
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
ฑฑบPrograma  ณGetArqTmp	 บAutor  ณMicrosiga  	      บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o arquivo temporario							 	  บฑฑ
ฑฑบ          ณ														 	  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetArqTmp(dDtDigDe, dDtDigAte, cDocDe, cDocAte, cSerieDe, cSerieAte, cCliDe, cClitAte, cLojaDe, cLojaAte)

	Local aArea 		:= GetArea()
	Local cQuery		:= ""
	Local cArqTmp		:= GetNextAlias()

	DEFAULT dDtDigDe	:= CTOD('')
	DEFAULT dDtDigAte	:= CTOD('')
	DEFAULT cDocDe		:= ""
	DEFAULT cDocAte		:= ""
	DEFAULT cSerieDe	:= ""
	DEFAULT cSerieAte	:= ""
	DEFAULT cCliDe		:= ""
	DEFAULT cClitAte	:= ""
	DEFAULT cLojaDe		:= ""
	DEFAULT cLojaAte	:= ""


	cQuery	:= " SELECT D1_DTDIGIT, D1_DOC, D1_SERIE, D1_COD, D1_LOCAL, B1_DESC, B1_TIPO, A1_COD, "+CRLF
	cQuery	+= " A1_LOJA, A1_NREDUZ, D1_QUANT, D1_TOTAL, D1_LOTECTL, D1_NUMLOTE, "+CRLF
	cQuery	+= " F2_DOC, F2_SERIE, F2_EMISSAO FROM "+RetSqlName("SF1")+" SF1 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SD1")+" SD1 "+CRLF
	cQuery	+= " ON SD1.D1_FILIAL = SF1.F1_FILIAL "+CRLF
	cQuery	+= " AND SD1.D1_DOC = SF1.F1_DOC "+CRLF
	cQuery	+= " AND SD1.D1_SERIE = SF1.F1_SERIE "+CRLF
	cQuery	+= " AND SD1.D1_FORNECE = SF1.F1_FORNECE "+CRLF
	cQuery	+= " AND SD1.D1_LOJA = SF1.F1_LOJA "+CRLF
	cQuery	+= " AND SD1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SD1.D1_FORNECE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SD1.D1_COD "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SF4")+" SF4 "+CRLF
	cQuery	+= " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"' "+CRLF
	cQuery	+= " AND SF4.F4_CODIGO = SD1.D1_TES "+CRLF
	cQuery	+= " AND SF4.F4_ESTOQUE = 'S' "+CRLF
	cQuery	+= " AND SF4.F4_DUPLIC = 'S' "+CRLF	
	cQuery	+= " AND SF4.D_E_L_E_T_ = ' ' "+CRLF


	cQuery	+= " LEFT JOIN "+RetSqlName("SF2")+" SF2 "+CRLF
	cQuery	+= " ON SF2.F2_FILIAL = SD1.D1_FILIAL "+CRLF
	cQuery	+= " AND SF2.F2_DOC = SD1.D1_NFORI "+CRLF
	cQuery	+= " AND SF2.F2_SERIE = SD1.D1_SERIORI "+CRLF
	cQuery	+= " AND SF2.F2_CLIENTE = SD1.D1_FORNECE "+CRLF
	cQuery	+= " AND SF2.F2_LOJA = SD1.D1_LOJA "+CRLF
	cQuery	+= " AND SF2.D_E_L_E_T_ = ' ' "+CRLF
	

	cQuery	+= " WHERE SF1.F1_FILIAL = '"+xFilial("SF1")+"' "+CRLF
	cQuery	+= " AND SF1.F1_DOC BETWEEN '"+cDocDe+"' AND '"+cDocAte+"' "+CRLF
	cQuery	+= " AND SF1.F1_SERIE BETWEEN '"+cSerieDe+"' AND '"+cSerieAte+"' "+CRLF 
	cQuery	+= " AND SF1.F1_FORNECE BETWEEN '"+cCliDe+"' AND '"+cClitAte+"' "+CRLF
	cQuery	+= " AND SF1.F1_LOJA BETWEEN '"+cLojaDe+"' AND '"+cLojaAte+"' "+CRLF
	cQuery	+= " AND SF1.F1_DTDIGIT BETWEEN '"+DTOS(dDtDigDe)+"' AND '"+DTOS(dDtDigAte)+"' "+CRLF
	cQuery	+= " AND SF1.F1_TIPO = 'D' "+CRLF
	cQuery	+= " AND SF1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " ORDER BY  D1_DTDIGIT, D1_DOC, D1_SERIE "+CRLF 

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	RestArea(aArea)
Return cArqTmp


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
	Local cLoadArq		:= "pzcv005"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)		

	AADD(aParamBox,{6,"Endere็o destino do arquivo","","","ExistDir(&(ReadVar()))","",080,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY})
	AADD(aParamBox,{1,"Dt.Digit. de"		,CTOD('')						,"@D"	,"","","",50,.F.})
	AADD(aParamBox,{1,"Dt.Digit. ate"		,CTOD('')						,"@D"	,"","","",50,.T.})
	AADD(aParamBox,{1,"Documento de"		,Space(TAMSX3("D1_DOC")[1])		,""	,"","","",50,.F.})
	AADD(aParamBox,{1,"Documento ate"		,Space(TAMSX3("D1_DOC")[1])		,""	,"","","",50,.T.})
	AADD(aParamBox,{1,"Serie de"			,Space(TAMSX3("D1_SERIE")[1])	,""	,"","","",50,.F.})
	AADD(aParamBox,{1,"Serie ate"			,Space(TAMSX3("D1_SERIE")[1])	,""	,"","","",50,.T.})
	AADD(aParamBox,{1,"Cliente de"			,Space(TAMSX3("A1_COD")[1])		,""	,"","SA1","",50,.F.})
	AADD(aParamBox,{1,"Cliente ate"			,Space(TAMSX3("A1_COD")[1])		,""	,"","SA1","",50,.T.})
	AADD(aParamBox,{1,"Loja de"				,Space(TAMSX3("A1_LOJA")[1])	,""	,"","","",50,.F.})
	AADD(aParamBox,{1,"Loja ate"			,Space(TAMSX3("A1_LOJA")[1])	,""	,"","","",50,.T.})



	//Monta a pergunta
	lRet := ParamBox(aParamBox, "Parโmetros", @aParam, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

	RestArea(aArea)
Return lRet  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetDtConv	  บAutor  ณMicrosiga         บ Data ณ  01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a data convertida		                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDtConv(dDtConv)

	Local aArea		:= GetArea()
	Local cRet		:= ""
	Local cDtAux	:= ""

	Default dDtConv := CTOD('')

	cDtAux := DTOS(dDtConv)

	cDtAux := SubStr(cDtAux,1,4)+"-"+SubStr(cDtAux,5,2)+"-"+SubStr(cDtAux,7,2) 

	cRet := cDtAux

	RestArea(aArea)
Return cRet


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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnvMail  บAutor  ณMicrosiga	          บ Data ณ  25/03/2017บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia e-mail                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 	                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

	Local aArea 		:= GetArea()
	Local cServer   	:= Alltrim(Separa(GetMV("MV_RELSERV",,""),":")[1])
	Local nPort			:= Val(Separa(GetMV("MV_RELSERV",,""),":")[2])
	Local cAccount		:= Alltrim(GetMV("MV_RELACNT",,""))
	Local cPwd			:= Alltrim(GetMV("MV_RELPSW",,""))
	Local lAutentic		:= GetNewPar("MV_RELAUTH",.F.)
	Local lSSL			:= GetNewPar("MV_RELSSL",.T.)
	Local lTLS			:= GetNewPar("MV_RELTLS",.T.)

	Local oServer       := Nil
	Local oMessage		:= Nil 
	Local aAnexos		:= Iif(!Empty(cAnexos), Separa(cAnexos,";"), "")
	Local nX			:= 1
	Local nErro			:= 0

	Default cMsgErr 	:= ""

	//Crio a conexใo com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()

	If lSSL
		oServer:SetUseSSL(lSSL)
	EndIf

	If lTLS
		oServer:SetUseTLS(lTLS)
	EndIf

	oServer:Init( "", cServer, cAccount,cPwd,0,nPort)

	//realizo a conexใo SMTP
	nErro := oServer:SmtpConnect() 
	If nErro != 0  
		cMsgErr := "Falha na conexใo SMTP. "
		Return .F.
	EndIf

	//seto um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		cMsgErr := "Falha ao setar o time out com o servidor. "
		Return .F.
	EndIf

	// Autentica็ใo
	If lAutentic
		If oServer:SMTPAuth ( cAccount,cPwd ) != 0
			cMsgErr := "Falha ao autenticar. "
			Return .F.
		EndIf
	EndIf

	//Apos a conexใo, crio o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpo o objeto
	oMessage:Clear()

	//Populo com os dados de envio
	oMessage:cFrom		:= 	cAccount
	oMessage:cTo		:=	cEmailTo
	oMessage:cSubject	:= 	cAssunto
	oMessage:cBody		:= 	cMensagem
	oMessage:MsgBodyType( "text/html" )

	For nX := 1 To Len(aAnexos)
		If File(aAnexos[nX])

			//Adiciono um attach
			If oMessage:AttachFile( aAnexos[nX] ) < 0
				cMsgErr := "Erro ao anexar o arquivo. "
				Return .F.
			EndIf
		EndIf     
	Next

	//Envio o e-mail
	If oMessage:Send( oServer ) != 0
		cMsgErr := "Erro ao enviar o e-mail. "
		Return .F.
	EndIf

	//Disconecto do servidor
	If oServer:SmtpDisconnect() != 0
		cMsgErr := "Erro ao disconectar do servidor SMTP. "
		Return .F.
	EndIf

	RestArea(aArea)
Return      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSetDtVldFab บAutor  ณMicrosiga  	      บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza as variavel enviadas no parametro para preencher a บฑฑ
ฑฑบ          ณdata de validade e fabrica็ใo							 	  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SetDtVldFab(dDtVld, dDtFab, cProduto, cLocal, cLote, cSubLote)

Local aArea		:= GetArea()
Local cQuery	:= ""
Local cArqTmp	:= GetNextAlias()

Default dDtVld		:= CTOD('') 
Default dDtFab		:= CTOD('')
Default cProduto	:= "" 
Default cLocal		:= "" 
Default cLote		:= "" 
Default cSubLote	:= ""

cQuery	:= " SELECT B8_DTVALID, B8_DFABRIC FROM "+RetSqlName("SB8")+" SB8 "+CRLF
cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
cQuery	+= " AND SB8.B8_PRODUTO = '"+cProduto+"' "+CRLF
cQuery	+= " AND SB8.B8_LOCAL = '"+cLocal+"' "+CRLF
cQuery	+= " AND SB8.B8_LOTECTL = '"+cLote+"' "+CRLF
cQuery	+= " AND SB8.B8_NUMLOTE = '"+cSubLote+"' "+CRLF
cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF

DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

If (cArqTmp)->(!Eof()) .And. !Empty((cArqTmp)->B8_DTVALID) .And. !Empty((cArqTmp)->B8_DFABRIC)
	dDtVld	:= STOD((cArqTmp)->B8_DTVALID) 
	dDtFab	:= STOD((cArqTmp)->B8_DFABRIC)
EndIf

If Select(cArqTmp) > 0
	(cArqTmp)->(DbCloseArea())
EndIf

RestArea(aArea)
Return
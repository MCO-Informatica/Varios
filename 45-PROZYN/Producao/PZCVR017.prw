#include 'protheus.ch'
#include 'TBICONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR017		บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de MRP (Utilizado em menu)						  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
User function PZCVR017()

	Local cArq 		:= "MRP DIA_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls" 
	Local aParam	:= {}

	If PergRel(@aParam)
		//Executa o relatorio 
		Processa( {|| RunRel(Alltrim(aParam[1])+cArq) },"Aguarde...","" )

		If File(Alltrim(aParam[1])+cArq)
			OpenExcel(Alltrim(aParam[1])+cArq)
		EndIf
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVRJ17		บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio MRP (Utilizado em job)							  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function PZCVRJ17(aDados)
	Local cDir			:= "\_Relatorios\"
	Local cArq 			:= cDir+"MRP_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"
	Local cAssunto		:= "Relat๓rio MRP"
	Local cMensagem		:= GetMsgMail()
	Local cEmailCc		:= ""
	Local cMsgErr		:= ""
	Local cMailDest		:= ""
	Default aDados	:=	 {"01","01"}

	
	// RpcClearEnv()
	// RpcSetType(3)
	// RpcSetEnv(aDados[1], aDados[2])

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER "admin" PASSWORD "adm@2023" TABLES "SB2","SB1","SD3","CZJ","CZK","CZI","SB1","SB2","SB3","SC4" MODULO "PCP"

	//E-mail dos destinatarios
	cMailDest	:= U_MyNewSX6("CV_MAILNMR", "","C","E-mail dos destinatแrios que receberใo o relat๓rio de MRP", "", "", .F. )

	//Executa o relatorio
	RunRel(cArq)

	//Verifica se o arquivo existe. Se existir serแ enviado por e-mail
	If File(cArq)

		//Envia o relatorio por e-mail
		// cMailDest := "denis.varella@newbridge.srv.br"
		EnvMail(cMailDest,cAssunto,cMensagem,cEmailCc, cArq, @cMsgErr)

		//Exclui o arquivo ap๓s o envio
		//FERASE(cArq)
	RESET ENVIRONMENT		
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRunRel		บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a rotina de Gera็ใo do relatorio					  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunRel(cArq)

	Local aArea	:= GetArea()
	Local nX		:= 0
	Local aPeriodos	:= {}
	Local nTipo		:= 0
	Local aNomeAba	:= {}
	Local aCodPer	:= {}
	Local cArqTmp	:= ""
	Local nCnt		:= 0
	Local cArqGer	:= ""
	Local cArqAglut := ""

	//Inicia a cria็ใo das tabelas de calculo do forecast 
	//Parametro nOpc:
	//0=Crias as tabelas temporarias do Forecast
	//1=Retorna o forecast aglutinado para o produto informado
	//2=Fecha as tabelas temporarias do forecast
	U_PZCVP017(0)
	
	//Descri็ใo dos periodos
	aPeriodos	:= R882PER(@nTipo)

	//Tipo de produtos a serem utilizados como nome da aba
	aNomeAba	:= GetTpProd()
	//aNomeAba	:= {"EM","ME","MP","PA","PI","ME","MP"}

	//Codigos dos periodos
	//aCodPer		:= GetCodPer()

	//Cria a tabela temporaria para ser utilizada na aba geral
	cArqGer	:= CriaTabTmp(aCodPer)

	//Cria a tabela temporaria para ser utilizada na aba geral
	cArqAglut:= CriaTabTmp(aCodPer)

	//Cabe็alho do Workbook
	CabBook(cArq)

	ProcRegua(Len(aNomeAba))

	For nX := 1 To Len(aNomeAba)//Preenchimento de cada aba (Tipo do Produto)

		IncProc("Processando...")
		nCnt := 0

		//Dados do relatorio. (Arquivo serแ fechado na rotina PrintSheet)
		cArqTmp := GetDadRel(aCodPer, Alltrim(aNomeAba[nX]))

		//Contagem da quantidade de linhas
		(cArqTmp)->( DbGoTop() )
		(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
		(cArqTmp)->( DbGoTop() )		


		//Cabe็alho do worksheet
		CabSheet(cArq,nCnt+10, Len(aPeriodos)+2, "MRP-"+Alltrim(aNomeAba[nX]), aPeriodos)

		//Preenchimento das linhas do relatorio
		PrintSheet(cArq, aCodPer, cArqTmp, cArqGer, Alltrim(aNomeAba[nX]), cArqAglut) 

		//Fecha o WorkSheet
		CloseSheet(cArq)
	Next


	//Preenche os dados da aba geral
	//Contagem da quantidade de linhas
	nCnt := 0
	(cArqGer)->( DbGoTop() )
	(cArqGer)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqGer)->( DbGoTop() )		

	//Cabe็alho do worksheet
	CabSheet(cArq,nCnt+10, Len(aPeriodos)+2, "MRP-Geral", aPeriodos)

	//Preenchimento das linhas do relatorio (Aba geral)
	PrtShGer(cArq, aCodPer, cArqGer)
	
	//Fecha o WorkSheet
	CloseSheet(cArq)	
	//Final do preenchimento da aba geral

	
	nCnt := 0
	(cArqAglut)->( DbGoTop() )
	(cArqAglut)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqAglut)->( DbGoTop() )	

	//Cabe็alho do worksheet
	CabSheet(cArq,nCnt+10, Len(aPeriodos)+2, "MRP-MP x ME", aPeriodos)

	//Preenchimento das linhas do relatorio (Aba geral)
	PrtShAglut(cArq, aCodPer, cArqAglut)
	
	//Fecha o WorkSheet
	CloseSheet(cArq)	
	//Final do preenchimento da aba geral



	//FECHA O WORKBOOK
	CloseBook(cArq)


	//Fecha as tabelas de calculo do forecast
	//Parametro nOpc:
	//0=Crias as tabelas temporarias do Forecast
	//1=Retorna o forecast aglutinado para o produto informado
	//2=Fecha as tabelas temporarias do forecast
	U_PZCVP017(2)

	RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabBook	  บAutor  ณMicrosiga         บ Data ณ  21/09/19   บฑฑ
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
	cDadosArq   += '  <Author>elton_csantana</Author>' +CRLF
	cDadosArq   += '  <LastAuthor>elton_csantana</LastAuthor>' +CRLF
	cDadosArq   += '  <Created>2019-09-22T00:55:14Z</Created>' +CRLF
	cDadosArq   += '  <LastSaved>2019-09-22T01:11:41Z</LastSaved>' +CRLF
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

	cDadosArq   += ' <Style ss:ID="s16" ss:Name="Vรญrgula"> '
	cDadosArq   += '  <NumberFormat ss:Format="_-* #,##0.00_-;\-* #,##0.00_-;_-* &quot;-&quot;??_-;_-@_-"/> '
	cDadosArq   += ' </Style>'	

	cDadosArq   += '  <Style ss:ID="Default" ss:Name="Normal">' +CRLF
	cDadosArq   += '   <Alignment ss:Vertical="Bottom"/>' +CRLF
	cDadosArq   += '   <Borders/>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '   <Interior/>' +CRLF
	cDadosArq   += '   <NumberFormat/>' +CRLF
	cDadosArq   += '   <Protection/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s62" ss:Name="Normal 3">' +CRLF
	cDadosArq   += '   <Alignment ss:Vertical="Bottom"/>' +CRLF
	cDadosArq   += '   <Borders/>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Tahoma" x:Family="Swiss" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '   <Interior/>' +CRLF
	cDadosArq   += '   <NumberFormat/>' +CRLF
	cDadosArq   += '   <Protection/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s141" ss:Parent="s62">' +CRLF
	cDadosArq   += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Tahoma" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s142" ss:Parent="s16">' +CRLF
	cDadosArq   += '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>' +CRLF
	cDadosArq   += '   <Borders>' +CRLF
	cDadosArq   += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>' +CRLF
	cDadosArq   += '   </Borders>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Tahoma" x:Family="Swiss" ss:Color="#FFFFFF" ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="dd/mm/yy;@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s66" ss:Parent="s16">'+CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>'+CRLF
	cDadosArq   += '  </Style>' +CRLF	

	cDadosArq   += ' <Style ss:ID="s69">' +CRLF
	//cDadosArq   += ' <Style ss:ID="s69" ss:Parent="s16">' +CRLF 
	cDadosArq   += '  <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' +CRLF
	cDadosArq   += '  <Interior ss:Color="#FF0000" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += ' </Style>' +CRLF

	cDadosArq   += ' </Styles>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCabSheet  บAutor  ณMicrosiga 	        บ Data ณ  21/09/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCabe็alho WorkSheet                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                	                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function CabSheet(cArq, nQtdRow, nQtdCol, cNameSheet, aPeriodos)

	Local aArea 		:= GetArea()
	Local cDadosArq   	:= ""
	Local nX			:= 0     

	Default cArq 		:= ""        
	Default nQtdRow		:= 0 
	Default cNameSheet	:= ""
	Default aPeriodos	:= {}

	cDadosArq   := ' <Worksheet ss:Name="'+cNameSheet+'">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="'+Alltrim(Str(19+nQtdCol))+'" ss:ExpandedRowCount="'+Alltrim(Str(nQtdRow+5))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="59.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="216.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="35"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="80"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="80"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="120"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="80"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="100"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="108"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="170"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="120"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="120"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="120"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="120"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="80"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="130"/>' +CRLF 
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="140"/>' +CRLF 
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="120"/>' +CRLF 
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="100"/>' +CRLF 
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="80"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="80"/>' +CRLF
	// cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="120"/>' +CRLF

	For nX := 1 To Len(aPeriodos)
		cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="80.25"/>' +CRLF
	nEXT

	cDadosArq   += '   <Row ss:AutoFitHeight="0" ss:Height="18">' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">CODIGO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">DESCRICAO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">TIPO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">FORECAST</Data></Cell>' +CRLF
    cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">FORECASTDIA</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">CONSUMO 9 MESES</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">TOTAL</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">MEDIA MENSAL</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ESTOQUE SEGURANCA</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ESTOQUE SEGURANCA COBERTO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ESTOQUE DISPONIVEL</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ESTOQUE EM TRANSITO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">MESES DE ESTOQUE</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">PRAZO DE REPOSICAO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">SMI</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">PONTO DE PEDIDO (QTD)</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">PONTO DE PEDIDO (STATUS)</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">SUGESTAO DE PEDIDO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ESTOQUE CRITICO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ARMAZEM 97</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">IMPORTADO</Data></Cell>' +CRLF
	// cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">NOVO EST. SEGURANCA</Data></Cell>' +CRLF

	For nX := 1 To Len(aPeriodos)
		cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">'+DTOC(aPeriodos[nX])+'</Data></Cell>' +CRLF
	Next

	cDadosArq   += '   </Row>' +CRLF                            

	GrvTxtArq( cArq, cDadosArq )

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrintSheet  บAutor  ณMicrosiga 	     บ Data ณ  21/09/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche as linhas do WorkSheet (Dados do relatorio)        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function PrintSheet(cArq, aCodPer, cArqTmp, cArqGer, cTp, cArqAglut)

	Local aArea  		:= GetArea()
	Local cDadosArq   	:= ""
	Local nX			:= 0
	Local nPerVal		:= 0
	Local nQuarent		:= 0
	Local nForeCast		:= 0
    Local nForeNew      := 0
    Local cEstCrit      := 0 
    Local nPerEnt       := 0 
    Local lCalcCrit     := .T.
	Local nPonPed		:= 0
	Local cESegCo		:= ""
	Local cPonPet		:= ""
	Local nSugPed		:= 0
	Local cStyle69 		:= ""
	Local cStyCr69		:= ""
	Local aItens		:= {}
	Local aRows 		:= {}
	Local nA 			:= 0
	Local aForecast		:= {0,0}
	Local nMesesCon 	:= 9
	Local nConsumo		:= 0
	Local aQtddias		:= {}

	Default dMrpIni		:= Date()
    Default dMrpFim		:= Date()
	Default cArq 		:= ""
	Default aCodPer		:= {} 
	Default cArqTmp		:= ""
	Default cArqGer		:= ""
	Default cArqAglut   := ""
	Default cTp			:= ""

	Pergunte("MTA712",.T.)

	dMrpIni := Date()
	dMrpFim := 	DaySum(dMrpIni,91) 
	aQtddias := { GetMV("CV_PERINOV") * 7, 4 * 7}

	While (cArqTmp)->(!Eof())

		
		nPerEnt:= POSICIONE("SB1",1,xFilial("SB1")+(cArqTmp)->B1_COD,"B1_PE")

		nEstran			:= GetSldTran((cArqTmp)->B1_COD)
		nQuarent		:= GetSldQuar((cArqTmp)->B1_COD)
		aForecast 		:= GetForeCast((cArqTmp)->B1_COD)
		nConsumo 		:= GetConsumo((cArqTmp)->B1_COD, nMesesCon)

		If 'S' $ (cArqTmp)->B1_IMPORT
			nForeCast		:= aForecast[1]
		Else
			nForeCast		:= aForecast[2]
		EndIf

		If nForeCast <> 0
       		If cTp == "PA" .or. cTp == "PI"
           		nForeNew := 0
		  		cEstCrit := "2"
		   		nPonPed  := 0
	
			Else
    	 		nForeNew := nForeCast / Iif('S' $ (cArqTmp)->B1_IMPORT, aQtddias[1], aQtddias[2])
				nPonPed := (cArqTmp)->B1_ESTSEG + (nForeNew*nPerEnt)
        		If lCalcCrit := nForeNew * nPerEnt >= (cArqTmp)->SALDO_SB2 + nEstran
					lCalcCrit := .T.
					cStyCr69 := "ss:StyleID='s69'"
				Else
					lCalcCrit := .F.
					//lCalcCrit := ((cArqTmp)->SALDO_SB2 + nQuarent-(nForeNew * nPerEnt)) <= 0
				EndIf
				
		    	If lCalcCrit == .T. 
					cEstCrit 	:= "1"
					cStyle69 := "ss:StyleID='s69'"
            	Else
            		cEstCrit := "2"
            	EndIf   
        	EndIf

			If (cArqTmp)->SALDO_SB2 + nEstran >= (cArqTmp)->B1_ESTSEG
				cESegCo := '1'
			Else
				cESegCo := '2'
			EndIf
		
			If ((cArqTmp)->SALDO_SB2 + nEstran) <= nPonPed
				cPonPet 	:= '1'
				cStyle69 := "ss:StyleID='s69'"
			Else
				cPonPet := '2'
			EndIf

			nSugPed := nForeCast + (cArqTmp)->B1_ESTSEG - (cArqTmp)->SALDO_SB2 - nEstran

			nSugPed := RetSugPed((cArqTmp)->B1_COD, nSugPed)

			cEndLine := ""
			nPerVal := 0
			For nX := 1 To Len(aCodPer)
				nPerVal += (cArqTmp)->&("PER_"+Alltrim(aCodPer[nX]))

				//Verifica se o valor dos periodos anteriores e maior que o saldo disponivel. Se for, serแ apresentado cor vermelha no relatorio
				If nPerVal > (cArqTmp)->SALDO_SB2
					cEndLine   += '    <Line ss:StyleID="s69"><Data ss:Type="Number">'+ Alltrim(Str((cArqTmp)->&("PER_"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
				Else
					cEndLine   += '    <Line><Data ss:Type="Number">'+ Alltrim(Str((cArqTmp)->&("PER_"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
				EndIf
			Next

			aAdd(aItens, {(cArqTmp)->B1_COD,;
			(cArqTmp)->B1_DESC,;
			cTp,;
			Alltrim(Str(nForeCast)),;
			Alltrim(Str(nForeNew)),;
			Alltrim(Str(nConsumo)),;
			Alltrim(Str((cArqTmp)->B1_ESTSEG)),;
			cESegCo,;
			Alltrim(Str((cArqTmp)->SALDO_SB2)),;
			Alltrim(Str(nEstran)),;
			Alltrim(Str(nPerEnt)),;
			Alltrim(Str(nPonPed)),;
			cPonPet,;
			Alltrim(Str(nSugPed)),;
			cEstCrit,;
			Alltrim(Str((cArqTmp)->SALDO_ARM_97)),;
			(cArqTmp)->B1_IMPORT,;
			cEndLine })

			//Grava os dados na tabela temporaria que serแ utilizada na aba geral
			If !Empty(cArqGer)

				RecLock(cArqGer, .T.)

				(cArqGer)->TMP_CODIGO			:= (cArqTmp)->B1_COD
				(cArqGer)->TMP_DESC				:= (cArqTmp)->B1_DESC
				(cArqGer)->TMP_TIPO				:= cTp
				(cArqGer)->TMP_FORECA  	 		:= nForeCast
				(cArqGer)->TMP_FORENE  			:= nForeNew
				(cArqGer)->TMP_CONSUM  			:= nConsumo
				(cArqGer)->TMP_ESTSEG			:= (cArqTmp)->B1_ESTSEG
				(cArqGer)->TMP_ESEGCO   		:= cESegCo
				(cArqGer)->TMP_QTDDIS			:= (cArqTmp)->SALDO_SB2
				(cArqGer)->TMP_QTD97			:= (cArqTmp)->SALDO_ARM_97
				(cArqGer)->TMP_ESTTRA			:= nEstran
				(cArqGer)->TMP_PERENT   		:= nPerEnt
				(cArqGer)->TMP_PONPED   		:= nPonPed
				(cArqGer)->TMP_PONPET			:= cPonPet
				(cArqGer)->TMP_SUGPED		    := nSugPed
				(cArqGer)->TMP_ESTCRI   		:= cEstCrit
				(cArqGer)->TMP_IMPORT   		:= (cArqTmp)->B1_IMPORT
				(cArqGer)->TMP_MPXME			:= trim((cArqTmp)->B5_MPXME)

				For nX := 1 To Len(aCodPer)		
					(cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX])) := (cArqTmp)->&("PER_"+Alltrim(aCodPer[nX]))
				Next 

				(cArqGer)->(MsUnLock())

			EndIf

			If !Empty(cArqAglut)


				If !empty(trim((cArqTmp)->B5_MPXME))

					RecLock(cArqAglut, .T.)

					(cArqAglut)->TMP_CODIGO			:= (cArqTmp)->B1_COD
					(cArqAglut)->TMP_DESC				:= (cArqTmp)->B1_DESC
					(cArqAglut)->TMP_TIPO				:= cTp
					(cArqAglut)->TMP_FORECA  	 		:= nForeCast
					(cArqAglut)->TMP_FORENE  			:= nForeNew
					(cArqAglut)->TMP_CONSUM  			:= nConsumo
					(cArqAglut)->TMP_ESTSEG			:= (cArqTmp)->B1_ESTSEG
					(cArqAglut)->TMP_ESEGCO   		:= cESegCo
					(cArqAglut)->TMP_QTDDIS			:= (cArqTmp)->SALDO_SB2
					(cArqAglut)->TMP_QTD97			:= (cArqTmp)->SALDO_ARM_97
					(cArqAglut)->TMP_ESTTRA			:= nEstran
					(cArqAglut)->TMP_PERENT   		:= nPerEnt
					(cArqAglut)->TMP_PONPED   		:= nPonPed
					(cArqAglut)->TMP_PONPET			:= cPonPet
					(cArqAglut)->TMP_SUGPED		    := nSugPed
					(cArqAglut)->TMP_ESTCRI   		:= cEstCrit
					(cArqAglut)->TMP_IMPORT   		:= (cArqTmp)->B1_IMPORT
					(cArqAglut)->TMP_MPXME			:= trim((cArqTmp)->B5_MPXME)

					For nX := 1 To Len(aCodPer)		
						(cArqAglut)->&("TMP_P"+Alltrim(aCodPer[nX])) := (cArqTmp)->&("PER_"+Alltrim(aCodPer[nX]))
					Next 

					(cArqAglut)->(MsUnLock())

				// ElseIf cTp == 'ME' .and. !empty(trim((cArqTmp)->B5_MPXME))
				// 	(cArqAglut)->(DbGoTop())
				// 	While  (cArqAglut)->(!EOF())
				// 		If  trim((cArqAglut)->TMP_CODIGO) == trim((cArqTmp)->B5_MPXME) .and. (cArqAglut)->TMP_TIPO == 'MP'
				// 			RecLock(cArqAglut, .F.)

				// 			(cArqAglut)->TMP_FORECA += nForeCast
				// 			(cArqAglut)->TMP_FORENE += nForeNew
				// 			(cArqAglut)->TMP_CONSUM += nConsumo
				// 			(cArqAglut)->TMP_QTDDIS += (cArqTmp)->SALDO_SB2
				// 			(cArqAglut)->TMP_QTD97  += (cArqTmp)->SALDO_ARM_97
				// 			(cArqAglut)->TMP_ESTSEG += (cArqTmp)->B1_ESTSEG
				// 			(cArqAglut)->TMP_ESTTRA += nEstran
				// 			(cArqAglut)->TMP_PERENT += nPerEnt
				// 			(cArqAglut)->TMP_PONPED += nPonPed
				// 			(cArqAglut)->TMP_SUGPED += nSugPed

				// 			(cArqAglut)->(MsUnLock())
				// 		EndIf
				// 		(cArqAglut)->(DbSkip())
				// 	Enddo
				EndIf
			EndIf

			(cArqTmp)->(DbSkip())
		Else
			(cArqTmp)->(DbSkip())	
		EndIf

		cEstCrit 	:= "NAO"
		cPonPet 	:= "NAO"
		cStyle69	:= ""
		cStyCr69	:= ""
	EndDo

	aRows := ASort(aItens, , , { | x,y | x[15]+x[13] < y[15]+y[13] } )
	For nA := 1 to len(aRows)

			cDadosArq   := '   <Row>' +CRLF
			cDadosArq   += '    <Cell><Data ss:Type="String">'+trim(aRows[nA][1])+'</Data></Cell>' +CRLF 
			cDadosArq   += '    <Cell><Data ss:Type="String">'+trim(aRows[nA][2])+'</Data></Cell>' +CRLF
			cDadosArq   += '    <Cell><Data ss:Type="String">'+aRows[nA][3]+'</Data></Cell>' +CRLF			
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][4]+'</Data></Cell>' +CRLF //Forecast
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][5]+'</Data></Cell>' +CRLF 
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][6]+'</Data></Cell>' +CRLF 
			nTotal := val(aRows[nA][6])+val(aRows[nA][4])
			nMedia := nTotal / Iif('S' $ trim(aRows[nA][17]),12,10)
			nMesesEst := (val(aRows[nA][9]) - val(aRows[nA][7])) / nMedia
			if nMesesEst < 0
				nMesesEst = 0
			endif
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+cValtoChar(nTotal)+'</Data></Cell>' +CRLF
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+cValtoChar(nMedia)+'</Data></Cell>' +CRLF
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][7]+'</Data></Cell>' +CRLF
			
			cYesNo := "NAO"
			If trim(aRows[nA][8]) == '1'
				cYesNo := "SIM"
			EndIf
			cDadosArq   += '    <Cell><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][9]+'</Data></Cell>' +CRLF //Estoque Disponํvel
			cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][10]+'</Data></Cell>' +CRLF //Em transito
			cDadosArq   += '    <Cell><Data ss:Type="String">'+cValtoChar(round(nMesesEst,1))+'</Data></Cell>' +CRLF //Meses de Estoque
			cDadosArq   += '    <Cell><Data ss:Type="String">'+cValtoChar(round(val(aRows[nA][11]),0))+'</Data></Cell>' +CRLF //Prazo Reposi็ใo
			// cDadosArq   += '    <Cell><Data ss:Type="String">'+Iif(nMesesEst > (val(aRows[nA][11]) / 28 * 1.9), 'SIM','NAO') +'</Data></Cell>' +CRLF
			// nEstDisp 	:= (val(aRows[nA][9]) - val(aRows[nA][7]))
			// nSOH 	:= nEstDisp / nMedia //Stock on Hand
			
			cDadosArq   += '    <Cell><Data ss:Type="String">'+Iif(nMesesEst > val(aRows[nA][11]) / 30 * 50 / 100, 'SIM','NAO') +'</Data></Cell>' +CRLF
			cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][12]+'</Data></Cell>' +CRLF

			cStyle69 := ""
			cYesNo := "NAO"
			If trim(aRows[nA][13]) == '1'
				cStyle69 := "ss:StyleID='s69'"
				cYesNo := "SIM"
			EndIf
			cDadosArq   += '    <Cell '+cStyle69+'><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF

			cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][14]+'</Data></Cell>' +CRLF

			cStyle69 := ""
			cYesNo := "NAO"
			If trim(aRows[nA][15]) == '1'
				cStyle69 := "ss:StyleID='s69'"
				cYesNo := "SIM"
			EndIf
			cDadosArq   += '    <Cell '+cStyle69+'><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF	
			cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][16]+'</Data></Cell>' +CRLF	
			
			
			cYesNo := "NAO"
			If 'S' $ trim(aRows[nA][17])
				cYesNo := "SIM"
			EndIf

			// nNewEstSeg 	:= nPerEnt * 1.5 * nMedia / 28
			// nLE := POSICIONE("SB1",1,xFilial("SB1")+TRIM(aRows[nA][1]),"B1_LE")

			// If nNewEstSeg < nLE
			// 	nNewEstSeg := nLE
			// EndIf

			// If cYesNo == 'NAO'
			// 	nQE 		:= POSICIONE("SB1",1,xFilial("SB1")+TRIM(aRows[nA][1]),"B1_QE")
			// 	If nNewEstSeg % nQE != 0
			// 		nNewEstSeg := round(nNewEstSeg,0) + nQE - (round(nNewEstSeg,0) % nQE)
			// 	EndIf
			// EndIf

			cDadosArq   += '	<Cell><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF	
			// cDadosArq   += '	<Cell><Data ss:Type="Number">'+cValtoChar(nNewEstSeg)+'</Data></Cell>' +CRLF	
			cDadosArq 	+= 		aRows[nA][18]
			cDadosArq   += '   </Row>' +CRLF
			
			GrvTxtArq( cArq, cDadosArq )
	Next nA

	//Fecha o arquivo temporario
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


Static Function RetSugPed(cProduto, nSugPed)
	Local aArea := GetArea()
	Local nLE := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_LE")
	Local nLM := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_LM")
	Local nQE := POSICIONE("SB1",1,xFilial("SB1")+cProduto,"B1_QE")

	If nLE > 0 .and. nSugPed % nLE != 0
		return Ceiling(nSugPed / nLE) * nLE
	EndIf

	If nLE == 0 .and. nLM > 0 .and. nSugPed % nLM != 0
		return Ceiling(nSugPed / nLM) * nLM
	EndIf

	If nLE == 0 .and. nLM == 0 .and. nQE > 0
		return nSugPed + nQE - (nSugPed % nQE)
	EndIf

	RestArea(aArea)
Return nSugPed


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrtShGer	  บAutor  ณMicrosiga 	     บ Data ณ  24/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche as linhas do WorkSheet (Geral)				      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function PrtShGer(cArq, aCodPer, cArqGer)

	Local aArea  		:= GetArea()
	Local cDadosArq   	:= ""
	Local nX			:= 0
	Local nPerVal		:= 0
	Local aItens 		:= {}
	Local aRows			:= {}
	Local nA			:= 0

	Default cArq 		:= ""
	Default aCodPer		:= {} 
	Default cArqGer		:= ""


	While (cArqGer)->(!Eof())
	
		nPerVal := 0
		cEndLine := ""
		For nX := 1 To Len(aCodPer)
			nPerVal += (cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX]))

			//Verifica se o valor dos periodos anteriores e maior que o saldo disponivel. Se for, serแ apresentado cor vermelha no relatorio
			If nPerVal > (cArqGer)->TMP_QTDDIS
				cEndLine   += '    <Cell ss:StyleID="s69"><Data ss:Type="Number">'+ Alltrim(Str((cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			Else
				cEndLine   += '    <Cell><Data ss:Type="Number">'+ Alltrim(Str((cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			EndIf
		Next

		
		nSugPed := RetSugPed((cArqGer)->TMP_CODIGO, (cArqGer)->TMP_SUGPED)

		aAdd(aItens, {(cArqGer)->TMP_CODIGO,;
		(cArqGer)->TMP_DESC,;
		(cArqGer)->TMP_TIPO,;
		Alltrim(Str((cArqGer)->TMP_FORECA)),;
		Alltrim(Str((cArqGer)->TMP_FORENE)),;
		Alltrim(Str((cArqGer)->TMP_CONSUM)),;
		Alltrim(Str((cArqGer)->TMP_ESTSEG)),;
		(cArqGer)->TMP_ESEGCO,;
		Alltrim(Str((cArqGer)->TMP_QTDDIS)),;
		Alltrim(Str((cArqGer)->TMP_ESTTRA)),;
		Alltrim(Str((cArqGer)->TMP_PERENT)),;
		Alltrim(Str((cArqGer)->TMP_PONPED)),;
		(cArqGer)->TMP_PONPET,;
		Alltrim(Str(nSugPed)),;
		(cArqGer)->TMP_ESTCRI,;
		Alltrim(Str((cArqGer)->TMP_QTD97)),;
		Alltrim((cArqGer)->TMP_IMPORT),;
		cEndLine })

		(cArqGer)->(DbSkip())
	EndDo

	
	aRows := ASort(aItens, , , { | x,y | x[15]+x[13] < y[15]+y[13] } )
	For nA := 1 to len(aRows)
		cDadosArq   := '   <Row>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+trim(aRows[nA][1])+'</Data></Cell>' +CRLF 
		cDadosArq   += '    <Cell><Data ss:Type="String">'+trim(aRows[nA][2])+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+aRows[nA][3]+'</Data></Cell>' +CRLF			
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][4]+'</Data></Cell>' +CRLF //Forecast
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][5]+'</Data></Cell>' +CRLF 
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][6]+'</Data></Cell>' +CRLF
		nTotal := val(aRows[nA][6])+val(aRows[nA][4])
		nMedia := nTotal / Iif('S' $ trim(aRows[nA][17]),12,10)
		nMesesEst := (val(aRows[nA][9]) - val(aRows[nA][7])) / nMedia
		if nMesesEst < 0
			nMesesEst = 0
		endif
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+cValtoChar(nTotal)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+cValtoChar(nMedia)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][7]+'</Data></Cell>' +CRLF
		
		If val(aRows[nA][9]) + val(aRows[nA][10]) >= val(aRows[nA][7])
			cESegCo := '1'
		Else
			cESegCo := '2'
		EndIf

		cYesNo := "NAO"
		If trim(cESegCo) == '1'
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][9]+'</Data></Cell>' +CRLF
		cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][10]+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cValtoChar(round(nMesesEst,1))+'</Data></Cell>' +CRLF //Meses de Estoque
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cValtoChar(round(val(aRows[nA][11]),0))+'</Data></Cell>' +CRLF //Prazo Reposi็ใo
		// cDadosArq   += '    <Cell><Data ss:Type="String">'+Iif(nMesesEst > (val(aRows[nA][11]) / 28 * 1.9), 'SIM','NAO') +'</Data></Cell>' +CRLF
		
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Iif(nMesesEst > val(aRows[nA][11]) / 30 * 50 / 100, 'SIM','NAO') +'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][12]+'</Data></Cell>' +CRLF

		cStyle69 := ""
		cYesNo := "NAO"
		If trim(aRows[nA][13]) == '1'
			cStyle69 := "ss:StyleID='s69'"
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '    <Cell '+cStyle69+'><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF

		cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][14]+'</Data></Cell>' +CRLF

		cStyle69 := ""
		cYesNo := "NAO"
		If val(aRows[nA][5]) * val(aRows[nA][11]) >= val(aRows[nA][9]) + val(aRows[nA][10])
			cStyle69 := "ss:StyleID='s69'"
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '    <Cell '+cStyle69+'><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF
		cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][16]+'</Data></Cell>' +CRLF		
		
		cYesNo := "NAO"
		If 'S' $ trim(aRows[nA][17])
			cYesNo := "SIM"
		EndIf

		// nNewEstSeg 	:= val(aRows[nA][11]) * 1.5 * nMedia / 28

		// nLE := POSICIONE("SB1",1,xFilial("SB1")+TRIM(aRows[nA][1]),"B1_LE")

		// If nNewEstSeg < nLE
		// 	nNewEstSeg := nLE
		// EndIf
		
		// If cYesNo == 'NAO'
		// 	nQE 		:= POSICIONE("SB1",1,xFilial("SB1")+aRows[nA][1],"B1_QE")
		// 	If nNewEstSeg % nQE != 0
		// 		nNewEstSeg := round(nNewEstSeg,0) + nQE - (round(nNewEstSeg,0) % nQE)
		// 	EndIf
		// EndIf

		cDadosArq   += '	<Cell><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF	
		// cDadosArq   += '	<Cell><Data ss:Type="Number">'+cValtoChar(nNewEstSeg)+'</Data></Cell>' +CRLF	
		
		cDadosArq 	+= 		aRows[nA][18]
		cDadosArq   += '   </Row>' +CRLF
		
		GrvTxtArq( cArq, cDadosArq )

	Next nA

	//Fecha o arquivo temporario
	If Select(cArqGer) > 0
		(cArqGer)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPrtShAglut  บAutor  ณMicrosiga 	     บ Data ณ  24/10/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche as linhas do WorkSheet (Aglutinados)			      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function PrtShAglut(cArq, aCodPer, cArqAglut)

	Local aArea  		:= GetArea()
	Local cDadosArq   	:= ""
	Local nX			:= 0
	Local nPerVal		:= 0
	Local aItens 		:= {}
	Local aRows			:= {}
	Local nA			:= 0

	Default cArq 		:= ""
	Default aCodPer		:= {} 
	Default cArqAglut		:= ""


	While (cArqAglut)->(!Eof())
	
		nPerVal := 0
		cEndLine := ""
		For nX := 1 To Len(aCodPer)
			nPerVal += (cArqAglut)->&("TMP_P"+Alltrim(aCodPer[nX]))

			//Verifica se o valor dos periodos anteriores e maior que o saldo disponivel. Se for, serแ apresentado cor vermelha no relatorio
			If nPerVal > (cArqAglut)->TMP_QTDDIS
				cEndLine   += '    <Cell ss:StyleID="s69"><Data ss:Type="Number">'+ Alltrim(Str((cArqAglut)->&("TMP_P"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			Else
				cEndLine   += '    <Cell><Data ss:Type="Number">'+ Alltrim(Str((cArqAglut)->&("TMP_P"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			EndIf
		Next

		
		nSugPed := RetSugPed((cArqAglut)->TMP_CODIGO, (cArqAglut)->TMP_SUGPED)

		aAdd(aItens, {(cArqAglut)->TMP_CODIGO,;
		(cArqAglut)->TMP_DESC,;
		(cArqAglut)->TMP_TIPO,;
		Alltrim(Str((cArqAglut)->TMP_FORECA)),;
		Alltrim(Str((cArqAglut)->TMP_FORENE)),;
		Alltrim(Str((cArqAglut)->TMP_CONSUM)),;
		Alltrim(Str((cArqAglut)->TMP_ESTSEG)),;
		(cArqAglut)->TMP_ESEGCO,;
		Alltrim(Str((cArqAglut)->TMP_QTDDIS)),;
		Alltrim(Str((cArqAglut)->TMP_ESTTRA)),;
		Alltrim(Str((cArqAglut)->TMP_PERENT)),;
		Alltrim(Str((cArqAglut)->TMP_PONPED)),;
		(cArqAglut)->TMP_PONPET,;
		Alltrim(Str(nSugPed)),;
		(cArqAglut)->TMP_ESTCRI,;
		Alltrim(Str((cArqAglut)->TMP_QTD97)),;
		Alltrim((cArqAglut)->TMP_IMPORT),;
		Alltrim((cArqAglut)->TMP_MPXME),;
		cEndLine })

		(cArqAglut)->(DbSkip())
	EndDo

	
	aRows := ASort(aItens, , , { | x,y | x[18]+x[3] > y[18]+y[3] } )
	For nA := 1 to len(aRows)
		cDadosArq   := '   <Row>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+trim(aRows[nA][1])+'</Data></Cell>' +CRLF 
		cDadosArq   += '    <Cell><Data ss:Type="String">'+trim(aRows[nA][2])+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+aRows[nA][3]+'</Data></Cell>' +CRLF			
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][4]+'</Data></Cell>' +CRLF //Forecast
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][5]+'</Data></Cell>' +CRLF 
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][6]+'</Data></Cell>' +CRLF
		nTotal := val(aRows[nA][6])+val(aRows[nA][4])
		nMedia := nTotal / Iif(trim(aRows[nA][17]) == 'S',12,10)
		nMesesEst := val(aRows[nA][9]) / nMedia
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+cValtoChar(nTotal)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+cValtoChar(nMedia)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][7]+'</Data></Cell>' +CRLF
		
		cESegCo := '2'
		If val(aRows[nA][9]) + val(aRows[nA][10]) >= val(aRows[nA][7])
			cESegCo := '1'
		EndIf

		cYesNo := "NAO"
		If trim(cESegCo) == '1'
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][9]+'</Data></Cell>' +CRLF
		cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][10]+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cValtoChar(round(nMesesEst,1))+'</Data></Cell>' +CRLF //Meses de Estoque
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cValtoChar(round(val(aRows[nA][11]),0))+'</Data></Cell>' +CRLF //Prazo Reposi็ใo
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Iif(nMesesEst > (val(aRows[nA][11]) / 28 * 1.9), 'SIM','NAO') +'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+aRows[nA][12]+'</Data></Cell>' +CRLF

		cStyle69 := ""
		cYesNo := "NAO"
		If trim(aRows[nA][13]) == '1'
			cStyle69 := "ss:StyleID='s69'"
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '    <Cell '+cStyle69+'><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF

		cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][14]+'</Data></Cell>' +CRLF

		cStyle69 := ""
		cYesNo := "NAO"
		If val(aRows[nA][5]) * val(aRows[nA][11]) >= val(aRows[nA][9]) + val(aRows[nA][10])
			cStyle69 := "ss:StyleID='s69'"
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '    <Cell '+cStyle69+'><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF
		cDadosArq   += '	<Cell><Data ss:Type="Number">'+aRows[nA][16]+'</Data></Cell>' +CRLF		
		
		cYesNo := "NAO"
		If 'S' $ trim(aRows[nA][17])
			cYesNo := "SIM"
		EndIf
		cDadosArq   += '	<Cell><Data ss:Type="String">'+cYesNo+'</Data></Cell>' +CRLF	
		// cDadosArq   += '	<Cell><Data ss:Type="Number">'+cValtoChar(val(aRows[nA][11]) * 1.5 * nMedia / 28)+'</Data></Cell>' +CRLF		
		
		cDadosArq 	+= 		aRows[nA][19]
		cDadosArq   += '   </Row>' +CRLF
		
		GrvTxtArq( cArq, cDadosArq )

	Next nA

	//Fecha o arquivo temporario
	If Select(cArqAglut) > 0
		(cArqAglut)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCloseSheet  บAutor  ณMicrosiga  	     บ Data ณ  21/09/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFecha a a tag Worksheet                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿  
*/
Static Function CloseSheet(cArq)

	Local aArea 		:= GetArea()
	Local cDadosArq   := ""     
	Default cArq 		:= ""     

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
	cDadosArq   += '   <LeftColumnVisible>1</LeftColumnVisible>' +CRLF
	cDadosArq   += '   <Panes>' +CRLF
	cDadosArq   += '    <Pane>' +CRLF
	cDadosArq   += '     <Number>3</Number>' +CRLF
	cDadosArq   += '     <ActiveRow>8</ActiveRow>' +CRLF
	cDadosArq   += '     <ActiveCol>3</ActiveCol>' +CRLF
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
	Local cDadosArq   := ""     
	Default cArq 		:= ""

	cDadosArq := '</Workbook>'
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

Static Function R882PER(nTipo)
	Local i
	Local dInicio
	Local aRet := {}
	Local nPosAno
	Local nTamAno
	Local cForAno
	Local lConsSabDom := Nil

	Private cPerg       := "MATR882"	

	Pergunte("MTA712",.F.)
	lConsSabDom := .T.//mv_par12 == 1
	Pergunte(cPerg, .F.)

	If __SetCentury()
		nPosAno := 1
		nTamAno := 4
		cForAno := "ddmmyyyy"
	Else
		nPosAno := 3
		nTamAno := 2
		cForAno := "ddmmyy"
	EndIf

	//Adiciona registro em array totalizador utilizado no TREE  
	DbSelectArea("CZI")
	CZI->(dbSetOrder(1))
	CZI->(DbSeek(xFilial("CZI")))
	While CZI->(!Eof()) .And. xFilial("CZI") == CZI->CZI_FILIAL
		// Recupera parametrizacao gravada no ultimo processamento
		// A T E N C A O
		// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
		// os periodos de maneira desordenada, por causa do indice do arquivo SH5
		// O array aRet ้ corrigido logo abaixo
		If CZI_ALIAS == "PAR"
			nTipo       := CZI_NRRGAL
			dInicio     := Date()
			nPeriodos   := GetMV("CV_PERINOV")
			If nTipo == 7
				AADD(aRet,DTOS(CTOD(Alltrim(CZI_OPC))))
			EndIf
			//NUMERO DO MRPณ
			c711NumMRP := CZI_NRMRP
		EndIf
		CZI->(dbSkip())
	End

	//Somente para nTipo==7 (Periodos Diversos) re-ordena aRet
	//pois como o H5_OPC esta gravado a data como caracter ex:(09/10/05)
	//o arquivo esta indexado incorretamente (diferente de 20051009)
	If !Empty(aRet)
		ASort(aRet)
		For i:=1 To Len(aRet)
			aRet[i] := STOD(aRet[i])
		Next i
	EndIf

/*	If nTipo == 2
		while Dow(dInicio) !=2
			dInicio := Date()
		EndDo
	EndIf*/


	If (nTipo == 2)                         // Semanal
		While Dow(dInicio)!=2
			dInicio--
		EndDo
	ElseIf (nTipo == 3) .or. (nTipo=4)      // Quinzenal ou Mensal
		dInicio:= CtoD("01/"+Substr(DtoS(dInicio),5,2)+Substr(DtoC(dInicio),6),cForAno)
	ElseIf (nTipo == 5)                     // Trimestral
		If Month(dInicio) < 4
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >= 4) .and. (Month(dInicio) < 7)
			dInicio := CtoD("01/04/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >= 7) .and. (Month(dInicio) < 10)
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
		ElseIf (Month(dInicio) >=10)
			dInicio := CtoD("01/10/"+Substr(DtoC(dInicio),7),cForAno)
		EndIf
	ElseIf (nTipo == 6)                     // Semestral
		If Month(dInicio) <= 6
			dInicio := CtoD("01/01/"+Substr(DtoC(dInicio),7),cForAno)
		Else
			dInicio := CtoD("01/07/"+Substr(DtoC(dInicio),7),cForAno)
		EndIf
	EndIf*/

	If nTipo != 7
		For i := 1 to nPeriodos
			//AADD(aRet,dInicio)
			If nTipo == 1
				dInicio ++
				While !lConsSabDom .And. ( DOW(dInicio) == 1 .or. DOW(dInicio) == 7 )
					dInicio++
				EndDo
			ElseIf nTipo == 2
				dInicio+=7
			ElseIf nTipo == 3
				dInicio := StoD(If(Substr(DtoS(dInicio),7,2)<"15",Substr(DtoS(dInicio),1,6)+"15",;
				If(Month(dInicio)+1<=12,Str(Year(dInicio),4)+StrZero(Month(dInicio)+1,2)+"01",;
				Str(Year(dInicio)+1,4)+"0101")),cForAno)			
			ElseIf nTipo == 4
				dInicio := CtoD("01/"+If(Month(dInicio)+1<=12,StrZero(Month(dInicio)+1,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 5
				dInicio := CtoD("01/"+If(Month(dInicio)+3<=12,StrZero(Month(dInicio)+3,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			ElseIf nTipo == 6
				dInicio := CtoD("01/"+If(Month(dInicio)+6<=12,StrZero(Month(dInicio)+6,2)+;
				"/"+Substr(Str(Year(dInicio),4),nPosAno,nTamAno),"01/"+Substr(Str(Year(dInicio)+1,4),nPosAno,nTamAno)),cForAno)
			EndIf
		Next i
	EndIf

Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetTpProd บAutor  ณMicrosiga 	          บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o tipo de produto									  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetTpProd()

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local aRet		:= {}

	cQuery	:= " SELECT B1_TIPO FROM "+RetSqlName("CZJ")+" CZJ "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = CZJ.CZJ_PROD "+CRLF
	cQuery  += " AND SB1.B1_TIPO IN ('EM','MP','PA','PI','ME','MP')"+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "+CRLF 
	cQuery	+= " AND CZJ.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY B1_TIPO "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)


	While (cArqTmp)->(!Eof())

		Aadd(aRet, (cArqTmp)->B1_TIPO)

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return aRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetCodPer บAutor  ณMicrosiga 	          บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os codios dos periodos							  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*Static Function GetCodPer()

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local aRet		:= {}


	cQuery	:= " SELECT CZK_PERMRP FROM "+RetSqlName("CZK")+" CZK "+CRLF
	cQuery	+= " WHERE CZK.D_E_L_E_T_ = ' ' "+CRLF
	cQuery	+= " GROUP BY CZK_PERMRP "+CRLF
	cQuery	+= " ORDER BY CZK_PERMRP "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	While (cArqTmp)->(!Eof())

		Aadd(aRet, Alltrim((cArqTmp)->CZK_PERMRP))

		(cArqTmp)->(DbSkip())
	EndDo

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return aRet*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetDadRel บAutor  ณMicrosiga 	          บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna os dados do relatorio								  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDadRel(aCodPer, cTpProd)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nX		:= 0
	Local aCons		:= {}
	Local cFormCons	:= ""
	Local cCpoCons	:= ""	
	Local cArmz 	:= U_MyNewSX6("CV_ARMCSPR", "00|09|10|11|98|20|95"	,"C","Armazens nใo considerados na consulta de saldo em estoque", "", "", .F. )

	Default aCodPer	:= {} 
	Default cTpProd	:= ""

	//Campos e formula para calculo do consumo medio
	aCons 		:= GetCpoCons()
	cFormCons	:= aCons[1]
	cCpoCons	:= aCons[2]

	cQuery	+= " SELECT  CZJ_PROD, B1_COD, B1_IMPORT, B1_DESC, ISNULL(B5_MPXME,'') B5_MPXME, "+CRLF 
	cQuery	+= " 		SUM(B1_ESTSEG) B1_ESTSEG, " +CRLF
	cQuery	+= " 		SUM(MEDIA_CONSUMO) MEDIA_CONSUMO, "+CRLF 
	cQuery	+= " 		SUM(SALDO_SB2) + SUM(SALDO_BLOQ) SALDO_SB2, "+CRLF
	cQuery	+= " 		SUM(SALDO_ARM_97) SALDO_ARM_97, "+CRLF
	cQuery	+= " 		SUM(CZK_QTSEST) CZK_QTSEST, "+CRLF
	cQuery	+= " 		SUM(CZK_QTENTR) CZK_QTENTR, "+CRLF
	cQuery	+= " 		(SUM(SALDO_SB2) - SUM(SALDO_BLOQ) -SUM(CZK_QTSEST)) DIF "+CRLF

	For nX := 1 To Len(aCodPer)
		cQuery	+= ", SUM(PER_"+Alltrim(aCodPer[nX])+") PER_"+Alltrim(aCodPer[nX])+" "+CRLF
	Next

	cQuery	+= " 		 FROM ( "+CRLF

	cQuery	+= " SELECT CZJ_PROD, B1_COD, B1_DESC, CASE WHEN B1_IMPORT = 'S' THEN 'SIM' ELSE 'NAO' END B1_IMPORT, B5_MPXME, B1_ESTSEG, "+CRLF
	cQuery	+= " 	"+cFormCons+" MEDIA_CONSUMO, "+CRLF
	cQuery	+= " 	SUM(SB2.B2_QATU-(SB2.B2_RESERVA+SB2.B2_QEMP+SB2.B2_QACLASS) ) SALDO_SB2, "+CRLF
	cQuery  += "    (SELECT ISNULL(SUM(DD_SALDO),0) FROM SDD010 DD WHERE DD_PRODUTO = SB1.B1_COD AND DD_SALDO > 0 AND DD_DTVALID >= '"+DtoS(date())+"' AND DD.D_E_L_E_T_ = '') SALDO_BLOQ, "+CRLF
	cQuery	+= " 	(SELECT ARM97.B2_QATU-(ARM97.B2_RESERVA+ARM97.B2_QEMP+ARM97.B2_QACLASS) FROM SB2010 ARM97 WHERE ARM97.B2_FILIAL = SB1.B1_FILIAL AND ARM97.B2_COD = SB1.B1_COD AND ARM97.B2_LOCAL = '97' AND ARM97.D_E_L_E_T_ = ' '  ) SALDO_ARM_97, "+CRLF
	cQuery	+= " 	0 CZK_QTSEST, "+CRLF
	cQuery	+= " 	0 CZK_QTENTR "+CRLF

	For nX := 1 To Len(aCodPer)
		cQuery	+= ", 0 PER_"+Alltrim(aCodPer[nX])+" "+CRLF
	Next

	cQuery	+= " 	FROM "+RetSqlName("CZJ")+" CZJ "+CRLF 

	cQuery	+= "  INNER JOIN "+RetSqlName("SB1")+" SB1 " +CRLF
	cQuery	+= "  ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
	cQuery	+= "  AND SB1.B1_TIPO = '"+cTpProd+"' "+CRLF 
	cQuery	+= "  AND SB1.B1_COD = CZJ.CZJ_PROD " +CRLF
	cQuery	+= "  AND SB1.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  LEFT JOIN "+RetSqlName("SB5")+" SB5 " +CRLF
	cQuery	+= "  ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' " +CRLF
	cQuery	+= "  AND SB5.B5_COD = CZJ.CZJ_PROD " +CRLF
	cQuery	+= "  AND SB5.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  INNER JOIN "+RetSqlName("SB2")+" SB2 "+CRLF 
	cQuery	+= "  ON SB2.B2_FILIAL = '"+xFilial("SB2")+"' " +CRLF
	cQuery	+= "  AND SB2.B2_COD = SB1.B1_COD " +CRLF
	cQuery	+= "  AND SB2.B2_LOCAL NOT IN"+FORMATIN(cArmz,"|")+"  "+CRLF  
	cQuery	+= "  AND SB2.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  LEFT JOIN "+RetSqlName("SB3")+" SB3 "+CRLF 
	cQuery	+= "  ON SB3.B3_FILIAL = '"+xFilial("SB3")+"' " +CRLF
	cQuery	+= "  AND SB3.B3_COD = SB1.B1_COD " +CRLF
	cQuery	+= "  AND SB3.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  WHERE CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "+CRLF 
	cQuery	+= "  AND CZJ.D_E_L_E_T_ = ' ' " +CRLF
	cQuery	+= "  GROUP BY CZJ_PROD, B1_FILIAL, B1_COD, B1_IMPORT, B1_DESC, B5_MPXME, B1_ESTSEG, "+cCpoCons+CRLF

	cQuery	+= "  UNION ALL "+CRLF
	cQuery	+= "  SELECT CZJ_PROD, B1_COD, B1_DESC, CASE WHEN B1_IMPORT = 'S' THEN 'SIM' ELSE 'NAO' END B1_IMPORT, B5_MPXME, 0 B1_ESTSEG, "+CRLF 
	cQuery	+= " 		0 MEDIA_CONSUMO, "+CRLF
	cQuery	+= "  		0 SALDO_SB2, " +CRLF
	cQuery  += "        0 SALDO_BLOQ, "+CRLF
	cQuery	+= " 		0 SALDO_ARM_97, "+CRLF

	If Alltrim(cTpProd) $ "ME|PA"
		cQuery	+= "  		SUM(CZK_QTSAID) CZK_QTSEST, "+CRLF
	Else
		cQuery	+= "  		SUM(CZK_QTSEST) CZK_QTSEST, "+CRLF
	EndIf

	cQuery	+= "  		SUM(CZK_QTENTR) CZK_QTENTR " +CRLF

	For nX := 1 To Len(aCodPer)
		If Alltrim(cTpProd) $ "ME|PA"
			cQuery	+= ", SUM(CASE WHEN CZK_PERMRP = '"+Alltrim(aCodPer[nX])+"' THEN CZK_QTSAID ELSE 0 END) PER_"+Alltrim(aCodPer[nX])+" "+CRLF
		Else
			cQuery	+= ", SUM(CASE WHEN CZK_PERMRP = '"+Alltrim(aCodPer[nX])+"' THEN CZK_QTSEST ELSE 0 END) PER_"+Alltrim(aCodPer[nX])+" "+CRLF
		EndIf
	Next

	cQuery	+= "  		 FROM "+RetSqlName("CZJ")+" CZJ " +CRLF

	cQuery	+= "  INNER JOIN "+RetSqlName("SB1")+" SB1 " +CRLF
	cQuery	+= "  ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' " +CRLF
	cQuery	+= "  AND SB1.B1_TIPO = '"+cTpProd+"' "+CRLF 
	cQuery	+= "  AND SB1.B1_COD = CZJ.CZJ_PROD " +CRLF
	cQuery	+= "  AND SB1.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  LEFT JOIN "+RetSqlName("SB5")+" SB5 " +CRLF
	cQuery	+= "  ON SB5.B5_FILIAL = '"+xFilial("SB5")+"' " +CRLF
	cQuery	+= "  AND SB5.B5_COD = CZJ.CZJ_PROD " +CRLF
	cQuery	+= "  AND SB5.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  INNER JOIN "+RetSqlName("CZK")+" CZK "+CRLF 
	cQuery	+= "  ON CZK.CZK_FILIAL = CZJ.CZJ_FILIAL " +CRLF
	cQuery	+= "  AND CZK.CZK_NRMRP = CZJ.CZJ_NRMRP " +CRLF
	cQuery	+= "  AND CZK.CZK_RGCZJ = CZJ.R_E_C_N_O_ " +CRLF
	cQuery	+= "  AND CZK.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  WHERE CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "+CRLF 
	cQuery	+= "  AND CZJ.D_E_L_E_T_ = ' ' " +CRLF
	cQuery	+= "  GROUP BY CZJ_PROD, B1_COD, B1_IMPORT, B1_DESC, B5_MPXME "+CRLF
	cQuery	+= "  ) DADOS "+CRLF
	cQuery	+= "  GROUP BY CZJ_PROD, B1_COD, B1_IMPORT, B1_DESC, B5_MPXME "+CRLF
	cQuery	+= "  ORDER BY DIF "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)


	RestArea(aArea)
Return cArqTmp


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
	Local cLoadArq		:= "pzcvr007"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)		

	AADD(aParamBox,{6,"Endere็o destino do arquivo","","","ExistDir(&(ReadVar()))","",080,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY})

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetForeCast  บAutor  ณMicrosiga        บ Data ณ  10/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o forecast do produto		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetForeCast(cCodProd)

	Local aArea	:= GetArea()
	Local aRet	:= {0,0}

	Default cCodProd := ""

	DbSelectArea("SB1")
	DbSetOrder(1)
	If SB1->(DbSeek(xFilial("SB1") + cCodProd))

		//Retorna o forecast do produto 
		//Parametro nOpc:
		//0=Crias as tabelas temporarias do Forecast
		//1=Retorna o forecast aglutinado para o produto informado
		//2=Fecha as tabelas temporarias do forecast
		aRet := U_PZCVP017(1, SB1->B1_COD, SB1->B1_TIPO, 3)

	EndIf

	RestArea(aArea)
Return aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetConsumo   บAutor  ณDenis Varella    บ Data ณ  05/04/21   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o consumo do produto		                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetConsumo(cCodProd, nMeses)
Local nConsumo 	:= 0
Local dData 	:= MsDate()
Local cMeses 	:= ""
Local nM		:= 0
Default nMeses 	:= 9

	For nM := 1 To nMeses
		If nM > 1
			cMeses += "+"
		Endif
		cMeses += "B3_Q"+PadL(Month(MonthSub(dData,nM)),2,"0")
	Next nM

	cQry := "SELECT sum("+cMeses+") TOTAL FROM SB3010 WHERE B3_COD = '"+cCodProd+"' AND D_E_L_E_T_ = ''"

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQry) , "CONSUMO",.T.,.T.)

	If CONSUMO->(!eof())
		nConsumo := CONSUMO->TOTAL
	EndIf

	CONSUMO->(DbCloseArea())

Return nConsumo


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetCpoCons   บAutor  ณMicrosiga        บ Data ณ  10/07/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a formula para o consumo medio					  บฑฑ
ฑฑบ          ณ										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                               	                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCpoCons()

	Local aRet	:= {}
	Local nMes	:= Month(MsDate())

	If nMes == 1
		aRet	:= {"ROUND((B3_Q12+B3_Q11+B3_Q10)/3,2)", "B3_Q12, B3_Q11, B3_Q10 " }
	ElseIf nMes == 2
		aRet	:= {"ROUND((B3_Q01+B3_Q12+B3_Q11)/3,2)", "B3_Q01, B3_Q12, B3_Q11" }
	ElseIf nMes == 3
		aRet	:= {"ROUND((B3_Q02+B3_Q01+B3_Q12)/3,2)", "B3_Q02, B3_Q01, B3_Q12" }
	ElseIf nMes == 4
		aRet	:= {"ROUND((B3_Q03+B3_Q02+B3_Q01)/3,2)", "B3_Q03, B3_Q02, B3_Q01" }
	ElseIf nMes == 5
		aRet	:= {"ROUND((B3_Q04+B3_Q03+B3_Q01)/3,2)", "B3_Q04, B3_Q03, B3_Q01" }
	ElseIf nMes == 6
		aRet	:= {"ROUND((B3_Q05+B3_Q04+B3_Q03)/3,2)", "B3_Q05, B3_Q04, B3_Q03" }
	ElseIf nMes == 7
		aRet	:= {"ROUND((B3_Q06+B3_Q05+B3_Q04)/3,2)", "B3_Q06, B3_Q05, B3_Q04" }
	ElseIf nMes == 8
		aRet	:= {"ROUND((B3_Q07+B3_Q06+B3_Q05)/3,2)", "B3_Q07, B3_Q06, B3_Q05" }
	ElseIf nMes == 9
		aRet	:= {"ROUND((B3_Q08+B3_Q07+B3_Q06)/3,2)", "B3_Q08, B3_Q07, B3_Q06" }
	ElseIf nMes == 10
		aRet	:= {"ROUND((B3_Q09+B3_Q08+B3_Q07)/3,2)", "B3_Q09, B3_Q08, B3_Q07" }
	ElseIf nMes == 11
		aRet	:= {"ROUND((B3_Q10+B3_Q09+B3_Q08)/3,2)", "B3_Q10, B3_Q09, B3_Q08" }
	ElseIf nMes == 12
		aRet	:= {"ROUND((B3_Q11+B3_Q10+B3_Q09)/3,2)", "B3_Q11, B3_Q10, B3_Q09" }
	EndIf 

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณGetMsgMail	บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMensagem a ser enviada no e-mail							  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetMsgMail()


	Local cRet	:= ""

	cRet += "<html> "
	cRet += "	<head></head> "
	cRet += "	<body> "
	cRet += "		Legenda das colunas: <br></br><br></br> "
	cRet += "		DESCRIวรO = Nome comercial<br></br> "
	cRet += "		FORECAST = Forecast do periodo de 91 dias, em caso de forecast zerado nใo serแ apresentado o produto<br></br> "	
    cRet += "		FORECAST DIA = Forecast Periodo 91 dias dividido pela quantidade de  91 dias<br></br> "
	cRet += "		ESTOQUE DE SEGURANวA = Informa็๕es do cadastro de produtos<br></br> "	
	cRet += "		ESTOQUE DE SEGURANวA COBERTO= Indica se o estoque disponํvel esta dentro do limite estipulado com o estoque de segura็a<br></br> "	
	cRet += "		QUANTIDADE DISPONIVEL = Soma do estoque disponivel com o estoque em quarentena<br></br> "
	cRet += "		ESTOQUE EM TRANSITO = Apenas o que chegarแ dentro do periodo analisado<br></br> "
	cRet += "		PRAZO DE REPOSIวรO = Informa็ใo do cadastro do produto<br></br> "
	cRet += "		PONTO DE PEDIDO QUANTIDADE = Indica qual o minimo que precisa ter em estoque para atender o forecast sem atingir o estoque de seguran็a<br></br> "
	cRet += "		PONTO DE PEDIDO STATUS = Indica se ้ o momento de incluir um pedido novo<br></br> "
	cRet += "		SUGESTรO DE PEDIDOS = Quantidade que precisarแ ser comprada quando atingir o ponto de pedido<br></br> "
	cRet += "		ESTOQUE CRITICO = Indica que a quantidade disponํvel nใo ้ suficiente para cobrir a necessidade de estoque durante o prazo de reposi็ใo<br></br> "
	cRet += "		ARMAZษM 97 = Soma do estoque disponivel no armaz้m 97<br></br> "
	cRet += "		IMPORTADO = Indica se o produto ้ importado ou nใo<br></br> "
	cRet += "		<br></br><br></br> "
	cRet += "		Mensagem automแtica, favor nใo responder. "
	cRet += "	</body> "
	cRet += "</html> "

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetSldQuar บAutor  ณMicrosiga 	      บ Data ณ 01/08/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a quantidade do produto em quarentena				  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetSldQuar(cCodProd)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nRet		:= 0
	Local cArmz		:= U_MyNewSX6("CV_ARMQUAR", "93|98"	,"C","Armazens em quarentena.", "", "", .F. )

	cQuery	:= " SELECT SUM(B2_QATU) B2_QATU FROM "+RetSqlName("SB2")+" SB2 "+CRLF
	cQuery	+= " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' " +CRLF
	cQuery	+= " AND SB2.B2_COD = '"+cCodProd+"' " +CRLF
	cQuery	+= " AND SB2.B2_LOCAL IN"+FORMATIN(cArmz,"|")+"  "+CRLF
	cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->B2_QATU
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetSldTran บAutor  ณMicrosiga 	      บ Data ณ 29/12/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a quantidade do produto em transito.				  บฑฑ
ฑฑบ          ณ												    		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ			                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetSldTran(cCodProd)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nRet		:= 0
	Local cDataIn	:= " "

	cDataIn 	:= GravaData(dMrpIni,.F.,8)
	cDataFim	:= GravaData(dMrpFim,.F.,8)

	cQuery	:= " SELECT SUM(C7_QUANT) C7_QUANT FROM "+RetSqlName("SC7")+" SC7 "+CRLF
	cQuery	+= " WHERE SC7.C7_FILIAL = '"+xFilial("SC7")+"' " +CRLF
	cQuery	+= " AND SC7.C7_PRODUTO = '"+cCodProd+"' " +CRLF
	cQuery	+= " AND SC7.C7_DATPRF BETWEEN '"+cDataIn+"' and '"+cDataFim+"'  "+CRLF
	cQuery	+= " AND SC7.C7_ENCER != 'E' "+CRLF
	cQuery	+= " AND SC7.D_E_L_E_T_ = ' ' "+CRLF

	//cQuery	:= " SELECT SUM(B2_QATU) B2_QATU FROM "+RetSqlName("SB2")+" SB2 "+CRLF
	//cQuery	+= " WHERE SB2.B2_FILIAL = '"+xFilial("SB2")+"' " +CRLF
	//cQuery	+= " AND SB2.B2_COD = '"+cCodProd+"' " +CRLF
	//cQuery	+= " AND SB2.B2_LOCAL IN"+FORMATIN(cArmx,"|")+"  "+CRLF
	//cQuery	+= " AND SB2.D_E_L_E_T_ = ' ' "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->C7_QUANT
	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณCriaTabTmp	บAutor  ณMicrosiga	     บ Data ณ  14/10/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria a tabela temporaria para armazenar os dados da aba	  บฑฑ
ฑฑบ          ณgeral. 						                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaTabTmp(aCodPer)

	Local aArea 	:= GetArea()
	Local aCmp		:= {}
	Local cArq		:= ""
	Local cIndex	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nX		:= 0

	aAdd (aCmp, {"TMP_CODIGO"	,"C", TAMSX3("B1_COD")[1]		,	0})
	aAdd (aCmp, {"TMP_DESC"		,"C", TAMSX3("B1_DESC")[1]		,	0})
	aAdd (aCmp, {"TMP_TIPO"		,"C", TAMSX3("B1_TIPO")[1]		,	0})
	aAdd (aCmp, {"TMP_FORECA"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_CONSUM"	,"N", TAMSX3("C4_QUANT")[1]+2		,	TAMSX3("C4_QUANT")[2]})
    aAdd (aCmp, {"TMP_FORENE"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_ESTSEG"	,"N", TAMSX3("B1_ESTSEG")[1]	,	TAMSX3("B1_ESTSEG")[2]})
	aAdd (aCmp, {"TMP_ESEGCO"	,"C", 4						   	,	2})
	aAdd (aCmp, {"TMP_ESTTRA"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_QTDDIS"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_PERENT"	,"N", TAMSX3("B1_PE")[1]		,	TAMSX3("B1_PE")[2]})
	aAdd (aCmp, {"TMP_PONPED"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_PONPET"	,"C", 4						   	,	2})
	aAdd (aCmp, {"TMP_SUGPED"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_ESTCRI"	,"C", 4						   	,	2})
	aAdd (aCmp, {"TMP_QTD97"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_IMPORT"	,"C", 3	,	0})
	aAdd (aCmp, {"TMP_MPXME"	,"C", TAMSX3("B5_MPXME")[1]		,	TAMSX3("B5_MPXME")[2]})

	/*
	aAdd (aCmp, {"TMP_CODIGO"	,"C", TAMSX3("B1_COD")[1]		,	0})
	aAdd (aCmp, {"TMP_DESC"		,"C", TAMSX3("B1_DESC")[1]		,	0})
	aAdd (aCmp, {"TMP_TIPO"		,"C", TAMSX3("B1_TIPO")[1]		,	0})
    aAdd (aCmp, {"TMP_FORENE"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
    aAdd (aCmp, {"TMP_ESTCRI"	,"C", 4						   	,	2})
	aAdd (aCmp, {"TMP_PONPED"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_PERENT"	,"N", TAMSX3("B1_PE")[1]		,	TAMSX3("B1_PE")[2]})
	aAdd (aCmp, {"TMP_QTDDIS"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_QTDQUA"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_ESTSEG"	,"N", TAMSX3("B1_ESTSEG")[1]	,	TAMSX3("B1_ESTSEG")[2]})
	aAdd (aCmp, {"TMP_NECES"	,"N", TAMSX3("CZK_QTSEST")[1]	,	TAMSX3("CZK_QTSEST")[2]})
	aAdd (aCmp, {"TMP_FORECA"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_MEDCON"	,"N", 10						,	2})
	aAdd (aCmp, {"TMP_ENTPRE"	,"N", TAMSX3("CZK_QTENTR")[1]	,	TAMSX3("CZK_QTENTR")[2]})
	aAdd (aCmp, {"TMP_DIF"		,"N", TAMSX3("CZK_QTSEST")[1]	,	TAMSX3("CZK_QTSEST")[2]})
	*/

	For nX := 1 To Len(aCodPer)
		aAdd (aCmp, {"TMP_P"+Alltrim(aCodPer[nX])		,"N", TAMSX3("B2_QATU")[1]	,	TAMSX3("B2_QATU")[2]})
	Next

	cArq	:=	CriaTrab(aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cArqTmp)

	cIndex := CriaTrab(,.F.)
	IndRegua(cArqTmp, cIndex, "TMP_TIPO+TMP_CODIGO")

	dbClearIndex()
	dbSetIndex(cIndex+OrdBagExt())

	RestArea(aArea)

Return cArqTmp

#include 'protheus.ch'
#include 'TBICONN.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR007		บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio de MRP (Utilizado em menu)						  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/
User function PZCVR007()

	// Local cArq 		:= "base_pedidos_colocados_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls" 
	Local aParam	:= {}
	Local cDir			:= "\_Relatorios\"
	Local cArq 			:= cDir+"base_pedidos_colocados_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"	
	Local cAssunto		:= "Relat๓rio base pedidos colocados "
	Local cMensagem		:= GetMsgMail()
	Local cEmailCc		:= ""
	Local cMsgErr		:= ""
	Local cMailDest		:= ""
	Default aDados	:=	 {"01","01"}

	If PergRel(@aParam)
		//Executa o relatorio 
		Processa( {|| RunRel(Alltrim(aParam[1])+cArq) },"Aguarde...","" )

		If File(Alltrim(aParam[1])+cArq)
			OpenExcel(Alltrim(aParam[1])+cArq)
		EndIf
	EndIf
	cMailDest	:= U_MyNewSX6("CV_MAILMRP", "","C","E-mail dos destinatแrios que receberใo o relat๓rio de MRP", "", "", .F. )

	//Executa o relatorio
	RunRel(cArq)

	//Verifica se o arquivo existe. Se existir serแ enviado por e-mail
	If File(cArq)

		//Envia o relatorio por e-mail
		EnvMail(cMailDest,cAssunto,cMensagem,cEmailCc, cArq, @cMsgErr)

		//Exclui o arquivo ap๓s o envio
		FERASE(cArq)
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVRJ07		บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio MRP (Utilizado em job)							  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function PZCVRJ07(aDados)
	// Local cDir			:= "\_Relatorios\"
	// Local cArq 			:= cDir+"base_pedidos_colocados_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"		
	Local nX			:= 0
	Local aPeriodos		:= {}
	Local nTipo			:= 0
	Local aNomeAba		:= {}
	Local aCodPer		:= {}
	Local cArqTmp		:= ""
	Local nCnt			:= 0 
	Local cDir			:= "\_Relatorios\"
	Local cArq 			:= cDir+"base_pedidos_colocados_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"	
	Local cAssunto		:= "Relat๓rio base pedidos colocados "
	Local cMensagem		:= GetMsgMail()
	Local cEmailCc		:= ""
	Local cMsgErr		:= ""
	Local cMailDest		:= ""
	Default aDados	:=	 {"01","01"}

	
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(aDados[1], aDados[2])

	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" USER "Admin" PASSWORD "adm@2023" MODULO "PCP"

	//E-mail dos destinatarios
	cMailDest	:= U_MyNewSX6("CV_MAILMRP", "","C","E-mail dos destinatแrios que receberใo o relat๓rio de MRP", "", "", .F. )
	//cMailDest := "denis.varella@newbridge.srv.br"

	//Executa o relatorio
	RunRel(cArq)

	//Verifica se o arquivo existe. Se existir serแ enviado por e-mail
	If File(cArq)

		//Envia o relatorio por e-mail
		EnvMail(cMailDest,cAssunto,cMensagem,cEmailCc, cArq, @cMsgErr)

		//Exclui o arquivo ap๓s o envio
		FERASE(cArq)
	RESET ENVIRONMENT		
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRunRel		บAutor  ณMicrosiga	     บ Data ณ  21/09/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa a rotina de era็ใo do relatorio					  บฑฑ
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

	//Inicia a cria็ใo das tabelas de calculo do forecast 
	//Parametro nOpc:
	//0=Crias as tabelas temporarias do Forecast
	//1=Retorna o forecast aglutinado para o produto informado
	//2=Fecha as tabelas temporarias do forecast
	U_PZCVP007(0)

	//Descri็ใo dos periodos
	aPeriodos	:= R882PER(@nTipo)

	//Tipo de produtos a serem utilizados como nome da aba
	aNomeAba	:= GetTpProd()

	//Codigos dos periodos
	aCodPer		:= GetCodPer()

	//Cria a tabela temporaria para ser utilizada na aba geral
	cArqGer	:= CriaTabTmp(aCodPer)

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
		PrintSheet(cArq, aCodPer, cArqTmp, cArqGer, Alltrim(aNomeAba[nX])) 

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



	//FECHA O WORKBOOK
	CloseBook(cArq)


	//Fecha as tabelas de calculo do forecast
	//Parametro nOpc:
	//0=Crias as tabelas temporarias do Forecast
	//1=Retorna o forecast aglutinado para o produto informado
	//2=Fecha as tabelas temporarias do forecast
	U_PZCVP007(2)

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

	cDadosArq   += ' <Style ss:ID="s69" ss:Parent="s16">' +CRLF 
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
	cDadosArq   += '  <Table ss:ExpandedColumnCount="'+Alltrim(Str(15+nQtdCol))+'" ss:ExpandedRowCount="'+Alltrim(Str(nQtdRow+5))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="59.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="216.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="59.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="128.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="150.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="108"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="92.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:Width="86.25"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="109.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="74.25"/>' +CRLF 

	For nX := 1 To Len(aPeriodos)
		cDadosArq   += '   <Column ss:StyleID="s66" ss:AutoFitWidth="0" ss:Width="80.25"/>' +CRLF
	nEXT

	cDadosArq   += '   <Row ss:AutoFitHeight="0" ss:Height="18">' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">CODIGO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">DESCRICAO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">TIPO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">QUANTIDADE DISPONIVEL</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">QUANTIDADE EM QUARENTENA</Data></Cell>' +CRLF	
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ESTOQUE SEGURANCA</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">NECESSIDADE</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">FORECAST</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">MEDIA CONSUMO</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">ENTRADA PREVISTA</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">DIFERENCA</Data></Cell>' +CRLF

	For nX := 1 To Len(aPeriodos)
		cDadosArq   += '    <Cell ss:StyleID="s141"><Data ss:Type="String">'+DTOC(aPeriodos[nX])+'</Data></Cell>' +CRLF
		//cDadosArq   += '    <Cell ss:StyleID="s142"><Data ss:Type="DateTime">2019-09-09T00:00:00.000</Data></Cell>' +CRLF
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
Static Function PrintSheet(cArq, aCodPer, cArqTmp, cArqGer, cTp)

	Local aArea  		:= GetArea()
	Local cDadosArq   	:= ""
	Local nX			:= 0
	Local nPerVal		:= 0
	Local nQuarent		:= 0
	Local aForecast		:= {0,0}
	Local nForeCast		:= 0        

	Default cArq 		:= ""
	Default aCodPer		:= {} 
	Default cArqTmp		:= ""
	Default cArqGer		:= ""
	Default cTp			:= ""

	While (cArqTmp)->(!Eof())

		nQuarent		:= GetSldQuar((cArqTmp)->B1_COD)
		nForeCast 		:= GetForeCast((cArqTmp)->B1_COD)

		cDadosArq   := '   <Row>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->B1_COD+'</Data></Cell>' +CRLF 
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqTmp)->B1_DESC+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+cTp+'</Data></Cell>' +CRLF		
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqTmp)->SALDO_SB2))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nQuarent))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqTmp)->B1_ESTSEG))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqTmp)->CZK_QTSEST))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nForeCast))+'</Data></Cell>' +CRLF //Forecast
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqTmp)->MEDIA_CONSUMO))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqTmp)->CZK_QTENTR))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqTmp)->(SALDO_SB2-CZK_QTSEST)))+'</Data></Cell>' +CRLF 

		nPerVal := 0
		For nX := 1 To Len(aCodPer)
			nPerVal += (cArqTmp)->&("PER_"+Alltrim(aCodPer[nX]))

			//Verifica se o valor dos periodos anteriores e maior que o saldo disponivel. Se for, serแ apresentado cor vermelha no relatorio
			If nPerVal > (cArqTmp)->SALDO_SB2
				cDadosArq   += '    <Cell ss:StyleID="s69"><Data ss:Type="Number">'+ Alltrim(Str((cArqTmp)->&("PER_"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			Else
				cDadosArq   += '    <Cell><Data ss:Type="Number">'+ Alltrim(Str((cArqTmp)->&("PER_"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			EndIf
		Next

		cDadosArq   += '   </Row>' +CRLF

		//Grava os dados na tabela temporaria que serแ utilizada na aba geral
		If !Empty(cArqGer)
			RecLock(cArqGer, .T.)

			(cArqGer)->TMP_CODIGO	:= (cArqTmp)->B1_COD
			(cArqGer)->TMP_DESC		:= (cArqTmp)->B1_DESC
			(cArqGer)->TMP_TIPO		:= cTp
			(cArqGer)->TMP_QTDDIS	:= (cArqTmp)->SALDO_SB2
			(cArqGer)->TMP_QTDQUA	:= nQuarent
			(cArqGer)->TMP_ESTSEG	:= (cArqTmp)->B1_ESTSEG
			(cArqGer)->TMP_NECES	:= (cArqTmp)->CZK_QTSEST
			(cArqGer)->TMP_FORECA   := nForeCast
			(cArqGer)->TMP_MEDCON   := (cArqTmp)->MEDIA_CONSUMO
			(cArqGer)->TMP_ENTPRE   := (cArqTmp)->CZK_QTENTR
			(cArqGer)->TMP_DIF      := (cArqTmp)->(SALDO_SB2-CZK_QTSEST)

			For nX := 1 To Len(aCodPer)		
				(cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX])) := (cArqTmp)->&("PER_"+Alltrim(aCodPer[nX]))
			Next 

			(cArqGer)->(MsUnLock())
		EndIf

		GrvTxtArq( cArq, cDadosArq )

		(cArqTmp)->(DbSkip())
	EndDo

	//Fecha o arquivo temporario
	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return


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

	Default cArq 		:= ""
	Default aCodPer		:= {} 
	Default cArqGer		:= ""

	While (cArqGer)->(!Eof())

		cDadosArq   := '   <Row>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqGer)->TMP_CODIGO+'</Data></Cell>' +CRLF 
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqGer)->TMP_DESC+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+(cArqGer)->TMP_TIPO+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_QTDDIS))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_QTDQUA))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_ESTSEG))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_NECES))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_FORECA))+'</Data></Cell>' +CRLF //Forecast
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_MEDCON))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_ENTPRE))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str((cArqGer)->TMP_DIF))+'</Data></Cell>' +CRLF 

		nPerVal := 0
		For nX := 1 To Len(aCodPer)
			nPerVal += (cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX]))

			//Verifica se o valor dos periodos anteriores e maior que o saldo disponivel. Se for, serแ apresentado cor vermelha no relatorio
			If nPerVal > (cArqGer)->TMP_QTDDIS
				cDadosArq   += '    <Cell ss:StyleID="s69"><Data ss:Type="Number">'+ Alltrim(Str((cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			Else
				cDadosArq   += '    <Cell><Data ss:Type="Number">'+ Alltrim(Str((cArqGer)->&("TMP_P"+Alltrim(aCodPer[nX])))) +'</Data></Cell>' +CRLF
			EndIf
		Next

		cDadosArq   += '   </Row>' +CRLF

		GrvTxtArq( cArq, cDadosArq )

		(cArqGer)->(DbSkip())
	EndDo

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
	dbSelectArea("CZI")
	dbSetOrder(1)
	DbSeek(xFilial("CZI"))
	While !Eof() .And. xFilial("CZI") == CZI->CZI_FILIAL
		// Recupera parametrizacao gravada no ultimo processamento
		// A T E N C A O
		// Quando utilizado o processamento por periodos variaveis o sistema monta o array com
		// os periodos de maneira desordenada, por causa do indice do arquivo SH5
		// O array aRet ้ corrigido logo abaixo
		If CZI_ALIAS == "PAR"
			nTipo       := CZI_NRRGAL
			dInicio     := CZI_DTOG
			nPeriodos   := CZI_QUANT
			If nTipo == 7
				AADD(aRet,DTOS(CTOD(Alltrim(CZI_OPC))))
			EndIf
			//NUMERO DO MRP                                                ณ
			c711NumMRP := CZI_NRMRP
		EndIf
		dbSkip()
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
	EndIf

	If nTipo != 7
		For i := 1 to nPeriodos
			AADD(aRet,dInicio)
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
Static Function GetCodPer()

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
Return aRet


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

	cQuery	+= " SELECT CZJ_PROD, B1_COD, B1_DESC, "+CRLF 
	cQuery	+= " 		SUM(B1_ESTSEG) B1_ESTSEG, " +CRLF
	cQuery	+= " 		SUM(MEDIA_CONSUMO) MEDIA_CONSUMO, "+CRLF 
	cQuery	+= " 		SUM(SALDO_SB2) SALDO_SB2, "+CRLF
	cQuery	+= " 		SUM(CZK_QTSEST) CZK_QTSEST, "+CRLF
	cQuery	+= " 		SUM(CZK_QTENTR) CZK_QTENTR, "+CRLF
	cQuery	+= " 		(SUM(SALDO_SB2)-SUM(CZK_QTSEST)) DIF "+CRLF

	For nX := 1 To Len(aCodPer)
		cQuery	+= ", SUM(PER_"+Alltrim(aCodPer[nX])+") PER_"+Alltrim(aCodPer[nX])+" "+CRLF
	Next

	cQuery	+= " 		 FROM ( "+CRLF

	cQuery	+= " SELECT CZJ_PROD, B1_COD, B1_DESC, B1_ESTSEG, "+CRLF
	cQuery	+= " 	"+cFormCons+" MEDIA_CONSUMO, "+CRLF
	cQuery	+= " 	SUM(B2_QATU-(B2_RESERVA+B2_QEMP+B2_QACLASS) ) SALDO_SB2, "+CRLF
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
	cQuery	+= "  GROUP BY CZJ_PROD, B1_COD, B1_DESC, B1_ESTSEG, "+cCpoCons+CRLF

	cQuery	+= "  UNION ALL "+CRLF
	cQuery	+= "  SELECT CZJ_PROD, B1_COD, B1_DESC, 0 B1_ESTSEG, "+CRLF 
	cQuery	+= " 		0 MEDIA_CONSUMO, "+CRLF
	cQuery	+= "  		0 SALDO_SB2, " +CRLF

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

	cQuery	+= "  INNER JOIN "+RetSqlName("CZK")+" CZK "+CRLF 
	cQuery	+= "  ON CZK.CZK_FILIAL = CZJ.CZJ_FILIAL " +CRLF
	cQuery	+= "  AND CZK.CZK_NRMRP = CZJ.CZJ_NRMRP " +CRLF
	cQuery	+= "  AND CZK.CZK_RGCZJ = CZJ.R_E_C_N_O_ " +CRLF
	cQuery	+= "  AND CZK.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= "  WHERE CZJ.CZJ_FILIAL = '"+xFilial("CZJ")+"' "+CRLF 
	cQuery	+= "  AND CZJ.D_E_L_E_T_ = ' ' " +CRLF
	cQuery	+= "  GROUP BY CZJ_PROD, B1_COD, B1_DESC "+CRLF
	cQuery	+= "  ) DADOS "+CRLF
	cQuery	+= "  GROUP BY CZJ_PROD, B1_COD, B1_DESC "+CRLF
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
	Local nRet	:= 0

	Default cCodProd := ""

	DbSelectArea("SB1")
	DbSetOrder(1)
	If SB1->(DbSeek(xFilial("SB1") + cCodProd))

		//Retorna o forecast do produto 
		//Parametro nOpc:
		//0=Crias as tabelas temporarias do Forecast
		//1=Retorna o forecast aglutinado para o produto informado
		//2=Fecha as tabelas temporarias do forecast
		nRet := U_PZCVP007(1, SB1->B1_COD, SB1->B1_TIPO, 1)

	EndIf

	RestArea(aArea)
Return nRet


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
	cRet += "		QUANTIDADE DISPONIVEL = Volume em kg jแ descontando OP's abertas e/ou lotes comprometidos<br></br> "
	cRet += "		QUANTIDADE EM QUARENTENA = Armaz้ns 98<br></br> "
	cRet += "		NECESSIDADE = Soma da necessidade com base nos pedidos cadastrados para os pr๓ximos 30 dias<br></br> "
	cRet += "		FORECAST = Volume do m๊s vigente<br></br> "
	cRet += "		MษDIA CONSUMO = Base relat๓rio 'Consumo m๊s a m๊s', m้dia dos ๚ltimos 3 meses<br></br> "
	cRet += "		ENTRADA PREVISTA = Volume de entrada prevista no m๊s<br></br> "
	cRet += "		DIFERENวA = QUANTIDADE DISPONIVEL – NECESSIDADE<br></br> "
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
	Local cIndex1	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nX		:= 0

	aAdd (aCmp, {"TMP_CODIGO"	,"C", TAMSX3("B1_COD")[1]		,	0})
	aAdd (aCmp, {"TMP_DESC"		,"C", TAMSX3("B1_DESC")[1]		,	0})
	aAdd (aCmp, {"TMP_TIPO"		,"C", TAMSX3("B1_TIPO")[1]		,	0})
	aAdd (aCmp, {"TMP_QTDDIS"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_QTDQUA"	,"N", TAMSX3("B2_QATU")[1]		,	TAMSX3("B2_QATU")[2]})
	aAdd (aCmp, {"TMP_ESTSEG"	,"N", TAMSX3("B1_ESTSEG")[1]	,	TAMSX3("B1_ESTSEG")[2]})
	aAdd (aCmp, {"TMP_NECES"	,"N", TAMSX3("CZK_QTSEST")[1]	,	TAMSX3("CZK_QTSEST")[2]})
	aAdd (aCmp, {"TMP_FORECA"	,"N", TAMSX3("C4_QUANT")[1]		,	TAMSX3("C4_QUANT")[2]})
	aAdd (aCmp, {"TMP_MEDCON"	,"N", 10						,	2})
	aAdd (aCmp, {"TMP_ENTPRE"	,"N", TAMSX3("CZK_QTENTR")[1]	,	TAMSX3("CZK_QTENTR")[2]})
	aAdd (aCmp, {"TMP_DIF"		,"N", TAMSX3("CZK_QTSEST")[1]	,	TAMSX3("CZK_QTSEST")[2]})

	For nX := 1 To Len(aCodPer)
		aAdd (aCmp, {"TMP_P"+Alltrim(aCodPer[nX])		,"N", TAMSX3("B2_QATU")[1]	,	TAMSX3("B2_QATU")[2]})
	Next

	cArq	:=	CriaTrab(aCmp)
	DbUseArea (.T., __LocalDriver, cArq, cArqTmp)

	cIndex1 := CriaTrab(,.F.)
	IndRegua(cArqTmp, cIndex1, "TMP_TIPO+TMP_CODIGO")

	dbClearIndex()
	dbSetIndex(cIndex1+OrdBagExt())

	RestArea(aArea)

Return cArqTmp




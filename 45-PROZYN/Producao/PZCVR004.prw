#include 'protheus.ch'

#DEFINE DIRETORIO 	1
#DEFINE PRODUTODE 	2
#DEFINE PRODUTOATE 	3
#DEFINE LOTEDE 		4
#DEFINE LOTEATE		5
#DEFINE VALIDDE		6
#DEFINE VALIDATE	7
#DEFINE TIPODE		8
#DEFINE TIPOATE		9


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVRJ04		บAutor  ณMicrosiga	     บ Data ณ  04/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJob para envio do relatorio de produtos a vencer			  บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PZCVRJ04(aDados)

Local nDiasVencer 	:= 0
Local cMailDest		:= ""
Local cArq 			:= ""
Local cAssunto		:= "Relat๓rio produtos a vencer"
Local cMensagem		:= "Mensagem automแtica, favor nใo responder."
Local cEmailCc		:= ""
Local cAnexos		:= ""
Local cMsgErr		:= ""
Local cTpProd		:= ""
Local aTpProd		:= {}
Local aArqAux		:= {}
Local nX			:= 0
Local aAnexos		:= {}

Default aDados := {"01","01"}

	RpcClearEnv()
	RpcSetType(3)

	If !RpcSetEnv(aDados[1],aDados[2])
		Conout("Erro ao abrir empresa e filial: "+cEmpAux+"/"+cFilAux) 
		Return
	Else
		//Diretorio temporario, para grava็ใo do arquivo
		cDir		:= "\_Relatorios\"
		
		//Quantidade de dias a ser considerado para o vencimento
		nDiasVencer := U_MyNewSX6("CV_NDIAPVC", "90"	,"N","Quantidade de dias para os produtos a vencer", "", "", .F. )
		dDtAte		:= MsDate()+nDiasVencer
		
		//Tipos de produtos a serem considerados no relatorio
		//Obs. Os arquivos serใo quebrados pelos tipos de produtos informados no parametro
		cTpProd		:= U_MyNewSX6("CV_TPPRDVC", "PA|MP","C","Tipos de produtos a ser considerado no relatorio", "", "", .F. )
		aTpProd		:= Separa(cTpProd,"|")
		
		//Dados para envio do e-mail
		cMailDest	:= U_MyNewSX6("CV_MAILPRV", ""		,"C","E-mail dos destinatแrios que receberใo o relat๓rio de produtos a vencer", "", "", .F. )
		cMsgErr		:= ""

		For nX := 1 To Len(aTpProd)//Gera o relatorio (Arquivo) para cada tipo de produto
			
			//Nome do arquivo
			cArq := ""
			cArq := Alltrim(aTpProd[nX])+"_relProdutosAVencer_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls"
			
			//Diretorio e nome do arquivo a ser utilizado no anexo do e-mail
			cAnexos += cDir+cArq+";" 
			
			//Gera o relatorio para ser enviado por e-mail
			GerRel(Alltrim(cDir),;		//Diretorio 
					cArq,; 				//Nome do Arquivo
					"",; 				//Produto de
					"zzzzzzzzzzzzzzz",; //Produto at้
					"",; 				//Lote de 
					"zz",; 				//Lote at้
					MsDate(),; 			//Validade de 
					dDtAte,;			//Validade at้
					Alltrim(aTpProd[nX]),;//Tipo de 
					Alltrim(aTpProd[nX]),;//Tipo At้
					.T.)				//Informar para a rotina que esta sendo processado em job		
			
			//Verifica se o arquivo foi gerado corretamente
			If File(cDir+cArq)
				aAdd(aArqAux,cDir+cArq)
			EndiF
			
		Next

	
		//Verifica se o arquivo foi gerado, para o mesmo ser enviado por e-mail
		If Len(aArqAux) > 0
			//Envio do e-mail
			EnvMail(cMailDest,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)
			
			For nX := 1 To Len(aArqAux)
				//Exclui o arquivo ap๓s o envio
				FERASE(aArqAux[nX])
			Next
		EndIf
		
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPZCVR004		บAutor  ณMicrosiga	     บ Data ณ  04/07/2019 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio produtos a vencer							      บฑฑ
ฑฑบ          ณ                											  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Ap		                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User function PZCVR004()

	Local cArq 		:= "relProdutosAVencer_"+DtoS(Date())+STRTRAN(Time(), ":", "")+".xls" 
	Local aParam	:= {}

	If PergRel(@aParam)
		GerRel(Alltrim(aParam[DIRETORIO]),;		//Diretorio 
				cArq,; 							//Nome do Arquivo
				Alltrim(aParam[PRODUTODE]),; 	//Produto de
				Alltrim(aParam[PRODUTOATE]),; 	//Produto at้
				Alltrim(aParam[LOTEDE]),; 		//Lote de 
				Alltrim(aParam[LOTEATE]),; 		//Lote at้
				aParam[VALIDDE],; 				//Validade de 
				aParam[VALIDATE],;				//Validade at้
				aParam[TIPODE],;				//Tipo de 
				aParam[TIPOATE],;				//Tipo Ate
				.F.)							//Informar para a rotina que esta sendo processado em job				
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
Static Function GerRel(cDir, cArq, cProdDe, cProdAte, cLoteDe, cLoteAte, dDtValidDe, dDtValidAte, cTipoDe, cTipoAte,lJob)

	Local aArea		:= GetArea()
	Local cArqTmp 	:= ""
	Local nCnt		:= 0

	Default cDir		:= "" 
	Default cArq		:= "" 
	Default cProdDe		:= "" 
	Default cProdAte	:= "" 
	Default cLoteDe		:= "" 
	Default cLoteAte	:= "" 
	Default dDtValidDe	:= CTOD('') 
	Default dDtValidAte	:= CTOD('')
	Default cTipoDe		:= "" 
	Default cTipoAte	:= ""
	Default lJob		:= .F.


	//Dados do relatorio
	cArqTmp := GetArqTmp(cProdDe, cProdAte, cLoteDe, cLoteAte, dDtValidDe, dDtValidAte, cTipoDe, cTipoAte)
	
	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqTmp)->( DbGoTop() )

	//Cabe็alho do relatorio
	CabBook(cDir+cArq, nCnt)

	//Impressใo dos itens do relatorio
	Processa( {|| PrintSheet(cDir+cArq, nCnt, cArqTmp) },"Aguarde...","" )

	//Fecha as tags do relatorio
	CloseBook(cDir+cArq)

	If !lJob
		//Abre o excel
		MsgRun( "Aguarde...",, { || OpenExcel(cDir+cArq) } )
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
	cDadosArq   += '  <Author>elton_csantana</Author>' +CRLF
	cDadosArq   += '  <LastAuthor>elton_csantana</LastAuthor>' +CRLF
	cDadosArq   += '  <Created>2019-08-01T17:43:27Z</Created>' +CRLF
	cDadosArq   += '  <LastSaved>2019-08-01T17:55:03Z</LastSaved>' +CRLF
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
	cDadosArq   += '  <Style ss:ID="s68">' +CRLF
	cDadosArq   += '   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000"' +CRLF
	cDadosArq   += '    ss:Bold="1"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#C5D9F1" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s69">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s70">' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="Short Date"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s95">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '   <NumberFormat ss:Format="@"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += '  <Style ss:ID="s96">' +CRLF
	cDadosArq   += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#FFFFFF"/>' +CRLF
	cDadosArq   += '   <Interior ss:Color="#366092" ss:Pattern="Solid"/>' +CRLF
	cDadosArq   += '  </Style>' +CRLF
	cDadosArq   += ' </Styles>' +CRLF
	cDadosArq   += ' <Worksheet ss:Name="Plan1">' +CRLF
	cDadosArq   += '  <Table ss:ExpandedColumnCount="10" ss:ExpandedRowCount="'+Alltrim(Str(nCnt+10))+'" x:FullColumns="1"' +CRLF
	cDadosArq   += '   x:FullRows="1" ss:DefaultRowHeight="15">' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s69" ss:Width="67.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s69" ss:AutoFitWidth="0" ss:Width="234.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s69" ss:Width="51"/>' +CRLF	
	cDadosArq   += '   <Column ss:StyleID="s69" ss:Width="51"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s69" ss:AutoFitWidth="0" ss:Width="234.75"/>' +CRLF	
	cDadosArq   += '   <Column ss:Width="52.5"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s69" ss:AutoFitWidth="0" ss:Width="92.25"/>' +CRLF
	cDadosArq   += '   <Column ss:AutoFitWidth="0" ss:Width="82.5"/>' +CRLF
	cDadosArq   += '   <Column ss:Width="75.5"/>' +CRLF
	cDadosArq   += '   <Column ss:AutoFitWidth="0" ss:Width="78.75"/>' +CRLF
	cDadosArq   += '   <Row ss:Height="18.75">' +CRLF
	cDadosArq   += '    <Cell ss:MergeAcross="9" ss:StyleID="s68"><Data ss:Type="String">Produtos a Vencer - Emissรฃo: '+DTOC(MsDate())+'</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF
	cDadosArq   += '   <Row>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s95"><Data ss:Type="String">Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s95"><Data ss:Type="String">Descriรงรฃo</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s95"><Data ss:Type="String">Tipo</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s95"><Data ss:Type="String">Armazรฉm</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s95"><Data ss:Type="String">Descriรงรฃo Armazรฉm</Data></Cell>' +CRLF	
	cDadosArq   += '    <Cell ss:StyleID="s96"><Data ss:Type="String">Saldo</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s95"><Data ss:Type="String">Lote</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s96"><Data ss:Type="String">Dt.Validade</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s96"><Data ss:Type="String">Lote Bloqueado</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s96"><Data ss:Type="String">Empenho</Data></Cell>' +CRLF
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

	Default nCnt := 0

	ProcRegua(nCnt)

	While (cArqTmp)->(!Eof())

		IncProc("Processando...")

		cDadosArq   += '   <Row>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->B8_PRODUTO)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->B1_DESC)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->B1_TIPO)+'</Data></Cell>' +CRLF		
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->B8_LOCAL)+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->NNR_DESCRI)+'</Data></Cell>' +CRLF		
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(STR((cArqTmp)->B8_SALDO))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="String">'+Alltrim((cArqTmp)->B8_LOTECTL)+'</Data></Cell>' +CRLF
		
		If !Empty((cArqTmp)->B8_DTVALID)
			cDadosArq   += '    <Cell ss:StyleID="s70"><Data ss:Type="DateTime">'+GetDtConv(STOD((cArqTmp)->B8_DTVALID))+'T00:00:00.000</Data></Cell>' +CRLF
		Else
			cDadosArq   += '    <Cell ss:StyleID="s70">'
		EndIf
		
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(STR((cArqTmp)->B8_YQBLQLT))+'</Data></Cell>' +CRLF
		cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(STR((cArqTmp)->B8_EMPENHO))+'</Data></Cell>' +CRLF
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
	cDadosArq   += '     <ActiveRow>2</ActiveRow>' +CRLF
	cDadosArq   += '     <ActiveCol>4</ActiveCol>' +CRLF
	cDadosArq   += '    </Pane>' +CRLF
	cDadosArq   += '   </Panes>' +CRLF
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
Static Function GetArqTmp(cProdDe, cProdAte, cLoteDe, cLoteAte, dDtValidDe, dDtValidAte, cTipoDe, cTipoAte)

	Local aArea 		:= GetArea()
	Local cQuery		:= ""
	Local cArqTmp		:= GetNextAlias()
	Local cArmzNCons	:= U_MyNewSX6("CV_NAOCARM", ""	,"C","Armazens nใo considerados no relat๓rio", "", "", .F. )

	Default cProdDe		:= "" 
	Default cProdAte	:= "" 
	Default cLoteDe		:= "" 
	Default cLoteAte	:= "" 
	Default dDtValidDe	:= CTOD('') 
	Default dDtValidAte	:= CTOD('')
	Default cTipoDe		:= "" 
	Default cTipoAte	:= ""

	cQuery	:= " SELECT B8_PRODUTO, B1_DESC, B1_TIPO, B8_LOCAL, B8_SALDO, B8_LOTECTL, B8_DTVALID, "+CRLF
	cQuery	+= " B8_YQBLQLT, B8_EMPENHO, NNR_DESCRI FROM "+RetSqlName("SB8")+" SB8 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SB8.B8_PRODUTO "+CRLF

	If IsBlind() .And. (Alltrim(cTipoDe) == "MP" .Or. Alltrim(cTipoDe) == "ME") 
		cQuery	+= " AND SB1.B1_TIPO IN('MP','ME') "
	Else 
		cQuery	+= " AND SB1.B1_TIPO BETWEEN '"+cTipoDe+"' AND '"+cTipoAte+"' "+CRLF
	EndIf	
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("NNR")+" NNR "+CRLF
	cQuery	+= " ON NNR.NNR_FILIAL = '"+xFilial("NNR")+"' "+CRLF
	cQuery	+= " AND NNR.NNR_CODIGO = SB8.B8_LOCAL "+CRLF
	cQuery	+= " AND NNR.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SB8.B8_FILIAL = '"+xFilial("SB8")+"' "+CRLF
	cQuery	+= " AND SB8.B8_PRODUTO BETWEEN '"+cProdDe+"' AND '"+cProdAte+"' "+CRLF	
	cQuery	+= " AND SB8.B8_LOCAL NOT IN"+FormatIn(Alltrim(cArmzNCons),"|")+CRLF
	cQuery	+= " AND SB8.B8_LOTECTL BETWEEN '"+cLoteDe+"' AND '"+cLoteAte+"' "+CRLF
	cQuery	+= " AND SB8.B8_DTVALID BETWEEN '"+DTOS(dDtValidDe)+"' AND '"+DTOS(dDtValidAte)+"' "+CRLF
	cQuery	+= " AND SB8.B8_SALDO > 0 "+CRLF
	cQuery	+= " AND SB8.D_E_L_E_T_ = ' ' "+CRLF

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
	Local cLoadArq		:= "pzcv004"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt)		

	AADD(aParamBox,{6,"Endere็o destino do arquivo","","","ExistDir(&(ReadVar()))","",080,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY})
	AADD(aParamBox,{1,"Produto de"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.F.})
	AADD(aParamBox,{1,"Produto ate"			,Space(TAMSX3("B1_COD")[1])		,""	,"","SB1","",50,.T.})
	AADD(aParamBox,{1,"Lote de"				,Space(TAMSX3("B8_LOTECTL")[1])	,""	,"","","",50,.F.})
	AADD(aParamBox,{1,"Lote ate"			,Space(TAMSX3("B8_LOTECTL")[1])	,""	,"","","",50,.T.})
	AADD(aParamBox,{1,"Validade de"			,CTOD('')						,"@D"	,"","","",50,.F.})
	AADD(aParamBox,{1,"Validade ate"		,CTOD('')						,"@D"	,"","","",50,.T.})
	AADD(aParamBox,{1,"Tipo Prod. de"		,Space(TAMSX3("B1_TIPO")[1])	,""	,"","02","",50,.F.})
	AADD(aParamBox,{1,"Tipo Prod. ate"		,Space(TAMSX3("B1_TIPO")[1])	,""	,"","02","",50,.T.})



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

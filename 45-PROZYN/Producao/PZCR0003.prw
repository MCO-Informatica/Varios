#include 'protheus.ch'

#DEFINE DATADE 		1 
#DEFINE DATAATE		2
#DEFINE PEDIDODE	3
#DEFINE PEDIDOATE	4 
#DEFINE ENDARQ		5

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCR0003		�Autor  �Microsiga	     � Data �  10/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio Pedido x Forecast					 			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCR0003()

	Local aArea		:= GetArea()
	Local aParams	:= {}
	Local cArq		:= ""

	If PergRel(@aParams)
		Processa( {|| cArq := ProcRel(aParams[DATADE],; 
		aParams[DATAATE],;
		aParams[PEDIDODE],; 
		aParams[PEDIDOATE],; 
		Alltrim(aParams[ENDARQ])) },"Aguarde...","" )

		//Abre o Excel
		OpenExcel(cArq)
	EndIf	
	RestArea(aArea)	
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PZCRJ003		�Autor  �Microsiga	     � Data �  10/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Job Relatorio Pedido x Forcast				 			  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User function PZCRJ003(aDados)

	Local cDirRel	:= ""
	Local cArq		:= ""
	Local cEmailTo 	:= ""
	Local cAssunto	:= ""
	Local cMensagem	:= ""
	Local cEmailCc	:= ""
	Local cAnexo	:= ""
	Local cMsgErr	:= ""

	Default aDados := {"01","01"}

	RpcClearEnv()
	RpcSetType(3)

	If !RpcSetEnv(aDados[1],aDados[2])
		Conout("Erro ao abrir empresa e filial: "+aDados[1]+"/"+aDados[2]) 
		Return
	Else
		cDirRel	:= U_MyNewSX6("CV_DIRREL", "\_Relatorios\",;
		"C","Diretorio para grava��o de arquivo de relatorio.", "", "", .F. )

		Processa( {|| cArq := ProcRel(MsDate(),; 
		MsDate(),;
		"",; 
		"zzzzzz",; 
		Alltrim(cDirRel)) },"Aguarde...","" )

		//Atualiza��o das variaveis de e-mail
		cEmailTo 	:= U_MyNewSX6("CV_MAILPVF", "",;
		"C","", "", "", .F. )
		cAssunto	:= "Pedido sem forecast"
		cMensagem	:= "Mensagem autom�tica, favor n�o responder"
		cEmailCc	:= ""
		cAnexo		:= cArq
		cMsgErr		:= ""

		If !Empty(cArq)
			//Envia por e-mail o arquivo
			EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexo, @cMsgErr)

			//Exclui os arquivo do diretorio temporario
			FERASE(cArq)

		EndIf
	EndIf

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �ProcRel		�Autor  �Microsiga	     � Data �  10/07/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento do Relatorio Pedido x Forcast				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcRel(dDtDe, dDtAte, cPediDe, cPediAte, cEndArq)

	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()	
	Local nCnt		:= 0
	Local cNomeArq	:= "PedidoForecast_"+ DtoS(MsDate())+STRTRAN(Time(), ":", "")+".xls"
	Local cPathArq	:= ""
	Local nResult	:= 0
	Local nCarteira	:= 0

	Default dDtDe		:= CTOD('') 
	Default dDtAte		:= CTOD('') 
	Default cEndArq		:= ""
	Default cPediDe		:= "" 
	Default cPediAte	:= ""

	//Endere�o de grava��o do arquivo
	cPathArq := cEndArq+cNomeArq

	cQuery	:= " SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI,SC5.C5_FECENT, SC5.C5_EMISSAO," +CRLF
	cQuery	+= "		SUM(SC6.C6_QTDVEN) C6_QTDVEN, SUM(SC6.C6_VALOR) C6_VALOR, "+CRLF 
	cQuery	+= "		B1_COD, B1_DESC, "+CRLF
	cQuery	+= "		SUM(D2_QUANT) D2_QUANT, D2_EMISSAO, "+CRLF
	cQuery	+= "		A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, "+CRLF
	cQuery	+= "		SUM(Z2_QTM01) Z2_QTM01, SUM(Z2_QTM02) Z2_QTM02, SUM(Z2_QTM03) Z2_QTM03, SUM(Z2_QTM04) Z2_QTM04, "+CRLF 
	cQuery	+= "		SUM(Z2_QTM05) Z2_QTM05, SUM(Z2_QTM06) Z2_QTM06, SUM(Z2_QTM07) Z2_QTM07, SUM(Z2_QTM08) Z2_QTM08, "+CRLF
	cQuery	+= "		SUM(Z2_QTM09) Z2_QTM09, SUM(Z2_QTM10) Z2_QTM10, SUM(Z2_QTM11) Z2_QTM11, SUM(Z2_QTM12) Z2_QTM12 "+CRLF
	cQuery	+= "		 FROM "+RetSqlName("SC5")+" SC5 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SC6")+" SC6 "+CRLF
	cQuery	+= " ON SC6.C6_FILIAL = SC5.C5_FILIAL "+CRLF
	cQuery	+= " AND SC6.C6_NUM = SC5.C5_NUM "+CRLF
	cQuery	+= " AND SC6.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SB1")+" SB1 "+CRLF
	cQuery	+= " ON SB1.B1_FILIAL = '"+xFilial("SB1")+"' "+CRLF
	cQuery	+= " AND SB1.B1_COD = SC6.C6_PRODUTO "+CRLF
	cQuery	+= " AND SB1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SA1")+" SA1 "+CRLF
	cQuery	+= " ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' "+CRLF
	cQuery	+= " AND SA1.A1_COD = SC5.C5_CLIENTE "+CRLF
	cQuery	+= " AND SA1.A1_LOJA = SC5.C5_LOJACLI "+CRLF
	cQuery	+= " AND SA1.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SZ2")+" SZ2 "+CRLF
	cQuery	+= " ON SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' "+CRLF
	cQuery	+= " AND SZ2.Z2_CLIENTE = SC5.C5_CLIENTE "+CRLF
	cQuery	+= " AND SZ2.Z2_LOJA = SC5.C5_LOJACLI "+CRLF
	cQuery	+= " AND SZ2.Z2_PRODUTO = SC6.C6_PRODUTO "+CRLF
	cQuery	+= " AND SZ2.Z2_ANO = SubString(SC5.C5_FECENT,1,4) "+CRLF
	cQuery	+= " AND SZ2.Z2_TOPICO = 'F' "+CRLF
	cQuery	+= " AND SZ2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " LEFT JOIN "+RetSqlName("SD2")+" SD2 "+CRLF
	cQuery	+= " ON SD2.D2_FILIAL = SC6.C6_FILIAL "+CRLF
	cQuery	+= " AND SD2.D2_PEDIDO = SC6.C6_NUM "+CRLF
	cQuery	+= " AND SD2.D2_ITEMPV = SC6.C6_ITEM "+CRLF
	cQuery	+= " AND SD2.D2_COD = SC6.C6_PRODUTO " +CRLF
	cQuery	+= " AND SD2.D2_EMISSAO BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "+CRLF
	cQuery	+= " AND SD2.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF
	cQuery	+= " AND SC5.C5_NUM BETWEEN '"+cPediDe+"' AND '"+cPediAte+"' "+CRLF
	cQuery	+= " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "+CRLF 
	cQuery	+= " AND SC5.D_E_L_E_T_ = ' ' "+CRLF

	cQuery	+= " GROUP BY SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_EMISSAO, 
	cQuery	+= " SC5.C5_FECENT, B1_COD, B1_DESC, D2_EMISSAO, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ "+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)

	(cArqTmp)->( DbGoTop() )
	(cArqTmp)->( dbEval( {|| nCnt++ },,{ || !Eof() } ) )
	(cArqTmp)->( DbGoTop() )

	ProcRegua(nCnt)

	//Cabe�alho do relatorio
	CabBook(cPathArq, nCnt+5)

	While (cArqTmp)->(!Eof())

		IncProc("Processando...")
		nCarteira	:= 0
		nCarteira 	:= GetQtdCart((cArqTmp)->C5_NUM, dDtDe, dDtAte, (cArqTmp)->B1_COD, (cArqTmp)->C5_CLIENTE, (cArqTmp)->C5_LOJACLI)
		nResult 	:= 0
		nResult 	:= (cArqTmp)->&("Z2_QTM"+SubStr((cArqTmp)->C5_FECENT,5,2)) - ((cArqTmp)->C6_QTDVEN + (cArqTmp)->D2_QUANT + nCarteira) 

		If nResult != 0
			//Itens do relatorio
			PrintLine(cPathArq,;
			STOD((cArqTmp)->C5_EMISSAO),;
			(cArqTmp)->C5_NUM,; 
			STOD((cArqTmp)->C5_FECENT),; 
			(cArqTmp)->A1_COD,; 
			(cArqTmp)->A1_NREDUZ,; 
			(cArqTmp)->B1_COD,; 
			(cArqTmp)->B1_DESC,; 
			(cArqTmp)->C6_QTDVEN,;
			nCarteira,; 
			(cArqTmp)->D2_QUANT,; 
			(cArqTmp)->&("Z2_QTM"+SubStr((cArqTmp)->C5_FECENT,5,2)),; 
			nResult)
		EndIf
		(cArqTmp)->(DbSkip())
	EndDo

	//Fecha as tas do relatorio
	CloseBook(cPathArq)

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return cPathArq



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CabBook	  �Autor  �Microsiga         � Data �  19/12/18   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cabe�alho do arquivo			                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	cDadosArq   += '  <Style ss:ID="s16" ss:Name="Vírgula">' +CRLF
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
	cDadosArq   += '  <Table ss:ExpandedColumnCount="12" ss:ExpandedRowCount="'+Alltrim(Str(nCont))+'" x:FullColumns="1"' +CRLF
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
	cDadosArq   += '   <Column ss:StyleID="s76" ss:Width="55.75"/>' +CRLF
	cDadosArq   += '   <Column ss:StyleID="s76" ss:Width="190.75"/>' +CRLF
	cDadosArq   += '   <Row>' +CRLF
	cDadosArq   += '    <Cell ss:MergeAcross="11" ss:StyleID="s88"><Data ss:Type="String">ANALISE DE FORECAST</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF
	cDadosArq   += '   <Row>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Data de Emissão</Data></Cell>' +CRLF 
	cDadosArq   += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Nº Pedido </Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s68"><Data ss:Type="String">Data de Faturamento</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod Cliente</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Nome Cliente</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Cod Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s73"><Data ss:Type="String">Descr Produto</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Qtd.Pedido</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Qtd.Carteira</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Faturado</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s75"><Data ss:Type="String">Forecast</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell ss:StyleID="s77"><Data ss:Type="String">Forecast-(Realizado + Carteira + Pedido)</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PrintLine	  �Autor  �Microsiga         � Data �  10/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Linha do arquivo				                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PrintLine(cArq, dDtPrev, cPedido, dDtFat, cCodCli, cNomCli, cCodPro, cDescPro, nQtdPed, nCarteira,nQtdFat, nForcast, nResult)

	Local cDadosArq	:= ""

	Default dDtPrev		:= CTOD('')
	Default cPedido		:= ""
	Default dDtFat		:= CTOD('')
	Default cCodCli		:= ""
	Default cNomCli		:= ""
	Default cCodPro		:= ""
	Default cDescPro	:= ""
	Default nQtdPed 	:= 0
	Default nCarteira	:= 0
	Default nQtdFat		:= 0
	Default nForcast	:= 0
	Default nResult 	:= 0

	cDadosArq   := '   <Row>' +CRLF
	If !Empty(dDtPrev)	
		cDadosArq   += '    <Cell ss:StyleID="s62"><Data ss:Type="DateTime">'+GetDtConv(dDtPrev)+'T00:00:00.000</Data></Cell>' +CRLF
	Else
		cDadosArq   += '    <Cell ss:StyleID="s62"/>' +CRLF
	EndIf

	cDadosArq   += '    <Cell><Data ss:Type="String">'+cPedido+'</Data></Cell>' +CRLF

	If !Empty(dDtFat)	
		cDadosArq   += '    <Cell ss:StyleID="s62"><Data ss:Type="DateTime">'+GetDtConv(dDtFat)+'T00:00:00.000</Data></Cell>' +CRLF
	Else
		cDadosArq   += '    <Cell ss:StyleID="s62"/>' +CRLF
	EndIf

	cDadosArq   += '    <Cell><Data ss:Type="String">'+cCodCli+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cNomCli+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cCodPro+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="String">'+cDescPro+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nQtdPed))+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nCarteira))+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nQtdFat))+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nForcast))+'</Data></Cell>' +CRLF
	cDadosArq   += '    <Cell><Data ss:Type="Number">'+Alltrim(Str(nResult))+'</Data></Cell>' +CRLF
	cDadosArq   += '   </Row>' +CRLF

	GrvTxtArq( cArq, cDadosArq )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CloseBook	  �Autor  �Microsiga         � Data �  10/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fecha o arquivo				                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

Return






/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvTxtArq  �Autor  �Microsiga          � Data �  05/01/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava o texto no final do arquivo                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �PergRel	�Autor  �Microsiga		     � Data �  13/12/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Perguntas a serem utilizadas no filtro				      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ap		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PergRel(aParams)

	Local aParamBox := {}
	Local lRet      := .T.
	Local cLoadArq	:= "PZCVR003"+Alltrim(RetCodUsr())+Alltrim(cEmpAnt) 

	AADD(aParamBox,{1,"Data de"				,CTOD('')	,"@D"				,"","","",50,.T.})
	AADD(aParamBox,{1,"Data at�"			,CTOD('')	,"@D"				,"","","",50,.T.})
	AADD(aParamBox,{1,"Pedido de"			,Space(TAMSX3("C5_NUM")[1])		,""	,"","","",50,.F.})
	AADD(aParamBox,{1,"Pedido ate"			,Space(TAMSX3("C5_NUM")[1])		,""	,"","","",50,.T.})
	AADD(aParamBox,{6,"Endere�o do arquivo","","","ExistDir(&(ReadVar()))","",080,.T.,"","",GETF_LOCALHARD+GETF_NETWORKDRIVE + GETF_RETDIRECTORY})

	lRet := ParamBox(aParamBox, "Par�metros", aParams, , /*alButtons*/, .T., /*nlPosx*/, /*nlPosy*/,, cLoadArq, .t., .t.)

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OpenExcel  �Autor  �Microsiga	         � Data �  10/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Abre o arquivo do excel			                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                               	                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function OpenExcel(cArq)

	Local aArea 	:= GetArea()
	Local oExcelApp	:= Nil

	Default cArq 	:= ""

	If File(cArq)
		If !ApOleCliente( "MsExcel" )
			Aviso("Aten��o","Microsoft Excel n�o Instalado... Contate o Administrador do Sistema!",{"Ok"},2)
		Else
			oExcelApp:=MsExcel():New()
			oExcelApp:WorkBooks:Open( cArq )
			oExcelApp:SetVisible( .T. )
			oExcelApp:Destroy()
		EndIf
	Else
		Aviso("Aten��o","Arquivo n�o encontrado: "+CRLF+cArq,{"Ok"},2)
	EndIf

	RestArea(aArea)
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetDtConv	  �Autor  �Microsiga         � Data �  10/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a data convertida		                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnvMail  �Autor  �Microsiga	          � Data �  25/03/2017���
�������������������������������������������������������������������������͹��
���Desc.     �Envia e-mail                                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 	                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EnvMail(cEmailTo,cAssunto,cMensagem,cEmailCc, cAnexos, cMsgErr)

	Local aArea 		:= GetArea()
	Local cServer   	:= Alltrim(Separa(GetMV("MV_RELSERV",,""),":")[1])
	Local nPort			:= Val(Separa(GetMV("MV_RELSERV",,""),":")[2])
	Local cAccount		:= Alltrim(GetMV("MV_RELACNT",,""))
	Local cPwd			:= Alltrim(GetMV("MV_RELPSW",,""))
	Local lAutentic		:= GetNewPar("MV_RELAUTH",.F.)
	Local lSSL			:= .T.
	Local lTLS			:= .T.

	Local oServer       := Nil
	Local oMessage		:= Nil 
	Local aAnexos		:= Iif(!Empty(cAnexos), Separa(cAnexos,";"), "")
	Local nX			:= 1
	Local nErro			:= 0

	Default cMsgErr 	:= ""

	//Crio a conex�o com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()

	If lSSL
		oServer:SetUseSSL(lSSL)
	EndIf

	If lTLS
		oServer:SetUseTLS(lTLS)
	EndIf

	oServer:Init( "", cServer, cAccount,cPwd,0,nPort)

	//realizo a conex�o SMTP
	nErro := oServer:SmtpConnect() 
	If nErro != 0  
		cMsgErr := "Falha na conex�o SMTP. "
		Return .F.
	EndIf

	//seto um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		cMsgErr := "Falha ao setar o time out com o servidor. "
		Return .F.
	EndIf

	// Autentica��o
	If lAutentic
		If oServer:SMTPAuth ( cAccount,cPwd ) != 0
			cMsgErr := "Falha ao autenticar. "
			Return .F.
		EndIf
	EndIf

	//Apos a conex�o, crio o objeto da mensagem
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetQtdCart  �Autor  �Microsiga         � Data �  16/07/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Quantidade em Carteira		                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetQtdCart(cPedido, dDtDe, dDtAte, cProdut, cCodCli, cLojaCli)

	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cArqTmp	:= GetNextAlias()
	Local nRet		:= 0

	Default cPedido		:= "" 
	Default dDtDe		:= CTOD('') 
	Default dDtAte		:= CTOD('') 
	Default cProdut		:= ""
	Default cCodCli		:= "" 
	Default cLojaCli	:= ""

	cQuery	:= " SELECT SUM(C6_QTDVEN) C6_QTDVEN FROM "+RetSqlName("SC5")+" SC5 "+CRLF

	cQuery	+= " INNER JOIN "+RetSqlName("SC6")+" SC6 " +CRLF
	cQuery	+= " ON SC6.C6_FILIAL = SC5.C5_FILIAL " +CRLF
	cQuery	+= " AND SC6.C6_NUM = SC5.C5_NUM " +CRLF
	cQuery	+= " AND SC6.C6_PRODUTO = '"+cProdut+"' "+CRLF
	cQuery	+= " AND SC6.D_E_L_E_T_ = ' ' " +CRLF

	cQuery	+= " WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "+CRLF 
	cQuery	+= " AND SC5.C5_NUM < '"+cPedido+"' "+CRLF
	cQuery	+= " AND SC5.C5_CLIENTE = '"+cCodCli+"' "
	cQuery	+= " AND SC5.C5_LOJACLI = '"+cLojaCli+"' " 
	cQuery	+= " AND SC5.C5_TIPO = 'N' "+CRLF
	cQuery	+= " AND SC5.C5_NOTA = '' "+CRLF
	cQuery	+= " AND SC5.C5_EMISSAO BETWEEN '"+DTOS(dDtDe)+"' AND '"+DTOS(dDtAte)+"' "+CRLF 
	cQuery	+= " AND SC5.D_E_L_E_T_ = ' ' "+CRLF 
	
	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cArqTmp,.T.,.T.)
	
	If (cArqTmp)->(!Eof())
		nRet := (cArqTmp)->C6_QTDVEN
	Else
		nRet := 0
	EndIf

	If Select(cArqTmp) > 0 
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)
Return nRet
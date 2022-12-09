#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT100   บ Autor ณ TOTVS ABM          บ Data ณ 31/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Produtos com Filtros                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFAT100
	Local aData			:= {}
	Local aArea			:= GetArea()
	Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3		:= "Relat๓rio de Produtos com Filtros"
	Local cPict			:= ""
	Local titulo		:= "Relatorio de Produtos com Filtros"
	Local cQuery		:= ""
	Local cFile

	Local Cabec1		:= ""
	Local Cabec2		:= ""
	Local imprime		:= .T.
	Local aOrd			:= {"Por Descri็ใo","Por Num. de dias sem movimento"}
	Local cPerg			:= "RFAT100"
	Local cOrder		:= "" 
	Local dData			:= CtoD('')

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RFAT100" , __cUserID )

	Private lEnd		:= .F.
	Private lAbortPrint	:= .F.
	Private CbTxt		:= ""
	Private limite		:= 220
	Private tamanho		:= "G"
	Private nomeprog	:= "RFAT100" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo		:= 15
	Private aReturn		:= { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey	:= 0
	Private cbcont		:= 00
	Private CONTFL		:= 01
	Private m_pag		:= 01
	Private wnrel		:= "RFAT100" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias		:= "SB1" 

	SetPrvt("cbtxt")

	If !Pergunte(cPerg)
		Return
	EndIf

	If MV_PAR13 <> 1
		wnrel := SetPrint(cAlias,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.f.)
		If nLAstKey == 27
			Return
		Endif

		SetDefault(aReturn,cAlias)

		If nLastKey == 27
			Return()
		Endif
	Endif

	/*
	Parametros do Relatorio
	MV_PAR01 - Agrupamento						(1=Produtos, 2=Grupo Prods)
	MV_PAR02 - Produto De:						(B1_COD)
	MV_PAR03 - Produto Ate:						(B1_COD)
	MV_PAR04 - Grupo Prd. De:					(BM_GRUPO)
	MV_PAR05 - Grupo Prd. Ate:					(BM_GRUPO)
	MV_PAR06 - Segm Venda De:					(B1_SEGMENT) (ACY_GRPVEN)
	MV_PAR07 - Segm Venda Ate:					(B1_SEGMENT) (ACY_GRPVEN)
	MV_PAR08 - Grp Respon De:					(A1_GRPVEN) (ACY_GRPVEN)
	MV_PAR09 - Grp Respon Ate:					(A1_GRPVEN) (ACY_GRPVEN)
	MV_PAR10 - Periodo desde:					(DD/MM/AA)
	MV_PAR11 - Listar Inativos:					(1=Sim,2=Nao)
	MV_PAR12 - Somente com saldo em estoque:	(1=Sim,2=Nao)
	MV_PAR13 - Gerar planilha Excel:			(1=Sim,2=Nao)
	*/

	cAlias := "XSB1"

	cQuery += " SELECT" + CRLF
	cQuery += "   SBM.BM_GRUPO," + CRLF
	cQuery += "   SBM.BM_DESC," + CRLF
	cQuery += "   SB1.B1_COD," + CRLF
	cQuery += "   SB1.B1_DESC," + CRLF
	cQuery += "   SB1.B1_SEGMENT," + CRLF
	cQuery += "   SB2.B2_QATU," + CRLF
	cQuery += "   SB2.B2_QEMP," + CRLF
	cQuery += "   MAX(SD2.D2_EMISSAO) AS MAX_EMISSA" + CRLF
	cQuery += " FROM" + CRLF
	cQuery += "   " + RetSqlName("SB1") + " SB1" + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("SBM") + " SBM ON (SBM.BM_FILIAL = '" + xFilial("SBM") + "' AND SB1.B1_GRUPO = SBM.BM_GRUPO AND SBM.D_E_L_E_T_ = ' ')" + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("SD2") + " SD2 ON (SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND SD2.D2_COD = SB1.B1_COD AND SD2.D_E_L_E_T_ = ' ')" + CRLF
	cQuery += "   INNER JOIN " + RetSqlName("SA1") + " SA1 ON (SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND SA1.D_E_L_E_T_ = ' ')" + CRLF
	cQuery += "   LEFT  JOIN " + RetSqlName("SB2") + " SB2 ON (SB2.B2_FILIAL = '" + xFilial("SB2") + "' AND SB1.B1_COD = SB2.B2_COD AND SB2.D_E_L_E_T_ = ' ')" + CRLF
	cQuery += " WHERE" + CRLF
	cQuery += "   SB1.B1_FILIAL = '" + xFilial("SB1") + "'" + CRLF
	cQuery += "   AND SB1.B1_GRUPO BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR05 + "'" + CRLF
	cQuery += "   AND SB1.B1_COD BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "'" + CRLF
	cQuery += "   AND SUBSTR(SB1.B1_COD,1,2) IN ('MR','PA')" + CRLF
	cQuery += "   AND SB1.B1_DESC NOT LIKE '%AMOSTRA%'" + CRLF
	cQuery += "   AND SB1.B1_SEGMENT BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'" + CRLF
	If MV_PAR11 == 2
		cQuery += "   AND SB1.B1_MSBLQL != '1'" + CRLF
	EndIf
	cQuery += "   AND SB1.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "   AND SD2.D2_EMISSAO >= '" + DtoS(MV_PAR10) + "'" + CRLF
	cQuery += "   AND SD2.D2_TIPO = 'N'" + CRLF
	cQuery += "   AND SA1.A1_GRPVEN BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "'" + CRLF
	cQuery += " GROUP BY" + CRLF
	cQuery += "   SBM.BM_GRUPO," + CRLF
	cQuery += "   SBM.BM_DESC," + CRLF
	cQuery += "   SB1.B1_COD," + CRLF
	cQuery += "   SB1.B1_DESC," + CRLF
	cQuery += "   SB1.B1_SEGMENT," + CRLF
	cQuery += "   SB2.B2_QATU," + CRLF
	cQuery += "   SB2.B2_QEMP" + CRLF
	cQuery += " ORDER BY" + CRLF
	cQuery += "   SBM.BM_DESC," + CRLF
	cQuery += "   SB1.B1_DESC" + CRLF

	cQuery := ChangeQuery(cQuery)

	MsgRun("Selecionando registros, aguarde...","Relat๓rio Produtos com Filtro", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })    

	TCSetField( cAlias,"MAX_EMISSA","D",08,0 )

	Processa( {|| GetData(cAlias,@aData) },'Classificando Dados...')

	If Len(aData) > 0
		If MV_PAR13 == 2 

			If MV_PAR01 == 1		
				Cabec1 := "Cod. Produto     Descri็ใo                                 Segm. Respons                   Saldo Atual         Sld. Em Terceiros   Sld. Disponํvel     Sld. Ped. a Faturar  Dt. ฺltimo Pedido  No. Dias s/ Movimto"
			Else
				Cabec1 := "Cod. Grupo       Descri็ใo                                 Segm. Respons                   Saldo Atual         Sld. Em Terceiros   Sld. Disponํvel     Sld. Ped. a Faturar  Dt. ฺltimo Pedido  No. Dias s/ Movimto"
				//			          "xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999,999.99  999,999,999,999.99  999,999,999,999.99  999,999,999,999.99       99/99/99              99999"
				//			          "0.........0......7..0.........0.........0.........0........90.........0.........0.........01........0.........01........0.........01........0.........01........0.........0.....6...0.........0.......8.0........."
			EndIf

			Cabec2 := ""

			If nLastKey == 27
				Return
			Endif

			nTipo := If(aReturn[4]==1,15,18)

			RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,aData) },Titulo)

		Else 
			//EXPORTAR PARA EXCEL
			cFile := cGetFile ( 'Arquivo XLS (*.XLS)|*.XLS' , 'Selecione a pasta para grava็ใo', 1, '', .T., GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)

			Processa( {|| CliExcel(aData,cFile)},"Relat๓rio Produtos com Filtro" )
		Endif
	Else
		MsgAlert("Nใo hแ dados para os parโmetros informados.")
	EndIf

	RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  04/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,aData)

	Local nFor		:= 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Variaveis utilizadas para Impressao do Cabecalho e Rodape ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cbcont	:= 0
	m_pag	:= 1
	Li		:= 80
	nTipo	:= Iif(aReturn[4]==1,15,18)

	SetRegua(Len(aData))

	For nFor := 1 To Len(aData)
		If lAbortPrint
			@Li,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If Li > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		Endif 

		/*	
		Cabec1 := "Cod. Grupo       Descri็ใo                                 Segm. Respons                   Saldo Atual         Sld. Em Terceiros   Sld. Disponํvel     Sld. Ped. a Faturar  Dt. ฺltimo Pedido  No. Dias s/ Movimto"
		"xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  999,999,999,999.99  999,999,999,999.99  999,999,999,999.99  999,999,999,999.99       99/99/99              99999"
		"0.........0......7..0.........0.........0.........0........90.........0.........0.........01........0.........01........0.........01........0.........01........0.........0.....6...0.........0.......8.0........."
		*/

		@Li,000 PSAY PadR(AllTrim(aData[nFor][01]),15)
		@Li,017 PSAY PadR(AllTrim(aData[nFor][02]),40)
		@Li,059 PSAY PadR(AllTrim(aData[nFor][03]),30)
		@Li,091 PSAY PadL(AllTrim(aData[nFor][04]),18)
		@Li,111 PSAY PadL(AllTrim(aData[nFor][05]),18)
		@Li,131 PSAY PadL(AllTrim(aData[nFor][06]),18)
		@Li,151 PSAY PadL(AllTrim(aData[nFor][07]),18)
		@Li,176 PSAY PadR(AllTrim(aData[nFor][08]),08)
		@Li,198 PSAY PadL(AllTrim(aData[nFor][09]),05)

		Li++

	Next nFor

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		//dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetData  บAutor  ณTOTVS ABM           บ Data ณ 31/08/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o array contendo os dados completos do relatorio ja    บฑฑ
ฑฑบ          ณno formato especificado pelos parametros                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetData(cAlias,aData)
	Local aItem		:= {}
	Local aTmp1		:= {}
	Local aTmp2		:= {}
	Local aAux1		:= {}
	Local aAux2		:= {}
	Local cMsg		:= ""
	Local nFor		:= 0
	Local nPos		:= 0

	Local cCodGrp	:= ""
	Local cDesGrp	:= ""
	Local cCodPrd	:= ""
	Local cDesPrd	:= ""
	Local cSegPrd	:= ""
	Local nSldAtu	:= 0
	Local nSldEmp	:= 0
	Local dDtUPed	:= CtoD("  /  /  ")

	Local cDesSeg	:= ""
	Local nSldTer	:= 0
	Local nSldDis	:= 0
	Local nSldPed	:= 0
	Local nDtUPed	:= 0
	Local nTotSld	:= 0

	/*
	Layout aAux1 - Agrupamento por Produto
	aAux1[X][01] Cod. Produto
	aAux1[X][02] Descricao
	aAux1[X][03] Segm. Respons
	aAux1[X][04] Saldo Atual
	aAux1[X][05] Sld. Em Terceiros
	aAux1[X][06] Sld. Disponivel
	aAux1[X][07] Sld. Ped. a Faturar
	aAux1[X][08] Dt. Ultimo Pedido
	aAux1[X][09] No. Dias s/ Movimto
	aAux1[X][10] Cod. Grupo
	aAux1[X][11] Descricao Grupo

	Layout aAux2 - Agrupamento por Grupo de Produto
	aAux2[X][1] Cod. Grupo
	aAux2[X][2] Descricao
	aAux2[X][3] Segm. Respons
	aAux2[X][4] Saldo Atual
	aAux2[X][5] Sld. Em Terceiros
	aAux2[X][6] Sld. Disponivel
	aAux2[X][7] Sld. Ped. a Faturar
	aAux2[X][8] Dt. Ultimo Pedido
	aAux2[X][9] No. Dias s/ Movimto
	*/

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVarre o conteudo da query sumarizando os valores por produtoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ProcRegua(0)

	aData := {}

	While !(cAlias)->(Eof())

		If MV_PAR01 == 1
			cMsg := "Lendo produto: " + AllTrim((cAlias)->B1_COD) + "-" + AllTrim((cAlias)->B1_DESC)
		Else
			cMsg := "Lendo grupo: " + AllTrim((cAlias)->BM_GRUPO) + "-" + AllTrim((cAlias)->BM_DESC)
		EndIf
		IncProc(cMsg)

		nPos := aScan(aTmp1,{ |x| x[3] == (cAlias)->B1_COD } )
		If nPos == 0

			aItem := {}

			cCodGrp	:= (cAlias)->BM_GRUPO
			cDesGrp	:= (cAlias)->BM_DESC
			cCodPrd	:= (cAlias)->B1_COD
			cDesPrd	:= (cAlias)->B1_DESC
			cSegPrd	:= (cAlias)->B1_SEGMENT
			nSldAtu	:= (cAlias)->B2_QATU
			nSldEmp	:= (cAlias)->B2_QEMP
			dDtUPed	:= (cAlias)->MAX_EMISSA

			AAdd(aItem,cCodGrp)
			AAdd(aItem,cDesGrp)
			AAdd(aItem,cCodPrd)
			AAdd(aItem,cDesPrd)
			AAdd(aItem,cSegPrd)
			AAdd(aItem,nSldAtu)
			AAdd(aItem,nSldEmp)
			AAdd(aItem,dDtUPed)

			AAdd(aTmp1,aItem)
		Else

			aTmp1[nPos][01] := aTmp1[nPos][01]
			aTmp1[nPos][02] := aTmp1[nPos][02]
			aTmp1[nPos][03] := aTmp1[nPos][03]
			aTmp1[nPos][04] := aTmp1[nPos][04]
			aTmp1[nPos][05] := aTmp1[nPos][05]
			aTmp1[nPos][06] += (cAlias)->B2_QATU
			aTmp1[nPos][07] += (cAlias)->B2_QEMP
			aTmp1[nPos][08] := IIf(aTmp1[nPos][08] > (cAlias)->MAX_EMISSA, aTmp1[nPos][08], (cAlias)->MAX_EMISSA)

		EndIf
		(cAlias)->(DbSkip())
	EndDo

	(cAlias)->(DbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPreenche os valores das demais colunas no array aAux1ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	ACY->(DbSetOrder(1))

	ProcRegua(Len(aTmp1))

	For nFor := 1 To Len(aTmp1)

		IncProc("Complementando informa็๕es")

		nTotSld	:= 0

		cCodGrp := aTmp1[nFor][01]
		cDesGrp := aTmp1[nFor][02]
		cCodPrd := aTmp1[nFor][03]
		cDesPrd := aTmp1[nFor][04]
		cSegPrd := aTmp1[nFor][05]
		nSldAtu := aTmp1[nFor][06]
		nSldTer := QtdEmTerc(cCodPrd)
		nSldDis := QtdDisponivel(cCodPrd,nSldAtu,aTmp1[nFor][07])
		nSldPed := QtdEmPedidos(cCodPrd)
		dDtUPed := aTmp1[nFor][08]
		nDtUPed := dDataBase - dDtUPed

		nTotSld	:= nSldAtu + nSldTer + nSldDis + nSldPed

		If (MV_PAR12 == 1 .And. nTotSld != 0) .Or. MV_PAR12 == 2

			If ACY->(DbSeek(xFilial("ACY")+cSegPrd))	
				cDesSeg := ACY->ACY_DESCRI
			Else
				cDesSeg	:= ""
			EndIf

			aItem := {}

			AAdd(aItem,cCodPrd )
			AAdd(aItem,cDesPrd )
			AAdd(aItem,cDesSeg )
			AAdd(aItem,Transform(nSldAtu,'@E 999,999.9999') )
			AAdd(aItem,Transform(nSldTer,'@E 999,999.9999') )
			AAdd(aItem,Transform(nSldDis,'@E 999,999.9999') )
			AAdd(aItem,Transform(nSldPed,'@E 999,999.9999') )
			AAdd(aItem,DtoC(dDtUPed) )
			AAdd(aItem,AllTrim(Str(nDtUPed)) )

			AAdd(aAux1,aItem)

			aItem := {}

			AAdd(aItem,cCodPrd)
			AAdd(aItem,cDesPrd)
			AAdd(aItem,cDesSeg)
			AAdd(aItem,nSldAtu)
			AAdd(aItem,nSldTer)
			AAdd(aItem,nSldDis)
			AAdd(aItem,nSldPed)
			AAdd(aItem,dDtUPed)
			AAdd(aItem,nDtUPed)
			AAdd(aItem,cCodGrp)
			AAdd(aItem,cDesGrp)

			AAdd(aTmp2,aItem)

		EndIf

		If Len(aAux1) > 0
			aAux1 := aSort(aAux1,,,{|x,y| x[02] < y[02]})
			aTmp2 := aSort(aTmp2,,,{|x,y| x[10]+x[01] < y[10]+y[01]})
		EndIf

	Next nFor

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz os tratamentos no layout do relatorioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Len(aAux1) > 0
		//Agrupado por Produto
		If MV_PAR01 == 1
			If aReturn[8] == 1
				aAux1 := aSort( aAux1,,,{|x,y| x[2] < y[2] } )
			Else
				aAux1 := aSort( aAux1,,,{|x,y| Val(x[9]) > Val(y[9]) } )
			EndIf

			aData := aClone(aAux1)

			//Agrupado por Grupo
		Else

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณFaz a sumarizacao por grupo de produtoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			ProcRegua(Len(aTmp2))

			For nFor := 1 To Len(aTmp2)

				IncProc("Agrupando informa็๕es")

				nPos := aScan(aAux2,{ |x| x[1] == aTmp2[nFor][10] } )
				If nPos == 0
					cCodGrp := aTmp2[nFor][10]
					cDesGrp := aTmp2[nFor][11]
					cDesSeg := aTmp2[nFor][03]
					nSldAtu := aTmp2[nFor][04]
					nSldTer := aTmp2[nFor][05]
					nSldDis := aTmp2[nFor][06]
					nSldPed := aTmp2[nFor][07]
					dDtUPed := aTmp2[nFor][08]
					nDtUPed := aTmp2[nFor][09]

					aItem := {}

					AAdd(aItem,cCodGrp)
					AAdd(aItem,cDesGrp)
					AAdd(aItem,cDesSeg)
					AAdd(aItem,nSldAtu)
					AAdd(aItem,nSldTer)
					AAdd(aItem,nSldDis)
					AAdd(aItem,nSldPed)
					AAdd(aItem,dDtUPed)
					AAdd(aItem,nDtUPed)

					AAdd(aAux2,aItem)

				Else
					cCodGrp := aTmp2[nFor][10]
					cDesGrp := aTmp2[nFor][11]
					cDesSeg := aTmp2[nFor][03]
					nSldAtu := aTmp2[nFor][04] + aAux2[nPos][04]
					nSldTer := aTmp2[nFor][05] + aAux2[nPos][05]
					nSldDis := aTmp2[nFor][06] + aAux2[nPos][06]
					nSldPed := aTmp2[nFor][07] + aAux2[nPos][07]
					dDtUPed := IIf(aTmp2[nFor][08] > aAux2[nPos][08], aTmp2[nFor][08], aAux2[nPos][08])
					nDtUPed := dDataBase - dDtUPed

					aAux2[nPos][01] := cCodGrp
					aAux2[nPos][02] := cDesGrp
					aAux2[nPos][03] := cDesSeg
					aAux2[nPos][04] := nSldAtu
					aAux2[nPos][05] := nSldTer
					aAux2[nPos][06] := nSldDis
					aAux2[nPos][07] := nSldPed
					aAux2[nPos][08] := dDtUPed
					aAux2[nPos][09] := nDtUPed

				EndIf
			Next nFor

			For nFor := 1 To Len(aAux2)
				aAux2[nFor][01] := aAux2[nFor][01]
				aAux2[nFor][02] := aAux2[nFor][02]
				aAux2[nFor][03] := aAux2[nFor][03]
				aAux2[nFor][04] := Transform(aAux2[nFor][04],'@E 999,999.9999')
				aAux2[nFor][05] := Transform(aAux2[nFor][05],'@E 999,999.9999')
				aAux2[nFor][06] := Transform(aAux2[nFor][06],'@E 999,999.9999')
				aAux2[nFor][07] := Transform(aAux2[nFor][07],'@E 999,999.9999')
				aAux2[nFor][08] := DtoC(aAux2[nFor][08])
				aAux2[nFor][09] := StrZero(aAux2[nFor][09],3)
			Next aAux2

			If aReturn[8] == 1
				aAux2 := aSort( aAux2,,,{ |x,y| x[2] < y[2] } )
			Else
				aAux2 := aSort( aAux2,,,{ |x,y| Val(x[9]) > Val(y[9]) } )
			EndIf

			aData := aClone(aAux2)
		EndIf
	EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaExcelบAutor  ณTOTVS ABM           บ Data ณ  20/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o arquivo excel com todos os registros referente aos  บฑฑ
ฑฑบ          ณparametros digitados pelo usuario                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CliExcel(aData,cFile)

	Local aCabec	:= {}
	Local cArquivo	:= CriaTrab(,.F.)
	Local cBuffer 
	Local cDirDocs	:= MsDocPath()
	Local cPath		:= AllTrim(GetTempPath())
	Local cTitle1	:= ""
	Local cTitle2	:= ""
	Local nHandle	:= 0
	Local nx
	Local ny

	Default cFile	:= ""

	If !Empty(cFile)
		cPath := cFile
	EndIf

	cArquivo += ".CSV"

	nHandle := FCreate(cDirDocs + "\" + cArquivo)

	If nHandle < 0
		MsgStop("Erro na cria็ใo do arquivo de trabalho. Contate o administrador do sistema.")
		Return
	EndIf

	ProcRegua(Len(aData))

	cTitle1 := "Relat๓rio de saldos em estoque por produto/grupo de produtos"

	If MV_PAR01 == 1 

		cTitle2 := "Agrupamento por Produto"

		aAdd(Acabec,"Cod. Produto"			)
		aAdd(Acabec,"Descri็ใo"				)
		aAdd(Acabec,"Segm. Respons"			)
		aAdd(Acabec,"Saldo Atual"			)
		aAdd(Acabec,"Sld. Em Terceiros"		)
		aAdd(Acabec,"Sld. Disponํvel"		)
		aAdd(Acabec,"Sld. Ped. a Faturar"	)
		aAdd(Acabec,"Dt. ฺltimo Pedido"		)
		aAdd(Acabec,"No. Dias s/ Movimto"	)

	Else
		cTitle2 := "Agrupamento por Grupo de Produto"

		aAdd(Acabec,"Cod. Grupo"			)
		aAdd(Acabec,"Descri็ใo"				)
		aAdd(Acabec,"Segm. Respons"			)
		aAdd(Acabec,"Saldo Atual"			)
		aAdd(Acabec,"Sld. Em Terceiros"		)
		aAdd(Acabec,"Sld. Disponํvel"		)
		aAdd(Acabec,"Sld. Ped. a Faturar"	)
		aAdd(Acabec,"Dt. ฺltimo Pedido"		)
		aAdd(Acabec,"No. Dias s/ Movimto"	)
	Endif

	FWrite(nHandle, cTitle1 + CRLF)
	FWrite(nHandle, cTitle2 + CRLF)
	FWrite(nHandle, CRLF) 

	cBuffer := ""

	//imprime o cabecalho
	For nx := 1 To Len(aCabec)
		If nx == Len(aCabec)
			cBuffer += aCabec[nx]
		Else
			cBuffer += aCabec[nx] + ";"
		EndIf
	Next nx

	FWrite(nHandle, cBuffer + CRLF)

	For nx := 1 To Len(aData)
		IncProc("Gravando planilha...")

		cBuffer := ""

		For ny := 1 To Len(aData[nx])
			cBuffer += IIf(ny == 1, '="', "")
			cBuffer += aData[nx][ny]
			cBuffer += IIf(ny == 1, '"', "")
			cBuffer += IIf(ny < Len(aData[nx]), ";", "")
		Next ny

		FWrite(nHandle, cBuffer + CRLF)

	Next nx

	FClose(nHandle)

	// copia o arquivo do servidor para o remote
	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	If File(cPath+cArquivo)
		MsgInfo("Planilha gravada em: " + cPath+cArquivo)
	Else
		MsgStop("Erro na grava็ใo do arquivo na esta็ใo local.")
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cArquivo)
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQtdEmPedidบAutor  ณTOTVS ABM           บ Data ณ 02/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetornar a Quantidade Reservada em Pedidos                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdEmPedidos( cProduto, cLocal )
	Local aArea		:= GetArea()
	Local aAreaC5	:= SC5->( GetArea() )
	Local aAreaC6	:= SC6->( GetArea() )
	Local nRet		:= 0
	Local nQtd		:= 0

	Default cLocal	:= ""

	dbSelectArea( "SC5" )
	SC5->( dbSetOrder(1) )

	dbSelectArea( "SC6" )
	SC6->( dbSetOrder(2) )
	SC6->( dbSeek( xFilial("SC6") + cProduto ) )

	While !SC6->( Eof() ) .And. SC6->C6_FILIAL == xFilial( "SC6" ) .And. SC6->C6_PRODUTO == cProduto

		If SC6->C6_BLQ == "R "
			SC6->( dbSkip() )
			Loop
		Endif

		If SC5->( dbSeek( xFilial( "SC5" ) + SC6->C6_NUM ) ) 
			If SC5->C5_X_CANC == "C" .or. SC5->C5_EMISSAO < Ctod("01/03/2010")
				SC6->( dbSkip() )
				Loop
			Endif
		Endif

		If !Empty( cLocal )
			If SC6->C6_LOCAL != cLocal
				SC6->( dbSkip() )
				Loop
			Endif
		Endif

		nQtd := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
		if nQtd < 0
			nQtd := 0
		endif

		nRet := nRet + nQtd

		SC6->( dbSkip() )

	EndDo

	SC5->( RestArea(aAreaC5) )
	SC6->( RestArea(aAreaC6) )
	RestArea(aArea)

Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQtdEmTerc บAutor  ณTOTVS ABM           บ Data ณ 02/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a quantidade em terceiros do produto especificado   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdEmTerc( cProduto, cLocal )
	Local aArea:= GetArea()
	Local nRet := 0

	Default cLocal := ""

	DbSelectArea("SB6")
	SB6->( dbsetorder(2) )
	SB6->( dbseek( xFilial( "SB6" ) + cProduto ) )
	Do While !SB6->( Eof() ) .and. xFilial("SB6") == SB6->B6_FILIAL .and. SB6->B6_PRODUTO == cProduto

		If !Empty( cLocal )
			If SB6->B6_LOCAL != cLocal
				SB6->( dbSkip() )
				Loop
			Endif
		Endif

		if SB6->B6_TIPO == "E" .and. SB6->B6_PODER3 == "R" .and. Empty( SB6->B6_ATEND ) .and. SB6->B6_TES != '641'
			nRet := nRet + SB6->B6_SALDO
		endif

		SB6->( dbskip() )

	EndDo

	RestArea(aArea)
Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณQtdDisponiบAutor  ณTOTVS ABM           บ Data ณ 02/09/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna a quantidade disponivel do produto especificado     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QtdDisponivel( cProduto, nSldAtu, nSldEmp )
	Local aArea:= GetArea()
	Local nRet := 0

	Default nSldAtu	:= 0
	Default nSldEmp	:= 0

	nRet := nSldAtu - nSldEmp - QtdEmPedidos( cProduto )

	RestArea(aArea)
Return nRet
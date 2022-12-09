#INCLUDE "rwmake.ch" 
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RQUA004   º Autor ³ Giane              º Data ³  22/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio Visao de Recebimento                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni /                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RQUA004()

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Relação Visão de Recebimento"
	Local cPict        := ""
	Local titulo       := "Visão de Recebimento"
	Local nLin         := 80    
	Local cPerg        := 'RQUA004'

	Local Cabec1       := "" 
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd         := {} //{"Data + Vendedor", "Data + Cliente","Motivo + Data"}  
	Local aConf        := {}   
	Local cQuery       := ""      
	Local aAreaAnt     := GetArea()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA004" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "RQUA004" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "RQUA004" // Coloque aqui o nome do arquivo usado para impressao em disco    
	Private cIniCab 

	Private cString := "SD1"       

	if !Pergunte(cPerg)
		Return
	Endif     


	cString := "XREC"                                                                                                   
	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	cQuery := MontaQry()

	cQuery := ChangeQuery(cQuery) 

	MsgRun("Selecionando registros, aguarde...","Relatório Visão de Recebimentos", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cString,.T.,.T.) })    

	if MV_PAR04 == 1  //EXCEL
		GeraExcel()
	Else
		//IMPRESSAO EM TELA OU IMPRESSORA
		if MV_PAR03 == 1
			cIniCab := "Fornecedor Loja  " + Padr( "Nome Fantasia", TamSx3("A2_NREDUZ")[1] )  
		elseif MV_PAR03 == 2
			cIniCab := "Transportadora   " + Padr( "Nome Fantasia", TamSx3("A4_NREDUZ")[1] )
		else
			cIniCab := "Produto          " + Padr( "Descrição", TamSx3("B1_DESC")[1] )   
			limite := 132
			tamanho := "M"  
		Endif

		Cabec1 := cIniCab + "  Descarregamentos     Peso Total Recebido"                       

		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)


		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)   

	Endif

	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	RestArea(aAreaAnt)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaQry  º Autor ³ Giane              º Data ³  22/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta query para imprimir relatorio                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni /                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaQry()  
	Local cQuery := ""
	cQuery := "SELECT "    
	If MV_PAR03 == 1
		cQuery += "  SD1.D1_FORNECE, SD1.D1_LOJA, "    //por fornecedor
	Elseif MV_PAR03 == 2   
		cQuery += "  SF1.F1_TRANSP, " //transportadora
	Else
		cQuery += "  SD1.D1_COD,  " // por produto
	Endif                         
	cQuery += "  COUNT(1) QTDREC, SUM( CASE WHEN SD1.D1_UM = 'KG' THEN SD1.D1_QUANT ELSE (SB1.B1_PESO * SD1.D1_QUANT) END ) PESOREC "                           
	cQuery += "FROM " 
	cQuery +=    RetSqlName("SD1") + " SD1 " 
	cQuery += "JOIN "
	cQuery +=    RetSqlName("SA2") + " SA2 ON "
	cQuery += "  SA2.A2_FILIAL = '" + xFilial("SA2") + "'  "  
	cQuery += "  AND SA2.A2_COD = SD1.D1_FORNECE "
	cQuery += "  AND SD1.D1_LOJA = SA2.A2_LOJA  AND SA2.D_E_L_E_T_ = ' ' "  
	cQuery += "JOIN "
	cQuery +=    RetSqlName("SB1") + " SB1 ON "
	cQuery += "  SB1.B1_FILIAL = '" + xFilial("SB1") + "'  "  
	cQuery += "  AND SB1.B1_COD = SD1.D1_COD "
	cQuery += "  AND SB1.D_E_L_E_T_ = ' ' "   
	cQuery += "JOIN "
	cQuery +=    RetSqlName("SF1") + " SF1 ON "
	cQuery += "  SF1.F1_FILIAL = '" + xFilial("SF1") + "'  "  
	cQuery += "  AND SF1.F1_DOC = SD1.D1_DOC "
	cQuery += "  AND SF1.F1_SERIE = SD1.D1_SERIE  AND SF1.D_E_L_E_T_ = ' ' "   
	cQuery += "  AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA " 
	cQuery += "WHERE "
	cQuery += "  SD1.D1_FILIAL = '" + xFilial("SD1") +  "' AND SD1.D_E_L_E_T_ = ' ' "   
	cQuery += "  AND SD1.D1_DTDIGIT BETWEEN '" + dtos(MV_PAR01) + "' AND '" + dtos(MV_PAR02) + "' " 
	cQuery += "  AND SD1.D1_TIPO = 'N' " 
	cQuery += "  AND SB1.B1_TIPCAR = '000001' " //granel  
	If MV_PAR03 == 1
		cQuery += "GROUP BY D1_FORNECE, D1_LOJA "
	Elseif MV_PAR03 == 2
		cQuery += "GROUP BY F1_TRANSP "
	Else
		cQuery += "GROUP BY D1_COD "
	Endif
	cQuery += "ORDER BY PESOREC DESC "  

	//memowrite('c:\rqua004.sql',cquery)

Return cQuery

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/11/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem 
	Local nTotRej := 0                        

	dbSelectArea(cString)

	SetRegua(RecCount())

	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		If MV_PAR03 == 1
			@nLin,000 PSAY (cString)->D1_FORNECE 
			@nLin,009 PSAY (cString)->D1_LOJA
			@nLin,017 PSAY Posicione("SA2",1,xFilial("SA2") + (cString)->D1_FORNECE + (cString)->D1_LOJA, "A2_NREDUZ") 
		Elseif MV_PAR03 == 2
			@nLin,000 PSAY (cString)->F1_TRANSP 	
			cNomeTrans := Posicione("SA4",1,xFilial("SA4") + (cString)->F1_TRANSP, "A4_NREDUZ") 	
			@nLin,017 PSAY iif( !empty(cNomeTrans), cNomeTrans, "SEM TRANSPORTADORA"  )				
		Else 
			@nLin,000 PSAY (cString)->D1_COD 	
			@nLin,017 PSAY Posicione("SB1",1,xFilial("SB1") + (cString)->D1_COD, "B1_DESC") 				
		Endif  

		nCol1 := len(cIniCab) + 5        
		@nLin,nCol1 PSAY Transform( (cString)->QTDREC,  "@E 999,999")                                      
		nCol1 := nCol1 + 16  
		@nLin,nCol1 PSAY Transform( (cString)->PESOREC, "@E 99,999,999,999.999999")           

		nLin := nLin + 1 

		dbSkip() 
	EndDo

	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraExcel ºAutor  ³ Giane              º Data ³ 19/11/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exporta relatorio para o excel                             º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GeraExcel()
	Local aDados := {}   
	Local aCabec := {}   
	Local cPeriodo := ""

	if MV_PAR03 == 1  
		aCabec := {"Fornecedor","Loja","Nome Fantasia","Descarregamentos","Peso Total Recebido"}
		(cString)->(DbEval({|| aadd(aDados, { '="' +(cString)->D1_FORNECE + '"', '="' + (cString)->D1_LOJA + '"',;
		Posicione("SA2",1,xFilial("SA2") + (cString)->D1_FORNECE + (cString)->D1_LOJA, "A2_NREDUZ"),;
		Transform( (cString)->QTDREC,  "@E 999,999"),;
		Transform( (cString)->PESOREC, "@E 99,999,999,999.999999") }  ) } ) )
	Elseif MV_PAR03 == 2      
		aCabec := {"Transportadora","Nome Fantasia","Descarregamentos","Peso Total Recebido"}
		(cString)->(DbEval({|| aadd(aDados, { '="' +(cString)->F1_TRANSP + '"',;
		iif( !empty(Posicione("SA4",1,xFilial("SA4") + (cString)->F1_TRANSP, "A4_NREDUZ")),;
		Posicione("SA4",1,xFilial("SA4") + (cString)->F1_TRANSP, "A4_NREDUZ"),"SEM TRANSPORTADORA" ) ,; 
		Transform( (cString)->QTDREC,  "@E 999,999"),;
		Transform( (cString)->PESOREC, "@E 99,999,999,999.999999") }  ) } ) )

	Else    
		aCabec := {"Produto","Descrição","Descarregamentos","Peso Total Recebido"}
		(cString)->(DbEval({|| aadd(aDados, {(cString)->D1_COD,;
		Posicione("SB1",1,xFilial("SB1") + (cString)->D1_COD, "B1_DESC") ,; 
		Transform( (cString)->QTDREC,  "@E 999,999"),;
		Transform( (cString)->PESOREC, "@E 99,999,999,999.999999") }  ) } ) )
	Endif	

	cPeriodo := "  De " + dtoc(MV_PAR01) + "  Até "  + dtoc(MV_PAR02)

	DlgToExcel({ {"ARRAY", "Visão de Recebimentos -" + cPeriodo, aCabec, aDados} })

Return
#INCLUDE "rwmake.ch" 
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RQUA005   � Autor � Giane              � Data �  23/02/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio Visao de Variacoes                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni /                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RQUA005()

	Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2       := "de acordo com os parametros informados pelo usuario."
	Local cDesc3       := "Rela��o Vis�o de Varia��es"
	Local cPict        := ""
	Local titulo       := "Vis�o de Varia��es"
	Local nLin         := 80    
	Local cPerg        := 'RQUA005'

	Local Cabec1       := "" 
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd         := {} //{"Data + Vendedor", "Data + Cliente","Motivo + Data"}  
	Local aConf        := {}   
	Local cQuery       := ""      
	Local aAreaAnt     := GetArea()

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA005" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 132
	Private tamanho      := "M"
	Private nomeprog     := "RQUA005" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 15
	Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "RQUA005" 
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

	MsgRun("Selecionando registros, aguarde...","Relat�rio Vis�o de Varia��es", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cString,.T.,.T.) })    

	if MV_PAR04 == 1  //EXCEL
		GeraExcel()
	Else
		//IMPRESSAO EM TELA OU IMPRESSORA
		if MV_PAR03 == 1
			cIniCab := "Placa          " 
		elseif MV_PAR03 == 2
			cIniCab := "Produto          " + Padr( "Descri��o", TamSx3("B1_DESC")[1] )   
			limite := 220
			tamanho := "G"	             
		Endif

		Cabec1 := cIniCab + " Descarregamentos         Volume(KG)          Sobra(KG)          Falta(KG)          Varia��o  Varia��o(%)"                       
		//                                    999,999,999.999999   9,999,999.999999   9,999,999.999999   9,999,999.999999    999.99
		wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)


		If nLastKey == 27
			Return
		Endif

		SetDefault(aReturn,cString)

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		//���������������������������������������������������������������������Ŀ
		//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
		//�����������������������������������������������������������������������

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)   

	Endif

	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf

	RestArea(aAreaAnt)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaQry  � Autor � Giane              � Data �  23/02/11   ���
�������������������������������������������������������������������������͹��
���Descricao � Monta query para imprimir relatorio                        ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Makeni /                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaQry()  
	Local cQuery := ""
	cQuery := "SELECT "    
	If MV_PAR03 == 1
		cQuery += "  SF1.F1_PLACA, "    //por veiculo
	Else
		cQuery += "  SD1.D1_COD,  " // por produto
	Endif                         
	cQuery += "  COUNT(1) QTDREC, "
	cQuery += "  SUM( SB1.B1_PESO * SD1.D1_QUANT ) PESOORI, "  
	cQuery += "  SUM(CASE WHEN "
	cQuery += "         (SB1.B1_PESO * SD1.D1_QUANT) - (SZI.ZI_PESINI - SZI.ZI_PESFIM) > 0 "                       
	cQuery += "       THEN "
	cQuery += "         (SB1.B1_PESO * SD1.D1_QUANT) - (SZI.ZI_PESINI - SZI.ZI_PESFIM) "
	cQuery += "       ELSE "
	cQuery += "          0 "
	cQuery += "       END) QTDFALTA, "       
	cQuery += "  SUM(CASE WHEN "
	cQuery += "         (SB1.B1_PESO * SD1.D1_QUANT) - (SZI.ZI_PESINI - SZI.ZI_PESFIM) < 0 "                       
	cQuery += "       THEN "
	cQuery += "         ((SB1.B1_PESO * SD1.D1_QUANT) - (SZI.ZI_PESINI - SZI.ZI_PESFIM)) * -1 "
	cQuery += "       ELSE "
	cQuery += "          0 "
	cQuery += "       END) QTDSOBRA, "
	cQuery += "  SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) ) QTDVARIA, "  
	// linha abaixo: se o percentual de variacao retornar "NULL", usa o decode pra jogar 0(zero) no lugar, senao o order by nao funciona   
	cQuery += "  DECODE( ABS( SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) ) * 100) / SUM( SB1.B1_PESO * SD1.D1_QUANT ), NULL, 0,  ABS(SUM( (SZI.ZI_PESINI - SZI.ZI_PESFIM) - (SB1.B1_PESO * SD1.D1_QUANT) )*100) / SUM( SB1.B1_PESO * SD1.D1_QUANT ) ) PERCVARIA "
	cQuery += "FROM " 
	cQuery +=    RetSqlName("SD1") + " SD1 " 
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SZI") + " SZI ON "
	cQuery += "  SZI.ZI_FILIAL = '" + xFilial("SZI") + "'  "  
	cQuery += "  AND SZI.ZI_DOC = SD1.D1_DOC AND SZI.ZI_SERIE = SD1.D1_SERIE "
	cQuery += "  AND SZI.ZI_ITEM = SD1.D1_ITEM "
	cQuery += "  AND SZI.ZI_FORNECE = SD1.D1_FORNECE AND SZI.ZI_LOJA = SD1.D1_LOJA "
	cQuery += "  AND SZI.D_E_L_E_T_ = ' ' "  
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
		cQuery += "GROUP BY F1_PLACA "
	Else
		cQuery += "GROUP BY D1_COD "
	Endif
	cQuery += "ORDER BY PERCVARIA DESC "  

	//memowrite('c:\rqua005.sql',cquery)

Return cQuery

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  18/11/09   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

		If nLin > 63 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		If MV_PAR03 == 1
			@nLin,000 PSAY (cString)->F1_PLACA
		Else 
			@nLin,000 PSAY (cString)->D1_COD 	
			@nLin,017 PSAY Posicione("SB1",1,xFilial("SB1") + (cString)->D1_COD, "B1_DESC") 				
		Endif  

		nCol1 := len(cIniCab) + 5        
		@nLin,nCol1 PSAY Transform( (cString)->QTDREC,  "@E 999,999")                                      
		nCol1 := nCol1 + 10  
		@nLin,nCol1 PSAY Transform( (cString)->PESOORI, "@E 99,999,999,999.999999")           

		nCol1 := nCol1 + 24 
		@nLin,nCol1 PSAY Transform( (cString)->QTDSOBRA, "@E 9,999,999.999999")   

		nCol1 := nCol1 + 19  
		@nLin,nCol1 PSAY Transform( (cString)->QTDFALTA, "@E 9,999,999.999999")     

		nCol1 := nCol1 + 18  
		@nLin,nCol1 PSAY Transform( (cString)->QTDVARIA, "@E 9,999,999.999999")  

		nCol1 := nCol1 + 20 
		@nLin,nCol1 PSAY Transform( (cString)->PERCVARIA, "@E 999.99")  

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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraExcel �Autor  � Giane              � Data � 19/11/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Exporta relatorio para o excel                             ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function GeraExcel()
	Local aDados := {}   
	Local aCabec := {}   
	Local cPeriodo := ""

	if MV_PAR03 == 1  
		aadd(aCabec, "Placa")
		(cString)->(DbEval({|| aadd(aDados, { '="' +(cString)->F1_PLACA + '"',;	
		Transform( (cString)->QTDREC,  "@E 999,999"),;
		Transform( (cString)->PESOORI, "@E 99,999,999,999.999999"),;
		Transform( (cString)->QTDSOBRA, "@E 9,999,999.999999"),;
		Transform( (cString)->QTDFALTA, "@E 9,999,999.999999"),;
		Transform( (cString)->QTDVARIA, "@E 9,999,999.999999"),;
		Transform( (cString)->PERCVARIA, "@E 999.99") }  ) } ) )
	Else 
		aadd(aCabec, "Produto")   
		aadd(aCabec, "Descri��o")  
		(cString)->(DbEval({|| aadd(aDados, {(cString)->D1_COD,;
		Posicione("SB1",1,xFilial("SB1") + (cString)->D1_COD, "B1_DESC") ,; 
		Transform( (cString)->QTDREC,  "@E 999,999"),;
		Transform( (cString)->PESOORI, "@E 99,999,999,999.999999"),;
		Transform( (cString)->QTDSOBRA, "@E 9,999,999.999999"),;
		Transform( (cString)->QTDFALTA, "@E 9,999,999.999999"),;
		Transform( (cString)->QTDVARIA, "@E 9,999,999.999999"),;
		Transform( (cString)->PERCVARIA, "@E 999.99") }  ) } ) )
	Endif

	aadd(aCabec,"Descarregamentos")
	aadd(aCabec,"Volume(KG)")
	aadd(aCabec,"Sobra(KG)")
	aadd(aCabec,"Falta(KG)")
	aadd(aCabec,"Varia��o")
	aadd(aCabec,"Varia��o(%)")

	cPeriodo := "  De " + dtoc(MV_PAR01) + "  At� "  + dtoc(MV_PAR02)

	DlgToExcel({ {"ARRAY", "Vis�o de Recebimentos -" + cPeriodo, aCabec, aDados} })

Return
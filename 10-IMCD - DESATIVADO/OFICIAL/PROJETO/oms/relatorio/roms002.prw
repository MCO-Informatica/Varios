#INCLUDE "rwmake.ch" 
#INCLUDE 'TOPCONN.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ROMS002   º Autor ³ Giane              º Data ³  11/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Entregas para Transportadora                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Makeni                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ROMS002

	Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2     := "de acordo com os parametros informados pelo usuario."
	Local cDesc3     := "Relatório de Entregas para Transportadora"
	Local cPict      := ""
	Local nLin       := 80     
	Local cPerg      := 'ROMS002'   
	Local cQuery     := ""                  
	Local Cabec1     := "Emissao    N.Fiscal  Cliente/Fornecedor              Produto                                                  Quantidade UM  Vlr. Unitario   Total    Transportadora          Placa    Tipo    Vlr.Frete  CTR       PickList"
	//      99/99/99  123456    123456 99 12345678901234567890  123456789012345 123456789012345678901234567890123456789 456,789.10 99 456,789.012345 789,123.45 123456 123456789012345 12345678   999     99,999.99  123456789 123456
	//      012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
	//               1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        2         21        220
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd         := {"Transp + Data", "Data + Nr.Nota"}   
	Local cTpNota   
	Local cTpFrete  
	Local cFrete2  
	Local cTpCarga  
	Local cSql1 
	Local cSql2
	Local cSql3 
	Local cSql4

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ROMS002" , __cUserID )

	Private titulo     := "Entregas para Transportadora"
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "ROMS002" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "ROMS002" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cAlias := "XTRA"

	pergunte( cPerg, .F.) 

	If MV_PAR08 == 2 //granel
		cTpCarga :=  "'000001'" 
	elseif MV_PAR08 == 3 //carga seca
		cTpCarga :=  "'000002'" 
	else
		cTpCarga :=  "'000002','000001'" 
	endif       

	cTpNota := iif(MV_PAR07 == 2, 'E', '')
	cTpNota := iif(MV_PAR07 == 3, 'S', cTpNota)
	cTpNota := iif(MV_PAR07 == 1, 'E/S',cTpNota)   

	cTpFrete := iif(MV_PAR09 == 2, "'C'", '')
	cTpFrete := iif(MV_PAR09 == 3, "'F'", cTpFrete)
	cTpFrete := iif(MV_PAR09 == 1, "'C','F'", cTpFrete)

	cFrete2 := iif(MV_PAR09 == 1, "'F'", cTpFrete)  //se escolher cif e fob, as nfs de entrada so pode imprimir as FOBS sempre.

	wnrel := SetPrint('SF2',NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.) 


	// ================= NOTAS FISCAIS DE SAIDA =====================
	cSql4 := "SELECT 'S' QRY, SF2.F2_TRANSP, SA4.A4_NREDUZ, SF2.F2_EMISSAO, SF2.F2_DOC, SF2.F2_SERIE, SF2.F2_CLIENTE, SA1.A1_NREDUZ, SF2.F2_LOJA, "
	cSql4 += "       SF2.F2_VALBRUT, SD2.D2_ITEM, SD2.D2_COD, SB1.B1_DESC, SD2.D2_QUANT, SD2.D2_UM, SD2.D2_PRCVEN, SC5.C5_TPFRETE, DAI.DAI_VALFRE VLFRETE,"
	cSql4 += "       DAK.DAK_COD, DA3.DA3_PLACA, DFP.DFP_DOCDCT, DFP.DFP_SERDCT, DAI.DAI_PESO  " 
	cSql4 += "FROM " + RetSqlName("SF2") + " SF2 "
	cSql4 += "   JOIN " + RetSqlName("SD2") + " SD2 ON "
	cSql4 += "      SD2.D2_FILIAL = SF2.F2_FILIAL AND SD2.D2_DOC = SF2.F2_DOC AND SD2.D2_SERIE = SF2.F2_SERIE AND SD2.D_E_L_E_T_ = ' ' "
	cSql4 += "   JOIN " + RetSqlName("SC5") + " SC5 ON "
	cSql4 += "      SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SD2.D2_PEDIDO = SC5.C5_NUM AND SC5.D_E_L_E_T_ = ' ' "
	cSql4 += "   LEFT JOIN " + RetSqlName("DAI") + " DAI ON "
	cSql4 += "      DAI.DAI_FILIAL = '" + xFilial("DAI") + "' AND DAI.DAI_PEDIDO = SD2.D2_PEDIDO AND DAI.D_E_L_E_T_ = ' ' "
	cSql4 += "   LEFT JOIN " + RetSqlName("DAK") + " DAK ON "
	cSql4 += "      DAK.DAK_FILIAL = '" + xFilial("DAK") + "' AND DAK.DAK_COD = DAI.DAI_COD AND DAK.D_E_L_E_T_ = ' ' " 
	cSql4 += "   LEFT JOIN " + RetSqlName("DA3") + " DA3 ON "
	cSql4 += "      DA3.DA3_FILIAL = '" + xFilial("DA3") + "' AND DA3.DA3_COD = DAK.DAK_CAMINH AND DA3.D_E_L_E_T_ = ' ' "
	cSql4 += "   JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql4 += "      SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.B1_COD = SD2.D2_COD AND SB1.D_E_L_E_T_ = ' ' "
	cSql4 += "   LEFT JOIN " + RetSqlName("DFP") + " DFP ON "
	cSql4 += "      DFP.DFP_FILDCS = '" + xFilial("SD2") + "' AND DFP.DFP_DOCDCS = SF2.F2_DOC AND DFP.D_E_L_E_T_ = ' ' " 
	cSql4 += "      AND DFP.DFP_SERDCS = SF2.F2_SERIE "
	cSql4 += "   LEFT JOIN " + RetSqlName("SA4") + " SA4 ON "
	cSql4 += "      SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SF2.F2_TRANSP = SA4.A4_COD AND SA4.D_E_L_E_T_ = ' ' "  
	cSql4 += "   JOIN " + RetSqlName("SA1") + " SA1 ON "
	cSql4 +="      SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SF2.F2_CLIENTE = SA1.A1_COD "
	cSql4 += "     AND SF2.F2_LOJA = SA1.A1_LOJA  AND SA1.D_E_L_E_T_ = ' ' "
	cSql4 += "WHERE SF2.F2_EMISSAO BETWEEN '" + dtos(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "     
	cSql4 += "    AND SF2.F2_TRANSP BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "    
	cSql4 += "    AND SF2.D_E_L_E_T_ = ' ' AND '" + cTpNota + "' LIKE '%S%' "      
	cSql4 += "    AND SC5.C5_TPFRETE IN (" + cTpFrete + ")" 
	cSql4 += "    AND (DAK.DAK_COD BETWEEN '" + MV_PAR12 + "' AND '" + MV_PAR13 + "' OR DAK.DAK_COD IS NULL) "	
	cSql4 += "    AND (DA3.DA3_COD BETWEEN '" + MV_PAR10 + "' AND '" + MV_PAR11 + "' OR DA3.DA3_COD IS NULL) " 
	cSql4 += "    AND SB1.B1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "    
	cSql4 += "    AND SB1.B1_TIPCAR IN (" + cTpCarga + ") "   


	// ================= NOTAS FISCAIS DE ENTRADA =====================   

	cSql1:= "       SELECT "
	cSql1+= "         SF8.F8_NFDIFRE, SF8.F8_SEDIFRE, SUM(SB1.B1_PESO * SD1.D1_QUANT) AS PESOFRETE "
	cSql1+= "       FROM "
	cSql1+= "         " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql1+= "           SD1.D1_COD = SB1.B1_COD AND "
	cSql1+= "           SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cSql1+= "           SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cSql1+= "           SB1.D_E_L_E_T_ = ' ' AND "
	cSql1+= "           SD1.D_E_L_E_T_ = ' ' "
	cSql1+= "         JOIN " + RetSqlName("SF8") + " SF8 ON "
	cSql1+= "           SD1.D1_DOC = SF8.F8_NFORIG AND "
	cSql1+= "           SD1.D1_SERIE = SF8.F8_SERORIG AND "
	cSql1+= "           SF8.F8_FILIAL = SD1.D1_FILIAL AND "
	cSql1+= "           SF8.D_E_L_E_T_ = ' ' "
	cSql1+= "       GROUP BY SF8.F8_NFDIFRE, SF8.F8_SEDIFRE "
	cSql1+= "       HAVING SUM(SB1.B1_PESO * SD1.D1_QUANT) > 0 "

	cSql2:= "    SELECT "
	cSql2+= "      SF1.F1_EMISSAO, SF8.F8_NFDIFRE, SF8.F8_SEDIFRE, (SF1.F1_VALBRUT / TMP1.PESOFRETE ) FRETEKG "
	cSql2+= "    FROM "
	cSql2+= "      " + RetSqlName("SF8") + " SF8 JOIN " + RetSqlName("SF1") + " SF1 ON "
	cSql2+= "        SF1.F1_DOC = SF8.F8_NFDIFRE AND "
	cSql2+= "        SF1.F1_SERIE = SF8.F8_SEDIFRE AND "
	cSql2+= "        SF8.F8_FILIAL = SF1.F1_FILIAL AND "
	cSql2+= "        SF8.D_E_L_E_T_ = ' ' AND "
	cSql2+= "        SF1.D_E_L_E_T_ = ' ' "
	cSql2+= "      JOIN "
	cSql2+= "      ( "
	cSql2+=         cSql1
	cSql2+= "      ) TMP1 ON "
	cSql2+= "        SF8.F8_NFDIFRE = TMP1.F8_NFDIFRE AND "
	cSql2+= "        SF8.F8_SEDIFRE = TMP1.F8_SEDIFRE "

	cSql3:= "SELECT "
	cSql3+= "  'E' QRY, TMP2.F1_EMISSAO, SD1.D1_DOC, SD1.D1_FORNECE, SD1.D1_LOJA, SA2.A2_NREDUZ, SD1.D1_COD, SB1.B1_DESC, SD1.D1_QUANT, "
	cSql3+= "   SD1.D1_UM, SD1.D1_VUNIT, SD1.D1_TOTAL, SF8.F8_TRANSP, STRA.A2_NREDUZ AS TRANSP, DA3.DA3_PLACA, SC7.C7_TPFRETE, "
	cSql3+= "   ( SB1.B1_PESO * SD1.D1_QUANT * TMP2.FRETEKG ) FRETEITEM, SF8.F8_NFDIFRE "
	cSql3+= "FROM "
	cSql3+= "  "+ RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SF8") + " SF8 ON "
	cSql3+= "    SD1.D1_DOC = SF8.F8_NFORIG AND "
	cSql3+= "    SD1.D1_SERIE = SF8.F8_SERORIG AND "
	cSql3+= "    SF8.D_E_L_E_T_ = ' ' AND "
	cSql3+= "    SD1.D_E_L_E_T_ = ' ' AND "
	cSql3+= "    SD1.D1_FILIAL = SF8.F8_FILIAL "
	cSql3+= "  JOIN "
	cSql3+= "   ( "
	cSql3+=      cSql2
	cSql3+= "   ) TMP2 ON "
	cSql3+= "     SF8.F8_NFDIFRE = TMP2.F8_NFDIFRE AND "
	cSql3+= "     SF8.F8_SEDIFRE = TMP2.F8_SEDIFRE "
	cSql3+= "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql3+= "    SD1.D1_COD = SB1.B1_COD AND "
	cSql3+= "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cSql3+= "    SB1.D_E_L_E_T_ = ' ' "
	cSql3+= "  JOIN " + RetSqlName("SC7") + " SC7 ON "
	cSql3+= "    SC7.C7_NUM = SD1.D1_PEDIDO AND "
	cSql3+= "    SC7.C7_ITEM = SD1.D1_ITEMPC AND "
	cSql3+= "    SC7.D_E_L_E_T_ = ' ' AND "
	cSql3+= "    SC7.C7_FILIAL = SD1.D1_FILIAL "
	cSql3+= "  JOIN " + RetSqlName("SA2") + " SA2 ON "
	cSql3+= "    SA2.A2_COD = SD1.D1_FORNECE AND "
	cSql3+= "    SA2.A2_LOJA = SD1.D1_LOJA AND "
	cSql3+= "    SA2.D_E_L_E_T_ = ' ' AND "
	cSql3+= "    SA2.A2_FILIAL ='" + xFilial("SA2") + "' "
	cSql3+= "  JOIN " + RetSqlName("SA2") + " STRA ON "
	cSql3+= "    STRA.A2_COD = SF8.F8_TRANSP AND "
	cSql3+= "    STRA.A2_LOJA = SF8.F8_LOJTRAN AND "
	cSql3+= "    STRA.D_E_L_E_T_ = ' ' AND "
	cSql3+= "    STRA.A2_FILIAL = '" + xFilial("SA2") + "' "
	cSql3+= "  JOIN " + RetSqlName("DA3") + " DA3 "
	cSql3+= "    DA3.DA3_COD = SF8.F8_VEICULO AND "
	cSql3+= "    DA3.FILIAL = '" + xFilial("DA3") + "' AND "
	cSql3+= "    DA3.D_E_L_E_T_ = ' ' "
	cSql3+= "WHERE "
	cSql3+= "   TMP2.F1_EMISSAO BETWEEN '" + dtos(MV_PAR05) + "' AND '" + DTOS(MV_PAR06) + "' "    
	cSql3+= "   AND SF8.F8_TRANSP BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "       
	cSql3+= "   AND '" + cTpNota + "' LIKE '%E' "	
	cSql3+= "   AND SC7.C7_TPFRETE IN (" + cFrete2 + ") " 
	cSql3+= "   AND SB1.B1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "   
	cSql3+= "   AND SB1.B1_TIPCAR IN (" + cTpCarga + ") "   

	//==== aqui fazer a união das querys cSql3 + csql4 e montar uma cQuery com (UNION )

	If aReturn[8] == 1
		cQuery += "ORDER BY F2_TRANSP, F2_EMISSAO, F2_DOC, D2_ITEM "
	else 
		cQuery += "ORDER BY F2_EMISSAO, F2_DOC, D2_ITEM "
	endif   

	TCQuery cQuery NEW ALIAS "XTRA"

	dbSelectArea(cAlias)    

	If nLastKey == 27
		(cAlias)->(DbCloseArea())
		Return
	Endif

	SetDefault(aReturn,cAlias)

	If nLastKey == 27        
		(cAlias)->(DbCloseArea())
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)	


	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)        


	(cAlias)->(DbCloseArea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/02/10   º±±
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
	Local nFrete := 0
	Local nUniFrete := 0

	titulo := ALLTRIM(titulo) + "  - Período  " + dtoc(MV_PAR05) + ' ate ' + dtoc(MV_PAR06)

	dbSelectArea(cAlias)

	SetRegua(RecCount())

	dbGoTop() 
	While !EOF()

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif


		If nLin > 58 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		nFrete := 0
		If (cAlias)->DAI_PESO > 0
			nUniFrete := ((cAlias)->VLFRETE / (cAlias)->DAI_PESO) 
			nFrete := nUniFrete * (cAlias)->D2_QUANT
		endif

		@ nLin,000   PSAY STOD((cAlias)->F2_EMISSAO)
		@ nLin,009   PSAY (cAlias)->QRY
		@ nLin,011   PSAY (cAlias)->F2_DOC 
		@ nLin,021   PSAY (cAlias)->F2_CLIENTE
		@ nLin,028   PSAY (cAlias)->F2_LOJA
		@ nLin,031   PSAY (cAlias)->A1_NREDUZ
		@ nLin,053   PSAY (cAlias)->D2_COD
		@ nLin,069   PSAY LEFT((cAlias)->B1_DESC,40)
		@ nLin,110   PSAY Transform((cAlias)->D2_QUANT, "@E 999,999.99" )  
		@ nLin,121   PSAY (cAlias)->D2_UM  
		@ nLin,124   PSAY Transform((cAlias)->D2_PRCVEN, "@E 999,999.999999" )   
		@ nLin,139   PSAY Transform((cAlias)->F2_VALBRUT, "@E 999,999.99" )       
		@ nLin,150   PSAY (cAlias)->F2_TRANSP     
		@ nLin,157   PSAY (cAlias)->A4_NREDUZ  
		@ nLin,174   PSAY (cAlias)->DA3_PLACA  
		@ nLin,183   PSAY Iif((cAlias)->C5_TPFRETE = 'C','CIF','FOB')  
		@ nLin,191   PSAY Transform(nFrete, "@E 99,999.99")    	     
		@ nLin,202   PSAY (cAlias)->DFP_DOCDCT  
		@ nLin,212   PSAY (cAlias)->DAK_COD  

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

Return()
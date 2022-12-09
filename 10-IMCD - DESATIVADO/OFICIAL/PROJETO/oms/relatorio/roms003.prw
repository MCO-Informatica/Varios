#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณROMS003   บ Autor ณ Giane              บ Data ณ  29/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio Geral de Frete                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Makeni - OMS                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ROMS003

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "Resumo Geral de Frete"
	Local cPict          := ""
	Local titulo         := "Resumo Geral de Frete"
	Local nLin           := 80
	Local Cabec1         := "NOME DA               PLACA     TIPO    VOLUME TOTAL      VALOR TOTAL   VALOR DO"
	Local Cabec2         := "TRANSPORTADORA        VEICULO   CARGA   TRANSPORTADO         DO FRETE   FRETE/KG"  
	//                       01234567890123456789  12345678  CS      9999999.9999   999,999,999.99  9,999.9999  
	//                       01234567890123456789012345678901234567890123456789012345678901234567890123456789
	Local imprime        := .T.                                                     
	Local aOrd           := {}
	Local cQuery         := ""
	Local cSql           := ""  
	Local cSql1          := ""
	Local cSql2          := ""
	Local cSql3          := ""
	Local cSql4          := ""
	Local cSql5          := ""
	Local cSql6          := ""
	Local cSql7          := ""
	Local cTpCarga       := ""

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "ROMS003" , __cUserID )

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 80
	Private tamanho      := "P"
	Private nomeprog     := "ROMS003" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cPerg        := "ROMS003"
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "ROMS003" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "SF2"  

	dbSelectArea("SF2")
	dbSetOrder(1)   

	pergunte(cPerg,.F.)

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	If MV_PAR05 == 2 //granel
		cTpCarga :=  "'000001'" 
	elseif MV_PAR05 == 3 //carga seca
		cTpCarga :=  "'000002'" 
	else
		cTpCarga :=  "'000002','000001'" 
	endif                                          


	// ==================== NOTAS FISCAIS DE SAIDA  ====================
	cSql1:= "      SELECT "
	cSql1+= "        DAI.DAI_COD, SB1.B1_TIPCAR, SF2.F2_TRANSP, DAI.DAI_PEDIDO, MAX(DAI.DAI_VALFRE) DAI_VALFRE "
	cSql1+= "      FROM "
	cSql1+= "        " + RetSqlName("DAI") + " DAI JOIN " + RetSqlName("SD2") + " SD2 ON "
	cSql1+= "          SD2.D2_FILIAL  = '" + xFilial("SD2") + "' AND "
	cSql1+= "          DAI.DAI_FILIAL = '" + xFilial("DAI") + "' AND "
	cSql1+= "          SD2.D2_PEDIDO  = DAI.DAI_PEDIDO AND "
	cSql1+= "          SD2.D_E_L_E_T_ = ' '  AND "
	cSql1+= "          DAI.D_E_L_E_T_ = ' ' "
	cSql1+= "        JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql1+= "          SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql1+= "          SD2.D2_COD = SB1.B1_COD AND "
	cSql1+= "          SB1.D_E_L_E_T_ = ' ' "
	cSql1+= "        JOIN " + RetSqlName("SF2") + " SF2 ON "
	cSql1+= "          SF2.F2_FILIAL  = SD2.D2_FILIAL AND "
	cSql1+= "          SF2.F2_DOC     = SD2.D2_DOC    AND "
	cSql1+= "          SF2.F2_SERIE   = SD2.D2_SERIE  AND "
	cSql1+= "          SF2.D_E_L_E_T_ = ' ' "    
	cSql1+= "      WHERE " 
	cSql1+= "        SF2.F2_EMISSAO BETWEEN '" + dtos(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "     
	cSql1+= "        AND SF2.F2_TRANSP BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "    
	cSql1+= "        AND SF2.D_E_L_E_T_ = '' AND SF2.F2_TRANSP <> '      ' "      
	cSql1+= "        AND SB1.B1_TIPCAR IN (" + cTpCarga + ") "    
	cSql1+= "      GROUP BY "
	cSql1+= "        DAI.DAI_COD, SB1.B1_TIPCAR, SF2.F2_TRANSP, DAI.DAI_PEDIDO "

	cSql2:= "   SELECT "
	cSql2+= "     DAK.DAK_COD, TMP.B1_TIPCAR, TMP.F2_TRANSP,DA3.DA3_PLACA, MAX(DAK.DAK_PESO) DAK_PESO, SUM(TMP.DAI_VALFRE) DAI_VALFRE "
	cSql2+= "   FROM "
	cSql2+= "     " + RetSqlName("DAK") + " DAK JOIN " + RetSqlName("DA3") + " DA3 ON "
	cSql2+= "       DA3.DA3_FILIAL = '" + xFilial("DA3") + "' AND "
	cSql2+= "       DAK.DAK_FILIAL = '" + xFilial("DAK") + "' AND "
	cSql2+= "       DA3.DA3_COD    = DAK.DAK_CAMINH AND "
	cSql2+= "       DA3.D_E_L_E_T_ = ' ' AND "
	cSql2+= "       DAK.D_E_L_E_T_ = ' ' "
	cSql2+= "     JOIN "
	cSql2+= "     ( " + cSql1 + " ) TMP ON "
	cSql2+= "       DAK.DAK_COD    = TMP.DAI_COD "
	cSql2+= "     JOIN " + RetSqlName("SC5") + " SC5 ON "
	cSql2+= "       SC5.C5_FILIAL  = '" + xFilial("SC5") + "' AND "
	cSql2+= "       SC5.C5_NUM = TMP.DAI_PEDIDO AND "
	cSql2+= "       SC5.D_E_L_E_T_ = ' ' "
	cSql2+= "   WHERE "
	cSql2+= "     SC5.C5_TPFRETE = 'C' " 
	cSql2+= "     AND DA3.DA3_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'  " 
	cSql2+= "   GROUP BY 
	cSql2+= "     DAK.DAK_COD, TMP.B1_TIPCAR, TMP.F2_TRANSP,DA3.DA3_PLACA "

	cSql3:= "SELECT "
	cSql3+= "  TMP.B1_TIPCAR, TMP.F2_TRANSP, TMP.DA3_PLACA, SUM(TMP.DAK_PESO) DAK_PESO, SUM(TMP.DAI_VALFRE) DAI_VALFRE, MAX(SA4.A4_NREDUZ) A4_NREDUZ "
	cSql3+= "FROM "
	cSql3+= "  ( " + cSql2 + "  ) TMP JOIN " + RetSqlName("SA4") + " SA4 ON "
	cSql3+= "    SA4.A4_FILIAL  = '" + xFilial("SA4") + "' AND "
	cSql3+= "    SA4.A4_COD     = TMP.F2_TRANSP AND "
	cSql3+= "    SA4.D_E_L_E_T_ = ' ' "    
	cSql3+= "GROUP BY "
	cSql3+= "  TMP.B1_TIPCAR, TMP.F2_TRANSP, TMP.DA3_PLACA"

	// ===================== NOTAS FISCAIS DE ENTRADA  ====================

	cSql4:= "       SELECT SD1.D1_DOC, SD1.D1_SERIE, SB1.B1_TIPCAR "
	cSql4+= "       FROM "
	cSql4+= "         " + RetSqlName("SD1") + " SD1 JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql4+= "         SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cSql4+= "         SB1.B1_COD = SD1.D1_COD AND "
	cSql4+= "         SB1.D_E_L_E_T_ = ' ' "
	cSql4+= "       JOIN " + RetSqlName("SC7") + " SC7 ON "
	cSql4+= "         SC7.C7_FILIAL = '"+ xFilial("SC7") + "' AND "
	cSql4+= "         SD1.D1_PEDIDO = SC7.C7_NUM AND "
	cSql4+= "         SC7.D_E_L_E_T_ = ' '  AND "
	cSql4+= "         SC7.C7_TPFRETE = 'F'  AND "  
	cSql4+= "         SB1.B1_TIPCAR IN (" + cTpCarga + ") "   
	cSql4+= "       GROUP BY SD1.D1_DOC, SD1.D1_SERIE, SB1.B1_TIPCAR  "

	cSql5:= "     SELECT "
	cSql5+= "       SF8.F8_FILIAL,SF8.F8_NFORIG, SF8.F8_SERORIG, SF1.F1_PBRUTO "
	cSql5+= "     FROM "
	cSql5+= "       " + RetSqlName("SF8") + " SF8 JOIN " + RetSqlName("SF1") + " SF1 ON "
	cSql5+= "         SF8.F8_FILIAL = SF1.F1_FILIAL AND "
	cSql5+= "         SF8.F8_NFORIG = SF1.F1_DOC AND "
	cSql5+= "         SF8.F8_SERORIG = SF1.F1_SERIE AND "
	cSql5+= "         SF1.D_E_L_E_T_ = ' ' AND "
	cSql5+= "         SF8.D_E_L_E_T_ = ' '  " 

	cSql6:= "  SELECT "
	cSql6+= "    TMP2.B1_TIPCAR,SF1.F1_FORNECE,DA3.DA3_PLACA, SF1.F1_DOC, SF1.F1_SERIE, SUM(TMP1.F1_PBRUTO) AS PESO, MAX(SF1.F1_VALBRUT) AS FRETE "
	cSql6+= "  FROM "
	cSql6+= "    " + RetSqlName("SF1") + " SF1 JOIN " + RetSqlName("SF8") + " SF8 ON "
	cSql6+= "      SF8.F8_FILIAL = SF1.F1_FILIAL AND "
	cSql6+= "      SF8.F8_NFDIFRE = SF1.F1_DOC AND "
	cSql6+= "      SF8.F8_SEDIFRE = SF1.F1_SERIE "
	cSql6+= "    JOIN "
	cSql6+= "    ( "
	cSql6+= "    "+ cSql5 
	cSql6+= "    ) TMP1 ON "
	cSql6+= "      SF8.F8_NFORIG = TMP1.F8_NFORIG AND "
	cSql6+= "      SF8.F8_SERORIG = TMP1.F8_SERORIG "
	cSql6+= "    JOIN " + RetSqlName("DA3") + " DA3 ON "
	cSql6+= "      DA3.DA3_FILIAL = '" + xFilial("DA3") + "' AND "
	cSql6+= "      DA3.DA3_COD = SF8.F8_VEICULO AND "
	cSql6+= "      DA3.D_E_L_E_T_ = ' ' "
	cSql6+= "    JOIN "
	cSql6+= "     ( "
	cSql6+= "     " + cSql4 
	cSql6+= "     ) TMP2 ON "
	cSql6+= "     SF8.F8_NFORIG = TMP2.D1_DOC AND "
	cSql6+= "     SF8.F8_SERORIG = TMP2.D1_SERIE "
	cSql6+= "  WHERE "
	cSql6+= "    SF1.F1_EMISSAO BETWEEN '" + dtos(MV_PAR03) + "' AND '" + DTOS(MV_PAR04) + "' "  
	cSql6+= "    AND SF1.F1_FORNECE BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "  
	cSql6+= "    AND SF1.D_E_L_E_T_ = ' ' "
	cSql6+= "    AND SF1.F1_FORNECE <> '      ' "
	cSql6+= "    AND DA3.DA3_COD BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "'  " 
	cSql6+= "  GROUP BY TMP2.B1_TIPCAR,SF1.F1_FORNECE,DA3.DA3_PLACA, SF1.F1_DOC, SF1.F1_SERIE "

	cSql7:="SELECT "
	cSql7+="  B1_TIPCAR,F1_FORNECE,DA3_PLACA,SUM(TMP3.PESO) AS PESO, SUM(TMP3.FRETE) AS FRETE, MAX(SA2.A2_NREDUZ) A2_NREDUZ "
	cSql7+="FROM "
	cSql7+="  ( "
	cSql7+=    cSql6  
	cSql7+="   ) TMP3 "  
	cSql7+="    JOIN " + RetSqlName("SA2") + " SA2 ON "
	cSql7+="    SA2.A2_FILIAL  = '" + xFilial("SA2") + "' AND "
	cSql7+="    SA2.A2_COD     = TMP3.F1_FORNECE AND "
	cSql7+="    SA2.A2_LOJA    = TMP3.F1_LOJA AND "
	cSql7+="    SA2.D_E_L_E_T_ = ' ' "    
	cSql7+="GROUP BY TMP3.B1_TIPCAR, TMP3.F1_FORNECE, TMP3.DA3_PLACA "

	//unindo as querys:
	cQuery:= "SELECT "
	cQuery+= "  B1_TIPCAR, F2_TRANSP, DA3_PLACA, A2_NREDUZ, SUM(DAK_PESO) DAK_PESO, SUM(DAI_VALFRE) DAI_VALFRE"
	cQuery+= "FROM "
	cQuery+= "( "
	cQuery+=  cSql3 + " UNION ALL " + cSql7
	cQuery+= ")  "  
	cQuery+= "GROUP BY "
	cQuery+= "  B1_TIPCAR, F2_TRANSP, DA3_PLACA, A2_NREDUZ" 

	cString := 'XFRE'

	If Select(cString) > 0
		(cString)->(DbCloseArea())
	EndIf                                    

	cQuery := ChangeQuery(cQuery)

	MsgRun("Selecionando registros...","Resumo Geral de Frete", {||dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cString,.T.,.F.) })                                                             

	dbSelectArea(cString)  

	SetDefault(aReturn,cString)

	If nLastKey == 27   
		(cString)->(DbCloseArea())
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	(cString)->(DbCloseArea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  29/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem
	Local nTotPeso := 0
	Local nTotFrete:= 0  
	Local nPesoGra := 0
	Local nPesoCS  := 0
	Local nFretGra := 0
	Local nFretCS  := 0
	Local cChave   := ""

	dbSelectArea(cString) 
	SetRegua(RecCount())

	cChave := (cString)->B1_TIPCAR + (cString)->F2_TRANSP
	While (cString)->(!EOF())

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif          

		If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 09
		Endif         

		@nLin,00 PSAY (cString)->A2_NREDUZ //Posicione("SA4",1,xFilial("SA4")+(cString)->F2_TRANSP,"A4_NREDUZ")  
		@nLin,22 PSAY (cString)->DA3_PLACA
		@nLin,32 PSAY iif( (cString)->B1_TIPCAR = '000001',' G','CS')
		@nLin,38 PSAY (cString)->DAK_PESO PICTURE "@E 9,999,999.9999"
		@nLin,55 PSAY Transform((cString)->DAI_VALFRE, "@E 999,999,999.99")
		if (cString)->DAK_PESO > 0 .and. (cString)->DAI_VALFRE  > 0
			@nLin,70 PSAY ( (cString)->DAI_VALFRE / (cString)->DAK_PESO) PICTURE "@E 9,999.9999"
		else
			@nLin,70 PSAY 0 PICTURE "9,999.9999"
		endif

		nLin := nLin + 1 
		@nLin,00 PSAY replicate('-',81)
		nLin := nLin + 1 

		//soma totais por transportadora
		nTotPeso += (cString)->DAK_PESO
		nTotFrete += (cString)->DAI_VALFRE  

		if (cString)->B1_TIPCAR = '000001'
			nPesoGra += (cString)->DAK_PESO
			nFretGra += (cString)->DAI_VALFRE   
		else
			nPesoCS += (cString)->DAK_PESO
			nFretCS += (cString)->DAI_VALFRE   
		endif

		(cString)->(dbSkip() )

		if (cString)->B1_TIPCAR + (cString)->F2_TRANSP != cChave        
			@nLin,02 PSAY 'TOTAL TRANSPORTADORA.............' 
			@nLin,36 PSAY nTotPeso PICTURE "@E 999,999,999.9999" 
			@nLin,53 PSAY Transform(nTotFrete, "@E 9,999,999,999.99")
			@nLin,70 PSAY ( nTotFrete / nTotPeso) PICTURE "@E 9,999.9999" 
			nLin ++  
			@nLin,00 PSAY replicate('-',81)
			nLin := nLin + 2      

			nTotPeso := 0
			nTotFrete := 0   
			cChave := (cString)->B1_TIPCAR + (cString)->F2_TRANSP
		endif

	EndDo   
	If nLin > 53 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 09
	Endif 

	@nLin,00 PSAY replicate('-',81)
	nLin++
	@nLin,00 PSAY  "VOLUME TOTAL TRANSPORTADO CARGA SECA..................."
	@nLin,65 PSAY nPesoCS PICTURE "@E 999,999,999.9999"  
	nLin++
	@nLin,00 PSAY replicate('-',81)
	nLin++
	@nLin,00 PSAY "VALOR TOTAL PAGO DE FRETE PARA CARGA SECA.............."
	@nLin,65 PSAY nFretCS PICTURE "@E 9,999,999,999.99"
	nLin++
	@nLin,00 PSAY replicate('-',81)
	nLin++
	@nLin,00 PSAY "VALOR DO FRETE P/KG NO PERIODO - CARGA SECA............"
	@nLin,71 PSAY (nFretCs / nPesoCs) PICTURE "@E 9,999.9999" 
	nLin++
	@nLin,00 PSAY replicate('-',81)
	nLin:= nLin +2

	If nLin > 53 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 09
	Endif 

	@nLin,00 PSAY replicate('-',81)
	nLin++
	@nLin,00 PSAY "VOLUME TOTAL TRANSPORTADO A GRANEL....................."
	@nLin,65 PSAY nPesoGra PICTURE "@E 999,999,999.9999"  
	nLin++
	@nLin,00 PSAY replicate('-',81)
	nLin++
	@nLin,00 PSAY "VALOR TOTAL PAGO DE FRETE A GRANEL....................."
	@nLin,65 PSAY nFretGra PICTURE "@E 9,999,999,999.99"
	nLin++
	@nLin,00 PSAY replicate('-',81)
	nLin++
	@nLin,00 PSAY "VALOR DO FRETE P/KG NO PERIODO - A GRANEL.............."
	@nLin,71 PSAY (nFretGra / nPesoGra) PICTURE "@E 9,999.9999" 
	nLin++
	@nLin,00 PSAY replicate('-',81)


	SET DEVICE TO SCREEN

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return()
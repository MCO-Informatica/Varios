#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  08/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
user function Relcusto()
	Local cPerg := "RELCUSTO02"
	Local aRel	:= {}

	IF PERGUNTE(cPerg,.T.)
		BUSCDADO(@aRel)
		if MV_PAR06 == 1
			IMPDADOS(@aRel)
		ELSEIF MV_PAR06 == 2
			IMPEXCEL(@aRel)
		ELSE
			IMPPDF(@aRel)
		ENDIF
	ENDIF

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELCUSTO  บAutor  ณMicrosiga           บ Data ณ  08/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION BUSCDADO(aRel)
	Local cQuery := ""
	cQuery += " SELECT MAX(A.D1_DTDIGIT) AS DTDIGIT, A.D1_COD, D.B1_DESC, A.D1_QUANT, B.F1_DOC, A.D1_CUSTO, D.B1_XMOEDA, G.M2_MOEDA2, G.M2_MOEDA3, G.M2_MOEDA4, G.M2_MOEDA5, A.D1_CF,(A.D1_CUSTO+CASE WHEN F.D1_CUSTO IS NULL THEN 0 ELSE F.D1_CUSTO END ) AS D1_TOTAL, CASE WHEN F.F1_DOC IS NULL THEN '' ELSE F.F1_DOC END AS F1_DOCS, CASE WHEN F.D1_CUSTO IS NULL THEN 0 ELSE F.D1_CUSTO END AS D1_CUSTOS, CASE WHEN F.QTD IS NULL THEN 0 ELSE F.QTD END AS QTD   "
	cQuery += "   FROM "+RETSQLNAME("SD1")+" A INNER JOIN "+RETSQLNAME("SF1")+" B ON "
	cQuery += "        A.D1_FILIAL = '"+xFilial("SD1")+"' "
	cQuery += "    AND A.D_E_L_E_T_ = ' ' "
	cQuery += "    AND B.F1_FILIAL =  '"+xFilial("SF1")+"' "
	cQuery += "    AND B.D_E_L_E_T_ = ' ' "
	cQuery += "    AND A.D1_DOC = B.F1_DOC "
	cQuery += "    AND B.F1_SERIE = A.D1_SERIE "
	cQuery += "  INNER JOIN "+RETSQLNAME("SB1")+" D ON "
	cQuery += "    D.B1_FILIAL = '"+xFilial("SB1")+"'  "
	cQuery += "    AND D.D_E_L_E_T_ = ' ' "
	cQuery += "    AND A.D1_COD = D.B1_COD  "
	cQuery += "  LEFT JOIN ( SELECT A1.D1_FILIAL, A1.D1_NFORI, A1.D1_SERIORI, A1.D1_COD, A1.D1_CUSTO, A1.D1_TOTAL, A1.D1_QUANT AS QTD,A1.D1_CF ,D1_FORNECE, D1_LOJA, F1_DOC "
	cQuery += "				   FROM "+RETSQLNAME("SD1")+" A1, "+RETSQLNAME("SF1")+" B1 "
	cQuery += "				  WHERE A1.D1_FILIAL =  '"+xFilial("SD1")+"'  "
	cQuery += "				    AND A1.D_E_L_E_T_ = ' ' "
	cQuery += "				    AND B1.F1_FILIAL = '"+xFilial("SF1")+"'  "
	cQuery += "				    AND B1.D_E_L_E_T_ = ' ' "
	cQuery += "				    AND A1.D1_DOC = B1.F1_DOC   "
	cQuery += "				    AND B1.F1_SERIE = A1.D1_SERIE "
	cQuery += "				    AND B1.F1_TIPO = 'C' "
	cQuery += "				    AND SUBSTR(A1.D1_CF,1,1) = '3') F ON  "
	cQuery += "    	   F.D1_FILIAL = A.D1_FILIAL   "
	cQuery += "    AND F.D1_NFORI = A.D1_DOC "
	cQuery += "    AND F.D1_SERIORI = A.D1_SERIE "
	cQuery += "    AND F.D1_FORNECE = B.F1_FORNECE "
	cQuery += "    AND F.D1_LOJA = B.F1_LOJA "
	cQuery += "    AND F.D1_COD = A.D1_COD "
	cQuery += "    AND SUBSTR(F.D1_CF,1,1) = '3' "
	cQuery += "  INNER JOIN "+RETSQLNAME("SM2")+" G ON "
	cQuery += "    G.D_E_L_E_T_ = ' ' "
	cQuery += "    AND G.M2_DATA = A.D1_DTDIGIT "
	cQuery += "  WHERE A.D1_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'  "+CRLF
	if !empty(MV_PAR05)
		cQuery += "     AND A.D1_CF IN "+FORMATIN(ALLTRIM(MV_PAR05),';')+"  "+CRLF
	endif
	cQuery += "     AND A.D1_DTDIGIT BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"'  "+CRLF
	cQuery += "     AND B.F1_TIPO <> 'C' "
	cQuery += " GROUP BY A.D1_COD, D.B1_DESC, A.D1_QUANT, B.F1_DOC, A.D1_CUSTO, D.B1_XMOEDA, G.M2_MOEDA2, G.M2_MOEDA3, G.M2_MOEDA4, G.M2_MOEDA5, A.D1_CF,(A.D1_TOTAL+CASE WHEN F.D1_TOTAL IS NULL THEN 0 ELSE F.D1_TOTAL END ), F.F1_DOC, F.D1_CUSTO, CASE WHEN F.QTD IS NULL THEN 0 ELSE F.QTD END    "+CRLF
	cQuery += " ORDER BY 1 DESC, 13 ASC "+CRLF
	cQuery := ChangeQuery( cQuery )
	IIF(SELECT("TRBTR")>0,TRBTR->(DBCLOSEAREA()),NIL)
	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "TRBTR", .T., .T.)
	while TRBTR->(!eof())
		if aScan(aRel,{|x| x[2] == TRBTR->D1_COD})<=0
			aadd(aRel,{TRBTR->DTDIGIT, TRBTR->D1_COD, SUBSTR(TRBTR->B1_DESC,1,40), TRBTR->D1_QUANT, TRBTR->D1_CUSTO, TRBTR->B1_XMOEDA, TRBTR->M2_MOEDA2, TRBTR->M2_MOEDA3, TRBTR->M2_MOEDA4, TRBTR->M2_MOEDA5, TRBTR->D1_CF, TRBTR->D1_TOTAL, TRBTR->D1_CUSTOS, TRBTR->D1_TOTAL/TRBTR->D1_QUANT, TRBTR->F1_DOC, TRBTR->F1_DOCS })
		endif
		TRBTR->(dbskip())
	end
rETURN()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELCUSTO  บAutor  ณMicrosiga           บ Data ณ  08/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION IMPPDF(aRel)
	Local oFont7  	:= TFont():New("Arial",9,7,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont8  	:= TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont8n 	:= TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont9  	:= TFont():New("Arial",9,9,.T.,.f.,5,.T.,5,.T.,.F.)
	Local oFont9n  	:= TFont():New("Arial",9,9,.T.,.t.,5,.T.,5,.T.,.F.)
	Local oFont10c 	:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont11c 	:= TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont10  	:= TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont11  	:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont12  	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont13  	:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont14  	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont18  	:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont20  	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont21  	:= TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont16 	:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont16n 	:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont15  	:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont15n 	:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont14n 	:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont24  	:= TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFontLD 	:= TFont():New("Times New Roman",8,17,.T.,.F.,5,.T.,5,.T.,.F.)
	Local nLinha	:= 0
	Local nTot		:= 0
	Local oPrint	:= NIL
	Local cNome		:= DTOS(DATE())+STRTRAN(TIME(),':','')
	Local nFor := 0
	FERASE('C:\TEMP\'+cNome+'.PDF')
	oPrint:= FWMsPrinter():New( cNome+'.PDF',IMP_PDF,.T.,'C:\TEMP\',.T.,.F.,,"",.F.,.T.,.F.,.T.,1)
	oPrint:setDevice(IMP_PDF)
	oPrint:CPATHPDF := '\DATA\'
	oPrint:NFACTORHOR := 4
	oPrint:NFACTORVERT := 4.8
	oPrint:NVERTSIZE := 350
	oPrint:nHorzSize := 250

	//oPrint:= TMSPrinter():New( "Fatura" )
	oPrint:SetLandscape()

	// Inicia uma nova pแgina
	oPrint:StartPage()

	// cabecario
	nLinha := 90
	oPrint:Say (nLinha,0020,"Data",oFont10 )
	oPrint:Say (nLinha,0120,"Codigo",oFont10 )
	oPrint:Say (nLinha,0320,"Descri็ใo",oFont10 )
	oPrint:Say (nLinha,0820,"Quantidade",oFont10 )
	oPrint:Say (nLinha,1020,"Doc",oFont10 )
	oPrint:Say (nLinha,1220,"Custo",oFont10 )
	oPrint:Say (nLinha,1420,"Doc Compl",oFont10 )
	oPrint:Say (nLinha,1570,"Custo Compl",oFont10 )
	oPrint:Say (nLinha,1750,"Moeda",oFont10 )
	oPrint:Say (nLinha,1880,"Tx Moeda2",oFont10 )
	oPrint:Say (nLinha,2040,"Tx Moeda4",oFont10 )
	oPrint:Say (nLinha,2200,"Tx Moeda5",oFont10 )
	oPrint:Say (nLinha,2400,"Cod Fiscal",oFont10 )
	oPrint:Say (nLinha,2650,"Custo Total",oFont10 )
	oPrint:Say (nLinha,2830,"Custo Unit",oFont10 )
	oPrint:Say (nLinha+10,0010,"|_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|",oFont9n )
	nLinha += 90
	// loop de dados do boleto
	for nFor := 1 to len(aRel)
		IF nLinha >= 1800
			oPrint:EndPage()
			oPrint:StartPage()
			nLinha := 90
			oPrint:Say (nLinha,0020,"Data",oFont10 )
			oPrint:Say (nLinha,0120,"Codigo",oFont10 )
			oPrint:Say (nLinha,0320,"Descri็ใo",oFont10 )
			oPrint:Say (nLinha,0820,"Quantidade",oFont10 )
			oPrint:Say (nLinha,1020,"Doc",oFont10 )
			oPrint:Say (nLinha,1220,"Custo",oFont10 )
			oPrint:Say (nLinha,1420,"Doc Compl",oFont10 )
			oPrint:Say (nLinha,1570,"Custo Compl",oFont10 )
			oPrint:Say (nLinha,1750,"Moeda",oFont10 )
			oPrint:Say (nLinha,1880,"Tx Moeda2",oFont10 )
			oPrint:Say (nLinha,2040,"Tx Moeda4",oFont10 )
			oPrint:Say (nLinha,2200,"Tx Moeda5",oFont10 )
			oPrint:Say (nLinha,2400,"Cod Fiscal",oFont10 )
			oPrint:Say (nLinha,2650,"Custo Total",oFont10 )
			oPrint:Say (nLinha,2830,"Custo Unit",oFont10 )
			oPrint:Say (nLinha+10,0010,"|_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|",oFont9n )
			nLinha += 90
		ENDIF
		oPrint:Say (nLinha,0020,dtoc(stod(aRel[nFor][1])),oFont9 )
		oPrint:Say (nLinha,0120,aRel[nFor][2],oFont9 )
		oPrint:Say (nLinha,0320,aRel[nFor][3],oFont9 )
		oPrint:Say (nLinha,0820,cValToChar(aRel[nFor][4]),oFont9 )
		oPrint:Say (nLinha,1020,cValToChar(aRel[nFor][15]),oFont9 )
		oPrint:Say (nLinha,1220,alltrim(transform(aRel[nFor][5],"@E 999,999,999,999.9999")),oFont9 )
		oPrint:Say (nLinha,1420,cValToChar(aRel[nFor][16]),oFont9 )
		oPrint:Say (nLinha,1570,alltrim(transform(aRel[nFor][13],"@E 999,999,999,999.9999")),oFont9 )
		oPrint:Say (nLinha,1800,cValToChar(aRel[nFor][6]),oFont9 )
		oPrint:Say (nLinha,1900,cValToChar(aRel[nFor][8]),oFont9 )
		oPrint:Say (nLinha,2040,cValToChar(aRel[nFor][9]),oFont9 )
		oPrint:Say (nLinha,2200,cValToChar(aRel[nFor][10]),oFont9 )
		oPrint:Say (nLinha,2400,aRel[nFor][11],oFont9 )
		oPrint:Say (nLinha,2650,alltrim(transform(aRel[nFor][12],"@E 999,999,999,999.99")),oFont9 )
		oPrint:Say (nLinha,2900,alltrim(transform(aRel[nFor][14],"@E 999,999,999,999.99")),oFont9 )
		nLinha	+= 40
	Next nFor
	// Finaliza a pแgina
	oPrint:EndPage()     // Finaliza a pแgina
	cnome1 := oPrint:cFilePrint
	FClose(oPrint:nHandle)
	File2Printer( cnome1, "PDF" )
	if file("DATA\"+cNome+".PDF")
		__COPYFILE( "DATA\"+CNOME+".PDF", "C:\TEMP\"+CNOME+".PDF")
	endif
	if file("C:\TEMP\"+CNOME+".PDF")
		shellExecute( "Open", "C:\TEMP\"+CNOME+".PDF", " ", "C:\", 1 )
	ENDIF
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELCUSTO  บAutor  ณMicrosiga           บ Data ณ  08/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION IMPDADOS(aRel)
	Local oFont7  	:= TFont():New("Arial",9,7,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont8  	:= TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont8n 	:= TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont9  	:= TFont():New("Arial",9,7,.T.,.f.,5,.T.,5,.T.,.F.)
	Local oFont9n  	:= TFont():New("Arial",9,9,.T.,.t.,5,.T.,5,.T.,.F.)
	Local oFont10c 	:= TFont():New("Courier New",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont11c 	:= TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont10  	:= TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont11  	:= TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont12  	:= TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont13  	:= TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont14  	:= TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont18  	:= TFont():New("Arial",9,18,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont20  	:= TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont21  	:= TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont16 	:= TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont16n 	:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont15  	:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFont15n 	:= TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont14n 	:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
	Local oFont24  	:= TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
	Local oFontLD 	:= TFont():New("Times New Roman",8,17,.T.,.F.,5,.T.,5,.T.,.F.)
	Local nLinha	:= 0
	Local nTot		:= 0
	Local oPrint	:= NIL
	Local cNome		:= DTOS(DATE())+STRTRAN(TIME(),':','')
	Local nFor := 0

	oPrint:= TMSPrinter():New( "Relatorio de Custo" )

	//oPrint:= TMSPrinter():New( "Fatura" )
	oPrint:SetLandscape()

	// Inicia uma nova pแgina
	oPrint:StartPage()


	// cabecario
	nLinha := 40
	oPrint:Say (nLinha,0020,"Data",oFont10 )
	oPrint:Say (nLinha,0140,"Codigo",oFont10 )
	oPrint:Say (nLinha,0380,"Descri็ใo",oFont10 )
	oPrint:Say (nLinha,1040,"Quantidade",oFont10 )
	oPrint:Say (nLinha,1260,"Doc",oFont10 )
	oPrint:Say (nLinha,1410,"Custo",oFont10 )
	oPrint:Say (nLinha,1600,"Doc Compl",oFont10 )
	oPrint:Say (nLinha,1800,"Custo Compl",oFont10 )
	oPrint:Say (nLinha,2050,"Moeda",oFont10 )
	oPrint:Say (nLinha,2200,"Tx Moeda2",oFont10 )
	oPrint:Say (nLinha,2400,"Tx Moeda4",oFont10 )
	oPrint:Say (nLinha,2600,"Tx Moeda5",oFont10 )
	oPrint:Say (nLinha,2800,"Cod Fiscal",oFont10 )
	oPrint:Say (nLinha,3000,"Custo Total",oFont10 )
	oPrint:Say (nLinha,3250,"Custo Unit",oFont10 )
	oPrint:Say (nLinha+10,0010,"|_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|",oFont9n )
	nLinha += 90
	// loop de dados do boleto
	for nFor := 1 to len(aRel)
		IF nLinha >= 1800
			oPrint:EndPage()
			oPrint:StartPage()
			nLinha := 90
			oPrint:Say (nLinha,0020,"Data",oFont10 )
			oPrint:Say (nLinha,0140,"Codigo",oFont10 )
			oPrint:Say (nLinha,0380,"Descri็ใo",oFont10 )
			oPrint:Say (nLinha,1040,"Quantidade",oFont10 )
			oPrint:Say (nLinha,1260,"Doc",oFont10 )
			oPrint:Say (nLinha,1410,"Custo",oFont10 )
			oPrint:Say (nLinha,1600,"Doc Compl",oFont10 )
			oPrint:Say (nLinha,1800,"Custo Compl",oFont10 )
			oPrint:Say (nLinha,2050,"Moeda",oFont10 )
			oPrint:Say (nLinha,2200,"Tx Moeda2",oFont10 )
			oPrint:Say (nLinha,2400,"Tx Moeda4",oFont10 )
			oPrint:Say (nLinha,2600,"Tx Moeda5",oFont10 )
			oPrint:Say (nLinha,2800,"Cod Fiscal",oFont10 )
			oPrint:Say (nLinha,3000,"Custo Total",oFont10 )
			oPrint:Say (nLinha,3250,"Custo Unit",oFont10 )
			oPrint:Say (nLinha+10,0010,"|_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________|",oFont9n )
			nLinha += 90
		ENDIF
		oPrint:Say (nLinha,0020,dtoc(stod(aRel[nFor][1])),oFont9 )
		oPrint:Say (nLinha,0140,aRel[nFor][2],oFont9 )
		oPrint:Say (nLinha,0380,aRel[nFor][3],oFont9 )
		oPrint:Say (nLinha,1040,cValToChar(aRel[nFor][4]),oFont9 )
		oPrint:Say (nLinha,1260,aRel[nFor][15],oFont9 )
		oPrint:Say (nLinha,1410,alltrim(transform(aRel[nFor][5],"@E 999,999,999,999.9999")),oFont9 )
		oPrint:Say (nLinha,1600,aRel[nFor][16],oFont9 )
		oPrint:Say (nLinha,1800,alltrim(transform(aRel[nFor][13],"@E 999,999,999,999.9999")),oFont9 )
		oPrint:Say (nLinha,2050,cValToChar(aRel[nFor][6]),oFont9 )
		oPrint:Say (nLinha,2200,cValToChar(aRel[nFor][8]),oFont9 )
		oPrint:Say (nLinha,2400,cValToChar(aRel[nFor][9]),oFont9 )
		oPrint:Say (nLinha,2600,cValToChar(aRel[nFor][10]),oFont9 )
		oPrint:Say (nLinha,2800,aRel[nFor][11],oFont9 )
		oPrint:Say (nLinha,3010,alltrim(transform(aRel[nFor][12],"@E 999,999,999,999.99")),oFont9 )
		oPrint:Say (nLinha,3260,alltrim(transform(aRel[nFor][14],"@E 999,999,999,999.99")),oFont9 )
		nLinha	+= 40
	Next nFor
	// Finaliza a pแgina
	oPrint:EndPage()
	oPrint:Preview()     // Visualiza antes de imprimir
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELCUSTO  บAutor  ณMicrosiga           บ Data ณ  08/27/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION IMPEXCEL(aRel)

	Local nLinha	:= 0
	Local nTot		:= 0
	Local oPrint	:= NIL
	lOCAL cNome		:= DTOS(DATE())+STRTRAN(TIME(),':','')
	Local cPath := cGetFile("","Local para grava็ใo...",1,,.F.,GETF_LOCALHARD + GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY ) //
	Local cArqPesq := cPath +cNome+ ".xls"	// Exemplo: PQ123456.xls
	Local cTabela	:= ""
	Local aXLS2		:= {}
	Local nFor := 0
	cNome :=cNome + ".xls"
	nHandle := FCREATE(cArqPesq, 0)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria um arquivo do tipo *.xls                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cTabela := "<table border=1>"
	cTabela += "<tr><td BGCOLOR='#FF0000'><b>DATA</b> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>CODIGO</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>DESCRIวรO</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>QUANTIDADE</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>DOC</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>CUSTO</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>DOC COMPL</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>CUSTO COMPL</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>MOEDA</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>TX MOEDA2</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>TX MOEDA4</B> </td>"
	cTabela += "<td BGCOLOR='#FF0000'><B>TX MOEDA5</B> </td>"
	cTabela	+= "<td BGCOLOR='#FF0000'><B>COD FISCAL</B> </td>"
	cTabela	+= "<td BGCOLOR='#FF0000'><B>CUSTO TOTAL</B> </td>"
	cTabela	+= "<td BGCOLOR='#FF0000'><B>CUSTO UNIT</B> </td></tr>"
	// loop de dados do boleto
	for nFor := 1 to len(aRel)
		cTabela	+=	"<tr><td>" + dtoc(stod(aRel[nFor][1])) + "</td>"
		cTabela +=	"<td>" + aRel[nFor][2] + "</td>"
		cTabela +=	"<td>" + aRel[nFor][3] + "</td>"
		cTabela +=	"<td>" + STRTRAN(cValToChar(aRel[nFor][4]),'.','') + "</td>"
		cTabela +=	"<td>'" + STRTRAN(cValToChar(aRel[nFor][15]),'.','') + "</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][5],"@E 999,999,999,999.9999")) + "</td>"
		cTabela +=	"<td>" + IIF(EMPTY(aRel[nFor][16]),'',"'"+aRel[nFor][16]) + "</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][13],"@E 999,999,999,999.9999")) + "</td>"
		cTabela +=	"<td>" + cValToChar(aRel[nFor][6]) + "</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][7],"@E 99.9999")) + "</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][9],"@E 99.9999")) + "</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][10],"@E 99.9999")) + "</td>"
		cTabela +=	"<td>" + aRel[nFor][11] + "</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][12],"@E 999,999,999,999.99"))+"</td>"
		cTabela +=	"<td>" + alltrim(transform(aRel[nFor][14],"@E 999,999,999,999.99"))+"</td></tr>"
		aadd(aXLS2,cTabela)
		cTabela := ""
	Next nFor

	for nFor := 1 to len(aXLS2)
		If(FWRITE(nHandle, aXLS2[nFor]) == 0)
			Alert("Nใo foi possํvel gravar o arquivo!")	 //
		EndIf
	next nFor

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha o arquivo gravado                                                          	ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	FCLOSE(nHandle)

	If MsgYesNo("O arquivo foi gerado no diret๓rio "+cArqPesq+". ") //
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Abre Excel                                                                       	ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If ApOleClient( 'MsExcel' )
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cArqPesq ) // Abre uma planilha
			oExcelApp:SetVisible(.T.)
		Else
			Alert( "Microsoft Excel nao encontrado !" )	 //
		EndIf
	ENDIF    // Visualiza antes de imprimir
Return()

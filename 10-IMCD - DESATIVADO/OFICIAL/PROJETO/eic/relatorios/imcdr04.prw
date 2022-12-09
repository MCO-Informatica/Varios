#INCLUDE "topconn.ch"
#INCLUDE "SHELL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PARMTYPE.CH"

#DEFINE IMP_SPOOL 2

User Function IMCDR04(cFilPO,cNumPO,lJob)

	Local aArea := GetArea()
	Local cPath    := "C:\TEMP\"
	Local lViewPDF	:= .T.
	Local lExistePO := .F.
	Private lAdjustToLegacy := .F.
	Private lDisableSetup  := .F.

	Private oPrn

//Fontes
	Private oFont0 := TFont():New( "Arial",,07,,.F.,,,,,.F.)
	Private oFont0N := TFont():New( "Arial",,07,,.T.,,,,,.F.)
	Private oFont1 := TFont():New( "Arial",,08,,.F.,,,,,.F.)
	Private oFont1N := TFont():New( "Arial",,08,,.T.,,,,,.F.)
	Private oFont2 := TFont():New( "Arial",,10,,.F.,,,,,.F.)
	Private oFont2N := TFont():New( "Arial",,10,,.T.,,,,,.F.)
	Private oFont3 := TFont():New( "Arial"  ,,12,,.F.,,,,,.F.)
	Private oFont3N := TFont():New( "Arial" ,,12,,.T.,,,,,.F.)
	Private oFont4 := TFont():New( "Arial"  ,,14,,.F.,,,,,.F.)
	Private oFont4N := TFont():New( "Arial" ,,14,,.T.,,,,,.F.)
	Private oFont5N := TFont():New( "Arial" ,,18,,.T.,,,,,.F.)
	Private oFont6NS := TFont():New("Arial",12,14,.T.,.T.,,,,,.T.)

	Private	nCol1	:=	0010
	Private	nCol2	:=	0150
	Private	nCol3	:=	0310
	Private	nCol4	:=	0330
	Private	nCol5	:=	0200
	Private	nCol6	:=	0400
	Private	nCol7	:=	0470
	Private	nCol8	:=	0440
	Private	nCol9	:=	0690
	Private	nCol10	:=	730
	Private nMargDir	:= 	580
	Private nCentroPag	:=	280
	Private nPulaLin := 12
	Private cFabr := ""
	Private nLinha := 0

	Default cFilPO := cFilant
	Default cNumPO := SW2->W2_PO_NUM
	Default lJob := .F.

	cNumPO := alltrim(cNumPO)

	IF EMPTY( cNumPO )
		cFilePrint	:= "Purchase_Order"+Dtos(MSDate())+StrTran(Time(),":","")+'.pdf'
	ELSE
		cFilePrint	:= "Purchase_Order_"+Alltrim(cNumPO)+"_"+Dtos(MSDate())+StrTran(Time(),":","")+'.pdf'
	ENDIF

	If lJob
		cPath := "\PO\"
		lDisableSetup := .T.
		lViewPDF := .F.
	Endif

	If oPrn == Nil

		oPrn  := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy,cPath, lDisableSetup, , , , , , .F., )

		MAKEDIR(cPath)

		oPrn:SetPortrait()
		oPrn:SetPaperSize(DMPAPER_A4)

		oPrn:SetMargin(30,30,30,30)
		oPrn:cPathPDF := cPath
		oPrn:lServer := .T.
		oPrn:nDevice := IMP_PDF
		oPrn:lViewPDF := lViewPDF

		if oPrn:Canceled()
			alert("Relatorio Cancelado!!!")
			Return()
		Endif

	EndIf

	If Select("WK_SW2") > 0
		WK_SW2->( dbCloseArea() )
	EndIf

	cQueryP := " select SW2.W2_PO_NUM , SW2.W2_CONSIG, W2_REFCLI, SW2.W2_INCOTER, SW2.W2_FOB_TOT, SW2.W2_FRETEiN, SW2.W2_MOEDA,SW2.W2_PESO_B ,W3_DT_EMB, X5.X5_DESCENG TPTRANS,  "
	cQueryP += " SW2.W2_NR_ALTE, SW2.W2_DT_ALTE, SW2.W2_COMPL_I, SW2.W2_COD_MSG, "
	cQueryP += " SY9.Y9_DESCR, SY9.Y9_CIDADE, SY9.Y9_ESTADO, W3_FABR, W3_COD_I, SW3.W3_QTDE, B1_DESC, X5FIN.X5_DESCENG AS DESCFIN, B1_UM, B1_CASNUM, W3_PRECO, Y6_DESC_I, W2_OBS,  "
	cQueryP += " SYTCON.YT_NOME, SYTCON.YT_ENDE, SYTCON.YT_NR_END, SYTCON.YT_BAIRRO, SYTCON.YT_CEP, SYTCON.YT_CIDADE, SYTCON.YT_ESTADO, SYTCON.YT_CGC, W3_UM ,     "
	cQueryP += " SA2FOR.A2_NOME, SA2FOR.A2_END , SA2FOR.A2_COMPLEM, SA2FOR.A2_MUN, SA2FOR.A2_PAIS, Y9ORIG.Y9_DESCR AS DESCORIG, Y9DEST.Y9_DESCR AS DESCDEST, "
	cQueryP += " SA2FABR.A2_NOME AS NOMEFAB, SA2FABR.A2_END ENDFAB , SA2FABR.A2_COMPLEM COMPFAB, SA2FABR.A2_MUN MUNFAB, SA2FABR.A2_PAIS PAISFAB,   "
	cQueryP += " SYTIMP.YT_NOME AS IMPORT, SYTIMP.YT_ENDE AS ENDE_IMP, SYTIMP.YT_NR_END AS NR_END_IMP, SYTIMP.YT_BAIRRO AS BAIRRO_IMP, SYTIMP.YT_CEP AS CEP_IMP, SYTIMP.YT_CIDADE AS CID_IMP, SYTIMP.YT_ESTADO AS EST_IMP, SYTIMP.YT_PAIS AS PAIS_IMP , Z2_DESC_I  "
	cQueryP += " from "+RetSqlName("SW2")+" SW2 "
	cQueryP += " LEFT JOIN "+RetSqlName("SYT")+" SYTCON ON SW2.W2_CONSIG = SYTCON.YT_COD_IMP  AND SYTCON.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SA2")+" SA2FOR ON SW2.W2_FORN = SA2FOR.A2_COD    AND SW2.W2_FORLOJ = SA2FOR.A2_LOJA AND SA2FOR.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SY6")+" SY6 ON SW2.W2_COND_PA = SY6.Y6_COD    AND SY6.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SYT")+" SYTIMP ON SW2.W2_IMPORT = SYTIMP.YT_COD_IMP    AND SYTIMP.D_E_L_E_T_ <> '*'  "
	cQueryP += " LEFT JOIN "+RetSqlName("SW3")+" SW3 ON SW2.W2_PO_NUM = SW3.W3_PO_NUM  AND SW3.D_E_L_E_T_ <> '*' AND SW2.W2_FILIAL = SW3.W3_FILIAL "
	cQueryP += " LEFT JOIN "+RetSqlName("SA2")+" SA2FABR ON SW3.W3_FABR = SA2FABR.A2_COD   AND SW3.W3_FABLOJ= SA2FABR.A2_LOJA   AND SA2FABR.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SYQ")+" SYQ ON SYQ.YQ_VIA = SW2.W2_TIPO_EM   AND SYQ.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SX5")+" X5 ON X5.X5_FILIAL = SW2.W2_FILIAL AND X5.X5_TABELA = 'Y3' AND SUBSTRING(X5.X5_CHAVE,0,1) = SUBSTRING(YQ_COD_DI,0,1)   AND X5.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SX5")+" X5FIN ON X5FIN.X5_FILIAL = SW2.W2_FILIAL AND X5FIN.X5_TABELA = 'Z1' AND SUBSTRING(X5FIN.X5_CHAVE,0,1) = SUBSTRING(SW2.W2_XFINA,0,1)    AND X5FIN.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SYR")+" SYR ON SYR.YR_VIA = SW2.W2_TIPO_EM AND SW2.W2_ORIGEM = SYR.YR_ORIGEM AND SW2.W2_DEST = SYR.YR_DESTINO   AND SYR.D_E_L_E_T_ <> '*'  "
	cQueryP += " LEFT JOIN "+RetSqlName("SY9")+" SY9 ON SY9.Y9_SIGLA = SYR.YR_DESTINO   AND SY9.D_E_L_E_T_ <> '*' "
	cQueryP += " left join "+RetSqlName("SB1")+" SB1 ON SW3.W3_COD_I = SB1.B1_COD  AND SB1.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SZ2")+" SZ2 ON SZ2.Z2_COD = SB1.B1_EMB  AND SZ2.D_E_L_E_T_ <> '*' "
	cQueryP += " LEFT JOIN "+RetSqlName("SY9")+" Y9ORIG ON SYR.YR_ORIGEM = Y9ORIG.Y9_SIGLA   AND Y9ORIG.D_E_L_E_T_ <> '*'     "
	cQueryP += " LEFT JOIN "+RetSqlName("SY9")+" Y9DEST ON SYR.YR_DESTINO = Y9DEST.Y9_SIGLA     AND Y9DEST.D_E_L_E_T_ <> '*' "
	cQueryP += " WHERE SW2.W2_PO_NUM = '" + cNumPO + "' AND SW3.W3_SEQ = '1' "


	TCQUERY Changequery(cQueryP) NEW ALIAS "WK_SW2"

	DbSelectArea("WK_SW2")
	DbGotop()

	While WK_SW2->(!EOF())

		oPrn:StartPage()

//Primeira entrada
		If Empty(cFabr)
			nLin := PRINTCABEC(1)

			nLin := PRINTCABEC(2)

			nLin:= PRINTCABEC (3)

		Endif

		//Caso troque o fabricante, necessario novo box de fabricante.
		iF cFabr == WK_SW2->W3_FABR .or. Empty(cFabr)

			nLin:= PRINTCABEC(4)
			cFabr:= WK_SW2->W3_FABR

		Else
			nLin += nPulaLin
			nLin := PRINTCABEC(3)
			nLin:= PRINTCABEC (4)
			cFabr:= WK_SW2->W3_FABR

		Endif

		lExistePO := .T.

		WK_SW2->(dbSkip())

//caso tenham encerrado os registros 
		If WK_SW2->(EOF())

			WK_SW2->(	DbGotop() )
			nLin:= PRINTCABEC (5)
			EXIT

		Endif

		If nLin > 760 .and. WK_SW2->(!EOF())
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
		Endif

	Enddo

	DbSelectArea("WK_SW2")
	DbGotop()

	if lExistePO

		PRINTRODAPE()
		oPrn:EndPage()

		IF lJob
			File2Printer( CPATH +cFilePrint, "PDF" )
			oPrn:cPathPDF:= CPATH
		ENDIF

		oPrn:Preview()

	Endif

	FreeObj(oPrn)
	oPrn := Nil

	WK_SW2->(Dbclosearea())

	RestArea(aArea)


	if lJob
		Return({cPath,cFilePrint})
	Endif

Return


Static Function PRINTCABEC( nTipo )
	Local cStartPath := GetSrvProfString("Startpath","")
	Local aMeses:= {"January","February","March","April","May","June","July","August","September","October","November","December"}
	Local nX := 0
	Default nTipo := 1

	if nTipo == 1
		nLin := 20
		oPrn:SayBitmap(nLin, nCol1 ,cStartPath+"FLWIMCDLG.bmp", 090, 0030)    //LOGO DA EMPRESA

		//BOX 1
		nLin += 40
		nLinBox := nLin
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += 15
		nLin += nPulaLin/2
		oPrn:Say(nLin,nCol1+5, "PURCHASE ORDER: " +WK_SW2-> W2_PO_NUM ,oFont5N,100)
		if WK_SW2->W2_NR_ALTE > 0

			oPrn:Say(nLin,nCol3, "Version ("+alltrim(str(WK_SW2->W2_NR_ALTE))  + "): " + alltrim(dtoc(stod(WK_SW2->W2_DT_ALTE)))  ,oFont3N,100)

		Endif

		oPrn:Say(nLin,nCol8, "Date: " + dtoc(date()),oFont5N,100)
		nLin+= 5
		nLin += nPulaLin/2
		oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
		oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

	Endif

	if nTipo == 2
		//BOX 2
		nLin += nPulaLin
		nLinBox := nLin
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += nPulaLin
		nLin += nPulaLin/2
		oPrn:Say(nLin,nCol1+5, "Buyer: " ,oFont3N,100)
		oPrn:Say(nLin,nCol2, "Customer's Order: " + WK_SW2->W2_REFCLI,oFont3N,100)
		oPrn:Say(nLin,nCol3, "Supplier (Exporter): " ,oFont3N,100)

		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5,WK_SW2->YT_NOME ,oFont3,100)
		oPrn:Say(nLin,nCol3, WK_SW2->A2_NOME ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, alltrim(WK_SW2->YT_ENDE) + " , " + alltrim(str(WK_SW2->YT_NR_END)) ,oFont3,100)
		oPrn:Say(nLin,nCol3, "" ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, alltrim(WK_SW2->YT_BAIRRO) + " - " + alltrim(WK_SW2->YT_CEP) ,oFont3,100)
		oPrn:Say(nLin,nCol3, WK_SW2->A2_END ,oFont3,100)
		nLin += nPulaLin
//	oPrn:Say(nLin,nCol1+5, + WK_SW2->YT_CIDADE + WK_SW2->YT_ESTADO + WK_SW2->YA_DESCR ,oFont3,100)
		oPrn:Say(nLin,nCol1+5,  alltrim(WK_SW2->YT_CIDADE) + alltrim(WK_SW2->YT_ESTADO) ,oFont3,100)
		oPrn:Say(nLin,nCoL3, "" ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, "CNPJ:" +  WK_SW2->YT_CGC ,oFont3,100)
		oPrn:Say(nLin,nCol3, alltrim(WK_SW2->A2_COMPLEM) + alltrim(WK_SW2->A2_MUN) + ;
			ALLTRIM(GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+WK_SW2->A2_PAIS,1))  ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, "" ,oFont3,100)
		oPrn:Say(nLin,nCol3, "" ,oFont3,100)

		nLin += nPulaLin
		oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
		oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

	Endif

	if nTipo == 3
//BOX 3

		If nLin > 760 .and. WK_SW2->(!EOF())
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		nLin += nPulaLin
		nLinBox := nLin
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += nPulaLin
		nLin += nPulaLin/2
		oPrn:Say(nLin,nCol1+5, "Manufacturer: "  ,oFont3N,100)
		oPrn:Say(nLin,nCol1+70, WK_SW2->NOMEFAB ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, "Address: "  ,oFont3N,100)
		oPrn:Say(nLin,nCol1+50, 	Alltrim(WK_SW2->ENDFAB) + " - "+ alltrim(WK_SW2->COMPFAB) + " - "+ alltrim(WK_SW2->MUNFAB);
			+ " - "+  ALLTRIM(GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+WK_SW2->PAISFAB,1)) ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, "Origin: " ,oFont3N,100)
		oPrn:Say(nLin,nCol1+40,  ALLTRIM(GetAdvFVal("SYA","YA_PAIS_I",xFilial("SYA")+WK_SW2->PAISFAB,1))  ,oFont3,100)
		nLin += nPulaLin
		oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
		oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

	Endif
//BOX 4
	if nTipo == 4

		If nLin > 760 .and. WK_SW2->(!EOF())
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif


		nLinBox := nLin
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += nPulaLin
		nLin += nPulaLin/2
		oPrn:Say(nLin,nCol1+5, "Product: " ,oFont3N,100)
		oPrn:Say(nLin,nCol1+50, WK_SW2->B1_DESC ,oFont3,100)
		oPrn:Say(nLin,nCol3+50, "Packing: " ,oFont3N,100)
		oPrn:Say(nLin,nCol3+90, ALLTRIM(WK_SW2->Z2_DESC_I) ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+5, "Quantity: " ,oFont3N,100)
		oPrn:Say(nLin,nCol1+50, ALLTRIM(Transform(WK_SW2->W3_QTDE, AvSx3("W3_QTDE",6))) + "  " + WK_SW2->B1_UM,oFont3,100)
		oPrn:Say(nLin,nCol5, "Unit Price: "+ WK_SW2->W2_MOEDA ,oFont3N,100)
		oPrn:Say(nLin,nCol5+70, ALLTRIM(Transform(WK_SW2->W3_PRECO, AvSx3("W3_PRECO",6))) ,oFont3,100)
		oPrn:Say(nLin,nCol8, "CAS: " ,oFont3N,100)
		oPrn:Say(nLin,nCol8+25, WK_SW2->B1_CASNUM  ,oFont3,100)
		nLin += nPulaLin
		oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
		oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
	Endif


	if nTipo == 5
//BOX 5
		If nLin > 760 .and. WK_SW2->(!EOF())
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		nLin += nPulaLin
		nLinBox := nLin
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += nPulaLin +5
		oPrn:Say(nLin+5,nCol1+50, "Values in ( "+ WK_SW2->W2_MOEDA+ " )" ,oFont5N,100)
		nLin += nPulaLin + 5
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

		nLin += nPulaLin

		If WK_SW2->W2_INCOTER $ "CFR/CPT/DAP"
			oPrn:Say(nLin,nCol1+5, "Total ( " + alltrim(WK_SW2->W2_COMPL_I) + "  )"  ,oFont3N,100)
		Else
			oPrn:Say(nLin,nCol1+5, "Total (   )"  ,oFont3N,100)
		endif

		oPrn:Say(nLin,nCol3, ALLTRIM(Transform(WK_SW2->W2_FOB_TOT, AvSx3("W2_FOB_TOT",6)))   ,oFont3N,100)
		nLin += nPulaLin
		nLin += nPulaLin/2

		IF WK_SW2->W2_FRETEiN > 0
			oPrn:Say(nLin,nCol1+5, "Freight ( " + alltrim(WK_SW2->TPTRANS)+ "  ) "  ,oFont3N,100)
			oPrn:Say(nLin,nCol3, ALLTRIM(Transform(WK_SW2->W2_FRETEIN, AvSx3("W2_FRETEiN",6)))   ,oFont3N,100)
			nLin += nPulaLin
		Endif

		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += nPulaLin

		oPrn:Say(nLin,nCol1+5, "Total ( " + WK_SW2->W2_INCOTER + "  "+ alltrim( WK_SW2->Y9_CIDADE) + "  ) ===>>>"  ,oFont3N,100)
		oPrn:Say(nLin,nCol3, ALLTRIM(Transform(WK_SW2->W2_FOB_TOT, AvSx3("W2_FOB_TOT",6)))   ,oFont3N,100)
		nLin += nPulaLin

		oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
		oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

//Box 6
		If nLin > 760 .and. WK_SW2->(!EOF())
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		nLin += nPulaLin
		nLinBox := nLin
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
		nLin += nPulaLin
		nLin += nPulaLin/2
		oPrn:Say(nLin,nCol1+25, "Area: "  ,oFont3N,100)
		oPrn:Say(nLin,nCol2, "DIVISION " + WK_SW2->DESCFIN ,oFont3N,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+25, "Payment: " ,oFont3N,200, , ,1)
		oPrn:Say(nLin,nCol2, ALLTRIM(MSMM( WK_SW2->Y6_DESC_I, 100)) ,oFont3,100)
		nLin += nPulaLin
		nLin += nPulaLin / 2
		oPrn:Say(nLin,nCol1+25, "Document: " ,oFont3N,100, , ,1)
		oPrn:Say(nLin,nCol2, WK_SW2->IMPORT  ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol2, ALLTRIM(WK_SW2->ENDE_IMP) + ALLTRIM(WK_SW2->NR_END_IMP) + ALLTRIM(WK_SW2->BAIRRO_IMP),oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol2,ALLTRIM(WK_SW2->CEP_IMP) +" " + ALLTRIM(WK_SW2->CID_IMP) + " - " + ALLTRIM(WK_SW2->EST_IMP)+ " - " +ALLTRIM(WK_SW2->PAIS_IMP) ,oFont3,100)
		nLin += nPulaLin
		nLin += nPulaLin / 2
		oPrn:Say(nLin,nCol1+25, "Agent Commission: " ,oFont3N,300, , ,2)
		oPrn:Say(nLin,nCol2, "0,00 % - US$ 0,00" ,oFont4N,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol2, "No agent commission" ,oFont3,100)
		nLin += nPulaLin
		nLin += nPulaLin / 2
		oPrn:Say(nLin,nCol1+25, "Lot: " ,oFont3N,100, , ,1)
		oPrn:Say(nLin,nCol2, "SHIPMENT SCHEDULE BELOW " ,oFont3,100)
		nLin += nPulaLin

		If DAY(CTOD(WK_SW2->W3_DT_EMB)) <= 10
			cText:= ALLTRIM(Transform(WK_SW2->W3_QTDE, AvSx3("W3_QTDE",6)))+ " " + WK_SW2->B1_UM +  " Beginning of "  +  aMeses[val(substr(WK_SW2->W3_DT_EMB,5,2) )]
		Elseif DAY(CTOD(WK_SW2->W3_DT_EMB)) >= 21
			cText:= ALLTRIM(Transform(WK_SW2->W3_QTDE, AvSx3("W3_QTDE",6)))+ " " + WK_SW2->B1_UM +  " End of " + aMeses[val(substr(WK_SW2->W3_DT_EMB,5,2) )]
		Else
			cText:= ALLTRIM(Transform(WK_SW2->W3_QTDE, AvSx3("W3_QTDE",6)))+ " " + WK_SW2->B1_UM +  " Middle of " + aMeses[val(substr(WK_SW2->W3_DT_EMB,5,2) )]
		Endif
		oPrn:Say(nLin,nCol2, cText ,oFont3,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol2, " " ,oFont3,100)
		nLin += nPulaLin
		nLin += nPulaLin / 2
		oPrn:Say(nLin,nCol1+25, "Delivery: " ,oFont3N,100, , ,1)
		oPrn:Say(nLin,nCol2, ALLTRIM(WK_SW2->DESCFIN)  + " TO "+ alltrim( WK_SW2->DESCDEST) + " IN "+ ALLTRIM(WK_SW2->Y9_CIDADE) + " / "  + WK_SW2->Y9_ESTADO  ,oFont6NS,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol2, "ATTENTION: PLEASE WAIT FOR OUR FINAL SHIPPING INSTRUCTIONS" ,oFont6NS,100)
		nLin += nPulaLin
		oPrn:Say(nLin,nCol2, "BEFORE EFFECTING SHIPMENT." ,oFont6NS,100)
		nLin += nPulaLin
		nLin += nPulaLin / 2
		oPrn:Say(nLin,nCol1+25, "Marks: " ,oFont3N,100, , ,1)
		oPrn:Say(nLin,nCol2,"BUYER'S FULL NAME ADDRESS."  ,oFont3,100)
		nLin += nPulaLin

		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

		If nLin > 760 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		nLin += nPulaLin
		oPrn:Say(nLin,nCol1+25, "Observations: " ,oFont3N,100, , ,1)
		IF !EMPTY(WK_SW2->W2_COD_MSG)
			cMemoW2 := MSMM(WK_SW2->W2_OBS, 100)

			For nX := 1  to mlCount(cMemoW2,100)
				oPrn:Say(nLin,nCol2, MemoLine(cMemoW2,100,nX) ,oFont3,100)
				nLin += nPulaLin

				If nLin > 800 .and. WK_SW2->(!EOF())
					oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
					oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
					oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
					PRINTRODAPE()
					oPrn:EndPage()
					oPrn:StartPage()
					nLin := PRINTCABEC(1)
					nLin += nPulaLin
				Endif
			Next nX

		Endif

		oPrn:Say(nLin,nCol2, "- CONSIGN TO CUSTOMER. " ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif


		oPrn:Say(nLin,nCol2, "- MATERIAL MUST BE FROM FRESH BATCH PRODUCTION ( >= 70% OF SHELF LIFE) " ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		oPrn:Say(nLin,nCol2, "- MANDATORY:  PACKAGES HAVE TO BE LABELED WITH INTERNAL/EXTERNAL" ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		oPrn:Say(nLin,nCol2, "LABELS CONTAINING: COMPLETE NAME/ ADDRESS OF PRODUCER AND EXPORTER" ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		oPrn:Say(nLin,nCol2, "NAME OF PRODUCT; LOT NR; QUANTITY; PRODUCE AND EXPIRE DATE" ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		oPrn:Say(nLin,nCol2, "TEMPERATURE OF STORAGE IN �C; LUMINOSITY AND HUMIDITY." ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		oPrn:Say(nLin,nCol2, "- CERTIFICATE OF ANALYSIS IS REQUIRED FOR APPROVAL PRIOR TO SHIPMENT" ,oFont3,100)
		nLin += nPulaLin

		If nLin > 800 .and. WK_SW2->(!EOF())
			oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
			oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
			oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")
			PRINTRODAPE()
			oPrn:EndPage()
			oPrn:StartPage()
			nLin := PRINTCABEC(1)
			nLin += nPulaLin
		Endif

		oPrn:Say(nLin,nCol2, "CERTIFICATE OF ANALYSIS MUST BE ISSUED ON MANUFACTURER LETTERHEAD " ,oFont3,100)
		nLin += nPulaLin


		oPrn:Line( nLinBox, nCol1, nLin, nCol1, 0, "-1")
		oPrn:Line( nLinBox, nMargDir, nLin, nMargDir, 0, "-1")
		oPrn:Line( nLin, nCol1, nLin, nMargDir, 0, "-1")

	Endif
//nLin += 15

RETURN(nLin)


Static Function PRINTRODAPE()

	cEnd := Capital(Alltrim(SM0->M0_ENDENT)+" - "+Alltrim(SM0->M0_COMPENT))
	cEnd += " - CEP: "+SM0->M0_CEPENT+" - "+CAPITAL(Alltrim(SM0->M0_CIDENT))
	cEnd += " - "+SM0->M0_ESTENT

	cEnd2 := "Tel: "+SM0->M0_TEL
	cEnd2 +=" - C.N.P.J. "+Transform(SM0->M0_CGC,"@r 99.999.999/9999-99")
	cEnd2 +=" - I.E. "+Transform(SM0->M0_INSC,"@r 999.999.999.99")

	nLin:= 818
	oPrn:Say( nLin ,nCol2, cEnd,oFont0,100)
	nLin += 10
	oPrn:Say( nLin ,nCol2+25,cEnd2,oFont0,100)

Return()

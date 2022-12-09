#include "protheus.ch"
#include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MKOMS003 ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 27/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exporta o layout PROCEDA NOTFIS                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³Solic.³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fabricio    ³27/05/11³000000³Implementacao                             ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MKOMS003()
	Local aPergs  := {}
	Local aResp   := {}
	Local cSql    := ""

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MKOMS003" , __cUserID )

	Private cTitulo  := "Exportação do arquivo NOTFIS"
	Private cCodTran := ""
	Private cLojTran := ""

	cCodTran := AllTrim(GetMv("MV_MKCODMI"))
	If Empty(cCodTran)
		MsgAlert("Parametro MV_MKCODMI não preenchido.", cTitulo)
		Return
	EndIf

	cLojTran := AllTrim(GetMv("MV_MKLOJMI"))
	If Empty(cLojTran)
		MsgAlert("Parametro MV_MKCODMI não preenchido.", cTitulo)
		Return
	EndIf

	cSql := "SELECT "
	cSql += "  'X' "
	cSql += "FROM "
	cSql += "  " + RetSqlName("DAK") + " DAK JOIN " + RetSqlName("DAI") + " DAI ON "
	cSql += "  	 DAK.DAK_FILIAL = '" + xFilial("DAK") + "'           AND "
	cSql += "  	 DAI.DAI_FILIAL = '" + xFilial("DAI") + "'           AND "
	cSql += "  	 DAK.D_E_L_E_T_ = ' '            AND "
	cSql += "  	 DAI.D_E_L_E_T_ = ' '            AND "
	cSql += "    DAK.DAK_COD    = DAI.DAI_COD    AND "
	cSql += "    DAI.DAI_SEQCAR = DAI.DAI_SEQCAR "
	cSql += "WHERE "
	cSql += "  DAK.DAK_PEDFRE <> '" + Space(Len(DAK->DAK_PEDFRE)) + "' AND "
	cSql += "  DAI.DAI_NFISCA =  '" + Space(Len(DAI->DAI_NFISCA)) + "'"
	TcQuery cSql New Alias "DAKVAL"

	aAdd(aPergs, {})
	aAdd(aPergs[Len(aPergs)], 6)	
	aAdd(aPergs[Len(aPergs)], "Caminho")	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], "@!S20")	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], 200)	
	aAdd(aPergs[Len(aPergs)], .F.)	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], "C:\")	
	aAdd(aPergs[Len(aPergs)],  GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY)
	If Parambox(aPergs, "Selecione a pasta...", @aResp)
		If (DAKVAL->(Eof()) .And. DAKVAL->(Bof())) .Or. MsgNoYes("Existem cargas que ainda não foram faturadas. Deseja desconsiderar estas e prosseguir?")
			Processa({|| ExpNotFis(AllTrim(aResp[1]))}, "Processando...")				
		EndIf
	EndIf
	DAKVAL->(DbCloseArea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MKOMS004 ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 27/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exporta o layout PROCEDA CONEMB                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Faturamento                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³Solic.³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fabricio    ³27/05/11³000000³Implementacao                             ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MKOMS004()
	Local aPergs := {}	
	Local aResp  := {}
	Private cTitulo   := "Importação do arquivo CONEMB"
	Private cCodTran  := ""
	Private cLojTran  := ""
	Private cProdFre1 := ""
	Private cProdFre2 := ""

	cCodTran := AllTrim(GetMv("MV_MKCODMI"))
	If Empty(cCodTran)
		MsgAlert("Parametro MV_MKCODMI não preenchido.", cTitulo)
		Return
	EndIf

	cLojTran := AllTrim(GetMv("MV_MKLOJMI"))
	If Empty(cLojTran)
		MsgAlert("Parametro MV_MKCODMI não preenchido.", cTitulo)
		Return
	EndIf

	cProdFre1 := AllTrim(GetMv("MV_MKPRFR1"))
	If Empty(cProdFre1)
		MsgAlert("Parametro MV_MKPRFR1 não preenchido.", cTitulo)
		Return
	EndIf

	cProdFre2 := AllTrim(GetMv("MV_MKPRFR2"))
	If Empty(cProdFre2)
		MsgAlert("Parametro MV_MKPRFR2 não preenchido.", cTitulo)
		Return
	EndIf

	aAdd(aPergs, {})
	aAdd(aPergs[Len(aPergs)], 6)	
	aAdd(aPergs[Len(aPergs)], "Arquivo")	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], "@!S20")	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], "")	
	aAdd(aPergs[Len(aPergs)], 200)	
	aAdd(aPergs[Len(aPergs)], .F.)	
	aAdd(aPergs[Len(aPergs)], "Arquivos .TXT | *.TXT")	
	aAdd(aPergs[Len(aPergs)], "C:\")	
	aAdd(aPergs[Len(aPergs)],  GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	If Parambox(aPergs, "Selecione o arquivo...", @aResp)
		Processa({|| ImpCONEMB(AllTrim(aResp[1]))}, "Processando...")
	EndIf

Return

Static Function ExpNotFis(cPath)
	Local aValores   := {}
	Local aValDES    := {}
	Local aValDNF    := {}
	Local aValDCN    := {}
	Local aLayout    := {}
	Local cArq       := ""
	Local cAux       := ""
	Local cSql       := ""
	Local cQuebraCli := ""
	Local cQuebraNf  := ""
	Local nHandle    := 0
	Local nValNf     := 0
	Local nPesNf     := 0
	Local nVolNf     := 0

	cArq    := "NOT" + StrTran(DtoC(dDataBase), "/", "") + StrTran(Left(Time(),5), ":", "") + "1.txt"
	nHandle := fCreate(cPath+cArq, 0)
	aLayout := RetLayout(1)

	ProcRegua(0)
	If nHandle == -1
		MsgStop("Erro na criação do arquivo " + cPath + cArq + ".", cTitulo)
	Else
		cSql := "SELECT "
		cSql += "  SA1.A1_NOME,   SA1.A1_CGC,     SA1.A1_INSCR,   SA1.A1_END,  SA1.A1_BAIRRO,  SA1.A1_MUN,     SA1.A1_CEP, "
		cSql += "  SA1.A1_EST,    SA1.A1_PESSOA,  SF2.F2_SERIE,   SF2.F2_DOC,  SF2.F2_EMISSAO, SF2.F2_VOLUME1, SF2.F2_VALBRUT, "
		cSql += "  SF2.F2_PBRUTO, SF2.F2_VALICM,  SF2.F2_CLIENTE, SF2.F2_LOJA, SC5.C5_SEGURO,  DAK.DAK_COD,    SC7.C7_TOTAL, "
		cSql += "  DA3.DA3_PLACA, SC5.C5_TPFRETE, SD2.D2_CF "
		cSql += "FROM "
		cSql += "  " + RetSqlName("DAK") + " DAK "
		cSql += "  JOIN "
		cSql += "  ( "
		cSql += "    SELECT DAI_COD, DAI_SEQCAR, DAI_NFISCA, DAI_SERIE "
		cSql += "    FROM " + RetSqlName("DAI") + " "
		cSql += "    WHERE D_E_L_E_T_ = ' ' AND DAI_FILIAL = '" + xFilial("DAI") + "' " 
		cSql += "    GROUP BY DAI_COD, DAI_SEQCAR, DAI_NFISCA, DAI_SERIE " 
		cSql += "  ) DAI1 ON "
		cSql += "    DAK.DAK_FILIAL  = '" + xFilial("DAK") + "'           AND "
		cSql += "    DAK.D_E_L_E_T_  = ' '            AND "
		cSql += "    DAI1.DAI_COD    = DAK.DAK_COD    AND "
		cSql += "    DAI1.DAI_SEQCAR = DAK.DAK_SEQCAR "
		cSql += "  JOIN "
		cSql += "  ( "
		cSql += "    SELECT DAI_NFISCA, DAI_SERIE, DAI_PEDIDO "
		cSql += "    FROM " + RetSqlName("DAI") + " "
		cSql += "    WHERE D_E_L_E_T_ = ' ' AND DAI_FILIAL = '" + xFilial("DAI") + "' " 
		cSql += "    GROUP BY DAI_NFISCA, DAI_SERIE, DAI_PEDIDO " 
		cSql += "  ) DAI2 ON " 
		cSql += "    DAI2.DAI_NFISCA = DAI1.DAI_NFISCA AND "
		cSql += "    DAI2.DAI_SERIE  = DAI1.DAI_SERIE "	
		cSql += "  JOIN "
		cSql += "  ( "
		cSql += "    SELECT C7_NUM, SUM(C7_TOTAL) C7_TOTAL "
		cSql += "    FROM " + RetSqlName("SC7") + " SC7 "
		cSql += "    WHERE D_E_L_E_T_ = ' ' AND C7_FILIAL = '" + xFilial("SC7") + "' " 
		cSql += "    GROUP BY C7_NUM " 
		cSql += "  ) SC7 ON "		
		cSql += "    SC7.C7_NUM = DAK.DAK_PEDFRE "
		cSql += "  JOIN "
		cSql += "  ( "
		cSql += "    SELECT D2_DOC, D2_SERIE, D2_CF "
		cSql += "    FROM " + RetSqlName("SD2") + " "
		cSql += "    WHERE D_E_L_E_T_ = ' ' AND D2_FILIAL = '" + xFilial("SD2") + "' AND D2_ITEM = '01' "  // Utilizar CFOP do primeiro item, definido pela Elaine e Daniel
		cSql += "  ) SD2 ON "		
		cSql += "    SD2.D2_DOC     = DAI1.DAI_NFISCA AND "
		cSql += "    SD2.D2_SERIE   = DAI1.DAI_SERIE "
		cSql += "  JOIN " + RetSqlName("DA3") + " DA3 ON "
		cSql += "    DA3.DA3_FILIAL  = '" + xFilial("DA3") + "'           AND "
		cSql += "    DA3.D_E_L_E_T_  = ' '            AND "
		cSql += "    DA3.DA3_COD     = DAK.DAK_CAMINH "
		cSql += "  JOIN " + RetSqlName("SC5") + " SC5 ON "
		cSql += "    SC5.C5_FILIAL  = '" + xFilial("SC5") + "'           AND "
		cSql += "    SC5.D_E_L_E_T_ = ' '            AND "
		cSql += "    SC5.C5_NUM     = DAI2.DAI_PEDIDO "
		cSql += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
		cSql += "  	 SF2.F2_FILIAL  = '" + xFilial("SF2") + "'           AND "
		cSql += "  	 SF2.D_E_L_E_T_ = ' '             AND "
		cSql += "    SF2.F2_DOC     = DAI1.DAI_NFISCA AND "
		cSql += "    SF2.F2_SERIE   = DAI1.DAI_SERIE "
		cSql += "  JOIN " + RetSqlName("SA1") + " SA1 ON "
		cSql += "  	 SA1.A1_FILIAL  = '" + xFilial("SA1") + "'           AND "
		cSql += "  	 SA1.D_E_L_E_T_ = ' '            AND "
		cSql += "    SA1.A1_COD     = SF2.F2_CLIENTE AND "
		cSql += "    SA1.A1_LOJA    = SF2.F2_LOJA "
		cSql += "WHERE "
		cSql += "  DAK.DAK_EXPEDI <> 'S' AND "
		cSql += "  DAK.DAK_PEDFRE <> '" + Space(Len(DAK->DAK_PEDFRE)) + "' AND "
		cSql += "  NOT EXISTS
		cSql += "	 ( "
		cSql += "   SELECT "
		cSql += "     'X' "
		cSql += "   FROM "
		cSql += "     " + RetSqlName("DAI") + " "
		cSql += "   WHERE "
		cSql += "     DAI_FILIAL = '" + xFilial("DAI") + "'           AND "
		cSql += "     D_E_L_E_T_ = ' '            AND "
		cSql += "     DAI_COD    = DAK.DAK_COD    AND "
		cSql += "     DAI_SEQCAR = DAK.DAK_SEQCAR AND "
		cSql += "     DAI_NFISCA = '" + Space(Len(DAI->DAI_NFISCA)) + "' "
		cSql += "  ) "
		cSql += "ORDER BY "
		cSql += "  DAK.DAK_COD, SF2.F2_CLIENTE, SF2.F2_LOJA, SF2.F2_DOC, SF2.F2_SERIE "
		TcQuery cSql New Alias "TMPF2"
		QSetField("TMPF2")

		If TMPF2->(Eof()) .And. TMPF2->(Bof())
			MsgAlert("Não existem cargas a serem exportadas.", cTitulo)
		Else
			IncProc("Gerando arquivo " + cArq + "...")
			aValores := {}
			aAdd(aValores, {"UNB", 1, {|| "000"}})
			aAdd(aValores, {"UNB", 2, {|| "IMCDBRASIL@IMCDBRASIL.COM.BR"}})
			aAdd(aValores, {"UNB", 3, {|| "transmili@transmilani.com.br"}})
			aAdd(aValores, {"UNB", 4, {|| StrTran(DtoC(dDataBase), "/", "")}})
			aAdd(aValores, {"UNB", 5, {|| StrTran(Left(Time(),5), ":", "")}})
			aAdd(aValores, {"UNB", 6, {|| "NOT" + StrTran(DtoC(dDataBase), "/", "") + StrTran(Left(Time(),5), ":", "") + "1"}})
			cAux := GeraReg("UNB", aLayout, aValores)
			FWrite(nHandle, cAux)

			IncProc("Gerando arquivo " + cArq + "...")
			aValores := {}
			aAdd(aValores, {"UNH", 1, {|| "310"}})
			aAdd(aValores, {"UNH", 2, {|| "NOTFI" + StrTran(DtoC(dDataBase), "/", "") + StrTran(Left(Time(),5), ":", "") + "1"}})
			cAux := GeraReg("UNH", aLayout, aValores)
			FWrite(nHandle, cAux)

			IncProc("Gerando arquivo " + cArq + "...")
			aValores := {}
			aAdd(aValores, {"DEM", 1, {|| "311"}})
			aAdd(aValores, {"DEM", 2, {|| SM0->M0_CGC}})
			aAdd(aValores, {"DEM", 3, {|| SM0->M0_INSC}})
			aAdd(aValores, {"DEM", 4, {|| SM0->M0_ENDCOB}})
			aAdd(aValores, {"DEM", 5, {|| SM0->M0_CIDCOB}})
			aAdd(aValores, {"DEM", 6, {|| SM0->M0_CEPCOB}})
			aAdd(aValores, {"DEM", 7, {|| SM0->M0_ESTCOB}})
			aAdd(aValores, {"DEM", 8, {|| StrTran(DtoC(dDataBase), "/", "")}})
			aAdd(aValores, {"DEM", 9, {|| SM0->M0_NOMECOM}})
			cAux := GeraReg("DEM", aLayout, aValores)
			FWrite(nHandle, cAux)

			aValDES := {}
			aAdd(aValDES, {"DES", 1, {|| "312"}})
			aAdd(aValDES, {"DES", 2, {|| TMPF2->A1_NOME}})
			aAdd(aValDES, {"DES", 3, {|| TMPF2->A1_CGC}})
			aAdd(aValDES, {"DES", 4, {|| TMPF2->A1_INSCR}})
			aAdd(aValDES, {"DES", 5, {|| TMPF2->A1_END}})
			aAdd(aValDES, {"DES", 6, {|| TMPF2->A1_BAIRRO}})
			aAdd(aValDES, {"DES", 7, {|| TMPF2->A1_MUN}})
			aAdd(aValDES, {"DES", 8, {|| TMPF2->A1_CEP}})
			aAdd(aValDES, {"DES", 10, {|| TMPF2->A1_EST}})
			aAdd(aValDES, {"DES", 13, {|| Iif(TMPF2->A1_PESSOA <> "F", "1", "2") }})

			aValDNF := {}
			aAdd(aValDNF, {"DNF", 1, {|| "313"}})
			aAdd(aValDNF, {"DNF", 2, {|| TMPF2->F2_CLIENTE + TMPF2->F2_LOJA + TMPF2->DAK_COD}})  // Verificar query
			aAdd(aValDNF, {"DNF", 4, {|| "1"}})
			aAdd(aValDNF, {"DNF", 7, {|| TMPF2->C5_TPFRETE}})
			aAdd(aValDNF, {"DNF", 8, {|| TMPF2->F2_SERIE}})
			aAdd(aValDNF, {"DNF", 9, {|| Right(TMPF2->F2_DOC,8)}})
			aAdd(aValDNF, {"DNF", 10, {|| TMPF2->F2_EMISSAO}})
			aAdd(aValDNF, {"DNF", 11, {|| "QUIMICOS"}})
			aAdd(aValDNF, {"DNF", 12, {|| "PALETE"}})  // Verificar Makeni B1_EMB - SZ2
			aAdd(aValDNF, {"DNF", 13, {|| StrTran(StrZero(TMPF2->F2_VOLUME1, 8, 2), ".", "")}})
			aAdd(aValDNF, {"DNF", 14, {|| StrTran(StrZero(TMPF2->F2_VALBRUT, 16, 2), ".", "")}})
			aAdd(aValDNF, {"DNF", 15, {|| StrTran(StrZero(TMPF2->F2_PBRUTO, 8, 2), ".", "")}})
			aAdd(aValDNF, {"DNF", 17, {|| Iif(TMPF2->F2_VALICM > 0, "S", "N")}})
			aAdd(aValDNF, {"DNF", 18, {|| Iif(TMPF2->C5_SEGURO > 0, "S", "N")}})
			aAdd(aValDNF, {"DNF", 19, {|| ""}})  // Verificar Makeni
			aAdd(aValDNF, {"DNF", 21, {|| StrTran(TMPF2->DA3_PLACA, "-", "")}})  // Verificar Makeni
			aAdd(aValDNF, {"DNF", 26, {|| StrTran(StrZero(TMPF2->C7_TOTAL, 16, 2), ".", "")}})  // Verificar Makeni
			aAdd(aValDNF, {"DNF", 30, {|| ""}})  // Verificar Makeni

			aValDCN := {}
			aAdd(aValDCN, {"DCN", 1, {|| "333"}})
			aAdd(aValDCN, {"DCN", 2, {|| TMPF2->D2_CF}})  // CFOP verificar Makeni
			aAdd(aValDCN, {"DCN", 3, {|| "0"}})
			aAdd(aValDCN, {"DCN", 9, {|| "S"}})			

			cQuebraCli := ""
			cQuebraNf	 := ""
			While !TMPF2->(Eof())
				If cQuebraCli <> TMPF2->DAK_COD + TMPF2->F2_CLIENTE + TMPF2->F2_LOJA
					IncProc("Gerando arquivo " + cArq + "...")
					cQuebraCli := TMPF2->DAK_COD + TMPF2->F2_CLIENTE + TMPF2->F2_LOJA
					cAux := GeraReg("DES", aLayout, aValDES)
					FWrite(nHandle, cAux)
				EndIf
				If cQuebraNf <> TMPF2->DAK_COD + TMPF2->F2_CLIENTE + TMPF2->F2_LOJA + TMPF2->F2_DOC + TMPF2->F2_SERIE
					IncProc("Gerando arquivo " + cArq + "...")
					nValNf += TMPF2->F2_VALBRUT
					nPesNf += TMPF2->F2_PBRUTO
					nVolNf += TMPF2->F2_VOLUME1
					cQuebraNf := TMPF2->DAK_COD + TMPF2->F2_CLIENTE + TMPF2->F2_LOJA + TMPF2->F2_DOC + TMPF2->F2_SERIE
					cAux := GeraReg("DNF", aLayout, aValDNF)
					FWrite(nHandle, cAux)

					cAux := GeraReg("DCN", aLayout, aValDCN)
					FWrite(nHandle, cAux)
				EndIf
				TMPF2->(DbSkip())
			End

			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial("SA2")+cCodTran+cLojTran))
			IncProc("Gerando arquivo " + cArq + "...")
			aValores := {}
			aAdd(aValores, {"RPF", 1, {|| "317"}})
			aAdd(aValores, {"RPF", 2, {|| SA2->A2_NOME}})
			aAdd(aValores, {"RPF", 3, {|| SA2->A2_CGC}})
			aAdd(aValores, {"RPF", 4, {|| SA2->A2_INSCR}})
			aAdd(aValores, {"RPF", 5, {|| SA2->A2_END}})
			aAdd(aValores, {"RPF", 6, {|| SA2->A2_BAIRRO}})
			aAdd(aValores, {"RPF", 7, {|| SA2->A2_MUN}})
			aAdd(aValores, {"RPF", 8, {|| SA2->A2_CEP}})
			aAdd(aValores, {"RPF", 10, {|| SA2->A2_EST}})
			cAux := GeraReg("RPF", aLayout, aValores)
			FWrite(nHandle, cAux)

			IncProc("Gerando arquivo " + cArq + "...")
			aValores := {}
			aAdd(aValores, {"TOT", 1, {|| "318"}})
			aAdd(aValores, {"TOT", 2, {|| StrTran(StrZero(nValNf, 8, 2), ".", "")}})
			aAdd(aValores, {"TOT", 3, {|| StrTran(StrZero(nPesNf, 8, 2), ".", "")}})
			aAdd(aValores, {"TOT", 5, {|| StrTran(StrZero(nVolNf, 8, 2), ".", "")}})
			cAux := GeraReg("TOT", aLayout, aValores)
			FWrite(nHandle, cAux)
			fClose(nHandle)

			IncProc("Gravando status das cargas...")
			cSql := "UPDATE " + RetSqlName("DAK") + " "
			cSql += "SET DAK_EXPEDI = 'S' "
			cSql += "WHERE "
			cSql += "  DAK_EXPEDI <> 'S' AND "
			cSql += "  DAK_PEDFRE <> '" + Space(Len(DAK->DAK_PEDFRE)) + "' AND "
			cSql += "  NOT EXISTS
			cSql += "	 ( "
			cSql += "   SELECT "
			cSql += "     'X' "
			cSql += "   FROM "
			cSql += "     " + RetSqlName("DAI") + " "
			cSql += "   WHERE "
			cSql += "     DAI_FILIAL = '" + xFilial("DAI") + "'           AND "
			cSql += "     D_E_L_E_T_ = ' '            AND "
			cSql += "     DAI_COD    = DAK_COD    AND "
			cSql += "     DAI_SEQCAR = DAK_SEQCAR AND "
			cSql += "     DAI_NFISCA = '" + Space(Len(DAI->DAI_NFISCA)) + "' "
			cSql += "  ) "
			If TcSqlExec(cSql) < 0
				HS_MsgInf("Ocorreu um erro ao gravar o status das cargas exportadas." + Chr(10) + Chr(13) + TcSqlError(), "Atenção!!!", cTitulo)
			Else
				MsgInfo("Importação concluída com sucesso. Gerado arquivo " + cPath + cArq, cTitulo)
			EndIf
		EndIf
		TMPF2->(DbCloseArea())
	EndIf

Return

Static Function ImpCONEMB(cFile)
	Local aUNB     := {}
	Local aCEM     := {}
	Local aDCC     := {}
	Local aCabNf   := {}
	Local aItensNf := {}
	Local aAux     := {}
	Local aNotas   := {}
	Local aLayout  := {}
	Local cFiltro  := ""
	Local cLinha   := ""
	Local cItemNfe := ""
	Local cCliente := ""
	Local cloja    := ""
	Local cCarga   := ""
	Local nTamId   := 3
	Local nTamReg  := 682
	Local nHandle1 := 0
	Local nBytes   := 0
	Local nLin     := 0
	Local nImp     := 0
	Local i

	If !File(cFile)
		MsgAlert("O arquivo informado não existe.", cTitulo)
		RestArea(aArea)
		Return
	Else
		nHandle1 := fOpen(cFile)
		If nHandle1 == -1
			MsgStop("O arquivo não pode ser aberto.", cTitulo)
			RestArea(aArea)
			Return
		EndIf
	EndIf

	fSeek(nHandle1, 0, 0)  // Volta no inicio do arquivo FS_SET = 0
	cLinha := ""
	nBytes := fRead(nHandle1, @cLinha, nTamReg)  // UNB
	nLin++

	cLinha := ""
	nBytes := fRead(nHandle1, @cLinha, nTamReg)  // UNH
	nLin++

	cLinha := ""
	nBytes := fRead(nHandle1, @cLinha, nTamReg)  // TRA
	nLin++

	cLinha := ""
	nBytes := fRead(nHandle1, @cLinha, nTamReg)  // CEM
	nLin++

	aLayout  := RetLayout(2)
	aCabNf   := {}
	aItensNf := {}
	While nBytes > 0 .And. Left(cLinha, nTamId) == "322"                             	
		aCEM := LeReg(cLinha, 3, aLayout)

		cLinha := ""
		nBytes := fRead(nHandle1, @cLinha, nTamReg)
		nLin++
		If Left(cLinha, nTamId) == "329"
			aDCC := LeReg(cLinha, 3, aLayout)
			cCliente := Left(aDCC[8], Len(SA1->A1_COD))
			cLoja    := SubStr(aDCC[8], Len(SA1->A1_COD) + 1, Len(SA1->A1_LOJA))
			cCarga   := Right(aDCC[8], Len(DAK->DAK_COD))
		Else
			MsgStop("Registro DCC não encontrado. Formato do arquivo inconsistente!", cTitulo)
			Final()
		EndIf

		aAdd(aCabNf, {})
		aAdd(aCabNf[Len(aCabNf)], {"F1_FILIAL" , xFilial("SF1"), Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_DOC"    , Right(aCEM[4], Len(SF1->F1_DOC)), Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_SERIE"  , aCEM[3]       , Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_FORMUL" , "N"           , Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_FORNECE", cCodTran      , Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_LOJA"   , cLojTran      , Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_TIPO"   , "N"           , Nil})				
		aAdd(aCabNf[Len(aCabNf)], {"F1_ESPECIE", "CTR"         , Nil})
		aAdd(aCabNf[Len(aCabNf)], {"F1_EMISSAO", StoD(SubStr(aCEM[5],5,4)+SubStr(aCEM[5],3,2)+SubStr(aCEM[5],1,2)), Nil})

		cItemNfe := Soma1(Replicate("0", TamSX3("D1_ITEM")[1]), TamSX3("D1_ITEM")[1])
		aNotas   := {}
		For i := 1 To Len(aCEM[23]) Step 11			
			If SubStr(aCEM[23], i+3, 8) <> Replicate("0", 8)
				aAdd(aNotas, {SubStr(aCEM[23], i, 3), PadL(SubStr(aCEM[23], i+3, 8), Len(SF2->F2_DOC), "0")})
			EndIf
		Next

		aAux := {}
		If Len(aNotas) > 0
			cFiltro := "F2_DOC = '" + aNotas[1,2] + "' AND F2_SERIE = '" + aNotas[1,1] + "' "
			aEval(aNotas, {|xItem| cFiltro += " AND F2_DOC = '" + xItem[2] + "' AND F2_SERIE = '" + xItem[1] + "' "}, 2)
			cSql := "SELECT SUM(F2_VALBRUT) F2_VALBRUT "
			cSql += "FROM " + RetSqlName("SF2") + " "
			cSql += "WHERE "
			cSql += "  D_E_L_E_T_ = ' ' AND F2_FILIAL = '" + xFilial("SF2") + "' AND " + cFiltro
			TcQuery cSql New Alias "TMPF2"

			SF2->(DbSetOrder(1))			
			SA1->(DbSetOrder(1))			
			SF2->(DbSeek(xFilial("SF2") + aNotas[1,2] + aNotas[1,1]))
			SA1->(DbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))
			If !SeekChave("SC7", {"C7_FILIAL", "C7_CHAVCTR"}, {xFilial("SC7"), cCliente + cLoja + cCarga}, .T.)
				MsgStop("Pedido de frete não localizado. Inconsistência no registro DCC campo 8 linha " + AllTrim(Str(nLin)) + ".", cTitulo)
				Final()
			EndIf
			For i := 1 To Len(aNotas)
				aAdd(aAux, {})
				aAdd(aAux[Len(aAux)], {"D1_FILIAL", xFilial("SD1")  , Nil})
				aAdd(aAux[Len(aAux)], {"D1_ITEM"  , cItemNfe        , Nil})
				aAdd(aAux[Len(aAux)], {"D1_COD"   , Iif(Right(SM0->M0_CODMUN,5) == SA1->A1_COD_MUN, cProdFre2, cProdFre1), Nil})
				aAdd(aAux[Len(aAux)], {"D1_QUANT" , 1 / Len(aNotas) , Nil})
				aAdd(aAux[Len(aAux)], {"D1_VUNIT" , (SF2->F2_VALBRUT * Val(aCEM[8]) / 100 / TMPF2->F2_VALBRUT) / (1 / Len(aNotas)), Nil})
				aAdd(aAux[Len(aAux)], {"D1_TOTAL" , (SF2->F2_VALBRUT * Val(aCEM[8]) / 100 / TMPF2->F2_VALBRUT) * (1 / Len(aNotas)), Nil})
				aAdd(aAux[Len(aAux)], {"D1_NFRSAI", aNotas[i,2]     , Nil})
				aAdd(aAux[Len(aAux)], {"D1_SERSAI", aNotas[i,1]     , Nil})
				aAdd(aAux[Len(aAux)], {"D1_PEDIDO", SC7->C7_NUM     , Nil})
				aAdd(aAux[Len(aAux)], {"D1_ITEMPC", SC7->C7_ITEM    , Nil})				
				cItemNfe := Soma1(cItemNfe, TamSX3("D1_ITEM")[1])
				aAdd(aItensNf, aClone(aAux))
			Next
			TMPF2->(DbCloseArea())			
		Else
			aDel(aCabNf, Len(aCabNf))
			aSize(aCabNf, Len(aCabNf) - 1)
		EndIf

		cLinha := ""
		nBytes := fRead(nHandle1, @cLinha, nTamReg)
		nLin++		
	End

	fClose(nHandle1)

	SF1->(DbSetOrder(1))
	Begin Transaction			
		For i := 1 To Len(aCabNf)
			SF1->(DbSeek(xFilial("SF1") + aCabNf[i,2,2] + aCabNf[i,3,2] + cCodTran + cLojTran))
			If !SF1->(Found())
				nImp++
				lMsHelpAuto := .T.
				lMsErroAuto := .F.
				MsExecAuto({|x,y,z| Mata140(x,y,z)}, aCabNf[i], aItensNf[i], 3)
				If lMsErroAuto
					MostraErro()
					Final()
				EndIf
			EndIf
		Next		
	End Transaction

	MsgInfo("Processo concluído com sucesso. " + AllTrim(Str(nImp)) + " conhecimento importados.", cTitulo)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³GeraReg   | Autor ³ Fabricio E. da Costa  ³ Data ³ 02/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera uma linha do arquivo baseado no layout                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraReg(cReg, aLayout, aDados)
	Local aAux    := {}
	Local cBuffer := ""
	Local nPos    := 0
	Local i

	nPos := aScan(aLayout, {|x| x[1] == cReg})
	aAux := aClone(aLayout[nPos, 3])
	For i := 1 To Len(aAux)
		If Len(aDados) > 0
			nPos := aScan(aDados, {|x| x[2] == i})
		EndIf
		If nPos == 0
			cBuffer += Replicate(Iif(aAux[i,3] == "N", "0", " "), aAux[i,2])
		Else
			cBuffer += Iif(aAux[i,3] == "N", PadL(Eval(aDados[nPos,3]), aAux[i,2], "0"), PadR(Eval(aDados[nPos,3]), aAux[i,2]))
		EndIf
	Next
	cBuffer += Chr(13) + Chr(10)

Return cBuffer

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LeReg   | Autor ³ Fabricio E. da Costa  ³ Data ³ 02/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Gera uma do arquivo baseado em no layout                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function LeReg(cLinha, nTamId, aLayout)
	Local nLayout := 0
	Local aRet    := {}
	Local aLayReg, i

	nLayout := aScan(aLayout, {|x| x[1]==Left(cLinha, nTamId)})
	aLayReg := aClone(aLayout[nLayout,3])
	aRet    := Array(Len(aLayReg))
	For i := 1 To Len(aLayReg)
		aRet[i] := SubStr(cLinha, aLayReg[i,1], aLayReg[i,2])
	Next

Return aClone(aRet)

Static Function RetLayout(nType)
	Local aUNBLay  := Array(7,3)
	Local aUNHLay  := Array(3,3)
	Local aDEMLay  := Array(10,3)
	Local aDESLay  := Array(14,3)
	Local aDNFLay  := Array(31,3)
	Local aDCNLay  := Array(31,3)
	Local aRPFLay  := Array(12,3)
	Local aTOTLay  := Array(8,3)
	Local aTRALay  := Array(4,3)
	Local aCEMLay  := Array(27,3)
	Local aDCCLay  := Array(11,3)
	Local aTCELay  := Array(4,3)
	Local aLayout  := {}
	Local nTamReg  := 0

	If nType == 1
		nTamReg := 242
		//Posicao Inicial      // Tamanho             // Tipo de dado
		aUNBLay[1,1]  := 001; aUNBLay[1,2]  := 003; aUNBLay[1,3]  := "N"
		aUNBLay[2,1]  := 004; aUNBLay[2,2]  := 035; aUNBLay[2,3]  := "A"
		aUNBLay[3,1]  := 039; aUNBLay[3,2]  := 035; aUNBLay[3,3]  := "A"
		aUNBLay[4,1]  := 074; aUNBLay[4,2]  := 006; aUNBLay[4,3]  := "N"
		aUNBLay[5,1]  := 080; aUNBLay[5,2]  := 004; aUNBLay[5,3]  := "N"
		aUNBLay[6,1]  := 084; aUNBLay[6,2]  := 012; aUNBLay[6,3]  := "A" 
		aUNBLay[7,1]  := 096; aUNBLay[7,2]  := 145; aUNBLay[7,3]  := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aUNHLay[1,1]  := 001; aUNHLay[1,2]  := 003; aUNHLay[1,3]  := "N"
		aUNHLay[2,1]  := 004; aUNHLay[2,2]  := 014; aUNHLay[2,3]  := "A"
		aUNHLay[3,1]  := 018; aUNHLay[3,2]  := 223; aUNHLay[3,3]  := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aDEMLay[1,1]  := 001; aDEMLay[1,2]  := 003; aDEMLay[1,3]  := "N"
		aDEMLay[2,1]  := 004; aDEMLay[2,2]  := 014; aDEMLay[2,3]  := "N"
		aDEMLay[3,1]  := 018; aDEMLay[3,2]  := 015; aDEMLay[3,3]  := "A"
		aDEMLay[4,1]  := 033; aDEMLay[4,2]  := 040; aDEMLay[4,3]  := "A"
		aDEMLay[5,1]  := 073; aDEMLay[5,2]  := 035; aDEMLay[5,3]  := "A"
		aDEMLay[6,1]  := 108; aDEMLay[6,2]  := 009; aDEMLay[6,3]  := "A"
		aDEMLay[7,1]  := 117; aDEMLay[7,2]  := 009; aDEMLay[7,3]  := "A"
		aDEMLay[8,1]  := 126; aDEMLay[8,2]  := 008; aDEMLay[8,3]  := "N"
		aDEMLay[9,1]  := 134; aDEMLay[9,2]  := 040; aDEMLay[9,3]  := "A"
		aDEMLay[10,1] := 174; aDEMLay[10,2] := 067; aDEMLay[10,3] := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aDESLay[1,1]  := 001; aDESLay[1,2]  := 003; aDESLay[1,3]  := "N"
		aDESLay[2,1]  := 004; aDESLay[2,2]  := 040; aDESLay[2,3]  := "A"
		aDESLay[3,1]  := 044; aDESLay[3,2]  := 014; aDESLay[3,3]  := "N"
		aDESLay[4,1]  := 058; aDESLay[4,2]  := 015; aDESLay[4,3]  := "A"
		aDESLay[5,1]  := 073; aDESLay[5,2]  := 040; aDESLay[5,3]  := "A"
		aDESLay[6,1]  := 113; aDESLay[6,2]  := 020; aDESLay[6,3]  := "A"
		aDESLay[7,1]  := 133; aDESLay[7,2]  := 035; aDESLay[7,3]  := "A"
		aDESLay[8,1]  := 168; aDESLay[8,2]  := 009; aDESLay[8,3]  := "A"
		aDESLay[9,1]  := 177; aDESLay[9,2]  := 009; aDESLay[9,3]  := "A"
		aDESLay[10,1] := 186; aDESLay[10,2] := 009; aDESLay[10,3] := "A"
		aDESLay[11,1] := 195; aDESLay[11,2] := 004; aDESLay[11,3] := "A"
		aDESLay[12,1] := 199; aDESLay[12,2] := 035; aDESLay[12,3] := "A"
		aDESLay[13,1] := 234; aDESLay[13,2] := 001; aDESLay[13,3] := "A"
		aDESLay[14,1] := 235; aDESLay[14,2] := 006; aDESLay[14,3] := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aDNFLay[1,1]  := 001; aDNFLay[1,2]  := 003; aDNFLay[1,3]  := "N"
		aDNFLay[2,1]  := 004; aDNFLay[2,2]  := 015; aDNFLay[2,3]  := "A"
		aDNFLay[3,1]  := 019; aDNFLay[3,2]  := 007; aDNFLay[3,3]  := "A"
		aDNFLay[4,1]  := 026; aDNFLay[4,2]  := 001; aDNFLay[4,3]  := "N"
		aDNFLay[5,1]  := 027; aDNFLay[5,2]  := 001; aDNFLay[5,3]  := "N"
		aDNFLay[6,1]  := 028; aDNFLay[6,2]  := 001; aDNFLay[6,3]  := "N"
		aDNFLay[7,1]  := 029; aDNFLay[7,2]  := 001; aDNFLay[7,3]  := "A"
		aDNFLay[8,1]  := 030; aDNFLay[8,2]  := 003; aDNFLay[8,3]  := "A"
		aDNFLay[9,1]  := 033; aDNFLay[9,2]  := 008; aDNFLay[9,3]  := "N"
		aDNFLay[10,1] := 041; aDNFLay[10,2] := 008; aDNFLay[10,3] := "N"
		aDNFLay[11,1] := 049; aDNFLay[11,2] := 015; aDNFLay[11,3] := "A"
		aDNFLay[12,1] := 064; aDNFLay[12,2] := 015; aDNFLay[12,3] := "A"
		aDNFLay[13,1] := 079; aDNFLay[13,2] := 007; aDNFLay[13,3] := "N"
		aDNFLay[14,1] := 086; aDNFLay[14,2] := 015; aDNFLay[14,3] := "N"
		aDNFLay[15,1] := 101; aDNFLay[15,2] := 007; aDNFLay[15,3] := "N"
		aDNFLay[16,1] := 108; aDNFLay[16,2] := 005; aDNFLay[16,3] := "N"
		aDNFLay[17,1] := 113; aDNFLay[17,2] := 001; aDNFLay[17,3] := "A"
		aDNFLay[18,1] := 114; aDNFLay[18,2] := 001; aDNFLay[18,3] := "A"
		aDNFLay[19,1] := 115; aDNFLay[19,2] := 015; aDNFLay[19,3] := "N"
		aDNFLay[20,1] := 130; aDNFLay[20,2] := 015; aDNFLay[20,3] := "N"
		aDNFLay[21,1] := 145; aDNFLay[21,2] := 007; aDNFLay[21,3] := "A"
		aDNFLay[22,1] := 152; aDNFLay[22,2] := 001; aDNFLay[22,3] := "A"
		aDNFLay[23,1] := 153; aDNFLay[23,2] := 015; aDNFLay[23,3] := "N"
		aDNFLay[24,1] := 168; aDNFLay[24,2] := 015; aDNFLay[24,3] := "N"
		aDNFLay[25,1] := 183; aDNFLay[25,2] := 015; aDNFLay[25,3] := "N"
		aDNFLay[26,1] := 198; aDNFLay[26,2] := 015; aDNFLay[26,3] := "N"
		aDNFLay[27,1] := 213; aDNFLay[27,2] := 001; aDNFLay[27,3] := "A"
		aDNFLay[28,1] := 214; aDNFLay[28,2] := 012; aDNFLay[28,3] := "N"
		aDNFLay[29,1] := 226; aDNFLay[29,2] := 012; aDNFLay[29,3] := "N"
		aDNFLay[30,1] := 238; aDNFLay[30,2] := 001; aDNFLay[30,3] := "A"
		aDNFLay[31,1] := 239; aDNFLay[31,2] := 002; aDNFLay[31,3] := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aDCNLay[1,1]  := 001; aDCNLay[1,2]  := 003; aDCNLay[1,3]  := "N"
		aDCNLay[2,1]  := 004; aDCNLay[2,2]  := 004; aDCNLay[2,3]  := "N"
		aDCNLay[3,1]  := 008; aDCNLay[3,2]  := 001; aDCNLay[3,3]  := "N"
		aDCNLay[4,1]  := 009; aDCNLay[4,2]  := 008; aDCNLay[4,3]  := "N"
		aDCNLay[5,1]  := 017; aDCNLay[5,2]  := 004; aDCNLay[5,3]  := "N"
		aDCNLay[6,1]  := 021; aDCNLay[6,2]  := 008; aDCNLay[6,3]  := "N"
		aDCNLay[7,1]  := 029; aDCNLay[7,2]  := 004; aDCNLay[7,3]  := "N"
		aDCNLay[8,1]  := 033; aDCNLay[8,2]  := 015; aDCNLay[8,3]  := "A"
		aDCNLay[9,1]  := 048; aDCNLay[9,2]  := 001; aDCNLay[9,3]  := "A"
		aDCNLay[10,1] := 049; aDCNLay[10,2] := 010; aDCNLay[10,3] := "A"
		aDCNLay[11,1] := 059; aDCNLay[11,2] := 015; aDCNLay[11,3] := "N"
		aDCNLay[12,1] := 074; aDCNLay[12,2] := 003; aDCNLay[12,3] := "A"
		aDCNLay[13,1] := 077; aDCNLay[13,2] := 008; aDCNLay[13,3] := "N"
		aDCNLay[14,1] := 085; aDCNLay[14,2] := 015; aDCNLay[14,3] := "N"
		aDCNLay[15,1] := 100; aDCNLay[15,2] := 003; aDCNLay[15,3] := "A"
		aDCNLay[16,1] := 103; aDCNLay[16,2] := 008; aDCNLay[16,3] := "N"
		aDCNLay[17,1] := 111; aDCNLay[17,2] := 015; aDCNLay[17,3] := "N"
		aDCNLay[18,1] := 126; aDCNLay[18,2] := 003; aDCNLay[18,3] := "A"
		aDCNLay[19,1] := 129; aDCNLay[19,2] := 008; aDCNLay[19,3] := "N"
		aDCNLay[20,1] := 137; aDCNLay[20,2] := 015; aDCNLay[20,3] := "N"
		aDCNLay[21,1] := 152; aDCNLay[21,2] := 003; aDCNLay[21,3] := "A"
		aDCNLay[22,1] := 155; aDCNLay[22,2] := 008; aDCNLay[22,3] := "N"
		aDCNLay[23,1] := 163; aDCNLay[23,2] := 015; aDCNLay[23,3] := "N"
		aDCNLay[24,1] := 178; aDCNLay[24,2] := 003; aDCNLay[24,3] := "A"
		aDCNLay[25,1] := 181; aDCNLay[25,2] := 008; aDCNLay[25,3] := "N"
		aDCNLay[26,1] := 189; aDCNLay[26,2] := 015; aDCNLay[26,3] := "N"
		aDCNLay[27,1] := 204; aDCNLay[27,2] := 005; aDCNLay[27,3] := "A"
		aDCNLay[28,1] := 209; aDCNLay[28,2] := 010; aDCNLay[28,3] := "A"
		aDCNLay[29,1] := 219; aDCNLay[29,2] := 005; aDCNLay[29,3] := "A"
		aDCNLay[30,1] := 224; aDCNLay[30,2] := 012; aDCNLay[30,3] := "A"
		aDCNLay[31,1] := 236; aDCNLay[31,2] := 005; aDCNLay[31,3] := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aRPFLay[1,1]  := 001; aRPFLay[1,2]  := 003; aRPFLay[1,3]  := "N"
		aRPFLay[2,1]  := 004; aRPFLay[2,2]  := 040; aRPFLay[2,3]  := "A"
		aRPFLay[3,1]  := 044; aRPFLay[3,2]  := 014; aRPFLay[3,3]  := "N"
		aRPFLay[4,1]  := 058; aRPFLay[4,2]  := 015; aRPFLay[4,3]  := "A"
		aRPFLay[5,1]  := 073; aRPFLay[5,2]  := 040; aRPFLay[5,3]  := "A"
		aRPFLay[6,1]  := 113; aRPFLay[6,2]  := 020; aRPFLay[6,3]  := "A"
		aRPFLay[7,1]  := 133; aRPFLay[7,2]  := 035; aRPFLay[7,3]  := "A"
		aRPFLay[8,1]  := 168; aRPFLay[8,2]  := 009; aRPFLay[8,3]  := "A"
		aRPFLay[9,1]  := 177; aRPFLay[9,2]  := 009; aRPFLay[9,3]  := "A"
		aRPFLay[10,1] := 186; aRPFLay[10,2] := 009; aRPFLay[10,3] := "A"
		aRPFLay[11,1] := 195; aRPFLay[11,2] := 035; aRPFLay[11,3] := "A"
		aRPFLay[12,1] := 230; aRPFLay[12,2] := 011; aRPFLay[12,3] := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aTOTLay[1,1]  := 001; aTOTLay[1,2]  := 003; aTOTLay[1,3]  := "N"
		aTOTLay[2,1]  := 004; aTOTLay[2,2]  := 015; aTOTLay[2,3]  := "N"
		aTOTLay[3,1]  := 019; aTOTLay[3,2]  := 015; aTOTLay[3,3]  := "N"
		aTOTLay[4,1]  := 034; aTOTLay[4,2]  := 015; aTOTLay[4,3]  := "N"
		aTOTLay[5,1]  := 049; aTOTLay[5,2]  := 015; aTOTLay[5,3]  := "N"
		aTOTLay[6,1]  := 064; aTOTLay[6,2]  := 015; aTOTLay[6,3]  := "N" 
		aTOTLay[7,1]  := 079; aTOTLay[7,2]  := 015; aTOTLay[7,3]  := "N" 
		aTOTLay[8,1]  := 094; aTOTLay[8,2]  := 147; aTOTLay[8,3]  := "A" 

		aAdd(aLayout, {"UNB", nTamReg, Aclone(aUNBLay)})
		aAdd(aLayout, {"UNH", nTamReg, Aclone(aUNHLay)})
		aAdd(aLayout, {"DEM", nTamReg, Aclone(aDEMLay)})
		aAdd(aLayout, {"DES", nTamReg, Aclone(aDESLay)})
		aAdd(aLayout, {"DNF", nTamReg, Aclone(aDNFLay)})
		aAdd(aLayout, {"DCN", nTamReg, Aclone(aDCNLay)})
		aAdd(aLayout, {"RPF", nTamReg, Aclone(aRPFLay)})
		aAdd(aLayout, {"TOT", nTamReg, Aclone(aTOTLay)})
	ElseIf nType == 2
		nTamReg := 682
		//Posicao Inicial      // Tamanho             // Tipo de dado
		aUNBLay[1,1]  := 001; aUNBLay[1,2]  := 003; aUNBLay[1,3]  := "N"
		aUNBLay[2,1]  := 004; aUNBLay[2,2]  := 035; aUNBLay[2,3]  := "A"
		aUNBLay[3,1]  := 039; aUNBLay[3,2]  := 035; aUNBLay[3,3]  := "A"
		aUNBLay[4,1]  := 074; aUNBLay[4,2]  := 006; aUNBLay[4,3]  := "N"
		aUNBLay[5,1]  := 080; aUNBLay[5,2]  := 004; aUNBLay[5,3]  := "N"
		aUNBLay[6,1]  := 084; aUNBLay[6,2]  := 012; aUNBLay[6,3]  := "A" 
		aUNBLay[7,1]  := 096; aUNBLay[7,2]  := 585; aUNBLay[7,3]  := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aUNHLay[1,1]  := 001; aUNHLay[1,2]  := 003; aUNHLay[1,3]  := "N"
		aUNHLay[2,1]  := 004; aUNHLay[2,2]  := 014; aUNHLay[2,3]  := "A"
		aUNHLay[3,1]  := 018; aUNHLay[3,2]  := 663; aUNHLay[3,3]  := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aTRALay[1,1]  := 001; aTRALay[1,2]  := 003; aTRALay[1,3]  := "N"
		aTRALay[2,1]  := 004; aTRALay[2,2]  := 014; aTRALay[2,3]  := "N"
		aTRALay[3,1]  := 018; aTRALay[3,2]  := 040; aTRALay[3,3]  := "A"
		aTRALay[4,1]  := 058; aTRALay[4,2]  := 623; aTRALay[4,3]  := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aCEMLay[1,1]  := 001; aCEMLay[1,2]  := 003; aCEMLay[1,3]  := "N"
		aCEMLay[2,1]  := 004; aCEMLay[2,2]  := 010; aCEMLay[2,3]  := "A"
		aCEMLay[3,1]  := 014; aCEMLay[3,2]  := 005; aCEMLay[3,3]  := "A"
		aCEMLay[4,1]  := 019; aCEMLay[4,2]  := 012; aCEMLay[4,3]  := "A"
		aCEMLay[5,1]  := 031; aCEMLay[5,2]  := 008; aCEMLay[5,3]  := "N"
		aCEMLay[6,1]  := 039; aCEMLay[6,2]  := 001; aCEMLay[6,3]  := "A"
		aCEMLay[7,1]  := 040; aCEMLay[7,2]  := 007; aCEMLay[7,3]  := "N"
		aCEMLay[8,1]  := 047; aCEMLay[8,2]  := 015; aCEMLay[8,3]  := "N"
		aCEMLay[9,1]  := 062; aCEMLay[9,2]  := 015; aCEMLay[9,3]  := "N"
		aCEMLay[10,1] := 077; aCEMLay[10,2] := 004; aCEMLay[10,3] := "N"
		aCEMLay[11,1] := 081; aCEMLay[11,2] := 015; aCEMLay[11,3] := "N"
		aCEMLay[12,1] := 096; aCEMLay[12,2] := 015; aCEMLay[12,3] := "N"
		aCEMLay[13,1] := 111; aCEMLay[13,2] := 015; aCEMLay[13,3] := "N"
		aCEMLay[14,1] := 126; aCEMLay[14,2] := 015; aCEMLay[14,3] := "N"
		aCEMLay[15,1] := 141; aCEMLay[15,2] := 015; aCEMLay[15,3] := "N"
		aCEMLay[16,1] := 156; aCEMLay[16,2] := 015; aCEMLay[16,3] := "N"
		aCEMLay[17,1] := 171; aCEMLay[17,2] := 015; aCEMLay[17,3] := "N"
		aCEMLay[18,1] := 186; aCEMLay[18,2] := 015; aCEMLay[18,3] := "N"
		aCEMLay[19,1] := 201; aCEMLay[19,2] := 001; aCEMLay[19,3] := "N"
		aCEMLay[20,1] := 202; aCEMLay[20,2] := 003; aCEMLay[20,3] := "A"
		aCEMLay[21,1] := 205; aCEMLay[21,2] := 014; aCEMLay[21,3] := "N"
		aCEMLay[22,1] := 219; aCEMLay[22,2] := 014; aCEMLay[22,3] := "N"

		aCEMLay[23,1] := 233; aCEMLay[23,2] := 440; aCEMLay[23,3] := "A"  // Notas e series

		aCEMLay[24,1] := 673; aCEMLay[24,2] := 001; aCEMLay[24,3] := "A"
		aCEMLay[25,1] := 674; aCEMLay[25,2] := 001; aCEMLay[25,3] := "A"
		aCEMLay[26,1] := 675; aCEMLay[26,2] := 001; aCEMLay[26,3] := "A"
		aCEMLay[27,1] := 676; aCEMLay[27,2] := 005; aCEMLay[27,3] := "A"

		//Posicao Inicial      // Tamanho             // Tipo de dado
		aDCCLay[1,1]  := 001; aDCCLay[1,2]  := 003; aDCCLay[1,3]  := "N"
		aDCCLay[2,1]  := 004; aDCCLay[2,2]  := 005; aDCCLay[2,3]  := "A"
		aDCCLay[3,1]  := 009; aDCCLay[3,2]  := 015; aDCCLay[3,3]  := "N"
		aDCCLay[4,1]  := 024; aDCCLay[4,2]  := 015; aDCCLay[4,3]  := "N"
		aDCCLay[5,1]  := 039; aDCCLay[5,2]  := 010; aDCCLay[5,3]  := "A"
		aDCCLay[6,1]  := 049; aDCCLay[6,2]  := 005; aDCCLay[6,3]  := "A"
		aDCCLay[7,1]  := 054; aDCCLay[7,2]  := 012; aDCCLay[7,3]  := "A"
		aDCCLay[8,1]  := 066; aDCCLay[8,2]  := 015; aDCCLay[8,3]  := "A"
		aDCCLay[9,1]  := 081; aDCCLay[9,2]  := 020; aDCCLay[9,3]  := "A"
		aDCCLay[10,1] := 101; aDCCLay[10,2] := 020; aDCCLay[10,3] := "A"
		aDCCLay[11,1] := 121; aDCCLay[11,2] := 560; aDCCLay[11,3] := "A"


		//Posicao Inicial      // Tamanho             // Tipo de dado
		aTCELay[1,1]  := 001; aTCELay[1,2]  := 003; aTCELay[1,3]  := "N"
		aTCELay[2,1]  := 004; aTCELay[2,2]  := 004; aTCELay[2,3]  := "N"
		aTCELay[3,1]  := 008; aTCELay[3,2]  := 015; aTCELay[3,3]  := "N"
		aTCELay[4,1]  := 023; aTCELay[4,2]  := 658; aTCELay[4,3]  := "A"

		aAdd(aLayout, {"000", nTamReg, Aclone(aUNBLay)})
		aAdd(aLayout, {"320", nTamReg, Aclone(aUNHLay)})
		aAdd(aLayout, {"321", nTamReg, Aclone(aTRALay)})
		aAdd(aLayout, {"322", nTamReg, Aclone(aCEMLay)})
		aAdd(aLayout, {"323", nTamReg, Aclone(aTCELay)})
		aAdd(aLayout, {"329", nTamReg, Aclone(aDCCLay)})
	EndIf

Return aClone(aLayout)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³QSetField ºAutor  ³Fabricio E. da Costaº Data ³  11/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ajusta o tipo de dado dos campos de um recordset, gerado    º±±
±±º          ³pelo TcQuery ou DbUseArea.                                  º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³  cAlias...: Nome do alias (recordset) a ser ajustado.      º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³   Nil                                                      º±±
±±º          ³                                                            º±±
±±º          ³Observacao:                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QSetField(cAlias)
	Local aStruct := {}
	Local aAuxCpo := {}
	Local i

	aStruct := (cAlias)->(DbStruct())
	For i := 1 To Len(aStruct)
		aAuxCpo := TamSx3(aStruct[i,1])
		If aAuxCpo[3] $ "D/N"
			TCSetField(cAlias, aStruct[i,1], aAuxCpo[3], aAuxCpo[1], aAuxCpo[2])
		EndIf		
	Next
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³SeekChave ºAutor  ³Fabricio E. da Costaº Data ³  15/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Efetua uma busca na tabela informada em cAlias.            º±±
±±º          ³                                                            º±±
±±º          ³Parametros:                                                 º±±
±±º          ³   cAlias.....: Tabela onde será feita a busca.             º±±
±±º          ³   aChave.....: Lista do campos onde será feita a busca.    º±±
±±º          ³   aValores...: Lista de valores que serão utilizados na    º±±
±±º          ³                busca.                                      º±±
±±º          ³   lPosiciona.: Indica se o registro ficará posicionado ou  º±±
±±º          ³                se somente retorna .T. ou .F.               º±±
±±º          ³                                                            º±±
±±º          ³Retorno:                                                    º±±
±±º          ³   .........: .T. se achou, .F. se não achou                º±±
±±º          ³                                                            º±±
±±º          ³Observacao:                                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GERAL                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SeekChave(cAlias, aChave, aValores, lPosiciona)
	Local aInfCpo := {}
	Local aArea   := GetArea(cAlias)
	Local cSql    := "" 
	Local nReg    := 0
	Local lAchou  := .F.
	Local i

	Default lPosiciona := .T.

	cSql := "SELECT R_E_C_N_O_ NRECNO "
	cSql += "FROM " + RetSqlName(cAlias) + " "
	cSql += "WHERE "
	If Set(11)
		cSql += "  D_E_L_E_T_ = ' ' AND "
	EndIf
	For i := 1 To Len(aChave)
		cSql += aChave[i] + " = "
		aInfCpo := TamSX3(aChave[i])
		If aInfCpo[3] $ "C/D"
			cSql += "'" + aValores[i] + "'"
		Else
			cSql += Str(aValores[i], aInfCpo[1], aInfCpo[2])
		EndIf
		cSql += Iif(i < Len(aChave), " AND ", "")
	Next
	TcQuery cSql New Alias "TMPSEEK"

	lAchou := !TMPSEEK->(Eof())
	If lAchou .And. lPosiciona
		(cAlias)->(DbGoTo(TMPSEEK->NRECNO))
	EndIf
	If Alias() <> cAlias
		RestArea(aArea)
	EndIf
	TMPSEEK->(DbCloseArea())	

Return lAchou
#Include "Totvs.ch"
#Include "TopConn.ch"

User Function MTA265GRV()  	   	


	Local aAuto    := {}
	Local cDocD3   := ""
	Local cSql     := ""
	Local cTMPerda := ""
	Local cTMGanho := ""
	Local cTitulo  := "Integração balança/estoque (MTA265GRV)"
	Local nQtdD1   := 0
	Local nQtdDB   := 0
	Local nDifPeso := 0
	Local nPercTol := 0.0

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MTA265GRV" , __cUserID )

	If GetApoInfo("MATA265.PRX")[4] < CtoD("04/01/11")
		MsgAlert("Para utilizar o PE MTA265GRV, é necessário o fonte MATA265.PRW com data 04/01/11 ou superior.", cTitulo)
		Return
	EndIf

	cTMPerda := GetMV("MV_MKTMPER")
	If Empty(cTMPerda)
		MsgAlert("Parametro MV_MKTMPER não existe ou não preenchido. Ajuste de balança não será efetuado.", cTitulo)
		Return
	EndIf

	cTMGanho := GetMV("MV_MKTMGAN")
	If Empty(cTMGanho)
		MsgAlert("Parametro MV_MKTMGAN não existe ou não preenchido. Ajuste de balança não será efetuado.", cTitulo)
		Return
	EndIf

	nPercTol := GetMV("MV_MKPBAL")
	If Empty(nPercTol)
		MsgAlert("Parametro MV_MKPBAL não existe ou não preenchido. Ajuste de balança não será efetuado.", cTitulo)
		Return
	EndIf

	cSql := "SELECT "
	cSql += "  ZI_DOC,     ZI_SERIE,   ZI_ITEM,  ZI_PESINI,  ZI_PESFIM, ZI_DOCD3,   ZI_SEQD3,   D1_COD,     D1_QUANT, "
	cSql += "  D1_LOTECTL, D1_UM,      D1_SEGUM, D1_QTSEGUM, B1_LOCPAD, QEK_ORIGEM, QEK_TIPDOC, QEK_MOVEST, QEK_NUMSEQ, "
	cSql += "  DB_LOCALIZ, DB_QUANT,   DB_QTSEGUM "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SZI") + " SZI JOIN " + RetSqlName("SD1") + " SD1 ON "
	cSql += "    SZI.D_E_L_E_T_ = ' ' AND "
	cSql += "    SZI.ZI_FILIAL  = '" + xFilial("SZI") + "' AND "
	cSql += "    SD1.D_E_L_E_T_ = ' ' AND "
	cSql += "    SD1.D1_FILIAL  = '" + xFilial("SD1") + "' AND "
	cSql += "    SZI.ZI_DOC     = SD1.D1_DOC   AND "
	cSql += "    SZI.ZI_SERIE   = SD1.D1_SERIE AND "
	cSql += "    SZI.ZI_ITEM    = SD1.D1_ITEM  "
	cSql += "  JOIN "
	cSql += "  ( "
	cSql += "   SELECT "
	cSql += "     D7_NUMSEQ "
	cSql += "   FROM "
	cSql += "     " + RetSqlName("SD7") + " "
	cSql += "   WHERE "
	cSql += "     D_E_L_E_T_ = ' ' "
	cSql += "     AND D7_FILIAL  =  '" + xFilial("SD7") + "' "
	cSql += "     AND D7_NUMERO  =  '" + SDA->DA_DOC    + "' "
	cSql += "     AND D7_TIPO    =  '0' "
	cSql += "  ) SD7 "
	cSql += "    JOIN " + RetSqlName("QEK") + " QEK ON "
	cSql += "      QEK.D_E_L_E_T_ = ' ' AND "
	cSql += "      QEK.QEK_FILIAL = '" + xFilial("QEK") + "' AND "
	cSql += "      SD7.D7_NUMSEQ  = QEK.QEK_NUMSEQ ON "
	cSql += "    SZI.ZI_DOC   = QEK.QEK_NTFISC AND "
	cSql += "    SZI.ZI_SERIE = QEK.QEK_SERINF AND "
	cSql += "    SZI.ZI_ITEM  = QEK.QEK_ITEMNF "
	cSql += "  LEFT JOIN "
	cSql += "  ( "
	cSql += "   SELECT "
	cSql += "     DB_PRODUTO, DB_LOCAL, DB_LOCALIZ, SUM(DB_QUANT) DB_QUANT, SUM(DB_QTSEGUM) DB_QTSEGUM "
	cSql += "   FROM "
	cSql += "     " + RetSqlName("SDB") + " "
	cSql += "   WHERE "
	cSql += "     D_E_L_E_T_ = ' ' "
	cSql += "     AND DB_FILIAL  =  '" + xFilial("SDB") + "' "
	cSql += "     AND DB_ESTORNO <> 'S' "
	cSql += "     AND DB_TIPO    =  'D' "
	cSql += "     AND DB_DOC     =  '" + SDA->DA_DOC     + "' "
	cSql += "     AND DB_PRODUTO =  '" + SDA->DA_PRODUTO + "' "
	cSql += "     AND DB_LOCAL   =  '" + SDA->DA_LOCAL   + "' "
	cSql += "     AND DB_LOTECTL =  '" + SDA->DA_LOTECTL + "' "
	cSql += "   GROUP BY "
	cSql += "     DB_PRODUTO, DB_LOCAL, DB_LOCALIZ "
	cSql += "  ) SDB ON "
	cSql += "    SDB.DB_PRODUTO = SD1.D1_COD "
	cSql += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cSql += "    SB1.D_E_L_E_T_ = ' ' AND "
	cSql += "    SB1.B1_FILIAL  = '" + xFilial("SB1") + "' AND "
	cSql += "    SB1.B1_COD     = SD1.D1_COD "
	cSql += "WHERE "
	cSql += "  SB1.B1_MKPESAG = '1' "
	cSql += "ORDER BY "
	cSql += "  SDB.DB_QUANT DESC "
	TcQuery cSql New Alias "TMPD7"

	If AllTrim(TMPD7->QEK_ORIGEM) == "MATA103" .And. AllTrim(TMPD7->QEK_TIPDOC) == "NF" .And. TMPD7->QEK_MOVEST == "S"

		If !"KG" $ TMPD7->D1_UM + "/" + TMPD7->D1_SEGUM
			MsgAlert("Unidade de medida 'KG' não cadastrada para este produto. O acerto de estoque não será efetuado.", cTitulo)
		Else		
			nQtdD1 := Iif(TMPD7->D1_UM == "KG", TMPD7->D1_QUANT, TMPD7->D1_QTSEGUM)
			nQtdDB := Iif(TMPD7->D1_UM == "KG", TMPD7->DB_QUANT, TMPD7->DB_QTSEGUM)

			nDifPeso := (TMPD7->ZI_PESINI - TMPD7->ZI_PESFIM) - nQtdD1
			If !TMPD7->(Eof()) .And. !TMPD7->(Bof()) .And. nDifPeso <> 0			
				If !Empty(TMPD7->DB_QUANT) .And. Empty(TMPD7->ZI_DOCD3)
					If nQtdDB < nDifPeso
						MsgAlert("Quantidade endereçada não é suficiente para efetuar o acerto de estoque.", cTitulo)
					Else
						cDocD3 := GetSxeNum("SD3", "D3_DOC")
						aAdd(aAuto, {"D3_DOC"    , cDocD3           , Nil})
						aAdd(aAuto, {"D3_COD"    , TMPD7->D1_COD    , Nil})
						aAdd(aAuto, {"D3_TM"     , Iif(nDifPeso > 0 , cTMGanho, cTMPerda), Nil})
						If TMPD7->D1_UM == "KG"
							aAdd(aAuto, {"D3_QUANT"  , Abs(nDifPeso)    , Nil})
						Else
							aAdd(aAuto, {"D3_QTSEGUM", Abs(nDifPeso)    , Nil})
						EndIf
						aAdd(aAuto, {"D3_LOCAL"  , SDA->DA_LOCAL    , Nil})
						aAdd(aAuto, {"D3_LOTECTL", SDA->DA_LOTECTL  , Nil})
						aAdd(aAuto, {"D3_LOCALIZ", TMPD7->DB_LOCALIZ, Nil})
						aAdd(aAuto, {"D3_EMISSAO", dDataBase        , Nil})
						aAdd(aAuto, {"D3_IDENT"  , TMPD7->QEK_NUMSEQ, Nil})
						aAdd(aAuto, {"D3_MOTIVO" , "Ajuste efetuado pela balança documento " + TMPD7->ZI_DOC + "-" + TMPD7->ZI_SERIE + "-" + TMPD7->ZI_ITEM, Nil})
						lMsHelpAuto := .T.
						lMsErroAuto := .F.
						Begin Transaction
							MSExecAuto({|x,y| MATA240(x,y)}, aAuto, 3)
							If lMsErroAuto
								MostraErro()
								MsgStop("Houve um erro na inclusão do movimento interno para o documento " + TMPD7->ZI_DOC + "-" + TMPD7->ZI_SERIE + "-" + TMPD7->ZI_ITEM + ". O acerto de pesagem não será efetuado.", cTitulo)
								DisarmTransction()
							Else
								cSql := "UPDATE " + RetSqlName("SZI") + " "
								cSql += "SET "
								cSql += "  ZI_DOCD3 = '" + SD3->D3_DOC    + "', "
								cSql += "  ZI_SEQD3 = '" + SD3->D3_NUMSEQ + "' "
								cSql += "WHERE"
								cSql += "  ZI_FILIAL = '" + xFilial("SZI") + "' "
								cSql += "  AND ZI_DOC   = '" + TMPD7->ZI_DOC   + "' "
								cSql += "  AND ZI_SERIE = '" + TMPD7->ZI_SERIE + "' "
								cSql += "  AND ZI_ITEM  = '" + TMPD7->ZI_ITEM  + "' "
								TcSqlExec(cSql)
								cAux := TCSqlError()
								If !Empty(cAux)
									MsgStop("Houve um erro na gravação do número do documento no controle de pesagens. Não será possivel o estorno do acerto de pesagem", cTitulo)
								EndIf
							EndIf
						End Transaction
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	TMPD7->(DbCloseArea())
Return      


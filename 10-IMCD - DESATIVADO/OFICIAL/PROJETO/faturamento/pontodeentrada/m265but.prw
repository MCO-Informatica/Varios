#Include "Totvs.ch"
#Include "TopConn.ch"

User Function M265BUT()

	Local aRet := {}
	Local cSql := ""
	aAdd(aRet, {"SDUSETDEL_MDI", {|| U_ESTTR01()}, "Redistribuição de estoque", "Redistribuição de estoque"})
	
	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "M265BUT" , __cUserID )

	cSql := "SELECT "
	cSql += "  ZI_DOCD3, ZI_SEQD3 "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SZI") + " SZI "
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
	TcQuery cSql New Alias "TMP1"

	If !Empty(TMP1->ZI_SEQD3) .And. ProcName(2) == "A265EXCLUI"
		aAdd(aRet, {"SDUSETDEL_MDI", {|| U_EstPeso()}, "Estorno com Ajuste...", "Est. Ajuste"})
	EndIf
	TMP1->(DbCloseArea())

Return aClone(aRet)
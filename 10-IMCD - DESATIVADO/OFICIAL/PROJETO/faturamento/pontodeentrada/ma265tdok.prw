#Include "Totvs.ch"
#Include "TopConn.ch"

User Function MA265TDOK()
	Local cSql    := ""
	Local cTitulo := "Integração balança/estoque (MA265TDOK)"
	Local lRet    := .F.

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MA265TDOK" , __cUserID )

	If GetApoInfo("MATA265.PRX")[4] >= CtoD("04/01/11")
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
		TcQuery cSql New Alias "TMPZI"

		lRet := Empty(TMPZI->ZI_SEQD3) .Or. ProcName(3) == "U_ESTPESO"

		If ProcName(3) <> "U_ESTPESO" .And. !Empty(TMPZI->ZI_SEQD3)
			MsgAlert("Para confirmar o estorno deste endereçamento utilize a opção Est. Ajuste. A mesma opção executará o OK.", cTitulo)
		EndIf
		TMPZI->(DbCloseArea())
	Else
		MsgAlert("Para utilizar o PE MA265TDOK, é necessário o fonte MATA265.PRW com data 04/01/11 ou superior.", cTitulo)
	EndIf

Return lRet
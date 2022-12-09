#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MS520VLD ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 17/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada executado antes do estorna da NF de saida ³±±
±±³          ³ Valida se o documento pode ser estornado ou não            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Remessa por conta e ordem                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ GAP  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fabricio    ³17/03/11³ 167  ³ Implementação                            ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MS520VLD()
	Local cSql    := ""
	Local cAlias  := ""
	Local cTitulo := "Remessa conta e ordem (MS520VLD)"
	Local lRet    := .F.	

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MS520VLD" , __cUserID )

	cAlias := GetNextAlias()
	// Verifica se é uma nota de remessa por conta e ordem
	cSql := "SELECT F2_DOC, F2_SERIE "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SD2") + " SD2 JOIN " + RetSqlName("SF4") + " SF4 ON "
	cSql += "    SD2.D2_FILIAL  = '" + xFilial("SD2") + "'  AND "
	cSql += "    SF4.F4_FILIAL  = '" + xFilial("SF4") + "'  AND "
	cSql += "    SD2.D_E_L_E_T_ = ' ' AND "
	cSql += "    SF4.D_E_L_E_T_ = ' ' AND "
	cSql += "    SD2.D2_TES     = SF4.F4_TESCO "
	cSql += "  JOIN " + RetSqlName("SF2") + " SF2 ON "
	cSql += "    SF2.F2_FILIAL  = '" + xFilial("SF2") + "'  AND "
	cSql += "    SF2.F2_NFCO    = SD2.D2_DOC   AND "
	cSql += "    SF2.F2_SERIECO = SD2.D2_SERIE  "
	cSql += "WHERE "
	cSql += "  SD2.D2_DOC  = '" + SF2->F2_DOC   + "' "
	cSql += "  AND SD2.D2_SERIE = '" + SF2->F2_SERIE + "'"
	TcQuery cSql New Alias (cAlias)

	lRet := (cAlias)->(Eof()) .And. (cAlias)->(Bof())
	If !lRet
		MsgAlert("NF " + SF2->F2_DOC + "-" + AllTrim(SF2->F2_SERIE) + " é uma remessa por conta e ordem. Estorne o documento " + (cAlias)->F2_DOC + "-" + AllTrim((cAlias)->F2_SERIE) + " e este será estornado automaticamente.", cTitulo)
	EndIf	
	(cAlias)->(DbCloseArea())

Return lRet
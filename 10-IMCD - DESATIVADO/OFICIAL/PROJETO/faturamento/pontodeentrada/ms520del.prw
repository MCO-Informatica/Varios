#include "PROTHEUS.CH"
#include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MS520DEL ³ Autor ³ Fabricio E. da Costa  ³ Data ³ 17/03/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada executado antes da exclusão da NF de saída³±±
±±³          ³ dentro da transação                                        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Remessa por conta e ordem                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ GAP  ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Fabricio    ³17/03/11³ 167  ³ Operação triangular                      ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MS520DEL()
	Local aAreaSF2 := SF2->(GetArea())
	Local aRegSD2  := {}
	Local aRegSE1  := {}
	Local aRegSE2  := {}
	Local cAlias   := ""
	Local cSql     := ""
	Local cTitulo  := "Remessa conta e ordem (SF2520E)"

	//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "MS520DEL" , __cUserID )

	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.

	cAlias := GetNextAlias()
	cSql := "SELECT "
	cSql += "  SF2.R_E_C_N_O_ RECNOF2, SC5.C5_NUM "
	cSql += "FROM "
	cSql += "  " + RetSqlName("SF2") + " SF2 JOIN " + RetSqlName("SC5") + " SC5 ON "
	cSql += "    SF2.F2_FILIAL  = '" + xFilial("SF2") + "'  AND "
	cSql += "    SF2.D_E_L_E_T_ = ' ' AND "
	cSql += "    SC5.C5_FILIAL  = '" + xFilial("SC5") + "'  AND "
	cSql += "    SC5.D_E_L_E_T_ = ' ' AND "
	cSql += "    SF2.F2_DOC     = SC5.C5_NOTA  AND "
	cSql += "    SF2.F2_SERIE   = SC5.C5_SERIE "
	cSql += "WHERE "
	cSql += "  SF2.F2_DOC = '" + SF2->F2_NFCO + "' "
	cSql += "  AND SF2.F2_SERIE = '" + SF2->F2_SERIECO + "' "
	TcQuery cSql New Alias (cAlias)

	If !(cAlias)->(Eof()) .And. !(cAlias)->(Bof())
		If MaCanDelF2("SF2", (cAlias)->RECNOF2, @aRegSD2, @aRegSE1, @aRegSE2)
			SF2->(DbSeek(xFilial("SF2") + SF2->F2_NFCO + SF2->F2_SERIECO))
			SF2->(MaDelNFS(aRegSD2, aRegSE1, aRegSE2, .F., .F., .F., .T.))
			SF2->(MsUnlockAll())
			SF2->(RestArea(aAreaSF2))

			aRegSD2 := {}
			aRegSE1 := {}
			aRegSE2 := {}

			cSql := "UPDATE " + RetSqlName("SC5") + " "
			cSql += "SET 
			cSql += "  C5_X_CANC = 'C', C5_X_MOTCA = '000008' "
			cSql += "WHERE "
			cSql += "  C5_FILIAL = '" + xFilial("SC5") + "' AND C5_NUM = '" + (cAlias)->C5_NUM + "'"
			If TcSqlExec(cSql) < 0
				HS_MsgInf("Houve um problema no cancelamento do pedido de remessa por conta e ordem, número " + (cAlias)->C5_NUM + Chr(10) + Chr(13) + TcSqlError(), "Atenção!!!", cTitulo)
				DisarmTransaction()
				Final()
			EndIf
		Else
			MsgAlert("A nota de remessa por conta e ordem não pode ser excluida.", cTitulo)
		EndIf		
	EndIf
	(cAlias)->(DbCloseArea())

Return Nil